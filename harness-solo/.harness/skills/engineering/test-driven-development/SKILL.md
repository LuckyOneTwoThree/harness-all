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
- loops/specs/<feature>/spec.md
- loops/specs/<feature>/state.yaml
- docs/engineering/TECH_STACK.md
- docs/handoff/component-map.json (optional)

## Outputs
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/evidence.md
- loops/specs/<feature>/iterations.log

## Iron Rule
**No production code without a failing test.** A test that passes immediately = you are testing existing behavior, not new behavior.

## Process

### 1. Red (写失败测试)

**前置路由（吸收自 executing-plans）**：
- Read `loops/specs/<feature>/spec.md` 确认当前任务 T<N>
- Read `loops/specs/<feature>/state.yaml` 确认恢复位置
- Read `docs/engineering/TECH_STACK.md` 确认 test/lint/build 命令
- 任务路由判断：
  - 如果任务含 `Contract: component-map.json#<Component>` 行 → 先调 `frontend-implementation` 技能读 component-map.json 获取契约，再继续写测试
  - 如果任务是混合任务（同时含前端组件+后端逻辑）→ STOP，返回 writing-plans 拆分
  - 如果 `Contract:` 行存在但 component-map.json 缺失 → STOP，要求 harness-design 交付
  - 无 `Contract:` 行 → 直接写测试

**写测试**：
- 基于 spec.md 中的 AC-xxx 写失败测试
- 运行测试，确认失败
- 失败原因必须是"功能未实现"而非"测试本身有 bug"

### 2. Green (写最小实现)
- 写最小实现让测试通过
- 运行测试确认通过
- 不过度工程（YAGNI）
- 如果任务含 Contract: 行，实现需遵循 frontend-implementation 产出的结构/样式/状态指导

### 3. Refactor (重构 + 更新状态)
- 测试全绿下重构（可读性、消除重复，不加功能）
- 每次重构后运行测试确认无回归
- 更新 state.yaml: iteration +1, stage=act, status=running, last_error="" (成功) 或失败详情
- 追加 iterations.log（Read 当前内容 → 追加新行 → Write 回去）

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
