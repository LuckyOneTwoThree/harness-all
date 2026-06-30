---
name: component-design
description: Designs atomic components (Button/Input/Card/Modal) with state machines, variants, and composition rules. Use when DESIGN.md exists and component design is needed. Use for component design tasks in LOOP.
---
# Component Design

## When to use
- Component design tasks (Button/Input/Card/Modal, etc.)
- In-LOOP component stage
- design-system-setup workflow

## Inputs
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- .harness/craft/anti-ai-slop.md
- .harness/craft/common-rules.md

## Outputs
- docs/design-system/components/

## Overview

Atomic component design, producing state machines + variant tables + composition rules. Focus on the "atomic component" itself; page-level layout is the responsibility of visual-design.

## Process

### 1. Read Context

- `docs/design-system/DESIGN.md`: Design System (10 sections, especially Section 4 Component Stylings and Section 10 Semantic Vocabulary)
- `docs/design-system/tokens.json`: Available tokens (color/spacing/radius/shadow/typography)
- `docs/visual/DESIGN_BRIEF.md`: Requirement context (if present)

### 2. Identify Component Requirements

Extract the required component list from Section 10 Semantic Vocabulary of DESIGN.md:
- Basic components: Button / Input / Select / Checkbox / Radio / Switch
- Container components: Card / Modal / Dialog / Drawer / Popover
- Feedback components: Toast / Alert / Progress / Skeleton
- Navigation components: Tabs / Breadcrumb / Pagination

### 3. Design Each Component

For each component, produce the following structure:

```markdown
## Component: <Name>

### Description
<1-2 sentences on component purpose>

### Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| variant | 'primary' \| 'secondary' \| 'ghost' | 'primary' | Visual variant |
| size | 'sm' \| 'md' \| 'lg' | 'md' | Size |
| disabled | boolean | false | Whether disabled |
| loading | boolean | false | Whether loading |

### States (State Machine)
| State | Trigger | Visual Change | Motion |
|-------|---------|---------------|--------|
| default | Initial | token: button.primary | - |
| hover | Mouse enter | token: button.primary.hover | 80-150ms ease-out |
| active | Mouse down | token: button.primary.active | 80ms ease-out |
| focus | Keyboard focus | outline: 2px token: focus.ring | Immediate |
| disabled | disabled=true | opacity: 0.5, cursor: not-allowed | - |
| loading | loading=true | Show Spinner, hide text | 200ms ease-in-out |

### Variants (Variant Table)
| Variant | Color Token | Use Case |
|---------|------------|----------|
| primary | color.primary | Primary action (max 1 per screen) |
| secondary | color.secondary | Secondary action |
| ghost | transparent | Tertiary action / toolbar |

### Sizes (Size Table)
| Size | Padding | Font Size | Min Height |
|------|---------|-----------|------------|
| sm | spacing.xs spacing.sm | text.sm | 32px |
| md | spacing.sm spacing.md | text.base | 40px |
| lg | spacing.md spacing.lg | text.lg | 48px |

### Composition Rules
- With Icon: Icon on the left, spacing.sm gap
- With Badge: Badge in the top-right corner
- With Loading: Hide text, center Spinner
- Forbidden composition: Button nested inside Button

### Accessibility
- role: button
- keyboard: Enter/Space triggers
- focus visible: outline 2px
- aria-disabled: when disabled
```

### 4. Token Consistency Check

- All colors must come from tokens (no hardcoded hex)
- All spacing must come from the spacing scale
- All border radii must come from the radius scale
- All font sizes must come from the type scale
- All shadows must come from the elevation scale

### 5. Anti AI-slop Check

Check item by item against `.harness/craft/anti-ai-slop.md`:
- [ ] No uniform border radius (rounded-2xl everywhere)
- [ ] No heavy shadows
- [ ] Typography follows the approved design system; any brand override is documented
- [ ] No #6366f1 purple

### 6. Touch Target Check

- All clickable elements ≥44×44pt (iOS) / 48×48dp (Android)
- Sufficient spacing to prevent mis-taps

### 7. Output

Write to `docs/design-system/components/<ComponentName>.md`, one file per component.

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "We'll add component states later" | States are the core of a component, not decoration; a component without states cannot be handed off |
| "Too many variants will confuse users" | Variants are the value of a design system; semantic naming (primary/secondary/ghost) avoids confusion |
| "Hardcoding colors is faster" | Hardcoding destroys design system consistency; lint will catch it |
| "Components can be freely composed" | Components without composition rules get misused (e.g., Button nested inside Button) |
| "Slightly smaller touch targets are fine" | 44pt is a WCAG requirement; anything smaller fails accessibility-audit |

## Red Flags

- Hardcoded hex colors (not from tokens)
- Missing state definitions (fewer than 4 states)
- Missing variant definitions
- Missing composition rules
- Touch target <44pt
- Using uniform border radius

## Verification

- [ ] Each component has a Props table (evidence: file contains ### Props section)
- [ ] Each component has a States table (≥4 states) (evidence: file contains ### States section)
- [ ] Each component has a Variants table (evidence: file contains ### Variants section)
- [ ] Each component has a Sizes table (evidence: file contains ### Sizes section)
- [ ] Each component has Composition Rules (evidence: file contains ### Composition Rules section)
- [ ] Each component has an Accessibility section (evidence: file contains ### Accessibility section)
- [ ] All colors come from tokens (evidence: Grep of component files finds no hardcoded hex)
- [ ] Touch target ≥44pt (evidence: Sizes table Min Height ≥32px sm / ≥40px md)
- [ ] Anti AI-slop check fully passed (evidence: item-by-item checklist ✓)

## Relationship with LOOP

- Stage: DESIGN
- Loop type: component
- Max iterations: 5
- After each iteration, verify runs; after verify passes, design-lint runs
- After LOOP exits, design-review performs the Five-Axis review
