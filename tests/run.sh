#!/usr/bin/env bash
# Runs the dev-flow scripts against throwaway git repos with fake reviewers.
# Usage: tests/run.sh [zh-CN|en ...]   (default: every language under skills/)
# Checks exit codes and produced files only, so both language versions share the same cases.
set -u

repo_dir=$(cd "$(dirname "$0")/.." && pwd)
langs=("$@")
[ ${#langs[@]} -gt 0 ] || langs=($(ls "$repo_dir/skills"))

work=$(mktemp -d "${TMPDIR:-/tmp}/dev-flow-test.XXXXXX")
trap 'rm -rf "$work"' EXIT

# Fake reviewers. Behaviour per reviewer comes from FAKE_<NAME> (ok | fail | empty | template | modify | note).
# "note" passes and copies the message it received to $FAKE_DUMP.
fake_bin="$work/bin"
mkdir -p "$fake_bin"
cat > "$fake_bin/fake-reviewer" <<'EOF'
#!/usr/bin/env bash
name=$(basename "$0")
out=""
args=("$@")
msg=${args[$((${#args[@]} - 1))]}
if [ "$name" = codex ]; then
  for ((i = 0; i < ${#args[@]}; i++)); do
    [ "${args[$i]}" = "-o" ] && out=${args[$((i + 1))]}
  done
fi
var="FAKE_$(echo "$name" | tr '[:lower:]' '[:upper:]')"
mode=${!var:-ok}
emit() { if [ -n "$out" ]; then printf '%s\n' "$1" > "$out"; else printf '%s\n' "$1"; fi; }
case "$mode" in
  ok) emit "Problems: none
Verdict: PASS" ;;
  note) printf '%s' "$msg" > "$FAKE_DUMP"; emit "Verdict: PASS" ;;
  fail) exit 1 ;;
  empty) : ;;
  template) emit "结论：通过 / 不通过" ;;
  modify) echo changed >> "$FAKE_TOUCH"; emit "Verdict: PASS" ;;
esac
EOF
chmod +x "$fake_bin/fake-reviewer"
for n in codex claude dsh; do ln -s fake-reviewer "$fake_bin/$n"; done
# PATH without any real reviewer CLI
base_path="$fake_bin:/usr/bin:/bin:/usr/sbin:/sbin"
git_bin=$(command -v git)
case "$git_bin" in /usr/bin/git|/bin/git) ;; *) ln -s "$git_bin" "$fake_bin/git" ;; esac

total=0
failed=0
expect() { # expect <description> <expected exit> <actual exit>
  total=$((total + 1))
  if [ "$2" = "$3" ]; then
    echo "  ok    $1"
  else
    echo "  FAIL  $1 (expected exit $2, got $3)"
    failed=$((failed + 1))
  fi
}
expect_true() { # expect_true <description> <command...>
  local d=$1
  shift
  total=$((total + 1))
  if "$@"; then
    echo "  ok    $d"
  else
    echo "  FAIL  $d"
    failed=$((failed + 1))
  fi
}

new_repo() {
  local r="$work/repo-$1"
  rm -rf "$r"
  mkdir -p "$r"
  (cd "$r" && git init -q -b main && git config user.email t@example.com && git config user.name t &&
    printf 'def average(xs):\n    return sum(xs) / len(xs)\n' > stats.py && git add . && git commit -qm init)
  echo "$r"
}

for lang in "${langs[@]}"; do
  skill="$repo_dir/skills/$lang/dev-flow"
  [ -d "$skill" ] || { echo "no skill at $skill"; failed=$((failed + 1)); continue; }
  echo "== $lang"
  export PATH="$base_path"
  unset DEV_FLOW_REVIEWER DEV_FLOW_REVIEWERS FAKE_CODEX FAKE_CLAUDE FAKE_DSH

  # check_scope.sh
  repo=$(new_repo "$lang-scope")
  run="$work/run-$lang-scope"
  mkdir -p "$run"
  cd "$repo" || exit 1
  echo keep > old-untracked.txt
  bash "$skill/scripts/check_scope.sh" --init "$run" > /dev/null
  expect "init writes base = HEAD" 0 "$( [ "$(cat "$run/base")" = "$(git rev-parse HEAD)" ]; echo $?)"
  expect_true "init writes branch" grep -qx main "$run/branch"
  echo stats.py > "$run/scope.txt"
  echo "x = 1" >> stats.py
  bash "$skill/scripts/check_scope.sh" "$run" > /dev/null
  expect "change inside scope" 0 $?
  echo new > other.py
  bash "$skill/scripts/check_scope.sh" "$run" > /dev/null
  expect "new untracked file outside scope" 1 $?
  rm other.py
  echo edited >> old-untracked.txt
  bash "$skill/scripts/check_scope.sh" "$run" > /dev/null
  expect "edited pre-existing untracked file counts" 1 $?
  bash "$skill/scripts/check_scope.sh" --init "$run" a b > /dev/null 2>&1
  expect "init with too many arguments" 2 $?
  git checkout -q -- stats.py
  git switch -qc feature
  echo "y = 2" >> stats.py && git commit -qam feature
  git switch -q main && echo z > z.txt && git add z.txt && git commit -qm "main moves" && git switch -q feature
  run2="$work/run-$lang-scope2"
  mkdir -p "$run2"
  bash "$skill/scripts/check_scope.sh" --init "$run2" main > /dev/null
  expect "init with start ref writes merge-base" 0 "$( [ "$(cat "$run2/base")" = "$(git merge-base main HEAD)" ]; echo $?)"
  bash "$skill/scripts/check_scope.sh" --init "$run2" no-such-ref > /dev/null 2>&1
  expect "init with unknown start ref" 2 $?

  # review.sh plan
  repo=$(new_repo "$lang-plan")
  run="$work/run-$lang-plan"
  mkdir -p "$run"
  cd "$repo" || exit 1
  echo requirement > "$run/requirement.md"
  echo plan > "$run/plan.md"
  bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "plan review without scope.txt" 2 $?
  echo stats.py > "$run/scope.txt"
  bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "plan review round 1 (no base needed)" 0 $?
  expect_true "round 1 used codex first" grep -q '^codex' "$run/review-plan-1.reviewer"
  bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "round 2 refused when plan unchanged" 2 $?
  echo "plan v2" > "$run/plan.md"
  FAKE_CODEX=fail bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "round 2 falls back from failing codex" 0 $?
  expect_true "round 2 used claude" grep -q '^claude' "$run/review-plan-2.reviewer"
  echo "plan v3" > "$run/plan.md"
  bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "round 3 hits the cap" 3 $?

  # reviewer selection
  run="$work/run-$lang-pick"
  mkdir -p "$run"
  cp "$work/run-$lang-plan/requirement.md" "$work/run-$lang-plan/scope.txt" "$run/"
  echo plan > "$run/plan.md"
  DEV_FLOW_REVIEWERS="nope" bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "unknown reviewer name" 2 $?
  FAKE_CODEX=template FAKE_CLAUDE=empty FAKE_DSH=fail bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "template verdict, empty output and failure all count as no reviewer" 5 $?
  rm -f "$run"/review-plan-1.*
  PATH="/usr/bin:/bin" DEV_FLOW_REVIEWERS="dsh" bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "reviewer not on PATH" 5 $?
  rm -f "$run"/review-plan-1.*
  DEV_FLOW_REVIEWERS="dsh" bash "$skill/scripts/review.sh" plan "$run" > /dev/null 2>&1
  expect "DEV_FLOW_REVIEWERS picks dsh" 0 $?
  expect_true "dsh recorded" grep -q '^dsh' "$run/review-plan-1.reviewer"

  # review.sh code
  repo=$(new_repo "$lang-code")
  run="$work/run-$lang-code"
  mkdir -p "$run"
  cd "$repo" || exit 1
  bash "$skill/scripts/check_scope.sh" --init "$run" > /dev/null
  echo requirement > "$run/requirement.md"
  echo "x = 1" >> stats.py
  bash "$skill/scripts/review.sh" code "$run" > /dev/null 2>&1
  expect "code review refuses uncommitted changes" 2 $?
  git commit -qam change
  echo "focus on division by zero" > "$run/review-note.md"
  FAKE_CODEX=note FAKE_DUMP="$work/dump-$lang" bash "$skill/scripts/review.sh" code "$run" > /dev/null 2>&1
  expect "code review without plan/scope/checks" 0 $?
  expect_true "message lists missing plan.md" grep -q 'plan.md' "$work/dump-$lang"
  expect_true "message carries review-note.md" grep -q 'focus on division by zero' "$work/dump-$lang"
  expect_true "diff file written" test -s "$run/diff-code-1.patch"
  echo "y = 2" >> stats.py && git commit -qam change2
  FAKE_CODEX=modify FAKE_TOUCH="$repo/stats.py" bash "$skill/scripts/review.sh" code "$run" > /dev/null 2>&1
  expect "reviewer that edits tracked files voids the round" 4 $?
  git checkout -q -- stats.py

  # run_check.sh
  bash "$skill/scripts/run_check.sh" "$run" -- sh -c 'exit 7' > /dev/null
  expect "run_check passes through the exit code" 7 $?
  expect_true "run_check logs exit code" grep -q '^exit=7$' "$run/checks.log"
done

echo
echo "$((total - failed))/$total passed"
[ $failed -eq 0 ]
