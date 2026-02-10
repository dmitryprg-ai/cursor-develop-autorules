---
name: deploy-app
description: Deploy backend and/or frontend after code changes. Use after npm run build, when deploying, restarting services, or when user mentions deploy, build, restart, or sees "Application error". BUILD WITHOUT RESTART = BROKEN SITE.
---

# Deploy App

Build, restart services, and verify the app is working.

**Configuration:** `.cursor/config/project.config.json` (project root, site URL, service names, etc.)

## Critical Rule

**BUILD WITHOUT RESTART = BROKEN SITE.** Always: build -> restart -> verify -> check logs.

## Workflows

### Deploy Backend

Run: `bash .cursor/skills/deploy-app/scripts/deploy-backend.sh`

Or manually (values from config):
1. Run backend build command
2. Restart backend service
3. Wait 3 seconds
4. Verify: `curl -s -u <user>:<pass> "<site_url>/api/health"`
5. Check logs: backend status command | tail -10

### Deploy Frontend

Run: `bash .cursor/skills/deploy-app/scripts/deploy-frontend.sh`

Or manually (values from config):
1. `cd <frontend_subdir> && <build_cmd>`
2. Restart frontend service
3. Wait 5 seconds
4. Verify no "Application error": `curl -s -u <user>:<pass> "<site_url>/" | grep "Application error"`
5. Check logs: frontend status command | tail -10

### Deploy All

Run: `bash .cursor/skills/deploy-app/scripts/deploy-all.sh`

### Verify Pages

Run: `bash .cursor/skills/deploy-app/scripts/verify-pages.sh`

Pages to verify are listed in `project.config.json` → `verify_pages`.

## Verification Checklist

- [ ] Build succeeded (exit code 0)?
- [ ] Service restarted?
- [ ] Pages/API respond without errors?
- [ ] Logs show no critical errors?

## Credentials

Basic Auth credentials: read from `.cursor/.secrets/` (path in config → `auth.basic_auth_file`)

## Stop Conditions

- If build fails: fix the error before restarting
- If service won't start: check logs immediately, do NOT proceed
- If "Application error" persists after restart: rebuild and restart again

## Success Criteria

- Health endpoint returns 200 (backend)
- Pages load without "Application error" (frontend)
- Service status shows "active (running)"
