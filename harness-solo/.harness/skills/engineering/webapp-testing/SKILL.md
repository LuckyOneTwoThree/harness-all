---
name: webapp-testing
description: 前端/Web 应用验证，纯 Agent 工具方式（不依赖 Playwright）
triggers:
  - 涉及前端代码变更时
  - verify skill 的前端验证子项
  - 用户要求验证 UI/页面行为时
reads:
  - loops/specs/<feature>/spec.md
  - docs/engineering/TECH_STACK.md
  - rules/security.md
writes:
  - loops/specs/<feature>/evidence.md
---

# Webapp Testing — 前端验证

## 铁律
**前端代码变更必须验证，不许只看代码就说"应该能跑"。** 纯 Agent 工具方式，不引入 Playwright 等外部依赖（遵守 constitution.md 零新依赖原则）。

## 定位

本 skill 是 **verify skill 的前端专项补充**，不替代单元测试：
- 单元测试（组件逻辑）→ tdd skill 管
- 集成测试（API 对接）→ tdd skill 管
- **前端结构/可访问性/构建验证** → 本 skill 管

## 流程

1. **确认前端技术栈**
   - 读 `docs/engineering/TECH_STACK.md`，确认框架（React/Vue/Svelte/原生）
   - 确认构建命令（`npm run build` / `vite build` 等）
   - 确认是否有 lint 命令（`npm run lint` / `eslint`）

2. **构建验证**（强制）
   - 运行构建命令，确认无编译错误：
     ```bash
     <构建命令，如 npm run build>
     ```
   - 展示完整输出，不能只说"构建通过"
   - 构建失败 → 回 tdd 修复

3. **类型检查**（如有 TypeScript）
   - 运行类型检查命令：
     ```bash
     <类型检查命令，如 npm run typecheck 或 tsc --noEmit>
     ```
   - 展示输出，确认无类型错误

4. **Lint 检查**（如有）
   - 运行 lint 命令：
     ```bash
     <lint 命令，如 npm run lint>
     ```
   - 展示输出，确认无 error（warning 可接受但应记录）

5. **结构验证**（用 Agent 工具，跨平台）

   **5.1 组件结构检查**
   - 用 Glob 找到本次变更的组件文件（`*.tsx` / `*.vue` / `*.svelte`）
   - 用 Read 读取每个组件，检查：
     - [ ] 组件有明确的 props 类型定义（不是 any）
     - [ ] 组件有对应的测试文件（`*.test.tsx` / `*.spec.tsx`）
     - [ ] 没有 inline 样式硬编码（应用 CSS 类/Tailwind 类）
     - [ ] 没有未清理的 console.log / debugger

   **5.2 可访问性基础检查**（用 Grep）
   - 搜索 `<img` 确认都有 `alt` 属性：
     ```
     <img[^>]*(?!alt=)[^>]*>
     ```
     命中 → 标记为可访问性问题
   - 搜索 `<button` 确认都有可读文本或 `aria-label`：
     ```
     <button[^>]*>\s*</button>
     ```
     命中（空 button）→ 标记为可访问性问题
   - 搜索 `onClick` 确认非 div/span 上绑定（应用 button）：
     ```
     <div[^>]*onClick
     ```
     命中 → 标记为可访问性建议

   **5.3 路由/页面检查**（如有路由）
   - 用 Glob 找到路由配置文件
   - 用 Read 确认新增页面已注册到路由
   - 确认路由路径与 spec.md 的 AC 一致

6. **安全检查**（前端专项）
   - 用 Grep 搜索 `dangerouslySetInnerHTML`（React）/ `v-html`（Vue）：
     命中 → 标记为 XSS 风险，需确认输入来源可信
   - 用 Grep 搜索硬编码 API 地址：
     ```
     (http|https)://[a-zA-Z0-9.-]+\.[a-z]{2,}
     ```
     命中 → 确认是否应走环境变量配置

7. **写入证据**
   将以上检查结果汇总到 evidence.md 的"前端验证"章节：
   ```markdown
   ## 前端验证

   ### 构建
   $ <命令>
   <实际输出>

   ### 类型检查
   $ <命令>
   <实际输出>

   ### Lint
   $ <命令>
   <实际输出>

   ### 结构验证
   - 组件文件：X 个，全部有 props 类型 ✓/✗
   - 测试文件：X 个组件有测试，Y 个缺失
   - 可访问性：[问题列表或"无问题"]

   ### 安全
   - dangerouslySetInnerHTML：[命中情况或"无"]
   - 硬编码 API 地址：[命中情况或"无"]
   ```

## 与 verify 的分工

| 维度 | verify | webapp-testing |
|------|--------|----------------|
| 范围 | 全栈综合验证 | 前端专项 |
| 触发 | 每次 LOOP 的 VERIFY | 涉及前端代码时 |
| 产出 | evidence.md 主章节 | evidence.md "前端验证"章节 |
| 关系 | verify 调用 webapp-testing | webapp-testing 是 verify 的子项 |

**调用方式**：verify skill 在检查到前端代码变更时，调用本 skill 做前端专项验证，结果合并到 evidence.md。

## 禁止事项
- 跳过构建验证（构建失败的前端代码不能交付）
- 只看代码不跑构建（"我觉得能编译"不算证据）
- 忽略可访问性问题（不是可选的，是基础质量）
- 引入 Playwright/Cypress 等外部依赖做 E2E（违反零新依赖原则，如需 E2E 由用户单独配置）

## 关于 E2E 测试

本 skill **不包含** E2E 测试（Playwright/Cypress），原因：
- E2E 框架是重依赖，违反 constitution.md 零新依赖原则
- E2E 需要浏览器环境，跨平台兼容性复杂
- 个人中型项目通常单元测试 + 结构验证足够

如用户明确需要 E2E：
1. 用户审批引入 Playwright（修改 constitution.md 的依赖白名单）
2. 单独创建 `e2e-testing` skill
3. 不在本 skill 范围内

## 与 LOOP 的关系
本 skill 在 LOOP 的 VERIFY 阶段被 verify skill 调用：
- tdd（ACT）→ verify（VERIFY）→ 检测到前端代码 → 调用 webapp-testing → 合并证据
