---
workflow_id: A
name: setup
default_mode: skip
---

# Workflow: setup

> 项目初始化工作流 · 首次使用 harness-design 时执行

## 适用场景

- 首次在项目中使用 harness-design
- 需要初始化设计系统
- 项目无 DESIGN.md

## 编排

```
session-start
  → design-brief（硬门）
  → design-recommendation（数据驱动推荐）
  → design-system（创建 DESIGN.md 10 段 + token）
  → session-end
```

## 详细步骤

### 1. session-start

读取 `memory/progress.md`，恢复上下文。

### 2. design-brief（硬门）

- Surface Assumptions
- 产品类型识别
- 需求 4 要素抽取
- Vibe Translation
- 审美方向选择
- Reframe（产出 AC-xxx 列表）
- Anti AI-Slop 字段
- 输出 `docs/visual/DESIGN_BRIEF.md`（含 AC-xxx）

**硬门**：DESIGN_BRIEF.md 未生成或不完整，不进入下一步。

### 3. design-recommendation

- 读取 DESIGN_BRIEF.md 的产品类型
- Grep reasoning.csv + products.csv + styles.csv + colors.csv + typography.csv + landing.csv
- 应用 decision_rules
- 输出 `docs/design-system/RECOMMENDATION.md`

### 4. design-system

- 读取 RECOMMENDATION.md 作为基础
- 填充 DESIGN.md 10 段（含第 10 段 Semantic Vocabulary 固定模板）
- 导出 tokens.json + tokens.css
- 创建 pages/ 目录

### 5. session-end

更新 `memory/progress.md`，归档会话。

## 产出物

| 文件 | 说明 |
|------|------|
| docs/visual/DESIGN_BRIEF.md | 需求文档（含 AC-xxx） |
| docs/design-system/RECOMMENDATION.md | 设计推荐 |
| docs/design-system/DESIGN.md | 设计系统（10 段） |
| docs/design-system/tokens.json | Token（W3C 格式） |
| docs/design-system/tokens.css | Token（CSS） |
| docs/design-system/pages/ | 页面级覆盖目录 |

## 退出条件

- 所有产出物已生成
- DESIGN_BRIEF.md 通过硬门
- DESIGN.md 含 10 段
- tokens.json 符合 W3C 格式
