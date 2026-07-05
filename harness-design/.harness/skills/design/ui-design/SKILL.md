---
name: ui-design
description: Produces combined visual + interaction design in a single LOOP iteration. Use when DESIGN_BRIEF.md and DESIGN.md exist. Use for ui-design tasks in LOOP. A1 (2026-07-05): merges former visual-design + interaction-design into one skill to avoid the split-then-merge round-trip with solo's component-contract consumption.
---
# UI Design (A1: combined visual + interaction)

## When to use
- UI design tasks (visual + interaction combined)
- In-LOOP ui-design stage (replaces former visual-design + interaction-design two-LOOP sequence)

## Inputs
- .harness/craft/anti-ai-slop.md
- .harness/craft/common-rules.md
- .harness/craft/typography.md
- .harness/craft/color.md
- docs/visual/DESIGN_BRIEF.md
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/design-system/pages/<page>.md (page-level overrides, if present)
- docs/prototype/wireframe-<page>.md (if wireframe LOOP ran)

## Outputs
- docs/ui/<page>.md (combined visual + interaction; A1: replaces former docs/visual/<page>.md + docs/interaction/<page>.md)
- docs/prototype/preview.html (B5: optional, see "Optional Mockup HTML Preview" below)

## Overview

Combined visual + interaction design output in a single file. Visual design (colors, typography, layout, hierarchy) and interaction design (component states, transitions, motion, keyboard nav) are produced together per page, because solo's `frontend-implementation` consumes them together via `component-contract.json` (visual `token_refs` + interaction `states` merged).

**A1 rationale**: The former two-LOOP split (visual-design → verify, then interaction-design → verify) caused a "split-then-merge" round-trip — design produced two separate `<page>.md` files, then handoff aggregated them back into `component-spec.md`. The combined ui-design LOOP preserves the "structure → visual → interaction" stage order within a single iteration (visual sub-stage passes before interaction sub-stage begins), but verify runs once per iteration covering both, halving the verify round-trips and producing a single source-of-truth file per page.

## Process

### Sub-stage order (within a single LOOP iteration)

```
iteration N:
  1. visual sub-stage (colors / typography / layout / hierarchy / responsive)
  2. interaction sub-stage (component states / transitions / motion / keyboard nav)
  → verify (single, covers both sub-stages)
```

The agent produces both sub-stages in one iteration. If verify fails on either sub-stage, the next iteration re-does both (the iteration counter increments once per DESIGN→VERIFY cycle, per LOOP.md).

### 1. Read Context

- `docs/visual/DESIGN_BRIEF.md`: Requirements + Style Direction (B4: condensed) + AC-xxx
- `docs/design-system/DESIGN.md`: Design system (10 sections)
- `docs/design-system/tokens.json`: Token values (for token_refs)
- `docs/design-system/pages/<page>.md`: Page-level overrides (if present)
- `docs/prototype/wireframe-<page>.md`: Approved wireframe (if wireframe LOOP ran)

### 2. Visual Sub-stage

#### 2a. Color Scheme
- Select colors from the design system (no hardcoded hex)
- Check contrast (body text ≥4.5:1)
- accent used at most 2 times per screen

#### 2b. Font Selection
- Select fonts from the approved design system; generic defaults require a documented brand override
- Check that font sizes are on the type scale

#### 2c. Layout Design
- Mobile first (starting at 375px)
- 12-column grid
- 4/8dp spacing rhythm

#### 2d. Visual Hierarchy
- One focal point per screen
- Build hierarchy with font weight / size / color (not under-title emphasis lines)

#### 2e. Anti AI-slop Check
Check item by item against `.harness/craft/anti-ai-slop.md`:
- [ ] Primary font follows the design system, with any generic-font override documented
- [ ] No #6366f1 purple
- [ ] No purple-blue gradient
- [ ] No uniform border radius (rounded-2xl everywhere)
- [ ] No Lorem ipsum placeholder text
- [ ] No excessive centering
- [ ] No standard card grid (ignoring information priority)
- [ ] No excessive padding
- [ ] No heavy shadows
- [ ] No under-title emphasis lines

#### 2f. Variants (conditional)
**Multi-variant trigger**: Produce 2-3 visual variants only when at least one of the following is met:
- The project has no complete design system (tokens + components not fully defined)
- The user explicitly requests visual exploration ("explore visual direction" / "give me options")
- This is the first page of a brand-driven consumer product where visual direction is undecided

**Default (single variant)**: When a complete design system exists and the user has not requested exploration, produce a single variant derived directly from the design system.

#### 2g. Responsive Annotation
Each variant annotates:
- Mobile (375px) layout
- Tablet (768px) layout
- Desktop (1280px) layout

### 3. Interaction Sub-stage (only if page has interactive components)

**Conditional trigger**: interaction sub-stage runs only when at least one of the following is met (same as former interaction-design LOOP trigger):
- AC-xxx contains interaction-related acceptance criteria (states / motion / keyboard navigation / touch targets)
- The page involves interactive components (Button / Input / Modal / Dropdown / Toast, etc.)
- The page involves motion parameters (duration / easing / state transitions)

If the page is static (color / spacing / typography / layout only, no interactive components), skip the interaction sub-stage and proceed to verify.

#### 3a. Define Component States
Each interactive component must annotate all states:

| Component | Required States |
|-----------|-----------------|
| Button | default / hover / active / disabled / loading |
| Input | default / focus / filled / error / disabled |
| Card | default / hover / selected / pressed |
| Modal | closed / opening / open / closing |
| Dropdown | closed / opening / open / closing |
| Toast | entering / visible / exiting |

#### 3b. Define State Transitions
Each state transition annotates:
- Trigger (user action / system event)
- Motion (duration + easing + property change)
- Interruption handling (can it be interrupted by a new trigger?)

Example:
```
Button: default → hover
  Trigger: mouseenter
  Motion: 150ms ease-out, background-color change
  Interruption: can be interrupted by mouseleave
```

#### 3c. Motion Parameters
| Interaction Type | Duration | Easing |
|------------------|----------|--------|
| Click feedback | 80-150ms | ease-out |
| Micro-interaction | 150-300ms | native easing |
| Page transition | 200-400ms | ease-in-out |
| Loading animation | Continuous | linear |

#### 3d. Keyboard Navigation Flow
- Tab order = visual order
- Focus visible (ring token)
- No keyboard traps
- Esc closes Modal/Dropdown

#### 3e. Gesture Support (Mobile)
- Touch target ≥44×44pt
- One gesture per region
- Prefer native interaction primitives

### 4. Output

Write to `docs/ui/<page>.md` (A1: single combined file, replaces former docs/visual/<page>.md + docs/interaction/<page>.md).

Full output format template (Visual + Interaction sections): see [Reference/output-format.md](./Reference/output-format.md).

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Inter is the safest font" | Inter is a hallmark of AI slop; use the project design system's font |
| "Purple gradients look nice" | #6366f1 is the AI default; all apps look the same |
| "Uniform border radius is cleaner" | Maximum radius ignores the real radius hierarchy of design |
| "We'll add motion later" | Motion is part of interaction, not decoration |
| "Too many states will confuse users" | Missing states confuse users more than extra states |
| "The loading state doesn't matter" | Without feedback within 200ms, users think it's frozen |
| "Nobody uses keyboard navigation" | Accessibility is a hard constraint, not optional |
| "A1: splitting visual and interaction into two LOOPs is more rigorous" | solo consumes them together via component-contract; splitting causes a split-then-merge round-trip with no downstream benefit |

## Red Flags

- Hardcoded hex colors (not from tokens)
- Using a generic default font without an approved project-brand rationale
- Using #6366f1 or purple-blue gradient
- Multi-variant produced when design system is complete and user didn't request exploration (wasted effort)
- Single variant produced when design system is incomplete or user requested exploration (skipped required exploration)
- No responsive annotations
- Component missing required states
- Motion duration outside the 80-400ms range
- Keyboard navigation undefined
- Touch target <44pt
- A1 violation: writing to separate docs/visual/<page>.md + docs/interaction/<page>.md instead of combined docs/ui/<page>.md

## Verification

- [ ] Every spacing value is on the spacing scale (evidence: compare with DESIGN.md)
- [ ] Every color comes from a design system token (evidence: Grep of design mockups finds no hardcoded hex)
- [ ] Contrast ≥4.5:1 (evidence: manual calculation or tool check)
- [ ] Anti AI-slop check fully passed (evidence: item-by-item checklist ✓)
- [ ] Variant count matches trigger rule: 2-3 variants when exploration triggered; 1 variant when design system is complete and no exploration requested
- [ ] Responsive annotations complete (evidence: 375px/768px/1280px all present)
- [ ] Each interactive component annotates all required states (evidence: state table complete)
- [ ] Each state transition has motion parameters (evidence: duration + easing + property)
- [ ] Keyboard navigation flow defined (evidence: Tab order + Esc behavior)
- [ ] Touch target ≥44pt (evidence: size annotation)
- [ ] Motion duration within 80-400ms range (evidence: parameter table)
- [ ] A1: output is single docs/ui/<page>.md (not separate visual/interaction files)
- [ ] B5 (if preview produced): preview.html links tokens.css via relative path and uses var(--token-name) for all values (evidence: Grep of preview.html finds no hardcoded hex)

## Relationship with LOOP

- Stage: DESIGN
- Loop type: ui-design (A1: replaces former visual-design + interaction-design)
- Max iterations: 5
- After each iteration, verify runs (single unified gate covering both visual + interaction ACs + mechanical lint)
- After LOOP exits, design-review performs the Five-Axis review (scans docs/ui/<page>.md)

## Optional Mockup HTML Preview (B5 — 2026-07-05)

**B5 scope**: ui-design MAY produce an optional `docs/prototype/preview.html` as a visual preview for human confirmation or Browser Agent inspection. This is a **preview, not a contract**.

### What the HTML preview is
- A single HTML file that renders the page's visual layout using `tokens.css` (linked via `<link rel="stylesheet" href="../../design-system/tokens.css">`)
- Contains representative content (real text, not Lorem ipsum) laid out per the `docs/ui/<page>.md` visual spec
- Renders at desktop width by default; can include a mobile viewport via `<meta name="viewport">`
- Purpose: let the human (or a Browser Agent) visually confirm the design in one glance, without reading the markdown spec

### What the HTML preview is NOT
- **NOT a contract**: the solo `frontend-implementation` skill's Contract Precedence is `component-contract.json` (#1) > `tokens.json` (#2) > `component-spec.md` + `flow.md` (#3). The HTML preview is NOT in the precedence chain.
- **NOT a source of token names**: Browser Agent reading the HTML sees rendered CSS values (`color: #3B82F6`), not token names (`color.primary`). The HTML must NOT be used to derive tokens — `tokens.json` is the only token authority.
- **NOT a source of a11y spec**: the HTML's runtime ARIA behavior is NOT the design-stage a11y declaration. `component-contract.json`'s accessibility constraints + `review-evidence.md`'s WCAG Audit section are the a11y authority.
- **NOT a substitute for `docs/ui/<page>.md`**: the markdown spec is the design-stage source of truth (annotations, states, transitions, responsive breakpoints). The HTML is a rendered preview of part of it.

### When to produce the HTML preview
- Default: do NOT produce unless the user explicitly asks ("give me a preview" / "render it" / "I want to see it")
- Or: when `exploration_mode = deep` and the user is evaluating visual variants (preview helps compare variants)
- Or: when a Browser Agent will be used in the design-review step (preview gives the agent something to inspect)

### HTML preview format
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Preview — <Page Name></title>
  <link rel="stylesheet" href="../../design-system/tokens.css">
  <style>
    /* Page-specific layout using token CSS variables */
    body { margin: 0; font-family: var(--font-sans); background: var(--color-background-tertiary); color: var(--color-text-primary); }
    .page { max-width: 1280px; margin: 0 auto; padding: var(--spacing-6); }
    /* ... layout per docs/ui/<page>.md visual spec ... */
  </style>
</head>
<body>
  <div class="page">
    <!-- Representative content (real text, not Lorem ipsum) laid out per the visual spec -->
  </div>
</body>
</html>
```

### B5 hard rules
- The HTML MUST link `tokens.css` via relative path — never inline hardcoded hex values (lint L001 applies to the HTML too)
- The HTML MUST use `var(--token-name)` for all colors / spacing / radius — never raw values
- The HTML MUST NOT be referenced by `design-handoff-spec` as a contract — it is preview-only
- The HTML MUST NOT be consumed by solo's `frontend-implementation` — solo implements from `component-contract.json`, not from HTML
- If the HTML and `docs/ui/<page>.md` disagree, the markdown spec wins (HTML is a derivative preview)
