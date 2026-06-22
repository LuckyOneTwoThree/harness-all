---
name: design-review
description: Performs final human-level design review with Five-Axis and Doubt-Driven approach. Use after LOOP passes. Use before design-handoff.
triggers:
  - LOOP 通过后的最终审查
  - design-handoff 之前
  - 需要人工级综合审查
reads:
  - .harness/craft/anti-ai-slop.md
  - .harness/craft/common-rules.md
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/visual/
  - docs/interaction/
  - docs/prototype/
  - loops/specs/<task>/spec.md
  - loops/specs/<task>/lint-report.md
writes:
  - loops/specs/<task>/evidence.md
---

# Design Review

## Overview

最终人工级综合审查，Five-Axis + Doubt-Driven。"看起来对"永远不够，必须有证据。

## When to Use

- ✅ LOOP 通过后的最终审查
- ✅ design-handoff 之前
- ✅ 需要人工级综合审查
- ❌ NOT for LOOP 内快速检查（用 verify skill）
- ❌ NOT for 机械规则检查（用 design-lint skill）

## Process

### 1. Five-Axis Review（五轴审查）

逐轴检查：

#### 轴 1：视觉层级
- 每屏 1 个焦点？
- 视觉权重分布合理？
- 用字重/字号/颜色建立层级（不用标题下强调线）？

#### 轴 2：间距与对齐
- spacing scale 一致？
- 对齐基线一致？
- 4/8dp 间距节奏？

#### 轴 3：色彩与对比度
- token 一致？
- WCAG AA 合规（正文 ≥4.5:1）？
- accent 每屏 ≤2 次？

#### 轴 4：组件一致性
- 遵循设计系统？
- 同语义组件 ≤3 种实现？
- 组件状态完整？

#### 轴 5：可访问性
- 键盘导航可用？
- 焦点可见？
- 屏幕阅读器友好？

### 2. Doubt-Driven 对抗式审查

**Severity 与退出条件强绑定**（防扯皮）：
- `Critical` 级别：触发对抗辩论
- `Nit` / `FYI` 级别：直接记录，不辩论

#### 对 Critical 级别的 CLAIM → EXTRACT → DOUBT → RECONCILE → STOP

**CLAIM**（2-3 行写明设计决策 + 为什么重要）：
```
CLAIM: 这个卡片的视觉层级正确，标题用 text-2xl + 700，正文用 text-base + 400。
重要性：建立视觉焦点，引导用户阅读顺序。
```

**EXTRACT**（抽出最小可审查单元，剥离推理）：
- Artifact：卡片设计稿
- Contract：标题 text-2xl/700，正文 text-base/400
- **不传 CLAIM**（防止 reviewer 偏置）

**DOUBT**（启动子 agent，fresh-context 对抗式审查）：
```
子 agent prompt: "Find what is wrong with this artifact. Assume the author is overconfident.
Do NOT validate. Do NOT summarize. Only report problems."
输入：Artifact + Contract（不传 CLAIM）
```

**RECONCILE**（按 4 类分类）：
1. Contract misread → 先修 contract
2. Valid + actionable → 改 artifact 重循环
3. Valid trade-off → 记录
4. Noise → 标注，问"加上下文能否避免误报"

**STOP**（有界循环）：
- 下一轮只返回 trivial 发现，或
- 已 3 轮，或
- 用户说 "ship it"
- 3 轮仍有 Critical = artifact 未就绪，升级给用户

**Doubt Theater 信号**：连续 2+ 轮 reviewer 都报出实质问题，但零条被分类为 actionable——你在 validate 不是 doubt，停止升级。

### 3. Severity Labeling

每条发现标注 severity：

| Severity | 含义 | 处理 |
|----------|------|------|
| `Critical:` | 阻塞（如对比度不达标） | 必须修，触发对抗辩论 |
| 无前缀 | 必须改 | 必须修，不辩论 |
| `Nit:` | 可选（风格偏好） | 直接记录，不辩论 |
| `FYI` | 仅信息 | 直接记录，不辩论 |

### 4. 输出审查报告

写入 `loops/specs/<task>/evidence.md`：

```markdown
# Design Review Evidence

## Five-Axis Review

### 视觉层级
- ✓ 每屏 1 个焦点
- ✗ 标题下有强调线（违反 anti-ai-slop）

### 间距与对齐
- ✓ spacing scale 一致
- ✓ 对齐基线一致

## Doubt-Driven Review

### Critical 发现

#### C001: <发现标题>
- CLAIM: <设计决策>
- DOUBT: <reviewer 发现>
- RECONCILE: <分类 + 处理>

### Nit 发现（直接记录，不辩论）
- N001: <发现>
- N002: <发现>

### FYI（仅信息）
- F001: <发现>

## 审查结论
- [ ] 通过 / [ ] 不通过
- 不通过原因：<...>
```

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "看起来对就行" | "看起来对"永远不够，必须有证据 |
| "AI 生成的代码大概没问题" | AI 代码需要更多审查不是更少 |
| "测试通过了就行" | 测试必要不充分，不抓架构/安全/可读 |
| "Nit 级别也要辩论清楚" | Nit 直接记录不辩论，避免无限扯皮 |
| "reviewer 不同意就是我错了" | reviewer 缺你的上下文，分歧是信息不是判决 |

## Red Flags

- 跳过 Five-Axis 直接给结论
- 对 Nit/FYI 级别触发对抗辩论
- Doubt 循环超过 3 轮仍未停止
- 未启动子 agent 实现 fresh-context（在主上下文里"假装"对抗审查）

## Verification

- [ ] Five-Axis 逐轴检查完成（证据：evidence.md 含 5 轴）
- [ ] Critical 发现走了 CLAIM→EXTRACT→DOUBT→RECONCILE→STOP（证据：evidence.md 含流程记录）
- [ ] Nit/FYI 直接记录未辩论（证据：evidence.md 含 Nit/FYI 列表）
- [ ] Doubt 循环 ≤3 轮（证据：流程记录）
- [ ] fresh-context 通过子 agent 实现（证据：子 agent 调用记录）
- [ ] 审查结论明确（通过/不通过 + 原因）

## 与 LOOP 的关系

- 所属阶段：LOOP 外门禁（LOOP 退出后运行，与 accessibility-audit 并列）
- 不在 LOOP 内运行（避免每次迭代都启动子 agent 做 Doubt-Driven 对抗审查，成本过高）
- LOOP 内由 verify + design-lint 做快速检查，design-review 做最终人工级综合审查
- 失败时：可修复 → 回到 LOOP 重新 DESIGN；需重新规划 → 回到 PLAN
- 不消耗迭代次数（LOOP 外失败不计数）
- 通过后进入 accessibility-audit 或直接交付（视工作流配置）
