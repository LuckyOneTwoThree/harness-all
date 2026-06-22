# Typography Craft Rules

> 通用工艺规则（品牌无关）· 被 visual-design / design-system / design-lint 引用
>
> 来源：Open Design craft/typography.md + 排版最佳实践

## 核心理念

字体是设计的灵魂。AI slop 的首要标志就是字体选择（Inter/Roboto/Arial）。好的排版需要关注字距、字号阶梯、行高三个维度。

## 字号阶梯（Type Scale）

采用 1.25 比率（Major Third）：

| Token | Size | 用途 |
|-------|------|------|
| text-xs | 0.8rem (12.8px) | 辅助文本/标签 |
| text-sm | 1rem (16px) | 正文（小屏） |
| text-base | 1.25rem (20px) | 正文（桌面） |
| text-lg | 1.563rem (25px) | 小标题 |
| text-xl | 1.953rem (31.25px) | 章节标题 |
| text-2xl | 2.441rem (39px) | 页面标题 |
| text-3xl | 3.052rem (49px) | Hero 标题 |

## 行高（Line Height）

| 用途 | 行高 | 原因 |
|------|------|------|
| 正文（多行） | 1.5-1.6 | 阅读舒适度 |
| 标题（短行） | 1.1-1.3 | 紧凑感 |
| UI 文本 | 1.4 | 平衡 |

## 字距（Letter Spacing）

| 场景 | 字距 | 原因 |
|------|------|------|
| ALL CAPS 文本 | ≥0.06em | 大写字母需更多间距 |
| 大标题 | -0.02em | 大字号需收紧 |
| 正文 | normal (0) | 默认即可 |
| 小文本 | 0.01em | 小字号略加间距 |

## 字重（Font Weight）

| 用途 | 字重 | 原因 |
|------|------|------|
| 正文 | 400 (normal) | 阅读舒适 |
| 强调 | 500-600 | 不抢标题 |
| 标题 | 600-700 | 建立层级 |
| 大标题 | 700-800 | 视觉焦点 |

## 字体配对原则

1. **衬线 + 无衬线**：标题用衬线（有个性），正文用无衬线（易读）
2. **展示字 + UI 字**：标题用展示字（有特色），正文用 UI 字（中性）
3. **避免同族配对**：两个无衬线或两个衬线配对缺乏对比

## 禁用配对

| 禁用 | 原因 |
|------|------|
| Inter + Roboto | 两个 AI 默认字体 |
| Arial + Helvetica | 太相似 |
| 单字体全场景 | 缺乏层级 |

## CSS Import 规范

```css
/* Google Fonts 导入示例（禁用 Inter/Roboto/Arial 作为主字体） */
@import url('https://fonts.googleapis.com/css2?family=Cormorant+Garamond:wght@400;600&family=Manrope:wght@400;500&display=swap');
```

## 检查时机

- **design-system**：定义字体系统时对照
- **visual-design**：选字体时对照禁用配对
- **design-lint**：L004 规则检查字号在 type scale 上
