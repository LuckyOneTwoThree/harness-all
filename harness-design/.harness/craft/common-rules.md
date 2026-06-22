# Common Rules for Professional UI

> 通用工艺规则（品牌无关）· 被 visual-design / design-lint / design-review 引用
>
> 来源：UI UX Pro Max 的 Common Rules for Professional UI

## 核心理念

"易被忽视但影响专业感"的规则。每条规则以 Standard / Avoid / Why It Matters 三栏呈现，便于 Agent 直接对照执行。

## Icons & Visual Elements

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| 默认用 Phosphor 图标库 | 用 emoji 作结构图标 | emoji 渲染不一致，不专业 |
| 矢量资源优先（SVG） | 位图图标 | 矢量可缩放无失真 |
| 品牌 logo 用官方资产 | 手绘 logo | 品牌一致性 |
| 图标尺寸 token 化（icon-sm/icon-md=24pt） | 硬编码尺寸 | 可维护性 |
| 同层笔画粗细一致 | 混用粗细 | 视觉一致性 |
| 填充/描边不混用 | 同一界面混用 | 视觉一致性 |
| 触控区 ≥44pt | 小于 44pt | 可访问性 + 移动端可用性 |
| 图标对齐基线 | 视觉对齐 | 排版专业度 |
| 对比度 4.5:1 | 低于 4.5:1 | WCAG AA |

## Interaction (App)

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| 点击反馈 80-150ms 内 | 超过 150ms | 感知性能 |
| 微交互 150-300ms 原生缓动 | 自定义复杂缓动 | 平台一致性 |
| 无障碍焦点序=视觉序 | 焦点序混乱 | 键盘用户体验 |
| 禁用态用语义化 props | 仅改样式 | 可访问性 |
| 触控 ≥44×44pt（iOS）/48×48dp（Android） | 小于标准 | 平台规范 |
| 单区域单手势 | 多手势冲突 | 防误操作 |
| 优先原生交互原语 | 自定义交互 | 平台一致性 |

## Light/Dark Mode Contrast

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| 亮色表面清晰分离 | 表面混在一起 | 视觉层级 |
| 正文对比度 ≥4.5:1 | 低于 4.5:1 | WCAG AA |
| 暗色主文 ≥4.5:1 次文 ≥3:1 | 低于标准 | 暗色模式可读性 |
| 分隔线双主题可见 | 单主题设计 | 跨主题可用性 |
| 交互态双主题等价 | 仅亮态设计 | 跨主题一致性 |
| 语义化 token 驱动 | 硬编码颜色 | 可维护性 |
| modal scrim 40-60% 黑 | 透明 scrim | 焦点引导 |

## Layout & Spacing

| Standard | Avoid | Why It Matters |
|----------|-------|----------------|
| 安全区合规（刘海/状态栏/手势条） | 内容被遮挡 | 移动端可用性 |
| 系统栏留空 | 内容侵入系统栏 | 平台规范 |
| 内容宽度按设备类一致 | 随意宽度 | 跨设备一致性 |
| 4/8dp 间距节奏 | 任意间距 | 视觉节奏感 |
| 12 栅格布局 | 任意栅格 | 工程可实现对齐 |
| 移动优先设计 | 桌面优先 | 响应式基础 |

## 检查时机

- **visual-design**：产出设计稿时对照三栏表
- **design-lint**：L006-L010 规则检查布局一致性
- **design-review**：Five-Axis Review 的"间距与对齐"轴检查
