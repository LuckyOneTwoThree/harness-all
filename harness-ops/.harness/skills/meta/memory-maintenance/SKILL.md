---
name: memory-maintenance
description: 维护 memory 目录，执行 retention 策略，防止 progress/knowledge-base/archives 无限膨胀
triggers:
  - session-end 可选调用
  - 用户说"清理历史"/"归档"/"memory 太大"时
  - memory 文件超过阈值时
reads:
  - .harness/loops/LOOP.md
  - .harness/skills/meta/session-end/SKILL.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - memory/archives/
  - loops/specs/*/iterations.log
---

# Memory Maintenance — 记忆维护

## 核心原则
**Memory is not a dumpster. If you can't afford to read it, don't keep it.**

Agent 的上下文有限。progress.md / knowledge-base.md / iterations.log 无限膨胀会污染上下文、降低效率。本 skill 负责定期清理和归档。

## 什么是 memory 维护

**维护的是：**
- `memory/progress.md` 的长度
- `memory/knowledge-base.md` 的长度
- `memory/archives/` 的保留期限
- `loops/specs/<task>/iterations.log` 的长度

**不是：**
- 删除当前活跃任务的 state.yaml / spec.md / evidence.md
- 删除 `.git` 历史
- 压缩或加密文件

## Retention 策略

| 文件 | 阈值 | 超限处理 |
|------|------|---------|
| `progress.md` | 200 行 | 归档最旧会话块到 `archives/` |
| `knowledge-base.md` | 150 行 | 拆分到主题归档 |
| `iterations.log`（每个任务） | 100 行 | 归档到 `archives/iterations-<task>-<date>.log` |
| `archives/` 中的文件 | 90 天 | 询问用户后删除 |

## 流程

1. **扫描文件大小**
   - 用 Read 读取 `memory/progress.md`，统计行数
   - 用 Read 读取 `memory/knowledge-base.md`，统计行数
   - 用 Glob 扫描 `loops/specs/*/iterations.log`
   - 用 Glob 扫描 `memory/archives/*`，记录文件日期

2. **判断是否需要清理**

   | 文件 | 条件 | 动作 |
   |------|------|------|
   | progress.md | 行数 > 200 | 执行步骤 3 |
   | knowledge-base.md | 行数 > 150 | 执行步骤 4 |
   | iterations.log | 行数 > 100 | 执行步骤 5 |
   | archives/ 文件 | 修改时间 > 90 天 | 执行步骤 6 |

3. **归档 progress.md**
   - 找到最后一个完整会话块（以 `## 会话` 或类似标题分隔）
   - 保留最后一个会话块在 progress.md（用于断点续传）
   - 其余内容追加写入 `memory/archives/progress-<YYYY-MM-DD-HHMM>.md`
   - 在 progress.md 顶部保留指向归档文件的链接

4. **拆分 knowledge-base.md**
   - 按主题（`##` 标题）拆分
   - 将最旧的主题归档到 `memory/archives/knowledge-<topic>-<date>.md`
   - 保留最近 3 个主题在 knowledge-base.md
   - **ops 领域特有**：故障复盘结论、变更记录、踩坑记录优先保留

5. **归档 iterations.log**
   - 保留最近 20 行在原地
   - 其余内容追加写入 `memory/archives/iterations-<task>-<date>.log`
   - 不删除原文件（LOOP 需要它）

6. **清理旧 archives**
   - 列出 90 天前的归档文件
   - **必须询问用户后删除**
   - 用户确认 → 删除
   - 用户拒绝 → 保留并记录

7. **输出维护报告**
   记录到 progress.md 或本次会话报告：
   ```markdown
   ## Memory 维护

   | 文件 | 操作前 | 操作后 | 动作 |
   |------|--------|--------|------|
   | progress.md | 250 行 | 45 行 | 归档到 archives/progress-2026-06-20-2000.md |
   | knowledge-base.md | 180 行 | 60 行 | 拆分归档 2 个主题 |
   | iterations.log | 120 行 | 20 行 | 归档到 archives/iterations-xxx-2026-06-20.log |
   | archives/ | 5 个旧文件 | 删除 3 个 | 用户确认 |
   ```

## 证据要求

运行本 skill 后必须展示：
- 每个文件的操作前行数/大小
- 每个文件的操作后行数/大小
- 归档文件的具体路径
- 删除文件的用户确认记录

不能只写"已清理"。

## 禁止事项
- 删除当前活跃任务的 state.yaml / spec.md / evidence.md
- 清空 progress.md 不留任何会话块（破坏断点续传）
- 不询问用户就删除 archives/ 中的文件
- 归档时不保留最近内容

## 与 session-end 的关系

session-end 负责日常收尾，memory-maintenance 负责大扫除：

| Skill | 频率 | 职责 |
|-------|------|------|
| session-end | 每次会话结束 | 归档本次会话、写 baseline、更新看板 |
| memory-maintenance | 按需/定期 | 大文件拆分、旧归档清理、retention 执行 |

**建议**：session-end 每次检查 progress.md 长度，超过 200 行时调用 memory-maintenance。

## 与 LOOP 的关系

本 skill 不影响 LOOP 状态：
- state.yaml 不清理
- spec.md 不清理
- evidence.md 不清理
- 只清理日志类和归档类文件
