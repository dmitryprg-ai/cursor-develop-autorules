---
name: backlog-to-rules
description: "Implement accumulated improvements from improvements-backlog into AI rules and skills. Use when backlog has 5+ items, weekly rule update cycle, 2+ high priority improvements exist, before important releases, when same error repeated 3+ times, when user says implement improvements/process backlog/update rules from errors."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Backlog to Rules

Turn accumulated error experience into concrete rules that prevent repetition. Every error that reaches production twice is a missing rule.

## When to Run

| Condition | Priority |
|-----------|----------|
| 5+ improvements in backlog | Mandatory |
| Week since last implementation | Recommended |
| 2+ High priority improvements | Mandatory |
| Before important release | Recommended |
| Same error repeated 3+ times | Immediate |

## Process (7 Phases)

### Phase 1: Analyze

1. Open `.cursor/data/improvements-backlog.md`
2. Group improvements by target files
3. Collect statistics (total, high/medium/low priority)
4. Identify error patterns (merge similar ones)

### Phase 2: Research

For each target file:
1. Read current structure
2. Determine where to add each improvement (existing or new section)
3. Check for conflicts with existing rules

### Phase 3: Plan

1. List changes by file
2. Define success criteria
3. For complex cases — full plan (see `references/templates.md`)

### Phase 4: Implement

Implementation rules:
- Add new sections — do NOT replace existing ones because existing rules were validated by real errors
- Each rule with a concrete code/command example
- Each rule with WHY (real error case) because rules without reasoning get ignored
- Preserve file format (tables, code blocks)
- After each file — re-read entirely, verify structure

### Phase 5: Verify

1. All existing sections preserved
2. New sections supplement, not replace
3. Format matches file style
4. Cross-file references intact
5. Cross-check: every file opened and verified

### Phase 6: Update Backlog

1. Update statuses: Backlog -> Done
2. Move to "Implemented" section in brief format
3. Update header statistics

### Phase 7: Summary

Report: how many implemented, which files updated, which patterns prevented, confidence.

## Quick Version (1-2 improvements)

1. Open backlog, find improvement
2. Open target instruction file
3. Add section at end of corresponding area
4. Include WHY with real error case
5. Update backlog status to Done

## Quality Framework

| Element | What to include |
|---------|-----------------|
| Input | What triggers the rule |
| Output | What should be done |
| Success Metrics | How to measure success |
| Guardrails | What is forbidden, boundaries |
| WHY | Real error case |

## References

- [templates.md](references/templates.md) — analysis, plan, and verification templates
- [anti-patterns.md](references/anti-patterns.md) — common mistakes when implementing rules
