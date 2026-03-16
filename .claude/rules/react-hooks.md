---
description: "Apply when writing or modifying React components with hooks. Enforces correct hook ordering to prevent React Error #310 runtime crashes."
paths:
  - "apps/web/**/*.tsx"
  - "apps/web/**/*.jsx"
---

# React Hooks Rules

## Why This Matters

React Error #310 crashed the entire page in production. A `useMemo` was placed after an early return, causing React's hook ordering to break on re-render. The fix took 5 minutes, but the crash affected all users for 20 minutes until deployed.

## Rule 1: Hooks ALWAYS at the Top

All hooks (useState, useEffect, useMemo, useCallback, useRef) go at the top of the component, before any conditional returns. This is because React tracks hooks by their call order — if the order changes between renders, React's internal state gets corrupted.

```tsx
// Correct order
function MyComponent() {
  const [data, setData] = useState(null);
  const processedData = useMemo(() => {
    if (!data) return null;
    return transform(data);
  }, [data]);
  useEffect(() => { /* ... */ }, []);

  // Early returns AFTER all hooks
  if (isLoading) return <Loader />;
  if (error) return <Error />;
  return <div>{processedData}</div>;
}
```

## Rule 2: Never Call Hooks Conditionally

```tsx
// WRONG — hook after early return
if (isLoading) return <Loader />;
const val = useMemo(() => {}, []);  // React Error #310!

// WRONG — hook inside condition
if (someCondition) {
  const [state, setState] = useState(0);  // Crash!
}
```

## Rule 3: Data Checks Go INSIDE the Hook

```tsx
const computed = useMemo(() => {
  if (!data) return defaultValue;
  return processData(data);
}, [data]);
```

## Quick Reference

- ALL hooks — top of component, BEFORE any `return`
- Data checks — INSIDE hook callbacks
- NEVER: hooks after if/return, inside conditions, loops, or try/catch
