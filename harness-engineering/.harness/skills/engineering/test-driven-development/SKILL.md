---
name: test-driven-development
description: Executes one behavior or structure change through Red, Green, and Refactor while obeying the shared attempt protocol.
---
# Test-Driven Development

## When to use

- Feature or bug behavior changes.
- Refactoring guarded by existing or characterization tests.
- Review fixes that change production behavior.

## Inputs

- `.harness/rules/engineering-pipeline.md`
- `.harness/loops/STATE_PROTOCOL.md`
- `loops/specs/<task>/spec.md` and `state.yaml`
- `docs/engineering/TECH_STACK.md`
- frontend semantic contract and binding when cited by the task

## Outputs

- production/test changes
- updated `state.yaml`

Verify owns `evidence.md`. TDD owns the per-attempt terminal outcome (inline verify-fast) and does not write a competing evidence document or increment after execution.

## Hard Rules

- Behavior change: no production code before a test fails for the intended missing behavior.
- **If implementation code is found to exist before a failing test for the intended behavior, delete that implementation and return to RED.** Writing tests to fit existing code is not TDD; it rationalizes unverified implementation.
- Refactor: baseline tests must already pass; the red signal is the explicit structural target, not a fabricated failing behavior test.
- Pure text/comment/format changes belong to quick-fix and may skip a new test.

## Process

### 1. Enter the Attempt

Read raw state, spec, and TECH_STACK. Reject terminal/broken state. Before any mutation:

1. enforce the recommended/hard limits;
2. increment `iteration` exactly once;
3. persist `stage: act`, `status: running`;
4. select one task outcome from spec.md.

Frontend tasks resolve the cited stable component ID in both `contract.json` and `component-bindings.json`. Missing design semantics block; missing engineering binding is created by frontend-implementation.

### 2. Red or Safety Baseline

- Feature/bug: write one behavior-focused test, or reuse the current validated failing regression from systematic-debugging; run it and confirm it fails for the intended reason—not syntax, fixture, or environment failure. Never add a duplicate test merely to repeat the Red ceremony.
- Refactor/migration safety step: run the relevant existing/characterization tests and confirm green before mutation.
- Record the exact command and output in the active execution context for verify-fast reuse.

If a new feature test passes immediately, either the behavior already exists or the assertion is ineffective. Stop and reconcile the spec; do not add production code merely to satisfy ceremony.

### 3. Green

Implement the smallest change that satisfies the current test/target. Do not bundle adjacent cleanup, new abstractions, or unrelated fixes. Run the focused test until green.

### 4. Refactor

With the focused test green, improve only code touched by this outcome when it materially improves clarity or removes duplication. Rerun the affected test set after every structural change. Refactor is optional when there is nothing concrete to improve; do not manufacture churn.

### 5. Inline Verify-Fast (merged)

TDD owns the per-attempt fast verification inline (verify-fast is no longer a separate skill invocation). Keep `stage: act`, `status: running`, and the current iteration. Perform these 4 fast-verify duties before declaring the attempt outcome:

1. **Validate tests** — reuse the exact green output from step 3 only when produced in the same execution context and neither command, code, nor attempt changed; otherwise rerun the affected test set. Reject `0 tests`, stale output, or a different command than claimed.
2. **AC/BAC/IAC check** — confirm the stable AC/BAC/IAC IDs exercised by this task have evidence; cite component contract/binding when frontend.
3. **Changed-file security scan** — run the quick security scan on changed files and disposition every hit.
4. **Append terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt.

On pass: `stage: verify`, `status: running`, `substage_progress[<active-phase>].verify_state: inline-passed`, clear error. Continue to the next planned outcome; set `substage_progress[<active-phase>].verify_state: awaiting-full` when all planned outcomes are done and handing off to verify-full.
On failure: `stage: verify`, `status: retrying`, `substage_progress[<active-phase>].verify_state: inline-failed`, concrete error, then route by cause (see Failure Handling). At the recommended failed-attempt limit, set `needs-human`. A failed attempt 10 triggers the hard breaker.

Do not append a second attempt record. This inline step writes the one terminal outcome.

## Failure Handling

- Known implementation defect: set `status: retrying`, concrete `last_error`; verify/debug decides next route.
- Requirement/spec defect: stop mutation and return to PLAN.
- Unknown cause: invoke systematic-debugging.
- Never increment during failure handling.

## Verification

- [ ] Iteration increment occurred once before mutation.
- [ ] Test failed for the intended reason when behavior changed.
- [ ] Minimal implementation passes the focused/affected tests.
- [ ] No unrelated scope entered the diff.
- [ ] Inline fast-verify received actual output, not a prediction.

## Relationship with LOOP

Default ACT owner for feature/bugfix/refactor variants; performance and migration use their specialist ACT skills. See `.harness/loops/LOOP.md`.
