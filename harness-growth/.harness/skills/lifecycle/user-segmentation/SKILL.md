---
name: user-segmentation
description: 用户分群（RFM/生命周期/价值分层），Segment作为一等公民可被复用
triggers:
  - 需要差异化运营用户时
  - 用户运营Workflow
  - 用户要求"给用户分群"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/segments.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# User Segmentation — 用户分群

## 铁律
- 分群必须**可操作**——能据此差异化运营，否则无意义
- Segment 是**一等公民**——写入知识库，可被触达/实验/看板复用
- 分群维度必须基于**行为数据**，不只是人口属性

## 流程

1. **确定分群目标**
   - 是为了差异化触达？还是为了实验定向？还是为了分析？
   - 不同目标对应不同分群方法

2. **选择分群方法**

   ### RFM 分群（适合电商/交易型）
   | 维度 | 含义 | 分值 |
   |------|------|------|
   | Recency | 最近一次购买距今多久 | 越近越高 |
   | Frequency | 购买频次 | 越高越高 |
   | Monetary | 消费金额 | 越高越高 |

   ### 生命周期分群（适合 SaaS/工具型）
   | 阶段 | 定义 | 运营目标 |
   |------|------|---------|
   | 新用户 | 注册 < 7 天 | 激活 |
   | 活跃用户 | 7 天内有核心动作 | 留存+习惯 |
   | 沉默用户 | 7-30 天无活跃 | 唤醒 |
   | 流失用户 | 30+ 天无活跃 | 召回 |

   ### 价值分层（适合订阅/SaaS）
   | 层级 | 定义 | 运营目标 |
   |------|------|---------|
   | 高价值 | Top 10% LTV | 保留+Upsell |
   | 中价值 | 10-50% LTV | 提升价值 |
   | 低价值 | Bottom 50% | 激活或放弃 |

3. **定义分群规则**
   每个分群必须有**明确的规则**（可查询/可计算）：
   ```
   分群ID: S-001
   名称: 高频活跃用户
   规则: 7天内核心动作 ≥ 5次 AND 注册 > 30天
   规模: 1,200 (15%)
   留存: 85%
   LTV: ¥450
   运营策略: 习惯强化 + Upsell
   ```

4. **写入分群库**
   将分群定义写入 `docs/operations/segments.md`
   同步到 `memory/knowledge-base.md` 的"用户分群库"

5. **分群可操作性检查**
   - 每个分群是否有明确的运营策略？
   - 分群之间是否互斥？（用户不应同时属于多个互斥分群）
   - 分群是否可动态更新？（用户行为变化后自动迁移）

## 禁止事项
- 不做无操作性的分群（如"男性用户"——然后呢？）
- 不做过于细碎的分群（每个分群 < 100 人无统计意义）
- 不做静态分群（用户行为变化后不更新=分群失效）

## 与 LOOP 的关系
本 skill 在 LOOP(lifecycle/optimization) 的 **PLAN 阶段**执行。

## 与 Workflow 的关系
本 skill 是 **lifecycle-operations-workflow** 的第 1 步。
分群可被 onboarding-design / churn-rescue / experiment-design 复用。
