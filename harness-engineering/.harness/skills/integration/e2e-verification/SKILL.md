---
name: e2e-verification
description: "Phase 3 integration skill. Use when verifying end-to-end user flows against the PRD acceptance-criteria list — starts frontend + backend, runs AC-driven flow checks, and routes visual/interaction checks to 👤 human verification instead of introducing Playwright."
---
# End-to-End Verification (Phase 3)

## When to use

- Phase 3 (integration) of the 4-phase engineering pipeline.
- Frontend and backend are both running against real data (after `mock-to-real-switch`).
- Need to verify the full user flows described by the PRD acceptance-criteria (AC) list.
- Visual / interaction correctness that automation cannot judge is routed to 👤 human verification.

## Inputs

- Phase 1 frontend code + Phase 2 backend code (both confirmed).
- `docs/handoff/pm-to-engineering.md` (current pointer, validated by session-start) — the acceptance-criteria list (AC-xxx) defining the user flows to verify. In degraded mode (no PM handoff), the AC list comes from `spec.md` (product AC section).
- `loops/specs/<task>/spec.md` — the AC/BAC/IAC IDs in scope and their evidence status.
- `loops/specs/<task>/evidence.md` — evidence accumulated by `verify` so far.
- `docs/engineering/TECH_STACK.md` — dev server start commands.
- `loops/specs/<task>/state.yaml`.

## Outputs

- An e2e verification report appended to `evidence.md` (via `verify`): per-AC/BAC pass/fail + residual issues.
- **IAC-xxx IDs** for each verified end-to-end user flow (allocated per `acceptance-id-protocol.md`; tracked in `spec.md` "Integration AC" section and `phase-3-integration-report.md`).
- 👤 human-confirmation items list (visual / interaction checks) surfaced for the user.
- Updated `state.yaml` (substage); `verify` owns the final `evidence.md`.

## Iron Rule

**Do not introduce Playwright or any new E2E framework.** Visual and interaction correctness is judged by 👤 human verification. Automation here covers reachable, deterministic checks (HTTP-level flow, status codes, response shapes, state transitions visible to the API). If a check cannot be automated without a new dependency, it is a 👤 human-confirmation item — do not install a framework to avoid the human step.

## Hard Gates

1. `mock-to-real-switch` must have passed (backend reachable, frontend pointing at real API).
2. Every AC-xxx in the PRD acceptance-criteria list must receive a disposition: `pass` / `fail` / `👤 human`. No AC is silently skipped.
3. A `fail` requires a concrete defect citation (endpoint, input, observed vs expected). Vague failure descriptions are invalid.

## Process

### 1. Enter the Attempt

Read raw `state.yaml`, the PRD AC list, and current `evidence.md`. Reject terminal/broken state. Before any mutation: enforce attempt limits, increment `iteration` exactly once, persist `stage: act`, `status: running`, and select the AC set to verify as the current outcome.

### 2. Start Frontend + Backend

Start both per `TECH_STACK.md`. Confirm the backend health endpoint returns 200 and the frontend dev server compiles without errors. Capture actual startup output. If either fails to start, route by cause (Phase 1 / Phase 2 / systematic-debugging) — do not proceed to flow verification.

### 3. AC-Driven Flow Verification

For each AC-xxx in scope:

- Identify the user flow the AC describes (entry point → action → expected outcome).
- For deterministic, API-reachable steps: drive the flow via the real backend (HTTP request → response → next request) and compare observed against expected. Capture actual responses.
- For visual / interaction steps (layout, animation feel, copy tone, hover/focus behavior, brand-specific rendering): mark 👤 human-confirmation required with a concrete prompt for the user — never silently skip, never fabricate an automated pass.
- Record the disposition: `pass` (with evidence) / `fail` (with defect citation) / `👤 human` (with the prompt).

### 4. Aggregate Findings

Group failures by likely owning phase: frontend rendering defect → Phase 1; backend behavior defect → Phase 2; cross-cutting / ambiguous → keep in integration for triage. Each failure links to the AC-xxx it blocks.

### 5. Inline Verify-Fast (merged)

This skill owns the per-attempt fast verification inline. Keep `stage: act`, `status: running`, and the current iteration. Perform the 4 fast-verify duties before declaring the attempt outcome:

1. **Validate tests** — every AC in scope has a disposition; 👤 human items have concrete prompts; `fail` items have defect citations. Reject empty dispositions or vague failures.
2. **AC/BAC/IAC check** — confirm every stable AC-xxx in scope has a recorded disposition (the AC list IS the test set here); BAC-xxx produced in Phase 2 are re-verified at the integration layer; IAC-xxx produced by this skill cover cross-phase user flows.
3. **Changed-file security scan** — typically no code changes in this skill; if any config/startup file changed, scan it.
4. **Append terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt.

On pass (all ACs `pass` or `👤 human` with no blocking `fail`): `stage: verify`, `status: running`, `substage_progress[<active-phase>].verify_state: inline-passed`, clear error. Surface 👤 items to the user.
On failure (one or more blocking `fail`): `stage: verify`, `status: retrying`, `substage_progress[<active-phase>].verify_state: inline-failed`, concrete error, then route by cause. At the recommended failed-attempt limit, set `needs-human`.

Do not append a second attempt record. This inline step writes the one terminal outcome.

## Failure Handling

- Frontend won't start: route to Phase 1 ACT.
- Backend won't start: route to Phase 2 ACT.
- AC `fail` with owning phase clear: route to that phase's ACT.
- AC `fail` with ambiguous owner: keep in integration; invoke `systematic-debugging` if root cause is unknown.
- Never increment during failure handling.

## Prohibited

- Introducing Playwright, Cypress, or any new E2E framework to automate visual checks.
- Marking an AC `pass` without a concrete citation (response, screenshot reference, or 👤 confirmation).
- Silently skipping an AC because it is "visual only" — it must be a 👤 human-confirmation item with a prompt.
- Fabricating an automated pass for a check that requires human judgement.
- Editing business code to make a flow pass — defects route to the owning phase.
- Running a second independent verification lifecycle instead of returning constraints to the canonical pipeline.

## Verification

- [ ] Iteration increment occurred once before mutation.
- [ ] Frontend + backend both start; health check green; dev server compiles.
- [ ] Every AC-xxx in scope has a disposition (pass / fail / 👤 human).
- [ ] Every `fail` has a concrete defect citation.
- [ ] Every `👤 human` item has a concrete prompt for the user.
- [ ] No new E2E framework introduced.

## Relationship with LOOP

- Phase: 3 (integration)
- ACT owner: `e2e-verification` (verification-focused ACT; no business-code mutation)
- Pairs with `contract-verify` and `mock-to-real-switch`; `verify` runs verify-full once for the phase, then the checkpoint writes `phase-3-integration-report.md`.

## Division of Labor with Other Skills

| Skill | Responsibility |
|-------|------|
| mock-to-real-switch | Config-only switch that precedes this skill |
| contract-verify | Contract consistency analysis (path/request/response types) |
| verify | Owns `evidence.md`; this skill appends e2e findings |
| webapp-testing | Static frontend checks (build / type / lint / a11y) — not duplicated here |
