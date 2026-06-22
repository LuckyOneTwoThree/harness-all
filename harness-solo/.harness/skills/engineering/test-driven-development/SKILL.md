---
name: test-driven-development
description: 测试驱动开发，红→绿→重构
triggers:
  - 写新功能代码前
  - 修改现有功能前
  - Bug 修复写复现测试时
reads:
  - rules/security.md
  - loops/LOOP.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/evidence.md
  - loops/specs/<feature>/iterations.log
---

# Test-Driven Development — TDD

## 铁律
**没有失败测试，不准写生产代码。** 测试立刻通过 = 你在测已有行为，不是新行为。

## 流程

### 红（Red）
1. 根据 spec.md 的验收标准，写一个失败的测试
2. 运行测试，**确认它失败**（不是"应该失败"，而是实际看到 FAIL）
3. 失败原因必须是"功能未实现"，不是"测试本身有 bug"

### 绿（Green）
1. 写**最小的**实现让测试通过
2. 运行测试，确认通过
3. 不许过度设计——能过就行，重构留到下一步

### 重构（Refactor）
1. 在测试全绿的前提下重构代码
2. 每次重构后立即跑测试，确认不回归
3. 重构目标：可读性、消除重复，不是加功能

## 每次迭代的状态维护

完成一次红→绿→重构后，按 `loops/LOOP.md` 的 "state.yaml Schema" 更新 state.yaml：
- `iteration`: +1
- `stage`: `act`
- `status`: `running`
- `last_error`: 成功则清空为 ""

如失败，更新：
- `stage`: `verify`（即将进入验证但失败）
- `last_error`: `"test_xxx FAILED: <错误信息>"`
- `status`: `retrying`

字段完整定义和写入责任见 LOOP.md 的 "字段写入责任" 表。

**更新 iterations.log（必须追加，禁止覆盖）**：
- 工具方式：先 Read 当前 iterations.log → 拼接新行 → Write 回去
- 或终端命令：`echo "[YYYY-MM-DD HH:MM] iter=<N> stage=act → verify FAILED: <测试名>" >> .harness/loops/specs/<feature>/iterations.log`
- 禁止用 Write 直接覆盖 iterations.log（会抹掉历史迭代记录）

追加格式：
```
[YYYY-MM-DD HH:MM] iter=<N> stage=act → verify FAILED: <测试名>
```

## 禁止事项
- 先写代码再补测试（本末倒置）
- 测试写完不跑就说"应该过了"（必须看到实际输出）
- 一次写多个测试再实现（违反小步迭代）
- 绿阶段过度设计（YAGNI）
- 重构时加新功能（职责混淆）

## 与 LOOP 的关系
本 skill 对应 LOOP 的 ACT 阶段。
- 红 = 写测试（ACT 的输入）
- 绿 = 写实现（ACT 的执行）
- 重构 = ACT 的优化
- 完成后进入 VERIFY（由 verify skill 接手）

## 证据要求
测试通过后，将实际输出写入 evidence.md：
```
## 测试结果
$ <测试命令>
<实际输出，包含通过数>

## 验收标准
- AC-001: ✓ <如何满足>
- AC-002: ✓ <如何满足>
```
