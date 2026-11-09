#!/usr/bin/env bash
# 检查从起点 commit 到当前工作区的所有改动，是否都落在 scope.txt 声明的范围内。
# 用法：
#   check_scope.sh --init <运行目录> [起点]   开工时运行一次：写入 base、branch（当前分支名）和 untracked-at-start（已有未跟踪文件的 sha1 与路径）。
#                                        不给起点时 base 是当前 HEAD；给了起点（commit 或分支）时 base 是起点和 HEAD 的分叉点（评审已有改动时用）
#   check_scope.sh <运行目录>          检查改动范围
# 都要在代码仓库内运行。
# 读取：<运行目录>/base、<运行目录>/scope.txt（一行一个路径，可用 *，* 跨目录匹配；# 开头为注释）、
#       <运行目录>/untracked-at-start（开工时已存在的未跟踪文件；内容没变的不算本次改动，被改或被删的算）
# 不检查被 .gitignore 忽略的文件（它们不会进入 commit）。
# 退出码：0 全部在范围内；1 有范围外改动；2 用法或输入错误。
set -u

usage() { echo "用法：check_scope.sh --init <运行目录> [起点] | check_scope.sh <运行目录>" >&2; exit 2; }

init=0
start_ref=""
if [ $# -ge 2 ] && [ "$1" = "--init" ]; then
  init=1
  shift
  [ $# -le 2 ] || usage
  start_ref=${2:-}
  set -- "$1"
fi
[ $# -eq 1 ] || usage

run_dir=$(cd "$1" 2>/dev/null && pwd) || { echo "运行目录不存在：$1" >&2; exit 2; }
top=$(git rev-parse --show-toplevel) || exit 2
cd "$top" || exit 2

start_list="$run_dir/untracked-at-start"

if [ $init -eq 1 ]; then
  if [ -n "$start_ref" ]; then
    base=$(git merge-base "$start_ref" HEAD) || { echo "找不到 $start_ref 和 HEAD 的分叉点" >&2; exit 2; }
  else
    base=$(git rev-parse HEAD) || exit 2
  fi
  echo "$base" > "$run_dir/base"
  git branch --show-current > "$run_dir/branch"
  : > "$start_list"
  while IFS= read -r -d '' f; do
    shasum "$f" >> "$start_list"
  done < <(git ls-files --others --exclude-standard -z)
  echo "已写入 $run_dir/base（$(cat "$run_dir/base")）和 untracked-at-start（$(wc -l < "$start_list" | tr -d ' ') 个已有未跟踪文件）"
  exit 0
fi

base_file="$run_dir/base"
scope_file="$run_dir/scope.txt"
for f in "$base_file" "$scope_file"; do
  if [ ! -f "$f" ]; then
    echo "缺少文件：$f" >&2
    exit 2
  fi
done

base=$(tr -d '[:space:]' < "$base_file")
if ! git rev-parse --verify --quiet "$base^{commit}" > /dev/null; then
  echo "起点 commit 无效：$base" >&2
  exit 2
fi

patterns=()
while IFS= read -r line || [ -n "$line" ]; do
  line=$(printf '%s' "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')
  case "$line" in
    ''|'#'*) continue ;;
  esac
  patterns+=("$line")
done < "$scope_file"

if [ ${#patterns[@]} -eq 0 ]; then
  echo "scope.txt 里没有任何路径" >&2
  exit 2
fi

# 开工时已有的未跟踪文件：sha1 占前 40 个字符，后面两个空格，再是路径
[ -f "$start_list" ] || start_list=/dev/null
start_paths=$(cut -c43- "$start_list" | sort)

# 开工后新出现的未跟踪文件
new_untracked=$(git ls-files --others --exclude-standard | sort | comm -23 - <(echo "$start_paths"))

# 开工时已有、之后被改或被删的未跟踪文件
touched_start=""
while IFS= read -r line; do
  [ -n "$line" ] || continue
  sum=${line:0:40}
  path=${line:42}
  if [ ! -e "$path" ] || [ "$(shasum "$path" | cut -c1-40)" != "$sum" ]; then
    touched_start="$touched_start$path"$'\n'
  fi
done < "$start_list"

# 已提交 + 未提交的已跟踪改动（--no-renames 让改名的旧路径和新路径都出现）
changed=$( { git diff --name-only --no-renames "$base"; [ -n "$new_untracked" ] && echo "$new_untracked"; printf '%s' "$touched_start"; } | sed '/^$/d' | sort -u )

if [ -z "$changed" ]; then
  echo "没有改动"
  exit 0
fi

out_count=0
while IFS= read -r f; do
  hit=0
  for p in "${patterns[@]}"; do
    # 不加引号的右侧按 glob 匹配
    if [[ "$f" == $p ]]; then
      hit=1
      break
    fi
  done
  if [ $hit -eq 1 ]; then
    echo "IN   $f"
  else
    echo "OUT  $f"
    out_count=$((out_count + 1))
  fi
done <<< "$changed"

if [ $out_count -gt 0 ]; then
  echo "范围外改动：$out_count 个文件"
  exit 1
fi
echo "全部改动在范围内"
exit 0
