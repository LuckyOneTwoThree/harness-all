# Typography Craft Rules

> Generic craft rules (brand-agnostic) · referenced by design-intake / verify (lint step)
>
> Source: Open Design craft/typography.md + typography best practices

## Core philosophy

Typography is the soul of design. The first sign of AI slop is font choice (Inter/Roboto/Arial). Good typography requires attention to letter spacing, type scale, and line height.

## Type scale

Uses a 1.25 ratio (Major Third):

| Token | Size | Usage |
|-------|------|------|
| text-xs | 0.8rem (12.8px) | Secondary text / labels |
| text-sm | 1rem (16px) | Body (small screens) |
| text-base | 1.25rem (20px) | Body (desktop) |
| text-lg | 1.563rem (25px) | Subtitle |
| text-xl | 1.953rem (31.25px) | Section heading |
| text-2xl | 2.441rem (39px) | Page title |
| text-3xl | 3.052rem (49px) | Hero title |

## Line height

| Usage | Line height | Reason |
|------|------|------|
| Body (multi-line) | 1.5-1.6 | Reading comfort |
| Heading (short lines) | 1.1-1.3 | Compact feel |
| UI text | 1.4 | Balance |

## Letter spacing

| Scenario | Letter spacing | Reason |
|------|------|------|
| ALL CAPS text | ≥0.06em | Caps need more spacing |
| Large heading | -0.02em | Large sizes need tightening |
| Body | normal (0) | Default is fine |
| Small text | 0.01em | Small sizes need slight spacing |

## Font weight

| Usage | Weight | Reason |
|------|------|------|
| Body | 400 (normal) | Reading comfort |
| Emphasis | 500-600 | Does not steal from heading |
| Heading | 600-700 | Establishes hierarchy |
| Large heading | 700-800 | Visual focus |

## Font pairing principles

1. **Serif + sans-serif**: serif for headings (personality), sans-serif for body (readability)
2. **Display + UI font**: display font for headings (character), UI font for body (neutral)
3. **Avoid same-family pairing**: two sans-serifs or two serifs lack contrast

## Forbidden pairings

| Forbidden | Reason |
|------|------|
| Inter + Roboto | Two AI default fonts |
| Arial + Helvetica | Too similar |
| Single font for all scenarios | Lacks hierarchy |

## CSS import spec

```css
/* Google Fonts import example (do not use Inter/Roboto/Arial as primary font) */
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600&family=Manrope:wght@400;500&display=swap');
```

## Check timing

- **design-intake**: cross-check when defining the typography system (tokens.json) and when choosing fonts (forbidden pairings)
- **verify (lint step)**: L004 rule checks that font sizes are on the type scale
