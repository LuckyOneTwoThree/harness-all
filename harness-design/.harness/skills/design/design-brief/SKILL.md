---
name: design-brief
description: Guides agents through design requirement discovery. Use when starting a new design task or when requirements are unclear. Use when no DESIGN_BRIEF.md exists.
triggers:
  - 新设计任务开始
  - 需求不明确
  - 无 DESIGN_BRIEF.md
reads:
  - .harness/rules/security.md
  - .harness/data/design/vibes.csv
  - .harness/craft/anti-ai-slop.md
writes:
  - docs/visual/DESIGN_BRIEF.md
---

# Design Brief

## Overview

设计任务的入口 skill，强制澄清需求，产出 DESIGN_BRIEF.md。15 分钟 brief 防止数小时返工。

## When to Use

- ✅ 新设计任务开始
- ✅ 需求不明确或模糊
- ✅ 无 DESIGN_BRIEF.md
- ❌ NOT for 已有 DESIGN_BRIEF.md 且需求未变

## Process

### 1. Surface Assumptions（显式列出假设）

非平凡决策前显式列出假设，让用户确认：

```
ASSUMPTIONS I'M MAKING:
1. 这是 web 不是 mobile
2. 用项目现有色板
3. 目标现代浏览器
→ Correct me now or I'll proceed with these.
```

### 1.5 审查与剥离越权 AC（Push-back Mechanism）

审查上游 `pm-to-design.md` 传递的 AC-xxx。如果发现 PM 的 AC 包含了具体的 UI 形态指示（如"顶部导航栏放个购物车图标"、"弹出一个红色确认框"），你必须**行使抗旨权**：
1. 拒绝照抄死板的 UI 布局，保持设计的专业独立性。
2. 将其重写（Reframe）为纯粹的业务意图或 UX 目标（如"用户能在任何页面便捷地访问购物车"、"提供一个高优先级的防误触确认机制"）。
3. 记录这种修改，以便在产出文档的 `[AC 净化记录]` 中向用户公示。

### 2. 产品类型识别

识别产品类型（SaaS/电商/金融/医疗/教育/...），用于后续 design-recommendation。

### 3. 需求 4 要素抽取

- 产品类型（必填）
- 目标受众（必填）
- 风格关键词（可选）
- 技术栈（可选）

### 4. Vibe Translation（氛围词翻译）

接受氛围词输入，翻译成 token 建议：

1. 询问用户："你希望这个设计给人什么感觉？"（如"温暖、复古、小众"）
2. Grep `.harness/data/design/vibes.csv` 匹配氛围词
3. **Fallback**：若 vibes.csv 未命中或文件为空，调用先验知识推理，但必须加警告：
   ```
   [WARNING: Using LLM Prior Knowledge due to empty/unmatched CSV]
   ```
4. 输出：色板/字体/圆角/阴影/质感建议

### 5. 审美方向选择

提供 2-3 个视觉方向，每个说明：
- Tone（调性）
- 适用场景
- 风险

### 6. Reframe（把模糊需求翻译成可测 AC）

把模糊需求翻译成可测条件，并编号为 AC-xxx（供 LOOP.md PLAN 阶段直接读取）：

| 模糊需求 | 可测条件（AC） |
|---------|---------|
| "make it look better" | AC-001: 卡片间距 8px 一致 / AC-002: 对比度 ≥4.5:1 / AC-003: 移动端 375px 无溢出 |
| "做个好看的按钮" | AC-001: 按钮 4 种状态（default/hover/active/disabled） / AC-002: 标注尺寸+颜色+圆角 |
| "这个页面要现代" | AC-001: 页面用 12 栅格 / AC-002: 主色 #xxx / AC-003: 间距 8px 基准 |

**AC 编号规则**：
- 格式：`AC-<3位数字>`（如 AC-001、AC-002）
- 全局唯一（同一 DESIGN_BRIEF.md 内不重复）
- 每条 AC 必须可验证（含具体数值/条件/状态）

### 7. Anti AI-Slop 显式字段

在 DESIGN_BRIEF.md 增加 Anti AI-Slop Requirements 字段，引用 craft/anti-ai-slop.md。

### 8. 宪法检查

检查是否违反 constitution.md。

### 9. 输出

写入 `docs/visual/DESIGN_BRIEF.md`，格式见下方。

## DESIGN_BRIEF.md 输出格式

```markdown
# Design Brief

## Product Type
<识别结果>

## Target Audience
<目标用户>

## Style Keywords
<风格关键词>

## Tech Stack
<技术栈>

## Vibe Translation
- 输入氛围词：<用户输入>
- 推荐色板：<从 vibes.csv 匹配或先验知识>
- 推荐字体：<...>
- 推荐圆角：<...>
- 推荐阴影：<...>

## Aesthetic Direction
<2-3 个视觉方向，用户选择>

## Reframed Success Criteria
- AC-001: <可测条件1>
- AC-002: <可测条件2>
- AC-003: <可测条件3>

## AC 净化记录 (Push-back Log)
> 记录被设计侧拒绝并重写的越权 UI 指令
- 原 AC-xxx: <PM的死板指令> → 重写为: <纯粹的UX目标>

## Anti AI-Slop Requirements
- 禁止：紫蓝渐变 / 对称三列 / emoji 图标 / Inter 字体
- 要求：用项目设计系统的字体和色板

## Assumptions
1. <假设1>
2. <假设2>
```

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "需求很清楚，直接开始设计吧" | 15 分钟 brief 防止数小时返工 |
| "用户说的就是想要的" | 用户说的是解决方案不是需求，要 Reframe |
| "氛围词太主观没法落地" | Vibe Translation 把氛围词翻译成可执行 token |
| "假设很明显不用列" | 不显式列出的假设会被 Agent 静默填空，导致方向偏差 |

## Red Flags

- 跳过 Surface Assumptions 直接开始设计
- 全盘照抄包含死板 UI 指令的上游 AC（放弃了设计的专业判断）
- 用模糊需求作为验收标准
- 未识别产品类型就进入设计
- 未提供 Anti AI-Slop 字段

## Verification

- [ ] DESIGN_BRIEF.md 包含 4 要素（证据：文件存在且字段齐全）
- [ ] 假设已显式列出并经用户确认（证据：对话记录）
- [ ] 审美方向有 2-3 个选项（证据：文件内容）
- [ ] Vibe Translation 有输出（证据：文件内容，若用先验知识有 WARNING 标签）
- [ ] Anti AI-Slop Requirements 字段存在（证据：文件内容）
- [ ] 若存在上游越权 AC，已执行剥离并记录在"AC 净化记录"中（证据：文件内容）
- [ ] Reframed Success Criteria 可测且编号为 AC-xxx（证据：每条含 AC 编号 + 具体数值/条件）

## 与 LOOP 的关系

- 不在 LOOP 内运行（在 LOOP 前的 design-brief 阶段运行）
- 产出的 AC-xxx 列表供 LOOP.md PLAN 阶段直接读取写入 spec.md
- 产出的 Aesthetic Direction 供 visual-design skill 读取
- 产出的 Anti AI-Slop Requirements 供 design-lint skill 检查
