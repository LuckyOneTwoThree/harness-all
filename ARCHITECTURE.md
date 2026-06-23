# harness-all 多 Agent 框架家族 · 架构设计方案

> 版本：v2.0 · 2026-06-22
> 定位：给 AI Agent 用的"个人 AI 工作室"框架家族，每个框架独立工作，通过契约文档协作

---

## 一、设计哲学

### 1.1 核心理念：独立优先，契约协作

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   独立工作 ──── 契约协作 ──── 多 Agent 编排                  │
│   (当前阶段)    (当前阶段)     (未来演进，非目标)            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

**为什么独立而非统一**：

| 维度 | 统一框架 | 独立框架（当前方案） |
|------|---------|-------------------|
| 上下文成本 | 单 Agent 加载所有 skill，上下文爆炸 | 每个 Agent 只加载本领域 skill |
| 记忆污染 | 产品/工程/设计/增长记忆混杂 | 各框架独立 memory，互不干扰 |
| 调试隔离 | 一个领域的 bug 影响全局 | 框架间完全隔离 |
| 工具适配 | 一套工具链适配所有场景 | 每个框架按需选工具（pm 不需要 Node，solo 需要） |
| 项目归属 | 一个项目一个 Agent | 不同框架可挂到不同项目/工作目录 |
| 协作成本 | 内部协作零成本 | 需要契约文档传递（可接受） |

**结论**：上下文爆炸和记忆污染是 AI Agent 协作的核心痛点，独立框架是当前最务实的选择。未来即使整合，也大概率是"编排层 + 独立框架"而非"大一统框架"。

### 1.2 三层架构

```
┌─────────────────────────────────────────────────────────────┐
│  编排层（未来，非当前目标）                                   │
│  - 多 Agent 调度 / 共享事实源 / 跨框架 LOOP                  │
└─────────────────────────────────────────────────────────────┘
                          ↕ 契约文档
┌─────────────────────────────────────────────────────────────┐
│  框架层（当前重点）                                           │
│  harness-pm / harness-design / harness-solo / harness-growth │
│  + 扩展框架（ops/data/qa/security，按需建设）                │
└─────────────────────────────────────────────────────────────┘
                          ↕ 加载链
┌─────────────────────────────────────────────────────────────┐
│  基础层（每个框架内部）                                       │
│  AGENTS.md / SOUL.md / constitution.md / LOOP.md / skills/  │
└─────────────────────────────────────────────────────────────┘
```

### 1.3 适用场景

- **个人 AI 工作室**：一个人 + 多个 AI Agent，每个 Agent 专精一个领域
- **小团队协作**：不同成员负责不同框架，通过契约文档对齐
- **多项目并行**：每个框架可挂到不同项目目录，互不干扰

---

## 二、框架家族总览

### 2.1 框架分类与状态

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

### 2.2 核心框架职责边界（不重叠原则）

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
```

**四条核心支撑链路**：

1. **pm → design**（`pm-to-design.md`）：PRD + Persona + AC-xxx + 风格关键词 + 技术栈
   - 消费方：harness-design 的 design-brief skill
   - 场景：需要 UI/视觉/交互设计时

2. **pm → solo**（`pm-to-solo.md`）：PRD + AC-xxx + **业务上下文摘要** + 埋点方案 + 关键决策
   - 消费方：harness-solo 的 brainstorming skill
   - 场景：纯工程项目（CLI/后端/API），或工程需求与设计并行启动时
   - **业务上下文摘要**：PM 从 user-research.md / market-analysis.md 提取工程相关约束（如数据规模、并发量、性能要求），避免 Solo 脱离业务场景做架构决策

3. **design → solo**（`design-to-solo.md` + `component-map.json` + `tokens.json` + `DESIGN.md`）：设计稿路径 + AC-xxx（设计视角）+ 组件映射 + 设计令牌 + 设计系统
   - 消费方：harness-solo 的 frontend-implementation / brainstorming / writing-plans / verify skill
   - 场景：**前端工程实现强依赖此契约**——component-map.json 是组件实现的单一事实源，tokens.json 是样式工程的令牌来源，AC-xxx（设计视角）是设计约束的可验证条件，进入工程后转为 DAC-xxx

**不强制串行**：pm → design → solo 不是唯一路径。纯工程项目可跳过 design 直接 pm → solo；前端项目则 design → solo 是硬依赖（无设计稿不实现前端）。

4. **solo → ops**（`solo-to-ops.md`）：镜像标签 + 环境变量清单 + 数据库迁移脚本
   - 消费方：harness-ops 的 deployment-pipeline / infrastructure-as-code
   - 场景：代码合并到主干后，需要发布上线

**职责边界铁律**：

| 领域 | 归属 | 禁止越界 |
|------|------|---------|
| 产品需求（PRD/AC/Persona） | harness-pm | design 不定义 PRD，solo 不修改 PRD |
| 视觉设计（配色/排版/组件） | harness-design | pm 不定义颜色，solo 不硬编码值 |
| 交互设计（状态机/动画/手势） | harness-design | pm 不定义动画参数，solo 按规格实现 |
| 工程实现（代码/测试/架构） | harness-solo | pm/design 不写代码 |
| 增长运营（内容/SEO/实验） | harness-growth | pm 提供指标，growth 执行实验 |
| 运维保障（发布/监控/容灾） | harness-ops | solo 不直接操作线上，需通过 ops 执行 IaC |

### 2.3 扩展框架建设优先级

| 优先级 | 框架 | 触发条件 | 理由 |
|--------|------|---------|------|
| P0 | harness-ops | 产品上线后 | 运维是上线的硬需求，监控/部署/容灾不可缺 |
| P1 | harness-data | 数据驱动决策时 | 当 pm/growth 需要复杂指标计算，ETL 管道必要 |
| P2 | harness-qa | 团队规模 > 3 人 | 小团队 solo 的 verify 够用，大团队需要独立 QA |
| P3 | harness-security | 合规要求出现 | 金融/医疗/ToB 场景必需，其他场景按需 |

---

## 三、独立工作模式

### 3.1 物理隔离

每个框架是**完全独立的目录**，可以：
- 挂到不同的项目目录（`project-A/` 用 pm，`project-B/` 用 solo）
- 由不同的 Agent 实例加载（Agent A 加载 pm，Agent B 加载 solo）
- 有独立的 `.harness/` 配置、memory、progress
- 有独立的 SOUL.md / constitution.md（人格和宪法可不同）

```
project-A/                    # 产品项目
├── .harness/                 # harness-pm 配置
│   ├── skills/               # 82 个 PM skill
│   ├── memory/               # PM 的记忆
│   └── ...
└── docs/                     # PM 产出

project-B/                    # 工程项目
├── .harness/                 # harness-solo 配置
│   ├── skills/               # 16 个工程 skill
│   ├── memory/               # solo 的记忆
│   └── ...
└── src/                      # 工程代码
```

### 3.2 加载链（每个框架独立遵循）

```
1. AGENTS.md          — 启动必读（唯一强制入口）
2. SOUL.md            — 人格 + 领域价值观
3. constitution.md    — 项目宪法（不可协商原则）
4. skills/INDEX.md    — skill 索引（80 行内）
5. 对应 SKILL.md      — 执行任务时按需加载
6. memory/progress.md — session-start 时读
```

**指令优先级**（所有框架统一）：

```
SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
```

### 3.3 单框架自洽

每个框架必须能**独立完成本领域工作**，不依赖其他框架：

| 框架 | 独立能力 | 不依赖 |
|------|---------|--------|
| harness-pm | 完成产品研究、PRD 生成、度量设计 | 不依赖 design 出图就能产出 PRD |
| harness-design | 完成视觉/交互设计、设计系统 | 不依赖 pm 的 PRD（可从用户对话获取需求） |
| harness-solo | 完成工程开发、测试、验证 | 不依赖 design 的设计稿（可从用户对话获取需求） |
| harness-growth | 完成内容生产、SEO、实验 | 不依赖 pm 的指标体系（可从用户对话获取目标） |

**自洽原则**：每个框架的 brainstorming/setup skill 必须支持"无交接文档"模式，从用户对话获取需求。

---

## 四、契约协作模式

### 4.1 契约文档体系

框架间通过 `docs/handoff/` 下的契约文档协作。每个文档有明确的**源框架**和**目标框架**。

```
docs/handoff/
├── README.md                    # 交接协议说明
├── handoff-template.md          # 通用模板（非契约文档）
├── pm-to-design-template.md     # PM → Design 专用模板（非契约文档）
├── pm-to-solo-template.md       # PM → Solo 专用模板（非契约文档）
├── pm-to-growth-template.md     # PM → Growth 专用模板（非契约文档）
├── design-to-solo-template.md   # Design → Solo 专用模板（非契约文档）
├── solo-to-growth-template.md   # Solo → Growth 专用模板（非契约文档）
├── solo-to-ops-template.md      # Solo → Ops 专用模板（非契约文档）
├── ops-to-pm-template.md        # Ops → PM 专用模板（非契约文档）
├── growth-to-pm-template.md     # Growth → PM 专用模板（非契约文档）
│
├── pm-to-design.md              # 契约：PM → Design（PRD + Persona + AC）
├── pm-to-solo.md                # 契约：PM → Solo（PRD + AC + 埋点）
├── pm-to-growth.md              # 契约：PM → Growth（指标 + 增长策略）
├── design-to-solo.md            # 契约：Design → Solo（设计稿 + AC + 组件映射）
├── design-to-pm.md              # 契约：Design → PM（设计反馈，按需）
├── solo-to-growth.md            # 契约：Solo → Growth（已实现功能 + 埋点）
├── solo-to-pm.md                # 契约：Solo → PM（工程反馈，按需）
├── solo-to-ops.md               # 契约：Solo → Ops（部署契约，环境变量与 DB 迁移）
├── ops-to-pm.md                 # 契约：Ops → PM（SLA 报告，故障复盘）
├── growth-to-pm.md              # 契约：Growth → PM（实验结果 + 数据反馈）
└── component-map.json           # 契约：Design → Solo（显式映射层，机器可读）
```

**说明**：模板文件（`*-template.md`）是产出契约文档的脚手架，本身不参与框架间流转；契约文档（`*-to-*.md` / `component-map.json`）是实际传递的协作媒介。

### 4.2 契约文档流转图

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

**流向说明**（箭头方向 = 文档流向）：

| 契约文档 | 源框架 | 目标框架 | 内容 |
|---------|--------|---------|------|
| pm-to-design.md | harness-pm | harness-design | PRD + Persona + AC-xxx |
| pm-to-solo.md | harness-pm | harness-solo | PRD + AC + 埋点 |
| pm-to-growth.md | harness-pm | harness-growth | 指标 + 增长策略 |
| design-to-solo.md | harness-design | harness-solo | 设计稿 + AC-xxx（设计视角）+ 组件映射 |
| design-to-pm.md | harness-design | harness-pm | 设计反馈（按需） |
| solo-to-growth.md | harness-solo | harness-growth | 已实现功能 + 埋点 |
| solo-to-pm.md | harness-solo | harness-pm | 工程反馈（按需） |
| solo-to-ops.md | harness-solo | harness-ops | 镜像标签 + 环境变量清单 + 数据库迁移脚本 |
| ops-to-pm.md | harness-ops | harness-pm | SLA 报告 + 故障复盘 (Post-mortem) |
| growth-to-pm.md | harness-growth | harness-pm | 实验结果 + 数据反馈 |
| component-map.json | harness-design | harness-solo | 显式映射层（机器可读） |

### 4.3 契约文档规范

#### 4.3.1 通用规范

- **文件名**：`<源框架>-to-<目标框架>.md`（固定，不按日期拆分）
- **追加模式**：已存在则追加本次交付内容，不覆盖历史
- **单一最新**：下游只看最新状态，不追溯历史版本
- **机器可读字段**：关键字段用结构化格式（表格/JSON），便于 Agent 解析

#### 4.3.2 AC 编号体系（跨框架对齐）

| AC 类型 | 前缀 | 来源 | 消费方 | 示例 |
|---------|------|------|--------|------|
| 工程 AC | `AC-xxx` | harness-pm 的 PRD | harness-solo 的 spec.md | `AC-001: 用户可登录` |
| 设计 AC（设计内部） | `AC-xxx`（沿用 PRD 编号） | harness-design 的 DESIGN_BRIEF.md | harness-design 的 LOOP | `AC-001: 对比度 ≥4.5:1`（对应 PRD 的 AC-001） |
| 设计 AC（流入工程） | `DAC-xxx` | harness-design 的 design-to-solo.md | harness-solo 的 spec.md | `DAC-001: 375px 无溢出` |

**AC 流转与防腐规则**：
- harness-pm 的 PRD 产出 `AC-xxx`（带 `ac_id` 字段），这是 AC 的唯一源头。在产出时受**UI指令越权门禁**拦截，严禁 PM 在此描述具体 UI 布局。
- harness-design 的 design-brief 沿用 PRD 的 `AC-xxx` 编号。在此阶段执行**审查与剥离机制（Push-back）**：若发现上游 AC 违规包含具体 UI，设计 Agent 将行使抗旨权，将其剥离并重写为纯粹的业务/UX 意图，记录入 `[AC 净化记录]`，并在设计域内补充视觉验收条件。
- harness-design 的 design-to-solo.md 携带净化后的设计 AC（仍为 `AC-xxx`，与 PRD 编号一致）。
- harness-solo 的 writing-plans 把设计 AC 转为 `DAC-xxx`（加 D 前缀区分来源，避免与工程 AC 混淆）。
- harness-solo 的 verify 同时检查 `AC-xxx`（纯工程）和 `DAC-xxx`（设计映射），确保设计约束在工程层不被遗漏。

**为什么需要 DAC-xxx**：同一个 spec.md 里可能同时有 `AC-001`（来自 PRD 的工程需求）和 `DAC-001`（来自 design-to-solo.md 的设计约束），加 D 前缀避免编号冲突，同时可追溯来源。

#### 4.3.3 专用模板与数据文件

**模板文件**（产出契约文档的脚手架）：

| 模板 | 用途 | 关键字段 |
|------|------|---------|
| `handoff-template.md` | 通用交接 | 阶段总结/产出物清单/AC/未决事项 |
| `pm-to-design-template.md` | PM → Design 专用 | 产品类型/目标受众/技术栈/Persona/PRD 路径/AC-xxx/风格关键词/不做清单 |
| `pm-to-solo-template.md` | PM → Solo 专用 | 产品类型/技术栈/PRD 路径/AC-xxx/功能优先级/埋点方案/业务上下文摘要 |
| `pm-to-growth-template.md` | PM → Growth 专用 | 产品类型/目标受众/北极星指标/OKR/Persona/增长假设 |
| `design-to-solo-template.md` | Design → Solo 专用 | 设计系统资产/页面清单/组件清单/AC-xxx+DAC-xxx/component-map.json |
| `solo-to-growth-template.md` | Solo → Growth 专用 | 已实现功能清单/AC-xxx/技术栈/性能指标/埋点事件清单 |
| `solo-to-ops-template.md` | Solo → Ops 专用 | 交付物版本/环境变量清单/数据库脚本/冒烟测试/回滚方案 |
| `ops-to-pm-template.md` | Ops → PM 专用 | SLA 摘要/事故通报/运维建议 |
| `growth-to-pm-template.md` | Growth → PM 专用 | 实验结果/用户反馈/增长建议/指标异动 |

**数据文件**（机器可读的契约载体，非模板）：

| 数据文件 | 用途 | 结构 |
|---------|------|------|
| `component-map.json` | Design → Solo 显式映射层 | `{ "<DesignComponentName>": { designToken, engineeringComponent, props, states, notes } }` |

### 契约文档写权限规则

交接文档实行**写权限单向物理隔离**：

| 文档 | 写入方 | 读取方 |
|------|--------|--------|
| pm-to-solo.md | harness-pm | harness-solo |
| pm-to-design.md | harness-pm | harness-design |
| pm-to-growth.md | harness-pm | harness-growth |
| design-to-solo.md | harness-design | harness-solo |
| solo-to-growth.md | harness-solo | harness-growth |
| solo-to-ops.md | harness-solo | harness-ops |
| growth-to-pm.md | harness-growth | harness-pm |
| ops-to-pm.md | harness-ops | harness-pm |

**规则**：
1. 产出方 session-end 写入出站交接文档（追加模式，不覆盖历史）
2. 消费方只能读取入站交接文档，**禁止修改**
3. 消费方如需向上游反馈，通过 `AskUserQuestion` 让用户转达，或写入自己的出站交接文档
4. 不允许双向读写同一个 Markdown 文档

### 4.4 多人协作场景

当多个 Agent（或多人 + Agent）协作时：

```
场景：Alice 负责 PM，Bob 负责 Design，Carol 负责 Solo

1. Alice 的 Agent 产出 pm-to-design.md，上传到共享存储
2. Bob 手动下载 pm-to-design.md，放到自己的 docs/handoff/
3. Bob 的 Agent 读取，产出设计稿 + design-to-solo.md
4. Carol 手动下载 design-to-solo.md + component-map.json
5. Carol 的 Agent 读取，实现代码
```

**关键约束**：
- 契约文档是**唯一协作媒介**，不依赖实时通信
- 上传/下载由人类手动完成（当前阶段）
- 未来可引入编排层自动流转（非当前目标）

---

## 五、核心框架详解

### 5.1 harness-pm（产品管理框架）

**定位**：做"对的事"——产品探索、市场分析、PRD 生成、度量运营

**四原则**：
1. Discovery First（探索先行）—— 不假设需求，用研究数据说话。通过 `exploration_mode` 机制实现可执行的探索控制（deep/standard/skip 三级模式，家族通用，详见 6.3 节 state.yaml Schema）
2. Contract-Driven（契约驱动）—— PRD 驱动设计，定位驱动品牌
3. Data-Driven（数据决策）—— 用数据减少猜测，决策权在人类
4. Closed-Loop（闭环迭代）—— 度量→监控→迭代→反馈

**LOOP 引擎**：
```
PLAN → RESEARCH → VALIDATE → 通过？DELIVER : 回到 RESEARCH/PLAN
```

**Skill 体系**（86 skill = 82 领域 + 4 meta）：
- 模块 1 探索发现（12）：user-research / market（insight / opportunity 退化壳已删）
- 模块 2 商业战略（13）：business / planning（positioning / stakeholder 退化壳已删）
- 模块 3 构思设计（9）：prd / validation（ideation 退化壳已删，视觉交互已交 harness-design）
- 模块 4 度量设计（4）：metrics
- 模块 5 度量运营（11）：analysis / decision / experiment
- 模块 6 增长运营（16）：growth / acquisition / activation / retention / revenue
- 模块 7 监控迭代（17）：monitoring / diagnosis / iteration / release

**核心产出**：
- `docs/product/PRD.md` — 产品需求文档（含 AC-xxx）
- `docs/strategy/PRODUCT_STRATEGY.md` — 产品策略
- `docs/metrics/tracking-plan.md` — 埋点方案
- `docs/handoff/pm-to-solo.md` — 交给工程
- `docs/handoff/pm-to-design.md` — 交给设计
- `docs/handoff/pm-to-growth.md` — 交给增长

**特色机制**：
- **UI 指令越权门禁**：在 PRD 产出门禁中，强制拦截 PM 夹带具体的视觉/交互形态（如“左侧边栏”、“红色按钮”），要求只能描述业务规则与状态流转，从源头确保不干涉下游设计空间。

**已知问题与优化方向**：
- ⚠️ 82 skill 数量仍偏多，模块 6 的 4 个子 orchestrator（acquisition/activation/retention/revenue）可合并为 growth 的子 phase
- ✅ 5 个越界 design skill 已删除 + design-orchestrator 拆分为 prd-orchestrator（视觉/交互移交 harness-design）
- ✅ 5 个退化壳 orchestrator 已删除（insight/positioning/ideation/opportunity/stakeholder）

### 5.2 harness-design（UI 设计框架）

**定位**：做"好看好用"——视觉设计、交互设计、原型产出、设计规范

**四原则**：
1. User-Centered（以用户为中心）—— Persona 驱动，不假设审美
2. System-First（系统优先）—— 先建设计系统再画页面
3. Accessible by Design（可访问性内建）—— WCAG 2.1 AA 是硬约束
4. Deliverable（可交付）—— 设计稿必须可被工程实现

**LOOP 引擎**（创新点：PLAN 内联 + LOOP 外门禁）：
```
PLAN（内联）→ LOOP(DESIGN → VERIFY → LINT) → LOOP 外门禁(DESIGN-REVIEW + ACCESSIBILITY-AUDIT)
```

**Skill 体系**（18 skill = 14 设计 + 4 meta）：
- 需求与推荐：design-brief / design-recommendation
- 设计系统：design-system / design-system-import / design-system-refactor
- 设计产出：visual-design / interaction-design / wireframe / component-design
- 审查与验证：verify / design-lint / design-review / accessibility-audit
- 交付：design-handoff-spec

**循环类型**（4 种）：
- `visual-design` — 视觉设计任务
- `interaction-design` — 交互设计任务
- `wireframe` — 线框图/低保真原型
- `component` — 组件设计

**核心产出**：
- `docs/visual/DESIGN_BRIEF.md` — 设计需求（含 AC-xxx）
- `docs/design-system/DESIGN.md` — 设计系统（10 段标准格式）
- `docs/design-system/tokens.json` / `tokens.css` — 设计令牌（W3C 格式）
- `docs/handoff/design-to-solo.md` — 交给工程
- `docs/handoff/component-map.json` — 显式映射层（Stitch 核心创新）

**特色机制**：
- **防越权抗旨剥离（Push-back Mechanism）**：设计 Agent 接收需求的第一站，强制审查上游 AC。若发现 PM 违规写死的 UI 布局指令，有权拒绝并重写（Reframe）为 UX 目标，同时公开展示净化记录，捍卫专业独立性。
- **数据驱动设计推荐**：8 个 CSV 文件（reasoning/products/styles/colors/typography/landing/ux-guidelines/vibes）
- **反 AI 同质化（Anti AI-Slop）**：禁用 Inter/紫渐变/统一圆角/Lorem ipsum，由 design-lint 用 Node.js 机械检查
- **Doubt-Driven 对抗式审查**：design-review 用 fresh-context 子 agent 做对抗式审查
- **框架无关约束**：component-map.json 的 props Type 与 TECH_STACK 匹配（React→ReactNode / Vue→VNode / Svelte→Snippet / 原生→HTMLElement）

### 5.3 harness-solo（工程开发框架）

**定位**：做"写好代码"——需求探索、TDD、调试、验证、代码审查

**卡帕西四原则**：
1. Think Before Coding（先思考后编码）—— 不代替用户做假设
2. Simplicity First（简单优先）—— 不做 speculative 抽象
3. Surgical Changes（手术刀式修改）—— 只改必须改的代码
4. Goal-Driven Execution（目标驱动执行）—— 循环验证直到达成

**LOOP 引擎**：
```
PLAN → ACT → VERIFY → 通过？DONE : 回到 PLAN/ACT
```

**Skill 体系**（20 skill = 16 工程 + 4 meta）：
- 需求与规划：brainstorming / writing-plans / executing-plans
- 测试与调试：test-driven-development / test-coverage / systematic-debugging
- 前端与性能：frontend-implementation / webapp-testing / performance-optimization
- 迁移与依赖：migration / dependency-management
- 验证与审查：verify / requesting-code-review / receiving-code-review
- 文档与技能：writing-documentation / writing-skills

**循环类型**（4 种）：
- `feature` — 新功能开发
- `bugfix` — Bug 修复
- `optimize` — 性能优化
- `refactor` — 重构

**核心产出**：
- `docs/product/PROJECT.md` — 产品需求（工程视角）
- `docs/engineering/TECH_STACK.md` — 技术栈
- `docs/handoff/solo-to-growth.md` — 交给增长
- `.harness/loops/specs/<feature>/spec.md` — 单功能规格（含 AC + DAC）

**特色机制**：
- **双源 AC 验证**：verify 同时检查工程 AC（AC-xxx）和设计 AC（DAC-xxx）
- **设计稿消费契约**：frontend-implementation 读取 component-map.json 作为组件实现单一事实源
- **熵检查**：verify 检查文件增长率/LOC 增长率/依赖膨胀/TODO 积压
- **git hooks**：pre-commit（secret/敏感文件/commit-msg 检查）+ pre-push

**已知问题与优化方向**：
- ⚠️ ARCHITECTURE.md 已删除（用户手动），后续按本方案重建

### 5.4 harness-growth（运营增长框架）

**定位**：做"被用起来"——内容生产、SEO、用户运营、增长实验

**四原则**：
1. Experiment-Driven（实验驱动）—— 每个动作有假设有度量
2. Content-First（内容优先）—— 质量 > 数量，不做内容农场
3. Long-Term（长期主义）—— SEO 不做黑帽，不刷量
4. Data-Loop（数据闭环）—— 每个实验有结论有行动

**LOOP 引擎**：
```
PLAN → EXPERIMENT → MEASURE → 通过？DONE : 回到 EXPERIMENT/PLAN
```

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

**循环类型**（4 种）：
- `content` — 内容生产
- `seo` — SEO 优化
- `experiment` — 增长实验
- `optimization` — 漏斗优化

**核心产出**：
- `docs/operations/GROWTH_STRATEGY.md` — 增长策略
- `docs/content/` — 内容资产
- `docs/seo/` — SEO 资产
- `docs/experiment/` — 实验记录
- `docs/handoff/growth-to-pm.md` — 反馈给 PM

**工作流**（6 个）：growth-experiment / growth-review / content-marketing / seo-optimization / lifecycle-operations / growth-strategy

### 5.5 harness-ops（运维与基础设施框架）

**定位**：做"护航与交付"——基础设施即代码、自动化部署、监控告警、容灾与应急响应

**SRE 四原则**：
1. Stability-First（稳定性第一）—— 不出故障是最高优指标
2. Infrastructure as Code（基建即代码）—— 环境可版本控制、可一键重建
3. Observability（无死角可观测）—— Logs / Metrics / Traces 缺一不可
4. Automation（无情自动化）—— 消除重复性劳作（Toil）

**LOOP 引擎**：
```
PLAN → PROVISION/DEPLOY → VERIFY → 通过？DONE : 失败则 ROLLBACK 并重试
```

**Skill 体系**（32 skill = 28 领域 + 4 meta）：
- 模块 1 部署交付（4）：deployment-pipeline / release-strategy / rollback / deployment-verify
- 模块 2 基础设施（4）：infrastructure-as-code / kubernetes-manifest / helm-management / gitops-sync
- 模块 3 监控可观测（4）：monitoring-setup / alerting-rules / log-analysis / dashboard-design
- 模块 4 故障响应（4）：incident-detection / root-cause-analysis / incident-mitigation / post-mortem
- 模块 5 安全合规（4）：secret-management / policy-as-code / security-scan / audit-review
- 模块 6 容量成本（3）：resource-right-sizing / cost-analysis / capacity-planning
- 模块 7 容灾备份（3）：backup-management / recovery-drill / disaster-recovery-plan
- 模块 8 运维审查（2）：ops-review / sla-report

**循环类型**（5 种）：
- `provision` — 基础设施部署（max 3）
- `incident` — 线上排障（max 5）
- `optimization` — 容量/成本优化（max 3）
- `recovery` — 容灾恢复（max 3）
- `audit` — 安全/合规审计（max 3）

**核心产出**：
- `docs/deployment/` — 部署记录
- `docs/monitoring/` — 监控大盘与告警规则
- `docs/infrastructure/` — 基础设施架构图与资产
- `docs/incident/` — 故障排查与工单记录
- `docs/handoff/ops-to-pm.md` — SLA 报告 + 故障复盘反馈给 PM

**工作流**（7 个）：deployment / incident-response / infrastructure-setup / monitoring-deployment / security-audit / disaster-recovery / ops-review

**特色机制**：
- **半自动化架构**：Agent 建议 + 人类审批 + GitOps 执行。完全自主运维 Agent 在 3-5 年内不可行，但半自动化框架可行且高价值
- **四类操作原语**（frontmatter `operation_tier` 字段）：
  - `inspect` —— 只读巡检，Agent 全自动
  - `propose` —— 生成 PR/提案，人类 review 后合并
  - `mutate-staging` —— Staging 直接执行白名单操作
  - `mutate-prod` —— 生产变更，**必须人类审批**
- **GitOps PR 间接执行**：Agent 永远不直接操作生产集群，通过开 PR + 人类 review + ArgoCD/Flux 同步（借鉴 HolmesGPT + ArgoCD 业界共识）
- **Secret 严格隔离**：Agent 只操作 Secret 的引用（路径/键名/CRD），永远不接触明文值（硬约束，不可协商）
- **7 层纵深防御**：Dry-run / Canary / Approval gate / Rate limit / Rollback / Audit / Blast radius
- **增强版 frontmatter**：在家族统一规范基础上增加 `operation_tier` 和 `requires_approval` 两个 ops 专属字段
- **7 张知识库表**：故障库 / 根因库 / 部署记录库 / 监控配置库 / IaC 资产库 / 运维模式沉淀 / 踩坑记录

---

## 六、统一基础层规范

### 6.1 每个框架必须有的基础文件

| 文件 | 作用 | 强制 |
|------|------|:---:|
| `AGENTS.md` | 启动必读，核心规则 + 领域原则 | ✅ |
| `SOUL.md` | Agent 人格 + 领域价值观 | ✅ |
| `constitution.md` | 项目宪法（不可协商原则） | ✅ |
| `install.sh` | 冷启动安装脚本 | ✅ |
| `README.md` | 框架说明 | ✅ |
| `.harness/loops/LOOP.md` | 循环引擎定义 | ✅ |
| `.harness/skills/INDEX.md` | skill 索引（80 行内） | ✅ |
| `.harness/skills/meta/` | 4 个元 skill | ✅ |
| `.harness/rules/security.md` | 安全红线 | ✅ |
| `.harness/rules/prompt-defense.md` | prompt 注入防护 | ✅ |
| `.harness/memory/progress.md` | 会话进度日志 | ✅ |
| `.harness/memory/knowledge-base.md` | 跨会话知识库 | ✅ |
| `.harness/FEATURES.md` | 动态任务状态看板 | ✅ |
| `.harness/VERSION` | 框架版本 | ✅ |
| `docs/handoff/README.md` | 交接协议说明 | ✅ |
| `docs/handoff/handoff-template.md` | 通用交接模板 | ✅ |

### 6.2 4 个元 skill（所有框架统一）

| 元 skill | 职责 | 触发时机 |
|----------|------|---------|
| session-start | 会话启动，恢复上下文 | 每次会话开始 |
| session-end | 会话收尾，归档 + 产出交接文档 | 任务完成/会话结束 |
| skill-maintenance | skill 增删改维护 | skill 变更时 |
| memory-maintenance | memory/knowledge-base 维护 | 定期/按需 |

### 6.3 LOOP 引擎统一规范

所有框架的 LOOP 必须支持：

- **state.yaml 断点续传**：会话中断后可恢复
- **迭代上限保护**：超限请求人类介入
- **证据驱动**：没有证据不声称完成
- **last_error 字段**：失败时记录错误，复用此字段不新增状态字段

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

# 可选（探索模式，家族通用）
exploration_mode: "<deep|standard|skip>"   # 默认 standard，控制 workflow 交互深度

# 可选（硬熔断标记）
hard_limit_reached: <bool>                 # true 时禁止继续循环，默认 false
```

> **exploration_mode 说明**（家族通用，各框架"探索"语义不同）：
> - `deep`：每个模块前暂停对话，禁用降级策略
> - `standard`：模块边界暂停，模块内自动执行
> - `skip`：不暂停探索对话，但人类决策点仍暂停
> - 来源优先级：用户显式切换 > workflow frontmatter `default_mode` > `standard`
>
> 各框架"探索"语义：
> | 框架 | 探索内容 |
> |------|---------|
> | pm | 用户需求和市场机会 |
> | design | 用户审美和设计需求 |
> | solo | 技术方案和需求边界 |
> | growth | 增长现状和实验上下文 |
> | ops | 基础设施现状和安全状态 |

### 6.4 安全红线统一规范

所有框架的 `security.md` 必须包含：

| 禁止 | 理由 |
|------|------|
| 硬编码密钥 | 密钥泄露风险 |
| `rm -rf` | 误删风险 |
| `curl \| sh` | 供应链攻击风险 |
| 修改 `.git/hooks/` | 破坏 git 钩子完整性 |
| 绕过质量门禁 | 产出质量失控 |

各框架可按领域扩展额外红线（如 growth 禁止黑帽 SEO，design 禁止泄露 PII）。

### 6.5 跨平台兼容规范

所有框架必须遵循：

- **Agent 工具优先**：所有流程优先用 Read/Write/Edit/Glob/Grep 等工具
- **bash 可选兜底**：脚本有 bash 可用性检查，Windows 环境自动跳过
- **不依赖 PowerShell 专用语法**
- **install.sh 检查**：git（BLOCK 级）+ Node.js（WARN 级，按需）

---

## 七、契约协议详解

### 7.1 PM → Design 契约

**文件**：`docs/handoff/pm-to-design.md`

**关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| 产品名称 | ✅ | |
| 产品类型 | ✅ | web app / mobile / desktop / landing page |
| 目标受众 | ✅ | 影响风格定位 |
| 技术栈 | ✅ | 决定 component-map.json 的 props Type 体系 |
| 定位陈述 | ✅ | 来自 positioning skill |
| Persona 路径 | ✅ | docs/research/persona-*.md |
| PRD 路径 | ✅ | docs/product/PRD.md |
| AC-xxx 清单 | ✅ | 严禁包含具体UI布局/颜色/排版指令，必须将视觉探索空间留给 harness-design |
| 风格关键词 | ○ | 3-5 个，来自 positioning 或用户要求 |
| 不做清单 | ✅ | 明确边界 |
| 已有设计系统资产 | ○ | 如为迭代项目，标注已有资产路径 |

**消费方**：harness-design 的 design-brief skill

### 7.2 PM → Solo 契约

**文件**：`docs/handoff/pm-to-solo.md`

**关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| 阶段总结 | ✅ | 本次交付了什么 |
| 产出物清单 | ✅ | PRD 路径、设计规范路径、埋点方案路径 |
| AC-xxx 清单 | ✅ | 工程 AC，供 spec.md 沿用 |
| 业务上下文摘要 | ✅ | PM 从 user-research.md / market-analysis.md 提取的工程相关约束（数据规模/并发量/性能要求等），避免 Solo 脱离业务做架构决策 |
| 关键决策 | ✅ | 决策 + 理由 + 影响范围 |
| 未决事项 | ✅ | 需工程确认的问题 |
| 建议下一步 | ✅ | 工程可做什么 |

**消费方**：harness-solo 的 brainstorming skill

### 7.3 PM → Growth 契约

**文件**：`docs/handoff/pm-to-growth.md`

**关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| 产品名称 | ✅ | |
| 产品类型 | ✅ | web app / mobile / desktop / landing page，决定增长渠道策略 |
| 目标受众 | ✅ | 影响获客策略 |
| 当前阶段 | ✅ | MVP / PMF / 规模化，决定增长重点 |
| 定位陈述 | ✅ | 来自 positioning skill |
| 北极星指标 | ✅ | 指标名称 + 当前值 + 目标值 |
| OKR | ✅ | 来自 planning-okr skill，含 Objective + Key Result + 周期 |
| Persona 路径 | ✅ | docs/discovery/user-research.md（用户画像章节） |
| 已有数据资产 | ○ | 指标定义/埋点方案/历史实验路径，全新项目填"无" |
| 增长假设 | ✅ | 待验证的假设列表（如"内容营销 CAC < 50 元"） |
| 关键决策 | ✅ | 决策 + 理由 + 影响范围 |
| 未决事项 | ✅ | 需 growth 确认的问题 |
| 建议下一步 | ✅ | growth 可做什么 |

**消费方**：harness-growth 的增长实验 / 增长分析 skill

### 7.4 Design → Solo 契约

**文件**：`docs/handoff/design-to-solo.md` + `docs/handoff/component-map.json`

**design-to-solo.md 关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| 设计稿路径 | ✅ | docs/visual/<page>.md / docs/interaction/<page>.md |
| 设计 AC 清单 | ✅ | AC-xxx（设计视角，如"对比度 ≥4.5:1"） |
| 组件映射路径 | ✅ | docs/handoff/component-map.json |
| 设计系统路径 | ✅ | docs/design-system/DESIGN.md + tokens.json |
| 未决事项 | ✅ | 需与工程确认的问题 |

**component-map.json 结构**：

```json
{
  "<DesignComponentName>": {
    "designToken": "<token-name>",
    "engineeringComponent": "<EngineeringComponentName>",
    "props": { "<key>": "<Type>" },
    "states": ["default", "hover", "..."],
    "notes": "<说明>"
  }
}
```

**框架无关约束**：props 的 Type 必须与 `docs/engineering/TECH_STACK.md` 的框架匹配：
- React → `ReactNode` / `JSX.Element`
- Vue → `VNode` / `Slot`
- Svelte → `Snippet` / `Component`
- 原生/Web Components → `HTMLElement` / `Slot`
- 未明确技术栈 → 用中性 `Slot` / `Component`，notes 标注"待工程确认"

**消费方**：harness-solo 的 brainstorming / frontend-implementation / writing-plans / verify skill

### 7.5 Solo → Growth 契约

**文件**：`docs/handoff/solo-to-growth.md`

**关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| 已实现功能清单 | ✅ | 功能 + 路径 + 状态 |
| 埋点清单 | ✅ | 已实施的埋点事件 |
| 性能指标 | ○ | LCP/FID/CLS 等基线数据 |
| 已知限制 | ✅ | 技术约束对增长的影响 |

**消费方**：harness-growth 的增长分析 skill

### 7.6 Growth → PM 契约

**文件**：`docs/handoff/growth-to-pm.md`

**关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| 实验结果 | ✅ | 实验 + 结论（有效/无效/不确定）+ 数据 |
| 用户反馈 | ✅ | 采集 + 分析 + 优先级 |
| 增长建议 | ✅ | 基于数据的下一步建议 |
| 指标异动 | ○ | 异常波动 + 原因分析 |

**消费方**：harness-pm 的 insight / iteration skill

### 7.7 Solo → Ops 契约

**文件**：`docs/handoff/solo-to-ops.md`

**关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| 交付物版本 | ✅ | 镜像 Tag 或代码 Commit Hash |
| 环境变量 | ✅ | 本次部署需增删改的配置项 |
| 数据库脚本 | ✅ | 是否包含 Migration 及其执行顺序 |
| 冒烟测试 | ✅ | 验证部署成功的检查点 |
| 回滚方案 | ✅ | 出错时的降级或代码回滚措施 |

**消费方**：harness-ops 的 deployment-pipeline / infrastructure-as-code skill

### 7.8 Ops → PM 契约

**文件**：`docs/handoff/ops-to-pm.md`

**关键字段**：

| 字段 | 必填 | 说明 |
|------|:---:|------|
| SLA 可用性 | ✅ | 本周期内的大盘可用性指标 (如 99.99%) |
| 事故通报 | ○ | 发生的 P0/P1 故障及复盘 (Post-mortem) |
| 成本优化 | ○ | 云账单趋势与资源清理报告 |
| 业务建议 | ✅ | 比如某接口极慢，建议下个版本重构 |

**消费方**：harness-pm 的 iteration / release skill

---

## 八、协作工作流示例

### 8.1 从 0 到 1 做新产品（四框架协作）

```
阶段 1：产品定义（harness-pm）
├── new-product workflow
├── 产出：PRD.md（含 AC-xxx）/ PRODUCT_STRATEGY.md / Persona
└── 产出：pm-to-design.md + pm-to-solo.md + pm-to-growth.md

阶段 2：设计（harness-design）
├── new-design workflow
├── 消费：pm-to-design.md
├── 产出：DESIGN_BRIEF.md / DESIGN.md / tokens.json / visual/ / interaction/
└── 产出：design-to-solo.md + component-map.json

阶段 3：工程（harness-solo）
├── new-feature workflow
├── 消费：pm-to-solo.md + design-to-solo.md + component-map.json
├── 产出：代码 + 测试 + spec.md（含 AC + DAC）
└── 产出：solo-to-growth.md

阶段 4：增长（harness-growth）
├── 增长实验 workflow
├── 消费：solo-to-growth.md + pm-to-growth.md
├── 产出：内容资产 / SEO 资产 / 实验记录
└── 产出：growth-to-pm.md（反馈闭环）
```

### 8.2 已有产品迭代（PM + Solo 协作）

```
阶段 1：迭代需求（harness-pm）
├── iteration workflow
├── 产出：PRD 更新（新增/修改 AC-xxx）
└── 产出：pm-to-solo.md（追加迭代需求）

阶段 2：工程实现（harness-solo）
├── new-feature / bugfix workflow
├── 消费：pm-to-solo.md（更新版）
└── 产出：代码更新 + solo-to-pm.md（工程反馈）
```

### 8.3 设计重做（PM + Design + Solo 协作）

```
阶段 1：重设计需求（harness-pm）
├── 产出：PRD 更新 + pm-to-design.md（重设计需求）

阶段 2：重设计（harness-design）
├── redesign workflow
├── 消费：pm-to-design.md + design-system-import（现有资产）
├── 产出：更新 visual/ / interaction/ / DESIGN.md / tokens.json
└── 产出：design-to-solo.md（更新版）+ component-map.json（更新版）

阶段 3：工程适配（harness-solo）
├── refactor / migration workflow
├── 消费：design-to-solo.md（更新版）
└── 产出：代码重构 + 测试更新
```

---

## 九、与单框架的关系

### 9.1 单框架用户视角

如果用户只用一个框架（如只用 harness-solo 做工程）：

- **完全自洽**：brainstorming 从用户对话获取需求，不依赖 pm-to-solo.md
- **无契约文档**：docs/handoff/ 目录为空或只有 README
- **独立工作**：所有流程在框架内闭环

### 9.2 多框架用户视角

如果用户用多个框架（如 pm + solo）：

- **契约协作**：通过 docs/handoff/ 下的文档传递需求
- **手动流转**：用户手动复制契约文档到目标框架的 docs/handoff/
- **独立 memory**：每个框架有自己的 memory，互不干扰

### 9.3 多人协作视角

如果多人 + 多 Agent 协作：

- **每人一个框架**：Alice 用 pm，Bob 用 design，Carol 用 solo
- **契约文档共享**：通过 Git 仓库/云盘/邮件等手动共享
- **版本对齐**：契约文档不按日期拆分，下游只看最新状态

---

## 十、演进路线

### 10.1 当前阶段（v2.0，已完成）

- ✅ 4 个核心框架独立建设（pm/design/solo/growth 全部完成）
- ✅ 契约文档体系打通（pm→design→solo→growth→pm 闭环）
- ✅ AC 编号体系跨框架对齐（AC-xxx / DAC-xxx）
- ✅ LOOP 引擎统一规范（state.yaml + 断点续传 + 超限保护）
- ✅ 基础层统一（AGENTS/SOUL/constitution/security/meta skill）

### 10.2 短期优化（v2.1，1-2 周内）

- ✅ harness-pm 的 5 个越界 design skill 删除 + design-orchestrator 拆分为 prd-orchestrator（保留 PRD + 变更影响分析，视觉/交互移交 harness-design）
- ✅ harness-pm 的 5 个退化壳 orchestrator 删除（insight/positioning/ideation/opportunity/stakeholder）
- ✅ harness-pm 的 PRD 增加 ac_id 字段，与 design-brief AC-xxx 对齐
- ✅ harness-solo 的 README skill 数量修正（工程 skill 误标 17，实际 16，总计 20）
- ✅ harness-solo 的 install.sh 增加 Node.js 检查
- ✅ harness-pm 的核心交接模板补齐（pm-to-solo-template / pm-to-growth-template）
- ✅ harness-solo 的核心交接模板补齐（solo-to-growth-template / solo-to-ops-template）
- ✅ harness-pm 的 AGENTS.md docs/design/ 归属越界修正（删除 5 个越界条目，补充职责边界说明）
- ✅ 跨框架契约防越权护栏部署（PM 侧增加 UI 门禁拦截 + Design 侧赋予 Push-back 净化重写权）
- ✅ harness-design 的 skill 数量修正（设计 skill 误标 13，实际 14，总计 18）
- ✅ harness-growth 的增长 skill 和 workflow 建设（40 skill + 6 workflow）

### 10.3 中期演进（v3.0，1-2 月）

- ✅ harness-ops 建设（P0，运维框架，32 skill + 7 workflow，半自动化架构）
- 📋 harness-data 建设（P1，数据管道框架）
- 📋 契约文档版本化（支持历史追溯，不破坏"只看最新"原则）
- 📋 跨框架循环类型映射说明（design 的 visual-design → solo 的 feature）

### 10.4 长期演进（v4.0，3-6 月，按需）

- 📋 编排层探索（多 Agent 自动调度，非当前目标）
- 📋 共享事实源探索（替代部分契约文档，减少信息损失）
- 📋 harness-qa / harness-security 建设（P2/P3，按需）

---

## 十一、关键设计决策记录

### 决策 1：独立框架 vs 统一框架

**选择**：独立框架
**理由**：
- 上下文爆炸是 AI Agent 协作的核心痛点
- 记忆污染会降低 Agent 质量
- 独立框架可挂到不同项目，灵活性强
- 契约文档的协作成本可接受

**代价**：
- 契约文档有信息损失（但可通过结构化字段缓解）
- 手动流转有摩擦（但当前阶段可接受）

### 决策 2：契约文档 vs 共享事实源

**选择**：契约文档（当前阶段）
**理由**：
- 共享事实源需要编排层支持，当前无编排层
- 契约文档是最低耦合的协作方式
- 多人协作时手动上传/下载契约文档即可

**代价**：
- 序列化开销（Agent 产出 → 文档 → Agent 解析）
- 信息损失（结构化字段可缓解）

**未来演进**：当编排层就绪后，可逐步用共享事实源替代部分契约文档。

### 决策 3：PLAN 内联 vs 独立 skill

**选择**：PLAN 内联到 LOOP.md（harness-design 方案）
**理由**：
- PLAN 是每个 LOOP 的必经步骤，不需要独立 skill
- 内联减少 skill 数量，降低 INDEX.md 负担
- 内联让 LOOP.md 自洽，不依赖外部 skill

**适用范围**：
- harness-design：PLAN 内联 ✅
- harness-solo：保留 writing-plans skill（工程 PLAN 更复杂，需要独立 skill）
- harness-pm：保留 writing-plans 思路（PM 的 PLAN 涉及多模块编排）

### 决策 4：LOOP 外门禁

**选择**：harness-design 引入 LOOP 外门禁（design-review + accessibility-audit）
**理由**：
- LOOP 内的 verify + lint 是快速检查（机械规则）
- LOOP 外的 design-review + accessibility-audit 是深度审查（对抗式 + 语义级）
- 拆分避免 LOOP 内过重，同时保证质量

**适用范围**：
- harness-design：LOOP 外门禁 ✅
- harness-solo：暂不引入（verify 已足够，工程 lint 集成在构建命令）
- harness-pm：暂不引入（PM 无机械 lint 需求）

### 决策 5：AC 编号跨框架对齐

**选择**：AC-xxx（工程）+ DAC-xxx（设计流入工程）
**理由**：
- PRD 的 AC-xxx 是源头，design-brief 沿用不重新编号
- design 的 AC 流入工程时加 D 前缀，区分来源
- verify 同时检查两源，确保设计约束在工程层不被遗漏

**代价**：
- spec.md 有两套 AC，略复杂
- 但收益（设计约束可验证）远大于成本

### 决策 6：component-map.json 框架无关

**选择**：props Type 与 TECH_STACK 匹配，不绑定任何框架
**理由**：
- harness-design 不应预判下游工程用 React/Vue/Svelte
- 强绑 React 会导致 Vue 项目无法消费
- 中性抽象（Slot/Component）+ Tech Stack 约束是根本解

**代价**：
- 需要在 design-handoff-spec 和 frontend-implementation 两端都维护映射规则
- 但收益（跨框架兼容）远大于成本

---

## 十二、风险评估与缓解

### 12.1 上下文爆炸风险

**风险**：单框架 skill 过多（如 harness-pm 82 skill），INDEX.md 可能塞不下
**缓解**：
- INDEX.md 按 7 个模块分组，每组列出 skill 名
- orchestrator 负责编排，Agent 只在需要时加载具体 pipeline skill
- 长期考虑合并冗余 orchestrator（如 growth 的 4 个子 orchestrator）

### 12.2 契约文档信息损失

**风险**：PM 产出 PRD → 交接文档解析 → 可能有信息丢失；特别是 PM → Solo 链路，纯 AC 清单无法传递业务场景，导致工程架构决策脱离实际（如"支持导出"不知数据量级，选错同步/异步方案）
**缓解**：
- 契约文档用结构化字段（表格/JSON），减少自然语言歧义
- AC-xxx 编号跨框架对齐，可追溯
- design-brief 的 Reframe 步骤显式列出"从 PRD 提取了什么"，便于核对
- **pm-to-solo.md 增加业务上下文摘要**（Business Context Digest）：PM 从 user-research.md / market-analysis.md 提取工程相关约束（数据规模/并发量/性能要求），Solo 在 brainstorming 的技术可行性评估时必须参考，发现 AC 与业务约束矛盾时主动提出

### 12.3 多人协作版本冲突

**风险**：多人同时修改契约文档，版本不一致
**缓解**：
- 契约文档不按日期拆分，下游只看最新状态（强制单最新版本）
- 多人协作时通过 Git 分支管理（PR 合并前不覆盖主线）
- 当前阶段手动流转，未来编排层可自动处理

### 12.4 框架间理念不一致

**风险**：4 个框架的 LOOP 设计不同（pm 是数据驱动，design 是质量驱动，solo 是目标驱动），可能混淆
**缓解**：
- 各框架 LOOP 独立设计，按领域特点优化（不强求统一）
- 在本架构文档中明确说明各框架 LOOP 的差异和理由
- 循环类型命名按领域语义（pm 用 research/prd/iteration，design 用 visual/interaction/wireframe）

### 12.5 扩展框架建设滞后

**风险**：harness-data 建设滞后，影响全链路
**缓解**：
- 扩展框架按需建设（P0/P1/P2/P3 优先级）
- 核心框架（pm/design/solo/growth/ops）已覆盖主要场景
- data 未建设前，相关能力由 harness-solo 的 verify/webapp-testing + harness-ops 的 monitoring 兜底

---

## 十三、总结

harness-all 是一套**独立优先、契约协作**的多 Agent 框架家族。当前阶段聚焦 4 个核心框架 + 1 个 P0 扩展框架的独立建设，通过契约文档实现跨框架协作。

**核心价值**：
- 每个 Agent 专精一个领域，避免上下文爆炸和记忆污染
- 契约文档是唯一协作媒介，支持多人 + 多 Agent 协作
- 跨平台兼容，Agent 工具优先，bash 可选兜底
- 框架间完全独立，可挂到不同项目/工作目录

**当前状态**：
- 4 个核心框架已全部建设完成（pm/design/solo/growth）
- 1 个 P0 扩展框架已建设完成（ops，32 skill + 7 workflow，半自动化架构）
- 契约文档体系已打通（pm→design→solo→growth→pm 闭环 + solo→ops→pm 闭环）
- AC 编号体系跨框架对齐
- LOOP 引擎统一规范

**下一步重点**：
- 短期：harness-pm design skill 瘦身（✅ 已完成）+ harness-growth skill 建设（✅ 已完成）+ harness-ops 建设（✅ 已完成）
- 中期：harness-data 建设（P1）
- 长期：编排层探索（按需）

---

## 附录 A：框架文件结构对照表

| 文件/目录 | harness-pm | harness-design | harness-solo | harness-growth | harness-ops |
|-----------|:---:|:---:|:---:|:---:|:---:|
| AGENTS.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| SOUL.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| constitution.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| README.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| install.sh | ✅ | ✅ | ✅ | ✅ | ✅ |
| ARCHITECTURE.md | ❌（已删） | ❌ | ❌（已删） | ❌ | ❌ |
| .harness/loops/LOOP.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/skills/INDEX.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/skills/meta/ | ✅（4 skill） | ✅（4 skill） | ✅（4 skill） | ✅（4 skill） | ✅（4 skill） |
| .harness/skills/<domain>/ | ✅（82 领域 skill） | ✅（14 领域 skill） | ✅（16 领域 skill） | ✅（36 领域 skill） | ✅（28 领域 skill） |
| .harness/skills/workflows/ | ✅（10 workflow） | ✅（6 workflow） | ✅（7 workflow） | ✅（6 workflow） | ✅（7 workflow） |
| .harness/rules/security.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/rules/prompt-defense.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/memory/ | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/FEATURES.md | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/VERSION | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/templates/ | ✅ | ✅ | ✅ | ✅ | ✅ |
| .harness/data/ | ❌ | ✅（8 CSV） | ❌ | ❌ | ❌ |
| .harness/craft/ | ❌ | ✅（4 文件） | ❌ | ❌ | ❌ |
| .harness/hooks/ | ❌ | ❌ | ✅ | ❌ | ❌ |
| .harness/scripts/ | ❌ | ❌ | ✅ | ❌ | ❌ |
| docs/handoff/ | ✅ | ✅ | ✅ | ✅ | ✅ |

**Skill 数量说明**：各框架的 skill 总数 = 领域 skill + 4 meta skill。例如 harness-design 总计 18 skill（14 领域 + 4 meta），harness-solo 总计 20 skill（16 领域 + 4 meta），harness-pm 总计 86 skill（82 领域 + 4 meta），harness-growth 总计 40 skill（36 领域 + 4 meta），harness-ops 总计 32 skill（28 领域 + 4 meta）。

## 附录 B：契约文档矩阵

| 源 \ 目标 | harness-pm | harness-design | harness-solo | harness-growth | harness-ops |
|-----------|:---:|:---:|:---:|:---:|:---:|
| harness-pm | - | pm-to-design.md | pm-to-solo.md | pm-to-growth.md | - |
| harness-design | design-to-pm.md（按需） | - | design-to-solo.md + component-map.json | - | - |
| harness-solo | solo-to-pm.md（按需） | - | - | solo-to-growth.md | solo-to-ops.md |
| harness-growth | growth-to-pm.md | - | - | - | - |
| harness-ops | ops-to-pm.md | - | - | - | - |

## 附录 C：LOOP 循环类型对照

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

**单 LOOP 硬熔断**：所有框架统一为 10 次迭代，超限停止并请求人类介入。

**命名规范**：循环类型按领域语义命名，避免跨框架混淆（如 harness-pm 用 `prd` 而非 `design`，避免与 harness-design 的 `visual-design` / `interaction-design` 混淆）。

---

**文档版本**：v2.1 · 2026-06-22（同步 harness-growth + harness-ops 建设完成）
**维护者**：harness-all 架构师
**下次评审**：v3.0 发布时（harness-data 建设启动）
