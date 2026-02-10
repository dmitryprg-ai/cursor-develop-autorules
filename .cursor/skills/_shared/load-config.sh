#!/bin/bash
# Shared config loader for all skill scripts
# Source this: source "$(dirname "$0")/../../_shared/load-config.sh"
#
# Provides: json_get() function + PROJECT_ROOT, SITE_URL, BASIC_AUTH variables
# Requires: python3 (fallback) or jq

SHARED_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_FILE="$(cd "$SHARED_DIR/../.." && pwd)/config/project.config.json"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "ERROR: Config not found: $CONFIG_FILE"
  exit 1
fi

# json_get <path> — extract value from config
# Examples: json_get .site_url | json_get .services.backend.name
if command -v jq &>/dev/null; then
  json_get() { jq -r "$1" "$CONFIG_FILE"; }
  json_get_secrets() { jq -r "$1" "$2"; }
else
  json_get() {
    python3 -c "
import json, sys
data = json.load(open('$CONFIG_FILE'))
keys = sys.argv[1].lstrip('.').split('.')
val = data
for k in keys:
    val = val[k]
print(val)
" "$1"
  }
  json_get_secrets() {
    python3 -c "
import json, sys
data = json.load(open(sys.argv[2]))
keys = sys.argv[1].lstrip('.').split('.')
val = data
for k in keys:
    val = val[k]
print(val)
" "$1" "$2"
  }
fi

# Export common variables
PROJECT_ROOT=$(json_get .project_root)
SITE_URL=$(json_get .site_url)

SECRETS_DIR="$PROJECT_ROOT/$(json_get .auth.secrets_dir)"
BASIC_AUTH_FILE="$SECRETS_DIR/$(json_get .auth.basic_auth_file)"

if [ -f "$BASIC_AUTH_FILE" ]; then
  BASIC_AUTH=$(python3 -c "
import json
d=json.load(open('$BASIC_AUTH_FILE'))
user=d.get('username', d.get('user', ''))
pw=d.get('password', d.get('pass', ''))
print(user+':'+pw)
")
fi
