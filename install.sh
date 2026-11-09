#!/usr/bin/env bash
# Link the dev-flow skill into the Claude Code and Codex user skill directories.
# Usage: ./install.sh [zh-CN|en]   (default: zh-CN)
# Existing entries with the same name are never overwritten; they are reported and skipped.
# Broken links left behind by earlier versions of this repository (they point into this repository's skills/) are removed.
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
  for link in "$target"/*; do
    if [ -L "$link" ] && [ ! -e "$link" ]; then
      case "$(readlink "$link")" in
        "$repo_dir/skills/"*) rm "$link" && echo "removed broken link: $link" ;;
      esac
    fi
  done
  for skill in "$src_dir"/*; do
    [ -d "$skill" ] || continue
    dest="$target/$(basename "$skill")"
    if [ -L "$dest" ] && [ "$(readlink "$dest")" = "$skill" ]; then
      echo "already linked: $dest"
    elif [ -e "$dest" ] || [ -L "$dest" ]; then
      echo "skipped, already exists: $dest -> $(readlink "$dest" 2>/dev/null || echo 'not a link')" >&2
    else
      ln -s "$skill" "$dest"
      echo "linked: $dest"
    fi
  done
done
