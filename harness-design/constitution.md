# constitution.md — 项目宪法

> **角色说明**：本文件是 **harness-design 框架仓库自身**的项目宪法。
> 当用 install.sh 安装到新项目时，会从 `.harness/templates/constitution.md.template` 复制生成新项目的宪法，覆盖本文件。
> 因此本文件约束的是"开发 harness-design 框架本身"，不是"用 harness-design 设计其他项目"。
>
> 与 AGENTS.md 的分工：AGENTS.md 是通用工作规则（所有项目相同），constitution.md 是项目特定约束。
> 加载时机：AGENTS.md 之后，首次交互时读。

## 项目特定原则

### 原则 1：零运行时依赖

harness-design 是**纯文档/规则框架**，本身不引入任何运行时依赖。
- 所有流程通过 Agent 工具完成，不依赖 bash 脚本
- 设计产出是文档/规范，不是可运行代码

**验证方式**：仓库根目录无 `package.json` / `requirements.txt` / `Cargo.toml` 等运行时依赖清单。

### 原则 2：Agent 工具优先，不绑定 bash

框架所有流程必须能在无 bash 环境（如 Windows PowerShell）下工作。
- SKILL.md 中的操作步骤必须给出"Agent 工具方式"（Read/Write/Glob/Grep/Edit 等）
- `.sh` 脚本只能标注为"可选兜底"

**验证方式**：任意 SKILL.md 流程不依赖 bash 特有语法完成核心任务。

### 原则 3：核心文件修改需用户确认

以下文件变更必须由用户明确授权：
- `AGENTS.md`
- `SOUL.md`
- `constitution.md`
- `.harness/rules/security.md`
- `.harness/rules/prompt-defense.md`

**验证方式**：修改前通过 `AskUserQuestion` 或显式对话获得授权。

### 原则 4：Skill 必须有完整 frontmatter

所有 `.harness/skills/*/*/SKILL.md` 必须包含：
- `name:`（与目录名一致）
- `description:`
- `triggers:`
- `reads:`
- `writes:`

**验证方式**：`skill-maintenance` 扫描无 frontmatter 缺失。

### 原则 5：文档简洁，防止膨胀

- `AGENTS.md` 不超过 150 行
- `SKILL.md` 不超过 300 行（超过时将 schema/示例/决策表提取到 `Reference/` 子目录，Reference/ 下不限）
- `progress.md` 超过 200 行必须归档

**验证方式**：`skill-maintenance` 行数检查 + Agent 自检。

### 原则 6：设计产出必须标注可访问性合规等级

所有设计稿（视觉/交互/原型）必须标注 WCAG 合规等级：
- WCAG 2.1 A / AA / AAA
- 不达标项必须列出原因和补救方案

**验证方式**：`accessibility-audit` skill 检查 + `verify` skill 综合验证。

### 原则 7：探索先行不可绕过

`default_mode: deep` 的 workflow（如 new-design / redesign），必须完成需求探索阶段（design-brief / 用户审美调研）才能进入设计产出。

- `deep` 模式下，⏸ 探索对话点不可跳过，必须获得用户输入后才继续
- `deep` 模式下，禁用 skill 降级策略，不允许"基于默认审美"降级
- 用户只能通过显式声明"切换到 skip 模式"来绕过，且 Agent 必须记录理由到 `state.yaml`
- `skip` 模式有安全兜底：无需求文档时自动降级为 `standard`

**验证方式**：workflow 执行前检查 `state.yaml` 的 `exploration_mode` 字段；`deep` 模式下未完成探索阶段则阻断 PLAN→DESIGN 流转。

## 宪法检查点（PLAN 阶段必查）

- [ ] 当前变更是否引入运行时依赖？
- [ ] 当前流程是否能在无 bash 环境下完成？
- [ ] 是否涉及核心文件修改？是否已获得用户授权？
- [ ] 新增/修改的 skill 是否有完整 frontmatter？
- [ ] 文档长度是否超过项目阈值？
- [ ] 设计产出是否标注可访问性合规等级？
- [ ] 当前 workflow 的 exploration_mode 是否为 deep？若是，是否已完成需求探索阶段？

## 修订记录

| 日期 | 修订内容 | 原因 |
|------|---------|------|
| 2026-06-21 | 初始版本 | 明确 harness-design 自身约束 |
| 2026-06-23 | 增加原则 7：探索先行不可绕过；原则 5 AGENTS.md 行数限制 120→150 | exploration_mode 机制需要宪法依据 |
