---
name: fix-last-task
description: "Analyze and fix issues in the last completed task. Use when user reports errors after task was marked as done, when completion report had high confidence but result has issues, when AI missed obvious problems, or when post-task issues appear."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Fix Last Task

Analyze failure before fixing. Patching without understanding why you missed the problem guarantees you'll miss it again.

## When to Apply

- AI declared task complete, but user found errors
- Challenge protocol or Cross-check were not performed properly
- Completion report had high confidence but result is wrong

## Workflow (7 Phases)

### Phase 1: Analyze Failure

1. Restore original request (exact quote)
2. List what was done vs what was expected
3. Re-run Challenge protocol (Cross-check + 4 questions)
4. List all missed issues

### Phase 2: Root Cause Analysis

Apply 5 Whys — dig at least 5 levels deep to find why issues were missed. Surface-level answers like "I forgot" are not root causes — keep asking until you reach a systemic reason.

### Phase 3: Plan

Create TODO list — one item per missed issue, critical ones first.

### Phase 4: Fix

For each TODO:
1. Mark in_progress
2. Apply fix
3. Cross-check: open file, read changes, verify
4. Mark completed
5. Report confidence change: `[before]% -> [after]% — [reason]`

### Phase 5: Verify

Open and read EVERY changed file. Run the Challenge (4 questions) again.

### Phase 6: Session Review

Record improvement to `.cursor/data/improvements-backlog.md` because patterns repeat without reflection — the same class of mistake will resurface unless codified.

### Phase 7: Completion Report

Full DONE block: issues found, fixes applied, root cause, improvement recorded, final confidence.

## What to Avoid

- Skipping phases — each exists because a specific class of error slipped through without it
- Fixing without Cross-check — you'll introduce new issues while fixing old ones
- Not recording improvement — the same mistake will repeat in 2-3 sessions
- Making excuses instead of analyzing — "I forgot" is not a root cause

## Templates

For detailed analysis and review templates, see [templates.md](references/templates.md).
