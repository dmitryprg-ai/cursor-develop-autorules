---
description: "Apply when writing API routes, database queries, form handling, or user input processing. Enforces input validation (Zod), SQL injection prevention, XSS protection."
paths:
  - "src/**/*.ts"
  - "apps/web/**/*.tsx"
---

# Security Standards

## Input Validation (ALL API routes)

- Every route handler MUST validate request body/params/query with Zod
- Validate BEFORE any business logic
- Return 400 with validation errors, not 500

## SQL Injection Prevention

- ALWAYS use parameterized queries ($1, $2, ...)
- NEVER concatenate user input into SQL strings
- NEVER use template literals for SQL with user data

## XSS Prevention

- Never use dangerouslySetInnerHTML with user data
- Escape HTML entities for user-provided text
- Sanitize at API boundary, not just display

## Common Anti-patterns (FORBIDDEN)

| Pattern | Risk | Fix |
|---------|------|-----|
| `eval(userInput)` | Remote Code Execution | Never use eval with user data |
| `innerHTML = userText` | XSS | Use textContent or sanitize |
| Template literal SQL | SQL Injection | Parameterized queries |
| Logging passwords/tokens | Data leak | Never log sensitive data |
| Hardcoded secrets in code | Credential exposure | Use env vars / .secrets/ |

---

**Version:** 1.0
