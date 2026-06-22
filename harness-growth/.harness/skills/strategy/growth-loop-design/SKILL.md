---
name: growth-loop-design
description: Growth Loops识别与设计，构建自我强化的增长闭环
triggers:
  - 需要设计可持续增长引擎时
  - 增长战略制定Workflow
  - 用户要求"设计增长循环"
reads:
  - docs/operations/GROWTH_STRATEGY.md
  - memory/knowledge-base.md
writes:
  - docs/operations/GROWTH_STRATEGY.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# Growth Loop Design — 增长循环设计

## 铁律
- Loop 的输出必须能**反哺输入**，形成复利
- 必须量化 Loop 的**转化效率**和**容量**
- 一个产品可以有多个 Loop，但需识别**主导 Loop**

## 流程

1. **识别现有 Loop**
   分析产品中已存在的增长循环：
   - 用户使用产品 → 产出内容 → 内容吸引新用户？（UGC Loop）
   - 用户使用产品 → 邀请他人 → 新用户加入？（病毒 Loop）
   - 收入 → 投放预算 → 新用户 → 更多收入？（付费 Loop）
   - 生产 SEO 内容 → 搜索流量 → 用户 → 数据反哺内容？（SEO Loop）

2. **Loop 三要素分析**
   对每个 Loop 分析：
   ```
   Input（输入）: [新用户/内容/收入]
   Action（行动）: [用户做什么产生价值]
   Output（输出）: [产出什么反哺输入]
   转化效率: [Output/Input 的比率]
   复利系数: [每轮循环的放大倍数]
   ```

3. **Loop 健康度评估**
   | 维度 | 健康 | 不健康 |
   |------|------|--------|
   | 转化效率 | Output > Input | Output < Input |
   | 容量 | 有增长空间 | 已饱和 |
   | 延迟 | 短（天/周级） | 长（月/年级） |
   | 可控性 | 可优化转化率 | 依赖外部因素 |

4. **设计新 Loop**（如现有 Loop 不足）
   ```
   新 Loop 设计:
   - 触发: 用户完成什么行为触发 Loop？
   - 行动: 用户做什么产生价值？
   - 奖励: 用户为什么愿意参与？
   - 反哺: 产出如何成为下一轮输入？
   - 量化: 如何度量 Loop 效率？
   ```

5. **Loop 优先级**
   | Loop 类型 | 适用场景 | 见效周期 |
   |---------|---------|---------|
   | UGC 内容 Loop | 内容型产品 | 中（月级） |
   | 病毒 Loop | 社交/协作产品 | 快（周级） |
   | 付费 Loop | 有变现能力的产品 | 快（立即可控） |
   | SEO 内容 Loop | 有搜索需求的产品 | 慢（3-6 月） |

6. **写入增长战略文档**
   更新 `docs/operations/GROWTH_STRATEGY.md` 的"增长循环"章节

## 禁止事项
- 不设计无法量化的 Loop（无法度量=无法优化）
- 不设计依赖单一渠道的 Loop（渠道风险）
- 不忽略 Loop 的延迟（SEO Loop 见效慢，不能等）

## 与 LOOP 的关系
本 skill 不在 LOOP 内执行，是**战略级**设计。

## 与 Workflow 的关系
本 skill 是 **growth-strategy-workflow** 的第 4 步。
