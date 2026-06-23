---
workflow_id: F
name: design-handoff
default_mode: skip
---

# Workflow: design-handoff

> 设计交付工作流 · 设计到工程的交接
>
> **职责边界**：本工作流只负责交付物生成 + Pre-Delivery Checklist。
> 信任前置 workflow（new-design / design-iteration / redesign）的 LOOP 外门禁结果
> （design-review + accessibility-audit 已通过），不重复跑审查。

## 适用场景

- 设计阶段完成，需要交接给工程
- 前置 workflow 的 LOOP 外门禁已通过（design-review + accessibility-audit）
- 产出工程可消费的交付物

## 前置条件（硬门）

进入本工作流前，必须确认以下前置条件已满足：

- [ ] 前置 workflow（new-design / design-iteration / redesign）已完成
- [ ] LOOP 内 verify + design-lint 全部通过（证据：`loops/specs/<task>/lint-report.md` 无 error）
- [ ] LOOP 外 design-review 通过（证据：`loops/specs/<task>/evidence.md` 含"通过"结论）
- [ ] LOOP 外 accessibility-audit 通过（证据：`docs/visual/accessibility-report.md` 无 Critical 不通过项）

**硬门未通过**：不进入交付，回到前置 workflow 补审查。

## 编排

```
session-start
  → 前置条件检查（硬门）
  → design-handoff-spec（生成交付规格 + Pre-Delivery Checklist）
  → session-end
```

## 详细步骤

### 1. session-start

读取 `memory/progress.md`，恢复上下文。

### 2. 前置条件检查（硬门）

逐项核对前置条件 4 项检查：

- 读取 `loops/specs/<task>/lint-report.md`，确认无 error 级违规
- 读取 `loops/specs/<task>/evidence.md`，确认 design-review 结论为"通过"
- 读取 `docs/visual/accessibility-report.md`，确认无 Critical 不通过项
- 读取 `loops/specs/<task>/state.yaml`，确认 status 非 failed

任一不满足 → 停止，回到前置 workflow 补审查。

### 3. design-handoff-spec

生成交付物：

- 汇总 visual/interaction/prototype 产出
- 生成 `docs/handoff/design-to-solo.md`（人类可读完整说明）
- 生成 `docs/interaction/component-spec.md`（组件 props/状态/变体表）
- 生成 `docs/handoff/component-map.json`（显式映射层，Stitch 核心创新）
- 生成 `docs/prototype/flow.md`（交互流程图）
- 复制 `docs/design-system/tokens.json` + `tokens.css` 到交付目录

执行 Pre-Delivery Checklist（6 项）：

- [ ] 运行 UX 验证扫描（Grep ux-guidelines.csv 的 animation/accessibility/z-index/loading）
- [ ] 过一遍 Common Rules §1-§3（CRITICAL + HIGH 级别）
- [ ] 在 375px（小手机）和横屏下测试
- [ ] 开启 reduced-motion 验证
- [ ] 独立验证暗色模式对比度
- [ ] 确认所有触控目标 ≥44pt

### 4. session-end

更新 `memory/progress.md`，归档会话。

## 产出物

| 文件 | 说明 |
|------|------|
| docs/handoff/design-to-solo.md | 人类可读完整说明 |
| docs/handoff/component-map.json | 显式映射层（设计→工程） |
| docs/interaction/component-spec.md | 组件规格 |
| docs/prototype/flow.md | 交互流程图 |

## 退出条件

- 前置条件硬门全部通过
- 所有交付物已生成
- Pre-Delivery Checklist 全部 ✓
- component-map.json 合法且含 states 字段
