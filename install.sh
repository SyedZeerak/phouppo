#!/usr/bin/env bash
# Install the Phouppo skill for Cursor, Claude Code, Codex, and Antigravity.
set -euo pipefail

SKILL_NAME="phouppo"
SRC="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/skills/${SKILL_NAME}"
SCOPE="global"
MODE="copy"
AGENTS="cursor,claude,codex,antigravity"
ACTION="install"

usage() {
  cat <<USAGE
Usage: bash install.sh [options]

Options:
  --global           Install into your home directory (default)
  --project          Install into the current directory
  --agents LIST      Comma-separated: cursor,claude,codex,antigravity (default: all)
  --link             Symlink instead of copying (updates follow this repo)
  --uninstall        Remove the skill from the selected locations
  -h, --help         Show this help

Examples:
  bash install.sh
  bash install.sh --agents codex,antigravity
  bash install.sh --project --agents cursor,claude
USAGE
}

while [ $# -gt 0 ]; do
  case "$1" in
    --global) SCOPE="global" ;;
    --project) SCOPE="project" ;;
    --agents) AGENTS="${2:?--agents needs a value}"; shift ;;
    --link) MODE="link" ;;
    --uninstall) ACTION="uninstall" ;;
    -h|--help) usage; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage; exit 1 ;;
  esac
  shift
done

dest_for() {
  case "$SCOPE:$1" in
    global:cursor)       echo "$HOME/.cursor/skills" ;;
    global:claude)       echo "$HOME/.claude/skills" ;;
    global:codex)        echo "$HOME/.agents/skills" ;;
    global:antigravity)  echo "$HOME/.gemini/antigravity/skills" ;;
    project:cursor)      echo "$PWD/.cursor/skills" ;;
    project:claude)      echo "$PWD/.claude/skills" ;;
    project:codex)       echo "$PWD/.agents/skills" ;;
    project:antigravity) echo "$PWD/.agent/skills" ;;
    *) return 1 ;;
  esac
}

if [ "$ACTION" = "install" ] && [ ! -f "$SRC/SKILL.md" ]; then
  echo "Cannot find $SRC/SKILL.md. Run this script from the repository root." >&2
  exit 1
fi

IFS=',' read -r -a LIST <<< "$AGENTS"
for agent in "${LIST[@]}"; do
  agent="$(echo "$agent" | tr -d ' ')"
  if ! base="$(dest_for "$agent")"; then
    echo "Skipping unknown agent: $agent" >&2
    continue
  fi
  target="$base/$SKILL_NAME"
  if [ "$ACTION" = "uninstall" ]; then
    rm -rf "$target"
    echo "Removed: $target"
    continue
  fi
  mkdir -p "$base"
  rm -rf "$target"
  if [ "$MODE" = "link" ]; then
    ln -s "$SRC" "$target"
  else
    cp -r "$SRC" "$target"
  fi
  echo "Installed ($MODE) for $agent: $target"
done

echo "Done. Restart your agent if the skill does not appear."
