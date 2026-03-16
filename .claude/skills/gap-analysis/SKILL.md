---
name: gap-analysis
description: "Find gaps, stubs, broken workflows, and incomplete features in code. Use before implementing features, for code audits, when checking TODO coverage, or when searching for buttons without handlers, forms without submit, links to nowhere, or partial CRUD implementations."
allowed-tools: Read, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# GAP Analysis

Find implicit requirements and incomplete code. 90% of AI failures come from specification gaps — what was never stated but silently assumed.

## Mode A: Planning (Before Implementation)

### Step 1: Explicit Requirements

List only what is explicitly stated. Quote the user's words.

### Step 2: Fit-Gap Analysis

| Category | Questions | Example Gaps |
|----------|-----------|-------------|
| **Data** | Formats? Null/empty? Boundaries? | max length, encoding, special chars |
| **UX** | Loading state? Error state? Empty state? | skeleton, retry button, placeholder |
| **Integration** | What else is affected? Side effects? | cache invalidation, events |
| **Security** | Access rights? Validation? | authorization, input sanitization |
| **Performance** | Data volume? Pagination? | batch limits, timeouts |
| **Errors** | What if it fails? Retry? | graceful degradation, error messages |

### Step 3: Pre-mortem

Ask: **"A week passed, the feature broke. Why?"**

Common answers: missed edge case, uncovered error scenario, forgot state handling, didn't check access rights.

### Step 4: Report

For HIGH gaps — ask the user, don't assume. Assumptions about critical gaps are the most dangerous kind of technical debt.

## Mode B: Codebase Scan

Run automated detection:
```bash
bash ${CLAUDE_SKILL_DIR}/scripts/scan-gaps.sh
```

Manual checks:

| Check | Pattern | Gap if |
|-------|---------|--------|
| Buttons without actions | `onClick={() => {}}` | Button does nothing |
| Forms without submit | `onSubmit` missing | Form doesn't send data |
| Links to nowhere | `href="#"` | Link leads nowhere |
| Loading without timeout | `isLoading` without error | May hang forever |
| Empty catches | `catch {}` | Error swallowed |
| Partial CRUD | Create but no Update/Delete | Incomplete |

## Gap Severity

| Severity | Criteria | Action |
|----------|----------|--------|
| HIGH | Feature doesn't work without it | Blocker — fix before implementation |
| MED | Works but bad UX/quality | Fix during implementation |
| LOW | Nice-to-have | Backlog or ask user |

## Key Principle

Before creating anything new:
1. `rg "X"` — maybe it already exists?
2. `rg "TODO.*X"` — maybe there's a stub?
3. Check UI — maybe button exists but doesn't work?

If a stub exists, complete it instead of creating a duplicate.
