#!/usr/bin/env bash
set -euo pipefail

# Install ask-perplexity for Claude Code, Codex, Cursor, or all three.
# Usage: bash install.sh [claude|codex|cursor|all]

SKILL_NAME="ask-perplexity"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/claude-code"
TARGET="${1:-claude}"

required=(
  "SKILL.md"
  "run-perplexity.sh"
  "run-perplexity.ps1"
  "assets/request.example.json"
  "assets/question.example.md"
)

for file in "${required[@]}"; do
  if [ ! -f "$SOURCE_DIR/$file" ]; then
    echo "Error: required file not found: $SOURCE_DIR/$file" >&2
    exit 1
  fi
done

install_one() {
  local agent="$1"
  local target_dir
  case "$agent" in
    claude) target_dir="$HOME/.claude/skills/$SKILL_NAME" ;;
    codex)  target_dir="$HOME/.codex/skills/$SKILL_NAME" ;;
    cursor) target_dir="$HOME/.cursor/skills/$SKILL_NAME" ;;
    *) echo "Error: unsupported target '$agent'" >&2; exit 2 ;;
  esac

  mkdir -p "$target_dir/assets"
  cp "$SOURCE_DIR/SKILL.md" "$target_dir/SKILL.md"
  cp "$SOURCE_DIR/run-perplexity.sh" "$target_dir/run-perplexity.sh"
  cp "$SOURCE_DIR/run-perplexity.ps1" "$target_dir/run-perplexity.ps1"
  cp "$SOURCE_DIR/assets/request.example.json" "$target_dir/assets/request.example.json"
  cp "$SOURCE_DIR/assets/question.example.md" "$target_dir/assets/question.example.md"
  chmod +x "$target_dir/run-perplexity.sh"
  echo "Installed for $agent: $target_dir"
}

case "$TARGET" in
  claude|codex|cursor) install_one "$TARGET" ;;
  all)
    install_one claude
    install_one codex
    install_one cursor
    ;;
  *)
    echo "Usage: bash install.sh [claude|codex|cursor|all]" >&2
    exit 2
    ;;
esac

echo "Create task-specific question.md and request.json files outside the skill."
echo "On Windows, validate and run request.json with run-perplexity.ps1."
