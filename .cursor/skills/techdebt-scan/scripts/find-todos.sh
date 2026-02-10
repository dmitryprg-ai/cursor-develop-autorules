#!/bin/bash
source "$(dirname "$0")/../../_shared/load-config.sh"

BACKEND_DIR="$PROJECT_ROOT/$(json_get .scan_dirs.backend)"
FRONTEND_DIR="$PROJECT_ROOT/$(json_get .scan_dirs.frontend)"

echo "=== Scanning for TODO/FIXME/HACK markers ==="
echo ""

echo "--- TODO ---"
rg -i "TODO" -g '*.ts' -g '*.tsx' "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' -g '!dist/**' -c 2>/dev/null
echo ""

echo "--- FIXME ---"
rg -i "FIXME" -g '*.ts' -g '*.tsx' "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' -g '!dist/**' -c 2>/dev/null
echo ""

echo "--- HACK/TEMP/STUB ---"
rg -i "HACK|TEMP|STUB" -g '*.ts' -g '*.tsx' "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' -g '!dist/**' -c 2>/dev/null
echo ""

echo "--- Empty catch blocks ---"
rg 'catch\s*\([^)]*\)\s*\{\s*\}' -g '*.ts' -g '*.tsx' "$BACKEND_DIR" "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' -g '!dist/**' 2>/dev/null
echo ""

echo "--- Empty onClick handlers ---"
rg 'onClick=\{?\(\)\s*=>\s*\{?\s*\}?\}?' -g '*.tsx' "$FRONTEND_DIR" \
  -g '!node_modules/**' -g '!.next/**' 2>/dev/null
echo ""

echo "=== Scan complete ==="
