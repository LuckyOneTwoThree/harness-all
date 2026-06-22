---
name: onboarding-design
description: Onboarding流程设计，引导新用户在首日到达aha moment
triggers:
  - 新用户激活率低时
  - 用户运营Workflow
  - 用户要求"设计onboarding流程"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/onboarding-plan.md
quality_gates: []
max_iterations: 2
---

# Onboarding Design — Onboarding 流程设计

## 铁律
- Onboarding 的唯一目标是**引导用户到达 aha moment**
- 每一步必须**减少摩擦**，不是增加步骤
- 必须定义**激活指标**和**成功阈值**

## 流程

1. **识别 aha moment**
   - 用户第一次感受到核心价值的时刻是什么？
   - 如：Slack=首次在频道发消息，Airbnb=首次完成预订
   - 如无定义，先调用 aha-moment-identification skill

2. **设计 Onboarding 路径**
   ```
   注册 → [步骤1] → [步骤2] → ... → aha moment

   原则:
   - 步骤 ≤ 5 步（每多一步流失 +10-20%）
   - 每步有明确目标
   - 每步有进度指示
   - 可跳过非必要步骤
   ```

3. **设计每步细节**
   对每步定义：
   ```
   | 步骤 | 目标 | 用户动作 | 预期完成率 | 摩擦点 | 优化方向 |
   |------|------|---------|-----------|--------|---------|
   | 1.欢迎 | 设置预期 | 看介绍 | 95% | 无 | - |
   | 2.创建空间 | 核心动作 | 输入名称 | 70% | 命名困难 | 提供模板 |
   | 3.邀请成员 | 激活病毒 | 输入邮箱 | 40% | 怕打扰 | 强调价值 |
   | 4.首次使用 | aha | 完成首任务 | 60% | 不知做什么 | 引导+模板 |
   ```

4. **设计激活指标**
   ```
   激活定义: 用户在首日完成 [核心动作]
   激活阈值: [如"首日发消息 ≥ 1 条"]
   当前激活率: [如 35%]
   目标激活率: [如 50%]
   ```

5. **设计触发机制**
   - 用户卡在某步时如何触发？（邮件/push/弹窗）
   - 触发时机？（如"注册后 24h 未完成步骤 3"）
   - 触发内容？（针对性提醒，非通用推送）

6. **产出 Onboarding 方案**
   写入 `docs/operations/onboarding-plan.md`

## 禁止事项
- 不设计过多步骤（> 5 步流失率高）
- 不强制完成所有步骤（允许跳过非必要步骤）
- 不忽略 aha moment（onboarding 的目标就是到达 aha）
- 不做通用 onboarding（不同分群应有不同路径）

## 与 LOOP 的关系
本 skill 在 LOOP(lifecycle) 的 **PLAN 阶段**执行。

## 与 Workflow 的关系
本 skill 是 **lifecycle-operations-workflow** 的第 2 步。
