---
name: api-implementation
description: "Phase 2 backend ACT skill. Use when implementing API endpoints from the PRD API contract — writes endpoint code, input validation, the 7 standard error responses, and auth wiring, then hands Red/Green/Refactor to test-driven-development."
---
# API Implementation (Phase 2)

## When to use

- Phase 2 (backend) of the 4-phase engineering pipeline.
- Need to implement API endpoints from a PRD API contract.
- Phase 2 LOOP ACT owner; hands the Red/Green/Refactor cycle to `test-driven-development`.

## Inputs

- `docs/handoff/pm-to-engineering.md` (current pointer, validated by session-start) — the API contract section (method, path, request/response shape, status codes, auth). In degraded mode (no PM handoff), this is derived from user conversation + `contract.json`.
- `docs/handoff/contract.json` — entities surfaced from Phase 0/1. **Read `deviations[]` for Phase 1 contract deviations** that affect the API contract (e.g., a mock API path or response shape adjusted during frontend review via `DEV-<task>-<N>` with `detected_at_phase: 1` and `field` touching `components.<id>` mock API or an entity field exposed in a response). These deviations are the authoritative source for aligning endpoint paths/shapes with what the frontend actually consumes; `severity: major` deviations require explicit user approval.
- `loops/specs/<task>/phase-1-frontend-report.md` — Phase 1 downstream notes and contract deviation summary; surfaces manual adjustments to mock API paths or response shapes (e.g., "DEV-<task>-2 changed /api/todos response to include `priority` — Phase 2 api-implementation must match").
- Phase 1 mock API configuration (reference only; never copied verbatim — mock fixtures are not the source of truth).
- `docs/engineering/TECH_STACK.md` — framework + `project_mode`.
- `loops/specs/<task>/spec.md` and `state.yaml`.
- `.harness/rules/engineering-pipeline.md`, `rules/security.md`.

## Outputs

- API endpoint code under the project-mode location below.
- **BAC-xxx IDs** for each implemented endpoint (allocated per `acceptance-id-protocol.md`; tracked in `spec.md` "Backend AC" section and `phase-2-backend-report.md`).
- Updated `state.yaml`.
- Verify owns `evidence.md`; this skill owns the per-attempt terminal outcome.

## Project Mode Adaptation

Read `docs/engineering/TECH_STACK.md` `project_mode`:

| Mode | API code location |
|------|-------------------|
| `fullstack` | `api/` (co-located with the frontend app) |
| `separate` | `server/api/` |

When `project_mode` is unset, infer from the existing directory layout and record the inference in `state.yaml`.

## Hard Gates

1. Confirm `TECH_STACK.md` declares framework + `project_mode` before writing any code.
2. Every implemented endpoint must trace to a documented PRD API contract entry. Do not invent endpoints, methods, or response fields the PRD does not authorize.
3. Implement endpoints one-by-one against the contract; TDD — write the failing API test before the implementation.
4. Input validation, error handling, and auth are mandatory, not optional polish.
5. **Endpoint coverage (forward)**: every endpoint documented in the PRD API contract (including paths/shapes adjusted via Phase 1 `deviations[]`) must have a corresponding implementation. A missing endpoint blocks the phase checkpoint; do not silently skip endpoints the contract authorizes. When a deviation adjusted a path or response shape, the implementation must match the deviated contract, not the original PRD text. If a `severity: major` deviation adjusted the API shape (e.g., response field renamed, status code changed) and the deviation is recorded but not yet approved by the user, block the current outcome, surface the deviation for approval, and do not proceed until approval is granted or the deviation is withdrawn.

## The 7 Standard Error Codes

Every endpoint must be able to return these statuses; do not invent ad-hoc codes:

| Code | Meaning | When |
|------|---------|------|
| 400 | Bad Request | Malformed input / validation failure |
| 401 | Unauthorized | Missing or invalid authentication credentials |
| 403 | Forbidden | Authenticated but lacking permission |
| 404 | Not Found | Resource does not exist |
| 409 | Conflict | Duplicate / state conflict |
| 422 | Unprocessable Entity | Semantic validation failure beyond 400 |
| 500 | Internal Server Error | Unhandled server fault (never leak stack traces) |

Error response bodies follow the project's canonical error envelope (see `rules/security.md`). If no envelope exists, surface it as a planning gap; do not improvise per-endpoint shapes.

## Process

### 1. Enter the Attempt

Read raw `state.yaml`, spec, and the PRD API contract. Reject terminal/broken state. Before any mutation: enforce attempt limits, increment `iteration` exactly once, persist `stage: act`, `status: running`, and select one endpoint (or one tightly-coupled endpoint group) as the current outcome.

### 2. Red — Failing API Test First

Write one behavior-focused API test (status code + response shape + auth outcome) for the selected endpoint. Run it and confirm it fails for the intended reason — not syntax, fixture, or environment failure. Never add a duplicate test merely to repeat the Red ceremony. If the test passes immediately, the behavior already exists; stop and reconcile the spec.

### 3. Green — Implement the Endpoint

Implement the smallest change that satisfies the test:

- route handler matching the contract method + path;
- input validation (request body, params, query) per the PRD schema;
- the 7 standard error codes wired through the canonical envelope;
- authentication + authorization checks before the handler body.

Do not bundle adjacent cleanup, new abstractions, or unrelated fixes. Run the focused test until green.

### 4. Refactor

With the focused test green, improve only code touched by this endpoint when it materially improves clarity or removes duplication. Rerun the affected test set after every structural change. Refactor is optional; do not manufacture churn.

### 5. Inline Verify-Fast (merged)

This skill owns the per-attempt fast verification inline (verify-fast is no longer a separate skill invocation). Keep `stage: act`, `status: running`, and the current iteration. Perform the 4 fast-verify duties before declaring the attempt outcome:

1. **Validate tests** — reuse the exact green output from step 3 only when produced in the same execution context and neither command, code, nor attempt changed; otherwise rerun the affected test set. Reject `0 tests`, stale output, or a different command than claimed.
2. **AC/BAC check + BAC reverse coverage** — confirm the stable AC/BAC IDs exercised by this endpoint have evidence. Additionally, perform **BAC reverse coverage**: verify that every endpoint implemented in this attempt has a corresponding BAC-xxx ID declared in `spec.md` (one BAC per endpoint, covering method+path+response shape+auth outcome). If an endpoint is implemented without a BAC, this is a `missing-bac` finding — do not pass until the BAC is allocated and recorded. This prevents BAC under-coverage from reaching Phase 3.
3. **Changed-file security scan** — run the quick security scan on changed files and disposition every hit (auth bypass, SQL injection, secret leakage, error leakage).
4. **Append terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt.

On pass: `stage: verify`, `status: running`, `substage_progress[<active-phase>].verify_state: inline-passed`, clear error. Continue to the next endpoint; set `substage_progress[<active-phase>].verify_state: awaiting-full` when all planned endpoints are done.
On failure: `stage: verify`, `status: retrying`, `substage_progress[<active-phase>].verify_state: inline-failed`, concrete error, then route by cause. At the recommended failed-attempt limit, set `needs-human`. A failed attempt 10 triggers the hard breaker.

Do not append a second attempt record. This inline step writes the one terminal outcome.

## Failure Handling

- Known implementation defect: `status: retrying`, concrete `last_error`; verify/debug decides next route.
- Requirement/spec defect: stop mutation and return to PLAN.
- Unknown cause: invoke `systematic-debugging`.
- Never increment during failure handling.

## Prohibited

- Implementing endpoints not authorized by the PRD API contract.
- Skipping input validation, error handling, or auth to ship faster.
- Copying mock fixture data as production seed data.
- Inventing error codes outside the 7 standard set without a documented envelope extension.
- Leaking stack traces or internal state in 500 responses.
- Writing production code before a failing API test for the intended behavior.
- Running a second independent TDD/verification lifecycle instead of returning constraints to the canonical pipeline.

## Verification

- [ ] Iteration increment occurred once before mutation.
- [ ] API test failed for the intended reason before implementation.
- [ ] Every implemented endpoint traces to a PRD contract entry.
- [ ] Every PRD-documented endpoint (including Phase 1 deviation adjustments) has a corresponding implementation; paths/shapes match the deviated contract.
- [ ] Input validation + the 7 standard error codes + auth are wired.
- [ ] No endpoints, methods, or response fields invented beyond the PRD.
- [ ] Inline fast-verify received actual output, not a prediction.

## Relationship with LOOP

- Phase: 2 (backend)
- ACT owner: `api-implementation` → `test-driven-development`
- After all planned endpoints pass inline fast verification, `verify` runs verify-full once for the phase, then the checkpoint writes `phase-2-backend-report.md`.

## Division of Labor with Other Skills

| Skill | Responsibility |
|-------|------|
| data-layer | schema + ORM models + migrations consumed by the endpoints implemented here |
| test-driven-development | Owns the Red/Green/Refactor cycle once the API test is written |
| verify | verify-full evidence gate for phase 2 |
