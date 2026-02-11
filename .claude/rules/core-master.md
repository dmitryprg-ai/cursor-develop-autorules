# MASTER PROTOCOL v5.1

## Step 0: Complexity

First line of response — ALWAYS:

| Complexity | Signs | Action |
|------------|-------|--------|
| SIMPLE | 1-2 files, typo, style | Execute → Lint → Short DONE |
| STANDARD | New feature, bug, multiple files | Plan → Protocol → Full DONE |
| COMPLEX | Architecture, migration, critical data | + CTO Review |

## Step 1: Plan (STANDARD/COMPLEX)

- BEFORE code — plan. Do NOT start without a plan
- Determine task type → choose protocol from Routing Table
- Step-by-step protocol execution is mandatory

```markdown
## PLAN
**Protocol:** [from Routing Table]
**Goal:** [one sentence]
**Files:** [affected]
**Risk:** [what could go wrong]
```

## Step 2: Execute

- Small steps — one file at a time
- After change — check linter
- Created/changed file — OPEN and read

## Step 3: Verify (before "done")

### Forbidden

- NEVER: files with `_fixed`, `_final`, `_v2` — edit the original
- NEVER: overwrite entire file — targeted changes only
- NEVER: "Done" without opening files
- NEVER: ignore terminal errors
- NEVER: assumptions without data verification

### Cross-check

Open and read EVERY created/changed file. Verify with a DIFFERENT method.

```markdown
| File | Opened | Verified |
|------|--------|----------|
| [path] | yes/no | yes/no |
```

### Challenge (4 questions before "done")

```
1. How to disprove my conclusion? → [answer]
2. All files opened and checked? → [YES/NO]
3. What edge cases did I miss? → [list]
4. Is user's Job solved? → [YES/NO]
```

If question 2 = NO → open files. If 4 = NO → finish the work.

### Confidence

Formula: 100% minus penalties: code not tested (-50%), files not opened (-40%), cross-check not done (-30%). Threshold: < 80% = need verification, < 50% = ask user.

## Step 4: DONE block

For SIMPLE — short format:
```
DONE: [what was done]. Confidence: X%.
```

For STANDARD / COMPLEX — full format:
```markdown
---
## DONE
**What was done:** [list]
**Checks:** Cross-check done | Challenge done | Linter done
**Confidence:** [X]% — [why]
---
```

---

## Routing Table

| Task | Skill / Protocol |
|------|-----------------|
| New feature | `development` skill |
| Bug / error | `bugfix` skill |
| Refactoring | `refactoring` skill |
| Data analysis | `research` skill |
| Deploy (build + restart) | `deploy-app` skill |
| API testing | `api-testing` skill |
| Code review / COMPLEX | `code-review` skill |
| Tests (TDD) | `tdd-workflow` skill |
| Session review / retro | `session-review` skill |
| Create rules/skills | `create-rules` skill |
| Find gaps/stubs | `gap-analysis` skill |
| Tech debt scan | `/techdebt-scan` (explicit only) |
| Fix last task issues | `fix-last-task` skill |
| Implement improvements from backlog | `backlog-to-rules` skill |
| AI freeze | freeze-recovery rule |

## Code Principles (KISS/YAGNI)

- Simplest solution is ALWAYS preferred
- Do NOT write code "for the future" — only current requirements
- Delete unused code IMMEDIATELY
- Before abstraction: needed NOW? Can be SIMPLER? → Yes = do simpler
- STOP signals: >3 layers of abstraction, factory of factories, abstraction for 1 use

## Additional Modules (agent-decided rules)

| Module | When |
|--------|------|
| `riskiest-assumption` rule | Risk assessment BEFORE implementation |
| `jtbd-thinking` rule | User-facing features |
| `analysis-5wh` rule | Structured problem analysis |
| `error-learning` rule | After errors |

---

**Version:** 5.1
