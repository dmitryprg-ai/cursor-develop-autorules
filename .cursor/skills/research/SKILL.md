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

```python
print(f"Shape: {df.shape}")
print(f"dtypes:\n{df.dtypes}")
print(f"head:\n{df.head()}")
print(f"nunique:\n{df.nunique()}")
print(f"nulls:\n{df.isnull().sum()}")
```

## Risk Profiling

| Risk | Check | Action |
|------|-------|--------|
| Missing data | `df.isnull().sum()` | Document, decide handling |
| Duplicates | `df.duplicated().sum()` | Investigate |
| Wrong types | Manual inspection | Convert types |
| Outliers | `df.describe()` | Investigate |

## Mini-Experiment Protocol

```python
# EXPERIMENT: [Description]
# HYPOTHESIS: [What we expect]
result = df[df['column'] == 'value'].shape[0]
print(f"Result: {result}")
print(f"Expected: {expected}")
print(f"Status: {'PASS' if result == expected else 'FAIL'}")
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
