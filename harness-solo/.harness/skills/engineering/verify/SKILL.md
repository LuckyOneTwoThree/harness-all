---
name: verify
description: Owns verify-full (final delivery evidence gate); fast verification is performed inline by each ACT skill per attempt, full verification runs once before code review.
---
# Verify

## Inputs

- `.harness/rules/engineering-pipeline.md`
- `.harness/loops/STATE_PROTOCOL.md`
- `constitution.md`, `spec.md`, raw `state.yaml`
- current diff and ACT commands/output
- `Reference/security-patterns.md`, `evidence-template.md`, `entropy-baseline.md`
- validated handoff/component/token artifacts when applicable

## Outputs

- `loops/specs/<task>/evidence.md` (full verification only)
- updated `state.yaml`
- one `full-verify` event in `iterations.log` (distinct from per-attempt outcomes written by ACT skills)

## Mode Selection

- **verify-fast**: inlined into the ACT skill (test-driven-development / performance-optimization / migration). The ACT owner performs the 4 fast-verify duties (test validation / AC-DAC check / changed-file security scan / append terminal outcome) inline before declaring the attempt outcome. See each ACT skill's "Inline Verify-Fast" step. (Note: `systematic-debugging` is NOT an ACT skill — it is a diagnostic skill invoked by failure routing; it does not perform inline verify-fast.)
- **verify-full**: owned by this skill; runs once after all planned outcomes pass fast verification. Scope is the complete change.

Do not run verify-full after every task — only once before code-review.

## Verify-Full

Run once, in this order (8 sub-checks merged into 4 groups):

1. **Tests + AC/DAC** — full test command with actual runner output/summary; every stable AC/DAC has test/assertion/demo evidence (design-only criteria route to Design rather than being guessed).
2. **Constitution + Security** — dependencies, API tests, migrations, project clauses, unrelated-file check; changed-file patterns from `security-patterns.md` with explicit dispositions.
3. **Entropy + Frontend + Documentation** — compare exact current metrics to baseline using `entropy-baseline.md` (do not estimate LOC from file count); when frontend files changed, invoke webapp-testing once (semantic contract, binding hash/revision, token use, accessibility, build, typecheck, lint); if no E2E tool is configured, record `DOM-level WCAG checks skipped (no E2E tool configured; static subset verified)` in evidence.md; changed public API/schema/config has documentation or explicit n/a reason.
4. **Evidence** — overwrite evidence.md using the canonical headings and actual outputs.

Full pass writes `stage: verify`, `status: running`, `substage: full-passed`, and clears error: verified, awaiting code review. It does **not** mark done.

Full failure writes `status: retrying`, `substage: full-failed` (or `needs-human`/`failed` under limit rules) and routes back to PLAN/ACT/debug. Do not append a second terminal outcome for an already logged attempt; append a distinct `full-verify` event.

## Invalid Evidence

- predicted language such as “should pass” without output;
- an AC marked pass without a concrete citation;
- stale test output after code changed;
- blanket false-positive/security waivers;
- frontend checks duplicated both here and outside webapp-testing;
- `status: done` written before code review.

## Completion Boundary

Verify proves correctness. Code-review proves maintainability and owns `review.md` plus the final done transition.
