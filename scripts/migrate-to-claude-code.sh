#!/bin/bash
set -euo pipefail

# Migrate .cursor/ rules and skills to .claude/ format
# Usage: ./scripts/migrate-to-claude-code.sh [--dry-run]

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CURSOR_DIR="$PROJECT_ROOT/.cursor"
CLAUDE_DIR="$PROJECT_ROOT/.claude"
DRY_RUN=false

if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "=== DRY RUN MODE ==="
fi

log() { echo "[migrate] $1"; }
dry() { if $DRY_RUN; then echo "  [dry-run] Would: $1"; else eval "$1"; fi; }

# Phase 1: Create directory structure
log "Phase 1: Creating .claude/ directory structure..."
dry "mkdir -p '$CLAUDE_DIR/rules'"
dry "mkdir -p '$CLAUDE_DIR/agents'"
dry "mkdir -p '$CLAUDE_DIR/skills'"

# Phase 2: Convert rules (.mdc -> .md)
log "Phase 2: Converting rules from .mdc to .md..."

convert_rule() {
  local src="$1"
  local dest_name="$2"
  local dest="$CLAUDE_DIR/rules/$dest_name.md"

  if $DRY_RUN; then
    echo "  [dry-run] Would convert: $(basename "$src") -> $dest_name.md"
    return
  fi

  # Read file, skip frontmatter, convert XML tags to markdown
  local in_frontmatter=false
  local frontmatter_count=0
  local content=""

  while IFS= read -r line; do
    if [[ "$line" == "---" ]]; then
      ((frontmatter_count++))
      if [[ $frontmatter_count -le 2 ]]; then
        continue
      fi
    fi

    if [[ $frontmatter_count -lt 2 ]]; then
      continue
    fi

    # Convert XML tags to markdown
    line="${line//<required>/}"
    line="${line//<\/required>/}"
    line="${line//<critical>/**CRITICAL:**}"
    line="${line//<\/critical>/}"
    line="${line//<example>/}"
    line="${line//<\/example>/}"
    line="${line//<example type=\"invalid\">/}"

    content+="$line"$'\n'
  done < "$src"

  echo "$content" > "$dest"
  log "  Converted: $(basename "$src") -> $dest_name.md"
}

# Map .cursor/rules/ -> .claude/rules/
declare -A RULE_MAP=(
  ["core-master.mdc"]="core-master"
  ["standard-react-hooks-auto.mdc"]="react-hooks"
  ["standard-radix-select-auto.mdc"]="radix-select"
  ["standard-api-pagination-agent.mdc"]="api-pagination"
  ["standard-file-size-limits-agent.mdc"]="file-size-limits"
  ["standard-agent-quality.mdc"]="agent-quality"
  ["standard-security-agent.mdc"]="security"
  ["workflows-site-basic-auth-agent.mdc"]="basic-auth"
  ["_base-5wh.mdc"]="analysis-5wh"
  ["_base-jtbd-thinking.mdc"]="jtbd-thinking"
  ["_base-rat.mdc"]="riskiest-assumption"
  ["_base-todo-usage.mdc"]="todo-usage"
  ["error-learning.mdc"]="error-learning"
  ["protocol-freeze-recovery.mdc"]="freeze-recovery"
)

for src_name in "${!RULE_MAP[@]}"; do
  src="$CURSOR_DIR/rules/$src_name"
  if [ -f "$src" ]; then
    convert_rule "$src" "${RULE_MAP[$src_name]}"
  else
    log "  SKIP: $src_name (not found)"
  fi
done

# Phase 3: Copy skills (they work in both formats)
log "Phase 3: Copying skills..."
if ! $DRY_RUN; then
  if [ -d "$CURSOR_DIR/skills" ]; then
    cp -r "$CURSOR_DIR/skills/"* "$CLAUDE_DIR/skills/" 2>/dev/null || true
    log "  Copied skills to .claude/skills/"
  fi
else
  echo "  [dry-run] Would copy .cursor/skills/ -> .claude/skills/"
fi

# Phase 4: Generate settings.json if not exists
log "Phase 4: Checking settings.json..."
if [ -f "$CLAUDE_DIR/settings.json" ]; then
  log "  settings.json already exists, skipping"
else
  log "  Creating default settings.json..."
  if ! $DRY_RUN; then
    cat > "$CLAUDE_DIR/settings.json" << 'SETTINGS_EOF'
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "allow": [
      "Bash(npm run *)",
      "Bash(npx *)",
      "Bash(git *)",
      "Bash(curl -s *)",
      "Read(src/**)",
      "Read(apps/**)",
      "Write(src/**/*.ts)",
      "Write(apps/**/*.ts)",
      "Write(apps/**/*.tsx)"
    ],
    "deny": [
      "Read(.env*)",
      "Read(.cursor/.secrets/*)",
      "Bash(rm -rf *)",
      "Bash(*DROP TABLE*)",
      "Write(node_modules/**)",
      "Write(dist/**)",
      "Write(.next/**)"
    ]
  }
}
SETTINGS_EOF
    log "  Created default settings.json"
  fi
fi

# Phase 5: Copy agents if not exists
log "Phase 5: Checking agents..."
if [ -d "$CLAUDE_DIR/agents" ] && [ "$(ls -A "$CLAUDE_DIR/agents" 2>/dev/null)" ]; then
  log "  agents/ already populated, skipping"
else
  log "  agents/ directory empty — create agents manually or copy from template"
fi

# Phase 6: Validate
log "Phase 6: Running validation..."
if [ -f "$SCRIPT_DIR/validate-rules.sh" ]; then
  bash "$SCRIPT_DIR/validate-rules.sh" || true
else
  log "  validate-rules.sh not found, skipping validation"
fi

# Summary
echo ""
echo "=== Migration Summary ==="
echo "Source:      .cursor/"
echo "Destination: .claude/"
echo ""
echo "Rules converted: ${#RULE_MAP[@]}"
echo "Skills copied:   $(ls -d "$CLAUDE_DIR/skills/"*/ 2>/dev/null | wc -l || echo 0)"
echo "Agents present:  $(ls "$CLAUDE_DIR/agents/"*.md 2>/dev/null | wc -l || echo 0)"
echo "Settings:        $([ -f "$CLAUDE_DIR/settings.json" ] && echo "present" || echo "missing")"
echo ""
if $DRY_RUN; then
  echo "This was a DRY RUN. No files were modified."
  echo "Run without --dry-run to perform the actual migration."
fi
