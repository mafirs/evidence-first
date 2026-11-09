#!/usr/bin/env bash
# 把评审 Prompt 原样交给独立评审方，评审原文写入运行目录。每轮都是新开的评审进程，上下文只来自运行目录里的文件。
# 用法：review.sh <plan|code> <运行目录>   （在代码仓库内运行）
# 必需材料：plan 要 requirement.md、plan.md、scope.txt；code 要 requirement.md、base。code 缺 plan.md、scope.txt、checks.log 时照常评审，
# 消息里列出缺的材料。运行目录里有 review-note.md（用户对评审方的追加要求）时原样附在消息末尾。
# 评审方：
#   - 设了环境变量 DEV_FLOW_REVIEWER 时只用它，失败不换别的。只接受不带引号的简单命令（按空格拆分），评审消息作为最后一个参数传入；
#   - 否则按 DEV_FLOW_REVIEWERS 列出的顺序（默认 "codex claude dsh"）逐个尝试，跳过不在 PATH 里的；
#     退出码非 0、输出为空或没有有效结论行时换下一个。
#     codex = codex exec -s read-only；claude = claude -p --permission-mode plan；dsh = dsh --profile ${DEV_FLOW_DSH_PROFILE:-headless}
# 有效结论行：单独一行的"结论：通过/不通过"或"Verdict: PASS/FAIL"（允许 Markdown 加粗，允许后面跟一个括号说明），取最后一个。
# 轮数上限：plan 2 轮（第 2 轮是定向复审，只在采纳了 [核心] 并改了方案时跑，由主 agent 按 SKILL.md 判断），code 2 轮。
# 退出码：0 完成；2 用法或输入错误；3 已达轮数上限；4 评审方改动了已跟踪文件或运行目录；5 没有可用的评审方。
set -u

if [ $# -ne 2 ] || { [ "$1" != "plan" ] && [ "$1" != "code" ]; }; then
  echo "用法：review.sh <plan|code> <运行目录>" >&2
  exit 2
fi

kind=$1
run_dir=$(cd "$2" 2>/dev/null && pwd) || { echo "运行目录不存在：$2" >&2; exit 2; }
skill_dir=$(cd "$(dirname "$0")/.." && pwd)
prompt_file="$skill_dir/prompts/$kind-review.md"

top=$(git rev-parse --show-toplevel) || exit 2
cd "$top" || exit 2

# 必需材料：plan 要需求单、方案、改动地图；code 要需求单和起点。其余材料缺了就告诉评审方跳过对应评审项
if [ "$kind" = "plan" ]; then
  required="requirement.md plan.md scope.txt"
  optional=""
else
  required="requirement.md base"
  optional="plan.md scope.txt checks.log"
fi
for f in $required; do
  if [ ! -f "$run_dir/$f" ]; then
    echo "缺少文件：$run_dir/$f" >&2
    exit 2
  fi
done
missing=""
for f in $optional; do
  [ -f "$run_dir/$f" ] || missing="$missing $f"
done

max=2

if [ -z "${DEV_FLOW_REVIEWER:-}" ]; then
  for name in ${DEV_FLOW_REVIEWERS:-codex claude dsh}; do
    case "$name" in
      codex|claude|dsh) ;;
      *) echo "DEV_FLOW_REVIEWERS 里有不认识的评审方：$name（只支持 codex、claude、dsh；其他命令用 DEV_FLOW_REVIEWER）" >&2; exit 2 ;;
    esac
  done
fi

# 只数成功完成的轮次（review-<kind>-<n>.md）
n=1
while [ -f "$run_dir/review-$kind-$n.md" ]; do n=$((n + 1)); done
if [ $n -gt $max ]; then
  echo "$kind 评审已达上限 $max 轮，剩余问题写进最终汇报" >&2
  exit 3
fi

start_list="$run_dir/untracked-at-start"
[ -f "$start_list" ] || start_list=/dev/null
start_paths=$(cut -c43- "$start_list" | sort)

if [ "$kind" = "plan" ]; then label="方案评审"; else label="代码评审"; fi
info="## 本轮信息

运行目录：$run_dir
本轮：$label 第 $n 轮
已结案清单：$run_dir/closed.md（不存在说明还没有已处理的意见）"

if [ "$kind" = "plan" ]; then
  # 保存本轮方案快照，供下一轮定向复审对比
  cp "$run_dir/plan.md" "$run_dir/plan-review-$n.snapshot.md"
  if [ $n -gt 1 ]; then
    if cmp -s "$run_dir/plan.md" "$run_dir/plan-review-$((n - 1)).snapshot.md"; then
      echo "方案和上一轮评审时相同，没有可复审的改动" >&2
      rm -f "$run_dir/plan-review-$n.snapshot.md"
      exit 2
    fi
    info="$info
上一轮评审原文：$run_dir/review-plan-$((n - 1)).md
上一轮时的方案快照：$run_dir/plan-review-$((n - 1)).snapshot.md
当前方案：$run_dir/plan.md"
  fi
fi

if [ "$kind" = "code" ]; then
  if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
    echo "已跟踪文件有未提交改动：评审前先把改动 commit 到功能分支" >&2
    git status --short --untracked-files=no >&2
    exit 2
  fi
  new_untracked=$(git ls-files --others --exclude-standard | sort | comm -23 - <(echo "$start_paths"))
  if [ -n "$new_untracked" ]; then
    echo "有开工后新出现的未跟踪文件，评审前先 commit 或删除：" >&2
    echo "$new_untracked" >&2
    exit 2
  fi
  base=$(tr -d '[:space:]' < "$run_dir/base")
  if [ $n -eq 1 ]; then
    from=$base
  else
    from=$(tr -d '[:space:]' < "$run_dir/review-code-$((n - 1)).head")
  fi
  diff_file="$run_dir/diff-code-$n.patch"
  git diff "$from" HEAD > "$diff_file" || exit 2
  if [ ! -s "$diff_file" ]; then
    echo "本轮 diff 为空（$from..HEAD）" >&2
    exit 2
  fi
  info="$info
本轮 diff：$diff_file（$from..HEAD）
完整 diff：git diff $base HEAD
开工前已存在的未跟踪文件：$run_dir/untracked-at-start（不属于本次改动）"
  if [ $n -gt 1 ]; then
    info="$info
上一轮评审原文：$run_dir/review-code-$((n - 1)).md"
  fi
fi

if [ -n "$missing" ]; then
  info="$info
本轮缺少的材料：$missing（跳过依赖它们的评审项，并在核对范围里写明没查什么）"
fi

if [ -s "$run_dir/review-note.md" ]; then
  info="$info

## 用户追加要求（用户原话）

$(cat "$run_dir/review-note.md")"
fi

# 轮次放在最前面，评审方先看到本轮该按哪套要求评审
msg="本轮：$label 第 $n 轮（运行目录：$run_dir）

$(cat "$prompt_file")

$info"

out_tmp="$run_dir/review-$kind-$n.tmp"
err_log="$run_dir/review-$kind-$n.stderr.log"

# 评审前后对比：已跟踪文件状态，以及运行目录里除本轮产物外的全部文件
snapshot() {
  {
    git rev-parse HEAD
    git status --porcelain --untracked-files=no
    git diff HEAD | shasum
    find "$run_dir" -type f ! -name "review-$kind-$n.*" | sort | while IFS= read -r f; do shasum "$f"; done
  } 2>/dev/null
}
untracked_now() { git ls-files --others --exclude-standard | sort; }
before=$(snapshot)
untracked_before=$(untracked_now)

: > "$err_log"
used=""
verdict=""

# 取最后一个有效结论行里的"通过"或"不通过"（括号说明里的字不算）
read_verdict() {
  local v
  v=$(grep -E '^[[:space:]>*#-]*(结论|[Vv]erdict)(:|：)[[:space:]*]*(通过|不通过|PASS|FAIL)[[:space:]*]*(（.*）|\(.*\))?[[:space:]*]*(。|\.)?[[:space:]*]*$' "$out_tmp" | tail -1 | grep -oE '不通过|通过|PASS|FAIL' | head -1)
  case "$v" in
    PASS) v=通过 ;;
    FAIL) v=不通过 ;;
  esac
  echo "$v"
}

# 运行一个评审方：退出码 0、输出非空且有有效结论行才算成功
try_reviewer() {
  local name=$1
  shift
  : > "$out_tmp"
  echo "评审中：$name（$label 第 $n 轮）" >&2
  echo "===== $name" >> "$err_log"
  "$@"
  local code=$?
  if [ $code -ne 0 ]; then
    echo "$name 失败，退出码 $code" | tee -a "$err_log" >&2
    return 1
  fi
  if [ ! -s "$out_tmp" ]; then
    echo "$name 输出为空" | tee -a "$err_log" >&2
    return 1
  fi
  verdict=$(read_verdict)
  if [ -z "$verdict" ]; then
    cp "$out_tmp" "$run_dir/review-$kind-$n.failed.md"
    echo "$name 输出没有有效结论行（原文存于 review-$kind-$n.failed.md）" | tee -a "$err_log" >&2
    return 1
  fi
  used=$name
  return 0
}

dsh_profile=${DEV_FLOW_DSH_PROFILE:-headless}
run_custom() { "${reviewer[@]}" "$msg" > "$out_tmp" 2>> "$err_log"; }
run_codex() { codex exec -s read-only -C "$top" --color never -o "$out_tmp" "$msg" >> "$err_log" 2>&1; }
run_claude() { claude -p --permission-mode plan "$msg" > "$out_tmp" 2>> "$err_log"; }
run_dsh() { dsh --profile "$dsh_profile" "$msg" > "$out_tmp" 2>> "$err_log"; }

if [ -n "${DEV_FLOW_REVIEWER:-}" ]; then
  read -r -a reviewer <<< "$DEV_FLOW_REVIEWER"
  try_reviewer "$DEV_FLOW_REVIEWER" run_custom
else
  for name in ${DEV_FLOW_REVIEWERS:-codex claude dsh}; do
    if ! command -v "$name" > /dev/null; then
      echo "$name 不在 PATH，跳过" | tee -a "$err_log" >&2
      continue
    fi
    case "$name" in
      codex) try_reviewer "codex exec" run_codex && break ;;
      claude) try_reviewer "claude -p" run_claude && break ;;
      dsh) try_reviewer "dsh --profile $dsh_profile" run_dsh && break ;;
    esac
    echo "换下一个评审方" >&2
  done
fi

after=$(snapshot)
if [ "$before" != "$after" ]; then
  [ -s "$out_tmp" ] && mv "$out_tmp" "$run_dir/review-$kind-$n.failed.md"
  rm -f "$out_tmp"
  echo "评审方改动了已跟踪文件或运行目录，本轮作废。评审前后状态差异：" >&2
  diff <(echo "$before") <(echo "$after") >&2
  exit 4
fi

# 评审方跑测试常会留下未跟踪的产物：不作废本轮，列出来由主 agent 删除
leftover=$(comm -13 <(echo "$untracked_before") <(untracked_now))
if [ -n "$leftover" ]; then
  echo "注意：评审期间出现了新的未跟踪文件（多半是评审方跑测试的产物），确认后删除：" >&2
  echo "$leftover" >&2
fi

if [ -z "$used" ]; then
  rm -f "$out_tmp"
  echo "没有可用的评审方，本轮不计数；日志：$err_log" >&2
  tail -20 "$err_log" >&2
  exit 5
fi

mv "$out_tmp" "$run_dir/review-$kind-$n.md"
echo "$used" > "$run_dir/review-$kind-$n.reviewer"
[ "$kind" = "code" ] && git rev-parse HEAD > "$run_dir/review-code-$n.head"
echo "评审方：$used；结论：$verdict" >&2
cat "$run_dir/review-$kind-$n.md"
