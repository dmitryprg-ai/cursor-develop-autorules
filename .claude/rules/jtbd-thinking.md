---
description: "Apply when developing user-facing features. Jobs To Be Done thinking: Job Story format instead of User Story, benefits vs effort taxes balance, three key questions before development."
---

# JTBD Thinking — Jobs To Be Done

## Why This Matters

Building features without understanding the user's Job leads to technically correct but useless implementations. A date filter is meaningless if the user's actual job is "quickly find overdue deals" — they might need a pre-filtered view, not a generic picker.

## Job Story Format

Instead of User Story, use Job Story because it focuses on the situation and desired outcome:

```
BAD:  "As a user, I want a filter to search"
GOOD: "When [situation], I want [action], to get [benefit]"
```

| Feature-focused (bad) | Job-focused (good) |
|----------------------|-------------------|
| "Add filter" | "When searching deals for a period, I want to quickly select dates, to see only relevant ones" |
| "Export button" | "When preparing a report, I want to export data, to avoid manual copying" |

## Benefits vs Effort Taxes

UI text should emphasize benefits (at least 60%), not effort:

| Benefit (good) | Tax (bad) |
|----------------|-----------|
| Reduces workload | Requires effort |
| Promises result | Unclear purpose |
| "See which deals need attention" | "Configure integration" |

## 3 Key Questions Before Development

| # | Question | Purpose |
|---|----------|---------|
| 1 | What task is the user performing? | Target, not feature |
| 2 | What blocks them now? | Real problem |
| 3 | How will they know the task is done? | Success criteria |

## Quick Reference

- UI text about BENEFITS, not about features
- "See which deals need attention" — not "Algorithm analyzes"
- Minimum steps to result
- No corporate jargon
