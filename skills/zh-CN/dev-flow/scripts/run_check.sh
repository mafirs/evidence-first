#!/usr/bin/env bash
# 运行一条检查命令，把命令、原始输出和退出码追加到 <运行目录>/checks.log。
# 用法：run_check.sh <运行目录> -- <命令> [参数...]
# 退出码与被运行命令一致。
set -u

if [ $# -lt 3 ] || [ "$2" != "--" ]; then
  echo "用法：run_check.sh <运行目录> -- <命令> [参数...]" >&2
  exit 2
fi

run_dir=$1
shift 2

if [ ! -d "$run_dir" ]; then
  echo "运行目录不存在：$run_dir" >&2
  exit 2
fi

log="$run_dir/checks.log"
{
  echo "===== $(date '+%Y-%m-%d %H:%M:%S') | cwd: $(pwd)"
  printf '$'
  printf ' %q' "$@"
  echo
} >> "$log"

# 输出同时写到终端和日志；用 PIPESTATUS 取被运行命令自己的退出码
"$@" 2>&1 | tee -a "$log"
code=${PIPESTATUS[0]}

echo "exit=$code" >> "$log"
echo >> "$log"
exit "$code"
