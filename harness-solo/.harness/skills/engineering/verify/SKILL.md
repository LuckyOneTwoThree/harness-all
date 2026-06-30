---
name: verify
description: Owns attempt outcomes and final delivery evidence; fast verification runs per attempt and full verification runs once before code review.
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
- one terminal outcome per attempt in `iterations.log`

## Mode Selection

- **verify-fast**: after every ACT attempt. Scope is the current outcome.
- **verify-full**: once after all planned outcomes pass fast verification. Scope is the complete change.

Do not run both modes after every task.

## Verify-Fast

1. Read raw state and confirm the current attempt number.
2. Validate tests:
   - reuse ACT's exact green output only when produced in the same execution context and neither command, code, nor attempt changed;
   - otherwise rerun the affected test set;
   - reject `0 tests`, stale output, or a different command than claimed.
3. Check only the stable AC/DAC IDs exercised by this task and any cited component contract/binding.
4. Run the changed-file quick security scan and disposition every hit.
5. Append exactly one terminal line for the attempt.

On pass: `stage: verify`, `status: running`, clear error. Continue to the next planned outcome or verify-full.

On failure: `stage: verify`, `status: retrying`, concrete error, then route by cause. At the recommended failed-attempt limit, set `needs-human`. A failed attempt 10 triggers the hard breaker; a successful attempt 10 may continue normally.

## Verify-Full

Run once, in this order:

1. **Full test command** — actual runner output and summary.
2. **Stable acceptance criteria** — every AC/DAC has test/assertion/demo evidence; design-only criteria route to Design rather than being guessed.
3. **Constitution/diff compliance** — dependencies, API tests, migrations, project clauses, and unrelated-file check.
4. **Security** — changed-file patterns from `security-patterns.md`, with explicit dispositions.
5. **Entropy** — compare exact current metrics to baseline using `entropy-baseline.md`; do not estimate LOC from file count.
6. **Frontend** — when frontend files changed, invoke webapp-testing once and verify semantic contract, binding hash/revision, token use, accessibility, build, typecheck, and lint.
7. **Documentation** — changed public API/schema/config has corresponding documentation or an explicit n/a reason.
8. **Evidence** — overwrite evidence.md using the canonical headings and actual outputs.

Full pass writes `stage: verify`, `status: running`, and clears error: verified, awaiting code review. It does **not** mark done.

Full failure writes `status: retrying` (or `needs-human`/`failed` under limit rules) and routes back to PLAN/ACT/debug. Do not append a second terminal outcome for an already logged attempt; append a distinct `full-verify` event.

## Invalid Evidence

- predicted language such as “should pass” without output;
- an AC marked pass without a concrete citation;
- stale test output after code changed;
- blanket false-positive/security waivers;
- frontend checks duplicated both here and outside webapp-testing;
- `status: done` written before code review.

## Completion Boundary

Verify proves correctness. Code-review proves maintainability and owns `review.md` plus the final done transition.
