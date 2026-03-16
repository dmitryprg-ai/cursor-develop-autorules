# 5 Whys Root Cause Analysis

## Template

```markdown
## 5 WHYS ANALYSIS

**Symptom:** [what went wrong — observable behavior]
**Context:** [when/where it happened]

1. **Why did [symptom] happen?**
   -> [answer 1]

2. **Why [answer 1]?**
   -> [answer 2]

3. **Why [answer 2]?**
   -> [answer 3]

4. **Why [answer 3]?**
   -> [answer 4]

5. **Why [answer 4]?**
   -> [ROOT CAUSE]

**Root Cause:** [systemic reason, not "I forgot"]
**Fix:** [what to change to prevent recurrence]
**Verify:** [how to confirm the fix works]
```

## Quality Criteria

Good root causes are **systemic**, not personal:

| Bad Root Cause | Good Root Cause |
|----------------|-----------------|
| "I forgot" | "No automated check exists for this" |
| "Didn't notice" | "Error message doesn't surface in the output" |
| "Was in a hurry" | "Process lacks a mandatory verification step" |
| "Didn't know" | "Documentation doesn't cover this edge case" |

## Example

```markdown
**Symptom:** UI shows blank page after deploy

1. Why blank page? -> Next.js serves old build
2. Why old build? -> Service wasn't restarted after build
3. Why not restarted? -> Deploy script only runs build
4. Why script incomplete? -> Script was copied from dev setup
5. Why dev setup different? -> Dev uses hot reload, prod needs restart

**Root Cause:** Deploy script missing restart step
**Fix:** Add `systemctl restart` to deploy script after build
**Verify:** Deploy and check page loads with new content
```
