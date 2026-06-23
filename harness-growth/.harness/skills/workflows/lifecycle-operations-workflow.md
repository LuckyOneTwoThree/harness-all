---
workflow_id: E
name: lifecycle-operations-workflow
default_mode: standard
---

# Workflow: 用户运营全流程（Lifecycle Operations Workflow）

> 所属 LOOP 类型：lifecycle / optimization
> 触发场景：生命周期运营持续进行、留存优化专项
> 编排 Skill：user-segmentation → onboarding-design → aha-moment-identification → retention-analysis → churn-rescue

## 流程图

```
┌─────────────────────┐
│ user-segmentation    │  用户分群（RFM/生命周期/价值）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ onboarding-design    │  Onboarding 流程设计
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ aha-moment-identify  │  Aha Moment 识别与验证
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ retention-analysis   │  留存曲线分析（Cohort/RBM）
│    [度量门]          │
└─────────┬───────────┘
          │ 留存不达标
          ▼
┌─────────────────────┐
│ churn-rescue         │  流失预警 + 召回 campaign
└─────────────────────┘
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| retention-analysis 后 | 留存曲线是否趋于水平 | 不趋于水平→进入 churn-rescue |
| churn-rescue 前 | 召回成本 ≤ LTV/3 | 成本超标→调整召回策略 |

## 数据流

| 阶段 | 产出 | 存储位置 |
|------|------|---------|
| user-segmentation | 分群定义 | docs/operations/segments.md + knowledge-base.md |
| onboarding-design | Onboarding 方案 | docs/operations/onboarding-plan.md |
| aha-moment-identification | Aha Moment 定义 | docs/operations/aha-moment.md + knowledge-base.md |
| retention-analysis | 留存报告 | docs/operations/retention-analysis.md |
| churn-rescue | 召回方案 | docs/operations/churn-rescue-plan.md + knowledge-base.md |

## 与 LOOP 的交互

```
LOOP(lifecycle):
  PLAN:       user-segmentation → onboarding-design → aha-moment-identification
  EXPERIMENT: [上线 onboarding/触达]
  MEASURE:    retention-analysis → churn-rescue
  通过? DONE : 回到 PLAN(调整分群/onboarding)
```

## 反馈闭环

retention-analysis 和 churn-rescue 的产出反馈到 user-segmentation：
- 留存改善的分群 → 总结成功模式
- 流失严重的分群 → 调整分群规则或运营策略
- 召回效果 → 更新分群库的触达策略

## 使用方式

对 Agent 说：
- "分析用户分群" → 从 user-segmentation 开始
- "设计 onboarding" → 从 onboarding-design 开始
- "找 aha moment" → 从 aha-moment-identification 开始
- "分析留存" → 从 retention-analysis 开始
- "设计召回策略" → 从 churn-rescue 开始
