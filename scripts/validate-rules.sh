#!/bin/bash
set -euo pipefail

# Validate Rules & Skills Integrity
# Checks cross-references, placeholders, frontmatter, file sizes, routing table

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CURSOR_DIR="$PROJECT_ROOT/.cursor"
ERRORS=0
WARNINGS=0

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
NC='\033[0m'

error() { echo -e "${RED}ERROR:${NC} $1"; ((ERRORS++)); }
warn() { echo -e "${YELLOW}WARN:${NC} $1"; ((WARNINGS++)); }
ok() { echo -e "${GREEN}OK:${NC} $1"; }

echo "=== Validating Rules & Skills Integrity ==="
echo "Project root: $PROJECT_ROOT"
echo ""

# 1. Check all referenced .mdc files exist
echo "--- Checking cross-references in rules ---"
for mdc in "$CURSOR_DIR"/rules/*.mdc "$CURSOR_DIR"/rules_alone/*.mdc 2>/dev/null; do
  [ -f "$mdc" ] || continue
  basename_mdc=$(basename "$mdc")

  # Find references to .mdc files
  while IFS= read -r ref; do
    ref_name=$(echo "$ref" | grep -oP '[a-zA-Z0-9_-]+\.mdc' || true)
    [ -z "$ref_name" ] && continue
    [ "$ref_name" = "$basename_mdc" ] && continue

    # Check if referenced file exists
    if [ ! -f "$CURSOR_DIR/rules/$ref_name" ] && [ ! -f "$CURSOR_DIR/rules_alone/$ref_name" ]; then
      error "$basename_mdc references non-existent file: $ref_name"
    fi
  done < <(grep -n '\.mdc' "$mdc" 2>/dev/null | grep -v '^---' | grep -v 'globs:' || true)
done

# 2. Check all skill directories referenced in routing table exist
echo ""
echo "--- Checking routing table completeness ---"
CORE_MASTER="$CURSOR_DIR/rules/core-master.mdc"
if [ -f "$CORE_MASTER" ]; then
  while IFS= read -r skill_name; do
    [ -z "$skill_name" ] && continue
    if [ ! -d "$CURSOR_DIR/skills/$skill_name" ]; then
      error "Routing table references non-existent skill: $skill_name"
    fi
  done < <(grep -oP '`([a-z-]+)` skill' "$CORE_MASTER" | grep -oP '`([a-z-]+)`' | tr -d '`' || true)
  ok "Routing table checked"
else
  error "core-master.mdc not found!"
fi

# 3. Check no {placeholder} tokens in rules/skills (only allowed in config/)
echo ""
echo "--- Checking for unresolved placeholders ---"
for f in "$CURSOR_DIR"/rules/*.mdc "$CURSOR_DIR"/rules_alone/*.mdc "$CURSOR_DIR"/skills/*/SKILL.md 2>/dev/null; do
  [ -f "$f" ] || continue
  if grep -qP '\{[a-z-]+\}' "$f" 2>/dev/null; then
    matches=$(grep -nP '\{[a-z-]+\}' "$f" | head -3)
    warn "$(basename "$f") contains placeholders: $matches"
  fi
done

# 4. Check .mdc frontmatter has required fields
echo ""
echo "--- Checking frontmatter format ---"
for mdc in "$CURSOR_DIR"/rules/*.mdc 2>/dev/null; do
  [ -f "$mdc" ] || continue
  basename_mdc=$(basename "$mdc")

  # Check starts with ---
  if ! head -1 "$mdc" | grep -q '^---$'; then
    error "$basename_mdc missing frontmatter (no opening ---)"
    continue
  fi

  # Check has alwaysApply field
  if ! grep -q 'alwaysApply:' "$mdc"; then
    warn "$basename_mdc missing alwaysApply field"
  fi
done

# 5. Check SKILL.md files have required frontmatter
echo ""
echo "--- Checking skill frontmatter ---"
for skill_dir in "$CURSOR_DIR"/skills/*/; do
  [ -d "$skill_dir" ] || continue
  skill_name=$(basename "$skill_dir")
  skill_md="$skill_dir/SKILL.md"

  if [ ! -f "$skill_md" ]; then
    error "Skill '$skill_name' has no SKILL.md"
    continue
  fi

  if ! grep -q '^name:' "$skill_md"; then
    warn "Skill '$skill_name' SKILL.md missing 'name:' in frontmatter"
  fi

  if ! grep -q '^description:' "$skill_md"; then
    warn "Skill '$skill_name' SKILL.md missing 'description:' in frontmatter"
  fi
done

# 6. Check file sizes against limits
echo ""
echo "--- Checking file size limits ---"
for f in "$CURSOR_DIR"/rules/*.mdc "$CURSOR_DIR"/rules_alone/*.mdc; do
  [ -f "$f" ] || continue
  lines=$(wc -l < "$f")
  basename_f=$(basename "$f")
  if [ "$lines" -gt 300 ]; then
    warn "$basename_f is $lines lines (soft limit: 300)"
  fi
done

for skill_dir in "$CURSOR_DIR"/skills/*/; do
  [ -d "$skill_dir" ] || continue
  skill_md="$skill_dir/SKILL.md"
  [ -f "$skill_md" ] || continue
  lines=$(wc -l < "$skill_md")
  skill_name=$(basename "$skill_dir")
  if [ "$lines" -gt 200 ]; then
    warn "Skill '$skill_name' SKILL.md is $lines lines (consider splitting with references/)"
  fi
done

# 7. Check .cursor_additional references (should not exist)
echo ""
echo "--- Checking for deprecated paths ---"
if grep -rl '.cursor_additional' "$CURSOR_DIR"/rules/ "$CURSOR_DIR"/rules_alone/ "$CURSOR_DIR"/skills/ 2>/dev/null; then
  error "Found references to deprecated .cursor_additional/ path"
fi

# 8. Check .cursor/data/ directory exists
echo ""
echo "--- Checking data directory ---"
if [ -d "$CURSOR_DIR/data" ]; then
  ok ".cursor/data/ directory exists"
else
  warn ".cursor/data/ directory missing (needed for error-log.md, improvements-backlog.md)"
fi

# Summary
echo ""
echo "=== Validation Summary ==="
echo -e "Errors:   ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

if [ "$ERRORS" -gt 0 ]; then
  echo -e "${RED}FAILED${NC} — fix errors before proceeding"
  exit 1
elif [ "$WARNINGS" -gt 0 ]; then
  echo -e "${YELLOW}PASSED with warnings${NC}"
  exit 0
else
  echo -e "${GREEN}ALL CHECKS PASSED${NC}"
  exit 0
fi
