---
name: design-intake
description: Phase 0 skill. Ingests design assets (image / v0 code / md spec) and produces a framework-neutral contract.json + W3C tokens.json + tokens.css. Supports incremental diff mode. Emits phase-0-design-intake-report.md and waits for user confirmation before downstream phases.
---
# Design Intake (Phase 0)

## When to use

- Phase 0 of a feature/product flow that has visual design input.
- User provides a design asset: reference image, hand-drawn sketch, mockup, v0-generated code, or a structured md spec.
- Reverse-engineer tokens + semantic component contract from any of the above asset types.
- Incremental update: an existing `contract.json` exists and a new PRD/asset requires a diff-and-merge.

## Inputs

- A design asset path (one of):
  - Image file (`.png` / `.jpg` / `.webp`) — reference screenshot, sketch, mockup.
  - Code dir / file (`tailwind.config.js`, `src/theme.ts`, `src/globals.css`, shadcn `components.json`, v0 export).
  - Markdown spec (`*.md`) with structured sections.
- Product requirements: `docs/handoff/pm-to-engineering.md` (current pointer, validated by session-start; AC-xxx) or `artifacts/product/PRD.md`.
- For incremental mode: existing `docs/handoff/contract.json` + `docs/design-system/tokens.json`.
- `.harness/craft/anti-ai-slop.md`, `.harness/craft/color.md`, `.harness/craft/typography.md`.

## Outputs

- `docs/design-system/tokens.json` (W3C format, `$value` + `$description`).
- `docs/design-system/tokens.css` (CSS custom properties).
- `docs/handoff/contract.json` (validates against `.harness/rules/component-contract.schema.json`).
- `loops/specs/<task>/phase-0-design-intake-report.md` (checkpoint artifact, see step 8).

## Process

### 1. Classify Asset

Detect the asset type and route to the matching extractor:

- Image → step 2 (multimodal extraction).
- Code config → step 3 (code parsing).
- Markdown spec → step 4 (md structuring).

If the asset is unparseable or missing, stop and surface a 👤 human intervention point (insufficient assets).

### 2. Multimodal Extraction (image)

Read the image with vision capability and extract:

- Color palette (dominant + accent hex values).
- Typography (font family if recognizable, size hierarchy).
- Spacing rhythm (estimate 4dp/8dp grid from element gaps).
- Border radius patterns, shadow / elevation patterns.
- Layout structure (grid columns, regions).
- Components visible in the image (Button / Input / Card / Modal / etc.).

Anti AI-Slop check on the image itself: if the image is an AI-slop default (Inter + #6366f1 purple gradient + uniform radius), warn the user and ask whether to proceed or override. Record detected patterns as lint-watching items.

Hard gate: do not proceed if no image provided, no AC-xxx from PM (image is style only, not product requirements), or image is pure noise.

### 3. Code Parsing (code config)

Detect tech stack and read configuration:

- `tailwind.config.{js,ts}` → read `theme.extend` (colors / spacing / fontFamily / borderRadius / boxShadow).
- `src/theme.ts` → MUI `createTheme` (palette / typography / spacing).
- `components.json` + CSS vars → shadcn (`--primary` / `--secondary` / ...).
- `src/globals.css` / `src/index.css` → `:root` custom properties.

Extract dimensions: color, typography, spacing, shadow, border radius, breakpoints. Chesterton's Fence: understand the original design before deciding whether to rewrite it.

### 4. Markdown Structuring (md spec)

Parse the markdown's structured sections into token dimensions and component list. Map each section (Colors / Typography / Spacing / Components) to the corresponding token groups.

### 5. Token Export (W3C)

Convert extracted attributes to W3C tokens. Every extracted value must land on a token; reject raw hex in the final token set.

`tokens.json` (W3C standard format):

```json
{
  "color": {
    "primary": { "$value": "#3b82f6", "$description": "Primary color" },
    "on-primary": { "$value": "#ffffff" }
  },
  "spacing": { "sm": { "$value": "0.5rem" }, "md": { "$value": "1rem" } }
}
```

`tokens.css` (CSS custom properties):

```css
:root {
  --color-primary: #3b82f6;
  --color-on-primary: #ffffff;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
}
```

If `tokens.json` already exists, **merge** — image/code-derived tokens fill gaps, never silently override. Conflicts (same token name, different value) pause for 👤 human decision.

### 6. Generate contract.json

Write `docs/handoff/contract.json` following `.harness/templates/component-contract.example.json` and validate against `.harness/rules/component-contract.schema.json`.

Required provenance: `schema_version` (`1.0`), `design_revision` (handoff ID), `token_source.path` (package-relative, `^artifacts/`), `token_source.sha256`.

Each component requires a stable `component_id` (`^CMP-[A-Z0-9-]+$`), semantic `name` + `purpose`, neutral `properties` (types: `string` / `boolean` / `number` / `enum` / `slot` / `collection` / `object`), `states`, `token_refs`, and `accessibility` constraints. Component IDs are immutable; removed IDs are retired, never reassigned.

Hard boundary: design owns semantic intent, not framework selection. Never emit React/Vue/Svelte-specific types or prescribe `engineeringComponent` names.

### 7. Incremental Diff Mode (when existing contract exists)

1. Read existing `docs/handoff/contract.json` + `docs/design-system/tokens.json`.
2. Extract tokens + components from the new PRD / asset (steps 2-4).
3. Compare: classify each token / component as `[added]` / `[modified]` / `[unchanged]` / `[superseded]`.
4. Update the contract: `added` and `modified` (new IDs) replace old ones; old IDs go to `superseded_acs`. `unchanged` carries forward.
5. Emit a diff summary section in `phase-0-design-intake-report.md`.

Conflicts the agent cannot resolve autonomously pause for 👤 human decision.

### 8. Checkpoint — phase-0-design-intake-report.md

Produce `loops/specs/<task>/phase-0-design-intake-report.md` containing:

- Asset inventory (source path, type, extraction route).
- Extracted token summary (counts per dimension).
- Component list (IDs + names + purposes).
- Anti AI-Slop observations.
- Incremental diff summary (if incremental mode).
- Open items / risks / assumptions.

**Hard checkpoint**: stop and wait for user confirmation before any downstream phase consumes the contract. Do not auto-proceed to Phase 1.

## 👤 Human Intervention Points

| Point | Trigger | Action |
|------|---------|--------|
| Insufficient assets | No image / unparseable code / empty md | Pause, request more input |
| Extraction failure | Vision parse returns noise / config unreadable | Pause, request cleaner asset |
| Token conflict (incremental) | Same token name, different value | Pause, ask which wins |
| AI-slop default detected | Image is Inter + #6366f1 + uniform radius | Warn, ask proceed or override |
| Component ID collision (incremental) | New component reuses retired ID | Pause, assign new ID |

## Verification

- [ ] Asset classified and routed (evidence: report names the route).
- [ ] `tokens.json` conforms to W3C format (every entry has `$value`).
- [ ] `tokens.css` contains matching `--*` custom properties.
- [ ] No hardcoded hex survives in `tokens.json` (every value is a token).
- [ ] `contract.json` validates against `component-contract.schema.json`.
- [ ] No framework-specific type or implementation name in the contract.
- [ ] `phase-0-design-intake-report.md` exists and is presented as a checkpoint.
- [ ] Incremental mode (if active): diff summary present, no silent overrides.

## Relationship with LOOP

Not run inside LOOP. This is the Phase 0 intake that produces the contract + tokens consumed by Phase 1 (frontend) and beyond. Downstream phases must not start until the checkpoint is confirmed.
