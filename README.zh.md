<div align="center">

**🌐 语言 / Language**: [English](./README.md) | **中文**

---

# 🪢 harness-all

### 个人 AI 工作室 · 多 Agent 框架家族

> **这是一个框架集合，不是单一框架。** 每个成员都是独立、领域专精的 Agent 框架。当前成员：harness-pm（产品）+ harness-engineering（软件工程）。家族设计为可扩展——data / qa / security 等框架可按需加入。

---

![Version](https://img.shields.io/badge/version-v3.0-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-2-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-109-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-19-purple.svg?style=for-the-badge&logo=git)
![Handoffs](https://img.shields.io/badge/handoffs-2-teal.svg?style=for-the-badge&logo=markdown)
![Loop Types](https://img.shields.io/badge/loop--types-10-red.svg?style=for-the-badge&logo=circleci)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)

---

## 框架家族

harness-all 是一个**独立 Agent 框架的集合**。每个框架是一个自包含的领域专精体（skills + workflows + memory + constitution）。框架间通过契约文档协作，不共享状态。

| 成员 | 类型 | 领域 | 状态 | Skills | Workflows |
|:----:|------|------|:----:|:------:|:---------:|
| **harness-pm** | 核心 | 产品 · 战略 · 市场 · PRD · API 契约 · 指标 | ✅ 已构建 | 84 | 10 |
| **harness-engineering** | 核心 | 软件工程交付（4 阶段：design-intake · frontend · backend · integration） | ✅ 已构建 | 26 | 9 |
| harness-data | 扩展 | 数据管道 · ETL · 指标生产 | 📋 P1 待构建 | — | — |
| harness-qa | 扩展 | 质量保证 · 自动化测试 · 性能测试 | ⚠️ P2 按需 | — | — |
| harness-security | 扩展 | 安全审计 · 合规 · 渗透测试 | ⚠️ P3 按需 | — | — |

> **家族是开放式的。** 软件工程只是其中一种领域类型；同样的架构（AGENTS.md + skills/ + LOOP + 契约文档）支持任何专精 Agent 框架——数据、QA、安全、ML、DevOps 等。

</div>

---

## 按需选型

家族当前交付 **2 个核心框架**（pm + engineering）。每个都能独立工作；需要跨领域数据流转时，自由组合即可。

```
┌─────────────────────────────────┐   ┌──────────────────────────────────────────────┐
│ 模式一：仅 Engineering          │   │ 模式二：完整工作室（PM + Engineering）         │
│                                 │   │                                              │
│   User ─────────► Engineering   │   │   User ──► PM ──pm-to-engineering.md──► Engineering
│                   (4 phases)    │   │            ◄──engineering-to-pm.md──          │
│                                 │   │              （反向反馈，按需）                │
│   "我只写代码"                  │   │   "完整产品工作室"                            │
└─────────────────────────────────┘   └──────────────────────────────────────────────┘
```

> **未来模式**：当 harness-data / harness-qa / harness-security 构建完成后，同样的契约文档模式自然扩展——每个新框架加入新的交接文档类型（如 `engineering-to-qa.md`、`qa-to-engineering.md`）。架构为增长而设计，不封顶于 2。

每个框架**独立自足**——engineering 的 design-intake 支持降级模式（无上游 PM 交接时，从用户对话推导最小契约）。组合使用时，框架间通过 `docs/handoff/` 下的结构化契约文档协作。

### 端到端流程（模式二）

```
┌──────────────────┐                              ┌──────────────────────────────────────────┐
│   harness-pm     │   pm-to-engineering.md       │   harness-engineering                    │
│                  │ ───────────────────────────► │                                          │
│  • PRD + AC-xxx  │   (PRD + API 契约            │   Phase 0: design-intake                 │
│  • API 契约      │    + 设计资产路径            │     → contract.json + tokens.json        │
│  • 设计资产路径  │    + 路由字段)               │   Phase 1: frontend（TDD + 双输入）      │
│  • 路由字段      │                              │     → 前端代码（mock-backed）            │
│                  │ ◄─────────────────────────── │   Phase 2: backend                       │
│                  │   engineering-to-pm.md       │     → api + data + migration             │
│                  │   (集成结果 +                │   Phase 3: integration                   │
│                  │    反馈，按需)               │     → mock→real + e2e + code-review      │
└──────────────────┘                              └──────────────────────────────────────────┘
```

---

## 为什么需要 harness

**核心痛点**：每次 AI 对话都从零开始。没有项目记忆、没有领域专长、没有质量门禁。

```
❌ 没有框架
  第 1 次对话："帮我写个 PRD"     → Agent 从头问起
  第 2 次对话："帮我实现这个功能" → Agent 不知道 PRD 长什么样
  第 3 次对话："帮我修这个 bug"   → Agent 不知道架构是什么
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

家族是开放式的。当前已构建 2 个核心框架；每个专精一个领域，独立工作。

| 你的角色 | 框架 | 类型 | 做什么 |
|---------|------|------|--------|
| 产品经理 | **harness-pm** | 产品框架 | 调研 → PRD → API 契约 → 指标 → 迭代 |
| 开发者（全栈） | **harness-engineering** | 软件工程框架 | 4 阶段交付：设计解析 → frontend → backend → integration |
| 数据工程师 | *harness-data*（P1，待构建） | 数据框架 | ETL · 管道 · 指标生产 |
| QA 工程师 | *harness-qa*（P2，按需） | QA 框架 | 自动化测试 · 性能测试 |
| 安全工程师 | *harness-security*（P3，按需） | 安全框架 | 审计 · 合规 · 渗透测试 |

### 安装

```bash
# 1. 克隆框架家族到任意位置（一次性操作）
cd /path/to/your-parent-dir
git clone https://github.com/LuckyOneTwoThree/harness-all.git

# 2. 进入你的项目目录（没有则新建）
cd /path/to/your-project

# 3. 安装你需要的框架（以 engineering 为例）
bash /path/to/your-parent-dir/harness-all/harness-engineering/install.sh
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

使用两个框架时，契约文档在框架间流转：

```
┌──────────────┐   pm-to-engineering.md    ┌──────────────────┐
│  harness-pm  │ ─────────────────────────►│  harness-        │
│              │   (PRD + AC + API 契约    │  engineering     │
│  PRD + AC +  │    + 设计路径 +           │                  │
│  API 契约    │    路由字段)              │  Phase 0 → 1 → 2 │
│  + 路由      │                           │  → 3             │
│              │ ◄─────────────────────────│                  │
│              │   engineering-to-pm.md    │                  │
│              │   (集成结果 +             │                  │
│              │    反馈，按需)            │                  │
└──────────────┘                           └──────────────────┘
```

将完整的 `docs/handoff/packages/<handoff_id>/` 目录复制到下游框架；不能只复制 Markdown 契约，因为消费方还必须校验 manifest 与随包产物。

---

## 框架一览

### harness-pm — "做对的事"（产品框架）

产品探索、市场分析、PRD 生成、API 契约规范、指标运营。84 个 skill（80 domain + 4 meta），含 17 个 orchestrator，覆盖 7 个模块。

**签名机制**：
- **UI 指令越界门禁** — 拦截 PM 在 PRD 中夹带视觉规格
- **路由字段** — `project_mode` + `exploration_mode` + `task_type` + `scope` 驱动 engineering 阶段执行
- **设计资产路径收集** — PM 收集用户拥有的设计资产路径（Figma / v0 / md / 图片）；PM 永不产出设计输出
- **Batch-aware 反向反馈** — prd-orchestrator phase 0 Branch B 检测 engineering-to-pm 交接包中的 `batch.added_acs` / `batch.superseded_acs`
- **变更影响分析** — 读取 `state.yaml.ac_change` 评估 added/superseded ACs 的影响范围

核心产出：`PRD.md` / `pm-to-engineering.md`

### harness-engineering — "写好代码"（软件工程框架）

4 阶段工程交付：design-intake → frontend → backend → integration。26 个 skill（22 domain + 4 meta）+ 9 个 workflow。这是家族的**软件工程**成员——其他领域类型（数据、QA、安全等）以独立框架加入，而不是作为 engineering 内部的 skill。

**四个阶段**：

| 阶段 | 名称 | 输入 | 输出 |
|-------|------|-------|--------|
| 0 | design-intake | `pm-to-engineering.md`（PRD + API 契约 + 设计资产路径）**或** 用户直接提供资产（降级模式） | `contract.json` + `tokens.json` |
| 1 | frontend | `contract.json` + `tokens.json` + 设计资产（双输入：契约层 + 视觉层） | 前端代码（TDD，mock-backed） |
| 2 | backend | 来自 `contract.json` 的 API 契约 | 后端实现（api + data + migration） |
| 3 | integration | frontend + backend | mock→real 切换 + e2e 验证 + `engineering-to-pm.md` |

**Phase 0 接受这些用户拥有的设计资产类型**（family 模式下 PM 收集路径；降级模式下用户直接投放）：

| 资产类型 | 示例 | Phase 0 处理路径 |
|---------|------|----------------|
| 图片 | `.png` / `.jpg` / `.webp`（截图、手绘、mockup、Figma 导出） | 多模态提取（颜色 / 字体 / 间距 / 布局） |
| 代码 | v0 export、`tailwind.config.js`、`theme.ts`、`globals.css`、shadcn `components.json` | 代码解析（提取 tokens + 组件结构） |
| Markdown | `*.md` 设计规格（含结构化章节） | Markdown 结构化 |
| Figma | Figma URL / 导出（Phase 1 作为视觉参考） | 路径转发至 Phase 1 双输入 |

**签名机制**：
- **双输入模式** — 前端 agent 同时读 `contract.json` 和原始设计资产（视觉保真）
- **TDD 硬规则** — 行为变更必须先有失败测试；测试之前写的代码会被删除
- **AC 编号** — `AC-xxx`（产品）+ `BAC-xxx`（后端）+ `IAC-xxx`（集成）；`DAC-xxx` 已废弃
- **代码审查独占完成** — `status: done` 仅由 code-review skill 写入，verify 永远不能写
- **bugfix 契约变更检测** — bugfix 改了 API 契约时提示升级为 refactor 流程
- **三档探索模式** — `skip`（快速修复）/ `standard`（完整 4 阶段）/ `deep`（OpenAPI + 嵌套任务）
- **阶段检查点** — 每阶段产出 `phase-N-report.md`；阶段推进需用户确认

核心产出：`TECH_STACK.md` / `spec.md` / `contract.json` / `engineering-to-pm.md`

---

## 签名机制深度解析

以下不是纸面设计——它们都在 SKILL.md 的 Process / Quality gates / Prohibited 段落中强制执行，伴随具体的文件写入和状态迁移。

### LOOP 引擎与硬熔断

```
    ┌──────────────────────────────────────────────────────┐
    │                                                      │
    ▼                                                      │
  PLAN ──► ACT ──► VERIFY ──通过──► REVIEW ──通过──► done │
                 │                  │
                 │                  └─失败──► 回到 ACT    │
                 └─失败──► RESEARCH（iteration +1）        │
                                  │                        │
                                  └─ iteration ≥ 10 ──► 硬熔断
                                     （第 11 次被禁止；重置需要
                                      用户显式授权）
```

- **证据驱动**：没有证据不能宣称完成（核心规则）
- **断点续传**：`state.yaml` 持久化 iteration / stage / substage / last_error
- **硬熔断**：第 10 次尝试可以完成；第 11 次被禁止；重置需要用户显式授权
- **Substage 枚举**：`inline-passed` / `inline-failed` / `awaiting-full` / `full-running` / `full-passed` / `full-failed` — 消除 `stage: verify` 的歧义
- **单次增量规则**：iteration 仅在 ACT 开始前增量一次，失败处理中不再增量
- **阶段追踪**（仅 engineering）：`state.yaml.substage_progress` 记录 phase_0..phase_3 完成情况

### AC 编号永久保留

```
PM (PRD)            Engineering
  │                 Phase 0          Phase 2          Phase 3
  │                 design-intake    backend          integration
  │                     │               │                │
  └──► AC-F01-001 ─────►│ 保留 ────────►│                │
                        │               └──► BAC-F01-001 │
                        │                   (新增)       │
                        │                                │
                        └────────────────► IAC-F01-001 ──┘
                                            (新增)

  三种 AC 类型都通过 state.yaml.ac_ids 追踪
  Phase 3 verify 执行三源校验（AC + BAC + IAC）
```

- **永久**：ID 永不重新编号或回收
- **Supersede 而非删除**：语义变更 → 新 ID，旧 ID 标记 `[superseded]` 并指向替代者
- **Superseded ACs 不出现在 envelope `ac_ids` 中** — 只有替代者出现
- **阶段专属验证**：AC-xxx 在所有阶段验证；BAC-xxx 在阶段 3；IAC-xxx 在阶段 3

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

| PM 状态 | Engineering 状态 | 含义 |
|---------|------------------|------|
| `approved` | `pending` | PM 交接就绪；Engineering 尚未启动 |
| `developing` | `in_progress` / `review` | Engineering 正在开发或验证 |
| `launched` | `done` | Engineering code-review 通过且 PM 已上线 |
| `blocked` | `blocked` | 阻塞（原因可能因框架而异） |

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
┌─────────────────────────────────────────────────────────────────┐
│  编排层（未来，非当前目标）                                       │
│  • 多 Agent 调度 · 共享真实数据源 · 跨 LOOP                       │
└─────────────────────────────────────────────────────────────────┘
                          ↕  契约文档
┌─────────────────────────────────────────────────────────────────┐
│  框架层（当前重点）                                              │
│  ┌──────────────────┐   ┌──────────────────────────────────┐    │
│  │  harness-pm      │   │  harness-engineering             │    │
│  │  (84 skills)     │   │  (26 skills, 4 阶段)             │    │
│  └──────────────────┘   └──────────────────────────────────┘    │
│  + 扩展框架：data (P1) / qa (P2) / security (P3)                │
└─────────────────────────────────────────────────────────────────┘
                          ↕  加载链
┌─────────────────────────────────────────────────────────────────┐
│  基础层（每个框架内部）                                          │
│  AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/      │
└─────────────────────────────────────────────────────────────────┘
```

### 契约协作

框架间通过 `docs/handoff/` 下的结构化文档传递需求。每份文档有明确的**生产方**和**消费方**。写入权限单向隔离——消费方只读不写。

| 生产方 → 消费方 | 文档 |
|:---:|---|
| pm → engineering | `pm-to-engineering.md`（PRD + AC + API 契约 + 设计资产路径 + 路由） |
| engineering → pm | `engineering-to-pm.md`（集成结果 + 反馈，按需） |

每个交接 envelope 携带：`schema_version` / `handoff_id` / `producer` / `consumer` / `created_at` / `source_revision` / `supersedes` / `status` / `ac_ids` + 可选 `batch` + `artifacts[]`。消费方校验 SHA-256 manifest 并写入 receipt。

### 三档探索模式（engineering）

| 模式 | 触发条件 | 阶段 | state.yaml | LOOP | verify-full | code-review |
|------|---------|:----:|:----------:|:----:|:-----------:|:-----------:|
| `skip` | quick-fix（Risk Gate 6 项全绿） | 仅阶段 3 | 0 字段 | 否 | 否 | 仅 diff review |
| `standard` | 默认 | 阶段 0 → 1 → 2 → 3 | 7-9 字段 | 是 | 是 | 是 |
| `deep` | new-product-engineering / 模糊任务 | 阶段 0（deep）→ 1 → 2 → 3 + OpenAPI | 10 字段 | 是（嵌套） | 是 | 是 + product-engineering-review |

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

### 为什么是框架家族，而非单一框架

单一框架加载所有领域 skill 会导致 Agent 上下文爆炸、记忆污染。家族架构让每个 Agent 专精一个领域（产品 / 工程 / 数据 / QA / 安全 / ...）。新的领域框架可按需加入，无需改动已有框架——它们只是新增新的交接文档类型。

### 为什么 2 个核心框架 + 4 阶段（v3.0.0）

v2.x 的 3 框架分离（pm/design/solo）UI 保真度差（solo 通过解析后的契约接收设计，丢失了视觉细节）且阻碍前后端并行开发。将 engineering 合并为一个框架 + 4 个内部阶段，保持工作区统一；阶段转换用轻量 `phase-N-report.md` 替代完整交接 envelope。设计资产现在用户拥有（Figma/v0/md）。

### 为什么独立而非统一

上下文爆炸和记忆污染是 AI Agent 协作的核心痛点。单个 Agent 加载 109 个 skill 浪费 token、降低输出质量。独立框架让每个 Agent 专精一个领域。

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
| [ARCHITECTURE.md](./ARCHITECTURE.md) | 完整架构设计（v3.0.0） |
| [DOMAIN_BOUNDARIES.md](./DOMAIN_BOUNDARIES.md) | 规范化职责边界与路由规则 |
| [HANDOFF_PROTOCOL.md](./HANDOFF_PROTOCOL.md) | 可版本化契约协议 |
| [UPGRADING.md](./UPGRADING.md) | 冲突安全的框架升级流程 |
| [harness-pm/README.md](./harness-pm/README.md) | PM 框架详情 |
| [harness-engineering/README.md](./harness-engineering/README.md) | Engineering 框架详情 |

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
