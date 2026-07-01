---
name: visual-design
description: Produces visual design with anti-AI-slop checks and multiple variants. Use when DESIGN_BRIEF.md and DESIGN.md exist. Use for visual design tasks in LOOP.
---
# Visual Design

## When to use
- Visual design tasks
- In-LOOP visual-design stage

## Inputs
- .harness/craft/anti-ai-slop.md
- .harness/craft/common-rules.md
- .harness/craft/typography.md
- .harness/craft/color.md

## Outputs
- docs/visual/

## Overview

Visual design output, including responsive + anti-AI-slop + multiple variants. Every spacing value is on the spacing scale; every color comes from a token.

## Process

### 1. Read Context

- `docs/visual/DESIGN_BRIEF.md`: Requirements + Aesthetic Direction + Vibe Translation
- `docs/design-system/DESIGN.md`: Design system (10 sections)
- `docs/design-system/pages/<page>.md`: Page-level overrides (if present)

### 2. Confirm Aesthetic Direction

Read the user-selected direction from DESIGN_BRIEF.md's Aesthetic Direction.

### 3. Color Scheme

- Select colors from the design system (no hardcoded hex)
- Check contrast (body text ≥4.5:1)
- accent used at most 2 times per screen

### 4. Font Selection

- Select fonts from the approved design system; generic defaults require a documented brand override
- Check that font sizes are on the type scale

### 5. Layout Design

- Mobile first (starting at 375px)
- 12-column grid
- 4/8dp spacing rhythm

### 6. Visual Hierarchy

- One focal point per screen
- Build hierarchy with font weight / size / color (not under-title emphasis lines)

### 7. Anti AI-slop Check

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

### 8. Variants (conditional)

**Multi-variant trigger**: Produce 2-3 visual variants only when at least one of the following is met:
- The project has no complete design system (tokens + components not fully defined)
- The user explicitly requests visual exploration ("explore visual direction" / "give me options")
- This is the first page of a brand-driven consumer product where visual direction is undecided

**Default (single variant)**: When a complete design system exists and the user has not requested exploration, produce a single variant derived directly from the design system. The design system already encodes the visual decision; re-exploring it per page is redundant and consumes a human decision point without value.

**When multi-variant runs**, produce 2-3 variants separated within the same file:

```markdown
## Variant A: <Direction name>
<Design description + annotations>

## Variant B: <Direction name>
<Design description + annotations>

## Variant C: <Direction name>
<Design description + annotations>
```

### 9. User Selection (only when multi-variant runs)

When multiple variants are produced, present them for the user to choose. After the user selects, write to `docs/visual/<page>.md`.

When single variant is produced (default), write directly to `docs/visual/<page>.md` without a selection step.

### 10. Responsive Annotation

Each variant annotates:
- Mobile (375px) layout
- Tablet (768px) layout
- Desktop (1280px) layout

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Inter is the safest font" | Inter is a hallmark of AI slop; use the project design system's font |
| "Purple gradients look nice" | #6366f1 is the AI default; all apps look the same |
| "Uniform border radius is cleaner" | Maximum radius ignores the real radius hierarchy of design |
| "Users won't notice a 1px deviation" | Accumulated deviations destroy visual hierarchy |
| "Just one variant is enough" | When exploration is triggered (no design system / user requested), at least 2 variants are required; when design system is complete, one variant is correct and multi-variant is waste |

## Red Flags

- Hardcoded hex colors (not from tokens)
- Using a generic default font without an approved project-brand rationale
- Using #6366f1 or purple-blue gradient
- Multi-variant produced when design system is complete and user didn't request exploration (wasted effort)
- Single variant produced when design system is incomplete or user requested exploration (skipped required exploration)
- No responsive annotations

## Verification

- [ ] Every spacing value is on the spacing scale (evidence: compare with DESIGN.md)
- [ ] Every color comes from a design system token (evidence: Grep of design mockups finds no hardcoded hex)
- [ ] Contrast ≥4.5:1 (evidence: manual calculation or tool check)
- [ ] Anti AI-slop check fully passed (evidence: item-by-item checklist ✓)
- [ ] Variant count matches trigger rule: 2-3 variants when exploration triggered (evidence: file contains ## Variant A/B/C); 1 variant when design system is complete and no exploration requested (evidence: single design section)
- [ ] Responsive annotations complete (evidence: 375px/768px/1280px all present)

## Relationship with LOOP

- Stage: DESIGN
- Loop type: visual-design
- Max iterations: 5
- After each iteration, verify runs (unified gate including lint)
