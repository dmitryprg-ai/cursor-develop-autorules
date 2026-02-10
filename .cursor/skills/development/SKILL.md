---
name: development
description: Develop new features, functionality, and enhancements. Use when creating new features, adding functionality, building components, or when user says add, create, build, develop, implement. Includes Duplicate Check, JTBD Analysis, TDD approach, UI pattern reuse, and service restart verification.
---

# Development Protocol

## Pre-Action (MANDATORY before coding)

### 1. Duplicate Check

```markdown
## DUPLICATE CHECK
**Target:** [what I'm creating]
**Search:** semantic/grep/file -> [found/not found]
**Decision:** CREATE NEW / EXTEND EXISTING / ASK USER
```

### 2. JTBD Analysis (for user-facing features)

```markdown
## JTBD ANALYSIS
**Job Story:** When [context], user wants [action], to get [result] and [benefit]
**Questions:**
1. What task are they solving? -> [answer]
2. What's blocking them? -> [answer]
3. What change will help? -> [answer]
```

### 3. Find Working Example

For UI: find a working pattern in the project first. Copy the pattern, then adapt. Do NOT invent CSS classes without checking they work.

### 4. Control File Size

Plan logic across multiple files. Refer to `standard-file-size-limits-agent.mdc` rule.

## Plan

```markdown
## DEVELOPMENT PLAN
**Task:** [what to do]
**Expected Output:** [artifacts]
**Test Cases:** [input -> expected output]
```

## Execute (TDD approach)

1. Write test cases (should FAIL)
2. Write minimal code to pass
3. Run tests (should pass)
4. Refactor if needed
5. Restart affected services and verify

## Verify

- [ ] 0 linter errors
- [ ] Tests pass
- [ ] JTBD: Job implemented, UI about benefits
- [ ] Each file opened and verified
- [ ] Services restarted if needed

## Common Pitfalls

- **UI Components**: Find working example in project first. Don't use CSS classes without checking they work.
- **Type Consistency**: Database types may differ from JSON (bigint -> string). Check actual types.
- **Backend Modules**: Follow pattern: types -> repository -> service -> routes
- **External APIs**: List/Enum fields may contain IDs, not text. Need mapping.
- **Entry Points**: Use high-level orchestrator services, not low-level methods.

## Additional Resources

For prompt preparation methodology, see [PREPARE-PROMPT.md](references/PREPARE-PROMPT.md).
