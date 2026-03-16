---
description: "Apply when creating React components or API routes. Enforces error boundaries, loading/error/empty states, and proper API error handling patterns."
paths:
  - "src/**/*.ts"
  - "apps/web/**/*.tsx"
---

# Error Handling Patterns

## Why This Matters

Missing loading state showed blank page for 3 seconds on slow connections — users thought the app was broken and refreshed, causing duplicate API calls. Empty catch blocks silenced a database connection error for 2 days before anyone noticed data wasn't syncing.

## React Components — State Triforce

Every data-fetching component needs 3 states because users encounter loading, errors, and empty data in production — missing any one creates a confusing experience:

```tsx
// All 3 states handled
if (isLoading) return <LoadingSpinner />;
if (error) return <ErrorMessage error={error} onRetry={refetch} />;
if (!data || data.length === 0) return <EmptyState message="No items found" />;
return <DataView data={data} />;
```

## API Route Error Handling

Every API route needs structured error handling because unhandled errors crash the entire Node.js process:

```typescript
router.get('/endpoint', async (req, res) => {
  try {
    const result = await service.getData();
    res.json(result);
  } catch (error) {
    console.error('[endpoint] Error:', error);
    res.status(500).json({
      error: 'Internal server error',
      message: error instanceof Error ? error.message : 'Unknown error'
    });
  }
});
```

## What to Avoid

| Pattern | Why It's Dangerous | Fix |
|---------|-------------------|-----|
| Empty catch `catch {}` | Errors disappear silently, bugs compound | Log + handle appropriately |
| `console.log` only | No user feedback, no error recovery | Return error response to client |
| Missing loading state | White screen confuses users | Add loading indicator |
| Missing empty state | Blank screen looks broken | Show "no data" message |
