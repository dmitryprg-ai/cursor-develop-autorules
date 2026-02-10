---
name: gap-analysis
description: Find gaps, stubs, broken workflows, and incomplete features in code. Use before implementing features (to find implicit requirements) or for code audits (to find TODO, FIXME, empty handlers, broken workflows). Keywords - gap analysis, audit, find stubs, incomplete, broken workflow.
---

# GAP Analysis

Find implicit requirements and incomplete code. 90% of AI failures are due to specification gaps.

## Mode A: Planning (Before Implementation)

### Step 1: Explicit Requirements

```markdown
## EXPLICIT REQUIREMENTS
**Task:** [one sentence]
**What's specified:**
- [ ] [requirement 1 -- quote]
- [ ] [requirement 2 -- quote]
**Constraints:** [limitations]
```

### Step 2: Fit-Gap Analysis

Check each category:

| Category | Questions | Example Gaps |
|----------|-----------|-------------|
| **Data** | Formats? Null/empty? Boundaries? | max length, encoding, special chars |
| **UX** | Loading state? Error state? Empty state? | skeleton, retry button, placeholder |
| **Integration** | What else affected? Side effects? | cache invalidation, events |
| **Security** | Access rights? Validation? | authorization, input sanitization |
| **Performance** | Data volume? Pagination? | batch limits, timeouts |
| **Errors** | What if fails? Retry? | graceful degradation, error messages |

### Step 3: Pre-mortem

Ask: **"A week passed, the feature broke. Why?"**
- Missed edge case (empty data, null, large volumes)
- Uncovered error scenario (API unavailable, timeout)
- Forgot state handling (loading, error, empty)
- Didn't check access rights
- Didn't test mobile/responsive

### Step 4: Report

```markdown
## GAP ANALYSIS REPORT

### Category: [DATA/UX/ERRORS/etc]
| # | GAP | Severity | Action |
|---|-----|----------|--------|
| 1 | [description] | HIGH/MED/LOW | [what to do] |

### TOTALS:
- HIGH (blockers): [count]
- MED (desirable): [count]
- LOW (later): [count]
```

For HIGH gaps -- ASK user, don't assume!

## Mode B: Codebase Scan

Run scan script for automated detection:
```bash
bash .cursor/skills/gap-analysis/scripts/scan-gaps.sh
```

### Manual checks:

| Check | How to find | GAP if |
|-------|-------------|--------|
| Buttons without actions | `onClick={() => {}}` | Button does nothing |
| Forms without submit | `onSubmit` missing or empty | Form doesn't send data |
| Links to nowhere | `href="#"` or `href=""` | Link leads nowhere |
| Loading without timeout | `isLoading` without error boundary | May hang forever |
| Error without recovery | `catch {}` empty | Error swallowed |
| Partial CRUD | Create exists but no Update/Delete | Incomplete |

### Business Logic

```markdown
## FEATURE COMPLETENESS
| Feature | Create | Read | Update | Delete | Status |
|---------|--------|------|--------|--------|--------|
| [Entity] | ok/no | ok/no | ok/no | ok/no | COMPLETE/INCOMPLETE |
```

## GAP Severity

| Severity | Criteria | Action |
|----------|----------|--------|
| HIGH | Without it, feature doesn't work | BLOCKER -- fix before implementation |
| MED | Works but bad UX/quality | Fix during implementation |
| LOW | Nice-to-have | Backlog or ask user |

## Key Principle

Before creating a new feature:
1. `rg "X"` -- maybe it already exists?
2. `rg "TODO.*X"` -- maybe there's a stub?
3. Check UI -- maybe button exists but doesn't work?

If found stub -> COMPLETE existing, don't create new!
