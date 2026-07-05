# Color Craft Rules

> Generic craft rules (brand-agnostic) · referenced by design-intake / verify (lint step)
>
> Source: Open Design craft/color.md + color theory best practices

## Core philosophy

Color is the core of brand identity. The second sign of AI slop is the purple gradient (#6366f1). A good color system needs semantic tokens, reasonable contrast, and restrained accent usage.

## Semantic token structure (shadcn compatible)

| Token | Usage | Example |
|-------|------|------|
| primary | Primary action color | Button / link |
| on-primary | Text on primary | Button text |
| secondary | Secondary action | Secondary button |
| accent | Highlight color | Highlight / badge |
| background | Page background | body background |
| foreground | Body text | Primary text |
| muted | Muted text | Secondary text |
| muted-foreground | Text on muted | Secondary text |
| card | Card background | Card |
| card-foreground | Card text | Card content |
| border | Border | Divider |
| destructive | Error / delete | Error message |
| ring | Focus ring | Keyboard focus |

## Contrast standards (WCAG 2.1 AA)

| Text type | Minimum contrast | Notes |
|---------|-----------|------|
| Body (<18pt) | 4.5:1 | Must satisfy |
| Large text (≥18pt or 14pt+bold) | 3:1 | May be slightly lower |
| UI component boundary | 3:1 | Button / input border |
| Non-text decoration | Not required | But recommended ≥2:1 |

## Accent usage principles

| Principle | Notes |
|------|------|
| At most 2 accent uses per screen | Accent is emphasis, not decoration |
| Accent not for large areas | Large areas use primary/secondary |
| Accent not for body | Body uses foreground |

## Dark mode principles

| Principle | Notes |
|------|------|
| Do not directly invert light mode | Dark mode needs independent tuning |
| Surface layering via brightness difference | Not shadows |
| Avoid pure black (#000) | Use #0a0a0a and similar dark grays |
| Avoid pure white (#fff) | Use #fafafa and similar warm whites |

## Forbidden colors

| Forbidden | Reason |
|------|------|
| #6366f1 as primary | AI default purple |
| Purple-blue gradient | AI default gradient |
| Pure black (#000) as background | Too harsh, use dark gray |
| Pure white (#fff) as dark-mode text | Too glaring, use warm white |
| Hardcoded hex | Use token references |

## Color generation principles

| Principle | Notes |
|------|------|
| 50-900 scale | Generate 11 steps per color |
| HSL color space | Easier to generate scales |
| 50 lightest, 900 darkest | Convention |

## Check timing

- **design-intake**: cross-check when defining the color system (tokens.json) and when choosing colors (forbidden colors)
- **verify (lint step)**: L001 rule checks colors come from tokens, L011-L012 check AI slop colors
- **webapp-testing**: contrast check
