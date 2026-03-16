---
name: cache-analysis
description: "Analyze Claude Code prompt cache efficiency and costs. Use when user asks about cache performance, token usage, session costs, how much a session cost, wants to optimize prompt caching, when costs seem high, when context window is filling up, or mentions cache-analyzer/cache hits/token costs/session metrics/cost analysis."
allowed-tools: Bash, Read, Grep
model: haiku
user-invocable: true
---

# Cache Analysis

Measure and optimize prompt cache performance using claude-cache-analyzer. Cache efficiency directly impacts cost — a 95% hit rate saves ~80% vs no caching.

## Prerequisites

```bash
pip install claude-cache-analyzer
```

## Quick Analysis

```bash
# All recent sessions
claude-cache-analyzer "C:\Users\Divan\.claude" --top 10

# Specific project
claude-cache-analyzer "C:\Users\Divan\.claude\projects\PROJECT_DIR" --top 5

# Grouped by project
claude-cache-analyzer "C:\Users\Divan\.claude" -g

# Export to JSON for programmatic analysis
claude-cache-analyzer "C:\Users\Divan\.claude" --export-json metrics.json

# Detailed single session
claude-cache-analyzer -s SESSION_ID
```

## Key Metrics

| Metric | What It Means | Good Value |
|--------|---------------|------------|
| Cache hit rate | % of tokens served from cache | > 80% |
| Efficiency score | Overall cache utilization [0..1] | > 0.70 |
| Net savings | Money saved minus cache write overhead | Positive |
| Savings % | Cost reduction vs no-cache baseline | > 70% |

## Performance Grades

| Grade | Efficiency Score | Action |
|-------|-----------------|--------|
| A | >= 0.70 | Excellent — no changes needed |
| B | >= 0.50 | Good — minor optimization possible |
| C | >= 0.30 | Fair — review instruction structure |
| D | >= 0.10 | Poor — rules/skills may be too dynamic |
| F | < 0.10 | Critical — architecture needs rework |

## Optimization Tips

If cache efficiency is low, the cause is usually rules or context that change too frequently between turns:

1. **Move volatile content to references/** — only loaded when needed, not cached in every turn
2. **Keep SKILL.md stable** — frequent edits invalidate cache across all sessions
3. **Use path-scoped rules** — rules loaded for specific files don't pollute the cache for unrelated work
4. **Prefer agent-decided rules** over always-loaded — reduces base context size

## Why This Matters

Cache efficiency = cost efficiency. On this project, 95% hit rate saves ~$119 per session. A drop to 50% would triple the cost. Monitoring cache performance catches regressions from rule/skill changes before they become expensive.
