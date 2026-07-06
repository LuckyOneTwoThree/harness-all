---
name: frontend-implementation
description: Phase 1 ACT skill. Consumes contract.json + tokens.json + raw design assets and produces frontend component code (.tsx/.vue/.svelte) plus a component implementation manifest, with token references and mock API configuration.
---
# Frontend Implementation

## When to use

- Phase 1 (frontend) of the 4-phase engineering pipeline.
- Need to produce frontend component code from a validated design contract and visual assets.
- Phase 1 LOOP ACT owner; hands the Red/Green/Refactor cycle to `test-driven-development`.

## Inputs

The agent reads **two layers simultaneously**. The contract layer constrains component boundaries; the visual layer supplies the details needed for pixel-consistent code.

### Contract layer (component boundary)
- `docs/handoff/contract.json` — semantic component IDs, props, states, accessibility contract (from Phase 0)
- `docs/design-system/tokens.json` — design token definitions (color/spacing/radius/shadow/typography)
- `.harness/rules/component-contract.schema.json`
- `.harness/rules/component-bindings.schema.json`

### Visual layer (component detail)
- Original design assets (Figma export, design files, screenshots, motion specs)
- `docs/design-system/tokens.css` — runtime token stylesheet (the agent reads values; the code references vars)
- Component specs under `docs/design-system/components/*.md` (when the user provides them as design assets)

### Engineering context
- `docs/engineering/TECH_STACK.md`
- API contract section from `docs/handoff/pm-to-engineering.md` (current pointer, validated by session-start; drives mock API configuration)
- `loops/specs/<task>/phase-0-design-intake-report.md` — Phase 0 checkpoint report (asset inventory, token summary, component list, anti-AI-slop observations, open items/risks). Read to understand extraction context and unresolved Phase 0 risks before consuming the contract.
- `Reference/state-management-matrix.md`

## Outputs

- Frontend component code (`.tsx` / `.vue` / `.svelte` per TECH_STACK) under the project-mode location below
- `docs/engineering/component-bindings.json` — component implementation manifest (one entry per implemented component, joining by immutable `component_id` from `contract.json`)
- Mock API configuration under the project-mode location below

## Project Mode Adaptation

Read `docs/engineering/TECH_STACK.md` `project_mode`:

| Mode | Component code | Page code | Mock API config |
|------|---------------|-----------|-----------------|
| `fullstack` | `components/` | `app/` | `app/api/mock/` or co-located route mock |
| `separate` | `src/components/` | `src/pages/` | `src/mocks/` or `mock-server/` |

When `project_mode` is unset, infer from the existing directory layout and record the inference in `component-bindings.json` `mode_inference`.

## Hard Gates

1. Confirm `docs/engineering/TECH_STACK.md` declares framework + `project_mode` before writing any code.
2. Validate `contract.json` against `.harness/rules/component-contract.schema.json`. Reject duplicate/unknown component IDs, framework-specific types in the contract, missing token provenance, or invalid hashes. (Note: `token_source.provenance` is schema-optional but Phase 1 treats it as required — every contract must declare whether tokens are `user-provided`, `agent-inferred-from-prd`, or `handoff` so downstream phases can adjust visual-fidelity expectations accordingly.)
3. Every implemented component must join by the stable `component_id` in `contract.json`. Never invent, rename, or silently drop a component ID.
4. Code must reference tokens via `var(--token-*)` from `tokens.css`. Hardcoded color/spacing/radius/shadow values are prohibited unless an explicit documented exception exists in `component-bindings.json` `token_exceptions`.
5. Mock API must be configured from the PRD API contract; do not invent endpoints or response shapes the PRD does not authorize.
6. Accessibility contract from `contract.json` (role/keyboard/focus/aria) must be implemented as written; gaps are 👤 human-confirmation items, not silent omissions.
7. Page coverage: every `page_id` in `contract.json.pages[]` must have a corresponding page file (route component / page component) implemented. Detect by Grep-ing the framework's route registration locations (e.g. `app/**/page.{tsx,jsx,vue,svelte}` for Next.js app router, `pages/**/*.{tsx,jsx,vue,svelte}` for pages router, `router.routes` / `createBrowserRouter` config for React Router). Missing pages block the phase checkpoint. If `contract.json` has no `pages[]` array (e.g., backend-only scope), this gate is skipped.

## Token Reference Constraint

- Colors: `var(--token-color-*)`
- Spacing: `var(--token-spacing-*)`
- Radii: `var(--token-radius-*)`
- Shadows: `var(--token-shadow-*)`
- Typography (size/weight/line-height): `var(--token-text-*)`

Code that hardcodes a value with an applicable token fails verify. If a required token is missing from `tokens.css`, surface it as a phase-0 defect and mark the affected component 👤 pending token addition; do not silently substitute a literal.

## Mock API Configuration

Based on the PRD API contract section:

- Create one mock handler per documented endpoint (method + path + request shape + response shape).
- Return fixture data that matches the PRD response schema; do not fabricate fields.
- Mount the mock at the project-mode location so the running dev server consumes it without code-path branching.
- Record the mock manifest path in `component-bindings.json` `mock_api`.

## Process

### 1. Read Both Layers

Read `contract.json`, `tokens.json`, the original design assets, and `TECH_STACK.md` together. For each `component_id` in scope for the current phase outcome:

- extract props/states/a11y from the contract;
- extract color/spacing/motion/shadow detail from the visual assets and `tokens.css`;
- map both to the engineering name + module per TECH_STACK.

### 2. Write Component Code

Implement the smallest verifiable component set per the current phase outcome. Write code that:

- matches the contract boundary (props, states, accessibility) exactly;
- is visually consistent with the design assets (token values, motion timing, shadow);
- references tokens via `var(--token-*)`;
- composes per the component spec under `docs/design-system/components/*.md` when present, otherwise per the design assets.

### 3. Configure Mock API

Wire the mock API for any endpoint the component reads/writes, per the PRD API contract.

### 4. Update component-bindings.json

Append/update one entry per implemented component with: schema version, `component_id`, engineering name, module path, property/state binding, token references used, mock API path, and `mode_inference` if applicable. Validate against `.harness/rules/component-bindings.schema.json`.

### 5. TDD (Red → Green → Refactor)

Hand off to `test-driven-development` as the ACT owner. TDD writes the failing test, mutates implementation, and runs affected tests. Components not amenable to automated testing (pure visual polish, motion feel, brand-specific rendering) are marked 👤 Human confirmation required in `component-bindings.json` `manual_verification` with a reason; TDD does not fabricate a test for them.

### 6. Detect Manual Adjustments (before Phase 1 checkpoint)

After verify-full passes and before the Phase 1 checkpoint is confirmed, the user may manually adjust frontend code (visual tweaks, prop changes, mock API edits, component add/remove). The agent detects these by comparing `component-bindings.json` (the agent's record of what was implemented) against the actual frontend code. For each drift detected:

- **Visual-only drift** (token values / layout / motion / copy): no contract impact. Record a one-line summary in `phase-1-frontend-report.md` `## Downstream notes` so reviewers know manual visual tuning happened. Do NOT touch `contract.json`.
- **Contract-affecting drift** (component props / states / mock API paths or response shapes / component added or removed): follow the Contract Deviation Protocol in `rules/engineering-pipeline.md`:
  1. Update the affected field in `contract.json` (e.g., add a property to a component, edit an entity field).
  2. Append a `DEV-<task>-<N>` entry to `contract.json.deviations[]` with `detected_at_phase: 1`, the affected `field`, `reason: "User manual adjustment during Phase 1 review"`, and `severity` (minor for non-breaking additions, major for breaking changes — major requires explicit user approval).
  3. Re-validate `contract.json` against `component-contract.schema.json`.
  4. Surface the deviation in `phase-1-frontend-report.md` `## Contract deviations` and `## Downstream notes` (e.g., "DEV-<task>-1 added `priority` to entities.Todo — Phase 2 data-layer must add the column; api-implementation must include it in the /api/todos response").

This step is the primary mechanism by which Phase 2 (backend) learns what changed in Phase 1. Because Phase 2 skills already read `contract.json` as an input, they automatically see both the updated fields and the `deviations[]` list — no separate sync channel needed.

## Contract Precedence

1. Semantic component intent/states/accessibility: `contract.json`.
2. Token values: `tokens.json` + `tokens.css`.
3. Interaction detail: `component-spec.md` and design assets.
4. Engineering names, modules, framework types: engineering-owned `component-bindings.json`.

Contradictions between design-owned sources are phase-0 handoff defects; report them and pause the affected component. Binding defects belong to phase 1.

## Brand Override

Anti-pattern defaults in design guidance are defaults, not universal bans. A project constitution or approved brand system may intentionally require a normally discouraged font, color treatment, radius system, or visual motif. Record the override source in `component-bindings.json` `brand_overrides` and still enforce accessibility, consistency, and evidence gates.

## Prohibited

- Guessing a missing semantic component or silently changing its ID.
- Treating an example file as a runtime contract.
- Hardcoding values that have an applicable token without a documented exception.
- Inventing API endpoints or response shapes not authorized by the PRD.
- Skipping the accessibility contract; gaps must be explicit 👤 items, not silent omissions.
- Running a second independent TDD/verification lifecycle instead of returning constraints to the canonical pipeline.

## Verification

- [ ] `contract.json` and `component-bindings.json` both validate.
- [ ] Every implemented component joins by stable `component_id`.
- [ ] Code references tokens via `var(--token-*)`; no hardcoded token-eligible values.
- [ ] Mock API matches the PRD API contract; no fabricated endpoints.
- [ ] Project-mode directory layout respected.
- [ ] Every `page_id` in `contract.json.pages[]` has an implemented page file (Grep route registration locations). Skipped when `pages[]` is absent.
- [ ] Accessibility contract implemented as written; gaps are explicit 👤 items.
- [ ] Affected tests pass with AC/BAC/IAC evidence; non-testable items marked 👤.

## Inline verify-fast (per attempt)

frontend-implementation runs its own inline verify-fast after each component implementation attempt, BEFORE handing off to TDD. This is separate from TDD's inline verify-fast (which covers behavior-level test validation). The four duties:

1. **Test validation**: confirm TDD's red-green cycle completed for the current component; reject if tests are 0, stale, or command doesn't match the planned outcome.
2. **AC/BAC/IAC + Hard Gate check**: confirm the current component's `component_id` exists in `contract.json`; verify token references resolve to `tokens.json` entries (no missing tokens); verify mock API endpoints trace to PRD documented endpoints; verify accessibility contract items are implemented or marked 👤; verify `component-bindings.json` entry is complete (including `mock_api`, `token_refs`, `manual_verification` where applicable).
3. **Changed-file security scan**: scan the component's changed files for hardcoded secrets/URLs, XSS-prone `dangerouslySetInnerHTML`, and hardcoded color/spacing values that should use tokens (cross-check against `token_exceptions`).
4. **Terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt (include the component ID and a brief verification summary).

## Relationship with LOOP

- Phase: 1 (frontend)
- ACT owner: `frontend-implementation` → `test-driven-development`
- After phase outcomes pass inline fast verification, `verify` runs verify-full once for the phase, then the checkpoint writes `phase-1-frontend-report.md`.
