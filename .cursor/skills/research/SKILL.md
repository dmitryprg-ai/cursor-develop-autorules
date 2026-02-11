---
name: research
description: Analyze data, investigate datasets, work with CSV/parquet/pandas/dataframes. Use when analyzing data, exploring datasets, running experiments, or when user mentions data, analysis, parquet, csv, pandas, dataframe, statistics, investigation.
---

# Data Research Protocol

Principle: **DATA FIRST, CODE SECOND.**

## Workflow

1. **LOAD** -- Load data, verify accessibility
2. **SCHEMA** -- Show structure (types, shape, samples)
3. **PROFILE** -- Find risks (nulls, duplicates, anomalies)
4. **HYPOTHESIS** -- What do we want to prove?
5. **EXPERIMENT** -- One small test
6. **DOCUMENT** -- Record findings per 5W+H format

## Schema Analysis (MANDATORY before any conclusions)

Choose analysis method based on project stack:

### PostgreSQL / SQL (for database analysis)

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

### TypeScript (for API/application data)

```typescript
// Shape and types
console.log(`Records: ${data.length}`);
console.log(`Keys: ${Object.keys(data[0] || {})}`);

// Profiling
const nullCount = data.filter(item => item.field == null).length;
const uniqueCount = new Set(data.map(item => item.field)).size;
const duplicates = data.length - uniqueCount;
```

### Python / pandas (for file-based data)

```python
print(f"Shape: {df.shape}")
print(f"dtypes:\n{df.dtypes}")
print(f"head:\n{df.head()}")
print(f"nunique:\n{df.nunique()}")
print(f"nulls:\n{df.isnull().sum()}")
```

## Risk Profiling

| Risk | SQL Check | TypeScript Check | Python Check |
|------|-----------|------------------|--------------|
| Missing data | `count(*) FILTER (WHERE col IS NULL)` | `data.filter(x => x.col == null).length` | `df.isnull().sum()` |
| Duplicates | `count(*) - count(DISTINCT col)` | `data.length - new Set(data.map(x => x.col)).size` | `df.duplicated().sum()` |
| Wrong types | `SELECT pg_typeof(col)` | `typeof item.field` | `df.dtypes` |
| Outliers | `percentile_cont(0.99)` | Sort + inspect extremes | `df.describe()` |

## Mini-Experiment Protocol

```
# EXPERIMENT: [Description]
# HYPOTHESIS: [What we expect]
# METHOD: [SQL query / TypeScript code / Python code]
# RESULT: [actual output]
# EXPECTED: [what we expected]
# STATUS: PASS / FAIL
```

Rules:
- One question per experiment
- Fast (< 30 seconds)
- Logged (print results)
- Compared with expectation

## Cognitive Bias Prevention

- Do NOT analyze only first N records (survivorship bias)
- Do NOT look only for confirmations (confirmation bias)
- Analyze ALL data
- Actively look for DISPROOF of hypothesis
