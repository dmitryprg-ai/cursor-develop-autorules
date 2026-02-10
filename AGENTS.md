# AGENTS.md — crmai Project

> Supplementary context for AI agents. Primary config: `CLAUDE.md`.

## Production Services

| Service | Purpose | Port | Restart |
|---------|---------|------|---------|
| `crmai.service` | Backend (Node.js) | 5003 | `sudo systemctl restart crmai` |
| `crmai-web.service` | Frontend (Next.js) | 3001 | `sudo systemctl restart crmai-web` |

**BUILD БЕЗ RESTART = СЛОМАННЫЙ САЙТ** — всегда restart после build. Use `deploy-app` skill.

## Key Files

| File | Purpose |
|------|---------|
| `src/index.ts` | Backend entry point |
| `src/modules/bitrix24/bitrix24.routes.ts` | Main Bitrix24 router |
| `src/modules/bitrix24/routes/` | Modular routes (deals, analytics) |
| `apps/web/lib/api.ts` | Main API client |
| `apps/web/lib/api/` | Modular API clients |
| `db/init.sql` | Database schema |

## Chat System Messages (Open Lines)

- `=== Исходящее сообщение ===` — ALWAYS from company (is_manager=true)
- Format: `=== Исходящее сообщение, автор: <source> ===`
- Sources: `Битрикс24 (ManagerName)`, `Телефон`, `WhatsApp`
- **Rule**: check message TEXT (`startsWith`), not just DB fields

## Architecture v12.0: Rules + Skills Hybrid

### Rules (13 files) — Constraints
- 1 always-apply: `core-master.mdc` v5.0
- 2 auto (globs): react-hooks, radix-select
- 10 agent-decided: api-pagination, file-size-limits, basic-auth, agent-quality, 4x _base-*, error-learning, freeze-recovery

### Skills (12 directories) — Workflows
- `deploy-app` — deploy with shell scripts
- `api-testing` — API auth testing with scripts
- `development` — feature development + prompt preparation
- `bugfix` — bug fixing with 5 Whys RCA
- `refactoring` — safe refactoring with TDD
- `research` — data analysis
- `session-review` — session quality review
- `code-review` — QA + CTO review
- `tdd-workflow` — Test-Driven Development
- `create-rules` — creating rules and skills
- `techdebt-scan` — tech debt scanning with scripts (explicit /techdebt-scan only)
- `gap-analysis` — finding gaps and stubs with scripts

### rules_alone (5 files) — Manual @ mention
- ajtbd-evaluation, backlog-to-rules, core-duplicate-check, fix-last-task, from-the-end

---

**Last updated:** 2026-02-10 | **Version:** 3.0
