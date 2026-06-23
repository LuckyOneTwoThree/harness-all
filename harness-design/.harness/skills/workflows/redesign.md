---
workflow_id: D
name: redesign
default_mode: deep
---

# Workflow: redesign

> 重设计工作流 · 已有项目的重设计

## 适用场景

- 已有项目需要重设计
- 现有设计系统需要升级
- 技术栈迁移后的设计重构

## 编排

```
session-start
  → design-brief（硬门）
  → design-system-import（从现有代码导入）
  → 差异分析
  → PLAN（内联，初始化 LOOP state）
  → LOOP(visual-design → verify → design-lint)        [visual-design, max 5]（必跑）
  → LOOP(interaction-design → verify → design-lint)   [interaction-design, max 5]（条件性）
  → design-review（LOOP 外门禁）
  → accessibility-audit（LOOP 外门禁）
  → session-end
```

**interaction-design LOOP 触发条件**（满足任一即跑）：
- AC-xxx 中含交互相关验收标准（状态/动效/键盘导航/触控目标）
- 重设计涉及交互组件（Button/Input/Modal/Dropdown/Toast 等）
- 重设计涉及动效参数（时长/缓动/状态转换）

若重设计仅涉及视觉（配色/间距/字体/布局），跳过 interaction-design LOOP。

## 详细步骤

### 1. session-start

读取 `memory/progress.md`，恢复上下文。

### 2. design-brief（硬门）

- 重设计目标
- 现有设计的问题
- 期望的改进方向
- 产出 `docs/visual/DESIGN_BRIEF.md`（含 AC-xxx）

### 3. design-system-import

- 检测项目技术栈
- 读取配置文件（tailwind.config.js / theme.ts / globals.css）
- 抽取 token
- 生成 DESIGN.md 10 段
- 生成 tokens.json + tokens.css
- 输出 IMPORT_REPORT.md

### 4. 差异分析

对比现有设计系统与重设计目标：

```markdown
# Redesign Diff Analysis

## 现有设计系统
- 色板：<...>
- 字体：<...>
- 组件：<...>

## 重设计目标
- 色板：<...>
- 字体：<...>
- 组件：<...>

## 差异
| 维度 | 现有 | 目标 | 变更范围 |
|------|------|------|---------|
| 色板 | <...> | <...> | 全局替换 |
| 字体 | <...> | <...> | 全局替换 |
| 组件 | <...> | <...> | 部分重构 |

## 影响范围
- 涉及页面：<...>
- 涉及组件：<...>
```

### 5. PLAN（内联，无独立 skill）

- 基于差异分析定义重设计 AC-xxx
- 宪法检查
- 初始化 `loops/specs/<task>/state.yaml`（stage=plan, iteration=0, status=running）
- 写入 `loops/specs/<task>/spec.md`（含 AC 列表）

### 6. LOOP: visual-design（max 5，类型 visual-design）

```
visual-design → verify → design-lint
  ↑                          |
  └──── 失败回到 visual-design ┘
```

- 基于差异分析，产出新视觉设计
- verify/design-lint 失败 → 回到 visual-design，iteration +1
- 超过 5 次迭代 → 请求人类介入

### 7. LOOP: interaction-design（max 5，条件性）

**触发条件**：见编排章节的"interaction-design LOOP 触发条件"。若不触发则跳过本步。

```
interaction-design → verify → design-lint
  ↑                          |
  └──── 失败回到 interaction-design ┘
```

- 基于新视觉设计，更新组件状态/动效参数
- verify/design-lint 失败 → 回到 interaction-design，iteration +1

### 8. design-review（LOOP 外门禁）

- Five-Axis Review
- Doubt-Driven（仅 Critical 触发对抗辩论）
- 重点审查：重设计是否破坏现有用户体验
- 输出 `loops/specs/<task>/evidence.md`
- 不通过 → 回到 LOOP（可修复）或 PLAN（需重新规划）

### 9. accessibility-audit（LOOP 外门禁）

- WCAG 2.1 AA 全项检查
- 不通过 → 回到 LOOP

### 10. session-end

更新 `memory/progress.md`，归档会话。

## 产出物

| 文件 | 说明 |
|------|------|
| docs/visual/DESIGN_BRIEF.md | 重设计需求（含 AC-xxx） |
| docs/design-system/IMPORT_REPORT.md | 导入报告 |
| docs/design-system/DESIGN.md | 更新后的设计系统 |
| docs/design-system/tokens.json | 更新后的 token |
| loops/specs/<task>/spec.md | 重设计规格（含 AC 列表） |
| loops/specs/<task>/state.yaml | 循环状态 |
| loops/specs/<task>/evidence.md | 验证证据 |
| loops/specs/<task>/iterations.log | 迭代历史 |
| loops/specs/<task>/lint-report.md | Lint 报告 |
| docs/visual/<page>.md | 重设计后的视觉稿 |
| docs/interaction/<page>.md | 更新后的交互设计（若触发 interaction LOOP） |

## 退出条件

- design-system-import 完成
- 差异分析完成
- LOOP 通过（verify + lint）
- design-review 通过
- accessibility-audit 通过
- state.yaml status=done
