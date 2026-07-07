---
name: verify
description: Owns verify-full (final delivery evidence gate); fast verification is performed inline by each ACT skill per attempt, full verification runs once before code review.
---
# Verify

## When to use

- All planned tasks have passed inline verify-fast and verify-full is needed before code-review.
- Do not run verify-full after every task — only once before code-review (scope is the complete change, not per-task).

## Inputs

- `.harness/rules/engineering-pipeline.md`
- `.harness/loops/STATE_PROTOCOL.md`
- `constitution.md`, `spec.md`, raw `state.yaml` (fetched via the Read tool at verify-full entry, NOT from context memory; check `iteration` and `hard_limit_reached` before proceeding)
  - `ac_change` field, to cross-reference added ACs have evidence
- current diff and ACT commands/output
- `Reference/security-patterns.md`, `evidence-template.md`, `entropy-baseline.md`
- validated handoff/component/token artifacts when applicable

## Outputs

- `loops/specs/<task>/evidence.md` (full verification only)
- updated `state.yaml`
- one `full-verify` event in `iterations.log` (distinct from per-attempt outcomes written by ACT skills)

## Mode Selection

- **verify-fast**: inlined into each ACT skill that owns a per-attempt outcome. The 9 ACT skills with inline verify-fast are: `frontend-implementation`, `data-layer`, `api-implementation`, `mock-to-real-switch`, `contract-verify`, `e2e-verification` (the 6 phase-specific ACT skills), plus `test-driven-development`, `performance-optimization`, `migration` (the 3 specialist ACT skills). The ACT owner performs the 4 fast-verify duties (test validation / AC-BAC-IAC check / changed-file security scan / append terminal outcome) inline before declaring the attempt outcome. See each ACT skill's "Inline Verify-Fast" step. (Note: `systematic-debugging` is NOT an ACT skill — it is a diagnostic skill invoked by failure routing; it does not perform inline verify-fast.)
- **verify-full**: owned by this skill; runs once after all planned outcomes pass fast verification. Scope is the complete change.

Do not run verify-full after every task — only once before code-review.

## Verify-Full

Run once, in this order (8 sub-checks merged into 4 groups):

0. **Fetch current state via Read tool** — use the Read tool (not context memory) to load the raw `loops/specs/<task>/state.yaml`. Read the current `iteration` and `status` values. Reject if `status` is terminal (`done`/`failed`) or `hard_limit_reached: true`. Per `STATE_PROTOCOL.md`, verification must read raw `state.yaml`.

1. **Tests + AC/BAC/IAC** — full test command with actual runner output/summary; every stable AC/BAC/IAC has test/assertion/demo evidence (design constraints that cannot be automated route to 👤 human, not guessed).

   **👤 human soft gate**: items routed to 👤 human are NOT passed until the human explicitly confirms. Recording "routed to 👤 human" without confirmation is a `pending-human` state, not a pass. Evidence must cite the human's confirmation message, ticket, or explicit approval. A `pending-human` item blocks the phase checkpoint from being marked `completed: true`.

   **1a. AC/BAC/IAC Traceability Reconciliation** — cross-check ID coverage across artifacts:
   - Read `spec.md` to extract all declared AC-xxx, BAC-xxx, IAC-xxx IDs.
   - Read `evidence.md` to confirm every declared ID has a cited evidence entry (test file:line, assertion, or 👤 confirmation).
   - For multi-phase workflows: confirm every AC-xxx from the PM handoff has at least one corresponding BAC-xxx (Phase 2) or IAC-xxx (Phase 3). Gaps are flagged as `traceability-gap` findings, not hard failures — route to the owning phase for resolution.
   - For Phase 3 verify-full: confirm every BAC-xxx produced in Phase 2 has been re-verified by contract-verify or e2e-verification (check evidence.md Phase 3 block for BAC re-verification entries).
   - Record the reconciliation result in evidence.md: `AC/BAC/IAC reconciliation: N ACs, M BACs, K IACs — all traced` or list specific gaps.

   **1b. Test Coverage Soft Threshold** — if the project has a test coverage tool configured (e.g., `nyc`, `jest --coverage`, `coverage.py`, `go test -cover`), record the coverage percentage for changed files and the overall project in evidence.md. If coverage for changed files drops below 70% (soft threshold), record a `coverage-warning` finding — this is NOT a hard failure; surface it to the user for awareness and route to code-review for disposition. If no coverage tool is configured, record `coverage check skipped (no tool configured)` in evidence.md. The 70% threshold is a project-level default; `constitution.md` or `TECH_STACK.md` may override it with a project-specific value.
2. **Constitution + Security** — dependencies, API tests, migrations, project clauses, unrelated-file check; changed-file patterns from `security-patterns.md` with explicit dispositions.
3. **Entropy + Frontend + Documentation** — compare exact current metrics to baseline using `entropy-baseline.md` (do not estimate LOC from file count); when frontend files changed, invoke webapp-testing once (semantic contract, binding hash/revision, token use, accessibility, build, typecheck, lint); if no E2E tool is configured, record `DOM-level WCAG checks skipped (no E2E tool configured; static subset verified)` in evidence.md; changed public API/schema/config has documentation or explicit n/a reason.
4. **Evidence** — append a phase-scoped block to `evidence.md` using the canonical headings and actual outputs (see `evidence-template.md` for the multi-phase append convention). Do NOT overwrite prior-phase evidence.

5. **Artifacts validation reference** — run `.harness/scripts/validate-artifacts.ps1` (or invoke its cross-validation logic) and reference its result in evidence.md. If the script reports [FAIL] for any artifact (schema invalid, cross-validation failed), record as a `verify-failure` and block. If the script reports [SKIP] for expected phase artifacts (e.g., contract.json missing during Phase 0), record the skip reason in evidence.md. This step reuses the existing CI validator rather than duplicating artifact checks in verify-full, keeping a single source of truth for artifact validation logic.

On verify-full start: write `stage: verify`, `status: running`, `substage_progress[<active-phase>].verify_state: full-running` before executing the 4 check groups. Full pass writes `substage_progress[<active-phase>].verify_state: full-passed`, and clears error: verified, awaiting code review. It does **not** mark done.

Full failure writes `status: retrying`, `substage_progress[<active-phase>].verify_state: full-failed` (or `needs-human`/`failed` under limit rules) and routes back to PLAN/ACT/debug. Do not append a second terminal outcome for an already logged attempt; append a distinct `full-verify` event.

## Invalid Evidence

- predicted language such as “should pass” without output;
- an AC marked pass without a concrete citation;
- stale test output after code changed;
- blanket false-positive/security waivers;
- frontend checks duplicated both here and outside webapp-testing;
- `status: done` written before code review;
- a 👤 human-routed item marked pass without explicit human confirmation (must cite the confirmation message/ticket; `pending-human` is not a pass).

## Completion Boundary

Verify proves correctness. Code-review proves maintainability and owns `review.md` plus the final done transition.
