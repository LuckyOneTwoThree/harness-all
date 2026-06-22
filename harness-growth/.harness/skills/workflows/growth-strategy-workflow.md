# Workflow: 增长战略制定（Growth Strategy Workflow）

> 所属 LOOP 类型：experiment（战略本身也是假设，需验证）
> 触发场景：季度/年度增长规划、新业务冷启动
> 编排 Skill：nsm-definition → kpi-tree → aarr-diagnosis → growth-loop-design → four-fits-assessment

## 流程图

```
┌─────────────────────┐
│ nsm-definition       │  北极星指标定义
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ kpi-tree             │  KPI Tree 拆解
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ aarr-diagnosis       │  AARRR 漏斗诊断
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ growth-loop-design   │  Growth Loops 设计
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ four-fits-assessment │  四维 Fit 评估
│    [质量门]          │
└─────────┬───────────┘
          │ 任一 Fit 不达标
          ▼
   回到 nsm-definition 重新审视
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| four-fits-assessment 后 | 四种 Fit 是否达标 | 任一不达标→回到 nsm-definition |
| aarr-diagnosis 后 | 是否有 P0 薄弱环节 | 有→优先安排实验 |

## 数据流

| 阶段 | 产出 | 存储位置 |
|------|------|---------|
| nsm-definition | 北极星指标 | docs/operations/GROWTH_STRATEGY.md |
| kpi-tree | KPI Tree | docs/operations/GROWTH_STRATEGY.md |
| aarr-diagnosis | 漏斗诊断 | docs/operations/GROWTH_STRATEGY.md |
| growth-loop-design | 增长循环设计 | docs/operations/GROWTH_STRATEGY.md |
| four-fits-assessment | 四维 Fit 评估 | docs/operations/GROWTH_STRATEGY.md |

## 与 LOOP 的交互

```
LOOP(experiment):
  PLAN:       nsm → kpi-tree → aarr → loop-design → four-fits
  EXPERIMENT: [按 KPI Tree 设计实验]
  MEASURE:    [实验验证战略假设]
  通过? DONE : 回到 PLAN(调整战略)
```

## 产出

- 增长战略文档（GROWTH_STRATEGY.md）完整填写
- KPI Tree（指导实验方向）
- 实验 Backlog（从 KPI Tree 叶子指标生成假设）
- 增长循环设计（指导长期增长引擎）

## 使用方式

对 Agent 说：
- "制定增长战略" → 触发本 workflow
- "定义北极星指标" → 从 nsm-definition 开始
- "拆解 KPI" → 从 kpi-tree 开始
- "诊断增长瓶颈" → 从 aarr-diagnosis 开始
- "设计增长循环" → 从 growth-loop-design 开始
- "评估增长可行性" → 从 four-fits-assessment 开始
