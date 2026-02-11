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

## Architecture v12.2: Rules + Skills Hybrid + Claude Code Support

### Rules (16 files) — Constraints
- 1 always-apply: `core-master.mdc` v5.1
- 3 auto (globs): react-hooks, radix-select, error-handling
- 12 agent-decided: api-pagination, file-size-limits, basic-auth, agent-quality, security, git-workflow, 4x _base-*, error-learning, freeze-recovery

### Skills (13 directories) — Workflows
- `deploy-app` — deploy with shell scripts
- `api-testing` — API auth testing with scripts
- `development` — feature development + prompt preparation
- `bugfix` — bug fixing with 5 Whys RCA
- `refactoring` — safe refactoring with TDD
- `research` — data analysis (SQL/TypeScript/Python)
- `session-review` — session quality review
- `code-review` — QA + CTO review
- `tdd-workflow` — Test-Driven Development
- `create-rules` — creating rules and skills
- `techdebt-scan` — tech debt scanning with scripts (explicit /techdebt-scan only)
- `gap-analysis` — finding gaps and stubs with scripts
- `fix-last-task` — analyze and fix issues in completed tasks

### rules_alone (4 files) — Manual @ mention
- ajtbd-evaluation, backlog-to-rules, core-duplicate-check, from-the-end

### Claude Code Support (.claude/)
- `.claude/settings.json` — permissions (allow/deny) + hooks (PreToolUse, PostToolUse)
- `.claude/rules/` — converted rules in .md format with path scoping
- `.claude/agents/` — 5 custom subagents: deploy, reviewer, researcher, tester, developer
- `scripts/migrate-to-claude-code.sh` — automated migration script
- `scripts/validate-rules.sh` — cross-reference and integrity validation

### Data Directory
- `.cursor/data/error-log.md` — error learning records
- `.cursor/data/improvements-backlog.md` — improvement proposals

---

**Last updated:** 2026-02-11 | **Version:** 4.0
