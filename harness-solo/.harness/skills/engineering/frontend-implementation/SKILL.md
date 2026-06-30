---
name: frontend-implementation
description: Resolves validated design semantics into Solo-owned tech-stack bindings and implementation constraints for TDD.
---
# Frontend Implementation

## Inputs

- `docs/engineering/TECH_STACK.md`
- a validated, ready design-to-solo package
- `docs/handoff/component-contract.json` or its package copy
- design tokens, DESIGN.md, component-spec.md, and flow.md from that package
- `.harness/rules/component-contract.schema.json`
- `.harness/rules/component-bindings.schema.json`
- `Reference/state-management-matrix.md` (state-management pattern selection by tech stack)

## Outputs

- `docs/engineering/component-bindings.json`
- resolved component constraints returned to test-driven-development

## Hard Gates

1. Apply `.harness/rules/handoff-protocol.md` before reading package content.
2. Family-mode frontend work requires a ready design package and valid semantic component contract. An explicit PM waiver must include approver, reason, scope, and expiry/review point.
3. Confirm TECH_STACK.md before creating bindings. Design does not choose code names or framework types.
4. Validate component-contract.json. Reject duplicate/unknown IDs, framework-specific types, missing token provenance, or invalid hashes.

## Contract Precedence

1. Semantic component intent/states/accessibility: `component-contract.json`.
2. Token values: packaged `artifacts/design-system/tokens.json` and `tokens.css`.
3. Interaction detail: component-spec.md and flow.md.
4. Engineering names, modules, and framework types: Solo-owned `component-bindings.json`.

Contradictions between design-owned sources are handoff defects; report them to harness-design. Binding defects belong to harness-solo.

## Process

### 1. Create or Update Engineering Bindings

Join by immutable `component_id`. For each component being implemented, choose the source module, engineering component name, and property/type mapping appropriate to TECH_STACK.md. Write `docs/engineering/component-bindings.json` with:

- schema version;
- SHA-256 of the exact semantic contract;
- TECH_STACK revision;
- component ID, engineering name, module, and property bindings.

Validate against `.harness/rules/component-bindings.schema.json`. Never mutate the design contract to make a binding fit.

### 2. Return Sequence and Constraints

Recommend foundations and high-reuse `used_by` components first, then page-local composition, subject to the approved engineering dependency order. Return required properties, states, token references, accessibility behaviors, and package artifact paths for the current stable component ID.

### 3. Hand Off to the ACT Owner

`test-driven-development` remains the ACT owner: it writes the failing test, mutates implementation code, and runs the affected tests. This skill does not start a second Red/Green cycle or increment state.

### 4. Verification Contract

Return the checks below to `verify`; do not write evidence directly: current binding/TECH_STACK revisions, semantic property/state coverage, actual module/name, token resolution, accessibility/responsive/reduced-motion behavior, and relevant stable AC/DAC IDs.

## Brand Override

Anti-pattern defaults in design guidance are defaults, not universal bans. A project constitution or approved brand system may intentionally require a normally discouraged font, color treatment, radius system, or visual motif. Record the override source and still enforce accessibility, consistency, and evidence gates.

## Prohibitions

- Guessing a missing semantic component or silently changing its ID.
- Treating an example file as a runtime contract.
- Copying a design-suggested code name without making a Solo-owned binding decision.
- Hardcoding values that have an applicable token without a documented exception.
- Running a second independent TDD/verification lifecycle instead of returning constraints to the canonical pipeline.

## Verification

- [ ] Handoff consumer gate passed and receipt was written.
- [ ] Semantic contract and engineering binding both validate.
- [ ] Contract hash and tech-stack revision match current files.
- [ ] Every implemented component joins by stable component ID.
- [ ] Tests and frontend verification pass with AC/DAC evidence.
