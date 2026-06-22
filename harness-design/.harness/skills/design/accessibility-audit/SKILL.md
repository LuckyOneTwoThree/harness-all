---
name: accessibility-audit
description: Performs deep WCAG 2.1 AA accessibility audit. Use before design-handoff. Use for accessibility compliance verification.
triggers:
  - 交付前可访问性审查
  - design-handoff 之前
  - 需要可访问性合规验证
reads:
  - .harness/craft/color.md
  - .harness/data/design/ux-guidelines.csv
writes:
  - docs/visual/accessibility-report.md
---

# Accessibility Audit

## Overview

WCAG 2.1 AA 专项深度审查。可访问性是硬约束，不是事后补。

## When to Use

- ✅ 交付前可访问性审查
- ✅ design-handoff 之前
- ✅ 需要可访问性合规验证
- ❌ NOT for LOOP 内快速检查（用 verify skill 的基础可访问性检查）

## Process

### 1. 对比度检查

| 文本类型 | 最小对比度 | 检查方式 |
|---------|-----------|---------|
| 正文（<18pt） | 4.5:1 | 计算 hex 色值对比度 |
| 大文本（≥18pt 或 14pt+bold） | 3:1 | 同上 |
| UI 组件边界 | 3:1 | 同上 |
| 非文本装饰 | ≥2:1（建议） | 同上 |

对比度计算公式：
```
L = 0.2126 * R + 0.7152 * G + 0.0722 * B（R/G/B 需先 gamma 校正）
contrast = (L1 + 0.05) / (L2 + 0.05)
```

### 2. 键盘导航检查

- [ ] Tab 顺序 = 视觉顺序
- [ ] 焦点可见（ring token，对比度 ≥3:1）
- [ ] 无键盘陷阱（所有焦点可通过 Esc/Tab 退出）
- [ ] 所有交互元素可键盘操作
- [ ] 跳过链接（Skip to main content）存在

### 3. 屏幕阅读器检查

- [ ] 语义化 HTML（header/nav/main/section/footer）
- [ ] ARIA 标签（aria-label/aria-describedby/aria-live）
- [ ] alt 文本（所有图片有 alt，装饰图片 alt=""）
- [ ] 表单标签（label 关联 input）
- [ ] 错误提示可被屏幕阅读器读取（aria-live="assertive"）

### 4. 响应式检查

| 断点 | 检查项 |
|------|--------|
| 375px（小手机） | 无水平溢出 / 文字可读 / 触控目标 ≥44pt |
| 768px（平板） | 布局合理 / 无溢出 |
| 1280px（桌面） | 布局合理 / 内容不拉伸过宽 |

### 5. reduced-motion 检查

- [ ] 所有动效有 reduced-motion 替代
- [ ] 无纯装饰性动画（reduced-motion 下隐藏）
- [ ] 加载动画有静态替代

### 6. 暗色模式检查

- [ ] 暗色模式正文对比度 ≥4.5:1
- [ ] 暗色模式次文对比度 ≥3:1
- [ ] 分隔线在双主题下可见
- [ ] 交互态在双主题下等价

### 7. 输出审查报告

写入 `docs/visual/accessibility-report.md`：

```markdown
# Accessibility Audit Report

## 对比度检查
| 元素 | 前景 | 背景 | 对比度 | 标准 | 结果 |
|------|------|------|--------|------|------|
| 正文 | #0F172A | #FFFFFF | 15.3:1 | 4.5:1 | ✓ |
| 按钮文字 | #FFFFFF | #3B82F6 | 4.2:1 | 4.5:1 | ✗ |

## 键盘导航
- [x] Tab 顺序 = 视觉顺序
- [x] 焦点可见
- [ ] 无键盘陷阱（Modal 缺 Esc 关闭）

## 屏幕阅读器
- [x] 语义化 HTML
- [ ] 表单 label 关联（Login 表单缺失）

## 响应式
- 375px：✓
- 768px：✓
- 1280px：✓

## reduced-motion
- [x] 所有动效有替代

## 暗色模式
- [x] 正文对比度达标
- [ ] 次文对比度不足

## 总结
- 通过项：X
- 不通过项：Y
- 必须修复：<列出 Critical 项>
```

## Common Rationalizations

| 借口 | 现实 |
|------|------|
| "可访问性后面再补" | WCAG 2.1 AA 是硬约束，不是事后补 |
| "对比度差不多就行" | 4.5:1 是硬标准，差 0.1 也不行 |
| "没人用键盘导航" | 可访问性是合规要求，不是可选 |
| "暗色模式对比度差不多" | 暗色模式需要独立检查，不能假设亮色值可用 |

## Red Flags

- 对比度未实际计算（仅目测）
- 键盘导航未实际测试
- 暗色模式未独立检查
- reduced-motion 未检查

## Verification

- [ ] 对比度逐项计算（证据：报告含对比度数值）
- [ ] 键盘导航逐项检查（证据：报告含 ✓/✗）
- [ ] 屏幕阅读器检查完成（证据：报告含语义化/ARIA/alt 检查）
- [ ] 响应式三断点检查（证据：375/768/1280 都有）
- [ ] reduced-motion 检查（证据：报告含动效替代）
- [ ] 暗色模式独立检查（证据：报告含暗色对比度）

## 与 LOOP 的关系

- 所属阶段：LOOP 外门禁（LOOP 退出后运行，与 design-review 并列）
- 不在 LOOP 内运行（避免每次迭代都跑全项 WCAG 2.1 AA 检查，成本过高）
- LOOP 内由 verify skill 做基础可访问性快速检查（对比度 + 键盘导航）
- 失败时回到 LOOP 重新 DESIGN，不消耗迭代次数
- 通过后进入交付阶段（design-handoff-spec）
