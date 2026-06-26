---
name: design-handoff-spec
description: Produces engineering-consumable handoff with component-map.json. Use after design-review passes. Use for design-to-engineering delivery.
---
# Design Handoff Spec

## When to use
- Design handoff
- After design-review passes (single-page) or product-design-review passes (product-level)
- Need to hand off to engineering

**Two modes**:
- **Single-page mode** (default): triggered by new-design / design-iteration / redesign workflows. Produces handoff for one page. Omits Cross-Page Consistency Report and Product Design Plan Reference sections.
- **Product-level mode**: triggered by new-product-design workflow. Produces handoff for the entire product (all pages). Includes Page Inventory with navigation structure, Component Inventory with reuse matrix, Cross-Page Consistency Report, and Product Design Plan Reference. Requires `docs/visual/DESIGN_PLAN.md` and `loops/specs/<product-task>/product-review-evidence.md` as additional inputs.

## Inputs

**Common inputs (both modes)**:
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
- loops/specs/<task>/evidence.md (per-page review evidence)

**Product-level mode additional inputs**:
- docs/visual/DESIGN_PLAN.md (page inventory + shared components + user flows)
- loops/specs/<product-task>/product-review-evidence.md (cross-page consistency review)

## Outputs
- docs/handoff/design-to-solo.md
- docs/handoff/component-map.json
- docs/interaction/component-spec.md
- docs/prototype/flow.md

## Overview

Engineering-consumable structured handoff. Turns "design to code" from "magic export" into "explicit mapping"—reviewable, version-controllable, testable.

## Process

### 1. Determine Mode

- If `docs/visual/DESIGN_PLAN.md` exists AND `loops/specs/<product-task>/product-review-evidence.md` exists → **product-level mode**
- Otherwise → **single-page mode**

In product-level mode, read DESIGN_PLAN.md first to get the full page inventory and shared component inventory before aggregating per-page outputs.

### 2. Aggregate Outputs

Read approved design outputs:
- `docs/visual/<page>.md`: Visual design (all pages in product-level mode; one page in single-page mode)
- `docs/interaction/<page>.md`: Interaction design
- `docs/prototype/wireframe.md`: Wireframe
- `docs/design-system/DESIGN.md`: Design system
- `docs/design-system/tokens.json`: Token definitions
- `docs/handoff/pm-to-design.md`: PM handoff document (reuse AC-xxx numbering; do not renumber)

**Product-level mode additional**:
- `docs/visual/DESIGN_PLAN.md`: Page inventory, shared components, user flows
- `loops/specs/<product-task>/product-review-evidence.md`: Cross-page consistency report

### 3. Generate design-to-solo.md (Human-readable Full Specification)

> Full template at `docs/handoff/design-to-solo-template.md`; below is the core structure. Product-level mode fills all sections; single-page mode omits Cross-Page Consistency Report and Product Design Plan Reference.

```markdown
# Design Handoff: <Project Name>

## Design System
- DESIGN.md path: docs/design-system/DESIGN.md
- tokens.json path: docs/design-system/tokens.json
- tokens.css path: docs/design-system/tokens.css

## Page List
| Page ID | Page | Priority | Depends On | Visual draft | Interaction draft | Wireframe |
|---------|------|----------|------------|--------------|-------------------|-----------|
| P01 | Home | P0 | — | docs/visual/home.md | docs/interaction/home.md | - |

**Navigation structure** (product-level only):
- Global Header: [Logo, Nav, UserMenu]

## Component List
| Component ID | Component | States | Used By Pages | Notes |
|--------------|-----------|--------|---------------|-------|
| C01 | Button | default, hover, active, disabled, loading | P01, P02, P03 | Primary CTA |

## Acceptance Criteria (AC-xxx)
> Reuses the acceptance_criteria numbering from the harness-pm PRD; do not renumber.
> Acceptance points added during the design stage use the DAC-xxx prefix (D = Design-derived).

- [ ] AC-001: <Testable description reused from PRD>
- [ ] DAC-001: <Testable description added during design stage>

## Interaction Flows
### Flow 1: <name>
<entry/exit/checkpoints>

## Cross-Page Consistency Report (product-level only)
| Dimension | Status | Notes |
| Navigation consistency | ✓/✗ | ... |
| User flow completeness | ✓/✗ | ... |
| Component reuse | ✓/✗ | ... |
| Token consistency | ✓/✗ | ... |
| Responsive consistency | ✓/✗ | ... |
| Interaction consistency | ✓/✗ | ... |

## Product Design Plan Reference (product-level only)
- Path: docs/visual/DESIGN_PLAN.md

## Notes
<Points engineering should be aware of during implementation>
```

### 4. Generate component-spec.md (Component Specification)

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

### 5. Generate component-map.json (Explicit Mapping Layer)

**Core innovation** (from Stitch): explicit mapping from design components to engineering components, version-controllable.

**Framework-agnostic constraint**: The Type declaration of props must match the Tech Stack defined in `docs/visual/DESIGN_BRIEF.md`.
- React project → `ReactNode` / `JSX.Element`
- Vue project → `VNode` / `Slot`
- Svelte project → `Snippet` / `Component`
- Native/Web Components → `HTMLElement` / `Slot`
- Tech stack unclear → use neutral abstract types (`Slot` / `Component`), and annotate "pending engineering confirmation" in notes

**`usedBy` field** (optional, product-level mode recommended): lists page IDs that use this component. Source: DESIGN_PLAN.md Section 3 Shared Component Inventory. Backward-compatible: old harness-solo readers ignore this field; new readers can use it to prioritize implementing high-reuse components first. Omit in single-page mode.

Write to `docs/handoff/component-map.json`:

```json
{
  "PrimaryButton": {
    "designToken": "button.primary",
    "engineeringComponent": "Button",
    "props": { "variant": "primary", "size": "md" },
    "states": ["default", "hover", "active", "disabled", "loading"],
    "usedBy": ["P01", "P02", "P03"],
    "notes": "Primary action button, max 1 per screen"
  },
  "ProductCard": {
    "designToken": "card.product",
    "engineeringComponent": "Card",
    "props": { "variant": "product", "elevation": "sm" },
    "states": ["default", "hover", "selected"],
    "usedBy": ["P03"],
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
    "usedBy": ["P03"],
    "notes": "Empty state component, defined in Section 10 of DESIGN.md. action type depends on Tech Stack, see framework-agnostic constraint"
  }
}
```

### 6. Generate flow.md (Interaction Flow Diagram)

Write to `docs/prototype/flow.md`, describing key user flows.

### 7. Pre-Delivery Checklist

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

**Common (both modes)**:
- [ ] design-to-solo.md generated (evidence: file exists)
- [ ] component-map.json generated (evidence: JSON valid + contains states field)
- [ ] component-spec.md generated (evidence: file contains Props/States tables)
- [ ] flow.md generated (evidence: file contains key flows)
- [ ] Pre-Delivery Checklist all ✓ (evidence: 6 check records)

**Product-level mode additional**:
- [ ] design-to-solo.md contains Cross-Page Consistency Report section (evidence: section exists with 6 dimensions)
- [ ] design-to-solo.md contains Product Design Plan Reference section (evidence: section exists with DESIGN_PLAN.md path)
- [ ] Page List includes all pages from DESIGN_PLAN.md Section 2 (evidence: page count matches)
- [ ] Component List includes Used By Pages column (evidence: column exists, populated for shared components)
- [ ] component-map.json contains usedBy field for shared components (evidence: JSON contains usedBy arrays)
- [ ] usedBy values match DESIGN_PLAN.md Section 3 (evidence: cross-reference matches)
- [ ] Interaction Flows cover all flows from DESIGN_PLAN.md Section 4 (evidence: flow count matches)

## Relationship with LOOP

- Not run inside LOOP (runs in the handoff stage after the out-of-LOOP gate passes)
- Reads all design mockups produced by LOOP (docs/visual/ + docs/interaction/ + docs/prototype/) as aggregated input
- Reads the pass evidence from the out-of-LOOP gate (design-review + accessibility-audit evidence.md)
- The component-map.json produced is the core Stitch innovation, consumed by the harness-solo engineering implementation stage
