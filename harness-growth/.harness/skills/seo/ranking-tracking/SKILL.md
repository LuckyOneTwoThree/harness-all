---
name: ranking-tracking
description: 排名追踪与波动归因，含算法更新检测/竞品变化/内容效果反馈
triggers:
  - SEO优化发布后，需要追踪排名时
  - SEO优化Loop的MEASURE阶段
  - 用户要求"查看排名变化"
  - 排名异常波动时
reads:
  - docs/seo/keyword-research.md
  - memory/knowledge-base.md
  - loops/specs/<seo>/state.yaml
writes:
  - docs/seo/ranking-report.md
  - memory/knowledge-base.md
  - loops/specs/<seo>/state.yaml
  - loops/specs/<seo>/iterations.log
quality_gates: []
max_iterations: 1
---

# Ranking Tracking — 排名追踪与归因

## 铁律
- 排名数据必须基于**实际查询**，不是"应该上升了"
- 排名波动必须**归因**——是算法更新/竞品变化/我们优化/外部因素
- 必须同时追踪排名、流量、CTR——排名升但流量不升可能是问题
- 结论必须写入知识库，反馈到下一轮 SEO 优化

## 流程

1. **读取目标关键词**
   从 `docs/seo/keyword-research.md` 和知识库的"SEO 资产库"读取追踪关键词清单

2. **排名数据采集**
   对每个目标关键词，获取：
   - 当前排名
   - 上期排名（对比变化）
   - 历史趋势（30/60/90 天）
   - SERP 特性（精选摘要/PAA/图片/视频）

   > 数据来源：用户提供排名报告/截图，或 Agent 用 WebSearch 查询

3. **排名变化分析**
   ```
   | 关键词 | 上期排名 | 当前排名 | 变化 | CTR | 流量 | 趋势 |
   |--------|---------|---------|------|-----|------|------|
   | how to do X | 15 | 8 | ↑7 | 3.2% | 450 | ↑ |
   | X vs Y | 5 | 5 | — | 5.1% | 200 | — |
   | what is X | 8 | 22 | ↓14 | 1.1% | 50 | ↓ |
   ```

4. **波动归因**
   对排名波动（±5 位以上）进行归因：

   ### 我们的操作
   - 近期是否做了 onpage 优化？（对应优化记录）
   - 近期是否发布了新内容？
   - 近期是否修改了 URL/结构？

   ### 算法更新
   - 是否有 Google 算法更新公告？（核心更新/有用内容更新/链接垃圾更新）
   - 多个关键词同时波动？（可能是算法更新）
   - 行业整体是否受影响？（查竞品排名是否也波动）

   ### 竞品变化
   - 竞品是否发布了新内容？
   - 竞品是否做了优化？
   - 是否有新竞品进入 SERP？

   ### 技术问题
   - 页面是否出现技术错误？（索引丢失/CWV 退化/移动端问题）
   - 是否被黑客攻击/注入垃圾内容？

5. **流量与 CTR 分析**
   - 排名升 + 流量升 = 正常
   - 排名升 + 流量不升 = CTR 问题（标题/Meta 不吸引）
   - 排名升 + 流量降 = 搜索量下降或 SERP 特性变化
   - 排名降 + 流量降 = 需要优化

6. **产出排名报告**
   写入 `docs/seo/ranking-report.md`：
   ```markdown
   # 排名追踪报告: <日期>

   ## 概览
   - 追踪关键词数: N
   - 排名上升: N
   - 排名下降: N
   - 排名不变: N
   - Top 10 关键词: N
   - Top 3 关键词: N

   ## 排名变化详情
   [排名变化表]

   ## 波动归因
   | 关键词 | 变化 | 归因 | 行动建议 |
   |--------|------|------|---------|
   | how to do X | ↑7 | onpage 优化生效 | 继续优化相关词 |
   | what is X | ↓14 | 疑似算法更新 | 观察 1-2 周 |

   ## CTR 优化机会
   | 关键词 | 排名 | CTR | 优化建议 |
   |--------|------|-----|---------|
   | X vs Y | 5 | 5.1% | 标题加数字可提升 CTR |
   ```

7. **更新知识库**
   - 更新"SEO 资产库"中每个关键词的排名和流量
   - 在"增长模式沉淀"中记录有效的 SEO 优化模式
   - 在"踩坑记录"中记录无效或有害的操作

8. **更新 state.yaml**
   - stage: measure
   - status: done（排名达标）/ retrying（需继续优化）
   - 追加 iterations.log

9. **反馈到下一轮**
   - 排名上升的关键词 → 总结成功模式，应用到其他关键词
   - 排名下降的关键词 → 分析原因，调整策略
   - 排名不变的关键词 → 考虑是否需要更深入的优化

## 禁止事项
- 不在无数据时声称排名变化
- 不忽略排名下降（可能是技术问题或算法更新）
- 不只看排名不看流量（排名升但流量不升=CTR 问题）
- 不忘记归因（不知道为什么变化=无法复用学习）

## 与 LOOP 的关系
本 skill 在 LOOP(seo) 的 **MEASURE 阶段**执行，是 MEASURE 的最后一步。
PLAN(research → serp) → EXPERIMENT(onpage → technical) → MEASURE(ranking) → DONE/回到 PLAN

## 与 Workflow 的关系
本 skill 是 **seo-optimization-workflow** 的第 5 步（最后一步）。
产出的排名数据反馈到 keyword-research，形成 SEO 复利 Loop。
