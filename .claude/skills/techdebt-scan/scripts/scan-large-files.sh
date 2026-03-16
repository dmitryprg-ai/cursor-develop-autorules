#!/bin/bash
set -eo pipefail
trap 'echo "ERROR: Script failed at line $LINENO" >&2' ERR
source "$(dirname "$0")/../../_shared/load-config.sh"

BACKEND_DIR="$PROJECT_ROOT/$(json_get .scan_dirs.backend)"
FRONTEND_DIR="$PROJECT_ROOT/$(json_get .scan_dirs.frontend)"

echo "=== Scanning for oversized files ==="
echo ""

echo "--- Routes/Controllers (limit: 300 lines) ---"
while IFS= read -r f; do
  LINES=$(wc -l < "$f")
  if [ "$LINES" -gt 300 ]; then
    echo "  OVER: $f ($LINES lines)"
  fi
done < <(find "$BACKEND_DIR" "$FRONTEND_DIR" -name "*.routes.ts" -o -name "*.controller.ts" 2>/dev/null)

echo ""
echo "--- Services (limit: 400 lines) ---"
while IFS= read -r f; do
  LINES=$(wc -l < "$f")
  if [ "$LINES" -gt 400 ]; then
    echo "  OVER: $f ($LINES lines)"
  fi
done < <(find "$BACKEND_DIR" -name "*.service.ts" 2>/dev/null)

echo ""
echo "--- React Components (limit: 200 lines) ---"
while IFS= read -r f; do
  LINES=$(wc -l < "$f")
  if [ "$LINES" -gt 200 ]; then
    echo "  OVER: $f ($LINES lines)"
  fi
done < <(find "$FRONTEND_DIR" \( -name "*.tsx" -o -name "*.jsx" \) -not -path "*/node_modules/*" -not -path "*/.next/*" 2>/dev/null)

echo ""
echo "--- API Client files (limit: 300 lines) ---"
while IFS= read -r f; do
  LINES=$(wc -l < "$f")
  if [ "$LINES" -gt 300 ]; then
    echo "  OVER: $f ($LINES lines)"
  fi
done < <(find "$FRONTEND_DIR/lib/api" -name "*.ts" 2>/dev/null)

echo ""
echo "=== Scan complete ==="
