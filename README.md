<div align="center">

# 🪢 harness-all

### 个人 AI 工作室 · 多 Agent 框架家族

> **一套给 AI Agent 用的"独立优先、契约协作"框架家族**
> 每个框架专精一个领域，独立工作；通过契约文档协作，形成完整闭环。

---

![Version](https://img.shields.io/badge/version-v2.1-blue.svg?style=for-the-badge&logo=semver)
![Frameworks](https://img.shields.io/badge/frameworks-5-green.svg?style=for-the-badge&logo=github)
![Skills](https://img.shields.io/badge/skills-206-orange.svg?style=for-the-badge&logo=skill)
![Workflows](https://img.shields.io/badge/workflows-36-purple.svg?style=for-the-badge&logo=git)
![License](https://img.shields.io/badge/license-MIT-blue.svg?style=for-the-badge&logo=open-source-initiative)
![Status](https://img.shields.io/badge/status-production--ready-brightgreen.svg?style=for-the-badge&logo=checkmarx)

---

| 框架 | 职责 | Skill | Workflow | 状态 |
|:----:|------|:-----:|:--------:|:----:|
| **harness-pm** | 战略 · 市场 · 产品 · PRD · 度量 | 86 | 10 | ✅ |
| **harness-design** | UI · 视觉 · 交互 · 原型 · 设计系统 | 18 | 6 | ✅ |
| **harness-solo** | 工程开发 · TDD · 调试 · 重构 · 验证 | 20 | 7 | ✅ |
| **harness-growth** | 运营 · 内容 · SEO · 增长实验 | 40 | 6 | ✅ |
| **harness-ops** | 运维 · 部署 · 监控 · 容灾 | 32 | 7 | ✅ |

**总计**：5 个框架 · 206 个 Skill · 36 个 Workflow · 11 份契约文档 · 25 种 LOOP 循环类型

</div>

---

## 📖 目录

- [🎯 设计哲学](#-设计哲学)
- [💡 为什么需要框架](#-为什么需要框架)
- [🏛️ 三层架构](#️-三层架构)
- [👨‍👩‍👧‍👦 框架家族总览](#-框架家族总览)
- [✨ 核心特性](#-核心特性)
- [🚀 快速开始](#-快速开始)
- [🔧 框架详解](#-框架详解)
- [📜 契约协作模式](#-契约协作模式)
- [⚙️ 统一基础层规范](#️-统一基础层规范)
- [🔄 LOOP 循环引擎](#-loop-循环引擎)
- [🛡️ 安全与合规](#️-安全与合规)
- [🗺️ 演进路线](#️-演进路线)
- [📚 文档导航](#-文档导航)
- [🤝 贡献与许可](#-贡献与许可)

---

## 🎯 设计哲学

### 核心理念：独立优先，契约协作

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   独立工作 ──── 契约协作 ──── 多 Agent 编排                  │
│   (当前阶段)    (当前阶段)     (未来演进，非目标)            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**为什么独立而非统一**：

| 维度 | 统一框架 | 独立框架（本方案） |
|------|---------|-------------------|
| 上下文成本 | 单 Agent 加载所有 skill，上下文爆炸 | 每个 Agent 只加载本领域 skill |
| 记忆污染 | 产品/工程/设计/增长记忆混杂 | 各框架独立 memory，互不干扰 |
| 调试隔离 | 一个领域的 bug 影响全局 | 框架间完全隔离 |
| 工具适配 | 一套工具链适配所有场景 | 每个框架按需选工具 |
| 项目归属 | 一个项目一个 Agent | 不同框架可挂到不同项目/工作目录 |

**结论**：上下文爆炸和记忆污染是 AI Agent 协作的核心痛点，独立框架是当前最务实的选择。

### 四条铁律

1. **独立自洽** —— 每个框架必须能独立完成本领域工作，不依赖其他框架
2. **契约协作** —— 框架间通过 `docs/handoff/` 下的契约文档传递需求
3. **循环验证** —— 所有任务走 LOOP（plan→execute→verify），证据驱动
4. **安全红线** —— 不可协商原则写入 constitution.md，Agent 必须遵守

---

## 💡 为什么需要框架

### 没有框架时，AI Agent 的真实困境

大多数人使用 AI Agent 的方式是：打开对话 → 描述需求 → 拿到结果 → 关闭对话。下次打开，一切从零开始。

```
❌ 没有 framework 的日常

  第 1 次对话：  "帮我写个 PRD"           → Agent 不知道你的产品背景，从零问起
  第 2 次对话：  "帮我设计这个页面"        → Agent 不知道 PRD 长什么样，从零问起
  第 3 次对话：  "帮我实现这个功能"        → Agent 不知道设计稿长什么样，从零问起
  第 4 次对话：  "帮我写个增长方案"        → Agent 不知道产品现状，从零问起
  ...每次对话都是失忆的，每次都要重新建立上下文
```

**核心问题不是 Agent 不够聪明，而是没有持久的项目记忆和领域知识。**

### 框架解决了什么

harness 框架的本质不是"更好的 prompt"，而是**为 AI Agent 构建持久化的项目知识体系**：

| 能力 | 没有 framework | 有 harness framework |
|------|---------------|---------------------|
| **项目知识库** | 每次对话从零解释项目背景 | `knowledge-base.md` 持续积累项目决策、技术选型、踩坑记录 |
| **工作区记忆** | 关闭对话即失忆 | `progress.md` 跨会话保持进度，下次打开自动恢复 |
| **领域专精** | 一个 Agent 什么都做，什么都不精 | 每个框架只聚焦一个领域，skill 精准匹配场景 |
| **上下文效率** | 全量加载，token 浪费严重 | 按需加载 INDEX → SKILL.md，只读必要的 |
| **协作可追溯** | 口头/聊天记录传递需求 | 契约文档（handoff）结构化传递，AC 编号跨框架对齐 |
| **质量可验证** | "我觉得做完了" | LOOP 引擎 + 证据门禁，没有证据不声称完成 |
| **安全有红线** | Agent 可能越权操作 | constitution.md 不可协商，security.md 统一禁止 |
| **经验可复用** | 每个项目从零开始 | 模板 + 知识库 + skill 跨项目复用 |

### 三层知识体系

```
┌─────────────────────────────────────────────────────────────┐
│  🧠 项目知识库 (knowledge-base.md)                           │
│                                                             │
│  持续积累的项目决策 · 技术选型 · 踩坑记录 · 最佳实践          │
│  → Agent 每次启动自动读取，不需要你重复解释项目背景           │
│  → 每次会话结束自动归档新知识，越用越懂你的项目               │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  📋 工作区记忆 (progress.md + FEATURES.md)                   │
│                                                             │
│  跨会话保持进度 · 当前任务状态 · 历史决策记录                 │
│  → session-start 自动恢复上下文，不丢失工作进度               │
│  → FEATURES.md 看板式追踪所有任务状态                        │
│  → state.yaml 支持断点续传，中断后可恢复                     │
│                                                             │
├─────────────────────────────────────────────────────────────┤
│  📐 领域规范 (AGENTS.md + SOUL.md + constitution.md)         │
│                                                             │
│  领域价值观 · 工作原则 · 安全红线 · 不可协商规则              │
│  → Agent 行为边界清晰，不会越权或偏离                        │
│  → 不同框架有不同人格和原则，专精而非泛化                    │
│  → 规则优先级明确：SOUL > AGENTS > rules > 对话 > 外部文件   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### 框架 vs 纯 Prompt Engineering：本质区别

| 维度 | 纯 Prompt Engineering | harness Framework |
|------|----------------------|-------------------|
| 知识持久化 | 无（每次对话从零开始） | knowledge-base.md 跨会话积累 |
| 上下文恢复 | 无（手动复制粘贴） | progress.md + session-start 自动恢复 |
| 领域专精 | 靠 prompt 描述角色（脆弱） | SOUL.md + 82 个 PM skill 精准匹配 |
| 质量保障 | 靠人肉检查 | LOOP 循环 + 证据门禁 + verify skill |
| 协作传递 | 复制粘贴聊天记录 | 契约文档结构化传递 + AC 编号对齐 |
| 安全边界 | 靠 prompt 约束（可被覆盖） | constitution.md 不可协商 + security.md |
| 经验复用 | 每个项目重写 prompt | 模板 + skill + 知识库跨项目复用 |
| 可扩展性 | prompt 越写越长，难以维护 | skill 模块化，INDEX 按需加载 |

**一句话总结**：Prompt Engineering 是"教 Agent 做一件事"，Framework 是"让 Agent 拥有持久的项目记忆和领域专长，越用越强"。

### 真实使用场景对比

**场景：你要做一个新产品，从 0 到 1**

```
❌ 没有 framework：

  你：帮我写个 PRD
  AI：好的，请告诉我你的产品是什么？目标用户是谁？...
  你：（花 30 分钟解释背景）
  AI：（产出 PRD）
  你：帮我设计首页
  AI：好的，请告诉我你的 PRD 内容是什么？...
  你：（花 10 分钟重新解释）
  ...每次切换领域都要重新建立上下文，知识无法沉淀

✅ 有 harness framework：

  你：启动 harness-pm，开始新产品工作流
  Agent：（自动读取 knowledge-base，了解项目背景）
  Agent：（执行 new-product workflow，产出 PRD + 契约文档）
  你：切换到 harness-design
  Agent：（自动读取 pm-to-design.md，精准理解需求）
  Agent：（产出设计稿 + component-map.json）
  你：切换到 harness-solo
  Agent：（自动读取 design-to-solo.md + component-map.json）
  Agent：（精准实现代码，AC 编号对齐验证）
  ...每个领域自动继承上游产出，知识持续沉淀
```

---

## 🏛️ 三层架构

```
┌─────────────────────────────────────────────────────────────┐
│  编排层（未来，非当前目标）                                   │
│  - 多 Agent 调度 / 共享事实源 / 跨框架 LOOP                  │
└─────────────────────────────────────────────────────────────┘
                          ↕ 契约文档
┌─────────────────────────────────────────────────────────────┐
│  框架层（当前重点）                                           │
│  harness-pm / harness-design / harness-solo                  │
│  harness-growth / harness-ops                                │
│  + 扩展框架（data/qa/security，按需建设）                    │
└─────────────────────────────────────────────────────────────┘
                          ↕ 加载链
┌─────────────────────────────────────────────────────────────┐
│  基础层（每个框架内部）                                       │
│  AGENTS.md / SOUL.md / constitution.md / LOOP.md / skills/  │
└─────────────────────────────────────────────────────────────┘
```

### 适用场景

- **个人 AI 工作室**：一个人 + 多个 AI Agent，每个 Agent 专精一个领域
- **小团队协作**：不同成员负责不同框架，通过契约文档对齐
- **多项目并行**：每个框架可挂到不同项目目录，互不干扰

---

## 👨‍👩‍👧‍👦 框架家族总览

### 框架分类与状态

| 分类 | 框架 | 职责 | 状态 | Skill 数 |
|------|------|------|------|---------|
| 核心 | **harness-pm** | 战略 · 市场 · 产品 · PRD · 度量 · 增长监控 | ✅ 已建设 | 86 skill（82 领域 + 4 meta）+ 10 workflow |
| 核心 | **harness-design** | UI · 视觉 · 交互 · 原型 · 设计系统 | ✅ 已建设 | 18 skill（14 领域 + 4 meta）+ 6 workflow |
| 核心 | **harness-solo** | 工程开发 · TDD · 调试 · 重构 · 验证 | ✅ 已建设 | 20 skill（16 领域 + 4 meta）+ 7 workflow |
| 核心 | **harness-growth** | 运营 · 内容 · SEO · 增长实验 | ✅ 已建设 | 40 skill（36 领域 + 4 meta）+ 6 workflow |
| 扩展 | **harness-ops** | 运维 · 部署 · 监控 · 容灾 | ✅ 已建设 | 32 skill（28 领域 + 4 meta）+ 7 workflow |
| 扩展 | harness-data | 数据管道 · ETL · 指标生产 | 📋 P1 待建 | - |
| 扩展 | harness-qa | 质量保障 · 自动化测试 · 性能测试 | ⚠️ P2 按需 | - |
| 扩展 | harness-security | 安全审计 · 合规 · 渗透 | ⚠️ P3 按需 | - |

### 框架职责边界（不重叠原则）

```
┌─────────────┐  PRD + Persona + AC   ┌─────────────┐  design-to-solo.md   ┌─────────────┐
│ harness-pm  │ ────────────────────> │harness-design│ ───────────────────> │ harness-solo│
│ 做"对的事"  │                        │ 做"好看好用" │ + component-map     │ 做"写好代码"│
│             │  PRD + AC + 埋点        │             │ + tokens.json       │             │
│             │ ───────────────────────────────────────────────────────> │             │
└─────────────┘                        └─────────────┘                     └─────────────┘
       │                                                                     │
       │ 指标 + 增长策略                                                      │ 已实现功能 + 埋点
       ▼                                                                     ▼
       └──────────────────> ┌─────────────┐ <──────────────────────────────┘
                            │harness-growth│
                            │ 做"被用起来"│
                            └─────────────┘
                                   ▲
                                   │ solo-to-ops.md（部署契约）
                                   │
                            ┌─────────────┐
                            │ harness-ops │
                            │ 做"护航交付"│
                            └─────────────┘
                                   │
                                   │ ops-to-pm.md（SLA + 故障复盘）
                                   ▼
                            （反馈给 harness-pm）
```

**职责边界铁律**：

| 领域 | 归属 | 禁止越界 |
|------|------|---------|
| 产品需求（PRD/AC/Persona） | harness-pm | design 不定义 PRD，solo 不修改 PRD |
| 视觉设计（配色/排版/组件） | harness-design | pm 不定义颜色，solo 不硬编码值 |
| 交互设计（状态机/动画/手势） | harness-design | pm 不定义动画参数，solo 按规格实现 |
| 工程实现（代码/测试/架构） | harness-solo | pm/design 不写代码 |
| 增长运营（内容/SEO/实验） | harness-growth | pm 提供指标，growth 执行实验 |
| 运维保障（发布/监控/容灾） | harness-ops | solo 不直接操作线上，需通过 ops 执行 IaC |

---

## ✨ 核心特性

### 1. 独立框架 · 上下文隔离

每个框架是完全独立的目录，可以挂到不同的项目目录，由不同的 Agent 实例加载，有独立的 `.harness/` 配置、memory、progress。

### 2. 契约协作 · 跨框架对齐

通过 `docs/handoff/` 下的契约文档传递需求，支持多人 + 多 Agent 协作。AC 编号体系跨框架对齐（`AC-xxx` 工程 + `DAC-xxx` 设计流入工程）。

### 3. LOOP 引擎 · 证据驱动

所有框架统一的循环引擎，支持 state.yaml 断点续传、迭代上限保护、证据驱动原则。单 LOOP 硬熔断 10 次。

### 4. 安全红线 · 不可协商

每个框架的 `constitution.md` 定义不可协商原则，`rules/security.md` 定义统一禁止项。ops 框架额外增加 Secret 严格隔离和 7 层纵深防御。

### 5. 跨平台兼容

Agent 工具优先（Read/Write/Edit/Glob/Grep），bash 可选兜底。所有脚本有 bash 可用性检查，Windows 环境自动跳过。

### 6. 半自动化架构（harness-ops 专属）

Agent 建议 + 人类审批 + GitOps 执行。四类操作原语（inspect/propose/mutate-staging/mutate-prod）精确控制自动化边界。

---

## 🚀 快速开始

### 1. 选择你需要的框架

```bash
# 个人 AI 工作室全套（推荐）
git clone <harness-all-repo>

# 或只克隆单个框架
git clone <harness-pm-repo>      # 产品管理
git clone <harness-design-repo>  # UI 设计
git clone <harness-solo-repo>    # 工程开发
git clone <harness-growth-repo>  # 运营增长
git clone <harness-ops-repo>     # 运维保障
```

### 2. 安装到你的项目

```bash
# 进入你的项目目录
cd my-project

# 执行安装脚本（以 harness-solo 为例）
bash /path/to/harness-solo/install.sh

# 安装脚本会：
# 1. 检查依赖（git 必需，Node.js 按需）
# 2. 创建 .harness/ 目录结构
# 3. 复制 AGENTS.md / SOUL.md / constitution.md
# 4. 初始化 memory/progress.md
# 5. 创建 docs/handoff/ 目录
```

### 3. 启动 Agent

```
# 在你的项目目录下启动 AI Agent（如 Trae IDE）

# Agent 会按加载链自动读取：
# 1. AGENTS.md（启动必读）
# 2. SOUL.md + constitution.md（首次交互时）
# 3. skills/INDEX.md（需要选 Skill 时）
# 4. 对应 SKILL.md（执行任务时）
# 5. memory/progress.md（session-start 时）
```

### 4. 多框架协作

```bash
# 场景：PM 产出 PRD → Design 出设计稿 → Solo 实现代码

# 1. 在产品项目目录下用 harness-pm
cd product-project
# Agent 产出：docs/handoff/pm-to-design.md + pm-to-solo.md

# 2. 手动复制契约文档到设计项目
cp product-project/docs/handoff/pm-to-design.md design-project/docs/handoff/

# 3. 在设计项目目录下用 harness-design
cd design-project
# Agent 消费 pm-to-design.md，产出：design-to-solo.md + component-map.json

# 4. 手动复制契约文档到工程项目
cp design-project/docs/handoff/design-to-solo.md engineering-project/docs/handoff/
cp design-project/docs/handoff/component-map.json engineering-project/docs/handoff/

# 5. 在工程项目目录下用 harness-solo
cd engineering-project
# Agent 消费 pm-to-solo.md + design-to-solo.md + component-map.json，实现代码
```

---

## 🔧 框架详解

### harness-pm（产品管理框架）

> **定位**：做"对的事"——产品探索、市场分析、PRD 生成、度量运营

**四原则**：
1. Discovery First（探索先行）—— 不假设需求，用研究数据说话
2. Contract-Driven（契约驱动）—— PRD 驱动设计，定位驱动品牌
3. Data-Driven（数据决策）—— 用数据减少猜测，决策权在人类
4. Closed-Loop（闭环迭代）—— 度量→监控→迭代→反馈

**Skill 体系**（86 skill = 82 领域 + 4 meta）：
- 模块 1 探索发现（12）：user-research / market
- 模块 2 商业战略（13）：business / planning
- 模块 3 构思设计（9）：prd / validation
- 模块 4 度量设计（4）：metrics
- 模块 5 度量运营（11）：analysis / decision / experiment
- 模块 6 增长运营（16）：growth / acquisition / activation / retention / revenue
- 模块 7 监控迭代（17）：monitoring / diagnosis / iteration / release

**特色机制**：
- **UI 指令越权门禁**：PRD 产出时强制拦截 PM 夹带具体视觉/交互形态
- **orchestrator-pipeline 二层架构**：19 个 orchestrator 编排 63 个 pipeline skill

**核心产出**：`docs/product/PRD.md` / `docs/strategy/PRODUCT_STRATEGY.md` / `docs/handoff/pm-to-{design,solo,growth}.md`

---

### harness-design（UI 设计框架）

> **定位**：做"好看好用"——视觉设计、交互设计、原型产出、设计规范

**四原则**：
1. User-Centered（以用户为中心）—— Persona 驱动，不假设审美
2. System-First（系统优先）—— 先建设计系统再画页面
3. Accessible by Design（可访问性内建）—— WCAG 2.1 AA 是硬约束
4. Deliverable（可交付）—— 设计稿必须可被工程实现

**Skill 体系**（18 skill = 14 设计 + 4 meta）：
- 需求与推荐：design-brief / design-recommendation
- 设计系统：design-system / design-system-import / design-system-refactor
- 设计产出：visual-design / interaction-design / wireframe / component-design
- 审查与验证：verify / design-lint / design-review / accessibility-audit
- 交付：design-handoff-spec

**特色机制**：
- **Push-back 防越权抗旨**：设计 Agent 有权拒绝 PM 违规写死的 UI 指令并重写
- **Anti AI-Slop**：禁用 Inter/紫渐变/统一圆角/Lorem ipsum，由 design-lint 机械检查
- **Doubt-Driven 对抗式审查**：design-review 用 fresh-context 子 agent 做对抗式审查
- **component-map.json**：显式映射层，机器可读的组件契约

**核心产出**：`docs/design-system/DESIGN.md` / `docs/design-system/tokens.json` / `docs/handoff/design-to-solo.md` + `component-map.json`

---

### harness-solo（工程开发框架）

> **定位**：做"写好代码"——需求探索、TDD、调试、验证、代码审查

**卡帕西四原则**：
1. Think Before Coding（先思考后编码）—— 不代替用户做假设
2. Simplicity First（简单优先）—— 不做 speculative 抽象
3. Surgical Changes（手术刀式修改）—— 只改必须改的代码
4. Goal-Driven Execution（目标驱动执行）—— 循环验证直到达成

**Skill 体系**（20 skill = 16 工程 + 4 meta）：
- 需求与规划：brainstorming / writing-plans / executing-plans
- 测试与调试：test-driven-development / test-coverage / systematic-debugging
- 前端与性能：frontend-implementation / webapp-testing / performance-optimization
- 迁移与依赖：migration / dependency-management
- 验证与审查：verify / requesting-code-review / receiving-code-review
- 文档与技能：writing-documentation / writing-skills

**特色机制**：
- **双源 AC 验证**：verify 同时检查工程 AC（`AC-xxx`）和设计 AC（`DAC-xxx`）
- **component-map.json 消费契约**：frontend-implementation 读取组件映射作为单一事实源
- **熵检查**：verify 检查文件增长率/LOC 增长率/依赖膨胀/TODO 积压
- **git hooks**：pre-commit（secret/敏感文件/commit-msg 检查）+ pre-push

**核心产出**：`docs/engineering/TECH_STACK.md` / `docs/handoff/solo-to-{growth,ops}.md` / `.harness/loops/specs/<feature>/spec.md`

---

### harness-growth（运营增长框架）

> **定位**：做"被用起来"——内容生产、SEO、用户运营、增长实验

**四原则**：
1. Experiment-Driven（实验驱动）—— 每个动作有假设有度量
2. Content-First（内容优先）—— 质量 > 数量，不做内容农场
3. Long-Term（长期主义）—— SEO 不做黑帽，不刷量
4. Data-Loop（数据闭环）—— 每个实验有结论有行动

**Skill 体系**（40 skill = 36 领域 + 4 meta）：
- 模块 1 增长策略（5）：nsm-definition / kpi-tree / aarr-diagnosis / growth-loop-design / four-fits-assessment
- 模块 2 增长实验（6）：hypothesis-generation / ice-scoring / experiment-design / sample-size-calc / experiment-analysis / experiment-conclusion
- 模块 3 内容营销（5）：content-ideation / content-creation / content-review / content-distribution / content-performance
- 模块 4 SEO 优化（5）：keyword-research / serp-analysis / onpage-optimization / technical-seo-audit / ranking-tracking
- 模块 5 用户运营（5）：user-segmentation / onboarding-design / aha-moment-identification / retention-analysis / churn-rescue
- 模块 6 获客投放（3）：channel-assessment / landing-page-optimization / cac-analysis
- 模块 7 变现（3）：pricing-strategy / paywall-optimization / nrr-analysis
- 模块 8 数据分析（3）：funnel-analysis / cohort-analysis / metric-anomaly-detection
- 模块 9 增长审查（1）：growth-review

**核心产出**：`docs/operations/GROWTH_STRATEGY.md` / `docs/content/` / `docs/seo/` / `docs/experiment/` / `docs/handoff/growth-to-pm.md`

---

### harness-ops（运维与基础设施框架）

> **定位**：做"护航与交付"——基础设施即代码、自动化部署、监控告警、容灾与应急响应

**SRE 四原则**：
1. Stability-First（稳定性第一）—— 不出故障是最高优指标
2. Infrastructure as Code（基建即代码）—— 环境可版本控制、可一键重建
3. Observability（无死角可观测）—— Logs / Metrics / Traces 缺一不可
4. Automation（无情自动化）—— 消除重复性劳作（Toil）

**Skill 体系**（32 skill = 28 领域 + 4 meta）：
- 模块 1 部署交付（4）：deployment-pipeline / release-strategy / rollback / deployment-verify
- 模块 2 基础设施（4）：infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- 模块 3 监控可观测（4）：monitoring-setup / alerting-rules / log-analysis / dashboard-design
- 模块 4 故障响应（4）：incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- 模块 5 安全合规（4）：secret-management / policy-as-code / security-scan / audit-review
- 模块 6 容量成本（3）：resource-right-sizing / cost-analysis / capacity-planning
- 模块 7 容灾备份（3）：backup-management / recovery-drill / disaster-recovery-plan
- 模块 8 运维审查（2）：ops-review / sla-report

**特色机制**：
- **半自动化架构**：Agent 建议 + 人类审批 + GitOps 执行
- **四类操作原语**（frontmatter `operation_tier` 字段）：
  - `inspect` —— 只读巡检，Agent 全自动（13 个 skill）
  - `propose` —— 生成 PR/提案，人类 review 后合并（12 个 skill）
  - `mutate-staging` —— Staging 直接执行白名单操作（3 个 skill）
  - `mutate-prod` —— 生产变更，**必须人类审批**
- **GitOps PR 间接执行**：Agent 永远不直接操作生产集群
- **Secret 严格隔离**：Agent 只操作 Secret 的引用，永远不接触明文值
- **7 层纵深防御**：Dry-run / Canary / Approval gate / Rate limit / Rollback / Audit / Blast radius
- **7 张知识库表**：故障库 / 根因库 / 部署记录库 / 监控配置库 / IaC 资产库 / 运维模式沉淀 / 踩坑记录

**核心产出**：`docs/deployment/` / `docs/monitoring/` / `docs/infrastructure/` / `docs/incident/` / `docs/handoff/ops-to-pm.md`

---

## 📜 契约协作模式

### 契约文档体系

框架间通过 `docs/handoff/` 下的契约文档协作。每个文档有明确的**源框架**和**目标框架**。

```
docs/handoff/
├── README.md                    # 交接协议说明
├── handoff-template.md          # 通用模板
│
├── pm-to-design.md              # 契约：PM → Design（PRD + Persona + AC）
├── pm-to-solo.md                # 契约：PM → Solo（PRD + AC + 埋点）
├── pm-to-growth.md              # 契约：PM → Growth（指标 + 增长策略）
├── design-to-solo.md            # 契约：Design → Solo（设计稿 + AC + 组件映射）
├── design-to-pm.md              # 契约：Design → PM（设计反馈，按需）
├── solo-to-growth.md            # 契约：Solo → Growth（已实现功能 + 埋点）
├── solo-to-pm.md                # 契约：Solo → PM（工程反馈，按需）
├── solo-to-ops.md               # 契约：Solo → Ops（部署契约）
├── ops-to-pm.md                 # 契约：Ops → PM（SLA 报告 + 故障复盘）
├── growth-to-pm.md              # 契约：Growth → PM（实验结果 + 数据反馈）
└── component-map.json           # 契约：Design → Solo（显式映射层，机器可读）
```

### 契约文档流转图

```
┌─────────────┐  pm-to-design.md    ┌─────────────┐
│ harness-pm  │ ──────────────────> │harness-design│
│             │ <─────────────────  │             │
│             │  design-to-pm(按需) │             │
│             │                     └─────────────┘
│             │                           │
│             │                     design-to-solo.md
│             │ pm-to-solo.md       + component-map.json
│             │                           ▼
│             │ ──────────────────> ┌─────────────┐
│             │                     │ harness-solo│
│             │ <─────────────────  │             │
│             │  solo-to-pm(按需)   │             │
└─────────────┘                     └─────────────┘
        ▲                                 │
        │ growth-to-pm.md                 │ solo-to-growth.md
        │                                 ▼
        │                         ┌─────────────┐
        │  pm-to-growth.md        │harness-growth│
        └────────────────────────>│             │
        ▲                         └─────────────┘
        │ ops-to-pm.md                    ▲
        │                                 │ solo-to-ops.md
        │                         ┌─────────────┐
        └──────────────────────── │ harness-ops │
                                  └─────────────┘
```

### 契约文档矩阵

| 源 \ 目标 | harness-pm | harness-design | harness-solo | harness-growth | harness-ops |
|-----------|:---:|:---:|:---:|:---:|:---:|
| harness-pm | - | pm-to-design.md | pm-to-solo.md | pm-to-growth.md | - |
| harness-design | design-to-pm.md（按需） | - | design-to-solo.md + component-map.json | - | - |
| harness-solo | solo-to-pm.md（按需） | - | - | solo-to-growth.md | solo-to-ops.md |
| harness-growth | growth-to-pm.md | - | - | - | - |
| harness-ops | ops-to-pm.md | - | - | - | - |

### AC 编号体系（跨框架对齐）

| AC 类型 | 前缀 | 来源 | 消费方 | 示例 |
|---------|------|------|--------|------|
| 工程 AC | `AC-xxx` | harness-pm 的 PRD | harness-solo 的 spec.md | `AC-001: 用户可登录` |
| 设计 AC（流入工程） | `DAC-xxx` | harness-design 的 design-to-solo.md | harness-solo 的 spec.md | `DAC-001: 375px 无溢出` |

**防腐规则**：
- harness-pm 的 PRD 产出 `AC-xxx`（受 UI 指令越权门禁拦截）
- harness-design 的 design-brief 沿用 PRD 的 `AC-xxx` 编号，行使 Push-back 净化权
- harness-solo 的 writing-plans 把设计 AC 转为 `DAC-xxx`（加 D 前缀区分来源）
- harness-solo 的 verify 同时检查 `AC-xxx` 和 `DAC-xxx`

---

## ⚙️ 统一基础层规范

### 每个框架必须有的基础文件

| 文件 | 作用 | 强制 |
|------|------|:---:|
| `AGENTS.md` | 启动必读，核心规则 + 领域原则 | ✅ |
| `SOUL.md` | Agent 人格 + 领域价值观 | ✅ |
| `constitution.md` | 项目宪法（不可协商原则） | ✅ |
| `install.sh` | 冷启动安装脚本 | ✅ |
| `README.md` | 框架说明 | ✅ |
| `.harness/loops/LOOP.md` | 循环引擎定义 | ✅ |
| `.harness/skills/INDEX.md` | skill 索引 | ✅ |
| `.harness/skills/meta/` | 4 个元 skill | ✅ |
| `.harness/rules/security.md` | 安全红线 | ✅ |
| `.harness/rules/prompt-defense.md` | prompt 注入防护 | ✅ |
| `.harness/memory/progress.md` | 会话进度日志 | ✅ |
| `.harness/memory/knowledge-base.md` | 跨会话知识库 | ✅ |
| `.harness/FEATURES.md` | 动态任务状态看板 | ✅ |
| `.harness/VERSION` | 框架版本 | ✅ |
| `.harness/templates/SKILL.md.template` | skill 模板 | ✅ |
| `docs/handoff/README.md` | 交接协议说明 | ✅ |
| `docs/handoff/handoff-template.md` | 通用交接模板 | ✅ |

### 4 个元 skill（所有框架统一）

| 元 skill | 职责 | 触发时机 |
|----------|------|---------|
| session-start | 会话启动，恢复上下文 | 每次会话开始 |
| session-end | 会话收尾，归档 + 产出交接文档 | 任务完成/会话结束 |
| skill-maintenance | skill 增删改维护 | skill 变更时 |
| memory-maintenance | memory/knowledge-base 维护 | 定期/按需 |

### 加载链（每个框架独立遵循）

```
1. AGENTS.md          — 启动必读（唯一强制入口）
2. SOUL.md            — 人格 + 领域价值观
3. constitution.md    — 项目宪法（不可协商原则）
4. skills/INDEX.md    — skill 索引
5. 对应 SKILL.md      — 执行任务时按需加载
6. memory/progress.md — session-start 时读
```

**指令优先级**（所有框架统一）：

```
SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
```

---

## 🔄 LOOP 循环引擎

### 统一规范

所有框架的 LOOP 必须支持：

- **state.yaml 断点续传**：会话中断后可恢复
- **迭代上限保护**：超限请求人类介入
- **证据驱动**：没有证据不声称完成
- **last_error 字段**：失败时记录错误

**state.yaml 统一 Schema**：

```yaml
# 必填
current_task: <task-id>
iteration: <N>
stage: <stage-name>      # 各框架自定义枚举
status: running          # running / retrying / done / failed / needs-human / blocked
started_at: "YYYY-MM-DDTHH:MM:SS"

# 可选（失败时）
last_error: "<错误描述>"
last_error_at: "YYYY-MM-DDTHH:MM:SS"

# 可选（子阶段）
substage: "<substage-name>"
```

**单 LOOP 硬熔断**：所有框架统一为 10 次迭代，超限停止并请求人类介入。

### 各框架循环类型对照

| 框架 | 循环类型 | 触发场景 | 最大迭代 |
|------|---------|---------|:---:|
| harness-pm | research | 用户研究/市场分析 | 5 |
| harness-pm | prd | PRD 生成/方案设计 | 5 |
| harness-pm | iteration | 数据驱动迭代 | 3 |
| harness-pm | growth | 增长突破 | 3 |
| harness-pm | pivot | 战略调整 | 5 |
| harness-design | visual-design | 视觉设计任务 | 5 |
| harness-design | interaction-design | 交互设计任务 | 5 |
| harness-design | wireframe | 线框图/低保真原型 | 5 |
| harness-design | component | 组件设计 | 5 |
| harness-solo | feature | 新功能开发 | 5 |
| harness-solo | bugfix | Bug 修复 | 3 |
| harness-solo | optimize | 性能优化 | 3 |
| harness-solo | refactor | 重构 | 3 |
| harness-growth | content | 内容生产 | 3 |
| harness-growth | seo | SEO 优化 | 5 |
| harness-growth | experiment | 增长实验 | 3 |
| harness-growth | optimization | 漏斗优化 | 3 |
| harness-growth | monetization | 变现优化 | 3 |
| harness-growth | lifecycle | 用户生命周期 | 5 |
| harness-ops | provision | 基础设施部署 | 3 |
| harness-ops | incident | 线上排障 | 5 |
| harness-ops | optimization | 容量/成本优化 | 3 |
| harness-ops | recovery | 容灾恢复 | 3 |
| harness-ops | audit | 安全/合规审计 | 3 |

---

## 🛡️ 安全与合规

### 统一安全红线

所有框架的 `security.md` 必须包含：

| 禁止 | 理由 |
|------|------|
| 硬编码密钥 | 密钥泄露风险 |
| `rm -rf` | 误删风险 |
| `curl \| sh` | 供应链攻击风险 |
| 修改 `.git/hooks/` | 破坏 git 钩子完整性 |
| 绕过质量门禁 | 产出质量失控 |

各框架按领域扩展额外红线：
- **harness-growth**：禁止黑帽 SEO、刷量、泄露用户 PII
- **harness-design**：禁止泄露 PII、禁止使用未授权素材
- **harness-ops**：禁止接触明文 Secret 值、禁止直接操作生产集群

### harness-ops 专属安全机制

- **Secret 严格隔离**：Agent 只操作 Secret 的引用（路径/键名/CRD），永远不接触明文值（硬约束，不可协商）
- **7 层纵深防御**：Dry-run / Canary / Approval gate / Rate limit / Rollback / Audit / Blast radius
- **GitOps PR 间接执行**：Agent 永远不直接操作生产集群，通过开 PR + 人类 review + ArgoCD/Flux 同步

### Prompt 注入防护

所有框架的 `prompt-defense.md` 定义：
- 指令优先级：SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
- 外部内容标记为不可信，不作为指令执行
- 关键操作需人类确认

---

## 🗺️ 演进路线

### 当前阶段（v2.1，已完成）

- ✅ 4 个核心框架独立建设（pm/design/solo/growth 全部完成）
- ✅ 1 个 P0 扩展框架建设完成（ops，32 skill + 7 workflow，半自动化架构）
- ✅ 契约文档体系打通（pm→design→solo→growth→pm 闭环 + solo→ops→pm 闭环）
- ✅ AC 编号体系跨框架对齐（AC-xxx / DAC-xxx）
- ✅ LOOP 引擎统一规范（state.yaml + 断点续传 + 超限保护）
- ✅ 基础层统一（AGENTS/SOUL/constitution/security/meta skill）
- ✅ 全局深度排查与修复（21 项问题全部解决，落地可用度 90+）

### 中期演进（v3.0，1-2 月）

- 📋 harness-data 建设（P1，数据管道框架）
- 📋 契约文档版本化（支持历史追溯，不破坏"只看最新"原则）
- 📋 跨框架循环类型映射说明（design 的 visual-design → solo 的 feature）

### 长期演进（v4.0，3-6 月，按需）

- 📋 编排层探索（多 Agent 自动调度，非当前目标）
- 📋 共享事实源探索（替代部分契约文档，减少信息损失）
- 📋 harness-qa / harness-security 建设（P2/P3，按需）

---

## 📚 文档导航

### 架构文档

- [ARCHITECTURE.md](./ARCHITECTURE.md) — 家族架构设计方案（v2.1，完整版）

### 各框架文档

| 框架 | 入口文档 |
|------|---------|
| harness-pm | [README.md](./harness-pm/README.md) / [AGENTS.md](./harness-pm/AGENTS.md) |
| harness-design | [README.md](./harness-design/README.md) / [AGENTS.md](./harness-design/AGENTS.md) |
| harness-solo | [README.md](./harness-solo/README.md) / [AGENTS.md](./harness-solo/AGENTS.md) |
| harness-growth | [README.md](./harness-growth/README.md) / [AGENTS.md](./harness-growth/AGENTS.md) |
| harness-ops | [README.md](./harness-ops/README.md) / [AGENTS.md](./harness-ops/AGENTS.md) |

### 各框架核心配置

| 框架 | SOUL.md | constitution.md | LOOP.md | INDEX.md |
|------|---------|-----------------|---------|----------|
| harness-pm | [链接](./harness-pm/SOUL.md) | [链接](./harness-pm/constitution.md) | [链接](./harness-pm/.harness/loops/LOOP.md) | [链接](./harness-pm/.harness/skills/INDEX.md) |
| harness-design | [链接](./harness-design/SOUL.md) | [链接](./harness-design/constitution.md) | [链接](./harness-design/.harness/loops/LOOP.md) | [链接](./harness-design/.harness/skills/INDEX.md) |
| harness-solo | [链接](./harness-solo/SOUL.md) | [链接](./harness-solo/constitution.md) | [链接](./harness-solo/.harness/loops/LOOP.md) | [链接](./harness-solo/.harness/skills/INDEX.md) |
| harness-growth | [链接](./harness-growth/SOUL.md) | [链接](./harness-growth/constitution.md) | [链接](./harness-growth/.harness/loops/LOOP.md) | [链接](./harness-growth/.harness/skills/INDEX.md) |
| harness-ops | [链接](./harness-ops/SOUL.md) | [链接](./harness-ops/constitution.md) | [链接](./harness-ops/.harness/loops/LOOP.md) | [链接](./harness-ops/.harness/skills/INDEX.md) |

---

## 🤝 贡献与许可

### 贡献方式

1. 选择一个框架深入理解（建议从 harness-solo 开始，最简单）
2. 阅读 [ARCHITECTURE.md](./ARCHITECTURE.md) 了解家族整体设计
3. 阅读对应框架的 AGENTS.md 和 SOUL.md 理解领域价值观
4. 按 SKILL.md.template 规范创建新 skill
5. 通过 LOOP 引擎验证 skill 可靠性

### 许可

MIT License — 见各框架根目录的 LICENSE 文件。

### 维护者

[@LuckyOneTwoThree](https://github.com/LuckyOneTwoThree)

---

<div align="center">

**harness-all** · 个人 AI 工作室 · 多 Agent 框架家族

**独立优先 · 契约协作 · 循环验证 · 安全红线**

v2.1 · 2026-06-22

</div>
