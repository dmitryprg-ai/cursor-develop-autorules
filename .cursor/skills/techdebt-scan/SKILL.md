---
name: techdebt-scan
description: Scan codebase for technical debt and fix safely with TDD. Use to find oversized files, duplicated code, code smells, and refactor safely. Workflow - SCAN, TEST CASES, REFACTOR, VERIFY. Keywords - techdebt, tech debt, duplicates, code quality audit.
disable-model-invocation: true
---

# Technical Debt Scanner

Find and safely fix technical debt using TDD approach.

**Order: SCAN -> TEST CASES -> REFACTOR -> VERIFY** (do NOT skip steps!)

## Phase 1: SCAN

Run scan scripts:
```bash
bash .cursor/skills/techdebt-scan/scripts/scan-large-files.sh
bash .cursor/skills/techdebt-scan/scripts/find-todos.sh
```

Then check for:
- Files > 300 lines (routes, services, components > 200 lines)
- Duplicated code patterns (grep for identical blocks > 5 lines)
- Functions > 50 lines
- Deep nesting (> 3 levels)
- Files with > 10 exports
- Magic numbers/strings

### Scan Results Template

```markdown
## TECHDEBT SCAN RESULTS — [date]

### Oversized Files
| File | Lines | Limit | Severity |
|------|-------|-------|----------|
| <path> | X | Y | HIGH/MED |

### Duplicate Code
| Pattern | File 1 | File 2 | Lines | Severity |
|---------|--------|--------|-------|----------|
| <desc> | <path> | <path> | X | HIGH/MED |

### Code Smells
| Type | Location | Description | Severity |
|------|----------|-------------|----------|
| Long function | <path>:<line> | X lines | MED |

### Exceptions (NOT violations)
| File | Exception Type | Reason |
|------|---------------|--------|
| <path> | High Cohesion Monolith | <reason> |
```

**High Cohesion Monolith criteria:**
- Single business responsibility (not a god-object)
- High method cohesion -- methods share common state
- Splitting requires full test coverage for safety

## Phase 2: PRIORITIZE

| Severity | Impact | Effort | Priority |
|----------|--------|--------|----------|
| HIGH | Blocks development | Low | P0 -- Fix now |
| HIGH | Blocks development | High | P1 -- Plan |
| MED | Reduces quality | Low | P2 -- Quick win |
| MED | Reduces quality | High | P3 -- Backlog |
| LOW | Cosmetic | Any | P4 -- Optional |

## Phase 3: TEST CASES (MANDATORY before refactoring)

Write tests BEFORE any code changes. For each selected issue:

1. Create test cases table
2. Write failing tests
3. Verify tests FAIL (code not changed yet)

## Phase 4: REFACTOR

1. Small steps -- one file at a time
2. Run tests after EACH change
3. Commit after each green test

## Phase 5: VERIFY

```markdown
## TECHDEBT FIX VERIFICATION
| ID | Description | Tests Written | Tests Passing | Status |
|----|-------------|---------------|---------------|--------|
| D1 | <desc> | X | X | OK |

- [ ] `npm run build` -- success
- [ ] `npm run lint` -- 0 errors
- [ ] `npm test` -- all passing
```

## FORBIDDEN

- Refactoring without SCAN first
- Refactoring without TEST CASES
- Writing tests AFTER refactoring
- "Build passed = everything works"
