---
name: design-handoff-spec
description: Produces engineering-consumable handoff with component-map.json. Use after design-review passes. Use for design-to-engineering delivery.
triggers:
  - Design handoff
  - After design-review passes
  - Need to hand off to engineering
reads:
  - .harness/data/design/ux-guidelines.csv
  - .harness/craft/common-rules.md
  - docs/visual/
  - docs/interaction/
  - docs/prototype/
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/design-system/tokens.css
  - docs/design-system/components/
  - docs/handoff/pm-to-design.md
  - loops/specs/<task>/evidence.md
writes:
  - docs/handoff/design-to-solo.md
  - docs/handoff/component-map.json
  - docs/interaction/component-spec.md
  - docs/prototype/flow.md
---

# Design Handoff Spec

## Overview

Engineering-consumable structured handoff. Turns "design to code" from "magic export" into "explicit mapping"—reviewable, version-controllable, testable.

## When to Use

- ✅ Design handoff
- ✅ After design-review passes
- ✅ Need to hand off to engineering (harness-solo)
- ❌ NOT for the design stage (use visual-design and other skills)

## Process

### 1. Aggregate Outputs

Read approved design outputs:
- `docs/visual/<page>.md`: Visual design
- `docs/interaction/<page>.md`: Interaction design
- `docs/prototype/wireframe.md`: Wireframe
- `docs/design-system/DESIGN.md`: Design system
- `docs/design-system/tokens.json`: Token definitions
- `docs/handoff/pm-to-design.md`: PM handoff document (reuse AC-xxx numbering; do not renumber)

### 2. Generate design-to-solo.md (Human-readable Full Specification)

> Full template at `docs/handoff/design-to-solo-template.md`; below is the core structure.

```markdown
# Design Handoff: <Project Name>

## Overview
<Design goals + scope>

## Design System
- DESIGN.md path: docs/design-system/DESIGN.md
- tokens.json path: docs/design-system/tokens.json
- tokens.css path: docs/design-system/tokens.css

## Page Inventory
| Page | Visual Mockup | Interaction Spec | Wireframe |
|------|---------------|------------------|-----------|
| Home | docs/visual/home.md | docs/interaction/home.md | - |
| Login | docs/visual/login.md | docs/interaction/login.md | - |

## Component Inventory
<Component list + states + variants>

## Acceptance Criteria (AC-xxx)
> Reuses the acceptance_criteria numbering from the harness-pm PRD; do not renumber.
> Acceptance points added during the design stage use the DAC-xxx prefix (D = Design-derived).

- [ ] AC-001: <Testable description reused from PRD>
- [ ] AC-002: <Testable description reused from PRD>
- [ ] DAC-001: <Testable description added during design stage>

## Interaction Flows
<Description of key flows>

## Notes
<Points engineering should be aware of during implementation>
```

### 3. Generate component-spec.md (Component Specification)

Write to `docs/interaction/component-spec.md`:

```markdown
# Component Specification

## Button
### Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | primary/secondary/ghost | primary | Visual variant |
| size | sm/md/lg | md | Size |
| disabled | boolean | false | Disabled state |
| loading | boolean | false | Loading state |

### States
| State | Style |
|-------|-------|
| default | bg: --color-primary |
| hover | bg: --color-primary-hover |
| active | transform: scale(0.98) |
| disabled | opacity: 0.5 |
| loading | spinner + disabled |
```

### 4. Generate component-map.json (Explicit Mapping Layer)

**Core innovation** (from Stitch): explicit mapping from design components to engineering components, version-controllable.

**Framework-agnostic constraint**: The Type declaration of props must match the Tech Stack defined in `docs/visual/DESIGN_BRIEF.md`.
- React project → `ReactNode` / `JSX.Element`
- Vue project → `VNode` / `Slot`
- Svelte project → `Snippet` / `Component`
- Native/Web Components → `HTMLElement` / `Slot`
- Tech stack unclear → use neutral abstract types (`Slot` / `Component`), and annotate "pending engineering confirmation" in notes

Write to `docs/handoff/component-map.json`:

```json
{
  "PrimaryButton": {
    "designToken": "button.primary",
    "engineeringComponent": "Button",
    "props": { "variant": "primary", "size": "md" },
    "states": ["default", "hover", "active", "disabled", "loading"],
    "notes": "Primary action button, max 1 per screen"
  },
  "ProductCard": {
    "designToken": "card.product",
    "engineeringComponent": "Card",
    "props": { "variant": "product", "elevation": "sm" },
    "states": ["default", "hover", "selected"],
    "notes": "Product list card, supports selected state"
  },
  "EmptyState": {
    "designToken": "empty-state",
    "engineeringComponent": "EmptyState",
    "props": {
      "illustration": "string",
      "title": "string",
      "description": "string",
      "action": "Slot"
    },
    "states": ["default"],
    "notes": "Empty state component, defined in Section 10 of DESIGN.md. action type depends on Tech Stack, see framework-agnostic constraint"
  }
}
```

### 5. Generate flow.md (Interaction Flow Diagram)

Write to `docs/prototype/flow.md`, describing key user flows.

### 6. Pre-Delivery Checklist

From UI UX Pro Max:

- [ ] Run UX validation scan (Grep ux-guidelines.csv for animation/accessibility/z-index/loading)
- [ ] Walk through Common Rules §1-§3 (CRITICAL + HIGH levels)
- [ ] Test at 375px (small phone) and landscape
- [ ] Verify with reduced-motion enabled
- [ ] Independently verify dark mode contrast
- [ ] Confirm all touch targets ≥44pt

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Markdown handoff is enough" | Engineering needs component-map.json for mapping, not just markdown |
| "Engineering can read the design mockups themselves" | Explicit mapping is more reliable than magic export—reviewable and testable |
| "Pre-Delivery Checklist is too tedious" | 6 checks are the minimum guarantee of handoff quality |

## Red Flags

- component-map.json not generated
- component-map.json missing the states field
- component-map.json props Type mismatched with DESIGN_BRIEF.md Tech Stack (e.g., ReactNode used in a Vue project)
- Pre-Delivery Checklist not executed
- Handoff artifact paths inconsistent with AGENTS.md conventions

## Verification

- [ ] design-to-solo.md generated (evidence: file exists)
- [ ] component-map.json generated (evidence: JSON valid + contains states field)
- [ ] component-spec.md generated (evidence: file contains Props/States tables)
- [ ] flow.md generated (evidence: file contains key flows)
- [ ] Pre-Delivery Checklist all ✓ (evidence: 6 check records)

## Relationship with LOOP

- Not run inside LOOP (runs in the handoff stage after the out-of-LOOP gate passes)
- Reads all design mockups produced by LOOP (docs/visual/ + docs/interaction/ + docs/prototype/) as aggregated input
- Reads the pass evidence from the out-of-LOOP gate (design-review + accessibility-audit evidence.md)
- The component-map.json produced is the core Stitch innovation, consumed by the harness-solo engineering implementation stage
