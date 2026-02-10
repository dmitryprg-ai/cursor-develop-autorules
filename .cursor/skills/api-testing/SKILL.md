---
name: api-testing
description: Test API endpoints with proper authorization. Use when testing curl requests, checking API responses, or getting 401 Unauthorized. API requires two auth levels - Basic Auth (nginx) + Session Auth (login). Credentials in .cursor/.secrets/.
---

# API Testing

Test API endpoints that require authorization.

**Configuration:** `.cursor/config/project.config.json` (site URL, auth settings, test user)

## Two Auth Levels

| Level | When needed | Source |
|-------|-------------|--------|
| **Basic Auth** | All requests (nginx) | Config → `auth.basic_auth_file` |
| **Session Auth** | API endpoints (except /health) | Login via `/api/auth/login` |

## Quick Start

Get a session and test:

```bash
# Run the helper script
bash .cursor/skills/api-testing/scripts/get-session.sh

# Then use the session for any endpoint
bash .cursor/skills/api-testing/scripts/test-endpoint.sh /api/endpoint?param=value
```

## Manual Process

All values (site URL, credentials paths, test user email) are in `project.config.json`:

```bash
# 1. Read config values
CONFIG=".cursor/config/project.config.json"
SITE_URL=$(jq -r .site_url "$CONFIG")
SECRETS_DIR=$(jq -r .auth.secrets_dir "$CONFIG")
TEST_EMAIL=$(jq -r .auth.test_user_email "$CONFIG")

# 2. Get Basic Auth
BASIC_AUTH=$(jq -r '.user + ":" + .pass' "$SECRETS_DIR/$(jq -r .auth.basic_auth_file "$CONFIG")")

# 3. Decode password and login
PASSWORD=$(jq -r .password "$SECRETS_DIR/$(jq -r .auth.test_user_file "$CONFIG")" | base64 -d)
curl -c /tmp/session.txt -u "$BASIC_AUTH" \
  -H "Content-Type: application/json" \
  -d '{"email":"'"$TEST_EMAIL"'","password":"'"$PASSWORD"'"}' \
  "$SITE_URL/api/auth/login"

# 4. Use session for requests
curl -b /tmp/session.txt -u "$BASIC_AUTH" "$SITE_URL/api/endpoint"
```

## Important

- **NEVER** hardcode passwords in scripts or output
- **ALWAYS** clean up: `rm /tmp/session.txt` after testing
- Test user is admin with access to all endpoints
- Health endpoint does NOT require session auth (only Basic Auth)
