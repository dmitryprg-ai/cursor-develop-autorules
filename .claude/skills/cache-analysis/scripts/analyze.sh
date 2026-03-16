#!/bin/bash
set -eo pipefail

CLAUDE_HOME="${CLAUDE_HOME:-$HOME/.claude}"
TOP="${1:-10}"

echo "=== Claude Code Cache Analysis ==="
echo "Path: $CLAUDE_HOME"
echo ""

if ! command -v claude-cache-analyzer &>/dev/null; then
  echo "Installing claude-cache-analyzer..."
  pip install claude-cache-analyzer 2>/dev/null
fi

echo "--- Top $TOP Sessions ---"
claude-cache-analyzer "$CLAUDE_HOME" --top "$TOP" 2>&1 || {
  echo ""
  echo "Note: If you see datetime errors, try analyzing a specific project:"
  echo "  claude-cache-analyzer \"\$CLAUDE_HOME/projects/PROJECT_DIR\" --top 5"
  echo ""
  echo "Available projects:"
  ls "$CLAUDE_HOME/projects/" 2>/dev/null
}
