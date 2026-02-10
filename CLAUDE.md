# CLAUDE.md — crmai Project

> Automatically loaded into every conversation. Keep lean — details in .cursor/rules/.

## Project Overview

**CRMAI** — CRM Analytics: Bitrix24 integration, sales analytics, manager activity tracking.

| Layer | Technologies |
|-------|--------------|
| Backend | Node.js 20+, TypeScript, Express, PostgreSQL, Zod |
| Frontend | Next.js 16+, React 19, Tailwind CSS v4, shadcn/ui |
| Deployment | systemd services on Linux |

## Key Directories

```
src/modules/           — Backend modules (bitrix24/, customers/, users/, settings/, schedule/)
apps/web/app/          — Frontend pages (Next.js App Router)
apps/web/features/     — Feature-based components
apps/web/lib/api/      — Modular API clients by feature
.cursor/rules/         — AI agent protocols
```

## Commands

```bash
# Backend
npm run dev                    # Dev server (port 5003)
npm run build && sudo systemctl restart crmai    # Deploy backend

# Frontend
cd apps/web && npm run dev     # Dev server (port 3001)
cd apps/web && npm run build && sudo systemctl restart crmai-web  # Deploy frontend

# Verify after deploy
curl -s -u <user>:<pass> "https://crmai.lavsit.ru/api/health"
sudo systemctl status crmai crmai-web | grep Active

# Database
psql -h localhost -U crmai_user -d crmai
```

## Code Style

- Backend pattern: `module.types.ts → module.repository.ts → module.service.ts → module.routes.ts`
- Types ONLY in `*.types.ts` — strict TypeScript, Zod validation
- Frontend: App Router, Tailwind CSS, shadcn/ui, `KtCard` wrapper
- File limit: > 300 lines = plan split. Split by business domain, not technical layer.

## Project-Specific Warnings

### Bitrix24 API
- **Pagination**: NEVER rely on `response.length < limit`. Use `total` from API response. Bitrix24 at `start > total` returns records WITHOUT filter (loaded 333K instead of 100).
- **UF-fields**: "List" type = IDs, not text — need mapping
- **Rate limits**: No parallel syncs

### Other
- PostgreSQL bigint → JSON string → `Number()` in code
- Entry points: use `*SummaryService.syncDay()`, not low-level methods
- Tailwind v4: use `grid grid-cols-4 gap-6` (no responsive prefixes like `md:` — may not generate)
- Chat messages: check text `startsWith('=== Исходящее')` for outgoing, not just `is_manager` field
- Site uses Basic Auth — creds in `.cursor/.secrets/site-basic-auth.json`

## Workflow

Complex tasks → `.cursor/rules/core-master.mdc` routes to skills:

| Task | Skill |
|------|-------|
| New feature | `development` skill |
| Bug fix | `bugfix` skill |
| Refactoring | `refactoring` skill |
| Data analysis | `research` skill |
| Deploy | `deploy-app` skill (with scripts) |
| Code review | `code-review` skill |
| TDD | `tdd-workflow` skill |

Skills live in `.cursor/skills/` with SKILL.md + optional scripts/, references/, assets/.

## API Routes

All prefixed with `/api`:
- `GET /api/health` — service check
- `/api/customers`, `/api/users`, `/api/settings` — CRUD
- `/api/bitrix24/*` — Bitrix24 integration (deals, analytics, sync)
- `/api/schedule` — scheduled tasks
- `/api/assortment` — product catalog

---

**Last updated:** 2026-02-10
