# State Management Matrix — Reference

The full selection matrix, applicability conditions, and Good/Bad examples for frontend state management. The main SKILL.md keeps only the one-sentence summary; this file holds the canonical detail. Read it before choosing a state management approach.

## Selection Principle

Use the simplest solution that fits; escalate on demand. Start with `useState` and escalate only when you can cite a concrete pain point the current level cannot solve. "Future possible needs" is never a valid escalation trigger.

## Selection Matrix

| # | Scenario | Approach | When to use | Escalation trigger |
|---|----------|----------|-------------|--------------------|
| 1 | In-component UI state | `useState` | toggles, input values, tab switching, single-component form fields | State needs to be read by a sibling → escalate to scenario 2 |
| 2 | Shared across 2-3 sibling components | Lifted state | lift to the nearest common parent; pass via props | Prop drilling exceeds 3 levels → escalate to scenario 3 or 6 |
| 3 | Global read-heavy, write-light | `Context` | theme / auth / locale / feature flags — many readers, rare writers | Writes become frequent (per-interaction) → escalate to scenario 6 |
| 4 | Shareable / bookmarkable | URL state | filters / pagination / sorting / active tab that should survive reload | State is large or includes non-serializable data → keep in scenario 6 |
| 5 | Remote data + caching | React Query / SWR | API data with loading/error/cache concerns | Mutations need cross-resource optimistic updates → scenario 6 |
| 6 | Complex global client state | Zustand / Redux | state frequently updated across many components; client-side domain state | — (top of ladder) |

## Applicability Conditions

- **`useState`** — default choice for any UI state that lives and dies with one component. No setup, no boilerplate. Reach for it first.
- **Lifted state** — when 2-3 siblings need the same value and the common parent is within 1-2 levels. Stop lifting the moment prop drilling crosses 3 levels.
- **`Context`** — when many components read a value that rarely changes. Context value changes force every consumer to re-render, so it is a poor fit for frequently-updated state.
- **URL state** — when the user would want to share, bookmark, or reload into the exact view. Pagination, filters, and sort order are the canonical cases.
- **React Query / SWR** — for any remote data that needs caching, dedup, loading, or error handling. Do not re-implement what these libraries give you.
- **Zustand / Redux** — for client-side domain state that many components both read and write. Reach for this only when scenarios 1-5 are insufficient.

## Good vs. Bad

### Scenario 2 — Lifted state

```tsx
// Good — lifted to the common parent, passed via props (1 level deep)
function FilterPanel() {
  const [query, setQuery] = useState('');
  return (
    <>
      <SearchInput value={query} onChange={setQuery} />
      <ResultList query={query} />
    </>
  );
}

// Bad — prop drilling 4 levels deep to share one string
// <GrandParent> → <Parent> → <Child> → <SearchInput> (query)
// Escalate to Context or a state library instead.
```

### Scenario 3 — Context

```tsx
// Good — read-heavy, write-light (theme toggled rarely)
const ThemeContext = createContext<{ theme: Theme; toggleTheme: () => void }>(...);
function useTheme() { return useContext(ThemeContext); }

// Bad — putting per-keystroke form state in Context
// Every keystroke re-renders every consumer; use useState or lift instead.
```

### Scenario 5 — Remote data

```tsx
// Good — React Query handles loading/error/cache
const { data, isLoading, error } = useQuery({ queryKey: ['users'], queryFn: fetchUsers });

// Bad — hand-rolling cache in a useEffect + useState
// Reimplements caching, dedup, and race-condition handling that React Query already solves.
```

### Scenario 6 — Complex global state

```tsx
// Good — Zustand store for client-side domain state many components read+write
const useCart = create((set) => ({
  items: [],
  addItem: (item) => set((s) => ({ items: [...s.items, item] })),
}));

// Bad — Redux wired up "in case we need it later"
// Adds boilerplate for a future that may never arrive; start with useState.
```

## What NOT to do

- Introduce Redux/Zustand on day one for "future possible needs" — escalate on evidence, not anticipation.
- Put frequently-updating state in Context — it forces every consumer to re-render on every change.
- Hand-roll remote-data caching when React Query / SWR already solves it.
- Let prop drilling cross 3 levels without extracting a Context or a state library.
- Mix URL state and component state for the same value — pick one source of truth.
