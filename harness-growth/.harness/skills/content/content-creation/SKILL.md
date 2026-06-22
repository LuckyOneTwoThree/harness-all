---
name: content-creation
description: 根据选题产出SEO优化的长文内容，内部分大纲/初稿/优化三step
triggers:
  - 选题已确定，需要创作内容时
  - 内容营销Loop的EXPERIMENT阶段
reads:
  - docs/content/ideation-backlog.md
  - memory/knowledge-base.md
  - rules/security.md
writes:
  - docs/content/drafts/
  - loops/specs/<content>/state.yaml
quality_gates:
  - content-review
max_iterations: 3
---

# Content Creation — 内容创作

## 铁律
- 内容必须对用户有**真实价值**，不是为 SEO 堆砌关键词
- 必须满足"10x 内容"标准——比竞品 Top10 结果好 10 倍（更深/更全/更实用）
- 创作完成后必须经过 content-review 质量门，不可直接发布
- 不做黑帽 SEO（关键词堆砌、隐藏文本、抄袭）

## 流程

### Step 1：大纲生成
1. 读取选题清单，确认目标关键词、搜索意图、目标受众
2. 分析 SERP Top10 竞品内容结构（如有 serp-analysis 数据则读取）
3. 生成内容大纲：
   ```
   # [选题标题]

   ## 引言（hook + 价值承诺）
   ## 1. [核心概念/问题定义]
   ## 2. [方法/步骤/方案]
   ## 3. [案例/数据/工具]
   ## 4. [常见问题/对比]
   ## 总结 + CTA
   ```
4. 确认大纲覆盖搜索意图（信息型要全/导航型要准/交易型要对比）

### Step 2：初稿创作
1. 按大纲逐章节创作
2. 遵循品牌 voice（如 SOUL.md / constitution.md 定义）
3. 嵌入目标关键词（自然出现，不堆砌，密度 1-2%）
4. 加入内部链接（指向已有内容）和外部权威链接
5. 每个章节加入数据/案例/图表（提升可信度）

### Step 3：SEO 优化
1. **标题优化**：包含目标关键词，<60 字符，吸引点击
2. **Meta Description**：包含关键词，<160 字符，含 CTA
3. **URL 结构**：短、含关键词、用连字符
4. **Heading 层级**：H1 唯一，H2/H3 层次清晰，含相关关键词
5. **图片 Alt 文本**：描述性 + 关键词
6. **Schema 标记**：Article/HowTo/FAQ（按内容类型）
7. **内链**：3-5 个相关内链
8. **可读性**：段落<5 行，Flesch 分数 > 60

### Step 4：写入草稿
将完整内容写入 `docs/content/drafts/<content-id>.md`
更新 state.yaml：stage=experiment, substage=content-draft

## 内容质量自检清单

- [ ] 是否比 SERP Top10 更深/更全/更实用？
- [ ] 目标关键词是否自然出现（非堆砌）？
- [ ] 是否有数据/案例支撑（非空谈）？
- [ ] 是否有明确的 CTA（引导下一步）？
- [ ] 可读性是否达标（段落短、层次清）？
- [ ] 是否有 3+ 内链？
- [ ] Meta Description 是否含关键词 + CTA？

## 禁止事项
- 不堆砌关键词（密度 > 3% 算堆砌）
- 不抄袭竞品内容（可参考结构，不可复制文字）
- 不生产同质化内容（查知识库，确保有独特角度）
- 不在创作阶段直接发布（必须过 content-review）

## 与 LOOP 的关系
本 skill 在 LOOP(content) 的 **EXPERIMENT 阶段**执行。
PLAN(content-ideation) → EXPERIMENT(content-creation) → MEASURE(content-review → content-performance)

## 与 Workflow 的关系
本 skill 是 **content-marketing-workflow** 的第 2 步。
产出必须经过 content-review 质量门才能进入 content-distribution。
