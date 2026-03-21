#!/usr/bin/env bash
set -euo pipefail

# install.sh — Install ask-perplexity skill for Claude Code
# Usage: bash install.sh

SKILL_NAME="ask-perplexity"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE_DIR="$SCRIPT_DIR/claude-code"
TARGET_DIR="$HOME/.claude/skills/$SKILL_NAME"

if [ ! -f "$SOURCE_DIR/SKILL.md" ]; then
  echo "Error: SKILL.md not found at $SOURCE_DIR/SKILL.md"
  echo "Run this script from the repository root."
  exit 1
fi

if [ ! -f "$SOURCE_DIR/run-perplexity.sh" ]; then
  echo "Error: run-perplexity.sh not found at $SOURCE_DIR/run-perplexity.sh"
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$SOURCE_DIR/SKILL.md" "$TARGET_DIR/SKILL.md"
cp "$SOURCE_DIR/run-perplexity.sh" "$TARGET_DIR/run-perplexity.sh"
chmod +x "$TARGET_DIR/run-perplexity.sh"

echo "Installed:"
echo "  $TARGET_DIR/SKILL.md"
echo "  $TARGET_DIR/run-perplexity.sh"
echo ""
echo "Next steps:"
echo "  1. Set your API key in ~/.claude/settings.json:"
echo "     \"env\": { \"PERPLEXITY_API_KEY\": \"pplx-...\" }"
echo ""
echo "  2. Use in Claude Code: /ask-perplexity <question>"
echo ""
echo "For Cursor: copy cursor/perplexity.mdc to your project's .cursor/rules/"
