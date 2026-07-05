# ui-design — Output Format Template

> Load on demand from the parent SKILL.md. This file preserves the full output template outside the default routing context.

## Output Format

```markdown
# UI Design: <Page Name>

## Visual Design

### Color Scheme
<colors from tokens, contrast values>

### Typography
<fonts from design system, type scale>

### Layout
<mobile-first, 12-column grid, 4/8dp rhythm>

### Visual Hierarchy
<focal point, hierarchy via weight/size/color>

### Responsive
- Mobile (375px): <layout>
- Tablet (768px): <layout>
- Desktop (1280px): <layout>

## Interaction Design

### Component States

#### Button
| State | Style | Trigger |
|-------|-------|---------|
| default | bg: primary, color: on-primary | - |
| hover | bg: primary-hover | mouseenter |
| active | transform: scale(0.98) | mousedown |
| disabled | opacity: 0.5, cursor: not-allowed | disabled prop |
| loading | spinner + disabled | loading prop |

### State Transitions

#### Button: default → hover
- Trigger: mouseenter
- Motion: 150ms ease-out, background-color
- Interruption: can be interrupted by mouseleave

### Keyboard Navigation
1. Logo → Tab → Nav Item 1 → ... → UserMenu
2. Esc closes Modal

### Motion Parameters
- Click feedback: 100ms ease-out
- Micro-interaction: 200ms ease-out
- Page transition: 300ms ease-in-out
```
