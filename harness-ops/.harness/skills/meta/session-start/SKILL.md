---
name: session-start
description: 会话启动，加载上下文恢复工作状态
triggers:
  - Agent 接到新部署/排错任务时
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
   读 `.harness/memory/knowledge-base.md`，查找与当前任务相关的故障结论、运维模式、踩坑记录

3. **检查进行中的任务**
   扫描 `.harness/loops/specs/*/state.yaml`，找出 status 为 `running` 或 `retrying` 的任务
   如有，向用户报告："发现进行中的任务 X，是否继续？"

4. **读取功能看板**
   读 `.harness/FEATURES.md`，了解运维任务整体进度

5. **检查交接文档**（来自 harness 家族其他成员）
   扫描 `docs/handoff/` 目录：
   - 如有 `solo-to-ops.md` 文件，向用户报告："发现工程交付文档（来自 harness-solo），是否本次会话消费执行部署？"
   - 交接文档包含镜像标签、环境变量清单、数据库迁移脚本、回滚方案，是部署的重要输入
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
session-start → 部署/排障 skill → LOOP → ... → session-end
