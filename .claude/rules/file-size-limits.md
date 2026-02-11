---
description: "Apply when creating or modifying files. Enforces file size limits to prevent monolithic files. Soft limits: Routes 300, Services 400, Components 200 lines."
---

# File Size Limits

## Limits

| File Type | Soft Limit | Hard Limit |
|-----------|-----------|------------|
| Routes (*.routes.ts) | 300 | 600 |
| Services (*.service.ts) | 400 | 800 |
| Components (*.tsx) | 200 | 400 |
| Types (*.types.ts) | 200 | 400 |
| Repository (*.repository.ts) | 300 | 600 |

## When Approaching Soft Limit

1. Plan splitting BEFORE adding more code
2. Split by business domain, not technical layer
3. Exception: "High Cohesion Monolith" with justification

## FORBIDDEN

- Single file with multiple unrelated responsibilities
- Splitting that creates circular dependencies
- Files with `_part1`, `_part2` suffixes

---

**Version:** 1.0
