---
name: design-lint
description: Mechanically verifies design against design system rules using script execution. Use after verify in LOOP. Use before design-review.
triggers:
  - LOOP 内 verify 之后
  - 设计稿需要机械规则检查
  - design-review 之前
reads:
  - .harness/craft/anti-ai-slop.md
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/visual/
  - docs/interaction/
  - docs/design-system/components/
writes:
  - loops/specs/<task>/lint-report.md
---

# Design Lint

## Overview

AI 设计 Linter，机械可验证规则检查，零主观判断。对照设计系统自身一致性，像 ESLint 捕获代码错误一样。

**关键**：真正的机械规则必须交给真正的代码执行，不是 LLM 脑补。Agent 编写并运行一次性 Node.js 脚本做正则扫描。

## When to Use

- ✅ LOOP 内 verify 之后
- ✅ 设计稿需要机械规则检查
- ✅ design-review 之前
- ❌ NOT for 主观设计判断（用 design-review skill）

## Process

### 1. 读取上下文

- `docs/design-system/DESIGN.md`：设计系统
- `docs/design-system/tokens.json`：token 定义
- 待检查的设计稿（`docs/visual/<page>.md`）

### 2. 编写 Lint 脚本

Agent 编写一次性 Node.js 脚本，正则扫描设计稿：

```javascript
// lint-design.mjs - 一次性脚本，用完即弃
import { readFileSync, writeFileSync } from 'fs';

const design = readFileSync('docs/visual/<page>.md', 'utf8');
const tokens = JSON.parse(readFileSync('docs/design-system/tokens.json', 'utf8'));

const errors = [];

// L001: 所有颜色必须来自 token（禁止硬编码 hex）
const hexMatches = design.matchAll(/#[0-9a-fA-F]{6}/g);
const tokenColors = Object.values(tokens.color || {}).map(t => t.$value.toLowerCase());
for (const match of hexMatches) {
  if (!tokenColors.includes(match[0].toLowerCase())) {
    errors.push({
      rule: 'L001',
      severity: 'error',
      value: match[0],
      position: match.index,
      expected: 'token reference',
      fix: 'use token from tokens.json'
    });
  }
}

// L011: 禁用 Inter/Roboto/Arial 作为主字体
if (/font-family.*?(Inter|Roboto|Arial)/i.test(design)) {
  errors.push({
    rule: 'L011',
    severity: 'error',
    value: 'Inter/Roboto/Arial',
    expected: 'project design system font',
    fix: 'use font from DESIGN.md'
  });
}

// L012: 禁用 #6366f1 紫色
if (/#6366f1/i.test(design)) {
  errors.push({
    rule: 'L012',
    severity: 'error',
    value: '#6366f1',
    expected: 'project primary token',
    fix: 'use --color-primary'
  });
}

// L013: 禁用紫蓝渐变
if (/(indigo|violet|purple).*?(purple|violet|indigo)/i.test(design)) {
  errors.push({
    rule: 'L013',
    severity: 'error',
    value: 'purple-blue gradient',
    expected: 'flat color or subtle gradient',
    fix: 'remove gradient'
  });
}

// L015: 禁用 Lorem ipsum
if (/lorem\s+ipsum/i.test(design)) {
  errors.push({
    rule: 'L015',
    severity: 'error',
    value: 'Lorem ipsum',
    expected: 'real placeholder content',
    fix: 'replace with real content'
  });
}

writeFileSync('loops/specs/<task>/lint-report.md', formatReport(errors));
console.log(`Lint complete: ${errors.length} issues found`);
```

### 3. 运行脚本

```bash
node lint-design.mjs
```

### 4. 解析报告

脚本输出 `loops/specs/<task>/lint-report.md`，格式：

```markdown
# Lint Report

## Summary
- Errors: <count>
- Warnings: <count>
- Info: <count>

## Details

### L001: 硬编码 hex 颜色 [ERROR]
- 位置：line 42
- 当前值：#3B82F6
- 期望值：token reference
- 修复：use --color-primary

### L011: 禁用字体 [ERROR]
- 位置：line 15
- 当前值：Inter
- 期望值：project design system font
- 修复：use font from DESIGN.md
```

### 5. 处理结果

- `error` 级：必须修复，回到 visual-design 修订
- `warning` 级：建议修复，标注处理决策（"修"或"忽略原因"）
- `info` 级：仅提示，无需处理

## Lint 规则清单

### Token 一致性
- L001: 所有颜色必须来自 token（禁止硬编码 hex）
- L002: 所有间距必须在 spacing scale 上
- L003: 所有圆角必须来自 radius scale
- L004: 所有字号必须在 type scale 上
- L005: 所有阴影必须来自 elevation scale

### 组件一致性
- L006: 同语义组件不超过 3 种实现
- L007: 组件变体差异 ≤2 个 prop 时建议合并
- L008: 组件必须标注所有状态

### 布局一致性
- L009: 对齐基线一致
- L010: 栅格列数一致（12 栅格）

### 反 AI-slop
- L011: 禁用 Inter/Roboto/Arial 作为主字体
- L012: 禁用 #6366f1 紫色
- L013: 禁用紫蓝渐变
- L014: 禁用统一圆角（rounded-2xl 全场）
- L015: 禁用 Lorem ipsum 占位文本

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "lint 规则太严格限制创意" | lint 检查一致性不检查创意，创意在 token 定义层 |
| "手动检查就行" | 手动检查不可重复，lint 可自动化 |
| "LLM 脑补检查就够了" | LLM 会注意力漂移产生幻觉，必须用脚本执行 |
| "写脚本太麻烦" | 一次性脚本用完即弃，比手动检查更可靠 |

## Red Flags

- 未编写脚本，仅靠 LLM 脑补检查
- 脚本未运行就声称通过
- error 级违规未修复就继续
- warning 级违规未标注处理决策

## Verification

- [ ] Lint 脚本已编写（证据：lint-design.mjs 文件存在）
- [ ] 脚本已运行（证据：命令执行记录）
- [ ] lint-report.md 已生成（证据：文件存在）
- [ ] 所有 error 级违规已修复（证据：重新运行脚本无 error）
- [ ] warning 级违规有处理决策（证据：每条 warning 标注"修"或"忽略原因"）

## 与 LOOP 的关系

- 所属阶段：LINT（LOOP 内，verify 之后）
- 不独立成 LOOP，作为设计 LOOP 的第三步
- 流程：DESIGN → VERIFY → LINT
- 循环类型：所有循环类型（visual-design / interaction-design / wireframe / component）均适用

## 失败处理

lint 失败时：
1. 更新 `state.yaml` 的 `last_error` 字段，格式：`Lint L00X: <描述>`（复用现有字段，不新增 lint_status）
2. 更新 `state.yaml` 的 `stage` 为 `lint`，`status` 为 `retrying`
3. 追加一行到 `iterations.log`：`[<时间>] iter=<N> stage=lint → FAILED: L00X <描述>`
4. 回到 DESIGN 阶段修复，iteration +1

lint 通过时：
1. 清空 `state.yaml` 的 `last_error` 字段
2. 更新 `stage` 为下一阶段（LOOP 外门禁或 DONE）
