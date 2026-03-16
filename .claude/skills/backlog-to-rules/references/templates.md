# Backlog-to-Rules: Templates

## Backlog Analysis Template (Phase 1)

```markdown
## BACKLOG ANALYSIS

### 1. Grouping by files:
| File | Improvements | Count |
|------|-------------|-------|
| [rule-file.md] | #X, #Y, #Z | N |

### 2. Statistics:
- Total improvements in backlog: [N]
- High priority: [N]
- Medium priority: [N]
- Low priority: [N]

### 3. Error patterns:
1. [Pattern 1] — improvements #X, #Y
2. [Pattern 2] — improvements #Z
```

## File Research Template (Phase 2)

```markdown
## RESEARCH: [filename.md]

### Current structure:
- Section 1: [name]
- Section 2: [name]

### Where to add improvements:
- Improvement #X -> [which section / new section N]

### Conflict check:
- [ ] Improvements don't contradict existing rules
- [ ] Format matches existing style
- [ ] New sections logically fit
```

## Implementation Plan Template (Phase 3)

```markdown
## IMPLEMENTATION PLAN

### File 1: [path/to/file.md]
- [ ] Add section X.Y: [name]

### Success criteria:
1. All improvements from backlog implemented
2. Existing context preserved
3. Format matches file style
```

## New Section Template (Phase 4)

```markdown
### X.Y. [Name] (from Improvement #N)

**Input:** [What triggers this rule]
**Output:** [What should be done]

**Process:**
1. **Step 1:**
   ```[lang]
   [concrete example]
   ```

**Guardrails:**
- [what NOT to do]

**Success Metric:** [how to know the rule worked]

> **WHY:** [Real error case]. Lost ~[X] minutes.
```

## Summary Template (Phase 7)

```markdown
## IMPLEMENTATION SUMMARY

### What was done:
- Improvements implemented: [N]
- Files updated: [N]
- Sections added: [N]

### Updated files:
| File | Changes |
|------|---------|
| [file1.md] | Added sections X.Y, X.Z |

### Patterns prevented:
1. [Pattern 1] — now has rule in [file.md] section X

### Confidence: [X]%
```
