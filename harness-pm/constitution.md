# constitution.md — 项目宪法

> **角色说明**：本文件是 **harness-pm 框架仓库自身**的项目宪法。
> 当用 install.sh 安装到新项目时，会从 `.harness/templates/constitution.md.template` 复制生成新项目的宪法，覆盖本文件。
> 因此本文件约束的是"开发 harness-pm 框架本身"，不是"用 harness-pm 做其他产品"。
>
> 与 AGENTS.md 的分工：AGENTS.md 是通用工作规则（所有项目相同），constitution.md 是项目特定约束。
> 加载时机：AGENTS.md 之后，首次交互时读。

## 项目特定原则

### 原则 1：零运行时依赖

harness-pm 是**纯文档/规则框架**，本身不引入任何运行时依赖。
- Agent 优先使用 IDE 工具完成等价操作，不依赖 bash
- `.harness/skills/pm/` 目录的 SKILL.md 是方法论定义，不是可执行代码

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

所有 `.harness/skills/pm/*/SKILL.md` 和 `.harness/skills/meta/*/SKILL.md` 必须包含：
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

**验证方式**：Agent 用 Read 工具统计行数 + skill-maintenance 检查复杂度。

### 原则 6：PM 产出必须有置信度标注

所有 PM skill 的推断性产出必须标注置信度（0-1.0）：
- 置信度 ≥ 0.7：可自动传递下游
- 置信度 0.3-0.7：传递时标注 `confidence: medium`，人类确认
- 置信度 < 0.3：**阻断自动传递**，必须人类确认

**验证方式**：verify skill 检查产出 JSON 的 confidence 字段。

### 原则 7：探索先行不可绕过

`default_mode: deep` 的 workflow（如 new-product / pivot），必须完成探索阶段（用户研究/市场分析）才能进入下游产出。

- `deep` 模式下，⏸ 探索对话点不可跳过，必须获得用户输入后才继续
- `deep` 模式下，禁用 skill 降级策略，不允许"基于口头描述"降级
- 用户只能通过显式声明"切换到 skip 模式"来绕过，且 Agent 必须记录理由到 `state.yaml`
- `skip` 模式有安全兜底：无探索数据时自动降级为 `standard`

**验证方式**：workflow 执行前检查 `state.yaml` 的 `exploration_mode` 字段；`deep` 模式下未完成探索阶段则阻断 PLAN→RESEARCH 流转。

## 宪法检查点（PLAN 阶段必查）

- [ ] 当前变更是否引入运行时依赖？
- [ ] 当前流程是否能在无 bash 环境下完成？
- [ ] 是否涉及核心文件修改？是否已获得用户授权？
- [ ] 新增/修改的 skill 是否有完整 frontmatter？
- [ ] 文档长度是否超过项目阈值？
- [ ] PM 产出是否标注置信度？低置信度是否阻断传递？
- [ ] 当前 workflow 的 exploration_mode 是否为 deep？若是，是否已完成探索阶段？

## 修订记录

| 日期 | 修订内容 | 原因 |
|------|---------|------|
| 2026-06-21 | 初始版本 | 明确 harness-pm 自身约束 |
| 2026-06-23 | 增加原则 7：探索先行不可绕过 | exploration_mode 机制需要宪法依据 |
| 2026-06-23 | 原则 4 frontmatter 要求统一为 triggers+reads+writes | 与 design/solo/growth/ops 框架宪法保持一致；pm 现有 82 个领域 skill 使用 metadata 结构属 S2 已知问题，后续单独修复 |
| 2026-06-23 | 原则5 增加 Reference/ 例外条款 + 原则4 frontmatter 要求统一 | 跨框架宪法一致性 + SKILL.md 拆分支持 |
