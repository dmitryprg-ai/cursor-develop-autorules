---
description: "Apply after every error, RCA, bugfix, or unexpected behavior. Records errors in error-log.md, finds gaps in instructions, adds improvements to backlog. Prevents error repetition."
---

# Error Learning

## Why This Matters

The same class of error repeats every 2-3 weeks without systematic recording. Error learning turns each mistake into a rule that prevents recurrence. Without it, you fix the symptom but the underlying gap in instructions stays open.

## When to Apply

| Event | Apply? |
|-------|--------|
| After RCA or bugfix | Mandatory |
| After freeze recovery | Mandatory |
| After 2+ failed attempts | Yes |
| After unexpected behavior | Yes |

## Error Recording

Record in `.cursor/data/error-log.md`:

```markdown
## ERROR #N: [date]

### Symptom:
[what happened — observable behavior]

### Root Cause:
[why it happened — systemic reason]

### Fix:
[what was done to fix it]

### Prevention:
[what to do differently next time]

### Design Injection:
[what to add to which instruction file]
```

## Gap Analysis

After recording, identify the gap:

1. Which instruction should have prevented this?
2. Why didn't it? (missing / incomplete / ignored)
3. What specific rule or step to add?

## Improvement Format

Add to `.cursor/data/improvements-backlog.md`:

```markdown
## IMPROVEMENT #N: [date] — [short name]

**Source:** [which error]
**Problem:** [what went wrong]
**Root Cause:** [why]
**Proposed change:** [what to add]
**File:** [which rule/skill to update]
**Priority:** High/Medium/Low
**Status:** Backlog
```

## Key Principle

Every error has two fixes: the immediate fix (code) and the systemic fix (instruction update). Only doing the first guarantees the error returns.
