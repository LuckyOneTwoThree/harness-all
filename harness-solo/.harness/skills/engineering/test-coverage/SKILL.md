---
name: test-coverage
description: 测试补强，覆盖率缺口分析+补边界/集成/E2E
triggers:
  - 现有代码缺乏测试时
  - 覆盖率下降时
  - 重构前补测试（Beyonce Rule）
  - Bug 修复后补回归测试
reads:
  - loops/LOOP.md
  - rules/security.md
  - docs/engineering/TECH_STACK.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/evidence.md
  - loops/specs/<feature>/iterations.log
---

# Test Coverage — 测试补强

## 铁律
**Tests are proof.** "Seems right" is not done. 没有测试的代码，重构/迁移出问题不是重构的错——是你的测试缺失的错（Beyonce Rule）。

## 与 tdd skill 的分工

| Skill | 场景 | 时机 |
|-------|------|------|
| **tdd** | 写**新功能**代码 | 红→绿→重构，测试先行 |
| **test-coverage** | 给**现有代码**补测试 | 代码已存在但缺测试，或覆盖率有缺口 |

本 skill 不写新功能代码，只补测试守护现有行为。

## 流程

### 1. 覆盖率缺口分析

**1.1 运行覆盖率工具**（读 `docs/engineering/TECH_STACK.md` 确认命令）：
```bash
# Node
npm test -- --coverage
# Python
pytest --cov=src --cov-report=term-missing
```
展示完整输出，记录当前覆盖率。

**1.2 识别缺口**：
- 未覆盖的文件/函数/分支（覆盖率报告标红的部分）
- 关键路径优先：核心业务逻辑 > 辅助函数 > 边界工具
- 风险优先：最近改过的高频文件、有 Bug 历史的模块

**1.3 分类缺口**：

| 缺口类型 | 优先级 | 测试类型 |
|---------|--------|---------|
| 核心逻辑无测试 | P0 | unit |
| 边界条件未覆盖 | P0 | unit |
| API 对接未测试 | P1 | integration |
| 关键用户流程未测试 | P1 | E2E（如有基础设施） |
| 错误路径未覆盖 | P1 | unit |

### 2. 补测试（按测试金字塔）

**测试金字塔 80/15/5**：
- 80% unit（毫秒级，无 I/O，纯逻辑）
- 15% integration（秒级，localhost，跨边界）
- 5% E2E（分钟级，真实浏览器，仅关键路径）

**2.1 Unit 测试**（优先补）：
- 纯逻辑函数：测输入输出
- 边界条件：空值 / 极值 / 负数 / 超长字符串
- 错误路径：异常输入应抛预期异常

**2.2 Integration 测试**：
- API 对接：请求→响应正确
- DB 交互：CRUD 正确性
- 跨模块协作：数据流转正确

**2.3 E2E 测试**（仅关键路径，需用户审批引入框架）：
- 核心用户流程：登录→操作→结果
- 不在本 skill 强制范围（遵守 constitution 零新依赖原则）

### 3. 测试质量规则

**3.1 Test state, not interactions**
- 断言**结果**，不断言"调用了哪个方法"
- 反例：`expect(mockFn).toHaveBeenCalledWith(args)` ← 重构就崩
- 正例：`expect(result).toEqual(expectedResult)` ← 行为稳定

**3.2 DAMP over DRY**
- 测试要像规格说明，每个测试自包含可读
- 允许重复以避免共享 setup 遮蔽意图
- 共享 setup 只用于真正重复的样板（如创建测试上下文）

**3.3 Real implementation > Fake > Stub > Mock**
- 优先用真实实现（最可信）
- mock 只在真实实现太慢/非确定/有不可控副作用时用
- 过度 mock 导致"测试绿但生产崩"

**3.4 Arrange-Act-Assert + 一测试一概念**
- 每个测试只验证一个行为
- 命名描述行为：`it('sets status to completed and records timestamp')` 而非 `it('works')`

### 4. 验证

- 跑全量测试，确认新测试全绿 + 无回归
- 对比覆盖率：before → after，展示提升数字
  ```
  ## 覆盖率对比
  | 指标 | Before | After |
  |------|--------|-------|
  | Lines | 62% | 85% |
  | Branches | 48% | 78% |
  ```
- 新测试不能是空壳（断言要有意义，不是 `expect(true).toBe(true)`）

## Bug 修复后补回归测试

Bug 修复（走 bugfix workflow）后，**必须**补回归测试：
1. Bug 的复现测试已有（systematic-debugging 产出）
2. 检查同类问题：同样的根因可能在别处 → 补测试
3. 回归测试纳入套件，防止 Bug 复发

## 反合理化表

| 借口 | 反驳 |
|------|------|
| "这太简单不用测" | 简单代码会变复杂，测试是行为规格 |
| "我会代码工作后再写测试" | 你不会，且事后测试测的是实现不是行为 |
| "测过了应该没问题" | "应该"不是证据，跑测试看输出 |
| "mock 一下就过了" | 过度 mock = 测试绿但生产崩 |
| "跳过这个测试让套件通过" | 跳过 = 没测，标记 tech debt 并记录 |

## 状态维护

按 LOOP.md 的 "state.yaml Schema" 更新：
- `stage`: `act`（补测试中）
- `iteration`: +1（每补一批测试）
- `last_error`: 失败时填"测试失败：<测试名>"

**更新 iterations.log（追加，禁止覆盖）**：
```
[YYYY-MM-DD HH:MM] iter=<N> stage=act → added 5 unit tests for <模块>
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → coverage 62%→85% ✓
```

## 禁止事项
- 测试实现细节而非行为（重构即崩）
- 一个测试验证多个概念（失败时不知道哪个断了）
- mock 一切（测试绿但生产崩）
- 跳过测试让套件通过（标记 tech debt，不静默跳过）
- snapshot 滥用（快照不是断言，是"看起来一样"）
- flaky tests（时序/顺序依赖，必须修复或删除）

## 与 LOOP 的关系
本 skill 可在 LOOP 内或外触发：
- **LOOP 内**：refactor/migration 前补测试守护 → 本 skill 作为 PLAN 阶段的前置
- **LOOP 外**：独立补测试任务 → 直接走本 skill 流程

## 与其他 skill 的分工
| Skill | 职责 |
|-------|------|
| test-coverage | 给现有代码补测试 |
| tdd | 新功能红绿重构（测试先行） |
| systematic-debugging | Bug 复现测试（本 skill 补同类回归测试） |
| verify | 覆盖率检查作为验证子项 |
| migration | 迁移前调用本 skill 补测试守护 |
