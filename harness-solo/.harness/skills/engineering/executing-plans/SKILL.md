---
name: executing-plans
description: 执行 writing-plans 产出的 spec.md，按任务序列推进，带 checkpoint
triggers:
  - writing-plans 完成后
  - spec.md 已就绪，准备开始编码时
  - 用户说"开始执行"/"go"/"动手"时
reads:
  - loops/LOOP.md
  - loops/specs/<feature>/spec.md
  - loops/specs/<feature>/state.yaml
  - docs/engineering/TECH_STACK.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/iterations.log
---

# Executing Plans — 计划执行

## 铁律
**按 spec.md 的任务序列推进，每个任务完成后必须 checkpoint。** 不许跳任务、不许批量改多个任务再验证。

## 流程

1. **加载 spec.md**
   - 读 `loops/specs/<feature>/spec.md`，确认任务列表（T1, T2, T3...）
   - 读 `loops/specs/<feature>/state.yaml`，确认从哪个任务继续（断点续传）
   - 读 `docs/engineering/TECH_STACK.md`，确认测试/lint/构建命令

2. **逐任务执行**（每个任务走一遍小循环）

   对 spec.md 中的每个任务 T<N>：

   **2.1 进入 ACT（交给 tdd skill）**
   - 调用 `test-driven-development` skill：红（写失败测试）→ 绿（最小实现）→ 重构
   - 按 LOOP.md 的 "state.yaml Schema" 更新：
     - `iteration`: +1
     - `stage`: `act`
     - `status`: `running`

   **2.2 进入 VERIFY（交给 verify skill）**
   - 调用 `verify` skill：跑测试 + 对照 AC + 宪法 + 安全
   - 更新 state.yaml：`stage`: `verify`

   **2.3 Checkpoint（人工确认点）**
   - 向用户报告本任务完成情况：
     ```
     ✅ T<N> 完成
     - 改动文件：[列表]
     - 测试：[通过数/总数]
     - AC 进度：AC-xxx ✓
     ```
   - 询问用户："T<N> 完成，是否继续 T<N+1>？"
   - 用户确认 → 继续下一个任务
   - 用户要求调整 → 回到 writing-plans 修改 spec.md

3. **失败处理**
   - verify 失败 → 调用 `systematic-debugging` 找根因 → 回到 2.1 重做
   - 迭代超限（见 LOOP.md 循环类型表）→ 停止，请求人类介入

4. **全部任务完成**
   - 所有 T<N> 完成 + 所有 AC ✓ → 退出本 skill
   - 进入 `requesting-code-review` skill 做最终审查

## Checkpoint 策略

| 场景 | 策略 |
|------|------|
| 任务粒度小（2-5 分钟） | 每个任务都 checkpoint，让用户掌控节奏 |
| 用户说"批量执行" | 可连续执行 2-3 个任务后统一 checkpoint，但 verify 失败必须立即停 |
| 用户离开（autonomous） | 连续执行直到 verify 失败或全部完成，checkpoint 记录到 iterations.log |

## 与其他 skill 的分工

| Skill | 职责 | 时机 |
|-------|------|------|
| writing-plans | 写 spec.md（任务拆解） | PLAN 阶段 |
| **executing-plans** | 调度任务执行（本 skill） | ACT+VERIFY 调度 |
| test-driven-development | 单个任务的红绿重构 | ACT 阶段 |
| verify | 单个任务的综合验证 | VERIFY 阶段 |
| systematic-debugging | 失败时找根因 | VERIFY 失败时 |

## 禁止事项
- 跳过 checkpoint 连续改多个任务（失控风险）
- 不读 state.yaml 就开始（可能重复已完成任务）
- verify 失败还继续下一个任务（错误累积）
- 任务粒度超过 5 分钟还不拆（spec.md 拆解不到位，回 writing-plans）

## 与 LOOP 的关系
本 skill 是 LOOP 循环的**调度器**，本身不写代码：
- executing-plans 调度 → tdd 执行 ACT → verify 执行 VERIFY → 失败回 systematic-debugging
- 一个 spec.md 的所有任务完成 = LOOP 结束
