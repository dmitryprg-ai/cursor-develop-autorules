---
name: session-review
description: "Review work session quality and capture improvement opportunities. Use at end of session, after completing complex features, after series of errors or failed attempts, after 2+ hours of focused work, when user says done/finished/wrap up, for retrospective analysis, or when same mistake happened twice in a session."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Session Review

Patterns repeat without reflection. Session reviews exist to catch systemic problems before they become habits.

## When to Apply

| Situation | Apply? |
|-----------|--------|
| After completing a feature | YES |
| After a complex bug fix | YES |
| After 2+ hours of work | YES |
| After series of errors | MANDATORY |
| Before ending the day | Recommended |

## Review Process

Use the template in `references/review-template.md`. Fill all 5 sections:

1. **SUMMARY** — What was done, how long, final status
2. **WHAT WENT WELL** — Techniques, tools, or approaches that helped
3. **WHAT WENT WRONG** — Where you got stuck, errors encountered
4. **GAPS IN INSTRUCTIONS** — What information was missing or unclear
5. **IMPROVEMENT** — Specific proposal for better instructions

## Error Learning Connection

After each error in the session, also record it using the error-learning rule:
- Error description and root cause
- Fix applied
- Prevention strategy
- Which instruction should have prevented it

## Output

Write improvements to `.cursor/data/improvements-backlog.md`.

When the backlog reaches 5+ items or has 2+ High priority entries, run the `backlog-to-rules` skill to implement them into rules and skills.

## Success Criteria

- All 5 sections filled with specific details (not generic observations)
- At least one concrete improvement proposal identified
- Improvement recorded in backlog with priority and target file
