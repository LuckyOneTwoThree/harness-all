---
workflow_id: D
name: seo-optimization-workflow
default_mode: standard
---

# Workflow: SEO 优化全流程（SEO Optimization Workflow）

> 所属 LOOP 类型：seo
> 触发场景：月度 SEO 优化周期、新站点 SEO 启动、排名异常波动
> 编排 Skill：keyword-research → serp-analysis → onpage-optimization → technical-seo-audit → [发布优化] → ranking-tracking

## 流程图

```
┌─────────────────────┐
│ keyword-research     │  关键词研究（扩展/意图/难度/优先级）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ serp-analysis        │  SERP 竞品分析（内容差距/机会）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ onpage-optimization  │  站内优化（标题/Meta/内容/内链/Schema）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ technical-seo-audit  │  技术审计（爬虫/CWV/索引/移动端）
│    [质量门]          │
└─────────┬───────────┘
          │ P0 问题修复
          ▼
   [发布优化，外部]
   （工程团队上线优化方案）
          ▼
┌─────────────────────┐
│ ranking-tracking     │  排名追踪与归因
└─────────────────────┘
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| technical-seo-audit 后 | P0 问题（索引屏蔽/robots 错误）必须修复 | 阻止发布，先修 P0 |
| ranking-tracking 前 | 优化方案已上线 | 等待上线后再追踪 |

## 数据流

| 阶段 | 产出 | 存储位置 |
|------|------|---------|
| keyword-research | 关键词清单 | docs/seo/keyword-research.md + knowledge-base.md |
| serp-analysis | SERP 分析报告 | docs/seo/serp-analysis.md |
| onpage-optimization | 优化方案 | docs/seo/onpage-optimization.md |
| technical-seo-audit | 技术审计报告 | docs/seo/technical-audit.md |
| ranking-tracking | 排名报告 | docs/seo/ranking-report.md + knowledge-base.md |

## 与 LOOP 的交互

```
LOOP(seo):
  PLAN:       keyword-research → serp-analysis
  EXPERIMENT: onpage-optimization → technical-seo-audit → [发布]
  MEASURE:    ranking-tracking
  通过? DONE : 回到 PLAN(新关键词) / EXPERIMENT(调整优化)
```

## 反馈闭环

ranking-tracking 的产出反馈到 keyword-research：
- 排名上升的关键词 → 总结成功模式，应用到其他词
- 排名下降的关键词 → 分析原因，调整策略
- 新机会关键词 → 下一轮 keyword-research 输入

## 使用方式

对 Agent 说：
- "做一次 SEO 优化" → 从 keyword-research 开始
- "研究关键词" → 从 keyword-research 开始
- "分析竞品 SERP" → 从 serp-analysis 开始
- "优化这个页面" → 从 onpage-optimization 开始
- "检查技术 SEO" → 从 technical-seo-audit 开始
- "查看排名变化" → 从 ranking-tracking 开始
