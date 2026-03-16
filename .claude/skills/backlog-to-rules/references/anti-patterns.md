# Backlog-to-Rules: Anti-patterns

## What NOT to Do

| Mistake | Correct Approach |
|---------|-----------------|
| Delete existing sections | Add new ones |
| Merge unrelated rules | Separate section for each pattern |
| Write abstract rules | Include concrete examples |
| Skip WHY | Every rule with real error case |
| Simplify wording | Preserve full context |
| Change numbering of existing sections | Add at the end |
| Overwrite entire file | Targeted changes via Edit |
| Create files with `_fixed`, `_v2` | Edit the original |

## Common Implementation Mistakes

### 1. Too abstract rule

```markdown
# BAD
Always validate data before use.

# GOOD
### 3.4. Bitrix24 UF-field Validation
**Input:** Data received with UF-fields of type "List"
**Output:** Values mapped from ID to text
> **WHY:** UF-field "Client Type" returned ID=127 instead of text. Lost ~40 minutes.
```

### 2. Rule without WHY

```markdown
# BAD
Don't use response.length < limit for pagination.

# GOOD
Don't use response.length < limit for Bitrix24 pagination.
> **WHY:** Bitrix24 at start > total returns records WITHOUT filter.
> Loaded 333K records instead of 100. Lost ~2 hours.
```

### 3. Loss of context during implementation

```markdown
# BAD — deleted existing section and replaced with own

# GOOD — added new section after existing ones,
#         preserving numbering (3.4, 3.5, ...)
```

## Pre-finalization Checklist

- [ ] Each implemented rule contains a concrete example
- [ ] Each rule has WHY with a real case
- [ ] Existing sections not deleted or changed
- [ ] Section numbering is correct
- [ ] Backlog updated (statuses + statistics)
- [ ] All affected files opened and re-read
