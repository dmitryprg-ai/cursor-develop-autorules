---
name: refactoring
description: "Improve code structure without changing behavior. Use when refactoring, cleaning up, simplifying, extracting methods, reducing complexity, removing duplication, or applying DRY principle. Also trigger when files exceed size limits or code smell is detected."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Refactoring Protocol

Principle: **Change structure, not behavior.**

If behavior changes, it's not refactoring — it's a feature or bugfix. Mixing both in one commit makes it impossible to tell what changed intentionally vs what broke.

## When to Refactor

| Refactor When | Do NOT When |
|---------------|-------------|
| Code works but is hard to understand | Code doesn't work yet (fix first) |
| Duplicated code exists | No tests exist (write tests first) |
| Long methods (50+ lines) | Under time pressure (risk too high) |
| Deep nesting (3+ levels) | "Just because" (needs a reason) |

## Safety Protocol

Tests must exist before refactoring because refactoring without tests is gambling — you have no way to verify behavior stayed the same. Each change should be small enough that if tests break, you know exactly which change caused it.

1. Verify all tests pass before starting
2. Make one small change
3. Run tests after each change
4. Commit after each green test
5. Repeat

## Common Patterns

| Code Smell | Refactoring |
|------------|-------------|
| Long Method (50+ lines) | Extract Method |
| Duplicate Code | Extract shared function/class |
| Long Parameter List (4+) | Parameter Object |
| Deep Nesting (3+ levels) | Guard Clauses (early return) |
| Magic Numbers | Extract Constant |

## What to avoid

- **Big Bang rewrites**: rewriting an entire module at once makes it impossible to isolate what broke. Small steps are slower but dramatically safer.
- **No test coverage**: without tests, you can't verify behavior is unchanged. Write tests first.
- **Mixed changes**: "while I'm here, let me fix this bug too" — separate commits for separate concerns.
- **Premature abstraction**: creating an abstraction for code used in only one place adds complexity without benefit. Wait for the second or third use case.

## File Size Limits

Plan splitting before the file grows too large:
- Routes: 300 lines (soft), 600 (hard)
- Services: 400 / 800
- Components: 200 / 400

Split by business domain, not technical layer. `CustomerValidation` and `CustomerFormatting` are better than `validation-utils` and `format-utils`.
