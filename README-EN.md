# Cursor AI Rules — Instruction System for AI Agents in Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-12.2-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/claude--code-supported-purple" alt="Claude Code">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **A hybrid Rules + Skills system for AI agents in Cursor IDE and Claude Code with token budget optimization, executable scripts, and self-improvement**

---

## What is this?

An instruction library for AI assistants in [Cursor IDE](https://cursor.com/) and [Claude Code](https://docs.anthropic.com/en/docs/claude-code):

- **14 skills** for different task types with shell scripts
- **16 rules** — built-in checks (Cross-check, Challenge, DONE block)
- **3-tier loading** system (~2,500 always tokens instead of ~21,000)
- **Self-improvement cycle** — learning from errors
- **Claude Code** support — `.claude/` with subagents, permissions, hooks

| Metric | Before | After |
|---|---|---|
| Tasks without rework | ~50% | >80% |
| Repeated errors | ~30% | <10% |
| Always-apply tokens | ~21,000 | ~2,500 |

---

## Architecture v12.2

```
your-project/
├── .cursor/
│   ├── config/                        # project.config.json ← adapt here
│   ├── rules/                         # 16 rules (always/auto/agent)
│   ├── skills/                        # 14 skills + _shared/ (scripts, references)
│   ├── rules_alone/                   # 3 manual instructions (invoke via @)
│   ├── data/                          # Templates: error-log, improvements-backlog
│   ├── docs/                          # ARCHITECTURE, HOW-TO-USE, CHANGELOG
│   └── .secrets/                      # Credentials (gitignored)
├── .claude/                           # Claude Code (settings, 5 agents, 4 rules)
│
├── scripts/                           # validate-rules.sh, migrate-to-claude-code.sh
├── .cursorignore, .mcp.json
├── CLAUDE.md                          # Project context (auto-loaded)
└── AGENTS.md                          # Supplementary AI context
```

### Rules vs Skills

| | Rules | Skills |
|---|---|---|
| Purpose | "Don't do this" — constraints | "Do it this way" — procedures |
| Format | Single `.mdc` file | Directory: `SKILL.md` + scripts |
| Scripts | No | Yes — `.sh` files |
| Size | < 100 lines | 50–120 lines + extras |

---

## Quick Start

```bash
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git
cp -r cursor-develop-autorules/.cursor /path/to/your/project/
cp cursor-develop-autorules/{CLAUDE.md,AGENTS.md,.cursorignore} /path/to/your/project/
# Optional: cp -r cursor-develop-autorules/{.claude,scripts,.mcp.json} /path/to/your/project/

cd /path/to/your/project
cp .cursor/config/project.config.example.json .cursor/config/project.config.json
# Fill in: project_name, site_url, services, auth, verify_pages
# Edit CLAUDE.md and AGENTS.md for your project
```

Or ask the AI: *"I copied `.cursor/` from cursor-develop-autorules. Adapt `project.config.json`, `CLAUDE.md`, `AGENTS.md` for this project. Run `scripts/validate-rules.sh`."*

---

## User Guide

### What works automatically

**Always (every dialog):** `core-master.mdc` — complexity, plan, skill from Routing Table, checks, DONE block, KISS/YAGNI.

**When files are open:**

| Rule | When | What it does |
|---|---|---|
| `react-hooks-auto` | `*.tsx`, `*.jsx` | Correct hook order |
| `radix-select-auto` | `*.tsx` | Prevents `<SelectItem value="">` |
| `error-handling-auto` | `*.tsx`, `*.ts` | Error boundaries, loading/error states |

**Agent loads by situation:** api-pagination, file-size-limits, security, git-workflow, basic-auth, agent-quality, freeze-recovery, error-learning, _base-5wh, _base-jtbd, _base-rat, _base-todo-usage.

**Skills — by request context:**

| Your request | Skill |
|---|---|
| "Add a date filter" | `development` — JTBD + TDD |
| "The button is broken" | `bugfix` — 5 Whys RCA |
| "Simplify this service" | `refactoring` — tests → small steps |
| "Deploy changes" | `deploy-app` — build → restart → verify (scripts) |
| "Test this API" | `api-testing` — auth + test (scripts) |
| "Analyze the data" | `research` — schema → hypothesis |
| "Review the code" | `code-review` — QA + CTO review |
| "Write tests first" | `tdd-workflow` — Red → Green → Refactor |
| "Create a rule" | `create-rules` — template + naming |
| "Find unfinished work" | `gap-analysis` — TODO, empty handlers |
| "Rework the last task" | `fix-last-task` — RCA + rework |
| "Implement improvements" | `backlog-to-rules` — 7 phases |

### What to invoke manually

**Via `@` (rules_alone):**

| Invocation | What you get |
|---|---|
| `@ajtbd-evaluation` | JTBD analysis of a landing page/interface |
| `@core-duplicate-check` | Duplication check before creating a file |
| `@from-the-end` | "From the end" methodology for complex tasks |

**Via `/` (explicit-only skill):** `/techdebt-scan` — scan for oversized files, TODO/FIXME.

If the agent doesn't load a skill — say: "use the development skill".

---

### Config and universality

**All rules/skills are universal.** Project-specific values live only in `project.config.json`:

```json
{
  "project_name": "myproject",
  "site_url": "https://myproject.example.com",
  "services": { "backend": { "name": "myproject-api", "port": 5003 } }
}
```

Scripts read config via `_shared/load-config.sh` (works with `jq` or `python3` fallback).

**Secrets** — `.cursor/.secrets/` (gitignored). **Data** — `.cursor/data/` (error-log, improvements-backlog).

**Self-improvement:** Error → `session-review` → `improvements-backlog.md` → `@backlog-to-rules` → New rule.

**Validation:** `bash scripts/validate-rules.sh` — cross-references, frontmatter, placeholders, routing table.

---

### Installing on another project

**What to change:** `project.config.json`, `CLAUDE.md`, `AGENTS.md`, `.secrets/`.

**What NOT to change:** `rules/`, `skills/`, `rules_alone/` — they're universal.

```bash
cp -r .cursor CLAUDE.md AGENTS.md .cursorignore /path/to/project/
cd /path/to/project
cp .cursor/config/project.config.example.json .cursor/config/project.config.json
# Fill in config → done
```

Or ask the AI: *"Adapt `.cursor/` for this project, fill in config, describe the project in CLAUDE.md."*

---

## Full Contents

| Component | Count | Details |
|---|---|---|
| **Rules** | 16 | 1 always + 3 auto + 12 agent |
| **Skills** | 14 | 4 with shell scripts, 4 with references |
| **Rules Alone** | 3 | ajtbd-evaluation, duplicate-check, from-the-end |
| **Claude Code agents** | 5 | deploy, developer, researcher, reviewer, tester |
| **Shell scripts** | 9 | deploy (4), testing (2), scanning (3) |
| **Validation** | 2 | validate-rules.sh, migrate-to-claude-code.sh |

---

## FAQ

**Q: Do I need to write "use core-master.mdc"?** — No, it's automatic.

**Q: How to add a rule?** — "Create a rule for X" → `create-rules` skill.

**Q: How to deploy?** — "Deploy" → `deploy-app` with scripts.

**Q: How to invoke a manual instruction?** — `@filename` in your message.

**Q: How to check integrity?** — `bash scripts/validate-rules.sh`.

**Q: Claude Code supported?** — Yes. `.claude/` + `scripts/migrate-to-claude-code.sh`.

**Q: How to install on another project?** — Copy `.cursor/`, fill in config. Everything is universal.

---

## License

MIT License — [GitHub](https://github.com/dmitryprg-ai/cursor-develop-autorules) | [Cursor IDE](https://cursor.com/) | [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

**Version:** 12.2 | **Date:** 2026-02-11
