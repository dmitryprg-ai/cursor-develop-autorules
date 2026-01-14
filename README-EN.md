# 🤖 Cursor AI Rules — Instruction System for AI Agents in Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-8.1-blue" alt="Version">
  <img src="https://img.shields.io/badge/cursor-compatible-green" alt="Cursor Compatible">
  <img src="https://img.shields.io/badge/license-MIT-yellow" alt="License">
</p>

> **A modular system of rules and protocols to improve AI agent quality in Cursor IDE**

---

## 🎯 What is this?

**Cursor AI Rules** is a ready-to-use instruction library for AI assistants in [Cursor IDE](https://cursor.com/) that:

- 📋 **Structures AI work** — clear protocols for different task types
- 🔍 **Improves quality** — built-in checks and result verification
- 📊 **Calibrates confidence** — AI honestly evaluates the reliability of its conclusions
- 🔄 **Accumulates experience** — learning from errors to prevent repetition
- ✅ **Ensures verification** — Challenge protocol and Cross-check before completion

---

## 📈 What results will you get?

| Metric | Before | After | Improvement |
|--------|--------|-------|-------------|
| Tasks without rework | ~50% | >80% | **+30%** |
| Repeated errors | ~30% | <10% | **-20%** |
| Linter errors on delivery | ~15% | 0% | **-15%** |
| Missed edge cases | frequent | rare | **↓↓↓** |

### Real improvement examples:

**Before:**
```
AI: "Done! Component created."
Reality: File created but not opened. Has syntax errors. Linter not checked.
```

**After:**
```
AI: "Confidence: 95% → 45% — code written, but not tested"
    → Runs the code
    → Cross-check completed
    → Challenge protocol passed
    "Confidence: 92% — everything verified"
    
    ✅ COMPLETION REPORT
    Protocol: protocol-development.mdc
    Standards: standard-tdd.mdc
    Base Modules: _base-confidence, _base-challenge, _base-crosscheck
```

---

## 🏗️ Architecture

```
your-project/
├── .cursor/                       # ⭐ Universal instructions
│   ├── CHANGELOG.md               # Change history
│   ├── rules/                     # Main instructions (24 files)
│   │   ├── core-master.mdc        # Single entry point (alwaysApply: true)
│   │   ├── _base-*.mdc            # Base modules (8 pcs)
│   │   ├── protocol-*.mdc         # Task-type protocols (7 pcs)
│   │   ├── standard-*.mdc         # Quality standards (5 pcs)
│   │   └── error-learning.mdc     # Error learning
│   │
│   └── rules_alone/               # Standalone instructions (4 files)
│       └── *.mdc                  # Called explicitly via @
│
├── .cursor_additional/            # 📁 Project-specific files
│   └── {projectname}/             # Folder for your project
│       ├── improvements-backlog.md # Improvement accumulation
│       └── error-log.md           # Error logs
│
└── AGENTS.md                      # Quick Start for AI agents
```

### How it works:

```
Your request
    ↓
core-master.mdc (determines complexity and type)
    ↓
protocol-*.mdc (executes the task)
    ↓
_base-*.mdc (applies checks)
    ↓
standard-*.mdc (verifies quality)
    ↓
✅ COMPLETION REPORT
```

---

## 🚀 Quick Start

### Step 1: Copy files to your project

```bash
# Clone the repository
git clone https://github.com/dmitryprg-ai/cursor-develop-autorules.git

# Copy .cursor and AGENTS.md to your project
cp -r cursor-develop-autorules/.cursor /path/to/your/project/
cp cursor-develop-autorules/AGENTS.md /path/to/your/project/
```

### Step 2: Done!

Just start working in Cursor IDE. Instructions are applied **automatically**.

```
Add a component to display statistics
```

AI will automatically:
1. Determine task complexity (Simple/Standard/Complex)
2. Choose the appropriate protocol
3. Apply checks and verifications
4. Output an execution report

---

## 📋 Library Contents

### 🔄 Protocols (7 items)

| Protocol | When to apply |
|----------|---------------|
| `protocol-prepare-prompt` | Improving user prompt before execution |
| `protocol-development` | Developing new features |
| `protocol-bugfix` | Fixing bugs |
| `protocol-refactoring` | Code refactoring |
| `protocol-research` | Data analysis (parquet, csv, SQL) |
| `protocol-freeze-recovery` | Recovery after AI freeze |
| `protocol-session-review` | Session analysis and improvement accumulation |

### 📦 Base Modules (8 items)

| Module | What it does |
|--------|--------------|
| `_base-confidence` | AI confidence calibration (deduction formula) |
| `_base-challenge` | 4 questions before "done" |
| `_base-crosscheck` | Independent result verification |
| `_base-forbidden` | Critical prohibitions |
| `_base-todo-usage` | TODO usage rules |
| `_base-5wh` | 5W+H format for analysis |
| `_base-jtbd-thinking` | JTBD thinking for user-facing features |
| `_base-rat` | **NEW:** Riskiest Assumption Test — verify risks BEFORE implementation |

### 📋 Quality Standards (6 items)

| Standard | Purpose |
|----------|---------|
| `standard-agent-quality` | Success metrics and agent boundaries |
| `standard-qa` | QA acceptance criteria |
| `standard-rca` | Root Cause Analysis (5 Whys) |
| `standard-tdd` | Test-Driven Development |
| `standard-cto-review` | CTO/Lead Review for complex tasks |
| `standard-file-size-limits` | **NEW:** File size control (< 300 lines) |

### 🎯 Standalone Instructions (4 items)

Called explicitly via `@`:

```
@rules_alone/core-duplicate-check Check for duplicates before creating
@rules_alone/ajtbd-evaluation Evaluate the landing page
@rules_alone/backlog-to-rules Implement improvements from backlog
```

---

## 💡 Key Concepts

### 0. RAT — Riskiest Assumption Test

Verify risky assumptions **BEFORE** starting implementation:

```
RAT = 3 steps:
1. List ALL assumptions
2. Rank by risk (what can "kill" the solution)
3. Verify TOP-1 risk BEFORE coding

If risk is disproved → revise the plan!
```

**Typical coding risks:**
- 🔧 Does the approach/library fit?
- 📊 Is data/API as expected?
- 🔗 Won't break existing code?

> Source: [Ivan Zamesin — RAT](https://zamesin.ru/books/product-howto/riskiest-assumption-test/)

### 1. Confidence Calibration

AI honestly evaluates the reliability of its conclusions:

```
Confidence = 100% minus:
• Code not tested: -50%
• Artifacts not opened: -40%
• No cross-check: -30%
• Assumptions not verified: -25%

Threshold: <80% = not ready
```

### 2. Challenge Protocol

Before each "done", AI asks itself 4 questions:

1. How can I disprove my conclusion?
2. Did I open ALL created files?
3. What edge cases did I miss?
4. Does this solve the user's real Job?

### 3. Cross-check

Verifying the result using a **different method**:

- File created → Open and read it
- API works → curl + code
- Data is correct → pandas + SQL

### 4. COMPLETION REPORT

At the end of each task, AI outputs a report:

```markdown
## ✅ COMPLETION REPORT

**Complexity:** 🟡 STANDARD

**Instructions used:**
- Protocol: protocol-development.mdc
- Standards: standard-tdd.mdc
- Base Modules: _base-confidence, _base-challenge, _base-crosscheck

**Final confidence:** 92%
```

---

## 🌍 Rule Universality (NEW in v4.0)

Rules are designed to work **in any project**. One `.cursor/rules/` set can be used across multiple projects without modifications.

### Principle: Separation of Universal and Project-Specific

| Universal (in `.cursor/rules/`) | Project-Specific (separate) |
|--------------------------------|----------------------------|
| Protocols and workflows | Project structure → `AGENTS.md` |
| Quality standards | Secrets (URLs, creds) → `.cursor/.secrets/` |
| Base checks | Lessons learned → `.cursor_additional/` |

### Examples in rules use placeholders:

```
✅ <ComponentName>.tsx     instead of   ❌ DealsTable.tsx
✅ <url>, <user>, <pass>   instead of   ❌ actual values
✅ "external API fields"   instead of   ❌ "Bitrix24 UF fields"
```

---

## 🔧 Project Customization

### Configure AGENTS.md

After copying, edit `AGENTS.md` for your project:
- Specify project structure
- Add build commands
- Describe code style
- **Add project specifics** (integrations, data types, workarounds)

### Create secrets folder (if needed)

```bash
mkdir -p .cursor/.secrets/
echo ".cursor/.secrets/" >> .gitignore
```

### Add project-specific checks to AGENTS.md

Add project checks to `AGENTS.md`, not to `.cursor/rules/`:

```markdown
## ⚠️ Important Project Notes

### [Integration Name]
- [Specificity 1]
- [Specificity 2]
- WHY: [Real error case]
```

---

## 🔄 Recording Failures and Self-Improvement

The system includes an error learning mechanism. When AI makes a mistake or the user points out a problem, it gets recorded and turned into new rules.

### How it works

```
Error detected
        ↓
Session Review (protocol-session-review.mdc)
        ↓
Record in improvements-backlog.md
        ↓
Implement via @rules_alone/backlog-to-rules
        ↓
New rule in instructions
        ↓
Error doesn't repeat ✅
```

### Step 1: Create a file for accumulating improvements

Create a folder and file for your project:

```bash
mkdir -p .cursor_additional/{projectname}/
```

Create file `.cursor_additional/{projectname}/improvements-backlog.md`:

```markdown
# 📋 IMPROVEMENTS BACKLOG

> **Project:** {projectname}

## 📊 STATISTICS
| Metric | Value |
|--------|-------|
| Total improvements | 0 |
| 🔴 High priority | 0 |
| ✅ Implemented | 0 |

## 🔴 HIGH PRIORITY
(entries will go here)

## ✅ IMPLEMENTED
(implemented improvements will go here)
```

### Step 2: Record errors after failures

When AI makes a mistake, record in backlog:

```markdown
---

### IMPROVEMENT #N: YYYY-MM-DD (Brief name)

**Source:** Session Review after [which task]

**Problem:**
[What went wrong]

**Root Cause:**
[Why it happened — 5 Whys if needed]

**Proposed change:**
```
[Specific text to add to instructions]
```

**File to modify:** `.cursor/rules/[file].mdc`

**Priority:** 🔴 High / 🟡 Medium / 🟢 Low
**Status:** 📝 Backlog

---
```

### Step 3: Implement improvements

When 2+ High priority improvements accumulate or a week passes:

```
@rules_alone/backlog-to-rules Implement accumulated improvements
```

AI will automatically:
1. Read the backlog
2. Group improvements by files
3. Add new sections to instructions
4. Update statuses in backlog (📝 → ✅)
5. Output a report

### Real improvement example

**Was:** AI created `.cursor` inside `git/`, although user said "I'll copy 2 folders myself"

**Recorded in backlog:**
```markdown
### IMPROVEMENT #11: Literal Request Following

**Problem:** AI interprets request instead of following literally

**Root Cause:** No explicit step to "write constraints verbatim"

**Proposed change:** Add Explicit Constraints section to protocol-prepare-prompt.mdc
```

**After implementation:** Now AI always writes explicit constraints from the request verbatim.

### When to run implementation

| Condition | Priority |
|-----------|----------|
| 5+ improvements accumulated | 🔴 Required |
| 2+ High priority exist | 🔴 Required |
| Week passed | 🟡 Recommended |
| Same error repeated 3+ times | 🔴 Immediately |

---

## 📊 Task Complexity Definition

| Complexity | Signs | Flow |
|------------|-------|------|
| 🟢 SIMPLE | 1-2 files, obvious result | EXECUTE → VERIFY |
| 🟡 STANDARD | New functionality, multiple files | Full 4-phase protocol |
| 🔴 COMPLEX | Architecture, critical data | + CTO Review + Session Review |

---

## ❓ FAQ

### Do I need to write "use core-master.mdc"?
**No.** Files with `alwaysApply: true` are applied automatically.

### Can I use this with other AI assistants?
The library is optimized for **Cursor IDE**, but the concepts are universal.

### How to add my own rules?
1. Create a file `protocol-your-name.mdc` or `_base-your-name.mdc`
2. Add a reference in `core-master.mdc`

### How to disable instructions?
Change `alwaysApply: true` to `false` in `core-master.mdc`.

---

## 🤝 Contributing

Welcome:
- 🐛 Bug reports
- 💡 Improvement suggestions
- 📝 New protocols and modules

---

## 📄 License

MIT License — use freely in any projects.

---

## 🔗 Links

- [GitHub Repository](https://github.com/dmitryprg-ai/cursor-develop-autorules)
- [Cursor IDE](https://cursor.com/)
- [Cursor Docs — Large Codebases](https://cursor.com/docs/cookbook/large-codebases)

---

**Version:** 8.1  
**Date:** 2026-01-14

---

## 🆕 What's New in v8.1

### File Size Limits Standard

New standard `standard-file-size-limits-always.mdc` (alwaysApply: true):

| File Type | Soft/Hard limit |
|-----------|-----------------|
| Routes/Controllers | 200/400 lines |
| Services | 250/500 lines |
| React components | 200/400 lines |

**Rules:**
- File > 300 lines = **splitting plan BEFORE adding code**
- Split by **business domains**, NOT by technical layers
- Use barrel exports (`index.ts`)

### Service Restart & Integration

**`protocol-development.mdc` v2.3:**
- RULE #5: Restart services after changes
- RULE #6: Follow file-size-limits standard
- PRE-ACTION: "Control File Size" step

**`protocol-refactoring.mdc` v1.2:**
- Workflow: "PREPLAN" step with file-size-limits reference
- Golden Rules: "RULES FIRST"

---

## 🆕 What's New in v8.0

### Universality Requirement

All rules are **fully universal** and work in any project:

- ❌ Removed project-specific references (Bitrix24, DealsTable, PostgreSQL bigint)
- ✅ Examples use placeholders (`<ComponentName>`, `<url>`)
- ✅ Project specifics moved to `AGENTS.md` and `.cursor/.secrets/`

---

## 🆕 What's New in v7.0

### STANDARD FORMAT COMPLIANCE

- All 22 files brought to unified standard
- description in ACTION-TRIGGER-OUTCOME format
- Structure: Context → Requirements → Examples → Critical Points
- XML tags: `<critical>`, `<required>`, `<example>`

---

## 🆕 What's New in v4.0

### Rule Universality

- Rules now work **in any project** without modifications
- Examples use placeholders (`<ComponentName>`, `<url>`)
- Project specifics moved to `AGENTS.md` and `.cursor/.secrets/`

### New Files

- `workflows-site-basic-auth-always.mdc` — universal Basic Auth rule
- `core-rules-standard-format-always.mdc` — rule generation standard

