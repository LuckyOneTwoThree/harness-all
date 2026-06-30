# Test Quality Principles — Shared by test-coverage & TDD

## Gap Classification

| Gap Type | Priority | Test Type |
|---------|--------|---------|
| Core logic without tests | P0 | unit |
| Boundary conditions not covered | P0 | unit |
| API integration not tested | P1 | integration |
| Critical user flows not tested | P1 | E2E (if infrastructure exists) |
| Error paths not covered | P1 | unit |

## Test Pyramid 80/15/5

- 80% unit (millisecond-level, no I/O, pure logic)
- 15% integration (second-level, localhost, cross-boundary)
- 5% E2E (minute-level, real browser, critical paths only)

## Test Quality Rules

### 3.1 Test state, not interactions
- Assert on **results**, not on "which method was called"
- Anti-example: `expect(mockFn).toHaveBeenCalledWith(args)` ← breaks on refactor
- Positive example: `expect(result).toEqual(expectedResult)` ← behavior is stable

### 3.2 DAMP over DRY
- Tests should read like specifications; each test is self-contained and readable
- Allow duplication to avoid shared setup obscuring intent
- Shared setup is only for genuinely repeated boilerplate (e.g. creating a test context)

### 3.3 Real implementation > Fake > Stub > Mock
- Prefer real implementations (most credible)
- Use mocks only when the real implementation is too slow / non-deterministic / has uncontrollable side effects
- Excessive mocking leads to "tests green but production broken"

### 3.4 Arrange-Act-Assert + one concept per test
- Each test verifies only one behavior
- Naming describes the behavior: `it('sets status to completed and records timestamp')` instead of `it('works')`

本文件为 test-coverage 与 test-driven-development 共享的测试质量原则参考。
