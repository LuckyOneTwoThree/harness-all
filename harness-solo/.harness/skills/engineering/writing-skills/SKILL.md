---
name: writing-skills
description: 按标准创建新 skill，支持框架扩展
triggers:
  - 用户要求添加新 skill 时
  - 现有 skill 无法覆盖新场景时
  - 框架扩展时
reads:
  - .harness/templates/SKILL.md.template
  - .harness/skills/INDEX.md
  - .harness/loops/LOOP.md
writes:
  - .harness/skills/<category>/<new-skill-name>/SKILL.md
  - .harness/skills/INDEX.md
---

# Writing Skills — 创建新 Skill

## 铁律
**新 skill 必须按模板创建，必须注册到 INDEX.md，必须声明 reads/writes。** 不许裸奔。

## 何时创建新 skill

创建新 skill 的判断标准：
- **应该创建**：某个工作模式会重复使用（不是一次性操作）
- **应该创建**：现有 skill 无法覆盖，且新场景有明确流程
- **不应该创建**：一次性操作（直接在对话里做就行）
- **不应该创建**：现有 skill 加几行说明就能覆盖（增强现有 skill）

## 流程

1. **确认 skill 定位**
   - 名字：小写中划线，如 `refactoring-database`
   - 一句话描述：做什么 + 什么时候用
   - 分类：`engineering` / `meta`（工程类还是元类）
   - 是否在 LOOP 内？对应哪个阶段（PLAN/ACT/VERIFY）？

2. **创建目录和文件**
   - 目录：`.harness/skills/<category>/<skill-name>/SKILL.md`
   - 从 `.harness/templates/SKILL.md.template` 复制基础结构
   - 不要创建 .gitkeep（SKILL.md 本身就是文件）

3. **填写 frontmatter**（必填字段）

   ```yaml
   ---
   name: <skill-name>                    # 必填，与目录名一致
   description: 一句话描述，用于 INDEX.md 引用  # 必填
   triggers:                             # 必填，什么时候用
     - 场景1
     - 场景2
   reads:                                # 必填，依赖的文件
     - loops/LOOP.md
     - rules/security.md
   writes:                               # 必填，产出的文件
     - loops/specs/<feature>/state.yaml
   ---
   ```

   **reads/writes 声明规则**：
   - `reads`：本 skill 执行时需要读取的文件（rules/loops/docs/specs）
   - `writes`：本 skill 执行后会修改的文件（state.yaml/evidence.md/iterations.log/docs）
   - 如涉及 state.yaml，必须读 `loops/LOOP.md`（引用 schema）
   - 如涉及安全，必须读 `rules/security.md`

4. **编写正文**（按模板结构）

   - **铁律**：不可违反的规则，放最前面（避免 lost-in-the-middle）
   - **流程**：编号步骤，每步可执行
   - **禁止事项**：明确不该做什么
   - **与 LOOP 的关系**：对应哪个阶段，如何与其他 skill 交互
   - **证据要求**（如适用）：声称完成需要什么证据

5. **注册到 INDEX.md**
   - 在对应分类下追加一行：`- **<skill-name>** — <一句话描述>`
   - 保持 INDEX.md 在 30 行内（纯索引原则）

6. **联动检查**
   - 如新 skill 写 state.yaml → 确认引用了 LOOP.md 的 schema
   - 如新 skill 在 LOOP 内 → 确认相关 workflow 文件已更新
   - 如新 skill 涉及交接 → 确认 reads/writes 声明了 docs/handoff/

7. **验证**
   - 用 Read 确认 SKILL.md 创建成功
   - 用 Read 确认 INDEX.md 已更新
   - 如修改了 workflow，用 Read 确认一致

## 设计原则

- **单一职责**：一个 skill 只管一件事
- **跨平台**：不依赖 bash，Agent 工具优先
- **引用而非重复**：state.yaml schema 引用 LOOP.md，不重复定义
- **最小必要**：frontmatter 只填需要的字段，不为了完整而填空
- **可组合**：skill 之间通过 reads/writes 声明依赖，不硬编码调用

## 命名规范

- 小写中划线：`test-driven-development`，不是 `TestDrivenDevelopment`
- 动词或动名词开头：`writing-plans` / `executing-plans` / `verify`
- 避免缩写：`systematic-debugging`，不是 `sys-debug`
- 与目录名完全一致

## 禁止事项
- 不按模板创建（结构不一致，Agent 难以解析）
- 不注册到 INDEX.md（skill 不会被发现了）
- 在一个 skill 里做多件事（违反单一职责）
- 硬编码其他 skill 的调用（应通过 reads/writes 声明依赖）
- 创建后不验证（可能文件没写成功）

## 与 LOOP 的关系
本 skill 是**元 skill**，不在 LOOP 内，用于框架自身扩展。
- 用户要求扩展框架 → writing-skills → 创建新 SKILL.md + 更新 INDEX.md
- 新 skill 创建后，可在后续 LOOP 中被调用
