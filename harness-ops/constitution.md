# constitution.md — 项目宪法

> **角色说明**：本文件是 **harness-ops 框架仓库自身**的项目宪法。
> 当用 install.sh 安装到新项目时，会从 `.harness/templates/constitution.md.template` 复制生成新项目的宪法，覆盖本文件。
> 因此本文件约束的是"开发 harness-ops 框架本身"，不是"用 harness-ops 运维其他项目"。
>
> 与 AGENTS.md 的分工：AGENTS.md 是通用工作规则（所有项目相同），constitution.md 是项目特定约束。
> 加载时机：AGENTS.md 之后，首次交互时读。

## 项目特定原则

### 原则 1：零运行时依赖

harness-ops 是**纯文档/规则框架**，本身不引入任何运行时依赖。
- 所有 `.harness/scripts/*.sh` 和 `.harness/hooks/*.sh` 仅作为可选兜底脚本
- Agent 优先使用 IDE 工具完成等价操作，不依赖 bash

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

### 原则 5：基础设施即代码（IaC）与破坏性变更保护

harness-ops 是**自动化运维框架**，禁止任何基于控制台手工点击（ClickOps）的运维方案。
- 所有对基础设施的变更必须有对应的 Terraform（`.tf`）、Ansible（`.yml`）或 Kubernetes YAML 文件
- 删除数据卷、清空数据库、销毁生产环境等高危操作必须强制拦截，禁止未经人类授权的破坏性操作

**验证方式**：项目中必须存在变更对应的 IaC 声明文件；PLAN 阶段必须通过 `AskUserQuestion` 获得对破坏性操作的明确授权。

### 原则 6：监控先行与零秘钥泄露

没有可观测性的部署就是盲飞。
- 每次服务上线前，必须明确定义用来判断服务健康的指标（如：HTTP 200，CPU < 60%）
- 代码仓库中绝对不能包含明文秘钥，所有凭证必须通过环境变量或秘钥管理系统注入

**验证方式**：VERIFY 阶段必须提供明确的日志、监控截图或脚本检测结果作为 Evidence；扫描 `.env` 或配置文件，如发现明文密码则拒绝提交或执行。

### 原则 7：文档简洁，防止膨胀

- `AGENTS.md` 不超过 150 行
- `SKILL.md` 不超过 300 行（超过时将 schema/示例/决策表提取到 `Reference/` 子目录，Reference/ 下不限）
- `progress.md` 超过 200 行必须归档

**验证方式**：Agent 用 Read 工具统计行数 + `skill-maintenance` 元 skill 检查。

### 原则 8：探索先行不可绕过

`default_mode: deep` 的 workflow（如 infrastructure-setup-workflow / security-audit-workflow），必须完成现状评估阶段（基础设施盘点/安全状态检查）才能进入变更产出。

- `deep` 模式下，⏸ 探索对话点不可跳过，必须获得用户输入后才继续
- `deep` 模式下，禁用 skill 降级策略，不允许跳过现状评估
- 用户只能通过显式声明"切换到 skip 模式"来绕过，且 Agent 必须记录理由到 `state.yaml`
- `skip` 模式有安全兜底：无运维上下文时自动降级为 `standard`

**验证方式**：workflow 执行前检查 `state.yaml` 的 `exploration_mode` 字段；`deep` 模式下未完成现状评估则阻断 PLAN→PROVISION 流转。

## 宪法检查点（PLAN 阶段必查）

- [ ] 核心文件修改是否已获得用户授权？
- [ ] 当前变更是否有对应的 IaC 代码文件支撑？
- [ ] 是否涉及高危/破坏性操作？是否已获得用户授权？
- [ ] 发布/变更的验证指标是什么？是否可监控？
- [ ] 代码或配置中是否绝对没有硬编码的明文秘钥？
- [ ] 文档长度是否超过项目阈值？
- [ ] 当前 workflow 的 exploration_mode 是否为 deep？若是，是否已完成现状评估？

## 修订记录

| 日期 | 修订内容 | 原因 |
|------|---------|------|
| 2026-06-22 | 初始版本 | 明确 harness-ops 自身架构约束 |
| 2026-06-23 | 增加原则 6（探索先行不可绕过）+ AGENTS.md 行数限制 120→150 | 推广 exploration_mode 机制到 ops 框架 |
| 2026-06-23 | 补齐原则 1-4 通用基础原则 + 合并领域原则为 5-6 + 原则重新编号 + Reference/ 例外条款 | 跨框架宪法一致性 |
