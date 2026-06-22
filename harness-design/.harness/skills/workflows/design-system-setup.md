# Workflow: design-system-setup

> 设计系统建设工作流 · 从零建设计系统

## 适用场景

- 项目无设计系统
- 需要建立完整设计系统
- 设计系统建设后供所有页面引用

## 编排

```
session-start
  → design-brief（硬门，识别产品类型）
  → design-recommendation（数据驱动推荐）
  → design-system（创建 DESIGN.md 10 段 + token）
  → PLAN（内联，初始化 LOOP state）
  → LOOP(component-design → verify → design-lint)  [component, max 5]
  → design-review（LOOP 外门禁）
  → session-end
```

## 详细步骤

### 1. session-start

读取 `memory/progress.md`，恢复上下文。

### 2. design-brief（硬门）

- 识别产品类型（用于 design-recommendation）
- 定义设计系统建设的 AC-xxx
- 产出 `docs/visual/DESIGN_BRIEF.md`

### 3. design-recommendation

- 读取 DESIGN_BRIEF.md 的产品类型
- Grep reasoning.csv + products.csv + styles.csv + colors.csv + typography.csv + landing.csv
- 输出 `docs/design-system/RECOMMENDATION.md`

### 4. design-system

- 读取 RECOMMENDATION.md 作为基础
- 填充 DESIGN.md 10 段（含第 10 段 Semantic Vocabulary 固定模板）
- 导出 tokens.json + tokens.css
- 创建 pages/ 目录

### 5. PLAN（内联，无独立 skill）

- 基于 DESIGN.md 第 10 段 Semantic Vocabulary 提取组件清单
- 定义每个组件的 AC-xxx
- 宪法检查
- 初始化 `loops/specs/<task>/state.yaml`（stage=plan, iteration=0, status=running）
- 写入 `loops/specs/<task>/spec.md`（含 AC 列表）

### 6. LOOP: component-design（max 5，类型 component）

对每个核心组件（Button/Input/Card/Modal 等）执行：

```
component-design → verify → design-lint
  ↑                          |
  └──── 失败回到 component-design ┘
```

- **component-design**：基于设计系统设计组件（状态/变体/尺寸/组合规则）
- **verify**：组件完整性检查（Props/States/Variants/Sizes/Composition/Accessibility）
- **design-lint**：token 一致性检查（L001-L015）
- 失败 → 回到 component-design，iteration +1
- 超过 5 次迭代 → 请求人类介入

### 7. design-review（LOOP 外门禁）

- Five-Axis Review（重点：组件一致性轴）
- Doubt-Driven（仅 Critical 触发对抗辩论）
- 输出 `loops/specs/<task>/evidence.md`
- 不通过 → 回到 LOOP（可修复）或 PLAN（需重新规划）

### 8. session-end

更新 `memory/progress.md`，归档会话。

## 产出物

| 文件 | 说明 |
|------|------|
| docs/visual/DESIGN_BRIEF.md | 需求文档（含产品类型 + AC-xxx） |
| docs/design-system/RECOMMENDATION.md | 设计推荐 |
| docs/design-system/DESIGN.md | 设计系统（10 段） |
| docs/design-system/tokens.json | Token（W3C 格式） |
| docs/design-system/tokens.css | Token（CSS） |
| docs/design-system/pages/ | 页面级覆盖目录 |
| docs/design-system/components/<Component>.md | 组件设计稿 |
| loops/specs/<task>/spec.md | 设计规格（含 AC 列表） |
| loops/specs/<task>/state.yaml | 循环状态 |
| loops/specs/<task>/evidence.md | 验证证据 |
| loops/specs/<task>/iterations.log | 迭代历史 |
| loops/specs/<task>/lint-report.md | Lint 报告 |

## 退出条件

- DESIGN.md 含 10 段
- tokens.json 符合 W3C 格式
- 核心组件（Button/Input/Card/Modal）全部设计完成
- LOOP 通过（verify + lint）
- design-review 通过
- state.yaml status=done
