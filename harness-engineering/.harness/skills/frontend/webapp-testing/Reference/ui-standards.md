# UI Standards (Visual + Interaction + Anti AI-Slop)

> Reference extracted from craft rules (typography / color / common-rules) and consolidated for frontend use. Consumed by frontend implementation and review gates.

## Visual Standards

### Color Scheme

- Select colors from the design system tokens only — no hardcoded hex.
- Body text contrast ≥ 4.5:1 (WCAG 2.1 AA).
- Large text (≥18pt or 14pt+bold) and UI component boundaries ≥ 3:1.
- Accent color used at most 2 times per screen; accent is emphasis, not decoration.
- Accent not for large areas or body text.

### Typography

- Select fonts from the approved design system; a generic default (Inter / Roboto / Arial) requires a documented brand override.
- Font sizes must land on the type scale (1.25 ratio Major Third: text-xs / sm / base / lg / xl / 2xl / 3xl).
- Line height: body 1.5-1.6, heading 1.1-1.3, UI text 1.4.
- Letter spacing: ALL CAPS ≥0.06em, large heading -0.02em, small text 0.01em.
- Font weight: body 400, emphasis 500-600, heading 600-700, large heading 700-800.

### Layout

- Mobile first, starting at 375px.
- 12-column grid.
- 4/8dp spacing rhythm — every spacing value on the scale.
- Safe area compliance (notch / status bar / gesture bar).
- Consistent content width by device class.

### Visual Hierarchy

- One focal point per screen.
- Build hierarchy with font weight / size / color — never under-title emphasis lines.
- Purpose-driven layout; avoid over-centering and uniform card grids that ignore information priority.

### Responsive Annotation

Every variant must annotate three breakpoints:

- Mobile (375px) layout.
- Tablet (768px) layout.
- Desktop (1280px) layout.

## Interaction Standards

### Component States (required)

| Component | Required States |
|-----------|-----------------|
| Button | default / hover / active / disabled / loading |
| Input | default / focus / filled / error / disabled |
| Card | default / hover / selected / pressed |
| Modal | closed / opening / open / closing |
| Dropdown | closed / opening / open / closing |
| Toast | entering / visible / exiting |

### State Transitions

Each transition annotates: trigger (user action / system event), motion (duration + easing + property change), interruption handling (can a new trigger interrupt?).

```
Button: default → hover
  Trigger: mouseenter
  Motion: 150ms ease-out, background-color change
  Interruption: can be interrupted by mouseleave
```

### Motion Parameters

| Interaction Type | Duration | Easing |
|------------------|----------|--------|
| Click feedback | 80-150ms | ease-out |
| Micro-interaction | 150-300ms | native easing |
| Page transition | 200-400ms | ease-in-out |
| Loading animation | Continuous | linear |

Motion duration outside 80-400ms range is a red flag (loading animations excepted).

### Keyboard Navigation

- Tab order = visual order.
- Focus visible (ring token, never removed).
- No keyboard traps.
- Esc closes Modal / Dropdown.

### Gesture Support (Mobile)

- Touch target ≥ 44×44pt (iOS) / 48×48dp (Android).
- One gesture per region.
- Prefer native interaction primitives.

## Anti AI-Slop Checklist

Check item by item; every item must pass:

- [ ] Primary font follows the design system; any generic-font override documented.
- [ ] No `#6366f1` indigo purple.
- [ ] No purple-blue gradient (indigo→purple or blue→violet).
- [ ] No uniform border radius (`rounded-2xl` everywhere) — no more than 2 elements share the same large radius unless they belong to the same component family.
- [ ] No Lorem ipsum placeholder text (real business copy only).
- [ ] No excessive centering (all elements centered destroys hierarchy).
- [ ] No standard card grid ignoring information priority.
- [ ] No excessive padding (equal padding destroys hierarchy).
- [ ] No heavy shadows (multi-layer stacking).
- [ ] No under-title emphasis lines.
- [ ] No 3D sphere decorations.
- [ ] No emoji as structural icons (use Phosphor or equivalent vector library).

## Variant Trigger Rule

- Produce 2-3 visual variants only when at least one is met: no complete design system, user explicitly requests exploration, or first page of a brand-driven consumer product with undecided direction.
- Default (single variant): a complete design system exists and the user has not requested exploration.

## Red Flags

- Hardcoded hex colors (not from tokens).
- Generic default font without an approved brand rationale.
- Multi-variant produced when design system is complete and user did not request exploration (wasted effort).
- Single variant produced when design system is incomplete or user requested exploration (skipped exploration).
- Missing responsive annotations (375 / 768 / 1280).
- Component missing required states.
- Motion duration outside 80-400ms.
- Keyboard navigation undefined.
- Touch target < 44pt.
