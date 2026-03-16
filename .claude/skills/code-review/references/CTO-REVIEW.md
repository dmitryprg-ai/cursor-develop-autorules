# CTO Review Template

For COMPLEX tasks and architectural decisions.

```markdown
## CTO REVIEW

### 1. SCOPE
- **What changes:** [description]
- **Affected components:** [list]
- **Consumers:** [who uses this]

### 2. RISK ASSESSMENT
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [risk 1] | Low/Med/High | [impact] | [how to reduce] |

### 3. ALTERNATIVES
| Option | Pros | Cons |
|--------|------|------|
| [option 1] | [pros] | [cons] |
| [option 2] | [pros] | [cons] |

### 4. RECOMMENDATION
- **Choice:** [which option]
- **Why:** [justification]

### 5. ROLLBACK PLAN
- [steps to rollback if something goes wrong]
```

## When to Apply

- Change affects >5 files
- Changing API used by others
- Data migration
- New architectural concept
- NEVER for simple changes

## Why This Matters

Assessing risks before implementation catches architectural mistakes when they're cheap to fix. After implementation, the cost of fixing increases 10x because code, tests, and integrations all need updating.
