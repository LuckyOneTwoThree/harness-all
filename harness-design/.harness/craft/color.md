# Color Craft Rules

> 通用工艺规则（品牌无关）· 被 visual-design / design-system / design-lint 引用
>
> 来源：Open Design craft/color.md + 色彩理论最佳实践

## 核心理念

颜色是品牌识别的核心。AI slop 的第二大标志就是紫色渐变（#6366f1）。好的色彩系统需要语义化 token、合理的对比度、克制的 accent 用量。

## 语义化 Token 结构（shadcn 兼容）

| Token | 用途 | 示例 |
|-------|------|------|
| primary | 主操作色 | 按钮/链接 |
| on-primary | primary 上的文本 | 按钮文字 |
| secondary | 次要操作 | 次按钮 |
| accent | 强调色 | 高亮/徽章 |
| background | 页面背景 | body 背景 |
| foreground | 正文文本 | 主文本 |
| muted | 静默文本 | 辅助文本 |
| muted-foreground | muted 上的文本 | 辅助文本 |
| card | 卡片背景 | 卡片 |
| card-foreground | 卡片文本 | 卡片内容 |
| border | 边框 | 分隔线 |
| destructive | 错误/删除 | 错误提示 |
| ring | 焦点环 | 键盘焦点 |

## 对比度标准（WCAG 2.1 AA）

| 文本类型 | 最小对比度 | 说明 |
|---------|-----------|------|
| 正文（<18pt） | 4.5:1 | 必须满足 |
| 大文本（≥18pt 或 14pt+bold） | 3:1 | 可略低 |
| UI 组件边界 | 3:1 | 按钮/输入框边框 |
| 非文本装饰 | 不要求 | 但建议 ≥2:1 |

## Accent 用量原则

| 原则 | 说明 |
|------|------|
| 每屏最多 2 次 accent | accent 是强调，不是装饰 |
| accent 不用于大面积 | 大面积用 primary/secondary |
| accent 不用于正文 | 正文用 foreground |

## 暗色模式原则

| 原则 | 说明 |
|------|------|
| 不直接反转亮色 | 暗色需要独立调色 |
| 表面分层用亮度差 | 而非阴影 |
| 避免纯黑（#000） | 用 #0a0a0a 等深灰 |
| 避免纯白（#fff） | 用 #fafafa 等暖白 |

## 禁用配色

| 禁用 | 原因 |
|------|------|
| #6366f1 作为 primary | AI 默认紫 |
| 紫蓝渐变 | AI 默认渐变 |
| 纯黑（#000）作为背景 | 太硬，用深灰 |
| 纯白（#fff）作为暗色文本 | 太刺眼，用暖白 |
| 硬编码 hex | 用 token 引用 |

## 色彩生成原则

| 原则 | 说明 |
|------|------|
| 50-900 阶梯 | 每个颜色生成 11 阶 |
| HSL 色彩空间 | 便于生成阶梯 |
| 50 最浅，900 最深 | 约定俗成 |

## 检查时机

- **design-system**：定义色彩系统时对照
- **visual-design**：选色时对照禁用配色
- **design-lint**：L001 规则检查颜色来自 token，L011-L012 检查 AI slop 色
- **accessibility-audit**：对比度专项检查
