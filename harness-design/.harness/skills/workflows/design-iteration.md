---
workflow_id: C
name: design-iteration
default_mode: standard
---

# Workflow: design-iteration

> 设计迭代工作流 · 已有设计的修改

## 适用场景

- 修改已有设计
- 用户反馈后的迭代
- 设计优化

## 编排

```
session-start
  → Chesterton's Fence 分析（理解原设计）
  → PLAN（内联，初始化 LOOP state）
  → LOOP(visual-design → verify → design-lint)        [visual-design, max 5]（必跑）
  → LOOP(interaction-design → verify → design-lint)   [interaction-design, max 5]（条件性）
  → design-review（LOOP 外门禁）
  → accessibility-audit（LOOP 外门禁）
  → session-end
```

**interaction-design LOOP 触发条件**（满足任一即跑）：
- AC-xxx 中含交互相关验收标准（状态/动效/键盘导航/触控目标）
- 修改涉及交互组件（Button/Input/Modal/Dropdown/Toast 等）
- 修改涉及动效参数（时长/缓动/状态转换）

若 AC 仅涉及视觉（配色/间距/字体/布局），跳过 interaction-design LOOP。

## 详细步骤

### 1. session-start

读取 `memory/progress.md`，恢复上下文。

### 2. Chesterton's Fence 分析

**改前先理解原设计**（来自 addyosmani code-simplification）：

回答以下问题，答不出就没准备好改：
- 原设计为何这样？（设计意图）
- 调用关系？（被哪些页面引用）
- 边界？（与哪些组件交互）
- 为何这样设计？（性能？平台约束？历史原因？）

输出 `loops/specs/<task>/context-analysis.md`：

```markdown
# Context Analysis (Chesterton's Fence)

## 原设计意图
<...>

## 调用关系
- 被引用于：<页面列表>
- 依赖：<组件列表>

## 边界
- 与 <组件> 交互
- 受 <约束> 限制

## 为何这样设计
- <原因1>
- <原因2>

## 修改范围
- 只动：<...>
- 不动：<...>

## NOTICED BUT NOT TOUCHING
- <发现但不在本次任务范围的无关问题>
- <要建任务吗？>
```

### 3. PLAN（内联，无独立 skill）

- 基于 Chesterton's Fence 分析定义迭代目标 + AC-xxx
- 宪法检查
- 初始化 `loops/specs/<task>/state.yaml`（stage=plan, iteration=0, status=running）
- 写入 `loops/specs/<task>/spec.md`（含 AC 列表）

### 4. LOOP: visual-design（max 5）

```
visual-design → verify → design-lint
  ↑                          |
  └──── 失败回到 visual-design ┘
```

- **Scope Discipline**：只动任务要求的，发现无关问题用 "NOTICED BUT NOT TOUCHING" 列表记录
- verify/design-lint 失败 → 回到 visual-design，iteration +1
- 超过 5 次迭代 → 请求人类介入

### 5. LOOP: interaction-design（max 5，条件性）

**触发条件**：见编排章节的"interaction-design LOOP 触发条件"。若不触发则跳过本步。

```
interaction-design → verify → design-lint
  ↑                          |
  └──── 失败回到 interaction-design ┘
```

- 基于已迭代的视觉设计，更新组件状态/动效参数
- verify/design-lint 失败 → 回到 interaction-design，iteration +1

### 6. design-review（LOOP 外门禁）

- Five-Axis Review
- Doubt-Driven（仅 Critical 触发对抗辩论）
- 对比 before/after
- 输出 `loops/specs/<task>/evidence.md`
- 不通过 → 回到 LOOP（可修复）或 PLAN（需重新规划）

### 7. accessibility-audit（LOOP 外门禁）

- WCAG 2.1 AA 全项检查
- 不通过 → 回到 LOOP

### 8. session-end

更新 `memory/progress.md`，归档会话。

## 产出物

| 文件 | 说明 |
|------|------|
| loops/specs/<task>/context-analysis.md | Chesterton's Fence 分析 |
| loops/specs/<task>/spec.md | 迭代规格（含 AC-xxx） |
| docs/visual/<page>.md | 更新后的视觉设计 |
| docs/interaction/<page>.md | 更新后的交互设计（若触发 interaction LOOP） |
| loops/specs/<task>/state.yaml | 循环状态 |
| loops/specs/<task>/evidence.md | 验证证据 |
| loops/specs/<task>/iterations.log | 迭代历史 |
| loops/specs/<task>/lint-report.md | Lint 报告 |

## 退出条件

- Chesterton's Fence 分析完成
- LOOP 通过（verify + lint）
- design-review 通过
- accessibility-audit 通过
- before/after 对比已记录
- state.yaml status=done
