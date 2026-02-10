#!/bin/bash
source "$(dirname "$0")/../../_shared/load-config.sh"

echo "=== Verifying pages ==="

# Read pages from config
if command -v jq &>/dev/null; then
  PAGES=$(jq -r '.verify_pages[]' "$CONFIG_FILE")
else
  PAGES=$(python3 -c "import json; [print(p) for p in json.load(open('$CONFIG_FILE'))['verify_pages']]")
fi

FAILED=0
while IFS= read -r PAGE; do
  ERRORS=$(curl -s -u "$BASIC_AUTH" "$SITE_URL$PAGE" | grep -c "Application error" || true)
  if [ "$ERRORS" -gt 0 ]; then
    echo "FAIL: $PAGE — Application error"
    FAILED=$((FAILED + 1))
  else
    echo "OK:   $PAGE"
  fi
done <<< "$PAGES"

if [ "$FAILED" -gt 0 ]; then
  echo ""
  echo "FAILED: $FAILED page(s) with errors"
  exit 1
else
  echo ""
  echo "ALL PAGES OK"
fi
