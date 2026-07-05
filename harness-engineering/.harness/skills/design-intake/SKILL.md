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
- `docs/handoff/contract.json` (validates against `.harness/rules/component-contract.schema.json`; includes `entities[]` array surfacing PRD data model for Phase 2 consumption, and `token_source.path` pointing to `docs/design-system/tokens.json`).
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

## Degraded Mode Extraction (No PM Handoff)

Trigger condition: `docs/handoff/pm-to-engineering.md` does not exist OR session-start confirms degraded mode (standalone-fallback). In this mode there is no PM contract package, so design-intake must derive `contract.json` + `tokens.json` from user-provided inputs alone.

### 1. Classify Available Inputs

Inventory what the user actually provided:
- User-provided images (screenshots, sketches, mockups).
- v0 / LLM-generated code (component files, `tailwind.config.*`, `globals.css`).
- Markdown design docs (structured or free-form).
- Figma exports (image snapshots, exported CSS, design tokens JSON).
- Verbal requirements (chat / call notes).
- PRD draft (`artifacts/product/PRD.md` or inline).

Route each input to the matching extractor from the main Process (image → step 2; code → step 3; md → step 4). Verbal requirements and PRD drafts feed entity extraction (step 3 below).

### 2. Extract Design Tokens

If no `docs/design-system/tokens.json` exists, derive a minimal token set from the provided assets:
- Colors (primary, secondary, neutrals, semantic states).
- Spacing (4dp / 8dp grid estimate).
- Typography (font family, size hierarchy, weight).

Write to `docs/design-system/tokens.json` (W3C format). Mark every inferred token with `inferred: true` in a `$description` note or a top-level `notes` field so downstream phases know these are non-authoritative.

If `tokens.json` already exists, merge per the main flow (step 5) — never silently override.

### 3. Extract Entities

If no PRD entities section exists, derive entities from:
- User conversation (nouns surfaced in requirements).
- Provided API examples (request/response shapes, endpoint paths).
- Component properties inferred from code/images.

Write to `docs/handoff/contract.json` `entities[]` with:
- `ac_refs: []` — AC IDs are NOT available in degraded mode.
- A `notes` field marking each entity as `pending-AC`.

### 4. Extract Components

Derive components from provided UI:
- If v0 / code is provided → parse component structure (props, states, variants) per step 3 of the main Process.
- If images only → describe components from visual inspection per step 2.
- If markdown design doc → map per step 4.

Each component still requires `component_id` (`^CMP-[A-Z0-9-]+$`), `purpose`, `properties`, `states`, `token_refs`, `accessibility`.

### 5. Validate

Run `validate-artifacts.ps1` to check:
- `contract.json` against `.harness/rules/component-contract.schema.json`.
- `tokens.json` W3C format (every entry has `$value`).

Fix any schema violations before proceeding.

### 6. Record Degraded-Mode Waiver

Append to `memory/progress.md`:

> Degraded mode active: no PM handoff. contract.json entities have pending-AC refs. AC traceability will be incomplete until PM provides AC IDs or user assigns them.

This waiver is the audit trail that downstream phases (Phase 1/2) read to understand why BAC/IAC traceability has gaps.

### 7. Self-Check

- [ ] `contract.json` + `tokens.json` validate cleanly.
- [ ] `phase-0-design-intake-report.md` cites the degraded-mode waiver in its Open items / risks section.
- [ ] User has been surfaced the AC-traceability gap at the Phase 0 checkpoint.

### AC Traceability Gap (must surface to user)

In degraded mode, AC IDs from PM are MISSING. As a result:
- Phase 1 BAC (Bidirectional AC) traceability will have gaps — components cannot be linked back to specific acceptance criteria.
- Phase 2 IAC (Implementation AC) traceability will have gaps — entities cannot be tagged with the ACs they satisfy.

The agent MUST surface this gap to the user at the Phase 0 checkpoint and recommend either (a) obtaining AC IDs from PM, or (b) user-assigned AC IDs (e.g., `AC-USER-001`) before Phase 1 begins.

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
