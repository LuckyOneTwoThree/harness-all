---
name: experiment-design
description: 设计实验方案，含变量/对照/主指标/护栏指标/受众/分流比例
triggers:
  - 假设已通过ICE排序，需要设计实验方案时
  - 增长实验Loop的PLAN阶段，ice-scoring之后
reads:
  - loops/specs/<experiment>/spec.md
  - loops/LOOP.md
  - rules/security.md
writes:
  - loops/specs/<experiment>/spec.md
  - loops/specs/<experiment>/state.yaml
quality_gates: []
max_iterations: 3
---

# Experiment Design — 实验设计

## 铁律
- 每个实验必须有且只有一个**主指标**——多主指标会导致结论混乱
- 必须设置**护栏指标**——防止实验副作用（如提升转化但损害留存）
- 必须定义**证伪条件**——什么结果会推翻假设
- 破坏性实验（可能降低核心指标）必须有人工兜底方案

## 流程

1. **确认实验假设**
   从 spec.md 读取 ICE 排序第一的假设，确认：
   - 假设陈述（如果X，那么Y，因为Z）
   - 主指标（假设要影响的指标）
   - 护栏指标（需监控的副作用指标）

2. **设计变量与对照**
   - **对照组（Control）**：当前版本（status quo）
   - **实验组（Variant）**：应用假设的改动
   - 明确改动内容：UI/逻辑/文案/流程/算法
   - 如有多变量，拆为多个实验（避免混杂变量）

3. **定义指标体系**
   ```
   主指标（Primary Metric）:
     - 名称: [如"注册转化率"]
     - 定义: [完成注册的用户数/访问注册页的用户数]
     - 基线值: [当前值，如 35%]
     - 目标值: [期望值，如 40%]
     - 最小可检测效应(MDE): [如 3%]

   护栏指标（Guardrail Metrics）:
     - [指标1]: [如"次日留存率"，阈值: 不低于基线-1%]
     - [指标2]: [如"页面加载时间"，阈值: 不超过基线+200ms]
     - [指标3]: [如"退订率"，阈值: 不超过基线+0.5%]

   辅助指标（Secondary Metrics，可选）:
     - [用于深度分析的分群指标]
   ```

4. **确定受众与分流**
   - **受众定义**：实验影响哪些用户（全部/新用户/某分群）
   - **分流比例**：对照组 50% / 实验组 50%（标准），或小流量先试（如 5%）
   - **分层策略**：如需按用户分层（设备/地区/新老），声明分层维度
   - **互斥规则**：与在跑实验是否互斥

5. **调用 sample-size-calc**
   基于主指标的基线值、MDE、显著性水平、统计功效，计算所需样本量和实验时长。
   将计算结果写入 spec.md。

6. **设计实验时间线**
   ```
   实验开始: [日期]
   预计结束: [开始日期 + 实验时长]
   最短运行周期: [如 7 天，避免周期性偏差]
   决策检查点: [如达到样本量后第 3 天检查显著性]
   ```

7. **设计兜底方案**（破坏性实验必填）
   - 什么情况立即停止实验（如护栏指标触发红线）
   - 实验失败后的回滚方案
   - 实验期间的监控频率

8. **写入 spec.md**
   将完整实验方案写入 spec.md 的"实验设计"章节

9. **初始化 state.yaml**
   创建 `loops/specs/<experiment>/state.yaml`：
   ```yaml
   current_task: <NNN>-<experiment-name>
   iteration: 0
   stage: plan
   status: running
   started_at: "<ISO 8601>"
   last_error: ""
   substage: "experiment-design"
   ```

## 实验设计质量检查

- [ ] 主指标是否唯一且可量化？
- [ ] 护栏指标是否覆盖主要副作用风险？
- [ ] MDE 是否现实？（过小导致需要巨量样本，过大致使漏掉真实效应）
- [ ] 分流是否随机且无偏？（避免 SRM）
- [ ] 实验时长是否覆盖完整周期？（至少 7 天，避免周末/工作日偏差）
- [ ] 破坏性实验是否有兜底方案？

## 禁止事项
- 不设计多主指标实验（结论会混乱）
- 不省略护栏指标（可能放大数据副作用）
- 不设计过短的实验（少于 7 天，周期性偏差大）
- 不设计无兜底的破坏性实验（风险不可控）

## 与 LOOP 的关系
本 skill 在 LOOP 的 **PLAN 阶段**执行，是 PLAN 的最后一步。
PLAN(hypothesis-generation → ice-scoring → experiment-design) → EXPERIMENT → MEASURE

## 与 Workflow 的关系
本 skill 是 **growth-experiment-workflow** 的第 3 步。
完成后进入 EXPERIMENT 阶段（实验执行，通常由工程/外部完成）。
