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

| Skill | Scenario | Timing |
|-------|------|------|
| **tdd** | Writing **new feature** code | Red→Green→Refactor, tests first |
| **test-coverage** | Adding tests for **existing code** | Code already exists but lacks tests, or coverage has gaps |

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

**1.3 Classify gaps**:

| Gap Type | Priority | Test Type |
|---------|--------|---------|
| Core logic without tests | P0 | unit |
| Boundary conditions not covered | P0 | unit |
| API integration not tested | P1 | integration |
| Critical user flows not tested | P1 | E2E (if infrastructure exists) |
| Error paths not covered | P1 | unit |

### 2. Add Tests (by the test pyramid)

**Test pyramid 80/15/5**:
- 80% unit (millisecond-level, no I/O, pure logic)
- 15% integration (second-level, localhost, cross-boundary)
- 5% E2E (minute-level, real browser, critical paths only)

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

**3.1 Test state, not interactions**
- Assert on **results**, not on "which method was called"
- Anti-example: `expect(mockFn).toHaveBeenCalledWith(args)` ← breaks on refactor
- Positive example: `expect(result).toEqual(expectedResult)` ← behavior is stable

**3.2 DAMP over DRY**
- Tests should read like specifications; each test is self-contained and readable
- Allow duplication to avoid shared setup obscuring intent
- Shared setup is only for genuinely repeated boilerplate (e.g. creating a test context)

**3.3 Real implementation > Fake > Stub > Mock**
- Prefer real implementations (most credible)
- Use mocks only when the real implementation is too slow / non-deterministic / has uncontrollable side effects
- Excessive mocking leads to "tests green but production broken"

**3.4 Arrange-Act-Assert + one concept per test**
- Each test verifies only one behavior
- Naming describes the behavior: `it('sets status to completed and records timestamp')` instead of `it('works')`

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
| "This is too simple to test" | Simple code becomes complex; tests are behavior specs |
| "I'll write tests after the code works" | You won't, and after-the-fact tests test the implementation, not the behavior |
| "It's tested, should be fine" | "Should" is not evidence; run the tests and look at the output |
| "Just mock it and it passes" | Excessive mocking = tests green but production broken |
| "Skip this test to make the suite pass" | Skipping = not testing; mark it as tech debt and record it |

## State Maintenance

When inside a LOOP, follow `.harness/loops/STATE_PROTOCOL.md` and validate with `state.schema.json`:
- `stage`: `act` (while adding tests)
- Inside an active LOOP, the selected ACT owner increments once before the test batch; outside LOOP this skill does not invent or mutate LOOP iteration state
- `last_error`: on failure, fill in "test failed: <test name>"

Inside LOOP, return coverage results to verify; verify owns terminal attempt logging. Standalone test-only work reports results directly without fabricating LOOP history.

## Prohibitions
- Testing implementation details rather than behavior (breaks on refactor)
- One test verifying multiple concepts (when it fails you don't know which assertion broke)
- Mocking everything (tests green but production broken)
- Skipping tests to make the suite pass (mark tech debt; do not silently skip)
- Snapshot abuse (a snapshot is not an assertion; it's "looks the same")
- Flaky tests (timing/order-dependent; must fix or delete)

## Relationship with LOOP
This skill can be triggered inside or outside LOOP:
- **Inside LOOP**: add tests before refactor/migration to guard behavior → this skill is a prerequisite of the PLAN phase
- **Outside LOOP**: standalone test-adding task → go directly through this skill's process

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| test-coverage | Add tests for existing code |
| tdd | Red-green-refactor for new features (tests first) |
| systematic-debugging | Bug reproduction test (this skill adds similar regression tests) |
| verify | Coverage check as a verification sub-item |
| migration | Call this skill before migration to add test coverage |
