---
name: api-testing
description: "Test API endpoints with proper authorization including Basic Auth and session cookies. Use when testing curl requests, checking API responses, getting 401 Unauthorized, session expired errors, or verifying endpoint behavior after changes."
allowed-tools: Bash, Read
model: sonnet
user-invocable: true
---

# API Testing

Test API endpoints that require authorization.

**Configuration:** `.cursor/config/project.config.json`

## Why Two Auth Levels

The API uses layered security: nginx handles Basic Auth for all requests (keeping the site private), while the application handles Session Auth for user-specific data. Health endpoint is exempt from session auth so monitoring tools can check availability without logging in.

| Level | Scope | Source |
|-------|-------|--------|
| **Basic Auth** | All requests (nginx layer) | Config: `auth.basic_auth_file` |
| **Session Auth** | API endpoints except /health | Login via `/api/auth/login` |

## Quick Start

```bash
# Get a session
bash ${CLAUDE_SKILL_DIR}/scripts/get-session.sh

# Test any endpoint
bash ${CLAUDE_SKILL_DIR}/scripts/test-endpoint.sh /api/endpoint?param=value
```

## Manual Process

```bash
# 1. Read config
CONFIG=".cursor/config/project.config.json"
SITE_URL=$(jq -r .site_url "$CONFIG")
SECRETS_DIR=$(jq -r .auth.secrets_dir "$CONFIG")
TEST_EMAIL=$(jq -r .auth.test_user_email "$CONFIG")

# 2. Get Basic Auth
BASIC_AUTH=$(jq -r '.user + ":" + .pass' "$SECRETS_DIR/$(jq -r .auth.basic_auth_file "$CONFIG")")

# 3. Login to get session
PASSWORD=$(jq -r .password "$SECRETS_DIR/$(jq -r .auth.test_user_file "$CONFIG")" | base64 -d)
curl -c /tmp/session.txt -u "$BASIC_AUTH" \
  -H "Content-Type: application/json" \
  -d '{"email":"'"$TEST_EMAIL"'","password":"'"$PASSWORD"'"}' \
  "$SITE_URL/api/auth/login"

# 4. Use session for requests
curl -b /tmp/session.txt -u "$BASIC_AUTH" "$SITE_URL/api/endpoint"
```

## Important

- Never hardcode passwords in scripts or output — they change and leak
- Clean up after testing: `rm /tmp/session.txt`
- Test user has admin access to all endpoints
- Health endpoint only needs Basic Auth (no session required)
