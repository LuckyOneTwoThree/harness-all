<div align="center">

**🌐 语言 / Language**: [English](./README.md) | **中文**

---

# 🪢 harness-all

### 个人 AI 工作室 · 多 Agent 框架家族

> **按需选型。每个框架独立可用，需要时自由组合。**

---

![Version](https://img.shields.io/badge/version-v2.2.1-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-3-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-119-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-27-purple.svg?style=for-the-badge&logo=git)
![Handoffs](https://img.shields.io/badge/handoffs-5-teal.svg?style=for-the-badge&logo=markdown)
![Loop Types](https://img.shields.io/badge/loop--types-13-red.svg?style=for-the-badge&logo=circleci)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)

---

| 框架 | 领域 | Skill | Workflow |
|:----:|------|:-----:|:--------:|
| **harness-pm** | 战略 · 市场 · PRD · 指标 | 84 | 10 |
| **harness-design** | 视觉 · 交互 · 原型 · 设计系统 | 16 | 8 |
| **harness-solo** | 工程 · TDD · 调试 · 重构 · 验证 | 19 | 9 |

</div>

---

## 按需选型

一个框架就能独立工作。需要跨领域数据流转时，自由组合即可。

```
┌──────────────────────────────────────────────────────────────┐
│                                                              │
│  模式一：单框架          模式二：按需组合        模式三：全链路 │
│                                                              │
│  只用你需要的            需要的组合起来          完整闭环       │
│                                                              │
│  ┌─────────┐           ┌─────┐  ┌─────────┐    pm → design  │
│  │  solo   │           │ pm  │→ │ design  │     → solo       │
│  │  独立用  │           └─────┘  └─────────┘                 │
│  └─────────┘                                                 │
│                                                              │
│  "我只写代码"          "PM + 设计"            "完整工作室"    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

每个框架**独立自足**——不需要交接文档也能工作（solo 甚至有显式的 **standalone mode**，在无上游 PM/Design 时短路整个交接校验流水线）。组合使用时，框架间通过 `docs/handoff/` 下的结构化契约文档协作。

---

## 为什么需要 harness

**核心痛点**：每次 AI 对话都从零开始。没有项目记忆、没有领域专长、没有质量门禁。

```
❌ 没有框架
  第 1 次对话："帮我写个 PRD"     → Agent 从头问起
  第 2 次对话："帮我设计首页"     → Agent 不知道 PRD 长什么样
  第 3 次对话："帮我实现这个功能" → Agent 不知道设计稿是什么
  ...每次对话都是失忆的
```

**harness 为 AI Agent 构建持久化的项目知识体系**：

| 没有 harness | 有 harness |
|-------------|-----------|
| 每次对话重新解释项目背景 | `knowledge-base.md` 跨会话持续积累 |
| 关闭对话就遗忘 | `progress.md` 自动恢复上下文 |
| 一个 Agent 什么都做，什么都做不好 | 专精领域的独立 Agent |
| "我觉得做完了" | LOOP 引擎 + 证据门禁 + 代码审查独占完成状态 |
| 口头交接，信息丢失 | 结构化契约文档 + AC 编号 + SHA-256 manifest |
| Agent 失败后无限循环 | 硬熔断 10 次迭代 |
| 一刀切的流程 | 三档探索模式（skip / standard / deep） |

**一句话**：提示词工程是"教 Agent 做一件事"；框架是"让 Agent 拥有持久记忆、领域专长和工程纪律，越用越强"。

---

## 按角色快速开始

### 选择你的框架

| 你的角色 | 框架 | 做什么 |
|---------|------|--------|
| 产品经理 | **harness-pm** | 调研 → PRD → 指标 → 迭代 |
| 设计师 | **harness-design** | 设计需求 → 视觉 → 交互 → 交接规范 |
| 开发者 | **harness-solo** | 规划 → TDD → 实现 → 验证 |

### 安装

```bash
# 1. 克隆框架家族到任意位置（一次性操作）
cd /path/to/your-parent-dir
git clone https://github.com/LuckyOneTwoThree/harness-all.git

# 2. 进入你的项目目录（没有则新建）
cd /path/to/your-project

# 3. 安装你需要的框架（以 solo 为例）
bash /path/to/your-parent-dir/harness-all/harness-solo/install.sh
```

安装脚本会在你的项目中创建 `.harness/` 目录结构、复制核心配置文件、初始化记忆。

> **Windows 用户注意 —— `bash` 命令路由问题**
>
> Windows 上系统自带的 `bash.exe` 是 WSL 的存根,不是 Git Bash。如果在 PowerShell/CMD 里执行 `bash install.sh` 报错"适用于 Linux 的 Windows 子系统没有已安装的分发",说明 `bash` 命令被路由到了 WSL 而非 Git Bash。
>
> **三种解决方案（任选其一）:**
> 1. **使用 Git Bash 终端**（推荐）:从开始菜单打开 "Git Bash",然后 `cd /d/your-project && bash /path/to/install.sh`
> 2. **PowerShell 里用完整路径**:`& "C:\Program Files\Git\bin\bash.exe" install.sh`
> 3. **永久别名**（一次性配置）:在 PowerShell profile 里添加（`notepad $PROFILE`）:
>    ```powershell
>    function bash { & "C:\Program Files\Git\bin\bash.exe" @args }
>    ```
>    重开 PowerShell 后,`bash install.sh` 会永久路由到 Git Bash。

### 启动 Agent

在项目目录打开 AI Agent（如 Trae IDE）。Agent 自动读取：
1. `AGENTS.md` — 启动时强制读取的规则
2. `SOUL.md` + `constitution.md` — 领域价值观和不可协商原则
3. `skills/INDEX.md` → 对应 `SKILL.md` — 按需加载技能
4. `memory/progress.md` — 跨会话上下文恢复

### 组合框架

使用多个框架时，契约文档在框架间流转：

```
harness-pm → pm-to-design.md → harness-design → design-to-solo.md → harness-solo
                                                       ↑
                                  solo-to-pm.md ───────┘  （反向反馈）
```

将完整的 `docs/handoff/packages/<handoff_id>/` 目录复制到下游框架；不能只复制 Markdown 契约，因为消费方还必须校验 manifest 与随包产物。

---

## 框架一览

### harness-pm — "做对的事"

产品探索、市场分析、PRD 生成、指标运营。84 个 skill（80 domain + 4 meta），含 17 个 orchestrator，覆盖 7 个模块。

**签名机制**：
- **UI 指令越界门禁** — 拦截 PM 在 PRD 中夹带视觉规格
- **Batch-aware 反向反馈** — prd-orchestrator phase 0 Branch B 检测 solo-to-pm 交接包中的 `batch.added_acs` / `batch.superseded_acs`，无需重新推导 diff
- **变更影响分析** — 读取 `state.yaml.ac_change` 评估 added/superseded ACs 的影响范围

核心产出：`PRD.md` / `pm-to-design.md` / `pm-to-solo.md`

### harness-design — "做得好看且好用"

视觉设计、交互设计、设计系统、原型输出。16 个 skill（12 domain + 4 meta）+ 8 个 workflow。

**签名机制**：
- **Push-back 反越界** — 设计 Agent 有权拒绝 PM 硬编码的 UI 指令，并通过 AC Cleanup Log 留痕可追溯
- **反 AI 味** — 禁用 Inter / 紫色渐变 / Lorem ipsum / 滥用插图
- **Doubt-Driven Review** — 五轴评审（视觉 / 交互 / 可访问性 / 一致性 / 美学），含 WCAG 2.1 AA 可机器断言子集
- **两层契约** — `component-contract.json`（语义层，design 拥有）+ `component-bindings.json`（工程绑定，solo 拥有）

核心产出：`DESIGN.md` / `tokens.json` / `design-to-solo.md` / `component-contract.json`

### harness-solo — "写好代码"

工程开发、TDD、调试、验证、代码审查。19 个 skill（15 domain + 4 meta）+ 9 个 workflow。

**签名机制**：
- **TDD 硬规则** — 行为变更必须先有失败测试；测试之前写的代码会被删除
- **双源 AC 验证** — verify 同时检查 `AC-xxx`（来自 PM）和 `DAC-xxx`（来自 Design）
- **代码审查独占完成** — `status: done` 仅由 code-review skill 写入，verify 永远不能写
- **Standalone Mode** — 无上游 PM/Design 交接时，session-start 短路整个 envelope/batch/manifest/receipt 流水线
- **三档探索模式** — `skip`（quick-fix，5 步，0 state 字段）/ `standard`（11 步，完整 LOOP）/ `deep`（20 步，嵌套任务 + product-engineering-review）

核心产出：`TECH_STACK.md` / `spec.md` / `solo-to-pm.md`

---

## 签名机制深度解析

以下不是纸面设计——它们都在 SKILL.md 的 Process / Quality gates / Prohibited 段落中强制执行，伴随具体的文件写入和状态迁移。

### LOOP 引擎与硬熔断

```
PLAN → EXECUTE → VERIFY ── 通过 ──→ REVIEW ──→ done
                  │
                  └─ 失败 ──→ 分析 ──→ RESEARCH（iteration +1）
                                       └─ iteration >= 10 → 硬熔断
```

- **证据驱动**：没有证据不能宣称完成（核心规则）
- **断点续传**：`state.yaml` 持久化 iteration / stage / substage / last_error
- **硬熔断**：第 10 次尝试可以完成；第 11 次被禁止；重置需要用户显式授权
- **Substage 枚举**：`inline-passed` / `inline-failed` / `awaiting-full` / `full-running` / `full-passed` / `full-failed` — 消除 `stage: verify` 的歧义
- **单次增量规则**：iteration 仅在 EXECUTE 开始前增量一次，失败处理中不再增量

### AC 编号永久保留

```
PM: AC-F01-001（产品 AC）     Design: DAC-P01-001（页面 AC）/ DAC-GLOBAL-001
        │                                          │
        └───────────── 通过 state.yaml.ac_ids 追踪 ─────────────┘
                                    │
                          solo verify: 双源校验
```

- **永久**：ID 永不重新编号或回收
- **Supersede 而非删除**：语义变更 → 新 ID，旧 ID 标记 `[superseded]` 并指向替代者
- **Superseded ACs 不出现在 envelope `ac_ids` 中** — 只有替代者出现
- **跨包可追溯**：design-to-solo 的 inherited AC-xxx 列表必须是 PM AC-xxx 的超集（PM 拥有的 AC 不能在设计阶段被静默丢弃）

### Batch 交付协议

```yaml
batch:
  id: 2
  type: incremental  # 或 "full"（首次交付 / 重新广播）
  added_acs: [AC-F01-004]           # 新增范围
  modified_acs: [AC-F01-002]        # 同 ID，新内容
  superseded_acs: [AC-F01-001]      # 退役，被 AC-F01-004 替代
  unchanged_acs: [AC-F01-003]
```

- 生产方在 envelope 填 `batch`；消费方（下游 session-start）读取它来界定分诊范围，无需重新推导 diff
- envelope 的 `ac_ids` 字段必须等于 `added_acs + modified_acs + unchanged_acs`（排除 superseded）
- validator 在交接消费时强制校验此等式

### 跨框架状态调和

每个框架维护各自的 `FEATURES.md`，使用与生命周期匹配的状态。同步通过交接文档流转，不直接写入对方文件：

| PM 状态 | Design 状态 | Solo 状态 | 含义 |
|---------|-------------|-----------|------|
| `approved` | `pending` | — | PM 交接就绪；Design 尚未启动 |
| `approved` | `in_progress` | — | Design 正在消费 pm-to-design.md |
| `approved` | `done` | `pending` | Design 完成；Solo 尚未启动 |
| `developing` | `done` | `in_progress` | Solo 正在消费 design-to-solo.md |
| `launched` | `done` | `done` | 完全上线 |

### 安全红线（绝对禁止）

- 禁止硬编码 secrets / API keys
- 禁止 `rm -rf /` / `curl | sh` / `chmod -R 777` / `git push --force to main`
- 禁止执行 `DROP DATABASE/TABLE`
- 禁止未经用户显式授权安装 Git hook
- 禁止绕过 verify skill 宣称完成
- 敏感文件（`.env` / `*.pem` / `*.key` / `id_rsa` / `credentials.json`）永不读取

---

## 运作原理

### 三层架构

```
编排层（未来，非当前目标）
              ↕ 契约文档
框架层       pm / design / solo
              ↕ 加载链
基础层       AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/
```

### 契约协作

框架间通过 `docs/handoff/` 下的结构化文档传递需求。每份文档有明确的**生产方**和**消费方**。写入权限单向隔离——消费方只读不写。

| 生产方 → 消费方 | 文档 |
|:---:|---|
| pm → design | `pm-to-design.md` |
| pm → solo | `pm-to-solo.md` |
| design → solo | 含 `design-to-solo.md` + `component-contract.json` 的可移植交接包 |
| design → pm | `design-to-pm.md`（反向反馈） |
| solo → pm | `solo-to-pm.md`（反向反馈） |

每个交接 envelope 携带：`schema_version` / `handoff_id` / `producer` / `consumer` / `created_at` / `source_revision` / `supersedes` / `status` / `mode` / `ac_ids` + 可选 `batch` + `artifacts[]`。消费方校验 SHA-256 manifest 并写入 receipt。

### 三档探索模式（solo）

| 模式 | 触发条件 | 步数 | state.yaml | LOOP | verify-full | code-review |
|------|---------|:-----:|:----------:|:----:|:-----------:|:-----------:|
| `skip` | quick-fix（Risk Gate 6 项全绿） | 5 | 0 字段 | 否 | 否 | 仅 diff review |
| `standard` | 默认 | 11 | 7-9 字段 | 是 | 是 | 是 |
| `deep` | new-product-engineering / 模糊任务 | 20 | 10 字段 | 是（嵌套） | 是 | 是 + product-engineering-review |

模式来源优先级：用户显式 > 自动检测 > workflow `default_mode` > standard。

### 极简 skill 格式

每个 skill 是一个 `SKILL.md`，frontmatter 极简：

```yaml
---
name: skill-name
description: 一句话描述
---
```

依赖信息（何时使用、输入、输出、质量门禁）放在正文段落中——自然语言，易读易维护。

---

## 关键设计决策

### 为什么独立而非统一

上下文爆炸和记忆污染是 AI Agent 协作的核心痛点。单个 Agent 加载 119 个 skill 浪费 token、降低输出质量。独立框架让每个 Agent 专精一个领域。

### 为什么用契约文档而非共享状态

目前没有编排层。契约文档是最低耦合的协作方式——生产一份文档，下游消费。编排层就绪后，共享状态可逐步替代部分契约。

### 为什么用极简 frontmatter

重型 YAML frontmatter（`triggers` / `reads` / `writes` / `quality_gates` / `max_iterations`）在开源界极其罕见。极简 frontmatter（`name` + `description`）+ 自然语言正文段落是主流趋势——更可读、更易维护。

### 为什么硬熔断设在 10 次

Agent 可能在失败时幻觉进度并无限循环。第 10 次是绝对上限——第 10 次尝试可以完成，但第 11 次被禁止。这既防止 token 失控消耗，又为真正的迭代留出空间。

### 为什么完成状态由代码审查独占

`status: done` 仅由 code-review skill 写入，verify 永远不能写。这种分离防止 verify skill 自证完成——这是审计追溯的基础保证。

---

## 文档导航

| 文档 | 内容 |
|------|------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | 完整架构设计（v2.2.1） |
| [DOMAIN_BOUNDARIES.md](./DOMAIN_BOUNDARIES.md) | 规范化职责边界与路由规则 |
| [HANDOFF_PROTOCOL.md](./HANDOFF_PROTOCOL.md) | 可版本化契约协议 |
| [UPGRADING.md](./UPGRADING.md) | 冲突安全的框架升级流程 |
| [harness-pm/README.md](./harness-pm/README.md) | PM 框架详情 |
| [harness-design/README.md](./harness-design/README.md) | 设计框架详情 |
| [harness-solo/README.md](./harness-solo/README.md) | 工程框架详情 |

每个框架的 `AGENTS.md` 是 Agent 启动时强制读取的入口。

---

## 许可

MIT License — 见每个框架根目录的 LICENSE 文件。

### 维护者

[@LuckyOneTwoThree](https://github.com/LuckyOneTwoThree)

---

<div align="center">

**harness-all** · 独立优先 · 契约协作 · 循环验证 · 安全红线

</div>
