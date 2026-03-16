# AI Rules — Instruction System for AI Agents (Cursor IDE + Claude Code)

<p align="center">
  <img src="https://img.shields.io/badge/version-13.0-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/claude--code-native-purple" alt="Claude Code Native">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **A complete dual-IDE rules and skills system for AI agents: Cursor IDE (.cursor/) and Claude Code (.claude/) with subagents, automatic checks, skill quality evaluation, and a self-improvement cycle**

---

## What is this?

An instruction library for AI assistants in [Cursor IDE](https://cursor.com/) and [Claude Code](https://docs.anthropic.com/en/docs/claude-code):

- **15 skills** for any task — from development to deployment and cache analytics
- **10 rules** for Claude Code — contextual constraints with "why" explanations
- **5 subagents** (developer, reviewer, researcher, tester, deploy) with linked skills
- **Automatic quality evaluation** — evals with assertions for every skill
- **Self-improvement cycle** — learning from errors → new rules
- **Skill-creator methodology** — skills built per [official Anthropic plugin](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/skill-creator)

| Metric | Before (v12) | After (v13) |
|---|---|---|
| Tasks without rework | ~50% | >80% |
| Repeated errors | ~30% | <10% |
| Skill eval coverage | 0% | 100% |
| Skill-creator compliance | ~20% | 100% |

---

## Architecture v13.0

```
your-project/
├── .claude/                           # Claude Code — primary environment
│   ├── settings.json                  # Permissions (allow/deny) + hooks
│   ├── launch.json                    # Dev servers for Preview
│   ├── MEMORY.md                      # Accumulated project patterns
│   ├── agents/                        # 5 subagents (deploy, developer, ...)
│   ├── rules/                         # 10 rules (.md with YAML frontmatter)
│   └── skills/                        # 15 skills (SKILL.md + scripts/ + evals/)
│       ├── deploy-app/                #   Deploy: build → restart → verify
│       ├── development/               #   Development: JTBD + TDD
│       ├── bugfix/                    #   Bug fixing: 5 Whys RCA
│       ├── code-review/               #   Review: QA + CTO
│       ├── tdd-workflow/              #   TDD: Red → Green → Refactor
│       ├── refactoring/               #   Refactoring: tests → small steps
│       ├── research/                  #   Analytics: SQL/TypeScript/Python
│       ├── api-testing/               #   API tests: auth + curl scripts
│       ├── session-review/            #   Retrospective: end of session
│       ├── gap-analysis/              #   Gap scanning: TODO, stubs
│       ├── techdebt-scan/             #   Tech debt: files, TODO/FIXME
│       ├── create-rules/              #   Creating rules and skills (skill-creator)
│       ├── fix-last-task/             #   Rework: RCA + fix
│       ├── backlog-to-rules/          #   Implementing improvements from backlog
│       ├── cache-analysis/            #   Cache analysis: cost, efficiency
│       └── _shared/                   #   Shared scripts (load-config.sh)
│
├── .cursor/                           # Cursor IDE — parallel configuration
│   ├── config/                        # project.config.json ← adapt here
│   ├── rules/                         # 16 rules (.mdc: always/auto/agent)
│   ├── skills/                        # 13 skills (Cursor format)
│   ├── rules_alone/                   # 3 manual instructions (invoke via @)
│   ├── data/                          # error-log, improvements-backlog
│   └── .secrets/                      # Credentials (gitignored)
│
├── CLAUDE.md                          # Project context (auto-loaded)
├── AGENTS.md                          # Supplementary AI context
└── scripts/                           # validate-rules.sh
```

### What's new in v13

| Aspect | v12 | v13 |
|---|---|---|
| Claude Code | 4 rules, 0 skills | 10 rules, 15 skills, 5 agents |
| Skills style | Rigid instructions | "Why" > "Don't" (skill-creator) |
| Skill descriptions | Generic | Contextual triggers (pushy) |
| Quality evaluation | None | Evals with assertions for every skill |
| Cache analytics | None | cache-analysis (hit rate, cost, grade) |
| Dev Preview | None | launch.json (backend + frontend) |
| Project memory | None | MEMORY.md — accumulated patterns |

---

## Quick Start

### For Claude Code (recommended)

```bash
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git
cp -r cursor-develop-autorules/.claude /path/to/your/project/
cp cursor-develop-autorules/{CLAUDE.md,AGENTS.md} /path/to/your/project/

# Edit CLAUDE.md and AGENTS.md for your project
# Edit .claude/MEMORY.md — describe your architecture and key patterns
```

### For Cursor IDE

```bash
cp -r cursor-develop-autorules/.cursor /path/to/your/project/
cp cursor-develop-autorules/{CLAUDE.md,AGENTS.md,.cursorignore} /path/to/your/project/

cd /path/to/your/project
cp .cursor/config/project.config.example.json .cursor/config/project.config.json
# Fill in: project_name, site_url, services, auth, verify_pages
```

### For both (dual-IDE)

```bash
cp -r cursor-develop-autorules/{.cursor,.claude,CLAUDE.md,AGENTS.md,.cursorignore,scripts} /path/to/your/project/
```

Or ask the AI: *"I copied `.cursor/` and `.claude/` from cursor-develop-autorules. Adapt the configuration for this project."*

---

## User Guide

### How it works

**The master protocol** (`core-master`) loads in every dialog and automatically:
1. Evaluates task complexity (SIMPLE / STANDARD / COMPLEX)
2. Selects a skill from the Routing Table
3. Runs checks (Cross-check, Challenge)
4. Produces a DONE block with confidence level

**Rules** activate based on context — when working with specific files or by agent decision.

### Skills — by request context

| Your request | Skill | What it does |
|---|---|---|
| "Add a date filter" | `development` | JTBD analysis + TDD + duplicate check |
| "The button is broken" | `bugfix` | 5 Whys RCA → fix → verification |
| "Simplify this service" | `refactoring` | Tests → small steps → verification |
| "Deploy changes" | `deploy-app` | build → restart → health check (scripts) |
| "Test this API" | `api-testing` | Auth + curl tests (scripts) |
| "Analyze the data" | `research` | Schema → hypothesis → SQL/TS/Python |
| "Review the code" | `code-review` | QA + CTO review (read-only) |
| "Write tests first" | `tdd-workflow` | Red → Green → Refactor |
| "Create a rule" | `create-rules` | Template + evals + validation |
| "Find unfinished work" | `gap-analysis` | Scan for TODO, empty handlers |
| "Rework the last task" | `fix-last-task` | RCA + fix + improvement |
| "Implement improvements" | `backlog-to-rules` | Grouping → implementation → status updates |
| "Show session costs" | `cache-analysis` | Hit rate, savings, grade A–F |

**Via `/` (explicit invocation):** `/techdebt-scan` — scan for oversized files, TODO/FIXME.

If the agent doesn't load a skill — say: *"use the development skill"*.

### Claude Code subagents

| Agent | Skills | Model | Key feature |
|---|---|---|---|
| `developer` | development, tdd-workflow | sonnet | JTBD + duplicate check |
| `reviewer` | code-review | sonnet | Read-only (no Write/Edit/Bash) |
| `researcher` | research | sonnet | Data-first analysis |
| `tester` | tdd-workflow | sonnet | Strict Red-Green-Refactor |
| `deploy` | deploy-app | haiku | Fast build + restart |

### Cursor IDE: manual instructions

**Via `@` (rules_alone):**

| Invocation | What you get |
|---|---|
| `@ajtbd-evaluation` | JTBD analysis of a landing page/interface |
| `@core-duplicate-check` | Duplication check before creating a file |
| `@from-the-end` | "From the end" methodology for complex tasks |

---

### Config and universality

**All rules and skills are universal.** Project-specific values live only in `project.config.json` (Cursor) or `MEMORY.md` (Claude Code).

Scripts read config via `_shared/load-config.sh` (works with `jq` or `python3` fallback).

**Self-improvement:** Error → `session-review` → `improvements-backlog.md` → `backlog-to-rules` → New rule.

---

### Installing on another project

**What to change:** `CLAUDE.md`, `AGENTS.md`, `.claude/MEMORY.md`, `project.config.json`, `.secrets/`.

**What NOT to change:** `rules/`, `skills/`, `agents/` — they're universal.

Or ask the AI: *"Adapt the configuration for this project — fill in CLAUDE.md, MEMORY.md, config."*

---

## Full Contents

| Component | Count | Details |
|---|---|---|
| **Claude Code rules** | 10 | 2 always + 4 path-scoped + 4 agent-decided |
| **Claude Code skills** | 15 | With evals, scripts, references |
| **Claude Code agents** | 5 | deploy, developer, researcher, reviewer, tester |
| **Cursor rules** | 16 | 1 always + 3 auto + 12 agent (.mdc) |
| **Cursor skills** | 13 | Cursor format |
| **Cursor rules_alone** | 3 | ajtbd-evaluation, duplicate-check, from-the-end |
| **Shell scripts** | 9+ | deploy (4), testing (2), scanning (3), cache (1) |
| **Evals** | 15 | 2–3 test cases per skill with assertions |

---

## FAQ

**Q: Does it work automatically?** — Yes, the master protocol loads in every dialog.

**Q: How to add a rule or skill?** — *"Create a rule for X"* → `create-rules` skill (using skill-creator methodology).

**Q: How to deploy?** — *"Deploy"* → `deploy-app` skill with shell scripts.

**Q: How to check cache efficiency?** — *"Show session costs"* → `cache-analysis` skill.

**Q: Claude Code or Cursor?** — Both supported. `.claude/` — native support with agents, hooks, and preview. `.cursor/` — full configuration for Cursor IDE.

**Q: How to install on another project?** — Copy `.claude/` and/or `.cursor/`, adapt `CLAUDE.md` and `MEMORY.md`.

**Q: What are evals?** — Test cases for evaluating skill quality. Each skill has `evals/evals.json` with 2–3 prompts and assertions.

---

## License

MIT License — [GitHub](https://github.com/dmitryprg-ai/cursor-develop-autorules) | [Cursor IDE](https://cursor.com/) | [Claude Code](https://docs.anthropic.com/en/docs/claude-code)

**Version:** 13.0 | **Date:** 2026-03-13
