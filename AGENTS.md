# AGENTS.md — crmai Project

> Supplementary context for AI agents. Primary config: `CLAUDE.md`.

## Production Services

| Service | Purpose | Port | Restart |
|---------|---------|------|---------|
| `crmai.service` | Backend (Node.js) | 5003 | `sudo systemctl restart crmai` |
| `crmai-web.service` | Frontend (Next.js) | 3001 | `sudo systemctl restart crmai-web` |

**BUILD WITHOUT RESTART = BROKEN SITE** — always restart after build. Use `deploy-app` skill.

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

## Architecture v13.0: Dual IDE Support (Cursor + Claude Code)

### Claude Code (.claude/) — Primary

#### Rules (10 files) — Constraints
- 2 always-loaded (no paths/description): `core-master.md`, `file-size-limits.md`
- 4 path-scoped: `error-handling.md`, `react-hooks.md`, `radix-select.md`, `security.md`
- 4 agent-decided (description): `api-pagination.md`, `git-workflow.md`, `error-learning.md`, `jtbd-thinking.md`

#### Skills (15 directories) — Workflows
- `deploy-app` — deploy with shell scripts + verification
- `api-testing` — API auth testing with scripts
- `development` — feature development + JTBD + duplicate check
- `bugfix` — bug fixing with 5 Whys RCA
- `refactoring` — safe refactoring with TDD
- `research` — data analysis (SQL/TypeScript/Python)
- `session-review` — session quality review + retrospective
- `code-review` — QA + CTO review (read-only)
- `tdd-workflow` — Test-Driven Development
- `create-rules` — creating/improving rules, skills, and evals (aligned with official skill-creator)
- `techdebt-scan` — tech debt scanning (explicit /techdebt-scan only)
- `gap-analysis` — finding gaps and stubs with scripts
- `fix-last-task` — analyze and fix issues in completed tasks
- `backlog-to-rules` — implement improvements from backlog
- `cache-analysis` — prompt cache efficiency and cost analysis (claude-cache-analyzer)

#### Agents (5 subagents)
| Agent | Skills | Model | Key Feature |
|-------|--------|-------|-------------|
| `developer` | development, tdd-workflow | sonnet | JTBD + duplicate check |
| `reviewer` | code-review | sonnet | Read-only (disallowed: Write, Edit, Bash) |
| `researcher` | research | sonnet | Data-first analysis |
| `tester` | tdd-workflow | sonnet | Strict Red-Green-Refactor |
| `deploy` | deploy-app | haiku | Fast build + restart |

#### Other Claude Code Files
- `.claude/settings.json` — permissions (allow/deny) + hooks (PostToolUse)
- `.claude/launch.json` — dev server preview (backend:5003, frontend:3001)
- `.claude/MEMORY.md` — learned patterns and project knowledge

### Cursor IDE (.cursor/) — Legacy

#### Rules (16 files .mdc)
- 1 always-apply: `core-master.mdc` v5.1
- 3 auto (globs): react-hooks, radix-select, error-handling
- 12 agent-decided

#### Skills (13 directories)
Same skills as Claude Code but in Cursor format.

### Data Directory
- `.cursor/data/error-log.md` — error learning records
- `.cursor/data/improvements-backlog.md` — improvement proposals

---

**Last updated:** 2026-03-13 | **Version:** 5.1
