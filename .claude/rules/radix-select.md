---
description: "Apply when using Radix UI Select or shadcn/ui Select components. Prevents white screen crash from empty string values."
paths:
  - "apps/web/**/*.tsx"
---

# Radix Select — Empty Value Crash

## Why This Matters

Empty string value caused white screen for all users. Radix UI Select does NOT support `value=""` — it throws a runtime error that crashes the entire React tree. This happened in production when a filter component defaulted to empty string.

## The Rule

Never use `value=""` in SelectItem. Use a placeholder constant instead:

```tsx
// WRONG — crashes at runtime
<SelectItem value="">Not selected</SelectItem>

// CORRECT — use a placeholder value
const NONE_VALUE = '__none__';
<Select
  value={value || NONE_VALUE}
  onValueChange={(v) => setValue(v === NONE_VALUE ? '' : v)}
>
  <SelectContent>
    <SelectItem value="__none__">Not selected</SelectItem>
    <SelectItem value="team_a">Team A</SelectItem>
  </SelectContent>
</Select>
```

## Quick Reference

- NEVER: `value=""` or `value={undefined}` in SelectItem
- ALWAYS: use `__none__` for placeholder, convert in onChange handler
