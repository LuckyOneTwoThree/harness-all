---
name: test-coverage
description: Test Coverage — coverage gap analysis + adding boundary/integration/E2E tests
---
# Test Coverage — Test Coverage

## When to use
- When existing code lacks tests
- When coverage drops
- When adding tests before refactoring (Beyonce Rule)
- When adding regression tests after a bug fix

## Inputs
- loops/LOOP.md
- loops/STATE_PROTOCOL.md
- loops/state.schema.json
- rules/security.md
- docs/engineering/TECH_STACK.md

## Outputs
- loops/specs/<feature>/state.yaml
- coverage command/results returned to verify (or reported directly for standalone test-only work)

## Iron Rule
**Tests are proof.** "Seems right" is not done. Code without tests that breaks during refactoring/migration is not the refactor's fault — it is the fault of your missing tests (Beyonce Rule).

## Division of Labor with the tdd Skill

This skill does not write new feature code; it only adds tests to guard existing behavior.

## Process

### 1. Coverage Gap Analysis

**1.1 Run the coverage tool** (read `docs/engineering/TECH_STACK.md` to confirm the command):
```bash
# Node
npm test -- --coverage
# Python
pytest --cov=src --cov-report=term-missing
```
Show the full output and record the current coverage.

**1.2 Identify gaps**:
- Uncovered files/functions/branches (the parts marked red in the coverage report)
- Critical paths first: core business logic > helper functions > edge tooling
- Risk first: high-frequency files changed recently, modules with a bug history

### 2. Add Tests (by the test pyramid)

**2.1 Unit tests** (add first):
- Pure logic functions: test inputs and outputs
- Boundary conditions: empty values / extremes / negatives / very long strings
- Error paths: anomalous inputs should throw expected exceptions

**2.2 Integration tests**:
- API integration: request→response correctness
- DB interactions: CRUD correctness
- Cross-module collaboration: data flow correctness

**2.3 E2E tests** (critical paths only; introducing the framework requires user approval):
- Core user flows: login→operation→result
- Not mandatory in this skill (abide by the constitution's zero-new-dependency principle)

### 3. Test Quality Rules
gap 分类表、Test pyramid、Test Quality Rules 见 `Reference/test-quality-principles.md`

### 4. Verification

- Run the full test suite and confirm the new tests are all green + no regressions
- Compare coverage: before → after, showing the improvement numbers
  ```
  ## Coverage Comparison
  | Metric | Before | After |
  |------|--------|-------|
  | Lines | 62% | 85% |
  | Branches | 48% | 78% |
  ```
- New tests must not be empty shells (assertions must be meaningful, not `expect(true).toBe(true)`)

## Adding Regression Tests After a Bug Fix

After a bug fix (via the bugfix workflow), you **must** add regression tests:
1. The bug's reproduction test already exists (produced by systematic-debugging)
2. Check for similar issues: the same root cause may exist elsewhere → add tests
3. Add regression tests to the suite to prevent the bug from recurring

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "Just mock it and it passes" | Excessive mocking = tests green but production broken |
| "Skip this test to make the suite pass" | Skipping = not testing; mark it as tech debt and record it |

## State Maintenance

Follow `.harness/loops/STATE_PROTOCOL.md`: the active ACT skill owns the per-attempt terminal outcome; verify owns `evidence.md`. Inside LOOP, return results to verify; outside LOOP, do not invent LOOP state.

## Prohibitions
- Testing implementation details rather than behavior (breaks on refactor)
- One test verifying multiple concepts (when it fails you don't know which assertion broke)
- Mocking everything (tests green but production broken)
- Skipping tests to make the suite pass (mark tech debt; do not silently skip)
- Snapshot abuse (a snapshot is not an assertion; it's "looks the same")
- Flaky tests (timing/order-dependent; must fix or delete)

## Relationship with LOOP

Triggered inside LOOP as a PLAN prerequisite (before refactor/migration/optimize) or outside LOOP as a standalone test-adding task. See `.harness/loops/LOOP.md`.

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| systematic-debugging | Bug reproduction test (this skill adds similar regression tests) |
| migration | Call this skill before migration to add test coverage |
