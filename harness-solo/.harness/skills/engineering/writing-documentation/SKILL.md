---
name: writing-documentation
description: 文档编写，ADR/API doc/CHANGELOG，document the why
triggers:
  - 做架构决策时
  - 改公开 API 时
  - 发版时
  - 用户要求写文档时
reads:
  - constitution.md
  - rules/security.md
  - docs/product/PROJECT.md
  - docs/engineering/TECH_STACK.md
writes:
  - docs/decisions/ADR-NNN-*.md
  - docs/
---

# Writing Documentation — 文档编写

## 铁律
**Document the *why*, not the *what*.** 代码说"做了什么"，文档说"为什么这么做、考虑过什么替代方案、有什么约束"。

## 文档类型与流程

### 1. ADR（架构决策记录）— 最高价值

**何时写**：做架构决策时（选型、模式选择、重大 tradeoff）

**流程**：
1. 在 `docs/decisions/` 下创建 `ADR-NNN-<short-title>.md`
   - 编号：用 Glob 扫描 `docs/decisions/ADR-*`，取最大编号 +1
   - 如目录不存在，用工具创建（不用 `mkdir -p`）
2. 按模板填写：

```markdown
# ADR-NNN: <决策标题>

## Status
PROPOSED | ACCEPTED | SUPERSEDED by ADR-XXX | DEPRECATED

## Date
YYYY-MM-DD

## Context
[为什么需要做这个决策？当前面临什么问题？]

## Decision
[决定是什么？]

## Alternatives Considered
- 方案A：[描述] — 为什么没选
- 方案B：[描述] — 为什么没选

## Consequences
- 正面：[好处]
- 负面：[代价]
- 风险：[需关注的点]
```

3. **不要删除旧 ADR**——它们记录历史，新决策写新 ADR 并在旧 ADR 标注 `SUPERSEDED by ADR-XXX`

### 2. API 文档

**何时写**：改公开 API 时（新增/修改/废弃）

**流程**：
- 类型语言（TS/Go/Rust）：类型定义即文档，确保类型完整（不用 `any`）
- 无类型语言（JS/Python）：写 docstring，包含参数、返回值、异常
- REST API：维护 OpenAPI/Swagger 规格文件
- GraphQL：schema 即文档，确保有 description

**最小必要**：
```typescript
/**
 * 按截止日期升序排序 Todo 列表
 * @param todos - Todo 数组（不修改原数组）
 * @returns 新数组，有截止日期的升序在前，无截止日期的排末尾
 */
```

### 3. CHANGELOG

**何时写**：发版时

**格式**（Keep a Changelog 风格）：
```markdown
## [Unreleased]

## [1.2.0] - 2026-06-21
### Added
- 按截止日期排序功能 (#12)
### Fixed
- 空截止日期排序异常 (#15)
### Changed
- 重构排序逻辑为独立模块 (#16)
```

### 4. README

**最小必要内容**：
- 项目一句话介绍
- Quick Start（如何安装、运行、测试）
- 常用命令清单
- 架构概览（指向 docs/）

### 5. 代码注释

**写注释的原则**：
- 注释 **why**（为什么这么做），不注释 **what**（代码已经说了 what）
- 注释非显而易见的意图、约束、踩坑
- 删除注释掉的代码（git 有历史）
- TODO 必须带日期和负责人：`// TODO(2026-06-21): <描述>`

**反例**（禁止）：
```javascript
// Increment counter by 1   ← 重述代码，删掉
counter++;
```

**正例**（保留）：
```javascript
// 用 || null 归一化空字符串，避免 localeCompare 把 '' 排在正常日期前
const normalized = deadline || null;
```

## 反合理化表

| 借口 | 反驳 |
|------|------|
| "代码自解释" | 代码不解释为什么、考虑过什么替代 |
| "等 API 稳定再写文档" | 文档是设计的第一个测试，越拖 API 越不稳 |
| "ADR 太麻烦" | 10 分钟的 ADR 避免 2 小时的重复争论 |
| "注释重述代码帮助理解" | 重述代码的注释是噪音，注释意图 |
| "旧 ADR 过时了删掉" | 旧 ADR 记录历史，新 ADR supersede 旧的 |

## 禁止事项
- 注释重述代码（`// Increment counter by 1`）
- 留注释掉的代码（git 有历史，删掉）
- 留无日期无负责人的 TODO
- 删除旧 ADR（应标注 SUPERSEDED）
- API 无类型/docstring（`any` 满天飞）
- README 不写如何运行项目

## 与 LOOP 的关系
本 skill 通常在 LOOP 之外触发：
- 架构决策 → brainstorming 阶段触发本 skill 写 ADR
- API 变更 → verify 阶段检查文档同步
- 发版 → session-end 或独立发版流程触发 CHANGELOG

## 与其他 skill 的分工
| Skill | 职责 |
|-------|------|
| writing-documentation | 文档编写（ADR/API/CHANGELOG/README/注释） |
| brainstorming | 架构决策的思考过程（决策定下来后写 ADR） |
| verify | 检查 API 变更是否同步文档 |
| session-end | 发版时触发 CHANGELOG 更新 |
