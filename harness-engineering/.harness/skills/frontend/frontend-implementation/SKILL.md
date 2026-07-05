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
2. Validate `contract.json` against `.harness/rules/component-contract.schema.json`. Reject duplicate/unknown component IDs, framework-specific types in the contract, missing token provenance, or invalid hashes.
3. Every implemented component must join by the stable `component_id` in `contract.json`. Never invent, rename, or silently drop a component ID.
4. Code must reference tokens via `var(--token-*)` from `tokens.css`. Hardcoded color/spacing/radius/shadow values are prohibited unless an explicit documented exception exists in `component-bindings.json` `token_exceptions`.
5. Mock API must be configured from the PRD API contract; do not invent endpoints or response shapes the PRD does not authorize.
6. Accessibility contract from `contract.json` (role/keyboard/focus/aria) must be implemented as written; gaps are 👤 human-confirmation items, not silent omissions.

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
- [ ] Accessibility contract implemented as written; gaps are explicit 👤 items.
- [ ] Affected tests pass with AC/BAC/IAC evidence; non-testable items marked 👤.

## Inline verify-fast (per attempt)

frontend-implementation runs its own inline verify-fast after each component implementation attempt, BEFORE handing off to TDD. This is separate from TDD's inline verify-fast (which covers behavior-level test validation). The four duties:

1. **Test validation**: confirm TDD's red-green cycle completed for the current component; reject if tests are 0, stale, or command doesn't match the planned outcome.
2. **AC/BAC/IAC + Hard Gate check**: confirm the current component's `component_id` exists in `contract.json`; verify token references resolve to `tokens.json` entries (no missing tokens); verify mock API endpoints trace to PRD documented endpoints; verify accessibility contract items are implemented or marked 👤; verify `component-bindings.json` entry is complete (including `mock_api`, `token_refs`, `manual_verification` where applicable).
3. **Changed-file security scan**: scan the component's changed files for hardcoded secrets/URLs, XSS-prone `dangerouslySetInnerHTML`, and hardcoded color/spacing values that should use tokens (cross-check against `token_exceptions`).
4. **Terminal outcome**: append one `PASSED` or `FAILED` line to `iterations.log` with the component ID and verification summary.

## Relationship with LOOP

- Phase: 1 (frontend)
- ACT owner: `frontend-implementation` → `test-driven-development`
- After phase outcomes pass inline fast verification, `verify` runs verify-full once for the phase, then the checkpoint writes `phase-1-frontend-report.md`.
