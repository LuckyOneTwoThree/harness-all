# Workflow: 增长回顾报告（Growth Review Workflow）

> 所属 LOOP 类型：无（非循环，周期性报告）
> 触发场景：周会/月会/季度回顾、session-end 检测到结题实验
> 编排 Skill：funnel-analysis + cohort-analysis + metric-anomaly-detection → aarr-diagnosis → growth-review

## 流程图

```
┌─────────────────────────────────────────┐
│ 并行执行数据分析（如有数据）              │
│  ├── funnel-analysis      漏斗分析       │
│  ├── cohort-analysis      同期群分析     │
│  └── metric-anomaly-detection 指标异常   │
└───────────────────┬─────────────────────┘
                    ▼
          ┌─────────────────────┐
          │ aarr-diagnosis       │  AARRR 漏斗诊断
          └─────────┬───────────┘
                    ▼
          ┌─────────────────────┐
          │ growth-review        │  汇总报告 + 产出 growth-to-pm.md
          └─────────────────────┘
```

## 说明

- 数据分析 skill（funnel-analysis / cohort-analysis / metric-anomaly-detection）在第 3 批建设
- 在第 3 批完成前，growth-review 直接从 knowledge-base.md 和 evidence.md 读取已有数据
- aarr-diagnosis 在第 3 批建设，当前由 growth-review 内联处理 AARRR 诊断

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| growth-review 产出前 | 数据完整（至少有本周期实验记录） | 标注"数据不足，报告为定性总结" |
| growth-to-pm.md 产出前 | 字段完整（实验结果/建议/异动） | 补充缺失字段 |

## 数据流

| 阶段 | 产出 | 存储位置 |
|------|------|---------|
| 数据分析（并行） | 漏斗/Cohort/异常报告 | evidence.md（如有对应实验） |
| aarr-diagnosis | AARRR 薄弱环节 | 报告内联 |
| growth-review | 增长回顾报告 + growth-to-pm.md | docs/handoff/growth-to-pm.md + knowledge-base.md |

## 使用方式

对 Agent 说：
- "生成本月增长回顾" → 触发本 workflow
- "准备交接给 PM" → 触发 growth-review 产出 growth-to-pm.md
- session-end 自动触发（如有结题实验）
