# Fix Last Task — Templates

## Phase 1: Analysis Template

```markdown
## ORIGINAL REQUEST

**What user asked:**
> [exact quote]

**What I did:**
- [list of actions]

**My Completion Report said:**
- Confidence: X%
- Cross-check: [done/not done]
- Challenge: [passed/not passed]

## CHALLENGE PROTOCOL (re-run)

1. **How to disprove my conclusion "task is done"?**
   -> [answer]

2. **Did I open ALL created/changed files and check content?**
   -> [answer]

3. **What edge cases did I miss?**
   -> [answer]

4. **Is user's Job actually solved?**
   -> [answer]

## MISSED ISSUES

| # | What was missed | Where it should be | Why I missed it |
|---|-----------------|-------------------|-----------------|
| 1 | [description] | [file/section] | [reason] |
```

## Phase 2: RCA Template

```markdown
## 5 WHYS ANALYSIS

**Problem:** [what went wrong]

1. **Why did this happen?**
   -> [answer]

2. **Why [answer 1]?**
   -> [answer]

3. **Why [answer 2]?**
   -> [answer]

4. **Why [answer 3]?**
   -> [answer]

5. **Why [answer 4]?**
   -> [ROOT CAUSE]

**Root Cause:** [final cause]
```

## Phase 5: Verification Template

```markdown
## CROSS-CHECK TABLE

| Artifact | Opened | Verified | Status |
|----------|--------|----------|--------|
| [file 1] | yes/no | yes/no | OK/ISSUE |

## FINAL CHALLENGE

1. How to disprove everything is fixed now? -> [answer]
2. All files opened and checked? -> [must be YES]
3. What edge cases might remain? -> [answer]
4. Is user's Job now solved? -> [must be YES]
```

## Phase 7: Completion Report Template

```markdown
---
## FIX LAST TASK — COMPLETION REPORT

**Original task:** [what was asked]
**Issues found:** X
**Fixed:**
1. [what was fixed]

**Root Cause:** [why initially missed]
**Improvement recorded:** yes/no

**Cross-check:**
- All files opened and verified
- Challenge protocol re-run
- Session review completed

**Final confidence:** X% — [justification]
---
```
