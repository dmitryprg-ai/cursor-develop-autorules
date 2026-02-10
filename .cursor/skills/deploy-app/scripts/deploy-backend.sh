#!/bin/bash
set -e
source "$(dirname "$0")/../../_shared/load-config.sh"

BUILD_CMD=$(json_get .services.backend.build_cmd)
RESTART_CMD=$(json_get .services.backend.restart_cmd)
STATUS_CMD=$(json_get .services.backend.status_cmd)
HEALTH=$(json_get .services.backend.health_endpoint)

cd "$PROJECT_ROOT"

echo "=== Building backend ==="
eval "$BUILD_CMD"

echo "=== Restarting backend service ==="
eval "$RESTART_CMD"

echo "=== Waiting 3 seconds ==="
sleep 3

echo "=== Verifying API health ==="
curl -s -u "$BASIC_AUTH" "$SITE_URL$HEALTH"
echo ""

echo "=== Service status ==="
eval "$STATUS_CMD" | tail -10

echo "=== Deploy backend complete ==="
