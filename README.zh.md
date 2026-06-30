<div align="center">

**🌐 语言 / Language**: [English](./README.md) | **中文**

---

# 🪢 harness-all

### 个人 AI 工作室 · 多 Agent 框架家族

> **按需选型。每个框架独立可用，需要时自由组合。**

---

![Version](https://img.shields.io/badge/version-v2.2-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-5-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-196-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-41-purple.svg?style=for-the-badge&logo=git)
![Handoffs](https://img.shields.io/badge/handoffs-11-teal.svg?style=for-the-badge&logo=markdown)
![Loop Types](https://img.shields.io/badge/loop--types-24-red.svg?style=for-the-badge&logo=circleci)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)

---

| 框架 | 领域 | Skill | Workflow |
|:----:|------|:-----:|:--------:|
| **harness-pm** | 战略 · 市场 · PRD · 指标 | 86 | 10 |
| **harness-design** | 视觉 · 交互 · 原型 · 设计系统 | 19 | 7 |
| **harness-solo** | 工程 · TDD · 调试 · 重构 · 验证 | 19 | 9 |
| **harness-growth** | 内容 · SEO · 增长实验 · 变现 | 40 | 7 |
| **harness-ops** | 部署 · 监控 · 故障 · 容灾 | 32 | 8 |

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
│  │  独立用  │           └─────┘  └─────────┘     → growth    │
│  └─────────┘                                       → ops      │
│                                                              │
│  "我只写代码"          "PM + 设计，不要运维"   "完整工作室"    │
│                                                              │
└──────────────────────────────────────────────────────────────┘
```

每个框架**独立自足**——不需要交接文档也能工作。组合使用时，框架间通过 `docs/handoff/` 下的结构化契约文档协作。

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
| "我觉得做完了" | LOOP 引擎 + 证据门禁 |
| 口头交接，信息丢失 | 结构化契约文档 + AC 编号对齐 |

**一句话**：提示词工程是"教 Agent 做一件事"；框架是"让 Agent 拥有持久记忆和领域专长，越用越强"。

---

## 按角色快速开始

### 选择你的框架

| 你的角色 | 框架 | 做什么 |
|---------|------|--------|
| 产品经理 | **harness-pm** | 调研 → PRD → 指标 → 迭代 |
| 设计师 | **harness-design** | 设计需求 → 视觉 → 交互 → 交接规范 |
| 开发者 | **harness-solo** | 规划 → TDD → 实现 → 验证 |
| 增长/运营 | **harness-growth** | 假设 → 实验 → 内容 → SEO |
| 运维/SRE | **harness-ops** | IaC → 部署 → 监控 → 故障响应 |

### 安装

```bash
# 1. 克隆框架家族到任意位置（一次性操作）
#    会在当前目录下创建一个 harness-all 文件夹
cd /path/to/your-parent-dir
git clone https://github.com/LuckyOneTwoThree/harness-all.git
# 现在框架位于 /path/to/your-parent-dir/harness-all/

# 2. 进入你的项目目录（没有则新建）
cd /path/to/your-project

# 3. 安装你需要的框架（以 solo 为例）
#    安装脚本会自动检测本地文件，无需联网
bash /path/to/your-parent-dir/harness-all/harness-solo/install.sh
```

安装脚本会在你的项目中创建 `.harness/` 目录结构、复制核心配置文件、初始化记忆。

> **Windows 用户注意 —— `bash` 命令路由问题**
>
> Windows 上系统自带的 `bash.exe`(位于 `C:\Windows\System32\` 或 `WindowsApps\`)是 WSL 的存根,不是 Git Bash。如果在 PowerShell/CMD 里执行 `bash install.sh` 报错"适用于 Linux 的 Windows 子系统没有已安装的分发",说明 `bash` 命令被路由到了 WSL 而非 Git Bash。
>
> **三种解决方案(任选其一):**
>
> 1. **使用 Git Bash 终端**(推荐):从开始菜单打开 "Git Bash",然后 `cd /d/your-project && bash /path/to/install.sh`
> 2. **PowerShell 里用完整路径**:`& "C:\Program Files\Git\bin\bash.exe" install.sh`
> 3. **永久别名**(一次性配置):在 PowerShell profile 里添加(`notepad $PROFILE`):
>    ```powershell
>    function bash { & "C:\Program Files\Git\bin\bash.exe" @args }
>    ```
>    重开 PowerShell 后,`bash install.sh` 会永久路由到 Git Bash。
>
> 这是 Windows 上 WSL 与 Git Bash 的已知冲突 —— 两者都带 `bash.exe`,但 Windows 把 WSL 存根排在 PATH 前面遮蔽了 Git Bash。

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
                                                                    → solo-to-ops.md → harness-ops
```

将完整的 `docs/handoff/packages/<handoff_id>/` 目录复制到下游框架；不能只复制 Markdown 契约，因为消费方还必须校验 manifest 与随包产物。

---

## 框架一览

### harness-pm — "做对的事"

产品探索、市场分析、PRD 生成、指标运营。86 个 skill，含 19 个编排器。特色：**UI 指令越界门禁** — 拦截 PM 在 PRD 中夹带视觉规格。

核心产出：`PRD.md` / `pm-to-design.md` / `pm-to-solo.md` / `pm-to-growth.md`

### harness-design — "做得好看且好用"

视觉设计、交互设计、设计系统、原型输出。19 个 skill。特色：**Push-back 反越界** — 设计 Agent 有权拒绝 PM 硬编码的 UI 指令。**反 AI 味** — 禁用 Inter/紫色渐变/Lorem ipsum。

核心产出：`DESIGN.md` / `tokens.json` / `design-to-solo.md` / `component-contract.json`

### harness-solo — "写好代码"

工程开发、TDD、调试、验证、代码审查。19 个 skill。特色：单一规范交付流水线、稳定验收证据和由代码审查独占的完成状态。

核心产出：`TECH_STACK.md` / `solo-to-growth.md` / `solo-to-ops.md` / `spec.md`

### harness-growth — "让人用起来"

内容生产、SEO、用户运营、增长实验。40 个 skill，9 个模块。特色：**实验驱动** — 每个动作都有假设和指标。

核心产出：`GROWTH_STRATEGY.md` / 内容资产 / 实验记录 / `growth-to-pm.md`

### harness-ops — "保驾护航"

基础设施即代码、自动化部署、监控告警、容灾响应。32 个 skill。特色：**半自动化架构** — Agent 提议、人类审批、GitOps 执行。四级操作原语（`inspect` → `propose` → `mutate-staging` → `mutate-prod`），严格权限管控。

核心产出：部署记录 / 监控配置 / 故障报告 / `ops-to-pm.md`

---

## 运作原理

### 三层架构

```
编排层（未来，非当前目标）
              ↕ 契约文档
框架层       pm / design / solo / growth / ops
              ↕ 加载链
基础层       AGENTS.md · SOUL.md · constitution.md · LOOP.md · skills/
```

### 契约协作

框架间通过 `docs/handoff/` 下的结构化文档传递需求。每份文档有明确的**生产方**和**消费方**。写入权限单向隔离——消费方只读不写。

| 生产方 → 消费方 | 文档 |
|:---:|---|
| pm → design | `pm-to-design.md` |
| pm → solo | `pm-to-solo.md` |
| pm → growth | `pm-to-growth.md` |
| design → solo | 含 `design-to-solo.md` + `component-contract.json` 的可移植交接包 |
| solo → growth | `solo-to-growth.md` |
| solo → ops | `solo-to-ops.md` |
| growth → pm | `growth-to-pm.md` |
| ops → pm | `ops-to-pm.md` |

AC 编号跨框架对齐：`AC-xxx`（工程）来自 PM，`DAC-xxx`（设计）来自 Design——solo 的 verify skill 同时验证两者。

### LOOP 引擎

所有任务走 计划→执行→验证 循环。证据驱动：没有证据不能宣称完成。`state.yaml` 支持断点续传。硬熔断 10 次迭代。

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

上下文爆炸和记忆污染是 AI Agent 协作的核心痛点。单个 Agent 加载 196 个 skill 浪费 token、降低输出质量。独立框架让每个 Agent 专精一个领域。

### 为什么用契约文档而非共享状态

目前没有编排层。契约文档是最低耦合的协作方式——生产一份文档，下游消费。编排层就绪后，共享状态可逐步替代部分契约。

### 为什么用极简 frontmatter

重型 YAML frontmatter（`triggers` / `reads` / `writes` / `quality_gates` / `max_iterations`）在开源界极其罕见。极简 frontmatter（`name` + `description`）+ 自然语言正文段落是主流趋势——更可读、更易维护。

---

## 文档导航

| 文档 | 内容 |
|------|------|
| [ARCHITECTURE.md](./ARCHITECTURE.md) | 完整架构设计（v2.2） |
| [DOMAIN_BOUNDARIES.md](./DOMAIN_BOUNDARIES.md) | 规范化职责边界与路由规则 |
| [HANDOFF_PROTOCOL.md](./HANDOFF_PROTOCOL.md) | 可版本化契约协议 |
| [UPGRADING.md](./UPGRADING.md) | 冲突安全的框架升级流程 |
| [harness-pm/README.md](./harness-pm/README.md) | PM 框架详情 |
| [harness-design/README.md](./harness-design/README.md) | 设计框架详情 |
| [harness-solo/README.md](./harness-solo/README.md) | 工程框架详情 |
| [harness-growth/README.md](./harness-growth/README.md) | 增长框架详情 |
| [harness-ops/README.md](./harness-ops/README.md) | 运维框架详情 |

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
