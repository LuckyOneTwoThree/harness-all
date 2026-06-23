---
workflow_id: B
name: new-design
default_mode: deep
---

# Workflow: new-design

> 新设计任务工作流 · 核心工作流

## 适用场景

- 新页面/组件设计任务
- 需求明确，从零开始设计
- 项目已有设计系统

## 编排

```
session-start
  → design-brief（硬门）
  → PLAN（内联，初始化 LOOP state）
  → LOOP(wireframe → verify → design-lint)            [wireframe, max 5]
  → LOOP(visual-design → verify → design-lint)        [visual-design, max 5]
  → LOOP(interaction-design → verify → design-lint)   [interaction-design, max 5]
  → design-review（LOOP 外门禁）
  → accessibility-audit（LOOP 外门禁）
  → session-end
```

**顺序原则**：先结构（wireframe）→ 再视觉（visual）→ 再交互（interaction）。
在错误结构上做视觉设计是浪费时间，在错误视觉上做交互设计同理。

## 详细步骤

### 1. session-start

读取 `memory/progress.md`，恢复上下文。

### 2. design-brief（硬门）

- 产出 `docs/visual/DESIGN_BRIEF.md`（含 AC-xxx 列表）
- 硬门：未通过不进入下一步

### 3. PLAN（内联，无独立 skill）

- 读取 DESIGN_BRIEF.md 的 AC-xxx 列表
- 宪法检查
- 初始化 `loops/specs/<task>/state.yaml`（stage=plan, iteration=0, status=running）
- 写入 `loops/specs/<task>/spec.md`（含 AC 列表）

### 4. LOOP 1: wireframe（max 5）

```
wireframe → verify → design-lint
  ↑                       |
  └── 失败回到 wireframe ──┘
```

- **wireframe**：低保真线框图（黑白灰，验证结构）
- **verify**：结构完整性检查 + AC 检查
- **design-lint**：机械规则检查
- 失败 → 回到 wireframe，iteration +1
- 超过 5 次迭代 → 请求人类介入

### 5. LOOP 2: visual-design（max 5）

```
visual-design → verify → design-lint
  ↑                          |
  └──── 失败回到 visual-design ┘
```

- **visual-design**：基于已批准的线框图，产出 2-3 个视觉方案，用户选择后写入 docs/visual/
- **verify**：AC 逐条检查 + 宪法 + 可访问性快速检查
- **design-lint**：编写并运行 Node.js 脚本，机械规则检查
- verify 或 design-lint 失败 → 回到 visual-design，iteration +1
- 超过 5 次迭代 → 请求人类介入

### 6. LOOP 3: interaction-design（max 5）

```
interaction-design → verify → design-lint
  ↑                          |
  └──── 失败回到 interaction-design ┘
```

- **interaction-design**：基于已批准的视觉设计，产出组件状态 + 状态转换 + 动效参数
- **verify**：AC 检查 + 键盘导航检查
- **design-lint**：机械规则检查
- 失败 → 回到 interaction-design，iteration +1

### 7. design-review（LOOP 外门禁）

- Five-Axis Review（5 轴）
- Doubt-Driven（仅 Critical 触发对抗辩论，Nit/FYI 直接记录）
- Severity Labeling
- 输出 `loops/specs/<task>/evidence.md`
- 不通过 → 回到 LOOP（可修复）或 PLAN（需重新规划）

### 8. accessibility-audit（LOOP 外门禁）

- WCAG 2.1 AA 全项检查
- 不通过 → 回到 LOOP

### 9. session-end

更新 `memory/progress.md`，归档会话。

## 产出物

| 文件 | 说明 |
|------|------|
| docs/visual/DESIGN_BRIEF.md | 需求文档（含 AC-xxx） |
| docs/prototype/wireframe.md | 线框图（结构验证） |
| docs/visual/<page>.md | 视觉设计 |
| docs/interaction/<page>.md | 交互设计 |
| loops/specs/<task>/spec.md | 设计规格（含 AC 列表） |
| loops/specs/<task>/state.yaml | 循环状态 |
| loops/specs/<task>/evidence.md | 验证证据 |
| loops/specs/<task>/iterations.log | 迭代历史 |
| loops/specs/<task>/lint-report.md | Lint 报告 |

## 退出条件

- 3 个 LOOP 全部通过（verify + lint）
- design-review 通过
- accessibility-audit 通过
- evidence.md 含审查结论"通过"
- state.yaml status=done
