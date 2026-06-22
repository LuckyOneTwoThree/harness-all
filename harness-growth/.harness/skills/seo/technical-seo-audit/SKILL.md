---
name: technical-seo-audit
description: 技术SEO审计，含爬虫可访问性/Core Web Vitals/索引状态/移动端/安全
triggers:
  - SEO优化时需要检查技术基础
  - SEO优化Loop的EXPERIMENT阶段
  - 用户要求"检查技术SEO"
  - 排名异常下降时
reads:
  - rules/security.md
writes:
  - docs/seo/technical-audit.md
  - loops/specs/<seo>/state.yaml
quality_gates: []
max_iterations: 2
---

# Technical SEO Audit — 技术 SEO 审计

## 铁律
- 审计必须基于**实际检测**，不是"我猜应该没问题"
- 发现的问题必须按**影响面 × 严重度**排序
- 严重问题（如索引被屏蔽）必须优先修复

## 流程

1. **爬虫可访问性检查**
   - Robots.txt 是否正确（未屏蔽重要页面）
   - Meta Robots 是否正确（noindex/nofollow 使用合理）
   - Canonical 标签是否正确（避免重复内容）
   - 爬虫日志分析（搜索引擎是否在爬）
   - Sitemap.xml 是否完整且提交

2. **索引状态检查**
   - 重要页面是否被索引（site: 查询）
   - 是否有被索引的低质页面（应 noindex）
   - 是否有孤儿页面（无内链指向，搜索引擎找不到）
   - 重复内容检查（相同内容不同 URL）

3. **Core Web Vitals 检查**
   | 指标 | 达标 | 需优化 | 不达标 |
   |------|------|--------|--------|
   | LCP（最大内容渲染） | < 2.5s | 2.5-4s | > 4s |
   | INP（交互延迟） | < 200ms | 200-500ms | > 500ms |
   | CLS（布局偏移） | < 0.1 | 0.1-0.25 | > 0.25 |

   - 检查 LCP 元素（通常是首屏大图/大标题）
   - 检查 INP 瓶颈（长任务/第三方脚本）
   - 检查 CLS 来源（图片无尺寸/动态注入内容）

4. **移动端适配**
   - 响应式设计是否正确
   - 移动端字体大小（≥ 16px）
   - 点击目标大小（≥ 48px）
   - 无水平滚动
   - 移动端加载速度

5. **安全检查**
   - HTTPS 是否启用
   - 混合内容（HTTPS 页面加载 HTTP 资源）
   - HSTS 头是否设置

6. **结构化数据验证**
   - Schema 标记是否正确（Google Rich Results Test）
   - 是否有 Schema 错误/警告

7. **内链结构分析**
   - 孤儿页面清单
   - 内链深度分布（重要页面是否 ≤ 3 次点击）
   - 锚文本多样性

8. **产出审计报告**
   写入 `docs/seo/technical-audit.md`：
   ```markdown
   # 技术 SEO 审计报告

   ## 审计概览
   - 审计日期: YYYY-MM-DD
   - 检查页面数: N
   - 发现问题数: N（严重 X / 中等 Y / 低 Z）

   ## 问题清单（按优先级排序）
   | 优先级 | 问题 | 影响面 | 严重度 | 修复建议 |
   |--------|------|--------|--------|---------|
   | P0 | robots.txt 屏蔽了 /blog | 全站博客 | 严重 | 修改 robots.txt |
   | P1 | LCP 4.5s | 首页 | 中等 | 压缩首图 |
   | P2 | 缺少 Schema | 博客 | 低 | 添加 Article Schema |

   ## Core Web Vitals
   | 页面 | LCP | INP | CLS | 评级 |
   |------|-----|-----|-----|------|

   ## 索引状态
   | 检查项 | 结果 | 说明 |
   |--------|------|------|
   | 重要页面索引 | N/M | |
   | 孤儿页面 | N | |
   | 重复内容 | N | |

   ## 修复路线图
   1. [P0 修复步骤]
   2. [P1 修复步骤]
   ```

## 问题优先级标准

| 优先级 | 定义 | 修复时限 |
|--------|------|---------|
| P0 | 严重影响索引/排名（如被 noindex/robots 屏蔽） | 立即 |
| P1 | 影响排名/用户体验（如 CWV 不达标/移动端问题） | 1 周内 |
| P2 | 优化空间（如缺 Schema/内链不足） | 1 月内 |

## 禁止事项
- 不跳过爬虫可访问性检查（技术基础不解决，其他优化白做）
- 不忽略 Core Web Vitals（Google 排名信号）
- 不只报告问题不给修复方案
- 不把 P0 问题降级为"以后再说"

## 与 LOOP 的关系
本 skill 在 LOOP(seo) 的 **EXPERIMENT 阶段**执行。
PLAN → EXPERIMENT(onpage → technical-seo-audit) → MEASURE(ranking)

## 与 Workflow 的关系
本 skill 是 **seo-optimization-workflow** 的第 4 步。
P0 问题必须修复后才能进入 ranking-tracking。
