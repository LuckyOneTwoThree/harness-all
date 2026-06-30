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

Verify owns `evidence.md` and the terminal attempt log. TDD does not write a competing evidence document or increment after execution.

## Hard Rules

- Behavior change: no production code before a test fails for the intended missing behavior.
- Refactor: baseline tests must already pass; the red signal is the explicit structural target, not a fabricated failing behavior test.
- Pure text/comment/format changes belong to quick-fix and may skip a new test.

## Process

### 1. Enter the Attempt

Read raw state, spec, and TECH_STACK. Reject terminal/broken state. Before any mutation:

1. enforce the recommended/hard limits;
2. increment `iteration` exactly once;
3. persist `stage: act`, `status: running`;
4. select one task outcome from spec.md.

Frontend tasks resolve the cited stable component ID in both `component-contract.json` and `component-bindings.json`. Missing design semantics block; missing Solo binding is created by frontend-implementation.

### 2. Red or Safety Baseline

- Feature/bug: write one behavior-focused test, or reuse the current validated failing regression from systematic-debugging; run it and confirm it fails for the intended reason—not syntax, fixture, or environment failure. Never add a duplicate test merely to repeat the Red ceremony.
- Refactor/migration safety step: run the relevant existing/characterization tests and confirm green before mutation.
- Record the exact command and output in the active execution context for verify-fast reuse.

If a new feature test passes immediately, either the behavior already exists or the assertion is ineffective. Stop and reconcile the spec; do not add production code merely to satisfy ceremony.

### 3. Green

Implement the smallest change that satisfies the current test/target. Do not bundle adjacent cleanup, new abstractions, or unrelated fixes. Run the focused test until green.

### 4. Refactor

With the focused test green, improve only code touched by this outcome when it materially improves clarity or removes duplication. Rerun the affected test set after every structural change. Refactor is optional when there is nothing concrete to improve; do not manufacture churn.

### 5. Hand to Verify

Keep `stage: act`, `status: running`, and the current iteration. Provide verify-fast with:

- exact commands and outputs;
- changed files;
- stable criteria exercised;
- any known limitation.

Do not append a second attempt record. Verify-fast writes the one terminal PASSED/FAILED outcome for this attempt.

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
- [ ] Verify-fast received actual output, not a prediction.

## Relationship with LOOP

This is the default ACT owner for feature, bugfix, and refactor variants. Performance and migration use their specialist ACT skills under the same state protocol.
