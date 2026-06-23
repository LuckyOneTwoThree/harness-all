---
workflow_id: C
name: content-marketing-workflow
default_mode: standard
---

# Workflow: 内容营销全流程（Content Marketing Workflow）

> 所属 LOOP 类型：content
> 触发场景：内容生产周期（周/双周）
> 编排 Skill：content-ideation → content-creation → content-review → content-distribution → [发布] → content-performance

## 流程图

```
┌─────────────────────┐
│ content-ideation     │  选题（关键词×意图×价值三维评估）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ content-creation     │  创作（大纲→初稿→SEO优化）
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ content-review       │  评审（合规/事实/品牌/SEO 四维审查）
│    [质量门]          │
└─────────┬───────────┘
          │ 通过
          ▼
┌─────────────────────┐
│ content-distribution │  分发（多渠道适配，一鱼多吃）
└─────────┬───────────┘
          ▼
   [发布，外部]
   （各渠道发布上线）
          ▼
┌─────────────────────┐
│ content-performance  │  度量（流量/停留/转化/复用建议）
└─────────────────────┘
```

## 质量门控

| 门控点 | 检查内容 | 不通过处理 |
|--------|---------|-----------|
| content-review | 合规无违规 + 事实准确 + 品牌一致 + SEO 达标 | 退回 content-creation 修改 |
| content-distribution 前 | content-review 必须通过 | 阻止发布 |

## 数据流

| 阶段 | 产出 | 存储位置 |
|------|------|---------|
| content-ideation | 选题清单 | docs/content/ideation-backlog.md + knowledge-base.md |
| content-creation | 内容草稿 | docs/content/drafts/ |
| content-review | 审查报告 | docs/content/drafts/*.review.md |
| content-distribution | 多渠道版本 | docs/content/published/ |
| content-performance | 效果报告 | docs/content/performance-report.md + knowledge-base.md |

## 与 LOOP 的交互

```
LOOP(content):
  PLAN:       content-ideation
  EXPERIMENT: content-creation → content-review → content-distribution
  MEASURE:    content-performance
  通过? DONE : 回到 PLAN(新选题) / EXPERIMENT(修改内容)
```

## 反馈闭环

content-performance 的产出反馈到 content-ideation：
- 高表现选题方向 → 下一轮选题参考
- 低表现选题方向 → 标注"已验证低效"
- 成功模式 → 写入知识库"增长模式沉淀"

## 使用方式

对 Agent 说：
- "我要做一篇关于 X 的内容" → 从 content-ideation 开始
- "帮我写这篇内容" → 从 content-creation 开始
- "审查这篇内容" → 从 content-review 开始
- "分发这篇内容" → 从 content-distribution 开始（需先过 review）
- "分析内容效果" → 从 content-performance 开始
