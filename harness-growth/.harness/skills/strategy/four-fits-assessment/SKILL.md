---
name: four-fits-assessment
description: Product-Channel-Model-Market Fit四维评估，诊断增长瓶颈根因
triggers:
  - 增长卡住不知哪里有问题时
  - 增长战略制定Workflow
  - 用户要求"评估增长可行性"
reads:
  - docs/operations/GROWTH_STRATEGY.md
  - docs/handoff/pm-to-growth.md
writes:
  - docs/operations/GROWTH_STRATEGY.md
quality_gates: []
max_iterations: 1
---

# Four Fits Assessment — 四维 Fit 评估

## 铁律
- 四种 Fit **相互耦合**——任一环断裂增长都会卡死
- 评估必须基于**数据/事实**，不是"感觉应该匹配"
- 不达标必须给出**修复方向**

## 流程

1. **Product-Market Fit（PMF）评估**
   - 产品是否满足某市场的核心需求？
   - Sean Ellis Test：用户"非常失望"比例 ≥ 40%？
   - 留存曲线是否趋于水平？
   - 评估: [达标/接近/不达标]

2. **Product-Channel Fit（PCF）评估**
   - 产品形态是否匹配某渠道的原生用户行为？
   - | 渠道 | 适配产品类型 | 我们是否匹配 |
     |------|-------------|-------------|
     | SEO/内容 | 有长尾需求、信息型产品 | ? |
     | 病毒传播 | 社交/协作、有分享属性 | ? |
     | 付费投放 | 有明确 LTV > CAC | ? |
     | 社媒 | 视觉型、有传播性 | ? |
   - 评估: [达标/接近/不达标]

3. **Channel-Model Fit（CMF）评估**
   - 渠道的 CAC 是否与商业模式的 LTV 匹配？
   - LTV/CAC ≥ 3？（健康标准）
   - CAC 是否在规模化后可控？
   - 评估: [达标/接近/不达标]

4. **Model-Market Fit（MMF）评估**
   - 商业模式（订阅/交易/广告）是否匹配目标市场的付费意愿？
   - 价格弹性是否合理？
   - ARPU 是否覆盖成本？
   - 评估: [达标/接近/不达标]

5. **综合评估**
   ```
   | Fit 类型 | 状态 | 瓶颈 | 修复方向 |
   |---------|------|------|---------|
   | PMF | ✅/⚠️/❌ | [如不达标的原因] | [修复方向] |
   | PCF | ✅/⚠️/❌ | | |
   | CMF | ✅/⚠️/❌ | | |
   | MMF | ✅/⚠️/❌ | | |
   ```

6. **产出修复建议**
   - 如 PMF 不达标：先打磨产品，不做增长投入
   - 如 PCF 不达标：调整产品形态适配渠道，或换渠道
   - 如 CMF 不达标：优化 CAC 或提升 LTV
   - 如 MMF 不达标：调整定价或商业模式

## 禁止事项
- 不在 PMF 不达标时做大规模获客（漏水桶）
- 不忽略任一 Fit（四种相互耦合）
- 不只评估不修复（评估的目的是行动）

## 与 LOOP 的关系
本 skill 不在 LOOP 内执行，是**战略级**评估。

## 与 Workflow 的关系
本 skill 是 **growth-strategy-workflow** 的第 5 步。
任一 Fit 不达标需回到 nsm-definition 重新审视。
