---
name: aha-moment-identification
description: Aha Moment识别与验证，通过行为-留存相关性分析找到核心行为
triggers:
  - 不清楚用户aha moment是什么时
  - 用户运营Workflow
  - 用户要求"找aha moment"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/aha-moment.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# Aha Moment Identification — Aha Moment 识别

## 铁律
- Aha moment 必须用**数据验证**，不是"我觉得用户会喜欢这个"
- 必须验证**行为-留存相关性**——做了该行为的用户留存显著更高
- Aha moment 必须是**具体行为**，不是模糊感受

## 流程

1. **候选行为清单**
   基于产品功能列出可能的 aha moment 候选：
   ```
   | 候选行为 | 描述 | 触发时机 |
   |---------|------|---------|
   | 首次发消息 | 用户在频道/群发送第一条消息 | 注册后 |
   | 首次创建项目 | 用户创建第一个项目 | 注册后 |
   | 首次邀请成员 | 用户邀请第一个协作者 | 注册后 |
   | 首次完成交易 | 用户完成第一次购买/预订 | 注册后 |
   ```

2. **行为-留存相关性分析**
   对每个候选行为分析：
   ```
   | 行为 | 做了该行为的用户 | 没做的用户 | 留存差异 | 相关性 |
   |------|----------------|-----------|---------|--------|
   | 首次发消息 | 7日留存 65% | 7日留存 15% | +50% | 强 |
   | 首次创建项目 | 7日留存 55% | 7日留存 20% | +35% | 中 |
   | 首次邀请 | 7日留存 80% | 7日留存 25% | +55% | 强 |
   ```

3. **时间窗口分析**
   - aha moment 应在**首日/首周**发生
   - 如行为在 7 天后才发生，不是 aha moment（太晚了）
   - 分析：做了该行为的用户中，多少在首日完成？

4. **因果性验证**
   - 是"做了该行为→留存高"还是"留存高的用户→更可能做该行为"？
   - 用时间序列验证：行为发生在前，留存提升在后
   - 如无法确定因果，设计 A/B 测试验证

5. **确定 Aha Moment**
   选择留存差异最大 + 首日完成率最高的行为：
   ```
   Aha Moment: [行为描述]
   定义: 用户在首日 [完成某行为]
   验证: 做了该行为的用户 7 日留存 X%，未做 Y%（差异 Z%）
   当前达标率: [如 35% 的首日用户完成该行为]
   目标达标率: [如 50%]
   ```

6. **写入文档和知识库**
   - 写入 `docs/operations/aha-moment.md`
   - 同步到 `memory/knowledge-base.md` 的"增长模式沉淀"

## 禁止事项
- 不用直觉代替数据验证
- 不选留存差异小的行为（< 10% 差异可能是噪声）
- 不忽略时间窗口（太晚发生的行为不是 aha moment）
- 不混淆相关与因果

## 与 LOOP 的关系
本 skill 在 LOOP(lifecycle) 的 **PLAN 阶段**执行。

## 与 Workflow 的关系
本 skill 是 **lifecycle-operations-workflow** 的第 3 步。
产出供 onboarding-design 参考设计引导路径。
