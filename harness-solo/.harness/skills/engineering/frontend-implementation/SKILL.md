---
name: frontend-implementation
description: Frontend Implementation — component decomposition/state management/styling engineering (not visual design)
---
# Frontend Implementation — Frontend Engineering

## When to use
- When implementing frontend components
- When selecting a state management approach
- When establishing the styling engineering
- When designing frontend architecture

## Inputs
- constitution.md
- rules/security.md
- docs/engineering/TECH_STACK.md
- docs/handoff/design-to-solo.md
- docs/handoff/component-map.json
- docs/design-system/tokens.json
- docs/design-system/tokens.css
- docs/design-system/DESIGN.md
- docs/interaction/component-spec.md

## Outputs
- loops/specs/<feature>/iterations.log

## Iron Rule
**Composition over configuration.** `<Card><CardHeader><CardTitle>` is better than `<Card title="..." headerVariant="large">`. Component composition > configuration explosion.

## Positioning

This skill is **engineering implementation**, not visual design:
- Visual design (color/typography/branding) → handed off by harness-design via `docs/handoff/`
- **This skill handles**: component structure, state management, styling engineering approach selection, three-state handling

## Consuming Design Assets (from harness-design)

This skill has a hard dependency on harness-design outputs and reads them per the following contracts:

### 1. component-map.json (explicit mapping layer, core contract)

Read `docs/handoff/component-map.json` as the **single source of truth** for component implementation:

```json
{
  "PrimaryButton": {
    "designToken": "button.primary",
    "engineeringComponent": "Button",
    "props": { "variant": "primary", "size": "md" },
    "states": ["default", "hover", "active", "disabled", "loading"],
    "notes": "Primary action button, at most 1 per screen"
  }
}
```

**Consumption rules**:
- `engineeringComponent` → engineering component name (e.g. `Button`), used directly as the code component name
- `props` → contract for component props; all must be implemented
- `states` → all states must be covered (none can be missing; a missing state is a design omission, feed it back to harness-design)
- `designToken` → token name linked to tokens.json; hardcoded values are forbidden

**Framework-agnostic constraint**: the props Type must match the framework in `docs/engineering/TECH_STACK.md`:
- React → `ReactNode` / `JSX.Element`
- Vue → `VNode` / `Slot`
- Svelte → `Snippet` / `Component`
- Native/Web Components → `HTMLElement` / `Slot`
- If the Type in component-map.json does not match the project framework, mark it as "to be aligned with harness-design"

### 2. tokens.json / tokens.css (design tokens)

Read `docs/design-system/tokens.json` (structured) and `tokens.css` (directly importable) as the **source of spacing/color/type scale** for styling engineering:
- spacing scale → arbitrary pixel values are forbidden; values must come from the scale
- color token → use semantic tokens like `text-primary` / `bg-surface`; bare `#333` is forbidden
- type scale → use the design system's font size scale; do not pick arbitrary values

### 3. DESIGN.md (10-section design system definition)

Read `docs/design-system/DESIGN.md` to understand the global constraints of the design system (Aesthetic Direction / Color System / Typography Scale / Layout Principles, etc., 10 sections in total).

### 4. component-spec.md (interactive component spec)

Read `docs/interaction/component-spec.md` to obtain the interaction behavior spec for components (gestures/animations/state transitions).

### 5. design-to-solo.md (handoff notes)

Read `docs/handoff/design-to-solo.md` to obtain:
- Design AC-xxx checklist (e.g. "contrast ≥4.5:1", "no overflow at 375px") → flows into verify checks
- Design asset paths (`docs/visual/<page>.md` / `docs/interaction/<page>.md`)
- Open items (questions to confirm with design)

## Component Design

### 1. Container vs. Presentation separation
- **Container**: handles data (fetch/loading/error/empty three states), does not care about UI
- **Presentation**: pure rendering, props in and UI out, does not care about data source

### 2. Single Responsibility
- Component > 200 lines → split
- One component does one thing: either fetch data, render UI, or handle interaction
- Naming describes responsibility: `UserList` / `UserListItem` / `EmptyState`

### 3. Composition over Configuration
```tsx
// ✓ Composition (recommended)
<Card>
  <CardHeader>
    <CardTitle>Title</CardTitle>
  </CardHeader>
  <CardBody>Content</CardBody>
</Card>

// ✗ Configuration explosion (avoid)
<Card title="Title" headerVariant="large" bodyPadding="md" showHeader={true}>
  Content
</Card>
```

### 4. Colocate
Everything related to a component lives in the same directory:
```
UserList/
├── UserList.tsx        # implementation
├── UserList.test.tsx   # tests
├── UserList.stories.tsx # stories (if any)
├── useUserData.ts      # related hook
└── types.ts            # types
```

## State Management Selection

**Use the simplest solution; upgrade on demand**:

| Scenario | Approach | When to use |
|------|------|--------|
| In-component UI state | `useState` | toggles, input values, tab switching |
| Shared across 2-3 sibling components | Lifted state | lift to common parent |
| Global read-heavy write-light | `Context` | theme / auth / locale |
| Shareable / bookmarkable | URL state | filters / pagination / sorting |
| Remote data + caching | React Query / SWR | API data (loading/error/cache) |
| Complex global client state | Zustand / Redux | state frequently updated across many components |

**Selection principles**:
- Start with `useState`; upgrade only when insufficient
- Avoid prop drilling beyond 3 levels (use Context or a state library)
- Do not prematurely introduce Redux for "future possible needs"

## Styling Engineering

### 1. Design system constraints
- **spacing scale**: use the design system's spacing scale (e.g. increments of 0.25rem: 0.25 / 0.5 / 1 / 1.5 / 2 / 3 / 4)
- **No arbitrary pixel values**: do not use `13px` / `2.3rem`; use values from the scale
- **Semantic color tokens**: use `text-primary` / `bg-surface`; do not use bare `#333`
- **Type scale**: use the design system's type scale; do not pick arbitrary values

### 2. Responsive
- **Mobile-first**: start with small screens, upgrade with `min-width` media queries
- **Required breakpoints**: 320 / 768 / 1024 / 1440
- Retrofitting responsiveness later costs 3× as much; do it from the start

### 3. Avoid the AI default aesthetic
- Purple everywhere, excessive gradients, `rounded-2xl` for everything, stock card grids, stacked shadows
- These are "the generic look of AI-generated code", not "UI written by an engineer with strong design sense"
- Visual specs are produced by harness-design; this skill implements per the spec

## Three-State Handling (mandatory)

Every data-driven component must handle three states:

```tsx
function UserList() {
  const { data, isLoading, error } = useUserData();

  if (isLoading) return <Skeleton />;      // loading state
  if (error) return <ErrorMessage error={error} />;  // error state
  if (!data?.length) return <EmptyState />;  // empty state

  return <ul>{data.map(user => <UserListItem key={user.id} user={user} />)}</ul>;
}
```

**Forbidden**: writing only the happy path and ignoring loading/error/empty.

## Accessibility (WCAG 2.1 AA baseline)

- Every interactive element is keyboard reachable (traversable via Tab)
- Controls without visible text have `aria-label`
- Color is not the only state indicator (add icons/text)
- `<img>` must have `alt`
- Use `<button>`, not `<div onClick>`

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "Write the component big first, split later" | 200 lines is a red line; split once exceeded |
| "Responsive can wait" | Retrofitting later costs 3× as much |
| "Accessibility is nice-to-have" | It is a legal requirement and an engineering quality standard in many places |
| "Use Redux first to be safe" | Over-engineering; start with useState |
| "Design isn't finalized, skip styles for now" | Use design system defaults; an unstyled UI leaves a bad impression |
| "Skip the loading state for now" | Three states are mandatory, not optional |

## Prohibitions
- Components > 200 lines without splitting
- Inline styles (`style={{ color: 'red' }}`)
- Arbitrary pixel values (values outside the scale)
- Missing loading/error/empty three states
- Color as the only state indicator
- `<div onClick>` instead of `<button>`
- `<img>` without `alt`
- Prop drilling beyond 3 levels without extracting a Context

## Relationship with LOOP
This skill is triggered in the ACT phase of LOOP:
- Frontend component implementation → this skill guides structure → tdd writes tests → verify validates
- Not triggered independently outside LOOP (implementation code must be inside LOOP)

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| frontend-implementation | Frontend engineering implementation (structure/state/styling) |
| tdd | Unit tests for component logic |
| webapp-testing | Frontend verification (build/type/lint/accessibility) |
| verify | Comprehensive verification (invokes webapp-testing) |
| writing-documentation | Component API docs (prop types) |

## Evidence Requirements
After implementation is complete, record in evidence.md:
```
## Frontend Implementation
- Component structure: X components, max Y lines (≤200 ✓)
- State management: chose <approach>, reason: <one sentence>
- Three-state handling: loading ✓ / error ✓ / empty ✓
- Accessibility: keyboard reachable ✓ / aria-label ✓ / alt ✓
- Responsive: 320/768/1024/1440 four breakpoints ✓
```
