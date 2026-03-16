# Project Memory — CRMAI

## Architecture

- **Backend:** Node.js 20+, TypeScript, Express, PostgreSQL, Zod (port 5003)
- **Frontend:** Next.js 16+, React 19, Tailwind CSS v4, shadcn/ui (port 3001)
- **Deploy:** systemd services: `crmai` (backend), `crmai-web` (frontend)
- **Module pattern:** types.ts -> repository.ts -> service.ts -> routes.ts

## Learned Patterns

- Bitrix24 pagination: use `total` from response, never `response.length < limit`. At `start > total`, API returns records WITHOUT filter — loaded 333K instead of 100 in production.
- Bitrix24 UF-fields: "List" type returns IDs, not text values. Need mapping table.
- PostgreSQL bigint comes as JSON string — always use `Number()` in TypeScript.
- Tailwind v4: responsive prefixes like `md:` may not generate classes. Use base classes only.
- Radix Select: `value=""` causes crash. Use `__none__` placeholder, convert in onChange.
- React hooks: ALL hooks must be called BEFORE any early return. Conditional hooks cause React Error #310.
- Chat messages: check text `startsWith('=== Исходящее')` for outgoing, not `is_manager` field.
- Build without restart = broken site. Next.js serves old build until systemd service restarts.
- No parallel Bitrix24 syncs — rate limits will cause failures.

## Key Entry Points

- Backend entry: `src/index.ts`
- Bitrix24 routes: `src/modules/bitrix24/bitrix24.routes.ts` + `src/modules/bitrix24/routes/`
- Use `*SummaryService.syncDay()`, not low-level methods
- Frontend pages: `apps/web/app/` (App Router)
- Feature components: `apps/web/features/`
- API clients: `apps/web/lib/api/` (modular by feature)

## User Preferences

- Communication language: Russian
- Code and comments: English
- Commit style: Conventional Commits (`feat(scope): description`)
- File limits: routes 300, services 400, components 200, types 200
- UI: shadcn/ui components, KtCard wrapper, Tailwind CSS v4
