# Prepare Prompt

For STANDARD/COMPLEX tasks, improve the user's prompt before executing.

## Prompt Analysis

```markdown
## PROMPT ANALYSIS

**Original:** "[user's prompt]"

| Component | Found | Clarify |
|-----------|-------|---------|
| **GOAL** | [yes/no] | [what] |
| **CONTEXT** | [yes/no] | [what] |
| **CONSTRAINTS** | [yes/no] | [what] |
```

## Extract EXPLICIT CONSTRAINTS

Quote constraints literally from the request:

```markdown
### Explicit Constraints (quotes):
- DO NOT: "[quote]"
- DO: "[quote]"
- HOW: "[quote]"
```

Red Flags:
- "User probably meant..." -- interpretation
- "It's logical to assume..." -- assumption

## Improved Prompt

```markdown
## IMPROVED PROMPT
**Goal:** [specific result]
**Context:** [what's known, files]
**Constraints:** [what NOT to change]
**Success:** [how to verify]
**Protocol:** [which to apply]
```

Rules:
- Don't interpret -- follow literally
- Quote constraints verbatim
- Choose protocol before executing
- If unclear -- ASK, don't assume
