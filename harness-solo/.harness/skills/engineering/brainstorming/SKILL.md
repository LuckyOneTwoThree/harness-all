---
name: brainstorming
description: 需求探索与设计细化，硬门——过不去不许写代码
triggers:
  - 新功能开发前
  - 新项目立项时
  - 需求模糊不清时
reads:
  - constitution.md
  - rules/security.md
  - docs/handoff/pm-to-solo.md
  - docs/handoff/design-to-solo.md
  - docs/handoff/component-map.json
  - docs/product/PROJECT.md
writes:
  - docs/product/PROJECT.md
---

# Brainstorming — 需求探索

## 铁律
**没有清晰的需求，不许写代码。** 这是一道硬门——过不去就停下来问，不许猜着干。

## 输入来源（按优先级）

1. **交接文档**（来自 harness-pm / harness-design）：
   - `docs/handoff/pm-to-solo.md` — 产品需求（PRD 路径、关键决策、未决事项）+ **业务上下文摘要**
   - `docs/handoff/design-to-solo.md` — 设计交付（设计稿路径、组件映射、设计 AC）
   - `docs/handoff/component-map.json` — 显式映射层（设计组件 → 工程组件，含 props/states）
   - 任一存在则**优先读取**作为需求来源
   - **读取 pm-to-solo.md 时，必须同时读取"业务上下文摘要"章节**，理解 AC 背后的业务约束
   - 读取后跳到流程第 3 步（技术方案探索），跳过第 1-2 步的需求探索
2. **产品文档**：如 `docs/product/PROJECT.md` 存在且已填写，读取作为需求输入
   - PROJECT.md 是静态需求定义（立项时写），FEATURES.md 是动态状态看板（开发中更新）
   - 读取后跳到流程第 2 步（宪法检查），跳过第 1 步的需求探索
3. **用户对话**：如以上都不存在，按下方流程与用户结构化探索需求

## 流程

1. **理解需求**
   用结构化问答明确：
   - 要解决什么问题？（用户痛点）
   - 给谁用？（目标用户）
   - 怎么算成功？（验收标准，可测试的描述）
   - 不做什么？（明确边界，避免范围蔓延）

2. **宪法检查**
   读 `constitution.md`，检查需求是否违反项目宪法：
   - 是否引入新依赖？（零新依赖原则；如需引入，走 `dependency-management` skill 审批流程）
   - 是否涉及 API？（必须有测试计划）
   - 是否涉及 schema 变更？（必须有迁移脚本，走 `migration` skill）

3. **技术可行性**
   评估现有代码是否能支撑：
   - 有没有可复用的模块？
   - 需要新增哪些文件/模块？
   - 有没有已知的技术风险？
   - **业务上下文约束检查**（如有 pm-to-solo.md 的业务上下文摘要）：
     - 技术方案是否满足摘要中的工程约束？（如"5GB 导出需异步队列"）
     - 如发现 AC 与业务约束有矛盾，**主动提出**而非盲目实现 AC
     - 将业务约束写入 PROJECT.md 的技术方案说明中，作为架构决策依据

4. **输出设计文档**
   根据输入来源决定写入策略：
   - **有交接文档**：从交接文档提取需求，写入 `docs/product/PROJECT.md`（PROJECT.md 始终由 brainstorming 维护，harness-pm 产出的是交接文档而非 PROJECT.md），同时在交接文档的"未决事项"或单独的 `docs/engineering/TECH_NOTES.md` 中补充技术方案
   - **无交接文档**：将确认的需求写入 `docs/product/PROJECT.md`
     - 如 `docs/product/` 目录不存在，先用工具创建（不用 `mkdir -p`，跨平台用 Agent 工具）
     - 文件不存在则创建，存在则追加/更新对应功能行（追加修订记录）
   - 写入内容包含：
     - 功能描述（一句话）
     - 验收标准（AC-xxx，可测试）
     - 技术方案（简要）
     - 不做的事（边界）

5. **硬门检查**
   逐条确认：
   - [ ] 需求是否清晰？（能用一句话说清楚）
   - [ ] 验收标准是否可测试？（不是"好用"，而是"输入X返回Y"）
   - [ ] 宪法是否合规？
   - [ ] 用户是否确认？

   **任何一条不满足 → 停下来问用户，不许往下走**

## 禁止事项
- 需求没问清楚就动手（最常见的中型项目翻车原因）
- 验收标准写成"系统应该好用"这种不可测试的描述
- 跳过宪法检查
- 自己替用户做需求决策

## 与 LOOP 的关系
本 skill 在 LOOP 的 PLAN 阶段之前执行，是 PLAN 的前置门。
brainstorming（硬门）→ writing-plans（PLAN）→ LOOP(tdd→verify) → ...
