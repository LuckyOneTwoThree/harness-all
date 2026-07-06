# Anti AI-Slop Rules

> Generic craft rules (brand-agnostic) · referenced by design-intake / verify (lint step) / webapp-testing
>
> Source: integrates the anti-AI homogenization consensus from anthropics/skills + addyosmani/agent-skills + Open Design

## Core philosophy

AI-generated designs have strong "homogenized defaults" — every app looks the same. These defaults are signals of AI slop and are **strongly discouraged**. They surface as lint warnings (L011-L015) by default; an agent may keep a discouraged choice when it has an explicit rationale tied to project context, recorded per-token / per-component in the relevant artifact (`tokens.json` `$description`, `component-bindings.json` `brand_overrides`, etc.). This aligns with the lint-rules.md override policy: error severity is downgradable to warning with rationale + source + scope + review point.

## Strongly discouraged fonts

| Discouraged | Reason | Alternative |
|------|------|------|
| Inter | AI default font, all apps look the same | Use the project design system's font, or pick a less-default sans (Manrope / DM Sans / Space Grotesk / etc.) with rationale |
| Roboto | Same as above | Same as above |
| Arial | Same as above | Same as above |
| System default font as primary font | Lazy | Explicitly declare the font stack |

## Strongly discouraged colors

| Discouraged | Reason | Alternative |
|------|------|------|
| #6366f1 (indigo-500) | AI default purple, highly recognizable | Use the project design system's primary, or pick a non-default accent with rationale |
| Purple gradient (indigo→purple) | AI default gradient | Flat color or a subtle gradient matching the design system |
| Blue-purple gradient (blue→violet) | Same as above | Same as above |
| Hardcoded hex (non-token) | Breaks consistency | Use token references |

## Strongly discouraged layouts

| Discouraged | Reason | Alternative |
|------|------|------|
| Over-centering (all elements centered) | Destroys visual hierarchy | Purpose-driven layout |
| Uniform radius (rounded-2xl everywhere) | Ignores radius hierarchy | Design-system-consistent border-radius |
| Standard card grid (uniform 3 columns) | Ignores information priority and scanning patterns | Purpose-driven layout |
| Excessive padding (equal padding) | Destroys visual hierarchy | Consistent spacing scale |
| Generic hero area (template-driven) | Disconnected from content / user needs | Content-first layout |

## Strongly discouraged content

| Discouraged | Reason | Alternative |
|------|------|------|
| Lorem ipsum placeholder text | Hides layout issues (length / wrapping / overflow) | Real placeholder content |
| Generic hero copy | Disconnected from content | Real business copy |
| Emoji as structural icons | Unprofessional | Phosphor and other icon libraries |

## Strongly discouraged effects

| Discouraged | Reason | Alternative |
|------|------|------|
| Heavy shadows (multi-layer stacking) | Competes with content, slow on low-end devices | Subtle or no shadow |
| Excessive gradients | Visual noise | Flat or subtle gradients |
| Underline accents below headings | Typical signal of AI-generated slides | Use weight / size to establish hierarchy |
| 3D sphere decorations | AI default decoration | Remove |

## How to use this list

- **Image / code / md spec mode**: when an input asset exhibits a discouraged pattern, surface it as a lint-watching item at Phase 0 and ask the user whether to proceed or override.
- **PRD-only mode** (no external design asset): after the agent infers tokens, run this checklist as a self-check. If the inferred set matches the AI-slop signature (Inter + #6366f1 + uniform radius), the agent should reconsider at least one dimension. This is a warning, not a hard block — the agent may keep the choice if it serves the PRD context, but the rationale must be explicit in `tokens.json` `$description` for each kept discouraged token.
- **verify (lint step)**: L011-L015 rules auto-check; downgradable to warning per the override policy in `lint-rules.md`.
- **webapp-testing**: visual hierarchy check.

## Check timing

- **design-intake**: cross-check item by item when producing design specs (tokens.json / contract.json)
- **verify (lint step)**: L011-L015 rules auto-check
- **webapp-testing**: visual hierarchy check
