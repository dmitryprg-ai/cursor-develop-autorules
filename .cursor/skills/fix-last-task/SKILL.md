---
name: fix-last-task
description: Analyze and fix issues in the last completed task — find missed problems, fix errors, perform session review. Use when user reports errors after task was marked as done, when completion report had high confidence but result has issues, or when AI missed obvious problems.
---

# Fix Last Task Protocol

Principle: **ANALYZE FAILURE BEFORE FIXING.**

## When to Apply

- AI declared task complete, but user found errors
- Challenge protocol or Cross-check were not performed properly
- Completion report had high confidence but result is wrong

## Workflow (7 Phases — ALL MANDATORY)

### Phase 1: ANALYZE FAILURE
1. Restore original request (exact quote)
2. List what was done vs what was expected
3. Re-run Challenge protocol from `core-master.mdc` (Cross-check + 4 questions)
4. List all missed issues

### Phase 2: ROOT CAUSE ANALYSIS
Apply 5 Whys from `_base-5wh.mdc` — dig at least 5 levels to find why the issues were missed.

### Phase 3: PLAN
Create TODO list — one item per missed issue, starting with critical ones.

### Phase 4: FIX
For each TODO:
1. Mark in_progress
2. Apply fix
3. Cross-check: open file, read changes, verify
4. Mark completed
5. Report confidence change: `[before]% → [after]% — [reason]`

### Phase 5: VERIFY
Apply Cross-check (open every changed file) + Final Challenge (4 questions).

### Phase 6: SESSION REVIEW
Apply `session-review` skill fully. Record improvement to `.cursor/data/improvements-backlog.md`.

### Phase 7: COMPLETION REPORT
Full DONE block with: issues found, fixes applied, root cause, improvement recorded, final confidence.

## FORBIDDEN

- Skipping any Phase
- Fixing without Cross-check
- Not recording improvement in backlog
- Declaring done without re-running Challenge
- Making excuses instead of analyzing

## Templates

For detailed analysis and review templates, see [templates.md](references/templates.md).
