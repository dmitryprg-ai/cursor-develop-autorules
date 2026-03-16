#!/bin/bash
set -euo pipefail
trap 'echo "ERROR: Script failed at line $LINENO" >&2' ERR
source "$(dirname "$0")/../../_shared/load-config.sh"

TEST_USER_FILE="$SECRETS_DIR/$(json_get .auth.test_user_file)"
TEST_USER_EMAIL=$(json_get .auth.test_user_email)

if command -v jq &>/dev/null; then
  PASSWORD=$(jq -r .password "$TEST_USER_FILE" | base64 -d)
else
  PASSWORD=$(python3 -c "import json; print(json.load(open('$TEST_USER_FILE'))['password'])" | base64 -d)
fi

echo "=== Logging in ==="
RESPONSE=$(curl -s -c /tmp/session.txt -u "$BASIC_AUTH" \
  -H "Content-Type: application/json" \
  -d '{"email":"'"$TEST_USER_EMAIL"'","password":"'"$PASSWORD"'"}' \
  "$SITE_URL/api/auth/login")

echo "$RESPONSE"

if [ -f /tmp/session.txt ]; then
  echo ""
  echo "Session saved to /tmp/session.txt"
  echo "Use: curl -b /tmp/session.txt -u '$BASIC_AUTH' '$SITE_URL/api/...'"
else
  echo "ERROR: Session file not created"
  exit 1
fi
