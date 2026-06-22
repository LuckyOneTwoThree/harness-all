---
name: content-ideation
description: 基于关键词×搜索意图×业务价值三维评估产出选题清单，支持一鱼多吃
triggers:
  - 需要产出内容但没选题时
  - 内容营销Loop的PLAN阶段
  - 用户要求"帮我想几个选题"
reads:
  - memory/knowledge-base.md
  - docs/handoff/pm-to-growth.md
  - docs/handoff/solo-to-growth.md
writes:
  - docs/content/ideation-backlog.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# Content Ideation — 选题机会识别

## 铁律
- 选题必须基于**搜索意图 × 业务价值 × 创作难度**三维评估，不拍脑袋
- 必须查知识库的"内容效果库"，复用高表现选题，避免重复低效选题
- 每个选题必须标注目标关键词和目标受众

## 流程

1. **收集输入**
   - 读取 `memory/knowledge-base.md` 的"内容效果库"，了解历史内容表现
   - 读取 `docs/handoff/pm-to-growth.md`（如有），获取 Persona 和业务目标
   - 读取 `docs/handoff/solo-to-growth.md`（如有），获取已实现功能（可做内容）
   - 如有 SEO 资产库，读取已有关键词排名数据

2. **关键词机会识别**
   - 从业务词根扩展长尾关键词
   - 按搜索意图分类：信息型（how/what/why）/ 导航型（品牌词）/ 交易型（best/compare/buy）
   - 评估每个关键词的搜索量、难度、业务相关性

3. **选题三维评估**
   对每个候选选题打分（1-5 分）：

   | 维度 | 评分依据 |
   |------|---------|
   | 搜索意图匹配 | 5=精准匹配用户搜索意图，1=意图模糊 |
   | 业务价值 | 5=直接关联产品转化路径，1=无关 |
   | 创作难度 | 5=已有素材可快速产出，1=需大量调研 |

   选题优先级 = 搜索意图匹配 × 业务价值 × 创作难度

4. **生成选题清单**
   ```
   | 选题ID | 标题 | 目标关键词 | 搜索意图 | 搜索量 | 难度 | 业务价值 | 优先级 | 目标受众 | 内容形态 |
   |--------|------|-----------|---------|--------|------|---------|--------|---------|---------|
   | T-001 | 如何用X提升Y | how to improve y | 信息型 | 1200 | 中 | 高 | 60 | 增长PM | 博客 |
   ```

5. **一鱼多吃规划**
   每个高优选题规划多渠道复用：
   - 博客长文 → 公众号文章 → 社媒摘要 → 邮件 Newsletter → 视频/图文脚本

6. **写入选题库**
   将选题清单写入 `docs/content/ideation-backlog.md`
   高优选题同步到 `memory/knowledge-base.md` 的"内容效果库"（状态标为"待创作"）

## 禁止事项
- 不生成无搜索意图的选题（没人搜=没流量）
- 不生成与业务无关的选题（有流量但无转化）
- 不重复已创作过的选题（查内容效果库）

## 与 LOOP 的关系
本 skill 在 LOOP(content) 的 **PLAN 阶段**执行。
PLAN(content-ideation → content-creation) → EXPERIMENT → MEASURE

## 与 Workflow 的关系
本 skill 是 **content-marketing-workflow** 的第 1 步。
