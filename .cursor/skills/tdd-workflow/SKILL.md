---
name: tdd-workflow
description: Test-Driven Development workflow with strict Red-Green-Refactor cycle. Use when developing features with TDD, writing tests before code, or when test-driven approach is needed. MANDATORY order - test cases table BEFORE code, failing tests BEFORE implementation.
---

# TDD Workflow

Principle: **Red -> Green -> Refactor** (STRICT order!)

## PHASE 0: Test Planning (FIRST STEP)

Fill test cases table BEFORE any code:

```markdown
## TEST CASES (fill BEFORE implementation!)

| # | Scenario | Input | Expected Output | Type | Status |
|---|----------|-------|-----------------|------|--------|
| 1 | Happy path | <input> | <expected> | Unit | pending |
| 2 | Edge case: empty | [] | <expected> | Unit | pending |
| 3 | Edge case: null | null | Error | Unit | pending |
| 4 | Integration | <context> | <expected> | Integration | pending |
```

Coverage categories:
- [ ] Happy path (main scenario)
- [ ] Edge cases (empty data, boundaries, null/undefined)
- [ ] Error cases (invalid input, exceptions)
- [ ] Integration points (if dependencies exist)

**STOP: Do NOT proceed to Phase 1 until table is filled!**

## PHASE 1: RED -- Write Failing Tests

1. Create test file (`feature.test.ts`)
2. Write tests for ALL cases from Phase 0 table
3. Run tests -- they MUST FAIL:
   ```bash
   npm test -- --grep "feature"
   # Expected: FAIL
   ```

**STOP: Do NOT write implementation until tests fail!**

## PHASE 2: GREEN -- Minimal Code

1. Write MINIMAL code to make tests pass
2. Do NOT optimize, do NOT add "for later"
3. Run tests:
   ```bash
   npm test -- --grep "feature"
   # Expected: PASS
   ```
4. Repeat for each test case

**STOP: Do NOT refactor until ALL tests are green!**

## PHASE 3: REFACTOR

1. All tests green? -> Refactor
2. Remove duplication, improve readability
3. After EACH change: `npm test` (must stay green)

## PHASE 4: VERIFY

```markdown
## TDD VERIFICATION

| Category | Written | Passing | Skipped |
|----------|---------|---------|---------|
| Happy path | X | X | 0 |
| Edge cases | X | X | 0 |
| Error cases | X | X | 0 |
| Integration | X | X | 0 |
| **TOTAL** | X | X | 0 |
```

## FORBIDDEN

- Writing code BEFORE test cases table
- Writing code BEFORE failing tests
- Refactoring with red tests
- Skipping checkpoints
- "I'll write tests later"
