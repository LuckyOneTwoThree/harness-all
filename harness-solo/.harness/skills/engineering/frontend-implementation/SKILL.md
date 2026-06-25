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
- Reference/component-map-contract.md
- Reference/state-management-matrix.md

## Outputs
- loops/specs/<feature>/iterations.log

## Iron Rule
**Composition over configuration.** `<Card><CardHeader><CardTitle>` is better than `<Card title="..." headerVariant="large">`. Component composition > configuration explosion.

## Positioning
This skill is **engineering implementation**, not visual design:
- Visual design (color/typography/branding) → handed off by harness-design via `docs/handoff/`
- **This skill handles**: component structure, state management, styling engineering approach selection, three-state handling

## Consuming Design Assets (from harness-design)
This skill has a hard dependency on harness-design outputs. Read each asset per its contract; do not improvise.
- **`docs/handoff/component-map.json`** — single source of truth for component implementation. Schema, consumption rules, framework Type alignment, and a worked example live in `Reference/component-map-contract.md`.
- **`docs/design-system/tokens.json` / `tokens.css`** — spacing/color/type scale. Hardcoded values are forbidden; resolve every value through a token.
- **`docs/design-system/DESIGN.md`** — global design system constraints (10 sections).
- **`docs/interaction/component-spec.md`** — interaction behavior spec (gestures / animations / state transitions).
- **`docs/handoff/design-to-solo.md`** — handoff notes: design AC-xxx checklist (flows into verify), asset paths, open items.
When sources conflict, follow the priority order in `Reference/component-map-contract.md`. A contradiction is a handoff defect — feed it back to harness-design.

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
// Good — composition
<Card><CardHeader><CardTitle>Title</CardTitle></CardHeader><CardBody>Content</CardBody></Card>
// Bad — configuration explosion
<Card title="Title" headerVariant="large" bodyPadding="md" showHeader={true}>Content</Card>
```

### 4. Colocate
Everything related to a component lives in the same directory: `UserList/` contains `UserList.tsx` (impl), `UserList.test.tsx` (tests), `UserList.stories.tsx` (stories), `useUserData.ts` (hook), and `types.ts`.

## State Management Selection
Use the simplest solution that fits; escalate on demand. The full selection matrix (6 scenarios with escalation triggers), applicability conditions, and Good/Bad code examples live in `Reference/state-management-matrix.md`. In short: start with `useState`, lift to a common parent for 2-3 siblings, escalate to Context / URL state / React Query / Zustand only when you can cite a concrete pain point — never "for future possible needs".

## Styling Engineering

### 1. Design system constraints
- **spacing scale**: use the design system's spacing scale (e.g. 0.25 / 0.5 / 1 / 1.5 / 2 / 3 / 4 rem); arbitrary values like `13px` / `2.3rem` are forbidden
- **Semantic color tokens**: use `text-primary` / `bg-surface`; do not use bare `#333`
- **Type scale**: use the design system's type scale; do not pick arbitrary values

### 2. Responsive
- **Mobile-first**: start with small screens, upgrade with `min-width` media queries
- **Required breakpoints**: 320 / 768 / 1024 / 1440
- Retrofitting responsiveness later costs 3× as much; do it from the start

### 3. Avoid the AI default aesthetic
- Purple everywhere, excessive gradients, `rounded-2xl` for everything, stock card grids, stacked shadows — these are "the generic look of AI-generated code", not "UI written by an engineer with strong design sense"
- Visual specs are produced by harness-design; this skill implements per the spec

## Three-State Handling (mandatory)
Every data-driven component must handle three states:
```tsx
function UserList() {
  const { data, isLoading, error } = useUserData();
  if (isLoading) return <Skeleton />;               // loading
  if (error) return <ErrorMessage error={error} />; // error
  if (!data?.length) return <EmptyState />;         // empty
  return <ul>{data.map(u => <UserListItem key={u.id} user={u} />)}</ul>;
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
| Shortcut taken | Rationalization | Why it fails |
|----------------|-----------------|--------------|
| Write the component big, defer splitting | "I'll split it later." | 200 lines is a red line; split once exceeded. |
| Defer responsive implementation | "Responsive can wait." | Retrofitting later costs 3× as much. |
| Skip accessibility | "Accessibility is nice-to-have." | It is a legal requirement and an engineering quality standard in many places. |
| Start with Redux | "Use Redux first to be safe." | Over-engineering; start with useState. |
| Skip styles when design is unfinished | "Design isn't finalized, skip styles for now." | Use design system defaults; an unstyled UI leaves a bad impression. |
| Skip the loading state | "Skip the loading state for now." | Three states are mandatory, not optional. |

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
- State management: <approach>, reason: <one sentence>
- Three-state: loading ✓ / error ✓ / empty ✓
- Accessibility: keyboard ✓ / aria-label ✓ / alt ✓
- Responsive: 320/768/1024/1440 ✓
```
