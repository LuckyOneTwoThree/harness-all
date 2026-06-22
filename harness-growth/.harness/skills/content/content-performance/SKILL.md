---
name: content-performance
description: 分析内容效果（流量/停留/转化/ROI），产出复用建议，反馈到选题阶段
triggers:
  - 内容发布后有数据时
  - 内容营销Loop的MEASURE阶段
  - 用户要求"分析内容效果"
reads:
  - docs/content/published/
  - memory/knowledge-base.md
  - loops/specs/<content>/state.yaml
writes:
  - docs/content/performance-report.md
  - memory/knowledge-base.md
  - loops/specs/<content>/state.yaml
  - loops/specs/<content>/iterations.log
quality_gates: []
max_iterations: 1
---

# Content Performance — 内容效果分析

## 铁律
- 必须基于**实际数据**分析，不是"感觉效果不错"
- 必须同时报告成功和失败的内容——失败内容的洞察同样有价值
- 必须产出**复用建议**——哪些内容值得改编为其他形态
- 结论必须写入知识库，反馈到下一轮选题

## 流程

1. **收集数据**
   - 读取 `docs/content/published/` 的发布记录
   - 获取各渠道的效果数据（需用户提供或从分析工具读取）：
     - 流量：UV/PV
     - 停留：平均停留时长、滚动深度
     - 转化：转化率、转化数
     - 排名：目标关键词排名变化
     - 社交：点赞/评论/分享/转发

2. **效果评估**
   对每篇内容评估：

   | 指标 | 优秀 | 合格 | 不达标 |
   |------|------|------|--------|
   | UV（月） | > 目标值 | 50-100% 目标 | < 50% 目标 |
   | 平均停留 | > 3 分钟 | 1-3 分钟 | < 1 分钟 |
   | 转化率 | > 目标 | 50-100% 目标 | < 50% 目标 |
   | 关键词排名 | Top 3 | Top 10 | 无排名 |
   | 社交互动 | > 目标 | 50-100% 目标 | < 50% 目标 |

3. **归因分析**
   - 高表现内容：为什么好？（选题准/标题好/内容深/渠道对）
   - 低表现内容：为什么差？（选题偏/标题弱/内容浅/渠道错/竞争大）
   - 提炼可复用的成功模式和失败教训

4. **复用建议**
   对高表现内容，建议复用方向：
   ```
   | 内容ID | 当前形态 | 表现 | 复用建议 | 目标渠道 |
   |--------|---------|------|---------|---------|
   | C-001 | 博客 | UV 5000 | 改编为视频脚本 | 抖音/视频号 |
   | C-001 | 博客 | UV 5000 | 摘要为 Thread | Twitter |
   | C-003 | 博客 | UV 800 | 改写标题重发 | 博客（A/B测试标题） |
   ```

5. **写入效果报告**
   产出 `docs/content/performance-report.md`：
   ```markdown
   # 内容效果报告: <周期>

   ## 概览
   - 发布内容数: N
   - 总 UV: N
   - 平均转化率: X%
   - Top 3 内容: ...

   ## 各内容详情
   | 内容ID | 标题 | 渠道 | UV | 停留 | 转化 | 排名 | 评级 |
   |--------|------|------|-----|------|------|------|------|

   ## 成功模式
   - [可复用的成功模式]

   ## 失败教训
   - [可避免的失败原因]

   ## 复用建议
   - [高表现内容的复用方向]
   ```

6. **更新知识库**
   在 `memory/knowledge-base.md` 的"内容效果库"表追加每篇内容的效果数据
   在"增长模式沉淀"表追加成功/失败模式

7. **更新 state.yaml**
   - stage: measure
   - status: done
   - 追加 iterations.log

8. **反馈到选题**
   高表现内容的主题方向 → 下一轮 content-ideation 的选题参考
   低表现内容的主题方向 → 标注"已验证低效，暂缓"

## 禁止事项
- 不在无数据时下结论
- 不只报告成功不报告失败
- 不省略复用建议（内容复用是增长复利的关键）
- 不忘记写入知识库（下一轮选题需要参考）

## 与 LOOP 的关系
本 skill 在 LOOP(content) 的 **MEASURE 阶段**执行，是 MEASURE 的最后一步。
PLAN(ideation) → EXPERIMENT(creation → review → distribution) → MEASURE(performance) → DONE

## 与 Workflow 的关系
本 skill 是 **content-marketing-workflow** 的第 5 步（最后一步）。
产出的效果数据反馈到 content-ideation，形成内容复利 Loop。
