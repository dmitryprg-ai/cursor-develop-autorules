#!/bin/bash
set -eo pipefail
trap 'echo "ERROR: Script failed at line $LINENO" >&2' ERR
source "$(dirname "$0")/../../_shared/load-config.sh"

BACKEND_DIR="$PROJECT_ROOT/$(json_get .scan_dirs.backend)"
FRONTEND_DIR="$PROJECT_ROOT/$(json_get .scan_dirs.frontend)"

echo "=== GAP ANALYSIS SCAN ==="
echo ""

echo "--- 1. TODO/FIXME/HACK markers ---"
rg -i "TODO|FIXME|XXX|HACK|TEMP|STUB" -g '*.ts' -g '*.tsx' \
  "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' -g '!dist/**' 2>/dev/null | head -50
echo ""

echo "--- 2. NotImplemented / throw stubs ---"
rg "NotImplemented|throw new Error\(['\"].*not implemented" -g '*.ts' \
  "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' 2>/dev/null
echo ""

echo "--- 3. Empty onClick handlers ---"
rg 'onClick=\{?\s*\(\)\s*=>\s*\{?\s*\}?\s*\}?' -g '*.tsx' \
  "$FRONTEND_DIR" -g '!node_modules/**' -g '!.next/**' 2>/dev/null
echo ""

echo "--- 4. Console placeholder handlers ---"
rg "onClick.*console\.(log|warn)" -g '*.tsx' \
  "$FRONTEND_DIR" -g '!node_modules/**' -g '!.next/**' 2>/dev/null
echo ""

echo "--- 5. Placeholder links ---"
rg 'href=["'\''"]#["'\''"]|href=["'\''"]["'\''"]' -g '*.tsx' \
  "$FRONTEND_DIR" -g '!node_modules/**' -g '!.next/**' 2>/dev/null
echo ""

echo "--- 6. Empty catch blocks ---"
rg 'catch\s*\([^)]*\)\s*\{\s*\}' -g '*.ts' -g '*.tsx' \
  "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' -g '!dist/**' 2>/dev/null
echo ""

echo "--- 7. Conditionally disabled code ---"
rg 'if\s*\(\s*false\s*\)|if\s*\(0\)|// disabled|// commented' -g '*.ts' -g '*.tsx' \
  "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' -g '!dist/**' 2>/dev/null
echo ""

echo "=== SCAN COMPLETE ==="
