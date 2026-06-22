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
   读 `.harness/memory/knowledge-base.md`，查找与当前任务相关的实验结论、增长模式、踩坑记录
   增长框架特有：避免重复已证伪的实验

3. **检查进行中的实验**
   扫描 `.harness/loops/specs/*/state.yaml`，找出 status 为 `running` 或 `retrying` 的实验
   如有，向用户报告："发现进行中的实验 X（当前阶段：Y），是否继续？"

4. **读取实验看板**
   读 `.harness/FEATURES.md`，了解项目整体增长进度

5. **检查交接文档**（来自 harness 家族其他成员）
   扫描 `docs/handoff/` 目录：
   - 如有 `solo-to-growth.md` 文件（来自 harness-solo），向用户报告："发现交接文档 solo-to-growth.md（来自 harness-solo），是否本次会话消费？"
   - 该文档可能包含新功能上线信息、可埋点事件、API 端点等，是增长工作的重要输入
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
- 不读 knowledge-base.md 就开始实验（可能重复已证伪的实验）

## 与 LOOP 的关系
本 skill 在 LOOP 之前执行，为循环准备上下文。
session-start → 增长 skill → LOOP(plan→experiment→measure) → ... → session-end

## 产出交接文档提醒
本框架的产出交接文档是 `docs/handoff/growth-to-pm.md`（增长数据反馈给 pm）。
如本次会话有可反馈给 pm 的增长数据/结论，会话结束时由 session-end 产出。
