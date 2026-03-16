#!/bin/bash
set -euo pipefail
trap 'echo "ERROR: Script failed at line $LINENO" >&2' ERR
source "$(dirname "$0")/../../_shared/load-config.sh"

SUBDIR=$(json_get .services.frontend.subdir)
BUILD_CMD=$(json_get .services.frontend.build_cmd)
RESTART_CMD=$(json_get .services.frontend.restart_cmd)
STATUS_CMD=$(json_get .services.frontend.status_cmd)

cd "$PROJECT_ROOT/$SUBDIR"

echo "=== Building frontend ==="
eval "$BUILD_CMD"

echo "=== Restarting frontend service ==="
eval "$RESTART_CMD"

echo "=== Waiting 5 seconds ==="
sleep 5

echo "=== Verifying pages ==="
ERRORS=$(curl -s -u "$BASIC_AUTH" "$SITE_URL/" | grep -c "Application error" || true)
if [ "$ERRORS" -gt 0 ]; then
  echo "ERROR: Application error detected on main page!"
  exit 1
else
  echo "OK: No Application error"
fi

echo "=== Service status ==="
eval "$STATUS_CMD" | tail -10

echo "=== Deploy frontend complete ==="
