# Cursor AI Rules — Instruction System for AI Agents in Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-12.1-blue" alt="Version">
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

## Library Contents

### Rules (13 files)

**Tier 1 — Always (1):** `core-master.mdc` — master protocol with KISS/YAGNI, Forbidden, Cross-check, Challenge, Confidence inline.

**Tier 2 — Auto (2):** react-hooks (*.tsx, *.jsx), radix-select (*.tsx)

**Tier 3 — Agent (10):** api-pagination, file-size-limits, basic-auth, agent-quality, freeze-recovery, error-learning, 4x _base-* modules

### Skills (12 directories)

| Skill | Purpose | Scripts |
|-------|---------|---------|
| `deploy-app` | Deploy backend/frontend | 4 scripts |
| `api-testing` | API auth testing | 2 scripts |
| `development` | Feature development (JTBD, TDD) | — |
| `bugfix` | Bug fixing (5 Whys RCA) | — |
| `refactoring` | Safe refactoring | — |
| `research` | Data analysis | — |
| `session-review` | Session quality review | — |
| `code-review` | QA + CTO Review | — |
| `tdd-workflow` | Test-Driven Development | — |
| `create-rules` | Creating rules/skills | — |
| `techdebt-scan` | Tech debt scan (explicit only) | 2 scripts |
| `gap-analysis` | Finding gaps/stubs | 1 script |

---

## Key Concepts

### KISS/YAGNI (inline in core-master)
Simplest solution always preferred. No code "for later". Check before abstracting.

### Challenge Protocol (inline)
4 questions before "done": disprove, files opened, edge cases, Job solved?

### RAT — Riskiest Assumption Test
Verify TOP-1 risk BEFORE coding.

---

## Self-Improvement

```
Error → session-review skill → improvements-backlog.md → @rules_alone/backlog-to-rules → New rule/skill
```

"Rule of Three": codify a rule after 3 repetitions of the same mistake.

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

## License

MIT License

## Links

- [GitHub Repository](https://github.com/dmitryprg-ai/cursor-develop-autorules)
- [Cursor IDE](https://cursor.com/)

---

**Version:** 12.1 | **Date:** 2026-02-10
