---
name: nsm-definition
description: 北极星指标定义与选择，指导全公司增长目标对齐
triggers:
  - 新项目/新产品需要定义增长指标时
  - 增长战略制定Workflow
  - 用户要求"定义北极星指标"
reads:
  - docs/handoff/pm-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/GROWTH_STRATEGY.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# NSM Definition — 北极星指标定义

## 铁律
- NSM 必须反映**用户获得的核心价值**，不是商业收入
- NSM 必须是**领先指标**（leading indicator），不是滞后指标
- NSM 必须可被**拆解为可操作的输入指标**
- 全公司只聚焦**一个** NSM

## 流程

1. **理解产品核心价值**
   - 读取 `docs/handoff/pm-to-growth.md`（如有）获取产品定位和目标受众
   - 回答：产品为用户创造的核心价值是什么？
   - 回答：用户使用产品的"aha moment"是什么？

2. **NSM 候选清单**
   基于产品类型生成候选 NSM：

   | 产品类型 | NSM 方向 | 经典案例 |
   |---------|---------|---------|
   | 社交/内容 | 时间 spent / 内容消费量 | Spotify=收听时长, Netflix=观看时长 |
   | SaaS/工具 | 核心动作完成数 | Slack=日活发送消息团队数 |
   | 电商/交易 | 交易量 | Airbnb=预订夜数 |
   | 市场/平台 | 双边匹配量 | Uber=每周完成行程数 |
   | 媒体/广告 | UV/PV | Facebook=DAU |
   | 订阅/SaaS | 付费用户活跃度 | 付费用户 MAU |

3. **NSM 选择标准评估**
   对每个候选 NSM 评估：

   | 标准 | 说明 | 权重 |
   |------|------|------|
   | 反映核心价值 | NSM 是否量化了用户获得的价值？ | 高 |
   | 领先指标 | NSM 变化是否先于收入变化？ | 高 |
   | 可拆解 | NSM 能否拆解为可实验的输入指标？ | 高 |
   | 可度量 | NSM 是否可准确测量？ | 中 |
   | 跨部门共识 | 全公司是否理解并认同？ | 中 |

4. **确定 NSM**
   选择评分最高的候选，定义：
   ```
   北极星指标: [指标名称]
   定义: [精确计算公式]
   当前值: [如有数据]
   目标值: [本阶段目标]
   度量周期: [日/周/月]
   ```

5. **写入增长战略文档**
   更新 `docs/operations/GROWTH_STRATEGY.md` 的"北极星指标"章节

## 禁止事项
- 不选收入类指标作为 NSM（收入是结果，不是用户价值）
- 不选虚荣指标（如注册数——注册不等于价值实现）
- 不选无法拆解的指标（无法实验=无法增长）
- 不选多个 NSM（聚焦一个才能对齐）

## 与 LOOP 的关系
本 skill 不在 LOOP 内执行，是**战略级**定义。
通常在增长战略制定 Workflow 中执行。

## 与 Workflow 的关系
本 skill 是 **growth-strategy-workflow** 的第 1 步。
