---
name: test-driven-development
description: Test-Driven Development (TDD) — red→green→refactor
---
# Test-Driven Development — TDD

## When to use
- Before writing new feature code
- Before modifying existing features
- When writing a reproduction test for a bug fix

## Inputs
- rules/security.md
- loops/LOOP.md

## Outputs
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/evidence.md
- loops/specs/<feature>/iterations.log

## Iron Rule
**No production code without a failing test.** A test that passes immediately = you are testing existing behavior, not new behavior.

## Process

### Red
1. Based on the acceptance criteria in spec.md, write a failing test
2. Run the test and **confirm it fails** (not "should fail", but actually see FAIL)
3. The failure reason must be "feature not implemented", not "the test itself has a bug"

### Green
1. Write the **minimal** implementation to make the test pass
2. Run the test and confirm it passes
3. Do not over-engineer — just enough to pass; leave refactoring for the next step

### Refactor
1. Refactor the code while the tests are all green
2. Run the tests immediately after each refactor and confirm no regression
3. Refactor goal: readability, eliminating duplication, not adding features

## State Maintenance Per Iteration

After completing one red→green→refactor, update state.yaml per the "state.yaml Schema" in `loops/LOOP.md`:
- `iteration`: +1
- `stage`: `act`
- `status`: `running`
- `last_error`: clear to "" on success

On failure, update:
- `stage`: `verify` (about to enter verification but failed)
- `last_error`: `"test_xxx FAILED: <error message>"`
- `status`: `retrying`

For full field definitions and write responsibilities, see the "Field Write Responsibilities" table in LOOP.md.

**Update iterations.log (must append, overwriting is forbidden)**:
- Tool approach: first Read the current iterations.log → append the new line → Write it back
- Or terminal command: `echo "[YYYY-MM-DD HH:MM] iter=<N> stage=act → verify FAILED: <test name>" >> .harness/loops/specs/<feature>/iterations.log`
- Do not use Write to overwrite iterations.log directly (it would erase historical iteration records)

Append format:
```
[YYYY-MM-DD HH:MM] iter=<N> stage=act → verify FAILED: <test name>
```

## Prohibitions
- Writing code first and adding tests later (putting the cart before the horse)
- Saying "should pass" without running the test after writing it (you must see the actual output)
- Writing multiple tests at once before implementing (violates small-step iteration)
- Over-engineering in the green phase (YAGNI)
- Adding new features during refactoring (mixing responsibilities)

## Anti-Rationalization Table

| Anti-pattern | Common excuse | Why it doesn't hold |
|---|---|---|
| Writing code first, adding tests later | "I already know how to implement it" | Tests written after the fact conform to the implementation and cannot validate the design |
| Saying "should pass" without running | "The change is tiny" | Running a test costs ≤ 30 seconds; regression triage costs hours |
| Over-engineering in Green | "I'll need this later anyway" | YAGNI — unused code is a liability, not an asset |
| Skipping Refactor | "The feature works, ship it" | Tech debt compounds; the next change costs more |
| Stopping after one test passes | "It's green, done" | Other tests may have regressed silently; run the full suite |
| Mocking instead of using real code | "Mocks are faster" | You are testing the mock, not the code under test |
| Writing multiple tests before any impl | "Batching is more efficient" | Violates small-step iteration; you cannot isolate which test drove which code |

## Red Flags

Stop immediately and reassess if you observe any of:
- Test output shows `0 tests` or `0 passed` — the test was not collected by the runner
- evidence.md contains the phrase "should pass" — you did not actually run the test
- A new test passes on the first run without any implementation change — you are testing existing behavior, not new behavior
- Refactor skipped because "it already works" — tech debt is accumulating now
- Multiple tests written before any implementation — small-step iteration is broken
- Implementation exceeds the scope of the failing test — you are gold-plating, not satisfying the spec

## Good vs Bad

A good failing test pins one behavior and fails for the right reason. A bad failing test is vague, passes for the wrong reason, or tests implementation details instead of behavior.

<Good>
```python
def test_discount_rejects_negative_price():
    cart = Cart()
    with pytest.raises(ValueError):
        cart.apply_discount(price=-10)
```
</Good>

<Bad>
```python
def test_discount_works():
    cart = Cart()
    cart.apply_discount(price=-10)
    assert cart.total >= 0  # passes even if the bug exists
```
</Bad>

## Relationship with LOOP
This skill corresponds to the ACT phase of LOOP.
- Red = write tests (input to ACT)
- Green = write implementation (execution of ACT)
- Refactor = optimization of ACT
- After completion, enter VERIFY (handed off to the verify skill)

## Evidence Requirements
After tests pass, write the actual output into evidence.md:
```
## Test Results
$ <test command>
<actual output, including the number of passes>

## Acceptance Criteria
- AC-001: ✓ <how it is satisfied>
- AC-002: ✓ <how it is satisfied>
```
