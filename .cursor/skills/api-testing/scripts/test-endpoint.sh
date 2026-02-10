#!/bin/bash
# Usage: test-endpoint.sh /api/endpoint
ENDPOINT="${1:?Usage: test-endpoint.sh /api/endpoint}"

source "$(dirname "$0")/../../_shared/load-config.sh"

if [ ! -f /tmp/session.txt ]; then
  echo "No session found. Run get-session.sh first."
  exit 1
fi

echo "=== Testing: $ENDPOINT ==="
curl -s -b /tmp/session.txt -u "$BASIC_AUTH" "$SITE_URL$ENDPOINT"
