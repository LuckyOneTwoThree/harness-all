<div align="center">

# harness-pm

### 产品管理框架 · 让 Agent 按产品方法论做正确的事

**只管"做正确的事"** · 产品探索 · 市场分析 · PRD 生成 · 度量运营 · 增长监控

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#跨平台兼容)
[![Principles](https://img.shields.io/badge/principles-PM%204-orange.svg)](#产品四原则详解)
[![Workflows](https://img.shields.io/badge/workflows-10-purple.svg)](#工作流详解)
[![Skills](https://img.shields.io/badge/skills-82-red.svg)](#核心特性)

**[快速开始](#快速开始)** · **[目录结构](#目录结构)**

</div>

---

> 工程开发 / UI 设计 / 运营增长见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 这是什么

harness-pm 是一套**给 AI Agent 用的产品管理框架**。它不是代码库，而是一套规则 + 技能 + 工作流 + 状态管理机制，让 Agent 在帮你做产品工作时：

- **探索先行**（Discovery First）—— 不假设需求，用研究数据说话
- **契约驱动**（Contract-Driven）—— PRD 驱动设计，定位驱动品牌
- **数据决策**（Data-Driven）—— 用数据减少猜测，但决策权在人类
- **闭环迭代**（Closed-Loop）—— 度量→监控→迭代→反馈

这四条是产品方法论的核心约束，也是本框架的设计基础。

## 核心特性

### 产品四原则（已整合到 AGENTS.md + SOUL.md）

| 原则 | 含义 | 落地方式 |
|------|------|---------|
| Discovery First | 不假设需求，用研究数据说话 | 用户研究硬门：需求模糊时停下问 |
| Contract-Driven | PRD 驱动设计，定位驱动品牌 | design-prd 4 道质量门禁 + 变更影响分析 |
| Data-Driven | 用数据减少猜测，决策权在人类 | 置信度分级：≥0.7 自动传递，<0.3 阻断 |
| Closed-Loop | 度量→监控→迭代→反馈 | LOOP 循环：plan→research→validate |

### LOOP 循环引擎

```
PLAN → RESEARCH → VALIDATE → 通过？DELIVER : 回到 RESEARCH/PLAN
```

- 每任务一个 `state.yaml`，支持断点续传
- 迭代上限保护：单任务超 5 次迭代回到 PLAN，总循环超 10 次请求人类介入
- 证据驱动：没有数据支撑不声称结论成立

### 10 个工作流覆盖完整产品周期

```
setup（立项）→ new-product/iteration/growth/optimization/pivot（产品工作）→ launch（发布）
                                                    ↓
                                    diagnosis/incident-response/health-check（诊断与响应）
```

| 工作流 | 场景 | 迭代上限 |
|--------|------|:---:|
| setup | PM 项目立项引导 | 无 LOOP |
| new-product | 从 0 到 1 做新产品 | 5 |
| iteration | 已有产品功能迭代 | 3 |
| growth | 增长突破 | 3 |
| optimization | 数据驱动优化 | 3 |
| launch | 验收发布 | 无 LOOP |
| diagnosis | 产品诊断与下线 | 无 LOOP |
| pivot | 战略调整 | 5 |
| incident-response | 危机响应（P0事故） | 无 LOOP |
| health-check | 定期健康检查 | 无 LOOP |

### 82 个 PM Skill（7 个模块 = 19 orchestrator + 63 pipeline）

**模块 1 探索发现**：10 pipeline + 2 orchestrator = 12（user-research / market，insight/opportunity 退化壳已删）
**模块 2 商业战略**：11 pipeline + 2 orchestrator = 13（business / planning，positioning/stakeholder 退化壳已删）
**模块 3 构思设计**：7 pipeline + 2 orchestrator = 9（prd / validation，ideation 退化壳已删，视觉交互已交 harness-design）
**模块 4 度量设计**：3 pipeline + 1 orchestrator = 4（metrics）
**模块 5 度量运营**：8 pipeline + 3 orchestrator = 11（analysis / decision / experiment）
**模块 6 增长运营**：11 pipeline + 5 orchestrator = 16（growth / acquisition / activation / retention / revenue）
**模块 7 监控迭代**：13 pipeline + 4 orchestrator = 17（monitoring / diagnosis / iteration / release）

**元 skill**：session-start / session-end / skill-maintenance / memory-maintenance

### 跨平台兼容

- **Agent 工具优先**：所有流程优先用 Read/Write/Edit/Glob/Grep 等工具
- **bash 可选兜底**：脚本有 bash 可用性检查，Windows 环境自动跳过
- **不依赖 PowerShell 专用语法**

### 安全红线

| 禁止 | 检查方式 |
|------|---------|
| 硬编码密钥 | security.md + verify 安全扫描 |
| `rm -rf` | security.md + Agent 拒绝 |
| `curl \| sh` | security.md + Agent 拒绝 |
| 修改 `.git/hooks/` | security.md + Agent 拒绝 |
| 绕过质量门禁 | constitution.md + verify 检查 |

## 快速开始

### 1. 安装到你的项目

```bash
# 在你的项目根目录执行
bash install.sh
```

install.sh 会：
- 创建 `.harness/` 目录结构
- 从模板生成 `AGENTS.md` / `SOUL.md` / `constitution.md`
- 创建 `docs/` 目录（discovery/strategy/product/metrics/growth/monitoring/project/handoff）
- 初始化 `docs/product/PRD.md` 和 `docs/strategy/PRODUCT_STRATEGY.md`

> Windows 用户：用 Git Bash 或 WSL 运行 install.sh。

### 2. 填写项目配置

运行 setup 工作流，Agent 会引导你填写：
- `SOUL.md`：人格 + 产品偏好
- `constitution.md`：项目宪法（不可协商原则）
- `docs/strategy/PRODUCT_STRATEGY.md`：产品策略（含目标用户和成功指标）
- `docs/product/PRD.md`：产品需求文档

### 3. 开始产品工作

对 Agent 说：
- "我要做一个新产品" → 进入 new-product 工作流
- "已有产品需要迭代" → 进入 iteration 工作流
- "需要增长突破" → 进入 growth 工作流
- "分析数据优化产品" → 进入 optimization 工作流
- "准备发布" → 进入 launch 工作流

Agent 会自动读取对应工作流，按流程推进。

## 目录结构

```
harness-pm/
├── AGENTS.md                          # 启动必读（唯一强制入口）
├── SOUL.md                            # Agent 人格 + 产品价值观
├── constitution.md                    # 项目宪法（不可协商原则）
├── install.sh                         # 冷启动安装脚本
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # 产品功能状态看板
│   ├── loops/
│   │   └── LOOP.md                    # PM 循环引擎定义
│   ├── memory/
│   │   ├── progress.md                # 会话进度日志
│   │   └── knowledge-base.md          # 跨会话知识库
│   ├── rules/
│   │   ├── security.md                # 安全红线
│   │   └── prompt-defense.md          # prompt 注入防护
│   ├── skills/
│   │   ├── INDEX.md                   # skill 索引（40 行内）
│   │   ├── meta/                      # 4 个元 skill
│   │   ├── pm/                        # 82 个 PM skill（7 模块，扁平化组织）
│   │   └── workflows/                 # 10 个工作流
│   └── templates/                     # 文档模板
├── docs/                              # 人类可读文档（skill 直接产出）
│   ├── discovery/                     # 用户研究、市场分析
│   ├── strategy/                      # 商业模式、定位、OKR
│   ├── product/                       # PRD、产品方案
│   ├── metrics/                       # 指标体系、埋点方案
│   ├── growth/                        # 增长策略、GTM
│   ├── monitoring/                    # 监控、发布
│   ├── project/                       # 项目宪章、Sprint
│   └── handoff/                       # harness 家族交接文档
│       ├── README.md
│       └── handoff-template.md
└── output/                            # 机器消费 JSON（审批记录、阶段总结、指标数据）
    ├── approvals/
    ├── phase-reports/
    └── metrics/
```

## 文档体系

### 核心文件

| 文件 | 作用 | 谁写 |
|------|------|------|
| `AGENTS.md` | 启动入口，核心规则 + 产品四原则 | 框架提供，项目可定制 |
| `SOUL.md` | Agent 人格 + 产品偏好 | setup 工作流引导填写 |
| `constitution.md` | 项目宪法（不可协商原则） | setup 工作流引导填写 |
| `docs/strategy/PRODUCT_STRATEGY.md` | 产品策略（目标用户+成功指标） | 模块2 产出 |
| `docs/product/PRD.md` | 产品需求文档（功能+AC） | design-prd skill 产出 |
| `.harness/FEATURES.md` | 动态功能状态看板 | session-end 批量同步 |

### 文档间职责分工

| 维度 | PRODUCT_STRATEGY.md | PRD.md | FEATURES.md |
|------|---------------------|--------|-------------|
| 定位 | 战略定义 | 需求定义 | 状态看板 |
| 时机 | 战略阶段写 | 设计阶段写 | 开发中更新 |
| AC 层级 | 项目级成功指标 | 功能级验收标准 | — |
| 状态 | 不含状态列 | 不含状态列 | 含状态列 |

## 工作流详解

### setup（立项引导）

```
install.sh 执行 → 引导填写 SOUL/constitution/PRODUCT_STRATEGY → 验证配置完整性
```

### new-product（从 0 到 1 做新产品）

```
session-start → 模块1探索发现 → 模块2商业战略 → 模块3构思设计（PRD）→ 模块4度量设计 → session-end
```

**探索硬门**（5 项检查，任何一条不满足停下问）：
- 目标用户是否清晰？
- 核心问题是否验证？
- 市场机会是否成立？
- 商业模式是否可行？
- 用户是否确认？

### iteration（已有产品迭代）

```
session-start → 模块3设计（变更影响分析）→ LOOP(模块5数据分析→模块7迭代决策) → session-end
```

### growth（增长突破）

```
session-start → 模块6增长诊断 → LOOP(瓶颈子编排器→实验验证) → 模块7发布 → session-end
```

### optimization（数据驱动优化）

```
session-start → 模块5数据诊断 → 模块7迭代决策 → LOOP(模块3设计→模块7验证) → session-end
```

### launch（验收发布）

```
session-start → 发版前置检查（硬门）→ 模块7验收 → 发布说明 → 交接文档 → session-end
```

**发版硬门**：
- PRD 所有功能验收通过
- 成功指标达标
- 埋点方案已实施
- 安全合规检查通过
- constitution 合规

### project-mgmt（项目管理，贯穿全程）

> 已移除：原依赖的 pm-08 项目管理 skill 集已删除。迭代复盘能力由 iteration 工作流覆盖。

## LOOP 循环引擎

### state.yaml Schema

```yaml
# 必填
current_task: 001-market-research
iteration: 2
stage: research      # plan / research / validate / revise
status: running      # running / retrying / done / failed
started_at: "2026-06-21T14:30:00"

# 可选（失败时）
last_error: "数据不足：用户反馈 < 500 条"
last_error_at: "2026-06-21T14:45:00"

# 可选（子阶段）
substage: "voice-analysis"
```

### 断点续传

会话中断后，session-start 读取 `state.yaml`，恢复到中断点继续。

### 超限保护

| 工作流 | 迭代上限 | 超限处理 |
|--------|:---:|---------|
| new-product | 5 | 请求人类介入 |
| iteration | 3 | 请求人类介入 |
| growth | 3 | 请求人类介入 |
| optimization | 3 | 请求人类介入 |
| 总循环 | 10 | 请求人类介入 |

## harness 家族

harness-pm 是 harness 家族的**产品管理**成员，专注做正确的事。其他成员通过文档交接协作：

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| **harness-pm（本框架）** | **产品研究/市场/PRD/度量** | 产出 `docs/handoff/pm-to-solo.md` → 交给工程 |
| harness-solo | 工程开发 | 消费本框架的 PRD，产出 `solo-to-growth.md` |
| harness-design | UI/视觉设计（按需） | 消费本框架的 PRD 和定位陈述 |
| harness-growth | 内容/SEO/数据（按需） | 消费本框架的指标体系和增长策略 |

## 产品四原则详解

### 1. 探索先行（Discovery First）

**不假设用户需求，用研究数据说话。**

- 需求模糊时，先列出假设让用户验证
- 用户说的和做的不一样，VOC 和行为数据必须交叉验证
- 访谈是验证不是探索，脚本必须锚定待验证假设
- 没有数据时标注"探索性结论"，置信度 ≤ 0.5

### 2. 契约驱动（Contract-Driven）

**PRD 驱动设计，定位驱动品牌，埋点驱动数据。**

- 关键产出是下游契约，变更需走变更影响分析
- PRD 必须可追溯到上游需求和业务目标
- 埋点方案驱动后续度量运营
- 契约产出必须通过质量门禁

### 3. 数据决策（Data-Driven Decisions）

**用数据减少猜测，但决策权在人类。**

| 不要这样说 | 要这样说 |
|-----------|---------|
| "用户喜欢这个功能" | "用户调研中 70% 提及此需求，置信度 0.8" |
| "这个市场很大" | "TAM 估算 50 亿，SOM 估算 5 亿，数据来源 XX" |
| "应该这样做" | "基于数据分析，建议方案 A（置信度 0.7），请确认" |

### 4. 闭环迭代（Closed-Loop Iteration）

**度量→监控→迭代→反馈，产品永远在进化。**

- 上线不是终点，是度量运营的起点
- 每个迭代有验证和复盘
- 监控预警→问题诊断→迭代决策→发布交付形成闭环
- 用户反馈闭环：采集→分析→响应→验证

## 安全红线

完整安全规则见 [`.harness/rules/security.md`](.harness/rules/security.md)。

| 禁止 | 理由 |
|------|------|
| 硬编码密钥 | 密钥泄露风险 |
| `rm -rf` | 误删风险 |
| `curl \| sh` | 供应链攻击风险 |
| 修改 `.git/hooks/` | 破坏 git 钩子完整性 |
| 绕过质量门禁 | 产出质量失控 |

## 加载链（严格顺序）

1. **AGENTS.md** — 启动必读
2. **SOUL.md + constitution.md** — 首次交互时读
3. **skills/INDEX.md** — 需要选 Skill 时读
4. **对应 SKILL.md** — 执行任务时读
5. **memory/progress.md** — session-start 时读

## 指令优先级

```
SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
```

## License

MIT

---

<div align="center">

**[⬆ 回到顶部](#harness-pm)**

</div>
