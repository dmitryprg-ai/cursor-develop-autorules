---
name: code-review
description: "Review code for quality, security, and maintainability. Use when reviewing pull requests, examining code changes, doing QA checks, architecture review, or CTO review. Also trigger for COMPLEX tasks affecting more than 5 files, API contract changes, or data migrations."
allowed-tools: Read, Grep, Glob
model: sonnet
user-invocable: true
---

# Code Review

## QA Checklist

### Code Quality
- [ ] 0 linter errors — linter catches mechanical mistakes before humans need to
- [ ] 0 TypeScript errors — type safety prevents entire classes of runtime bugs
- [ ] No console.log (except intentional debug) — logs in production leak implementation details
- [ ] Tests pass — untested code is unverified code
- [ ] Edge cases handled — empty arrays, null values, boundary conditions
- [ ] Error cases handled — what happens when things go wrong?

### Naming Standards

| Type | Convention | Example |
|------|-----------|---------|
| Files (components) | PascalCase | `ComponentName.tsx` |
| Files (utils) | camelCase | `utilName.ts` |
| Functions | camelCase | `functionName()` |
| Components | PascalCase | `ComponentName` |
| Constants | UPPER_SNAKE | `CONSTANT_NAME` |

### JTBD Verification (user-facing features)

- [ ] Job Story implemented — the feature solves the user's actual problem
- [ ] UI text about benefits, not features — "See deals at a glance" not "Algorithm analyzes"
- [ ] Minimum steps to result — every extra click is a tax on the user
- [ ] No confusing terminology — avoid jargon the user wouldn't use

## Feedback Format

- **CRITICAL**: Must fix before merge — blocks deployment
- **SUGGESTION**: Consider improving — improves maintainability
- **NICE TO HAVE**: Optional enhancement — polish

## CTO Review (for COMPLEX tasks)

Apply when: change affects 5+ files, API contract changes, data migration, new architectural pattern.

See detailed template: `references/CTO-REVIEW.md`

Key areas:
1. **Scope** — What changed and why
2. **Risk Assessment** — What could break
3. **Alternatives** — Were other approaches considered
4. **Recommendation** — Approve / Request changes / Escalate
5. **Rollback Plan** — How to revert if needed
