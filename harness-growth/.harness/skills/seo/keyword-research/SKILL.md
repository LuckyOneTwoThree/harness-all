---
name: keyword-research
description: 关键词研究，含种子词扩展/意图分类/难度评估/优先级排序
triggers:
  - 需要做SEO但没有关键词清单时
  - SEO优化Loop的PLAN阶段
  - 用户要求"研究关键词"
reads:
  - memory/knowledge-base.md
  - docs/handoff/pm-to-growth.md
writes:
  - docs/seo/keyword-research.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# Keyword Research — 关键词研究

## 铁律
- 关键词必须按**搜索意图**分类（信息/导航/交易），不同意图对应不同内容形态
- 必须查知识库的"SEO 资产库"，避免重复已优化的关键词
- 难度评估必须基于数据（搜索量/竞品数/SERP 权威度），不拍脑袋

## 流程

1. **收集种子词**
   - 从业务核心词根扩展（产品名/功能名/行业术语/用户痛点词）
   - 读取 `docs/handoff/pm-to-growth.md`（如有）获取产品定位和目标受众
   - 读取知识库的"SEO 资产库"，排除已优化的关键词
   - 从用户反馈/客服记录中挖掘长尾词

2. **关键词扩展**
   - 使用关键词扩展方法：
     - 同义词/近义词扩展
     - 长尾扩展（how to / what is / best / vs / alternatives）
     - 问题型扩展（为什么/如何/什么是）
     - 修饰词扩展（2026/免费/工具/教程）
   - 目标：每个种子词扩展 10-20 个相关词

3. **搜索意图分类**
   | 意图类型 | 特征词 | 对应内容形态 |
   |---------|--------|-------------|
   | 信息型 | how/what/why/教程/指南 | 博客长文/FAQ |
   | 导航型 | 品牌名/产品名 | 官网/落地页 |
   | 交易型 | best/compare/buy/price | 对比文/购买指南 |
   | 本地型 | near me/城市名 | 本地落地页 |

4. **难度评估**
   对每个关键词评估：
   - **搜索量**：月搜索量（高/中/低）
   - **竞争度**：SERP Top10 的域名权威度
   - **CPC**：商业价值参考（高 CPC = 高商业意图）
   - **趋势**：搜索趋势（上升/稳定/下降）

5. **优先级排序**
   关键词优先级 = 搜索量 × 商业价值 × (1 / 难度)

   ```
   | 关键词 | 意图 | 月搜索量 | 难度 | CPC | 优先级 | 目标页面 | 内容形态 |
   |--------|------|---------|------|-----|--------|---------|---------|
   | how to do X | 信息 | 1200 | 中 | $2.5 | 高 | /blog/how-to-x | 长文 |
   | X vs Y | 交易 | 800 | 低 | $5.0 | 高 | /blog/x-vs-y | 对比 |
   ```

6. **写入关键词研究报告**
   产出 `docs/seo/keyword-research.md`，含：
   - 种子词清单
   - 扩展关键词全表
   - 意图分类统计
   - 优先级排序 Top 20
   - 内容规划建议（每个高优关键词对应什么内容）

7. **更新知识库**
   将高优关键词写入 `memory/knowledge-base.md` 的"SEO 资产库"（状态标为"待优化"）

## 禁止事项
- 不选与业务无关的高搜索量词（有流量无转化）
- 不忽视长尾词（长尾词难度低、意图明确、转化率高）
- 不重复已优化的关键词（查 SEO 资产库）
- 不只看搜索量不看难度（高搜索量+高难度=短期内无法排名）

## 与 LOOP 的关系
本 skill 在 LOOP(seo) 的 **PLAN 阶段**执行。
PLAN(keyword-research → serp-analysis → onpage-optimization) → EXPERIMENT → MEASURE

## 与 Workflow 的关系
本 skill 是 **seo-optimization-workflow** 的第 1 步。
