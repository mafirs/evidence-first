#!/usr/bin/env bash
# Checks that every change from the starting commit to the current working tree falls within the scope declared in scope.txt.
# Usage:
#   check_scope.sh --init <run dir> [start]   run once at setup: writes base, branch (current branch name) and untracked-at-start (sha1 and path of existing untracked files).
#                                        Without a start, base is the current HEAD; with a start (commit or branch), base is the fork point of start and HEAD (used when reviewing existing changes)
#   check_scope.sh <run dir>                  check the change scope
# Both must be run inside the code repository.
# Reads: <run dir>/base, <run dir>/scope.txt (one path per line, * allowed and matches across directories; lines starting with # are comments),
#        <run dir>/untracked-at-start (untracked files that existed at setup; unchanged ones are not part of this change, edited or deleted ones are)
# Files ignored by .gitignore are not checked (they never enter a commit).
# Exit codes: 0 everything in scope; 1 changes out of scope; 2 usage or input error.
set -u

usage() { echo "Usage: check_scope.sh --init <run dir> [start] | check_scope.sh <run dir>" >&2; exit 2; }

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

run_dir=$(cd "$1" 2>/dev/null && pwd) || { echo "Run directory not found: $1" >&2; exit 2; }
top=$(git rev-parse --show-toplevel) || exit 2
cd "$top" || exit 2

start_list="$run_dir/untracked-at-start"

if [ $init -eq 1 ]; then
  if [ -n "$start_ref" ]; then
    base=$(git merge-base "$start_ref" HEAD) || { echo "Cannot find the fork point of $start_ref and HEAD" >&2; exit 2; }
  else
    base=$(git rev-parse HEAD) || exit 2
  fi
  echo "$base" > "$run_dir/base"
  git branch --show-current > "$run_dir/branch"
  : > "$start_list"
  while IFS= read -r -d '' f; do
    shasum "$f" >> "$start_list"
  done < <(git ls-files --others --exclude-standard -z)
  echo "Wrote $run_dir/base ($(cat "$run_dir/base")) and untracked-at-start ($(wc -l < "$start_list" | tr -d ' ') existing untracked files)"
  exit 0
fi

base_file="$run_dir/base"
scope_file="$run_dir/scope.txt"
for f in "$base_file" "$scope_file"; do
  if [ ! -f "$f" ]; then
    echo "Missing file: $f" >&2
    exit 2
  fi
done

base=$(tr -d '[:space:]' < "$base_file")
if ! git rev-parse --verify --quiet "$base^{commit}" > /dev/null; then
  echo "Invalid starting commit: $base" >&2
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
  echo "scope.txt contains no paths" >&2
  exit 2
fi

# Untracked files that existed at setup: 40 characters of sha1, two spaces, then the path
[ -f "$start_list" ] || start_list=/dev/null
start_paths=$(cut -c43- "$start_list" | sort)

# Untracked files that appeared after setup
new_untracked=$(git ls-files --others --exclude-standard | sort | comm -23 - <(echo "$start_paths"))

# Untracked files that existed at setup and were edited or deleted since
touched_start=""
while IFS= read -r line; do
  [ -n "$line" ] || continue
  sum=${line:0:40}
  path=${line:42}
  if [ ! -e "$path" ] || [ "$(shasum "$path" | cut -c1-40)" != "$sum" ]; then
    touched_start="$touched_start$path"$'\n'
  fi
done < "$start_list"

# Committed + uncommitted tracked changes (--no-renames lists both the old and new path of a rename)
changed=$( { git diff --name-only --no-renames "$base"; [ -n "$new_untracked" ] && echo "$new_untracked"; printf '%s' "$touched_start"; } | sed '/^$/d' | sort -u )

if [ -z "$changed" ]; then
  echo "No changes"
  exit 0
fi

out_count=0
while IFS= read -r f; do
  hit=0
  for p in "${patterns[@]}"; do
    # The unquoted right-hand side matches as a glob
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
  echo "Out of scope: $out_count file(s)"
  exit 1
fi
echo "All changes are in scope"
exit 0
