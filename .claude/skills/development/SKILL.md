---
name: development
description: "Develop new features, functionality, and enhancements. Use when creating, adding, building, implementing new features, components, endpoints, pages, or modules. Also trigger when user asks to add functionality, create a form, implement a filter, build a new UI section, or add an API endpoint."
allowed-tools: Read, Write, Bash, Grep, Glob
model: sonnet
user-invocable: true
---

# Feature Development

Build features methodically. Check first, build second.

## Pre-Action (before writing any code)

### 1. Duplicate Check

Search semantically, grep, and file search. If similar functionality exists, extend it instead of creating a duplicate. Duplicates create maintenance burden — when the original changes, the copy becomes a silent source of bugs.

### 2. JTBD Analysis (for user-facing features)

**Job Story:** When [context], user wants [action], to get [result]

Three questions before coding:
- What task is the user actually solving?
- What is blocking them right now?
- How will they know the job is done?

This prevents building features nobody uses because the feature solves the wrong problem.

### 3. Find Working Example

For UI: find a working pattern in the project first. Copy the pattern, then adapt. Inventing CSS class combinations from scratch leads to inconsistent UI and wasted debugging time.

### 4. Control File Size

Plan logic across multiple files before starting. Soft limits: routes 300 lines, services 400, components 200. Large files become hard to review and often hide multiple responsibilities.

## Backend Pattern

```
module.types.ts -> module.repository.ts -> module.service.ts -> module.routes.ts
```

Types define the contract. Repository handles DB. Service contains business logic. Routes wire HTTP to services. This separation exists so changes to DB queries don't require touching HTTP handlers.

## Frontend Pattern

- App Router for pages (`apps/web/app/`)
- Feature components (`apps/web/features/`)
- Tailwind CSS v4 (no responsive prefixes like `md:`)
- shadcn/ui components, KtCard wrapper

## Common Pitfalls

- **UI patterns**: Always find a working example in the project first. Don't guess CSS classes.
- **Types**: Database bigint returns as JSON string. Always `Number()` in code.
- **External APIs**: List/Enum fields may contain IDs, not text. Check field mapping.
- **Entry points**: Use high-level orchestrator services (`*SummaryService.syncDay()`), not low-level methods.

## Verification

- 0 linter errors
- Tests pass (if tests exist)
- JTBD job is fulfilled
- All changed files opened and verified
- If deploying: service restarted after build
