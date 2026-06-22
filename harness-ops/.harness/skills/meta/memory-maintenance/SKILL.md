---
name: memory-maintenance
description: 记忆维护与归档，确保 progress.md 不膨胀、knowledge-base.md 不丢失
triggers:
  - progress.md 接近 200 行时
  - 定期记忆整理
  - session-end 归档后
reads:
  - memory/progress.md
  - memory/knowledge-base.md
  - memory/archives/
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - memory/archives/
---

# Memory Maintenance — 记忆维护

## 铁律
progress.md 超 200 行必须归档，knowledge-base.md 的重要结论不能丢失

## 流程

1. **检测 progress.md 行数**
   用 Read 读取 `.harness/memory/progress.md`
   - ≤200 行 → 无需操作
   - >200 行 → 执行归档（步骤 2）

2. **归档历史会话**
   - 找到最后一个 `## 会话:` 标记
   - 将标记之前的内容归档到 `.harness/memory/archives/YYYY-MM-DD-HHMM-progress.md`
   - progress.md 只保留最后一个会话块 + 顶部说明

3. **提取重要发现到 knowledge-base.md**
   扫描归档内容，如有值得长期沉淀的知识：
   - 故障结论 → 追加到 knowledge-base.md 的"运维故障结论"表
   - 运维模式 → 追加到"运维模式沉淀"表
   - 踩坑记录 → 追加到"踩坑记录"表

4. **清理临时记忆**
   progress.md 中已归档的会话块不再保留，避免上下文污染

## 禁止事项
- 不检测直接归档（可能误切正在进行的会话）
- 归档时不提取重要发现（知识丢失）

## 与 LOOP 的关系
本 skill 在 LOOP 之外执行，是维护性操作。
通常由 session-end 触发，也可独立调用。
