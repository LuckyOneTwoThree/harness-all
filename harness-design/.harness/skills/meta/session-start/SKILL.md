---
name: session-start
description: 会话启动，加载上下文恢复工作状态
triggers:
  - Agent 接到新任务时
  - 跨会话恢复工作时
reads:
  - SOUL.md
  - constitution.md
  - memory/progress.md
  - memory/knowledge-base.md
  - FEATURES.md
  - loops/specs/*/state.yaml
  - docs/handoff/
writes:
  - memory/progress.md
---

# Session Start — 会话启动

## 铁律
会话开始前必须加载上下文，不允许"失忆"干活

## 流程

1. **读取进度日志**
   读 `.harness/memory/progress.md`，了解上次会话做到哪、待续什么

2. **读取知识库**（如有相关）
   读 `.harness/memory/knowledge-base.md`，查找与当前任务相关的设计决策、踩坑记录

3. **检查进行中的任务**
   扫描 `.harness/loops/specs/*/state.yaml`，找出 status 为 `running` 或 `retrying` 的任务
   如有，向用户报告："发现进行中的设计任务 X，是否继续？"
   同时读取 `exploration_mode` 字段，报告当前模式（如"当前探索模式：deep"）

4. **读取任务看板**
   读 `.harness/FEATURES.md`，了解项目整体设计进度

5. **检查交接文档**（来自 harness 家族其他成员）
   扫描 `docs/handoff/` 目录：
   - 如有 `pm-to-design.md` 文件，向用户报告："发现交接文档（来自 harness-pm），是否本次会话消费？"
   - 交接文档可能包含 PRD 路径、关键决策、未决事项，是 design-brief 的重要输入
   - 如未消费过的交接文档存在，提醒用户优先处理

6. **确认任务范围**
   向用户确认本次会话要做什么，写入 progress.md 新会话块：
   ```
   ## 会话: YYYY-MM-DD HH:MM
   ### 任务
   [本次会话目标]
   ```

## 禁止事项
- 不读 progress.md 直接开干（会丢失上下文）
- 不确认任务范围就动手（可能跑偏）

## 与 LOOP 的关系
本 skill 在 LOOP 之前执行，为循环准备上下文。
session-start → design-brief → new-design/iteration/redesign workflow（含 LOOP）→ ... → session-end
