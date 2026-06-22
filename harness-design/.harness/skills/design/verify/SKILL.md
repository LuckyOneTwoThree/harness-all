---
name: verify
description: Performs quick in-LOOP verification against acceptance criteria and constitution. Use in every LOOP iteration. Use before design-lint.
triggers:
  - LOOP 内每次迭代
  - design-lint 之前
  - 需要快速验证
reads:
  - loops/specs/<task>/spec.md
  - loops/specs/<task>/state.yaml
  - constitution.md
  - docs/visual/DESIGN_BRIEF.md
  - docs/design-system/DESIGN.md
writes:
  - loops/specs/<task>/evidence.md
  - loops/specs/<task>/state.yaml
  - loops/specs/<task>/iterations.log
---

# Verify

## Overview

LOOP 内快速检查，每次迭代都跑。检查"设计对不对"，不检查"设计是否遵循设计系统"（后者由 design-lint 负责）。

## When to Use

- ✅ LOOP 内每次迭代
- ✅ design-lint 之前
- ✅ 需要快速验证（非深度审查）
- ❌ NOT for 机械规则检查（用 design-lint skill）
- ❌ NOT for 人工级综合审查（用 design-review skill）

## Process

### 1. 设计完整性检查

- 设计稿是否覆盖所有验收标准？
- 是否有遗漏的页面/组件/状态？

### 2. 验收标准逐条检查

读取 `loops/specs/<task>/spec.md` 的 AC-xxx，逐条标注 ✓/✗：

```
AC-001: 登录表单含邮箱+密码+提交按钮 → ✓
AC-002: 提交按钮有 4 种状态 → ✓
AC-003: 移动端 375px 无溢出 → ✗（密码输入框溢出）
```

### 3. 宪法合规检查

检查是否违反 `constitution.md` 的原则：
- 设计系统优先，不重复造组件
- 可访问性 WCAG 2.1 AA 是硬约束
- 移动优先，响应式必做

### 4. 可访问性快速检查

- 对比度（正文 ≥4.5:1）
- 键盘导航（Tab 顺序 + 焦点可见）

**注意**：仅快速检查，深度审查由 accessibility-audit skill 负责。

### 5. 可交付性快速检查

- 标注齐全（尺寸/颜色/圆角）
- 规格齐全（组件状态/变体）

### 6. 写入 evidence.md

```markdown
# Verify Evidence (Iteration <N>)

## 验收标准
- AC-001: ✓
- AC-002: ✓
- AC-003: ✗（密码输入框溢出）

## 宪法合规
- ✓ 设计系统优先
- ✓ WCAG 2.1 AA
- ✗ 移动优先（375px 溢出）

## 可访问性快速检查
- 对比度：✓
- 键盘导航：✓

## 可交付性快速检查
- 标注：✓
- 规格：✓

## 结论
- [ ] 通过 → 进入 design-lint
- [x] 不通过 → 回到 visual-design
- 失败原因：AC-003 未满足，375px 密码输入框溢出
```

### 7. 更新 state.yaml

```yaml
iteration: <N+1>
stage: verify
status: retrying  # 或 running（通过时）
last_error: "AC-003 未满足，375px 密码输入框溢出"  # 或 "" （通过时）
last_error_at: "<ISO 8601>"
```

### 8. 追加 iterations.log

```
[<timestamp>] iter=<N> stage=design → review FAILED: AC-003 未满足，375px 密码输入框溢出
```

## 失败处理

1. 将失败信息写入 `state.yaml` 的 `last_error`
2. 追加一行到 `iterations.log`
3. 分析失败原因：
   - 可修复（对比度不足、缺少状态）→ 回到 DESIGN
   - 需重新规划（需求理解错误、方向偏差）→ 回到 PLAN
4. 迭代次数 +1，检查是否超过最大迭代

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "看起来对就行" | "看起来对"永远不够，必须有证据 |
| "快速检查跳过吧" | 快速检查是 LOOP 的质量门，跳过会导致问题累积 |
| "AC 差不多满足" | AC 是逐条 ✓/✗，没有"差不多" |

## Red Flags

- 未逐条检查 AC
- 未写入 evidence.md
- 未更新 state.yaml
- 未追加 iterations.log
- 跳过可访问性快速检查

## Verification

- [ ] AC 逐条标注 ✓/✗（证据：evidence.md 含 AC 列表）
- [ ] 宪法合规检查（证据：evidence.md 含宪法检查）
- [ ] 可访问性快速检查（证据：evidence.md 含对比度/键盘）
- [ ] evidence.md 已写入（证据：文件存在）
- [ ] state.yaml 已更新（证据：iteration/stage/status 更新）
- [ ] iterations.log 已追加（证据：文件含新行）

## 与 LOOP 的关系

- 所属阶段：VERIFY（LOOP 内）
- 在所有循环类型的 LOOP 内运行，verify 之后运行 design-lint
- 流程：DESIGN → VERIFY → LINT
- verify 失败回到 DESIGN，design-lint 失败也回到 DESIGN
- 循环类型：所有循环类型（visual-design / interaction-design / wireframe / component）均适用
