---
name: writing-plans
description: 任务拆解，输出可执行的 spec.md
triggers:
  - brainstorming 通过后
  - 多步骤任务开始前
  - 进入 LOOP 的 PLAN 阶段时
reads:
  - loops/LOOP.md
  - constitution.md
  - rules/security.md
  - docs/product/PROJECT.md
  - docs/handoff/pm-to-solo.md
  - docs/handoff/design-to-solo.md
  - docs/handoff/component-map.json
writes:
  - loops/specs/<feature>/spec.md
  - loops/specs/<feature>/state.yaml
---

# Writing Plans — 任务拆解

## 铁律
**先写规格再写代码。** 规格不清就开干 = 返工的根源。

## 流程

1. **创建功能目录**
   在 `.harness/loops/specs/` 下创建功能目录：
   ```
   .harness/loops/specs/<NNN>-<feature-name>/
   ```
   编号规则：NNN 为三位数字，按创建顺序递增（001, 002, ...）
   **查询下一个编号**：用 Glob 扫描 `.harness/loops/specs/*` 目录，取最大编号 +1。
   首次创建（目录为空）时从 001 开始。

2. **写 spec.md**
   包含以下部分：
   ```markdown
   # <功能名>

   ## 目标
   [一句话目标，来自 brainstorming]

   ## 验收标准

   ### 工程 AC（来自 pm-to-solo.md / brainstorming）
   - AC-001: [可测试的描述]
   - AC-002: [可测试的描述]

   ### 设计 AC（来自 design-to-solo.md，如涉及前端）
   - DAC-001: [设计可测试描述，如"对比度 ≥4.5:1"]
   - DAC-002: [设计可测试描述，如"375px 无溢出"]

   ## 任务拆解
   - [ ] T1: [任务1，2-5分钟能完成]
   - [ ] T2: [任务2]
   - [ ] T3: [任务3]

   ## 技术方案
   [简要：改哪些文件、新增什么模块、关键设计决策]

   ## 不做的事
   [明确边界，避免范围蔓延]
   ```

   **AC 来源说明**：
   - 工程 AC（AC-xxx）：来自 PRD 或 brainstorming，描述功能行为
   - 设计 AC（DAC-xxx）：来自 `docs/handoff/design-to-solo.md`，描述视觉/交互约束
   - 如无 design-to-solo.md，跳过设计 AC 章节
   - DAC 编号沿用 design-to-solo.md 的 AC-xxx 编号，加 D 前缀以区分来源

3. **任务粒度控制**
   每个任务应该是：
   - 2-5 分钟能完成（太大就继续拆）
   - 可独立验证（完成后能跑测试确认）
   - 有明确产出（代码/测试/配置）

4. **初始化 state.yaml**
   按 `loops/LOOP.md` 的 "state.yaml Schema" 章节定义的字段初始化：
   ```yaml
   current_feature: <NNN>-<feature-name>
   iteration: 0
   stage: plan
   status: running
   last_error: ""
   started_at: "YYYY-MM-DDTHH:MM:SS"
   ```
   字段含义和枚举值见 LOOP.md，本 SKILL.md 不重复定义。

5. **宪法复核**
   检查任务拆解是否符合宪法：
   - 每个新增依赖是否经过审批？
   - 新增 API 是否有测试任务？
   - schema 变更是否有迁移脚本任务？

## 禁止事项
- 任务粒度过大（"实现用户系统"不是任务，是史诗）
- 验收标准不可测试
- 跳过 state.yaml 初始化（LOOP 无法断点续传）
- spec.md 写完就不更新（执行中发现 spec 错了要回头改）

## 与 LOOP 的关系
本 skill 对应 LOOP 的 PLAN 阶段。
- 输出 spec.md = PLAN 的产物
- 初始化 state.yaml = LOOP 的起点
- writing-plans → LOOP(tdd→verify) → 失败回到 writing-plans 重新规划
