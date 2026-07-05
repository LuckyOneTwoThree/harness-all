# Common Rules for Professional UI

> Generic craft rules (brand-agnostic) · referenced by ui-design (A1: replaces former visual-design) / verify (lint step) / design-review
>
> Source: UI UX Pro Max's Common Rules for Professional UI

## Core philosophy

"Easy to overlook but affects professionalism" rules. Each rule is presented in three columns: Standard / Avoid / Why It Matters, so the Agent can directly cross-check and execute.

## Icons & Visual Elements

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| Default to Phosphor icon library | Using emoji as structural icons | emoji rendering is inconsistent and unprofessional |
| Prefer vector assets (SVG) | Bitmap icons | Vectors scale without distortion |
| Use official assets for brand logos | Hand-drawn logos | Brand consistency |
| Tokenize icon sizes (icon-sm/icon-md=24pt) | Hardcoded sizes | Maintainability |
| Consistent stroke weight at the same layer | Mixing weights | Visual consistency |
| Do not mix fill/stroke | Mixing in the same interface | Visual consistency |
| Touch target ≥44pt | Less than 44pt | Accessibility + mobile usability |
| Icons align to baseline | Visual alignment | Typography professionalism |
| Contrast 4.5:1 | Below 4.5:1 | WCAG AA |

## Interaction (App)

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| Click feedback within 80-150ms | Over 150ms | Perceived performance |
| Microinteractions 150-300ms native easing | Custom complex easing | Platform consistency |
| Accessibility focus order = visual order | Chaotic focus order | Keyboard UX |
| Disabled state uses semantic props | Style-only changes | Accessibility |
| Touch ≥44×44pt (iOS) / 48×48dp (Android) | Below standard | Platform spec |
| Single gesture per area | Multi-gesture conflict | Prevent misoperation |
| Prefer native interaction primitives | Custom interactions | Platform consistency |

## Light/Dark Mode Contrast

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| Light surfaces clearly separated | Surfaces blending together | Visual hierarchy |
| Body contrast ≥4.5:1 | Below 4.5:1 | WCAG AA |
| Dark mode primary text ≥4.5:1, secondary ≥3:1 | Below standard | Dark mode readability |
| Dividers visible in both themes | Single-theme design | Cross-theme usability |
| Interaction states equivalent in both themes | Light-only design | Cross-theme consistency |
| Semantic token driven | Hardcoded colors | Maintainability |
| Modal scrim 40-60% black | Transparent scrim | Focus guidance |

## Layout & Spacing

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| Safe area compliance (notch/status bar/gesture bar) | Content occluded | Mobile usability |
| System bar padding | Content intruding on system bar | Platform spec |
| Content width consistent by device class | Arbitrary widths | Cross-device consistency |
| 4/8dp spacing rhythm | Arbitrary spacing | Visual rhythm |
| 12-column grid layout | Arbitrary grid | Engineering alignment |
| Mobile-first design | Desktop-first | Responsive foundation |

## Check timing

- **ui-design** (A1: replaces former visual-design): cross-check the three-column table when producing design specs
- **verify (lint step)**: L006-L010 rules check layout consistency
- **design-review**: Five-Axis Review's "spacing and alignment" axis check
