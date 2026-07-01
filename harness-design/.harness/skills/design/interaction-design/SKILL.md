---
name: interaction-design
description: Produces interaction design with state machine and motion parameters. Use when visual design is approved. Use for interaction design tasks in LOOP.
---
# Interaction Design

## When to use
- Interaction design tasks
- In-LOOP interaction-design stage
- Visual design approved

## Inputs
- .harness/craft/common-rules.md
- docs/visual/DESIGN_BRIEF.md
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/visual/

## Outputs
- docs/interaction/

## Overview

Interaction design output, including state machines + motion parameters. Missing states confuse users more than extra states.

## Process

### 1. Read Context

- `docs/visual/DESIGN_BRIEF.md`: Requirements
- `docs/design-system/DESIGN.md`: Design system (Section 4 Component Stylings)
- `docs/visual/<page>.md`: Approved visual design

### 2. Define Component States

Each interactive component must annotate all states:

| Component | Required States |
|-----------|-----------------|
| Button | default / hover / active / disabled / loading |
| Input | default / focus / filled / error / disabled |
| Card | default / hover / selected / pressed |
| Modal | closed / opening / open / closing |
| Dropdown | closed / opening / open / closing |
| Toast | entering / visible / exiting |

### 3. Define State Transitions

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

Button: hover → active
  Trigger: mousedown
  Motion: 80ms ease-out, transform: scale(0.98)
  Interruption: can be interrupted by mouseup
```

### 4. Motion Parameters

| Interaction Type | Duration | Easing |
|------------------|----------|--------|
| Click feedback | 80-150ms | ease-out |
| Micro-interaction | 150-300ms | native easing |
| Page transition | 200-400ms | ease-in-out |
| Loading animation | Continuous | linear |

### 5. Keyboard Navigation Flow

- Tab order = visual order
- Focus visible (ring token)
- No keyboard traps
- Esc closes Modal/Dropdown

### 6. Gesture Support (Mobile)

- Touch target ≥44×44pt
- One gesture per region
- Prefer native interaction primitives

### 7. Output

Write to `docs/interaction/<page>.md`.

## Output Format

```markdown
# Interaction Design: <Page Name>

## Component States

### Button
| State | Style | Trigger |
|-------|-------|---------|
| default | bg: primary, color: on-primary | - |
| hover | bg: primary-hover | mouseenter |
| active | transform: scale(0.98) | mousedown |
| disabled | opacity: 0.5, cursor: not-allowed | disabled prop |
| loading | spinner + disabled | loading prop |

## State Transitions

### Button: default → hover
- Trigger: mouseenter
- Motion: 150ms ease-out, background-color
- Interruption: can be interrupted by mouseleave

## Keyboard Navigation
1. Logo → Tab → Nav Item 1 → ... → UserMenu
2. Esc closes Modal

## Motion Parameters
- Click feedback: 100ms ease-out
- Micro-interaction: 200ms ease-out
- Page transition: 300ms ease-in-out
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "We'll add motion later" | Motion is part of interaction, not decoration |
| "Too many states will confuse users" | Missing states confuse users more than extra states |
| "The loading state doesn't matter" | Without feedback within 200ms, users think it's frozen |
| "Nobody uses keyboard navigation" | Accessibility is a hard constraint, not optional |

## Red Flags

- Component missing required states
- Motion duration outside the 80-400ms range
- Keyboard navigation undefined
- Touch target <44pt

## Verification

- [ ] Each interactive component annotates all required states (evidence: state table complete)
- [ ] Each state transition has motion parameters (evidence: duration + easing + property)
- [ ] Keyboard navigation flow defined (evidence: Tab order + Esc behavior)
- [ ] Touch target ≥44pt (evidence: size annotation)
- [ ] Motion duration within 80-400ms range (evidence: parameter table)

## Relationship with LOOP

- Stage: DESIGN
- Loop type: interaction-design
- Max iterations: 5
- After each iteration, verify runs (unified gate including lint)
- After LOOP exits, design-review performs the Five-Axis review
