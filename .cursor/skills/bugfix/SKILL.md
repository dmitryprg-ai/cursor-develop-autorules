---
name: bugfix
description: Fix bugs, errors, exceptions, and unexpected behavior. Use when debugging, fixing errors, handling crashes, or when user mentions bug, error, broken, not working, crash, exception, 500 error, Application error. Uses 5 Whys Root Cause Analysis.
---

# Bug Fix Protocol

Principle: **FIX ROOT CAUSE, NOT SYMPTOM.**

## Workflow

1. **STOP** -- Pause at the error
2. **CAPTURE** -- Record all error information
3. **ANALYZE** -- 5 Whys to find root cause
4. **FIX** -- Minimal patch for root cause
5. **VERIFY** -- Confirm the fix works
6. **PREVENT** -- Add protection against recurrence

## Error Capture Template

```markdown
## ERROR CAPTURED
**Command:** [what caused the error]
**Error Output:**
[FULL output, don't truncate]
**Context:** File: [file], Action: [what I was doing]
```

## Root Cause Analysis (5 Whys)

Use `_base-5wh.mdc` template. Dig at least 5 levels:

```markdown
**Why 1:** [surface error]
  -> **Why 2:** [deeper cause]
    -> **Why 3:** [even deeper]
      -> **Why 4:** [structural issue]
        -> **Why 5:** [root cause]

ROOT CAUSE: [the real problem]
FIX: [minimal change to address root cause]
```

## Common Error Patterns

| Error Type | Likely Root Cause | Fix |
|------------|------------------|-----|
| ModuleNotFoundError | Missing package | `npm install` / `pip install` |
| TypeError | Wrong data type | Check actual types |
| 500 Error | Unhandled exception | Add error handling |
| Connection refused | Service not running | Start/restart service |
| 401 Unauthorized | Missing auth | Check Basic Auth + Session |

## Anti-patterns (FORBIDDEN)

- try/catch that silences errors without fixing root cause
- Workarounds without documentation
- Multiple fixes at once (one change at a time!)
- Ignoring recurring errors

## Success Criteria

- The same command that caused the error now works
- Root cause is addressed, not just the symptom
- No new errors introduced
