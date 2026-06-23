---
workflow_id: B
name: growth-experiment-workflow
default_mode: standard
---

# Workflow: 增长实验全流程（Growth Experiment Workflow）

> 所属 LOOP 类型：experiment
> 触发场景：每周实验周期、新假设需要验证时
> 编排 Skill：hypothesis-generation → ice-scoring → experiment-design → sample-size-calc → [执行] → experiment-analysis → experiment-conclusion

## 流程图

```
┌─────────────────────┐
│ hypothesis-generation│  生成可证伪假设
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ ice-scoring          │  ICE/RICE 评分排序
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ experiment-design    │  设计实验方案（变量/指标/护栏/受众）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ sample-size-calc     │  计算样本量与实验时长
└─────────┬───────────┘
          ▼
   [实验执行，外部]
   （工程团队上线实验，等待数据收集）
          ▼
┌─────────────────────┐
│ experiment-analysis  │  统计分析（显著性/SRM/分群）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ experiment-conclusion│  结论+决策+知识库沉淀
└─────────────────────┘
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| hypothesis-generation 后 | 假设可证伪 + 查重 | 重写假设 |
| experiment-design 后 | 主指标唯一 + 护栏完整 + 兜底方案 | 补充设计 |
| sample-size-calc 后 | 样本量可行 + 时长≥7天 | 调整 MDE 或拆分实验 |
| experiment-analysis 后 | SRM 未触发 + 样本充足 | 如 SRM 触发，重做实验 |

## 数据流

| 阶段 | 产出 | 存储位置 |
|------|------|---------|
| hypothesis-generation | 假设清单 | spec.md + knowledge-base.md |
| ice-scoring | 排序表 | spec.md |
| experiment-design | 实验方案 + state.yaml | spec.md + state.yaml |
| sample-size-calc | 样本量计算结果 | spec.md |
| experiment-analysis | 证据报告 | evidence.md + iterations.log |
| experiment-conclusion | 结论+决策+知识库条目 | evidence.md + knowledge-base.md + growth-to-pm.md |

## 与 LOOP 的交互

```
LOOP(experiment):
  PLAN:   hypothesis-generation → ice-scoring → experiment-design → sample-size-calc
  EXPERIMENT: [外部执行]
  MEASURE: experiment-analysis → experiment-conclusion
  通过? DONE : 回到 PLAN(新假设) / EXPERIMENT(调整方案)
```

## 使用方式

对 Agent 说：
- "开始一个增长实验" → 触发本 workflow
- "验证这个假设：如果...那么..." → 从 hypothesis-generation 开始
- "实验数据出来了，分析一下" → 从 experiment-analysis 开始
