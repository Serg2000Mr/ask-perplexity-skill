#!/usr/bin/env bash
set -euo pipefail

# install.sh — Install ask-perplexity skill for Claude Code
# Usage: bash install.sh

SKILL_NAME="ask-perplexity"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SOURCE="$SCRIPT_DIR/claude-code/SKILL.md"

# Determine target directory
TARGET_DIR="$HOME/.claude/skills/$SKILL_NAME"

if [ ! -f "$SOURCE" ]; then
  echo "Error: SKILL.md not found at $SOURCE"
  echo "Run this script from the repository root."
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$SOURCE" "$TARGET_DIR/SKILL.md"

echo "Installed: $TARGET_DIR/SKILL.md"
echo ""
echo "Next steps:"
echo "  1. Set your API key in ~/.claude/settings.json:"
echo "     \"env\": { \"PERPLEXITY_API_KEY\": \"pplx-...\" }"
echo ""
echo "  2. Use in Claude Code: /ask-perplexity <question>"
echo ""
echo "For Cursor: copy cursor/perplexity.mdc to your project's .cursor/rules/"
