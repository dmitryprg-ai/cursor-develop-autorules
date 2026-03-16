---
name: deploy-app
description: "Deploy backend and/or frontend services. Use after npm run build completes, when restarting services, when user mentions deploy/build/restart, or when page shows Application error. Also trigger on 502/503 errors, service health check failures, or after code changes that need deployment."
allowed-tools: Bash, Read
model: sonnet
user-invocable: true
---

# Deploy App

Build, restart services, and verify the app is working.

**Configuration:** `.cursor/config/project.config.json`

## Why order matters

Next.js serves the old build until the systemd service restarts. If you build but forget to restart, users see stale code. If you restart without building, the service may crash on missing files. The sequence build -> restart -> verify exists because each step depends on the previous one succeeding.

## Workflows

### Deploy Backend

Run: `bash ${CLAUDE_SKILL_DIR}/scripts/deploy-backend.sh`

Or manually:
1. Build: `npm run build` (from project root)
2. Restart: `sudo systemctl restart crmai`
3. Wait 3 seconds for startup
4. Verify: `curl -s -u user:pass "https://site/api/health"`
5. Check logs: `systemctl status crmai | tail -10`

### Deploy Frontend

Run: `bash ${CLAUDE_SKILL_DIR}/scripts/deploy-frontend.sh`

Or manually:
1. Build: `cd apps/web && npm run build`
2. Restart: `sudo systemctl restart crmai-web`
3. Wait 5 seconds (Next.js takes longer to start)
4. Verify no "Application error": `curl -s -u user:pass "https://site/" | grep "Application error"`
5. Check logs: `systemctl status crmai-web | tail -10`

### Deploy All

Run: `bash ${CLAUDE_SKILL_DIR}/scripts/deploy-all.sh`

### Verify Pages

Run: `bash ${CLAUDE_SKILL_DIR}/scripts/verify-pages.sh`

## Verification Checklist

- [ ] Build succeeded (exit code 0)?
- [ ] Service restarted?
- [ ] Pages/API respond without errors?
- [ ] Logs show no critical errors?

## Credentials

Basic Auth credentials: read from `.cursor/.secrets/` (path in config)

## Stop Conditions

- Build fails: fix the error first — restarting with broken build makes things worse
- Service won't start: check logs immediately — proceeding blindly wastes time
- "Application error" persists: rebuild and restart again — the build cache may be stale

## Success Criteria

- Health endpoint returns 200 (backend)
- Pages load without "Application error" (frontend)
- Service status shows "active (running)"
