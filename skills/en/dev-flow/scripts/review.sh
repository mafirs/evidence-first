#!/usr/bin/env bash
# Hands the review prompt verbatim to an independent reviewer and writes the review into the run directory. Every round is a new reviewer process; its context comes only from files in the run directory.
# Usage: review.sh <plan|code> <run dir>   (run inside the code repository)
# Required materials: plan needs requirement.md, plan.md, scope.txt; code needs requirement.md, base. Code review still runs without plan.md, scope.txt, checks.log;
# the message lists what is missing. When the run directory has review-note.md (the user's extra instructions for the reviewer), it is appended verbatim.
# Reviewers:
#   - When DEV_FLOW_REVIEWER is set, only it is used, with no fallback. Only simple commands without quotes (split on spaces); the review message is passed as the last argument;
#   - otherwise try the names in DEV_FLOW_REVIEWERS in order (default "codex claude dsh"), skipping those not on PATH;
#     move to the next one on a non-zero exit code, empty output or no valid verdict line.
#     codex = codex exec -s read-only; claude = claude -p --permission-mode plan; dsh = dsh --profile ${DEV_FLOW_DSH_PROFILE:-headless}
# Valid verdict line: a line of its own reading "Verdict: PASS/FAIL" or "结论：通过/不通过" (Markdown bold allowed, an explanation in parentheses allowed after it); the last one counts.
# Round limits: plan 2 rounds (round 2 is the targeted re-review, run only when a [core] finding was adopted and the plan revised; the main agent decides per SKILL.md), code 2 rounds.
# Exit codes: 0 done; 2 usage or input error; 3 round limit reached; 4 the reviewer changed tracked files or the run directory; 5 no reviewer available.
set -u

if [ $# -ne 2 ] || { [ "$1" != "plan" ] && [ "$1" != "code" ]; }; then
  echo "Usage: review.sh <plan|code> <run dir>" >&2
  exit 2
fi

kind=$1
run_dir=$(cd "$2" 2>/dev/null && pwd) || { echo "Run directory not found: $2" >&2; exit 2; }
skill_dir=$(cd "$(dirname "$0")/.." && pwd)
prompt_file="$skill_dir/prompts/$kind-review.md"

top=$(git rev-parse --show-toplevel) || exit 2
cd "$top" || exit 2

# Required: plan needs the requirement doc, plan and change map; code needs the requirement doc and starting point. Other missing materials are reported to the reviewer, who skips the matching review items
if [ "$kind" = "plan" ]; then
  required="requirement.md plan.md scope.txt"
  optional=""
else
  required="requirement.md base"
  optional="plan.md scope.txt checks.log"
fi
for f in $required; do
  if [ ! -f "$run_dir/$f" ]; then
    echo "Missing file: $run_dir/$f" >&2
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
      *) echo "Unknown reviewer in DEV_FLOW_REVIEWERS: $name (only codex, claude, dsh are supported; use DEV_FLOW_REVIEWER for other commands)" >&2; exit 2 ;;
    esac
  done
fi

# Count only completed rounds (review-<kind>-<n>.md)
n=1
while [ -f "$run_dir/review-$kind-$n.md" ]; do n=$((n + 1)); done
if [ $n -gt $max ]; then
  echo "$kind review has reached its limit of $max rounds; put the remaining findings in the final report" >&2
  exit 3
fi

start_list="$run_dir/untracked-at-start"
[ -f "$start_list" ] || start_list=/dev/null
start_paths=$(cut -c43- "$start_list" | sort)

if [ "$kind" = "plan" ]; then label="plan review"; else label="code review"; fi
info="## This round

Run directory: $run_dir
This round: $label, round $n
Closed list: $run_dir/closed.md (if missing, no findings have been handled yet)"

if [ "$kind" = "plan" ]; then
  # Save this round's plan snapshot for the next targeted re-review to compare against
  cp "$run_dir/plan.md" "$run_dir/plan-review-$n.snapshot.md"
  if [ $n -gt 1 ]; then
    if cmp -s "$run_dir/plan.md" "$run_dir/plan-review-$((n - 1)).snapshot.md"; then
      echo "The plan is the same as at the previous review round; nothing to re-review" >&2
      rm -f "$run_dir/plan-review-$n.snapshot.md"
      exit 2
    fi
    info="$info
Previous round review: $run_dir/review-plan-$((n - 1)).md
Plan snapshot from the previous round: $run_dir/plan-review-$((n - 1)).snapshot.md
Current plan: $run_dir/plan.md"
  fi
fi

if [ "$kind" = "code" ]; then
  if [ -n "$(git status --porcelain --untracked-files=no)" ]; then
    echo "Tracked files have uncommitted changes: commit them to the feature branch before the review" >&2
    git status --short --untracked-files=no >&2
    exit 2
  fi
  new_untracked=$(git ls-files --others --exclude-standard | sort | comm -23 - <(echo "$start_paths"))
  if [ -n "$new_untracked" ]; then
    echo "New untracked files appeared since setup; commit or delete them before the review:" >&2
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
    echo "This round's diff is empty ($from..HEAD)" >&2
    exit 2
  fi
  info="$info
Diff for this round: $diff_file ($from..HEAD)
Full diff: git diff $base HEAD
Untracked files that existed before work began: $run_dir/untracked-at-start (not part of this change)"
  if [ $n -gt 1 ]; then
    info="$info
Previous round review: $run_dir/review-code-$((n - 1)).md"
  fi
fi

if [ -n "$missing" ]; then
  info="$info
Missing materials this round:$missing (skip the review items that depend on them, and state in the scope of checking what you didn't check)"
fi

if [ -s "$run_dir/review-note.md" ]; then
  info="$info

## User's extra instructions (verbatim)

$(cat "$run_dir/review-note.md")"
fi

# Put the round first so the reviewer sees which set of instructions applies
msg="This round: $label, round $n (run directory: $run_dir)

$(cat "$prompt_file")

$info"

out_tmp="$run_dir/review-$kind-$n.tmp"
err_log="$run_dir/review-$kind-$n.stderr.log"

# Compare before and after the review: tracked file state, plus every file in the run directory except this round's outputs
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

# Take PASS or FAIL from the last valid verdict line (words inside the parenthetical don't count)
read_verdict() {
  local v
  v=$(grep -E '^[[:space:]>*#-]*(结论|[Vv]erdict)(:|：)[[:space:]*]*(通过|不通过|PASS|FAIL)[[:space:]*]*(（.*）|\(.*\))?[[:space:]*]*(。|\.)?[[:space:]*]*$' "$out_tmp" | tail -1 | grep -oE '不通过|通过|PASS|FAIL' | head -1)
  case "$v" in
    通过) v=PASS ;;
    不通过) v=FAIL ;;
  esac
  echo "$v"
}

# Run one reviewer: success requires exit code 0, non-empty output and a valid verdict line
try_reviewer() {
  local name=$1
  shift
  : > "$out_tmp"
  echo "Reviewing: $name ($label, round $n)" >&2
  echo "===== $name" >> "$err_log"
  "$@"
  local code=$?
  if [ $code -ne 0 ]; then
    echo "$name failed with exit code $code" | tee -a "$err_log" >&2
    return 1
  fi
  if [ ! -s "$out_tmp" ]; then
    echo "$name produced empty output" | tee -a "$err_log" >&2
    return 1
  fi
  verdict=$(read_verdict)
  if [ -z "$verdict" ]; then
    cp "$out_tmp" "$run_dir/review-$kind-$n.failed.md"
    echo "$name output has no valid verdict line (saved as review-$kind-$n.failed.md)" | tee -a "$err_log" >&2
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
      echo "$name is not on PATH, skipping" | tee -a "$err_log" >&2
      continue
    fi
    case "$name" in
      codex) try_reviewer "codex exec" run_codex && break ;;
      claude) try_reviewer "claude -p" run_claude && break ;;
      dsh) try_reviewer "dsh --profile $dsh_profile" run_dsh && break ;;
    esac
    echo "Trying the next reviewer" >&2
  done
fi

after=$(snapshot)
if [ "$before" != "$after" ]; then
  [ -s "$out_tmp" ] && mv "$out_tmp" "$run_dir/review-$kind-$n.failed.md"
  rm -f "$out_tmp"
  echo "The reviewer changed tracked files or the run directory; this round is void. State before vs after the review:" >&2
  diff <(echo "$before") <(echo "$after") >&2
  exit 4
fi

# Reviewers running tests often leave untracked artifacts: the round stays valid, and they are listed for the main agent to delete
leftover=$(comm -13 <(echo "$untracked_before") <(untracked_now))
if [ -n "$leftover" ]; then
  echo "Note: new untracked files appeared during the review (most likely artifacts of the reviewer running tests); delete them after checking:" >&2
  echo "$leftover" >&2
fi

if [ -z "$used" ]; then
  rm -f "$out_tmp"
  echo "No reviewer available; this round does not count. Log: $err_log" >&2
  tail -20 "$err_log" >&2
  exit 5
fi

mv "$out_tmp" "$run_dir/review-$kind-$n.md"
echo "$used" > "$run_dir/review-$kind-$n.reviewer"
[ "$kind" = "code" ] && git rev-parse HEAD > "$run_dir/review-code-$n.head"
echo "Reviewer: $used; verdict: $verdict" >&2
cat "$run_dir/review-$kind-$n.md"
