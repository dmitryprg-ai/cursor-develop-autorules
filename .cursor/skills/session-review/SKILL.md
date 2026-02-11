---
name: session-review
description: Review work session quality and capture improvements. Use at end of session, after large tasks, after series of errors, or when user asks for session review, retrospective, lessons learned. Records improvements to backlog.
---

# Session Review Protocol

## When to Apply

| Situation | Apply? |
|-----------|--------|
| After completing a feature | YES |
| After a complex bug fix | YES |
| After 2+ hours of work | YES |
| After series of errors | MANDATORY |
| Before ending the day | Recommended |

## Session Review Template

```markdown
## SESSION REVIEW: [date]

### 1. SUMMARY
- **Task:** [what was done]
- **Time:** [how long]
- **Status:** done/partial/failed

### 2. WHAT WENT WELL
- [what helped]

### 3. WHAT WENT WRONG
- [where got stuck]
- [what errors occurred]

### 4. GAPS IN INSTRUCTIONS
- [what was missing]

### 5. IMPROVEMENT
**Problem:** [what went wrong]
**Root Cause:** [why]
**Proposal:** [what to add to instructions]
**File:** [which .mdc to change]
```

## Error Learning

After each error, record:

```markdown
## ERROR LOG
**Error:** [what happened]
**Root Cause:** [why]
**Fix:** [what was done]
**Prevention:** [how to avoid in future]
**Rule Gap:** [what instruction was missing]
```

Write improvements to `.cursor/data/improvements-backlog.md`.

## Success Criteria

- Session reviewed with all 5 sections filled
- At least one improvement identified
- Improvement recorded in backlog
