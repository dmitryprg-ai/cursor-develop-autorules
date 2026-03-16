#!/bin/bash
set -euo pipefail
trap 'echo "ERROR: Script failed at line $LINENO" >&2' ERR
source "$(dirname "$0")/../../_shared/load-config.sh"

BE_BUILD=$(json_get .services.backend.build_cmd)
BE_RESTART=$(json_get .services.backend.restart_cmd)
FE_SUBDIR=$(json_get .services.frontend.subdir)
FE_BUILD=$(json_get .services.frontend.build_cmd)
FE_RESTART=$(json_get .services.frontend.restart_cmd)
HEALTH=$(json_get .services.backend.health_endpoint)
BE_NAME=$(json_get .services.backend.name)
FE_NAME=$(json_get .services.frontend.name)

echo "=== Building backend ==="
cd "$PROJECT_ROOT"
eval "$BE_BUILD"

echo "=== Building frontend ==="
cd "$PROJECT_ROOT/$FE_SUBDIR"
eval "$FE_BUILD"

echo "=== Restarting both services ==="
eval "$BE_RESTART"
eval "$FE_RESTART"

echo "=== Waiting 5 seconds ==="
sleep 5

echo "=== Verifying backend ==="
curl -s -u "$BASIC_AUTH" "$SITE_URL$HEALTH"
echo ""

echo "=== Verifying frontend ==="
ERRORS=$(curl -s -u "$BASIC_AUTH" "$SITE_URL/" | grep -c "Application error" || true)
if [ "$ERRORS" -gt 0 ]; then
  echo "ERROR: Application error detected!"
  exit 1
else
  echo "OK: No Application error"
fi

echo "=== Service status ==="
sudo systemctl status "$BE_NAME" "$FE_NAME" | grep -E "Active:|●"

echo "=== Deploy all complete ==="
