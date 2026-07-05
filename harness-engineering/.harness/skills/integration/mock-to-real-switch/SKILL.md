---
name: mock-to-real-switch
description: "Phase 3 integration skill. Use when switching the frontend from the Phase 1 mock API to the Phase 2 real backend — modifies only connection config (.env / mock toggle) and verifies the backend is reachable, never edits business code."
---
# Mock to Real Switch (Phase 3)

## When to use

- Phase 3 (integration) of the 4-phase engineering pipeline.
- Phase 1 frontend code reads from a mock API and Phase 2 backend endpoints are ready to receive traffic.
- Need to flip the frontend from mock to real with the smallest possible blast radius.

## Inputs

- Phase 1 frontend code + mock API configuration (path recorded in `component-bindings.json` `mock_api`).
- Phase 2 backend code + API implementation (endpoint list from `phase-2-backend-report.md`).
- `docs/handoff/pm-to-engineering.md` (current pointer, validated by session-start) API contract — the source of truth for which endpoints must be live. In degraded mode (no PM handoff), the source of truth is `contract.json` derived from user conversation.
- `docs/engineering/TECH_STACK.md` — `project_mode`, dev server commands, env conventions.
- `loops/specs/<task>/state.yaml`.

## Outputs

- Modified frontend connection config (`.env`, `.env.local`, mock toggle, or framework equivalent) under the project-mode location.
- **IAC-xxx IDs** for the switch itself (e.g., "mock→real switch succeeds without business-code edits"); allocated per `acceptance-id-protocol.md`, tracked in `spec.md` "Integration AC" section and `phase-3-integration-report.md`.
- Integration verification result (health check output + endpoint reachability) recorded in `state.yaml` notes and surfaced to `verify` for `evidence.md`.
- Updated `state.yaml` (substage); verify owns the final `evidence.md`.

## Iron Rule

**Only connection configuration changes.** Business code (components, hooks, services, API client wrappers) does not change in this skill. If switching the mock off requires editing business code, the Phase 1 abstraction leaked — surface it as a defect and route back to Phase 1, do not patch it here.

## Project Mode Adaptation

Read `docs/engineering/TECH_STACK.md` `project_mode`:

| Mode | Frontend config | Backend start |
|------|-----------------|---------------|
| `fullstack` | `.env` / `.env.local` at repo root; mock toggle in `app/api/mock/` | same process / `npm run dev` |
| `separate` | `client/.env` / `src/config/api.ts` | `server/` started independently |

When `project_mode` is unset, infer from the existing directory layout and record the inference in `state.yaml`.

## Hard Gates

1. Phase 1 and Phase 2 checkpoints must be confirmed (`substage_progress.frontend.user_confirmed = true` AND `substage_progress.backend.user_confirmed = true`) before this skill runs.
2. The backend must start and pass a health check before any frontend traffic is pointed at it.
3. Diff scope is restricted to: `.env*` files, mock toggle flags, framework config that selects the API base URL. Anything outside this set blocks.

## Process

### 1. Enter the Attempt

Read raw `state.yaml`, the Phase 1 mock configuration, and the Phase 2 endpoint list. Reject terminal/broken state. Before any mutation: enforce attempt limits, increment `iteration` exactly once, persist `stage: act`, `status: running`, and select the switch as the current outcome.

### 2. Inventory the Mock Wiring

Use Grep to find every place the mock is enabled: env vars (`VITE_USE_MOCK`, `NEXT_PUBLIC_API_MOCK`), mock toggle flags, MSW worker registration, `mock-server` import sites. Record the inventory. If the mock is wired directly into business code (not behind a config flag), stop and surface the Phase 1 leak — do not patch business code here.

### 3. Start the Backend + Health Check

Start the backend per `TECH_STACK.md`. Hit the documented health endpoint (e.g. `GET /health`, `GET /api/health`). Capture the actual response. If the backend does not start, or the health endpoint returns non-200, the switch cannot proceed — route by cause (Phase 2 implementation defect → Phase 2 ACT; env/startup defect → systematic-debugging).

### 4. Flip Connection Config Only

Modify only:

- `.env` / `.env.local` — set the real `API_BASE_URL`, set `USE_MOCK=false` (or framework equivalent);
- mock toggle flags — turn the mock off at the configuration layer;
- framework config that selects the API base URL.

Do not edit components, hooks, services, or API client wrappers. If a wrapper hardcodes a mock path, that is a Phase 1 defect — route back, do not patch here.

### 5. Verify Reachability

With the config flipped and the backend running, hit each endpoint the frontend will call (per the PRD contract) and confirm the backend responds with the contract-defined shape. Capture actual responses. Mismatches route to `contract-verify` (deeper analysis) or back to Phase 2 (implementation defect).

### 6. Inline Verify-Fast (merged)

This skill owns the per-attempt fast verification inline. Keep `stage: act`, `status: running`, and the current iteration. Perform the 4 fast-verify duties before declaring the attempt outcome:

1. **Validate tests** — the dev server still builds/typeschecks with the new config; the backend health check is green; at least one real endpoint returns the contract shape. Reject stale or predicted output.
2. **AC/IAC check** — confirm the stable AC/IAC IDs exercised by the switch have evidence. IAC-xxx IDs are produced by this skill in Phase 3.
3. **Changed-file security scan** — confirm no secrets were committed to `.env` files that are tracked by VCS; `.env` files in VCS are flagged.
4. **Append terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt.

On pass: `stage: verify`, `status: running`, `substage: inline-passed`, clear error. Hand to `contract-verify` and `e2e-verification`.
On failure: `stage: verify`, `status: retrying`, `substage: inline-failed`, concrete error, then route by cause. At the recommended failed-attempt limit, set `needs-human`.

Do not append a second attempt record. This inline step writes the one terminal outcome.

## Failure Handling

- Backend won't start / health check fails: route to Phase 2 ACT (implementation defect) or systematic-debugging (startup/env defect).
- Endpoint shape mismatch: route to `contract-verify` for analysis, then to the owning phase.
- Mock wired into business code: surface as Phase 1 defect; do not patch here.
- Never increment during failure handling.

## Prohibited

- Editing business code (components, hooks, services, API client wrappers) to make the switch work.
- Committing secrets or real credentials into a VCS-tracked `.env` file.
- Skipping the backend health check before flipping the frontend.
- Leaving the mock partially on (some endpoints mock, some real) without an explicit, documented reason.
- Running a second independent verification lifecycle instead of returning constraints to the canonical pipeline.

## Verification

- [ ] Iteration increment occurred once before mutation.
- [ ] Backend starts and the health endpoint returns 200.
- [ ] Diff is restricted to connection config; no business code changed.
- [ ] Real backend endpoints respond with the contract-defined shape.
- [ ] No secrets committed to VCS-tracked env files.
- [ ] Inline fast-verify received actual output, not a prediction.

## Relationship with LOOP

- Phase: 3 (integration)
- ACT owner: `mock-to-real-switch` (config-only mutation)
- Followed by `contract-verify` and `e2e-verification`; `verify` runs verify-full once for the phase, then the checkpoint writes `phase-3-integration-report.md`.

## Division of Labor with Other Skills

| Skill | Responsibility |
|-------|------|
| frontend-implementation | Owns the Phase 1 abstraction; a mock leak routes back here |
| api-implementation | Owns the Phase 2 endpoints the switch points at |
| contract-verify | Deep contract consistency analysis after the switch |
| e2e-verification | End-to-end user-flow verification after the switch |
