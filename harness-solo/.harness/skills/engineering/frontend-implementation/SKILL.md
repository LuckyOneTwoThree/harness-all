---
name: frontend-implementation
description: 前端工程实现，组件拆分/状态管理/样式工程（非视觉设计）
triggers:
  - 实现前端组件时
  - 选型状态管理方案时
  - 建立样式工程时
  - 前端架构设计时
reads:
  - constitution.md
  - rules/security.md
  - docs/engineering/TECH_STACK.md
  - docs/handoff/design-to-solo.md
  - docs/handoff/component-map.json
  - docs/design-system/tokens.json
  - docs/design-system/tokens.css
  - docs/design-system/DESIGN.md
  - docs/interaction/component-spec.md
writes:
  - loops/specs/<feature>/iterations.log
---

# Frontend Implementation — 前端工程实现

## 铁律
**Composition over configuration.** `<Card><CardHeader><CardTitle>` 优于 `<Card title="..." headerVariant="large">`。组件组合 > 配置爆炸。

## 定位

本 skill 是**工程实现**，不是视觉设计：
- 视觉设计（配色/排版/品牌）→ harness-design 通过 `docs/handoff/` 交接
- **本 skill 管**：组件结构、状态管理、样式工程方案选型、三态处理

## 设计稿消费（来自 harness-design）

本 skill 强依赖 harness-design 的产出物，按以下契约读取：

### 1. component-map.json（显式映射层，核心契约）

读取 `docs/handoff/component-map.json`，作为组件实现的**单一事实源**：

```json
{
  "PrimaryButton": {
    "designToken": "button.primary",
    "engineeringComponent": "Button",
    "props": { "variant": "primary", "size": "md" },
    "states": ["default", "hover", "active", "disabled", "loading"],
    "notes": "主操作按钮，每屏最多 1 个"
  }
}
```

**消费规则**：
- `engineeringComponent` → 工程组件名（如 `Button`），直接作为代码组件名
- `props` → 组件 props 的契约，必须全部实现
- `states` → 必须覆盖所有状态（缺一不可，缺了就是设计稿遗漏，反馈给 harness-design）
- `designToken` → 关联 tokens.json 的 token 名，禁止硬编码值

**框架无关约束**：props 的 Type 必须与 `docs/engineering/TECH_STACK.md` 的框架匹配：
- React → `ReactNode` / `JSX.Element`
- Vue → `VNode` / `Slot`
- Svelte → `Snippet` / `Component`
- 原生/Web Components → `HTMLElement` / `Slot`
- 如 component-map.json 的 Type 与项目框架不匹配，标注为"待与 harness-design 对齐"

### 2. tokens.json / tokens.css（设计令牌）

读取 `docs/design-system/tokens.json`（结构化）和 `tokens.css`（可直接 import），作为样式工程的**间距/颜色/字体阶梯来源**：
- spacing scale → 禁止任意像素值，必须用 scale 内的值
- color token → 用 `text-primary` / `bg-surface` 等语义化 token，禁止裸 `#333`
- type scale → 用设计系统的字体大小阶梯，不随意指定

### 3. DESIGN.md（设计系统 10 段定义）

读取 `docs/design-system/DESIGN.md`，理解设计系统的全局约束（Aesthetic Direction / Color System / Typography Scale / Layout Principles 等 10 段）。

### 4. component-spec.md（交互组件规格）

读取 `docs/interaction/component-spec.md`，获取组件的交互行为规格（手势/动画/状态转换）。

### 5. design-to-solo.md（交付说明）

读取 `docs/handoff/design-to-solo.md`，获取：
- 设计 AC-xxx 清单（如"对比度 ≥4.5:1""375px 无溢出"）→ 流入 verify 检查
- 设计稿路径（`docs/visual/<page>.md` / `docs/interaction/<page>.md`）
- 未决事项（需与设计确认的问题）

## 组件设计

### 1. 容器与展示分离
- **Container**：处理数据（fetch/loading/error/empty 三态），不关心 UI
- **Presentation**：纯渲染，props 进 UI 出，不关心数据来源

### 2. 单一职责
- 组件 > 200 行 → 拆分
- 一个组件做一件事：要么获取数据，要么渲染 UI，要么处理交互
- 命名描述职责：`UserList` / `UserListItem` / `EmptyState`

### 3. 组合优于配置
```tsx
// ✓ 组合（推荐）
<Card>
  <CardHeader>
    <CardTitle>标题</CardTitle>
  </CardHeader>
  <CardBody>内容</CardBody>
</Card>

// ✗ 配置爆炸（避免）
<Card title="标题" headerVariant="large" bodyPadding="md" showHeader={true}>
  内容
</Card>
```

### 4. Colocate（就近放置）
组件相关的一切放同一目录：
```
UserList/
├── UserList.tsx        # 实现
├── UserList.test.tsx   # 测试
├── UserList.stories.tsx # stories（如有）
├── useUserData.ts      # 关联 hook
└── types.ts            # 类型
```

## 状态管理选型

**用最简方案，按需升级**：

| 场景 | 方案 | 何时用 |
|------|------|--------|
| 组件内 UI 状态 | `useState` | 开关、输入值、tab 切换 |
| 2-3 个兄弟组件共享 | Lifted state | 提升到共同父组件 |
| 全局读多写少 | `Context` | theme / auth / locale |
| 可分享/可书签 | URL state | 筛选 / 分页 / 排序 |
| 远程数据 + 缓存 | React Query / SWR | API 数据（loading/error/缓存） |
| 复杂全局客户端状态 | Zustand / Redux | 跨多组件频繁更新的状态 |

**选型原则**：
- 从 `useState` 开始，不够再升级
- 避免 prop drilling 超 3 层（用 Context 或状态库）
- 不要为了"未来可能需要"提前引入 Redux

## 样式工程

### 1. 设计系统约束
- **spacing scale**：用设计系统的间距阶梯（如 0.25rem 递增：0.25 / 0.5 / 1 / 1.5 / 2 / 3 / 4）
- **禁止任意像素值**：不用 `13px` / `2.3rem`，用 scale 内的值
- **语义化 color token**：用 `text-primary` / `bg-surface`，不用裸 `#333`
- **字体大小阶梯**：用设计系统的 type scale，不随意指定

### 2. 响应式
- **Mobile-first**：从小屏开始写，用 `min-width` 媒体查询升级
- **必测断点**：320 / 768 / 1024 / 1440
- 事后改响应式是 3 倍成本，一开始就写

### 3. 避免 AI 默认审美
- 紫色满天飞、过度渐变、`rounded-2xl` 万能、stock card 网格、shadow 堆叠
- 这些是"AI 生成的通用样子"，不是"设计意识强的工程师写的 UI"
- 视觉规范由 harness-design 产出，本 skill 负责按规范实现

## 三态处理（强制）

每个数据驱动组件必须处理三态：

```tsx
function UserList() {
  const { data, isLoading, error } = useUserData();

  if (isLoading) return <Skeleton />;      // loading 态
  if (error) return <ErrorMessage error={error} />;  // error 态
  if (!data?.length) return <EmptyState />;  // empty 态

  return <ul>{data.map(user => <UserListItem key={user.id} user={user} />)}</ul>;
}
```

**禁止**：只写 happy path，忽略 loading/error/empty。

## 可访问性（WCAG 2.1 AA 底线）

- 每个交互元素键盘可达（Tab 键能遍历）
- 无可见文字的控件有 `aria-label`
- 颜色不作唯一状态指示（加图标/文字）
- `<img>` 必须有 `alt`
- 用 `<button>` 不用 `<div onClick>`

## 反合理化表

| 借口 | 反驳 |
|------|------|
| "组件先写大点以后再拆" | 200 行是红线，超了就拆 |
| "响应式以后再做" | 事后改是 3 倍成本 |
| "可访问性是 nice-to-have" | 多地是法律要求 + 工程质量标准 |
| "状态管理先用 Redux 万无一失" | 过度工程，从 useState 开始 |
| "设计没定先不写样式" | 用设计系统默认值，无样式 UI 留坏印象 |
| "loading 态先不写" | 三态是强制，不是可选 |

## 禁止事项
- 组件 > 200 行不拆
- 内联样式（`style={{ color: 'red' }}`）
- 任意像素值（非 scale 内的值）
- 缺 loading/error/empty 三态
- 颜色作唯一状态指示
- `<div onClick>` 代替 `<button>`
- 无 `alt` 的 `<img>`
- prop drilling 超 3 层不提取 Context

## 与 LOOP 的关系
本 skill 在 LOOP 的 ACT 阶段触发：
- 前端组件实现 → 本 skill 指导结构 → tdd 写测试 → verify 验证
- 不在 LOOP 外独立触发（实现代码必须在 LOOP 内）

## 与其他 skill 的分工
| Skill | 职责 |
|-------|------|
| frontend-implementation | 前端工程实现（结构/状态/样式） |
| tdd | 组件逻辑的单元测试 |
| webapp-testing | 前端验证（构建/类型/lint/可访问性） |
| verify | 综合验证（调用 webapp-testing） |
| writing-documentation | 组件 API 文档（props 类型） |

## 证据要求
实现完成后，在 evidence.md 记录：
```
## 前端实现
- 组件结构：X 个组件，最大 Y 行（≤200 ✓）
- 状态管理：选型 <方案>，理由：<一句话>
- 三态处理：loading ✓ / error ✓ / empty ✓
- 可访问性：键盘可达 ✓ / aria-label ✓ / alt ✓
- 响应式：320/768/1024/1440 四断点 ✓
```
