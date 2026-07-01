# Anti AI-Slop Rules

> Generic craft rules (brand-agnostic) · referenced by visual-design / verify (lint step) / design-review
>
> Source: integrates the anti-AI homogenization consensus from anthropics/skills + addyosmani/agent-skills + Open Design

## Core philosophy

AI-generated designs have strong "homogenized defaults" — every app looks the same. These defaults are signs of AI slop and must be prohibited as hard constraints.

## Forbidden fonts

| Forbidden | Reason | Alternative |
|------|------|------|
| Inter | AI default font, all apps look the same | Use the project design system's font |
| Roboto | Same as above | Same as above |
| Arial | Same as above | Same as above |
| System default font as primary font | Lazy | Explicitly declare the font stack |

## Forbidden colors

| Forbidden | Reason | Alternative |
|------|------|------|
| #6366f1 (indigo-500) | AI default purple, highly recognizable | Use the project design system's primary |
| Purple gradient (indigo→purple) | AI default gradient | Flat color or a subtle gradient matching the design system |
| Blue-purple gradient (blue→violet) | Same as above | Same as above |
| Hardcoded hex (non-token) | Breaks consistency | Use token references |

## Forbidden layouts

| Forbidden | Reason | Alternative |
|------|------|------|
| Over-centering (all elements centered) | Destroys visual hierarchy | Purpose-driven layout |
| Uniform radius (rounded-2xl everywhere) | Ignores radius hierarchy | Design-system-consistent border-radius |
| Standard card grid (uniform 3 columns) | Ignores information priority and scanning patterns | Purpose-driven layout |
| Excessive padding (equal padding) | Destroys visual hierarchy | Consistent spacing scale |
| Generic hero area (template-driven) | Disconnected from content / user needs | Content-first layout |

## Forbidden content

| Forbidden | Reason | Alternative |
|------|------|------|
| Lorem ipsum placeholder text | Hides layout issues (length / wrapping / overflow) | Real placeholder content |
| Generic hero copy | Disconnected from content | Real business copy |
| Emoji as structural icons | Unprofessional | Phosphor and other icon libraries |

## Forbidden effects

| Forbidden | Reason | Alternative |
|------|------|------|
| Heavy shadows (multi-layer stacking) | Competes with content, slow on low-end devices | Subtle or no shadow |
| Excessive gradients | Visual noise | Flat or subtle gradients |
| Underline accents below headings | Typical signal of AI-generated slides | Use weight / size to establish hierarchy |
| 3D sphere decorations | AI default decoration | Remove |

## Check timing

- **visual-design**: cross-check item by item when producing design specs
- **verify (lint step)**: L011-L015 rules auto-check
- **design-review**: Five-Axis Review's "visual hierarchy" axis check
