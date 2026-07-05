---
schema_version: "1.0"
handoff_id: "<PM-ENGINEERING-YYYYMMDD-NNN>"
producer: "harness-pm"
consumer: "harness-engineering"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
ac_ids: []
batch:
  id: 1
  type: full
  added_acs: []
  modified_acs: []
  superseded_acs: []
  unchanged_acs: []
artifacts: []
---

# Handoff: harness-pm → harness-engineering

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-pm
> Target framework: harness-engineering

## Project Mode & Routing

| Field | Value | Rule |
|---|---|---|
| project_mode | <fullstack / separate> | `fullstack` = one repo (Next.js/Remix/SvelteKit, app/+api/+lib/); `separate` = two roots (React+Express, src/+server/) |
| exploration_mode | <skip / standard / deep> | `skip` = only Phase 3; `standard` = Phase 0→1→2→3; `deep` = +OpenAPI contract |
| task_type | <new-feature / bugfix / refactor / migration / optimize / release> | Suggested routing; agent may extend scope with user confirmation |
| scope | <full / frontend / backend> | Default `full`. Suggested phase coverage; not a hard constraint |

**Routing guidance** (advisory, not hard constraint):

| task_type | scope | Suggested phases |
|---|---|---|
| new-feature | full | Phase 0 → 1 → 2 → 3 |
| new-feature | frontend | Phase 0 → 1 |
| new-feature | backend | Phase 0 → 2 |
| bugfix | frontend | Phase 1 (systematic-debugging + verify) |
| bugfix | backend | Phase 2 (systematic-debugging + verify) |
| refactor | full | Phase 1 + 2 + 3 |
| migration | — | Phase 2 (migration + data-layer + verify) |
| optimize | — | Phase 1 or 2 (depends on target) |
| release | — | Phase 3 (e2e + contract-verify) |

**Bugfix contract-change detection**: if bugfix changes API signatures or component props, engineering prompts user to either (A) sync contract.json only or (B) upgrade to refactor flow (Phase 0 + Phase 3 regression).

## Consumer Action Map

| Contract section | Engineering consumer action or gate |
|---|---|
| Project Mode & Routing | Select phase routing; enforce project_mode directory boundary |
| PRD + stable AC IDs | Generate specs/tests without renumbering |
| API Contract (PRD Section 3.2.6 or deep-mode OpenAPI) | Drive Phase 2 backend implementation + Phase 1 mock API config |
| Design Asset Paths | Phase 0 design-intake consumes them; agent reads original assets (multi-modal dual input) |
| Business Context Digest / NFR | Drive architecture tradeoffs and measurable constraints |
| Priority / out of scope | Define engineering plan boundaries |
| Tracking plan | Preserve instrumentation requirements in implementation and downstream handoff |
| Decisions / open items / risks | Apply, assign an owner, or stop when materially unresolved |

Any context without a downstream action belongs under Notes, not a new required section.

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 PRD, including 3 core features + acceptance criteria + tracking plan>

## Product Basics

| Field | Value | Notes |
|------|-----|------|
| Product name | <name> | |
| Product type | <web app / mobile app / desktop / landing page / ...> | Determines engineering architecture |
| Tech constraints (optional) | <platform/integration constraints, or unknown> | Context only; harness-engineering owns the final tech-stack decision |
| Platform | <iOS / Android / Web / desktop> | Determines deployment strategy |
| Current stage | <MVP / PMF / Scaling / ...> | Determines development priorities |

## Positioning Statement

<One-sentence positioning, from positioning skill output. e.g., A one-stop project management tool for indie developers>

## PRD Path and Acceptance Criteria

**PRD document**: `artifacts/product/PRD.md`
**PRD structured data**: `artifacts/product/prd.json` (generated projection with matching source hash)

**Acceptance criteria list (AC-xxx)**:

> The following ACs directly reuse the acceptance_criteria from the PRD, already numbered with ac_id.
> harness-engineering's writing-plans skill should reuse these IDs as-is, do not renumber.
> BAC-xxx (backend acceptance) and IAC-xxx (integration acceptance) are produced by engineering, not PM.
>
> **Batch delivery rule** (when `batch.type: incremental`):
> - `ac_ids` envelope field MUST contain ALL valid AC IDs (unchanged + added + modified), never just the changed subset — this prevents AC loss if a previous handoff was never consumed.
> - ACs marked `[unchanged]` may use a one-line summary + reference to the prior handoff (e.g., "see PM-ENGINEERING-20260704-001"); they do NOT need full Given-When-Then repetition.
> - ACs marked `[added]` or `[modified]` MUST include the full Given-When-Then description.
> - ACs marked `[superseded]` MUST include a pointer to the replacement AC ID (e.g., "superseded by AC-F01-002"); the superseded ID does NOT appear in `ac_ids` (only the replacement does).

| AC ID | Change | Description |
|-------|--------|-------------|
| AC-F01-001 | [added] | <full Given-When-Then or testable description> |
| AC-F01-002 | [added] | <full testable description> |
| AC-F02-001 | [added] | <full testable description; gaps are valid> |

> For incremental batches, the table would look like:
>
> | AC ID | Change | Description |
> |-------|--------|-------------|
> | AC-F01-001 | [unchanged] | (see PM-ENGINEERING-20260704-001) User login email verification |
> | AC-F02-001 | [unchanged] | (see PM-ENGINEERING-20260704-001) Password strength check |
> | AC-F06-001 | [added] | <full Given-When-Then for new feature> |
> | AC-F07-001 | [added] | <full Given-When-Then for new feature> |
> | AC-F03-001 | [superseded] | superseded by AC-F03-002 — original checkout flow replaced |
> | AC-F03-002 | [added] | <full Given-When-Then for replacement AC> |

## Engineering-Consumable PRD Sections

> harness-engineering's brainstorming should read these PRD sections as direct input (not just the AC-xxx list):

| PRD section | What engineering consumes | Where in prd.json |
|------|------|------|
| 3.2.1 Feature list | MoSCoW priorities, feature dependencies | `features[].priority` + `features[].dependencies` |
| 3.2.5 Data model | Entities, fields, relationships (for ER design + migration) | `entities[]` |
| 3.2.6 Interface definition | API contract input (method/path/params/response) | `features[].api_endpoints[]` (advisory; final API design by engineering) |
| 4.2 Technical constraints | Architecture constraints, known tech debt | (in prd.md Section 4.2) |
| 5.1-5.4 NFR | Performance, availability, security, observability targets | `non_functional_requirements[]` |
| 7.1 Functional acceptance | AC-xxx (Happy Path + boundary + exception) | `features[].acceptance_criteria[]` |

## Business Context Digest

> Engineering-relevant constraints extracted by PM from user-research.md / market-analysis.md.
> harness-engineering **must reference** these when making architecture and tech-stack decisions, to avoid technical choices detached from business reality.
>
> Extraction rules:
> - ✅ Extract: constraints that affect architecture / tech selection / performance requirements / capacity planning / data scale
> - ❌ Do not extract: user personas / mental models / aesthetic preferences (those are not engineering constraints)

| Constraint | Engineering impact | Source |
|--------|---------|------|
| <e.g., single export can be up to 5GB> | <e.g., requires async queue, cannot generate synchronously> | <user-research.md#export-scenarios> |
| <e.g., 70% of target users on mobile> | <e.g., mobile-first, first screen < 2s> | <user-research.md#device-distribution> |
| <e.g., peak concurrency estimated at 1000 QPS> | <e.g., requires cache layer + rate limiting> | <market-analysis.md#capacity-estimate> |

> If user-research.md / market-analysis.md do not exist, record "No additional business context; use the stated ACs".

## Feature Priorities

| Priority | Feature | Source | Notes |
|--------|------|------|------|
| P0 | <core feature 1> | PRD | MVP must-do |
| P1 | <important feature 2> | PRD | Important but can be deferred |
| P2 | <enhancement 3> | PRD | Optional |

## Tracking Plan (if any)

| Asset | Path | Notes |
|------|------|------|
| Tracking plan | artifacts/metrics/tracking-plan.md | Event tracking definitions |
| Metric system | artifacts/metrics/metrics-system.md | North Star + key metrics |

> If not yet produced, fill in "To be supplemented".
>
> **Note**: the unified PRD always includes Section 6 (Tracking Plan) and Section 6.3 (Experiment Hypothesis Reference). Ensure the experiment_hypothesis_ref in prd.json is filled when applicable — downstream analysis skills depend on event definitions and hypotheses.

## Design Assets (user-provided)

> The following are user-owned design assets (Figma / v0 / markdown designs / image files). PM collected their paths during PRD design; harness-engineering Phase 0 design-intake consumes them.
> If no design assets exist, fill in "No design assets provided; engineering proceeds with PRD-only mode (degraded visual fidelity)".

| Asset | Path | Type | Notes |
|------|------|------|------|
| Design source 1 | artifacts/design-assets/<file> | <figma / v0 / md / image> | <e.g., main page mockup> |
| Design source 2 | artifacts/design-assets/<file> | <figma / v0 / md / image> | <e.g., component library> |
| Design system (if any) | artifacts/design-assets/<dir> | tokens / css | <e.g., existing color tokens> |

> **Degraded mode**: when design assets are absent, engineering Phase 0 produces contract.json + tokens.json based on PRD only; visual fidelity is marked as 👤 human-adjusted in Phase 1.

## Out of Scope

Content explicitly excluded from this engineering scope:

- Not doing <X>
- Not doing <Y>

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose tech stack X | Team familiarity + mature ecosystem | Whole project |
| Skip feature Y | Not in MVP scope | Scope boundary |

## Open Items

Issues for harness-engineering to handle or confirm with harness-pm:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Suggested Next Steps

harness-engineering should:

1. Run session-start, read this handoff, recover substage state if any
2. Route to the appropriate phase based on `task_type` + `scope` (advisory)
3. Phase 0 design-intake: consume PRD + design assets → produce `contract.json` + `tokens.json`
4. Phase 1 frontend: contract + assets → frontend code (TDD, mock-backed)
5. Phase 2 backend: API contract → api + data + migration
6. Phase 3 integration: mock→real switch + e2e verification → produce `engineering-to-pm.md`

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Tech stack undecided | High/Medium/Low | <action> |
| Design assets not ready | High/Medium/Low | <action; or proceed in PRD-only mode> |
| Tracking plan missing | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-engineering's session-start / design-intake / brainstorming / writing-plans / verify skills will auto-detect this file and read stable AC IDs, project_mode, exploration_mode, task_type, scope, feature priorities, design asset paths, and the Business Context Digest.
If not auto-detected, you can manually point the Agent to this file path to read it.
