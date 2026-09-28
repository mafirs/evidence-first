#!/usr/bin/env bash
# Link evidence-first skills into the Claude Code and Codex user skill directories.
# Usage: ./install.sh [zh-CN|en]   (default: zh-CN)
# Existing entries with the same name are never overwritten; they are reported and skipped.
set -euo pipefail

lang="${1:-zh-CN}"
repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
src_dir="$repo_dir/skills/$lang"

if [ ! -d "$src_dir" ]; then
  echo "Unknown language '$lang'. Available: $(ls "$repo_dir/skills" | tr '\n' ' ')" >&2
  exit 1
fi

# Claude Code reads ~/.claude/skills; Codex reads ~/.agents/skills.
for target in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
  mkdir -p "$target"
  for skill in "$src_dir"/ef-*; do
    [ -d "$skill" ] || continue
    dest="$target/$(basename "$skill")"
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$skill" ]; then
      echo "already linked: $dest"
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
      echo "skipped, already exists: $dest" >&2
    else
      ln -s "$skill" "$dest"
      echo "linked: $dest"
    fi
  done
done
