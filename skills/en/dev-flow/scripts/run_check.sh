#!/usr/bin/env bash
# Runs one check command and appends the command, its raw output and exit code to <run dir>/checks.log.
# Usage: run_check.sh <run dir> -- <command> [args...]
# Exits with the same code as the command it ran.
set -u

if [ $# -lt 3 ] || [ "$2" != "--" ]; then
  echo "Usage: run_check.sh <run dir> -- <command> [args...]" >&2
  exit 2
fi

run_dir=$1
shift 2

if [ ! -d "$run_dir" ]; then
  echo "Run directory not found: $run_dir" >&2
  exit 2
fi

log="$run_dir/checks.log"
{
  echo "===== $(date '+%Y-%m-%d %H:%M:%S') | cwd: $(pwd)"
  printf '$'
  printf ' %q' "$@"
  echo
} >> "$log"

# Output goes to both the terminal and the log; PIPESTATUS gives the command's own exit code
"$@" 2>&1 | tee -a "$log"
code=${PIPESTATUS[0]}

echo "exit=$code" >> "$log"
echo >> "$log"
exit "$code"
