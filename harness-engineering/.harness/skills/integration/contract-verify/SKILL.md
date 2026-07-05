---
name: contract-verify
description: "Phase 3 integration skill. Use when verifying frontend/backend contract consistency — compares API paths, request shapes, and response types across the frontend calls, backend implementations, and PRD API contract. Deep mode uses OpenAPI auto-verification; standard mode uses static code analysis."
---
# Contract Verify (Phase 3)

## When to use

- Phase 3 (integration) of the 4-phase engineering pipeline.
- Need to verify that what the frontend calls matches what the backend implements and what the PRD authorizes.
- After `mock-to-real-switch`; pairs with `e2e-verification`.

## Inputs

- Frontend code — the API call sites (paths, methods, request bodies, expected response types).
- Backend code — the implemented routes (paths, methods, handlers, response shapes).
- `docs/handoff/pm-to-engineering.md` (current pointer, validated by session-start) — the API contract section (the source of truth). In degraded mode (no PM handoff), the source of truth is `contract.json` derived from user conversation.
- OpenAPI spec, when present (`docs/api/openapi.yaml` or `.json`) — enables deep mode.
- `loops/specs/<task>/spec.md` and `state.yaml`.
- `state.yaml.exploration_mode` — workflow mode (`deep` / `standard`).

## Outputs

- A contract consistency report appended to `evidence.md` (via `verify`): pass/fail + a mismatches list (frontend ↔ backend ↔ PRD).
- **IAC-xxx IDs** for contract consistency outcomes (allocated per `acceptance-id-protocol.md`; tracked in `spec.md` "Integration AC" section and `phase-3-integration-report.md`).
- Each mismatch classified by owning phase (frontend call defect → Phase 1; backend implementation defect → Phase 2; PRD ambiguity → PLAN).
- Updated `state.yaml` (substage); `verify` owns the final `evidence.md`.

## Iron Rule

**The PRD API contract is the source of truth.** Frontend and backend must both conform to it. A frontend that calls an endpoint the PRD does not document, or a backend that implements a route the PRD does not authorize, is a defect — even if the two happen to agree with each other.

## Mode Selection

Read the active workflow mode from `state.yaml.exploration_mode` (fall back to the workflow invocation if unset):

| Mode | Method | When |
|------|--------|------|
| `deep` | OpenAPI auto-verification — generate/compare the spec against both sides | OpenAPI spec present or generatable from the backend |
| `standard` | Static code analysis — Grep the frontend call sites and backend route definitions, compare against the PRD contract | No OpenAPI spec, or workflow is `standard` |

`deep` is preferred when available; `standard` is the fallback. Never block on the absence of an OpenAPI spec — fall back to `standard`.

## Hard Gates

1. `mock-to-real-switch` must have passed (the backend is reachable).
2. Every PRD-documented endpoint must receive a disposition: `consistent` / `mismatch` / `frontend-only` / `backend-only`.
3. A `mismatch` requires a concrete citation (the differing field: path / method / request field / response field / status code / type).

## Process

### 1. Enter the Attempt

Read raw `state.yaml`, the PRD API contract, and the workflow mode. Reject terminal/broken state. Before any mutation: enforce attempt limits, increment `iteration` exactly once, persist `stage: act`, `status: running`, and select the contract surface to verify as the current outcome.

### 2. Build the Three-Sided Inventory

For each PRD-documented endpoint, collect:

- **PRD side**: method, path, request body schema, response body schema, status codes, auth requirement.
- **Frontend side**: the actual call site(s) — method, path, request body construction, response consumption (which fields are read).
- **Backend side**: the implemented route — method, path, input validation, response shape, status codes returned.

Use Grep to find frontend call sites (fetch / axios / framework client) and backend route definitions. Do not rely on memory or stale context.

### 3. Compare (mode-dependent)

**Deep mode** (OpenAPI present):

- Generate or load the OpenAPI spec from the backend.
- Validate the frontend client against the spec (path / method / request schema / response schema).
- Cross-check the spec against the PRD contract: every PRD endpoint must appear in the spec; every spec path must trace to a PRD entry.
- Capture the validator's actual output.

**Standard mode** (no OpenAPI):

- For each PRD endpoint, compare the three sides field-by-field: path, method, request body fields (name + type), response body fields (name + type), status codes, auth.
- Flag any divergence: frontend calls a path the backend doesn't implement; backend returns a field the frontend doesn't read; PRD documents a field neither side uses; type mismatch (frontend expects `string`, backend returns `number`).

### 4. Classify Mismatches

Each mismatch gets an owning phase:

| Mismatch pattern | Owner |
|------------------|-------|
| Frontend calls an endpoint the PRD does not document | Phase 1 (frontend) |
| Frontend calls a path/method the backend doesn't implement | Phase 1 (frontend) — or Phase 2 if the PRD authorizes it and the backend is missing it |
| Backend implements a route the PRD does not document | Phase 2 (backend) |
| Backend returns a field/type the PRD does not authorize | Phase 2 (backend) |
| PRD documents a field neither side uses | PLAN (PRD ambiguity) |
| Type mismatch between frontend expectation and backend response | Owning side deviates from PRD — whichever side disagrees with the PRD |

Ambiguous ownership stays in integration for triage; invoke `systematic-debugging` if the root cause is unclear.

### 5. Inline Verify-Fast (merged)

This skill owns the per-attempt fast verification inline. Keep `stage: act`, `status: running`, and the current iteration. Perform the 4 fast-verify duties before declaring the attempt outcome:

1. **Validate tests** — every PRD endpoint has a disposition; every `mismatch` has a concrete citation and an owning phase. Reject vague "looks inconsistent" findings.
2. **AC/BAC/IAC check** — confirm the stable AC/BAC IDs tied to contract consistency have evidence; IAC-xxx IDs are produced by this skill for contract consistency outcomes. BAC-xxx produced in Phase 2 are re-verified here against the frontend call sites.
3. **Changed-file security scan** — typically no code changes here; if any analysis script changed, scan it.
4. **Append terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt.

On pass (all endpoints `consistent`): `stage: verify`, `status: running`, `substage_progress[<active-phase>].verify_state: inline-passed`, clear error.
On failure (one or more `mismatch`): `stage: verify`, `status: retrying`, `substage_progress[<active-phase>].verify_state: inline-failed`, concrete error, then route by owning phase. At the recommended failed-attempt limit, set `needs-human`.

Do not append a second attempt record. This inline step writes the one terminal outcome.

## Failure Handling

- Mismatch with clear owning phase: route to that phase's ACT.
- PRD ambiguity (contract itself is unclear): route to PLAN.
- Ambiguous ownership: keep in integration; invoke `systematic-debugging` if root cause is unknown.
- Never increment during failure handling.

## Prohibited

- Marking an endpoint `consistent` without comparing all three sides (PRD + frontend + backend).
- Comparing only frontend ↔ backend and ignoring the PRD (the PRD is the source of truth, not the frontend's call sites).
- Inventing a new contract validator dependency — fall back to `standard` mode instead.
- Editing business code to resolve a mismatch — defects route to the owning phase.
- Vague mismatch descriptions ("types don't line up") without naming the field and the differing type.
- Running a second independent verification lifecycle instead of returning constraints to the canonical pipeline.

## Verification

- [ ] Iteration increment occurred once before mutation.
- [ ] Every PRD-documented endpoint has a disposition.
- [ ] Every `mismatch` has a concrete citation (field + differing value) and an owning phase.
- [ ] Deep mode used OpenAPI actual output (when available); standard mode used Grep-based inventory.
- [ ] No new validator dependency introduced.
- [ ] Inline fast-verify received actual output, not a prediction.

## Relationship with LOOP

- Phase: 3 (integration)
- ACT owner: `contract-verify` (analysis-focused ACT; no business-code mutation)
- Pairs with `mock-to-real-switch` and `e2e-verification`; `verify` runs verify-full once for the phase, then the checkpoint writes `phase-3-integration-report.md`.

## Division of Labor with Other Skills

| Skill | Responsibility |
|-------|------|
| mock-to-real-switch | Config switch that precedes contract verification |
| e2e-verification | User-flow verification (AC-driven) — complements this contract check |
| verify | Owns `evidence.md`; this skill appends contract findings |
| api-implementation / frontend-implementation | Own the sides being compared; mismatches route back to them |
