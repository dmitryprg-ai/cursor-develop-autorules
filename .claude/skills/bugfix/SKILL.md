---
name: bugfix
description: "Fix bugs, errors, exceptions, and unexpected behavior. Use when debugging, fixing errors, handling crashes, or when user mentions bug, error, broken, not working, crash, exception, 500 error, Application error, white screen, TypeError, undefined is not a function, or unexpected behavior."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Bug Fix Protocol

Principle: **Fix the root cause, not the symptom.**

Patching symptoms creates a growing pile of workarounds that eventually become harder to maintain than the original bug. Every bug is a signal that something in the system's design allowed it to happen.

## Workflow

1. **STOP** — Pause at the error. Rushing to fix without understanding causes more damage.
2. **CAPTURE** — Record full error context (command, output, file, action).
3. **ANALYZE** — Apply 5 Whys to find root cause (see below).
4. **FIX** — Apply minimal patch to address root cause, not symptom.
5. **VERIFY** — Confirm the exact same trigger no longer produces the error.
6. **PREVENT** — Add protection against recurrence (test, validation, guard).

## Error Capture

```markdown
## ERROR CAPTURED
**Command:** [what caused the error]
**Error Output:** [FULL output, don't truncate]
**Context:** File: [file], Action: [what I was doing]
```

## 5 Whys Root Cause Analysis

Dig at least 5 levels deep. Surface-level fixes are temporary.

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
| ModuleNotFoundError | Missing package | `npm install` |
| TypeError | Wrong data type or null | Check actual types at runtime |
| 500 Error | Unhandled exception | Add error handling + log |
| Connection refused | Service not running | Start/restart service |
| 401 Unauthorized | Missing auth headers | Check Basic Auth + Session |

## What to avoid

- **Silent catches**: `try/catch {}` hides the root cause and makes the same bug resurface later in a harder-to-debug location.
- **Multiple fixes at once**: change one thing at a time so you know exactly which change resolved the issue.
- **Workarounds without docs**: if you must work around an issue temporarily, document why and create a follow-up task.
- **Ignoring recurring errors**: if the same error appears twice, it needs a systemic fix, not another patch.

## Success Criteria

- The same command that caused the error now works
- Root cause is addressed, not just the symptom
- No new errors introduced
