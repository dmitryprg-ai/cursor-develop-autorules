---
name: tdd-workflow
description: "Test-Driven Development with strict Red-Green-Refactor cycle. Use when developing with TDD, writing tests before code, adding test coverage, or when user mentions test-first, red-green-refactor, or wants reliable test suites."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# TDD Workflow

Principle: **Red -> Green -> Refactor** (strict order)

Writing tests first catches design issues early — if the API is awkward to test, it's awkward to use. Tests also serve as living documentation that stays current because it breaks when behavior changes.

## Phase 0: Test Planning (before any code)

Fill the test cases table first because it forces you to think about behavior before implementation. Without this step, tests end up only covering the happy path.

```markdown
| # | Scenario | Input | Expected Output | Type |
|---|----------|-------|-----------------|------|
| 1 | Happy path | ... | ... | Unit |
| 2 | Edge: empty | [] | ... | Unit |
| 3 | Edge: null | null | Error | Unit |
| 4 | Integration | ... | ... | Integration |
```

Coverage categories:
- Happy path (main scenario)
- Edge cases (empty, null, boundaries)
- Error cases (invalid input, exceptions)
- Integration points (if dependencies exist)

Do NOT proceed until the table is filled — skipping this step leads to incomplete test coverage that gives false confidence.

## Phase 1: RED — Write Failing Tests

1. Create test file (`feature.test.ts`)
2. Write tests for ALL cases from Phase 0
3. Run tests — they must fail

```bash
npm test -- --grep "feature"
# Expected: FAIL
```

Tests must fail first because a test that passes without implementation might be testing the wrong thing.

## Phase 2: GREEN — Minimal Code

1. Write the minimum code to make tests pass
2. Resist the urge to optimize or add "for later" — that's Phase 3
3. Run tests — they must pass

```bash
npm test -- --grep "feature"
# Expected: PASS
```

## Phase 3: REFACTOR

1. All tests green? Now refactor
2. After each change: run tests (must stay green)

Refactoring with a green test suite is safe. Refactoring without tests is gambling.

## Phase 4: Verify

```markdown
| Category | Written | Passing | Skipped |
|----------|---------|---------|---------|
| Happy path | X | X | 0 |
| Edge cases | X | X | 0 |
| Error cases | X | X | 0 |
| Integration | X | X | 0 |
```

## What to avoid

- Code before test table — leads to incomplete coverage
- Code before failing tests — the test might be wrong
- Refactoring while tests are red — you don't know if refactoring broke something or if it was already broken
- "I'll write tests later" — later never comes, and by then you've forgotten the edge cases
