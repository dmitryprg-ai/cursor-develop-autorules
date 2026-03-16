---
description: "Apply when making git commits, creating branches, or preparing PRs. Enforces conventional commits, branch naming, and pre-commit quality gates."
---

# Git Workflow

## Commit Messages (Conventional Commits)

Format: `<type>(<scope>): <description>`

| Type | When |
|------|------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring (no behavior change) |
| `docs` | Documentation only |
| `test` | Adding/fixing tests |
| `chore` | Build, config, dependencies |
| `perf` | Performance improvement |

Examples:
```
feat(deals): add date filter to deals API
fix(auth): handle expired session tokens
refactor(customers): extract validation to shared util
```

## Branch Naming

Format: `<type>/<short-description>`

```
feat/deal-date-filter
fix/session-expiry
refactor/customer-validation
```

## Pre-Commit Quality Gates

Before EVERY commit:
1. `npm run lint` — must pass (0 errors)
2. `npm run type-check` — must pass (if available)
3. All changed files opened and verified

## Why This Matters

Inconsistent commit messages make `git log` useless for debugging. When a production issue occurs at 2am, you need to quickly find which commit introduced the problem. Conventional commits make `git log --grep="fix(auth)"` actually work.

## PR Template

```markdown
## What
[1-2 sentences: what changed]

## Why
[1-2 sentences: why this change is needed]

## How
[Key implementation details]

## Testing
- [ ] Tests added/updated
- [ ] Linter passes
- [ ] Manually verified
```

## What to Avoid

- Committing `.env`, `.secrets/`, credentials — because leaked secrets require emergency rotation
- Force-pushing to main/master — because it destroys other developers' history
- Commits without meaningful message — because "fix" tells nothing 3 months later
- Mixing unrelated changes in one commit — because it makes reverting one change impossible
