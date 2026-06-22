---
name: serp-analysis
description: 分析SERP Top10竞品内容，找出内容差距和优化机会
triggers:
  - 关键词研究后，需要分析竞品内容时
  - SEO优化Loop的PLAN阶段
  - 用户要求"分析竞品SERP"
reads:
  - docs/seo/keyword-research.md
  - memory/knowledge-base.md
writes:
  - docs/seo/serp-analysis.md
quality_gates: []
max_iterations: 2
---

# SERP Analysis — SERP 竞品分析

## 铁律
- 分析必须基于**实际 SERP**，不是"我猜竞品会这样"
- 必须找出**内容差距**（我们没做但竞品做了的）
- 必须提炼**可执行的机会**（不是只列数据）

## 流程

1. **读取目标关键词**
   从 `docs/seo/keyword-research.md` 读取高优关键词清单

2. **SERP 数据采集**
   对每个目标关键词，获取 SERP Top10 结果：
   - 排名 URL
   - 页面标题 + Meta Description
   - 内容类型（博客/落地页/视频/FAQ/工具页）
   - 内容长度（字数）
   - 页面权威度（DA/PA）
   - 外链数
   - Schema 标记类型
   - SERP 特性（精选摘要/People Also Ask/图片/视频）

   > 数据来源：用户提供 SERP 截图/导出，或 Agent 用 WebSearch 查询

3. **内容差距分析**
   对比我们的内容与 SERP Top10：
   ```
   | 维度 | Top10 平均 | 我们的内容 | 差距 | 行动 |
   |------|-----------|-----------|------|------|
   | 字数 | 2500 | 1200 | -1300 | 扩充内容 |
   | 图片数 | 8 | 3 | -5 | 增加图表 |
   | 外链数 | 45 | 5 | -40 | 建设外链 |
   | Schema | Article+FAQ | 无 | 缺失 | 添加 Schema |
   | 内链 | 12 | 4 | -8 | 增加内链 |
   ```

4. **SERP 特性机会**
   - 精选摘要（Featured Snippet）：是否有机会抢占？
   - People Also Ask：是否有对应内容？
   - 图片/视频：是否有多媒体内容？
   - 本地包：是否需要本地 SEO？

5. **内容类型匹配**
   - SERP 主要是什么类型的内容？（博客/落地页/工具/视频）
   - 我们的页面类型是否匹配？
   - 如不匹配，建议调整页面类型

6. **产出 SERP 分析报告**
   写入 `docs/seo/serp-analysis.md`：
   ```markdown
   # SERP 分析报告

   ## 目标关键词: [关键词]

   ## SERP Top10 概览
   | 排名 | URL | 标题 | 类型 | 字数 | DA | 外链 | Schema |
   |------|-----|------|------|------|-----|------|--------|

   ## 内容差距
   [差距分析表]

   ## SERP 特性机会
   - 精选摘要: [有机会/已占据/无]
   - PAA: [有对应/无对应]

   ## 优化建议
   1. [具体建议]
   2. [具体建议]
   ```

## 禁止事项
- 不在无 SERP 数据时猜测竞品内容
- 不只看排名不看内容质量（排名高不等于内容好）
- 不忽略 SERP 特性（精选摘要可大幅提升流量）
- 不产出无行动建议的分析（分析是为了优化）

## 与 LOOP 的关系
本 skill 在 LOOP(seo) 的 **PLAN 阶段**执行。
PLAN(keyword-research → serp-analysis → onpage-optimization) → EXPERIMENT → MEASURE

## 与 Workflow 的关系
本 skill 是 **seo-optimization-workflow** 的第 2 步。
