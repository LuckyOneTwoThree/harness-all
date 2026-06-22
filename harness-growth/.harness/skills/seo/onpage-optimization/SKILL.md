---
name: onpage-optimization
description: 站内优化建议，含IA/URL/内链/内容优化/Schema标记
triggers:
  - SERP分析后，需要优化页面时
  - SEO优化Loop的EXPERIMENT阶段
  - 用户要求"优化这个页面的SEO"
reads:
  - docs/seo/keyword-research.md
  - docs/seo/serp-analysis.md
  - rules/security.md
writes:
  - docs/seo/onpage-optimization.md
  - loops/specs/<seo>/state.yaml
quality_gates: []
max_iterations: 3
---

# Onpage Optimization — 站内优化

## 铁律
- 优化必须基于 SERP 分析的数据，不是"我觉得应该这样"
- 不做黑帽 SEO（关键词堆砌/隐藏文本/门页/链接农场）
- 优化建议必须具体可执行（指出改什么 + 改成什么）

## 流程

1. **读取分析数据**
   - 读取 `docs/seo/keyword-research.md` 的目标关键词
   - 读取 `docs/seo/serp-analysis.md` 的内容差距和优化建议

2. **信息架构（IA）优化**
   - 网站结构是否扁平（重要页面 ≤ 3 次点击到达）？
   - URL 结构是否含关键词、用连字符、短？
   - 面包屑导航是否完整？
   - 分类/标签是否合理？

3. **页面级优化**
   对每个目标页面：

   ### 标题优化
   - 含目标关键词（尽量靠前）
   - < 60 字符（避免截断）
   - 吸引点击（含数字/问题/情感词）

   ### Meta Description
   - 含关键词 + 相关词
   - < 160 字符
   - 含 CTA（了解更多/立即试用/免费下载）

   ### Heading 结构
   - H1 唯一，含目标关键词
   - H2/H3 层次清晰，含相关关键词（LSI）
   - 不跳层级（H1 → H3 是错误的）

   ### 内容优化
   - 关键词密度 1-2%（自然出现，不堆砌）
   - 相关关键词/LSI 词覆盖
   - 搜索意图全覆盖（信息型要全/交易型要对比）
   - 内容长度 ≥ SERP Top10 平均（参考 serp-analysis）
   - 多媒体（图片/视频/图表）提升体验

   ### 内链优化
   - 每页 3-5 个相关内链
   - 锚文本含关键词（自然，不堆砌）
   - 重要页面获得更多内链

   ### 图片优化
   - 文件名含关键词（如 how-to-do-x.png）
   - Alt 文本描述性 + 关键词
   - 压缩图片大小（WebP 格式）
   - Lazy loading

4. **Schema 标记**
   按内容类型添加 Schema：
   | 内容类型 | Schema 类型 |
   |---------|-----------|
   | 博客文章 | Article |
   | 教程 | HowTo |
   | 问答 | FAQPage |
   | 产品 | Product |
   | 评测 | Review |
   | 面包屑 | BreadcrumbList |

5. **技术优化检查**
   - Canonical 标签（避免重复内容）
   - Robots.txt / Meta Robots
   - Open Graph / Twitter Card
   - 移动端适配
   - 页面加载速度（Core Web Vitals）

6. **产出优化方案**
   写入 `docs/seo/onpage-optimization.md`：
   ```markdown
   # 站内优化方案: [页面/关键词]

   ## 当前状态
   [页面 URL、当前排名、当前问题]

   ## 优化建议
   | 优化项 | 当前 | 建议 | 优先级 |
   |--------|------|------|--------|
   | 标题 | [当前标题] | [建议标题] | 高 |
   | Meta | [当前] | [建议] | 高 |
   | 字数 | 1200 | 2500 | 高 |
   | Schema | 无 | Article+FAQ | 中 |

   ## 具体修改
   [逐项修改的详细说明]
   ```

7. **更新 state.yaml**
   stage=experiment, substage=onpage-optimization

## 禁止事项
- 不堆砌关键词（密度 > 3% 算堆砌）
- 不做隐藏文本（同色文字/小字号）
- 不做门页（为不同关键词创建相同内容的页面）
- 不买外链（违反搜索引擎规则）

## 与 LOOP 的关系
本 skill 在 LOOP(seo) 的 **EXPERIMENT 阶段**执行。
PLAN(research → serp) → EXPERIMENT(onpage → technical) → MEASURE(ranking)

## 与 Workflow 的关系
本 skill 是 **seo-optimization-workflow** 的第 3 步。
