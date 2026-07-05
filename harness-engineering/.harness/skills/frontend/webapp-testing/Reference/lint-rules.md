# Lint Rules L001-L015

> Reference extracted from the legacy design framework's verify skill. Mechanical rules executed by the Agent via built-in tools (Grep/Read) or an existing project script when available — never LLM hallucination. Consumed by frontend review gates and any design-output lint pass.

## Philosophy

Mechanical lint checks consistency, not creativity. Creativity lives at the token definition layer; once tokens are fixed, downstream artifacts must reference them. An LLM "looks right" judgment is never sufficient — rules must be executed via mechanical means (Agent's Grep/Read tools or an existing project lint script).

## Token Consistency

### L001 — Colors must come from tokens

All colors in design mockups and frontend output must reference a token from `tokens.json`. No hardcoded hex values. Regex scan for `#[0-9a-fA-F]{6}` and verify each match exists in the token set.

- Severity: `error`
- Fix: replace the hex with the matching `var(--color-*)` / token reference.

### L002 — Spacing must be on the spacing scale

Every spacing value must match a token on the spacing scale (4px base, common scale). No arbitrary pixel values.

- Severity: `error`
- Fix: snap to the nearest scale step.

### L003 — Border radii must come from the radius scale

All border-radius values must reference a radius token (`radius.sm` / `md` / `lg`). No one-off radius values.

- Severity: `error`
- Fix: use the closest radius token.

### L004 — Font sizes must be on the type scale

All font sizes must match a type-scale token (1.25 ratio Major Third: text-xs / sm / base / lg / xl / 2xl / 3xl).

- Severity: `error`
- Fix: snap to the nearest type-scale step.

### L005 — Shadows must come from the elevation scale

All box-shadow values must reference an elevation token (`elevation.1` / `2` / `3`). No ad-hoc shadow definitions.

- Severity: `error`
- Fix: use the matching elevation token.

## Component Consistency

### L006 — No more than 3 implementations for the same semantic component

If the same semantic component (e.g. Button) has more than 3 distinct implementations, the variants should be consolidated.

- Severity: `warning`
- Fix: merge into a single component with variant props.

### L007 — Component variants differing by ≤2 props should be merged

Variants that differ by only 1-2 props are over-fragmentation. Merge them with a prop-driven variant.

- Severity: `warning`
- Fix: combine into one component with an additional prop.

### L008 — Components must annotate all states

Each interactive component must declare all required states (see ui-standards.md state table). Missing states fail the gate.

- Severity: `error`
- Fix: add the missing states to the component spec.

## Layout Consistency

### L009 — Consistent alignment baseline

Alignment baselines must be consistent across a page. Drifting baselines break visual rhythm.

- Severity: `warning`
- Fix: align to the shared baseline grid.

### L010 — Consistent grid column count (12-column grid)

Layouts must use a 12-column grid. Mixing grid systems within a product breaks engineering alignment.

- Severity: `warning`
- Fix: normalize to the 12-column grid.

## Anti AI-Slop Defaults

### L011 — Forbid generic default fonts

Forbid Inter / Roboto / Arial as the primary font unless an approved brand override explicitly names L011 and records rationale, source, scope, and review point.

- Severity: `error` (downgradable to `warning` with a recorded override)
- Fix: use the project design system's font.

### L012 — Forbid #6366f1 purple

`#6366f1` (indigo-500) is the AI default purple and is forbidden.

- Severity: `error` (downgradable to `warning` with a recorded override)
- Fix: use the project primary token.

### L013 — Forbid purple-blue gradient

Purple-blue gradients (indigo→purple, blue→violet) are AI defaults and forbidden.

- Severity: `error` (downgradable to `warning` with a recorded override)
- Fix: use a flat color or a subtle gradient matching the design system.

### L014 — Forbid uniform border-radius

No more than 2 elements may share the same `rounded-2xl` / `rounded-3xl` / `rounded-full` value unless they belong to the same component family. Uniform radius ignores the radius hierarchy.

- Severity: `error` (downgradable to `warning` with a recorded override)
- Fix: apply the radius scale (`radius.sm` / `md` / `lg`).

### L015 — Forbid Lorem ipsum placeholder copy

Lorem ipsum is forbidden unless the artifact is explicitly a content-wireframe fixture. Real business copy must be used so length / wrapping / overflow issues surface.

- Severity: `error` (downgradable to `warning` with a recorded override)
- Fix: replace with real representative content.

## Override Policy

A constitution or brand-system override may downgrade a named rule (L011-L015 only) when all of the following are recorded:

- Rationale (why the override is needed).
- Source (which document / decision authorizes it).
- Scope (which artifacts / pages the override covers).
- Review point (when the override is re-evaluated).

Overrides never bypass:

- WCAG or accessibility constraints.
- Token consistency (L001-L005).
- Interaction-state completeness (L008).
- Evidence gates.

## Severity Handling

| Severity | Action |
|----------|--------|
| `error` | Must fix; return to the owning phase's ACT. Cannot proceed with unresolved errors. |
| `warning` | Recommended fix; annotate the decision ("fix" or "ignore with reason"). Warnings without an annotated decision fail the gate. |
| `info` | Informational only; no action required. |

## Execution Requirement

Rules must be executed via mechanical means — the Agent's built-in Grep/Read tools (e.g., regex scan for `#[0-9a-fA-F]{6}` and cross-check against `tokens.json`), or an existing project lint script when one is already present. Never introduce a new lint dependency to satisfy these rules — fall back to Agent tooling instead. The check reads the artifact file + `tokens.json` and emits a structured report captured into the review evidence. Claiming pass without performing the mechanical check is a red flag.
