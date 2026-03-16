---
name: research
description: "Analyze data, investigate datasets, debug with data, and explore system behavior. Use when analyzing, running SQL queries, data profiling, investigating patterns, building statistics, exploring CSV/JSON data, or debugging with data evidence."
allowed-tools: Read, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Data Research Protocol

Principle: **Data first, code second.**

Jumping to conclusions without examining the data leads to building solutions for problems that don't exist. Every assumption needs verification with actual data.

## Workflow

1. **LOAD** — Verify data is accessible (DB connection, file exists, API responds)
2. **SCHEMA** — Examine structure, types, relationships before analyzing
3. **PROFILE** — Check for risks: nulls, duplicates, outliers, wrong types
4. **HYPOTHESIS** — Formulate what you expect to find (and what would disprove it)
5. **EXPERIMENT** — Test ONE hypothesis at a time with a focused query
6. **DOCUMENT** — Record findings with evidence, not opinions

## Schema Analysis

### PostgreSQL

```sql
-- Schema inspection
SELECT column_name, data_type, is_nullable
FROM information_schema.columns WHERE table_name = 'target';

-- Data profiling
SELECT count(*), count(DISTINCT column_name),
       count(*) FILTER (WHERE column_name IS NULL) as nulls
FROM target;

-- Distribution
SELECT column_name, count(*) FROM target GROUP BY 1 ORDER BY 2 DESC LIMIT 20;
```

### TypeScript

```typescript
console.log(`Records: ${data.length}`);
console.log(`Keys: ${Object.keys(data[0] || {})}`);
const nullCount = data.filter(item => item.field == null).length;
const uniqueCount = new Set(data.map(item => item.field)).size;
```

## Risk Profiling

| Risk | How to detect |
|------|--------------|
| Missing data | Count nulls per column |
| Duplicates | Compare total vs distinct count |
| Wrong types | Check actual types vs expected |
| Outliers | Look at min/max, percentiles |

## Mini-Experiment Protocol

```
EXPERIMENT: [Description]
HYPOTHESIS: [What we expect]
METHOD: [Query or code]
RESULT: [Actual output]
STATUS: CONFIRMED / DISPROVED
```

Rules: one question per experiment, fast execution, logged results, compared with expectations.

## Cognitive Bias Prevention

- Analyze ALL data, not just the first N records (survivorship bias)
- Actively look for evidence that DISPROVES your hypothesis (confirmation bias)
- Check edge cases and outliers, not just the median (anchoring bias)

## Safety

- Read-only database queries (SELECT only)
- Always include LIMIT on exploratory queries
- Never modify production data during research
