---
name: design-handoff-spec
description: Produces an engineering-consumable handoff with a framework-neutral component contract after design review passes.
---
# Design Handoff Spec

## When to use

- After `design-review` passes for one page.
- After `product-design-review` passes for a product-level delivery.

## Inputs

- `docs/handoff/pm-to-design.md`
- `docs/visual/`, `docs/interaction/`, `docs/prototype/`
- `docs/design-system/DESIGN.md`
- `docs/design-system/tokens.json` and `tokens.css`
- `loops/specs/<task>/evidence.md`
- Product mode only: `docs/visual/DESIGN_PLAN.md` and product review evidence

## Outputs

- `docs/handoff/design-to-solo.md`
- `docs/handoff/component-contract.json`
- `docs/interaction/component-spec.md`
- `docs/prototype/flow.md`
- Portable package under `docs/handoff/packages/<handoff_id>/`

## Hard Boundary

Design owns semantic component intent, not framework selection or source-code names.

- Read platform constraints from `pm-to-design.md`, if present.
- Do not require `docs/engineering/TECH_STACK.md`; harness-solo owns it and it may not exist yet.
- Use neutral property types: `string`, `boolean`, `number`, `enum`, `slot`, `collection`, `object`.
- Never emit React/Vue/Svelte-specific types or prescribe `engineeringComponent` names.
- Harness-solo creates `docs/engineering/component-bindings.json` after choosing the tech stack.

## Process

### 1. Validate the Upstream Contract

Apply `.harness/rules/handoff-protocol.md`. Do not consume a draft, wrong-consumer, unsupported-schema, stale, incomplete, or hash-invalid handoff. Preserve all stable AC IDs from the PM contract; never renumber or reuse them.

### 2. Determine Scope

- Product mode requires both `DESIGN_PLAN.md` and product review evidence.
- Otherwise use single-page mode.
- Product mode includes page inventory, shared-component reuse, cross-page consistency, and all named flows.

### 3. Aggregate Approved Outputs

Read only approved design artifacts. Confirm every referenced page, interaction, token, and review-evidence file exists. Record its package-relative destination and SHA-256.

### 4. Produce Human-Readable Contract

Fill `docs/handoff/templates/design-to-solo-template.md` with:

- phase summary and asset inventory;
- pages, navigation, components, and flows;
- PM-owned stable ACs (`AC-<feature>-<sequence>`);
- design-derived stable DACs (`DAC-<page>-<sequence>` or `DAC-GLOBAL-<sequence>`);
- decisions, open items, risks, and explicit downstream actions.

Every section must name its consumer action or gate. Put non-actionable context under Notes.

### 5. Produce Semantic Component Contract

Write `docs/handoff/component-contract.json`, validate it against `.harness/rules/component-contract.schema.json`, and follow `.harness/templates/component-contract.example.json`.

Required provenance:

- `schema_version`;
- `design_revision` (the design handoff ID);
- `token_source.path` using a package-relative path;
- `token_source.sha256`.

Each component requires a stable `component_id`, semantic `name` and `purpose`, neutral `properties`, `states`, `token_refs`, and accessibility constraints. Product mode also records `used_by` page IDs. Component IDs are immutable across revisions; removed IDs are retired, never reassigned.

### 6. Produce Component and Flow Specs

Write component props/states/behavior to `docs/interaction/component-spec.md` and key entry/exit/error paths to `docs/prototype/flow.md`. These are explanatory artifacts; the JSON semantic contract is the machine-readable authority.

### 7. Run Pre-Delivery Checks

- UX guideline and common-rule scans pass.
- 375px, landscape, reduced-motion, dark-mode contrast, keyboard, and touch-target checks pass.
- All AC/DAC IDs are unique, stable, scoped, and included in the envelope.
- No framework-specific type or implementation name appears in component-contract.json.
- Token and artifact hashes match packaged files.

### 8. Publish Portable Package

Follow `HANDOFF_PROTOCOL.md` semantics via `.harness/rules/handoff-protocol.md`:

1. Generate with `status: draft`.
2. Create `docs/handoff/packages/<handoff_id>/manifest.json` and `contract.md`.
3. Copy every referenced dependency under `artifacts/`; never reference producer-local paths.
4. Validate manifest, artifact hashes, envelope/body ID parity, and consumer.
5. Archive the previous current pointer, publish `status: ready`, and record the handoff ID.

## Verification

- [ ] design-to-solo.md has exactly one valid envelope and all required sections.
- [ ] component-contract.json validates and contains no engineering binding.
- [ ] component-spec.md and flow.md exist.
- [ ] Product mode covers every planned page, shared component, and flow.
- [ ] Package is self-contained; every manifest path exists and every hash matches.
- [ ] Envelope `ac_ids` exactly equals the unique AC/DAC IDs in the contract body.
- [ ] Previous current pointer is archived unchanged.

## Red Flags

- A repository sample is present as `docs/handoff/component-contract.json` before a real delivery.
- The design contract chooses a framework, code component name, or language-specific type.
- A package references `docs/...` outside its own directory.
- An AC/DAC is renumbered, duplicated, or silently dropped.

## Relationship with LOOP

This skill runs after the out-of-LOOP review gate. It packages approved LOOP outputs for harness-solo; Solo then creates its own implementation binding.
