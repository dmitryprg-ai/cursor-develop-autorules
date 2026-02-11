---
description: "Apply when working with paginated APIs (REST, GraphQL, Bitrix24). Prevents infinite loops and data corruption from incorrect pagination."
paths:
  - "src/modules/bitrix24/**"
  - "src/**/*repository*"
  - "src/**/*service*"
---

# API Pagination Safety

## Critical Rule

NEVER rely on `response.length < limit` to detect last page.

Bitrix24 at `start > total` returns records WITHOUT filter — can load 333K records instead of 100.

## Required Pattern

```typescript
// GOOD: Use total from API response
let start = 0;
const limit = 50;
const MAX_SAFETY = 100000;

while (start < MAX_SAFETY) {
  const response = await api.call({ start, limit });
  const total = response.total; // USE THIS

  process(response.result);
  start += limit;

  if (start >= total) break; // CORRECT: compare with total
}
```

## FORBIDDEN

```typescript
// BAD: Relies on response length
while (results.length === limit) { // DANGEROUS
  start += limit;
  results = await api.call({ start, limit });
}
```

---

**Version:** 1.0
