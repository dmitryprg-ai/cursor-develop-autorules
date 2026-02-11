# Cursor AI Rules — Instruction System for AI Agents in Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-12.2-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **A hybrid Rules + Skills system for AI agents in Cursor IDE with token budget optimization and executable scripts**

---

## What is this?

**Cursor AI Rules** is an instruction library for AI assistants in [Cursor IDE](https://cursor.com/):

- **Structures AI work** — skills for different task types
- **Improves quality** — built-in checks and verification
- **Optimizes tokens** — 3-tier rule loading system (~2,500 always tokens)
- **Automates workflows** — shell scripts in skills for deploy, testing, scanning
- **Accumulates experience** — learning from errors

---

## Results

| Metric | Before | After |
|--------|--------|-------|
| Tasks without rework | ~50% | >80% |
| Repeated errors | ~30% | <10% |
| Linter errors on delivery | ~15% | 0% |
| Always-apply tokens | ~21,000 | ~2,500 |

---

## Architecture v12.0: Rules + Skills Hybrid

```
your-project/
├── .cursor/
│   ├── docs/                         # Documentation
│   ├── rules/                        # Rules — constraints (13 files)
│   │   ├── core-master.mdc           # Tier 1: ALWAYS (only one)
│   │   ├── standard-*-auto.mdc       # Tier 2: AUTO (2, by globs)
│   │   └── *-agent.mdc, _base-*.mdc  # Tier 3: AGENT (10)
│   │
│   ├── skills/                       # Skills — workflows (12 directories)
│   │   ├── deploy-app/               # With shell scripts
│   │   ├── api-testing/              # With shell scripts
│   │   ├── development/              # With references/
│   │   ├── bugfix/, refactoring/, research/, session-review/
│   │   ├── code-review/              # With references/
│   │   ├── tdd-workflow/, create-rules/
│   │   ├── techdebt-scan/            # With scripts (explicit only)
│   │   └── gap-analysis/             # With scripts
│   │
│   ├── rules_alone/                  # Standalone instructions (5)
│   └── .secrets/                     # Secrets (gitignored)
│
├── .cursorignore                     # Context exclusions
├── CLAUDE.md                         # Lean project context
└── AGENTS.md                         # Supplementary AI context
```

### Rules vs Skills

| Aspect | Rules | Skills |
|--------|-------|--------|
| What | Constraints, invariants | Procedural workflows |
| Format | Single .mdc file | Directory with SKILL.md + scripts/ |
| Scripts | No | Yes (shell, python, etc.) |
| Loading | Always / Auto / Agent | Agent-decided or /skill-name |
| Examples | "Don't use value='' in Select" | "Feature development protocol" |

### How it works

```
Your request
    ↓
core-master.mdc (automatic)
  ├── Complexity 🟢/🟡/🔴
  ├── Plan → Skill from Routing Table
  ├── Execute (KISS/YAGNI inline)
  ├── Verify (Forbidden + Cross-check + Challenge inline)
  └── DONE block
    ↓
*.tsx open? → react-hooks, radix-select (auto)
    ↓
Agent loads relevant skills and rules by description
```

---

## Quick Start

### Step 1: Copy to your project

```bash
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git
cp -r cursor-develop-autorules/.cursor /path/to/your/project/
cp cursor-develop-autorules/AGENTS.md /path/to/your/project/
cp cursor-develop-autorules/.cursorignore /path/to/your/project/
```

### Step 2: Configure config and AGENTS.md

1. Edit `.cursor/config/project.config.json` — specify URL, services, paths
2. Edit `AGENTS.md` — specify project structure
3. Create `.cursor/.secrets/` with credentials (if deploy/testing skills are needed)

### Step 3: Done!

Start working. Instructions apply automatically.

---

## User Guide

### What works automatically (no action needed)

These instructions load on their own. You don't need to write, call, or remember anything.

**Always active:**

| Rule | What it ensures |
|------|----------------|
| `core-master.mdc` | Determines task complexity, requires a plan, enforces checks, DONE block. Routes to the right skill. Enforces KISS/YAGNI. |

**Activates when specific file types are open:**

| Rule | When | What it ensures |
|------|------|----------------|
| `standard-react-hooks-auto.mdc` | `*.tsx` or `*.jsx` is open | Hooks are called in correct order, before early returns |
| `standard-radix-select-auto.mdc` | `*.tsx` is open | Prevents `<SelectItem value="">` (causes crash) |

**Agent loads on its own (by situation):**

| Rule | When the agent loads it |
|------|------------------------|
| `standard-api-pagination-agent.mdc` | Code with API pagination is being written |
| `standard-file-size-limits-agent.mdc` | A large file is being created or modified |
| `workflows-site-basic-auth-agent.mdc` | Got 401 when checking a page |
| `standard-agent-quality.mdc` | Task verification phase |
| `protocol-freeze-recovery.mdc` | Agent is stuck or looping |
| `error-learning.mdc` | An error occurred, analysis needed |
| `_base-5wh.mdc` | Structured problem analysis needed |
| `_base-jtbd-thinking.mdc` | User-facing feature is being developed |
| `_base-rat.mdc` | Planning a complex task (risk assessment) |
| `_base-todo-usage.mdc` | Task needs decomposition into steps |

**The agent also automatically loads skills based on your request context:**

| Your request | Which skill activates |
|--------------|----------------------|
| "Add a date filter" | `development` — full dev cycle with JTBD and TDD |
| "The save button is broken" | `bugfix` — 5 Whys analysis, root cause fix |
| "Simplify this service" | `refactoring` — tests before changes, small steps |
| "Deploy the changes" | `deploy-app` — build, restart, verify via shell scripts |
| "Test this API" | `api-testing` — auth and testing via scripts |
| "Analyze data from CSV" | `research` — schema first, then hypothesis |
| "Review the code quality" | `code-review` — QA checklist and CTO review |
| "Write tests first" | `tdd-workflow` — Red → Green → Refactor |
| "Create a new rule" | `create-rules` — template, naming, token budget |
| "Find unfinished features" | `gap-analysis` — scanning for TODO, empty handlers |

---

### What you need to invoke manually

**Manual instructions** (`rules_alone/`) — invoked via `@` in your message:

| How to invoke | When to use | What you get |
|---------------|-------------|-------------|
| `@ajtbd-evaluation` | Want to evaluate a landing page or interface | Full JTBD analysis: Job Stories, benefits/taxes, conversion assessment |
| `@backlog-to-rules` | Improvements accumulated, time to implement | 7-phase protocol for implementing from backlog |
| `@core-duplicate-check` | Before creating a new file/class/function | Duplication check with confidence matrix |
| `@fix-last-task` | Last task was done poorly | Analysis + rework with RCA and session review |
| `@from-the-end` | Complex task, want to start from the result | "From the end" methodology: expected output first |

**Example:** type `Analyze our landing page @ajtbd-evaluation` — the agent loads the instruction and runs a full JTBD analysis.

**Explicit-only skill:**

| How to invoke | What you get |
|---------------|-------------|
| `/techdebt-scan` | Project scan: oversized files, TODO/FIXME, code smells. Runs shell scripts. |

---

### How Skills differ from Rules

| | Rules | Skills |
|---|---|---|
| **What they are** | Short constraints and standards | Step-by-step work procedures |
| **Format** | Single `.mdc` file | Directory: `SKILL.md` + scripts + reference materials |
| **Can run scripts** | No | Yes — real `.sh` files |
| **Size** | Compact (< 100 lines) | Detailed (50–106 lines) + additional files |
| **Metaphor** | Safety regulations: "don't do this" | User manual: "do it this way" |
| **Rule example** | "Hooks only before early return" | — |
| **Skill example** | — | "How to deploy: build → restart → verify → check logs" |

**When each is used:**
- **Rule** — if violation causes a bug. "Don't do X" → Rule.
- **Skill** — if a step-by-step procedure is needed. "How to do Y" → Skill.

---

### What else you need to know

**1. Config — single source for project-specific values**

`.cursor/config/project.config.json` contains the site URL, service names, ports, secrets paths, pages to verify. All scripts read values from it. Rules and skills **contain zero hardcoded values** — they are universal for any project.

**2. Secrets — credentials**

`.cursor/.secrets/` contains password files (Basic Auth, test user). The folder is gitignored.

**3. Shared loader — common config loader for scripts**

`.cursor/skills/_shared/load-config.sh` is sourced by all scripts. Provides `PROJECT_ROOT`, `SITE_URL`, `BASIC_AUTH` variables and the `json_get` function. Works with `jq` or `python3` as fallback.

**4. Self-improvement cycle**

```
Error → session-review skill → improvements-backlog.md → @backlog-to-rules → New rule/skill
```

"Rule of Three": codify a rule after 3 repetitions of the same mistake.

**5. Documentation (`.cursor/docs/`)**

| File | Contents |
|------|----------|
| `ARCHITECTURE.md` | Technical architecture of rules and skills |
| `HOW-TO-USE.md` | Detailed usage guide |
| `CHANGELOG.md` | Full change history |

---

## Full Library Contents

### Rules — 13 files

**Tier 1 — Always (1):** `core-master.mdc` — master protocol with KISS/YAGNI, Forbidden, Cross-check, Challenge, Confidence inline.

**Tier 2 — Auto (2):**

| File | Globs | What it does |
|------|-------|-------------|
| `standard-react-hooks-auto.mdc` | *.tsx, *.jsx | Hook order enforcement |
| `standard-radix-select-auto.mdc` | *.tsx | Prevents empty value="" |

**Tier 3 — Agent (10):** api-pagination, file-size-limits, basic-auth, agent-quality, freeze-recovery, error-learning, 4x _base-* modules

### Skills — 12 directories

| Skill | Purpose | Scripts |
|-------|---------|---------|
| `deploy-app` | Deploy backend/frontend | deploy-backend.sh, deploy-frontend.sh, deploy-all.sh, verify-pages.sh |
| `api-testing` | API auth testing | get-session.sh, test-endpoint.sh |
| `development` | Feature development (JTBD, TDD) | — |
| `bugfix` | Bug fixing (5 Whys RCA) | — |
| `refactoring` | Safe refactoring | — |
| `research` | Data analysis | — |
| `session-review` | Session quality review | — |
| `code-review` | QA + CTO Review | — |
| `tdd-workflow` | Test-Driven Development | — |
| `create-rules` | Creating rules/skills | — |
| `techdebt-scan` | Tech debt scan (explicit only) | scan-large-files.sh, find-todos.sh |
| `gap-analysis` | Finding gaps/stubs | scan-gaps.sh |

### Rules Alone — 5 manual instructions

`ajtbd-evaluation`, `backlog-to-rules`, `core-duplicate-check`, `fix-last-task`, `from-the-end`

### .cursorignore

Excludes from AI context: `dist/`, `node_modules/`, `.next/`, `.git/`, secrets.

---

## What's New in v12.1

- **Project Config**: `.cursor/config/project.config.json` — single source for all project-specific values
- **Full Universality**: Zero hardcoded values in rules/skills — all project-specific in config
- **Skills Architecture**: 12 skills with SKILL.md format, progressive disclosure
- **Executable Scripts**: 4 skills with config-driven shell scripts (deploy, testing, scanning)
- **References/Assets**: 4 skills with reference materials
- **Rules → Skills Migration**: 14 rules converted to 12 skills
- **Easy Setup**: Copy `.cursor/`, edit `config/project.config.json` — done

---

## FAQ

**Q: Do I need to write "use core-master.mdc"?**
A: No, `core-master.mdc` applies automatically to every request.

**Q: How do I add a new rule or skill?**
A: Say "create a rule for X" — the agent will load the `create-rules` skill with a template and naming convention.

**Q: How do I deploy?**
A: Say "deploy" — the agent will load the `deploy-app` skill and run the appropriate scripts.

**Q: How do I invoke a manual instruction?**
A: Type `@filename` in your message. For example: `@fix-last-task`.

**Q: How do I scan for tech debt?**
A: Use `/techdebt-scan` — it's an explicit-only skill, it won't activate automatically.

**Q: How do I use this in another project?**
A: Copy `.cursor/`, edit `config/project.config.json`. All rules/skills are universal.

**Q: The agent doesn't load the right skill — what do I do?**
A: Mention it explicitly: "use the development skill" or describe your task more precisely.

---

## License

MIT License

## Links

- [GitHub Repository](https://github.com/dmitryprg-ai/cursor-develop-autorules)
- [Cursor IDE](https://cursor.com/)

---

**Version:** 12.1 | **Date:** 2026-02-10
