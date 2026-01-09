# 🤖 Cursor AI Rules — Instruction System for AI Agents in Cursor IDE

<p align="center">
  <img src="https://img.shields.io/badge/version-2.0-blue" alt="Version">
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
.cursor/
├── rules/                    # ⭐ Main instructions (21 files)
│   ├── core-master.mdc       # Single entry point (alwaysApply: true)
│   ├── _base-*.mdc           # Base modules (7 pcs)
│   ├── protocol-*.mdc        # Task-type protocols (7 pcs)
│   ├── standard-*.mdc        # Quality standards (5 pcs)
│   └── error-learning.mdc    # Error learning
│
└── rules_alone/              # 🎯 Standalone instructions (4 files)
    └── *.mdc                 # Called explicitly via @
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

### Step 1: Copy the folder

```bash
# Clone the repository
git clone https://github.com/YOUR_USERNAME/cursor-ai-rules.git

# Copy .cursor to your project
cp -r cursor-ai-rules/.cursor /path/to/your/project/
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

### 📦 Base Modules (7 items)

| Module | What it does |
|--------|--------------|
| `_base-confidence` | AI confidence calibration (deduction formula) |
| `_base-challenge` | 4 questions before "done" |
| `_base-crosscheck` | Independent result verification |
| `_base-forbidden` | Critical prohibitions |
| `_base-todo-usage` | TODO usage rules |
| `_base-5wh` | 5W+H format for analysis |
| `_base-jtbd-thinking` | JTBD thinking for user-facing features |

### 📋 Quality Standards (5 items)

| Standard | Purpose |
|----------|---------|
| `standard-agent-quality` | Success metrics and agent boundaries |
| `standard-qa` | QA acceptance criteria |
| `standard-rca` | Root Cause Analysis (5 Whys) |
| `standard-tdd` | Test-Driven Development |
| `standard-cto-review` | CTO/Lead Review for complex tasks |

### 🎯 Standalone Instructions (4 items)

Called explicitly via `@`:

```
@rules_alone/core-duplicate-check Check for duplicates before creating
@rules_alone/ajtbd-evaluation Evaluate the landing page
@rules_alone/backlog-to-rules Implement improvements from backlog
```

---

## 💡 Key Concepts

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

## 🔧 Project Customization

### Add a file for accumulating improvements

Create in project root:

```markdown
# {projectname}-improvements-backlog.md

## 📊 Statistics
- Total improvements: 0
- Implemented: 0

## 📝 Backlog
(entries will be added automatically)
```

### Configure project-specific checks

If you have project-specific checks, add them to `protocol-development.mdc`:

```markdown
### X.Y. [Your check]

**Input:** [When to apply]

**Output:** [What should be done]

**WHY:** [Real error case]
```

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

- [Cursor IDE](https://cursor.com/)
- [Cursor Docs — Large Codebases](https://cursor.com/docs/cookbook/large-codebases)

---

**Version:** 2.0  
**Date:** 2026-01-09

