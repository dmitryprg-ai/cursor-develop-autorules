---
name: refactoring
description: Improve code structure without changing behavior. Use when refactoring, cleaning up, optimizing, simplifying, extracting methods, or reducing complexity. Requires tests BEFORE refactoring, small steps, commit after each green test.
---

# Refactoring Protocol

Principle: **CHANGE STRUCTURE, NOT BEHAVIOR.**

If behavior changes, it's NOT refactoring -- it's a feature or bugfix.

## When to Refactor

| Refactor When | Do NOT When |
|---------------|-------------|
| Code works but hard to understand | Code doesn't work yet |
| Duplicated code | No tests exist |
| Long methods (> 50 lines) | Under time pressure |
| Deep nesting (> 3 levels) | "Just because" |

## Safety Protocol

1. Tests MUST exist before refactoring
2. Tests MUST pass before each change
3. Only small steps (one change at a time)
4. Run tests AFTER each change
5. Commit AFTER each green test

## Workflow

```
1. VERIFY   -> All tests pass
2. IDENTIFY -> What to refactor
3. PREPLAN  -> Check file size limits (standard-file-size-limits rule)
4. PLAN     -> Small steps
5. EXECUTE  -> One step
6. TEST     -> Tests after step
7. COMMIT   -> Commit if green
8. REPEAT   -> Next step
```

## Common Patterns

| Code Smell | Refactoring |
|------------|-------------|
| Long Method (> 50 lines) | Extract Method |
| Duplicate Code | Extract Method/Class |
| Long Parameter List (> 4) | Parameter Object |
| Deep Nesting (> 3 levels) | Guard Clauses |
| Magic Numbers | Extract Constant |

## Anti-patterns (FORBIDDEN)

- Big Bang: rewriting entire module at once
- No Tests: refactoring without test coverage
- Mixed Changes: "while I'm here, let me fix this bug too"
- Premature Abstraction: abstraction for code used once

## Golden Rules

1. **TESTS FIRST** -- no tests, no refactoring
2. **SMALL STEPS** -- one change at a time
3. **TEST OFTEN** -- after every change
4. **COMMIT OFTEN** -- after every green test
5. **BEHAVIOR UNCHANGED** -- same inputs -> same outputs
