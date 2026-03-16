---
name: techdebt-scan
description: "Scan codebase for technical debt including oversized files, duplicated code, code smells, and TODO items. Use when files exceed size limits, when TODO/FIXME/HACK count is growing, when build is slow, when coverage is low, when user says cleanup/tech debt/code quality, or when empty catch blocks or dead code are suspected."
allowed-tools: Read, Bash, Grep, Glob
model: sonnet
user-invocable: true
disable-model-invocation: true
---

# Technical Debt Scanner

Find and safely fix technical debt using a TDD approach.

The order SCAN -> TEST CASES -> REFACTOR -> VERIFY exists because fixing debt without tests creates new debt. Skipping the scan leads to fixing low-impact issues while ignoring critical ones.

## Phase 1: SCAN

```bash
bash ${CLAUDE_SKILL_DIR}/scripts/scan-large-files.sh
bash ${CLAUDE_SKILL_DIR}/scripts/find-todos.sh
```

Also check for: functions over 50 lines, nesting deeper than 3 levels, files with 10+ exports, magic numbers.

## Phase 2: PRIORITIZE

| Impact | Low Effort | High Effort |
|--------|-----------|-------------|
| High (blocks dev) | P0 — Fix now | P1 — Plan carefully |
| Medium (reduces quality) | P2 — Quick win | P3 — Backlog |
| Low (cosmetic) | P4 — Optional | Skip |

## Phase 3: TEST CASES (before refactoring)

Write tests before changing any code because refactoring without tests is gambling. For each selected issue:
1. Create test cases table
2. Write failing tests
3. Verify tests fail (code not changed yet)

## Phase 4: REFACTOR

1. Small steps — one file at a time
2. Run tests after each change
3. Commit after each green test

## Phase 5: VERIFY

- `npm run build` — success
- `npm run lint` — 0 errors
- `npm test` — all passing

## What to avoid

- Refactoring without scanning first — you might fix the wrong things
- Skipping test cases — creates new bugs while fixing old debt
- Writing tests after refactoring — defeats the purpose of TDD safety net
- Equating "build passed" with "everything works" — build checks syntax, not behavior
