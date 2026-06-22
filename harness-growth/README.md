<div align="center">

# harness-growth

### 个人运营增长框架 · 让 Agent 按增长原则做运营

**只管"让产品被用起来"** · 内容生产 · SEO · 用户运营 · 增长实验

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#跨平台兼容)
[![Principles](https://img.shields.io/badge/principles-Growth%204-orange.svg)](#增长四原则详解)
[![Workflows](https://img.shields.io/badge/workflows-6%2F6-brightgreen.svg)](#工作流详解)
[![Skills](https://img.shields.io/badge/skills-40-brightgreen.svg)](#核心特性)

**[快速开始](#快速开始)** · **[目录结构](#目录结构)**

</div>

---

> 产品研究 / UI 设计 / 工程开发见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 这是什么

harness-growth 是一套**给 AI Agent 用的运营增长框架**。它不是代码库，而是一套规则 + 技能 + 工作流 + 状态管理机制，让 Agent 在帮你做增长时：

- **实验驱动**（Experiment-Driven）每个动作有假设有度量
- **内容优先**（Content-First）质量 > 数量，不做内容农场
- **长期主义**（Long-Term）SEO 不做黑帽，不刷量
- **数据闭环**（Data-Loop）每个实验有结论有行动

这四条是增长框架的核心约束，对应 harness-solo 的卡帕西四原则。

## 核心特性

### 增长四原则（已整合到 AGENTS.md + SOUL.md）

| 原则 | 含义 | 落地方式 |
|------|------|---------|
| Experiment-Driven | 增长是实验，不是拍脑袋 | PLAN 阶段必须写假设和度量 |
| Content-First | 内容质量 > 数量 | 内容生产 skill 检查质量门 |
| Long-Term | SEO 长期主义，不做黑帽 | security.md 禁止黑帽手段 |
| Data-Loop | 每个实验有结论有行动 | MEASURE 阶段必须写结论 |

### LOOP 循环引擎

```
PLAN → EXPERIMENT → MEASURE → 通过？DONE : 回到 EXPERIMENT/PLAN
```

- 每实验一个 `state.yaml`，支持断点续传
- 迭代上限保护：超 5 次请求人类介入
- 证据驱动：没有数据不声称完成

### 4 个元 Skill（已建设）

**元 skill**：session-start / session-end / skill-maintenance / memory-maintenance

### 领域 Skill（9 模块 36 个，✅ 全部已建设）

按 AARRR + 支撑层分类：

- **模块1 增长策略**（5 skill，✅）：nsm-definition / kpi-tree / aarr-diagnosis / growth-loop-design / four-fits-assessment
- **模块2 增长实验**（6 skill，✅）：hypothesis-generation / ice-scoring / experiment-design / sample-size-calc / experiment-analysis / experiment-conclusion
- **模块3 内容营销**（5 skill，✅）：content-ideation / content-creation / content-review / content-distribution / content-performance
- **模块4 SEO优化**（5 skill，✅）：keyword-research / serp-analysis / onpage-optimization / technical-seo-audit / ranking-tracking
- **模块5 用户运营**（5 skill，✅）：user-segmentation / onboarding-design / aha-moment-identification / retention-analysis / churn-rescue
- **模块6 获客投放**（3 skill，✅）：channel-assessment / landing-page-optimization / cac-analysis
- **模块7 变现**（3 skill，✅）：pricing-strategy / paywall-optimization / nrr-analysis
- **模块8 数据分析**（3 skill，✅）：funnel-analysis / cohort-analysis / metric-anomaly-detection
- **模块9 增长审查**（1 skill，✅）：growth-review

完整索引见 `.harness/skills/INDEX.md`。

### 工作流（6 个，✅ 全部已建设）

- **growth-experiment-workflow**（✅）：hypothesis-generation → ice-scoring → experiment-design → sample-size-calc → [执行] → experiment-analysis → experiment-conclusion
- **growth-review-workflow**（✅）：数据分析 → aarr-diagnosis → growth-review
- **content-marketing-workflow**（✅）：content-ideation → content-creation → content-review[质量门] → content-distribution → [发布] → content-performance
- **seo-optimization-workflow**（✅）：keyword-research → serp-analysis → onpage-optimization → technical-seo-audit[质量门] → [发布] → ranking-tracking
- **lifecycle-operations-workflow**（✅）：user-segmentation → onboarding-design → aha-moment-identification → retention-analysis[度量门] → churn-rescue
- **growth-strategy-workflow**（✅）：nsm-definition → kpi-tree → aarr-diagnosis → growth-loop-design → four-fits-assessment[质量门]

### 跨平台兼容

- **Agent 工具优先**：所有流程优先用 Read/Write/Edit/Glob/Grep 等工具
- **bash 可选兜底**：脚本有 bash 可用性检查，Windows 环境自动跳过
- **不依赖 PowerShell 专用语法**

### 安全红线

| 禁止 | 检查方式 |
|------|---------|
| 黑帽 SEO（关键词堆砌、隐藏文本、链接农场） | security.md + Agent 拒绝 |
| 刷量（点击、下载、评分、粉丝） | security.md + Agent 拒绝 |
| 泄露用户 PII | security.md + 数据脱敏 |
| 抓取竞品非公开数据 | security.md + Agent 拒绝 |

## 快速开始

### 1. 安装到你的项目

```bash
# 在你的项目根目录执行
bash install.sh
```

install.sh 会：
- 创建 `.harness/` 目录结构
- 从模板生成 `AGENTS.md` / `SOUL.md` / `constitution.md`
- 创建 `docs/` 目录（content/seo/experiment/operations/handoff）
- 初始化 `docs/operations/GROWTH_STRATEGY.md`

> Windows 用户：用 Git Bash 或 WSL 运行 install.sh。

### 2. 填写项目配置

编辑以下文件：
- `SOUL.md`：人格 + 增长偏好
- `constitution.md`：项目宪法（不可协商原则）
- `docs/operations/GROWTH_STRATEGY.md`：增长策略（目标、渠道、实验计划）

### 3. 开始增长工作

对 Agent 说：
- "我要做一篇关于 X 的内容" → 内容生产
- "优化这个页面的 SEO" → SEO 优化
- "设计一个 A/B 测试" → 增长实验
- "分析上周的留存数据" → 增长分析

Agent 会自动读取对应 skill，按流程推进。

## 目录结构

```
harness-growth/
├── AGENTS.md                          # 启动必读（唯一强制入口）
├── SOUL.md                            # Agent 人格 + 增长价值观
├── constitution.md                    # 项目宪法（不可协商原则）
├── install.sh                         # 冷启动安装脚本
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # 动态实验状态看板
│   ├── loops/
│   │   └── LOOP.md                    # 循环引擎定义
│   ├── memory/
│   │   ├── progress.md                # 会话进度日志
│   │   └── knowledge-base.md          # 跨会话知识库
│   ├── rules/
│   │   ├── security.md                # 安全红线
│   │   └── prompt-defense.md          # prompt 注入防护
│   ├── skills/
│   │   ├── INDEX.md                   # skill 索引（40 行内）
│   │   ├── meta/                      # 4 个元 skill
│   │   ├── strategy/                  # 增长策略 skill（5个）
│   │   ├── experiment/                # 增长实验 skill（6个）
│   │   ├── content/                   # 内容营销 skill（5个）
│   │   ├── seo/                       # SEO 优化 skill（5个）
│   │   ├── lifecycle/                 # 用户运营 skill（5个）
│   │   ├── acquisition/               # 获客投放 skill（3个）
│   │   ├── monetization/              # 变现 skill（3个）
│   │   ├── analytics/                 # 数据分析 skill（3个）
│   │   ├── review/                    # 增长审查 skill（1个）
│   │   └── workflows/                 # 工作流（6个）
│   └── templates/                     # 文档模板
└── docs/
    ├── content/                       # 内容资产
    ├── seo/                           # SEO 资产
    ├── experiment/                    # 实验记录
    ├── operations/                    # 运营文档（GROWTH_STRATEGY.md）
    └── handoff/                       # harness 家族交接文档
        ├── README.md
        └── handoff-template.md
```

## 文档体系

### 核心文件

| 文件 | 作用 | 谁写 |
|------|------|------|
| `AGENTS.md` | 启动入口，核心规则 + 增长四原则 | 框架提供，项目可定制 |
| `SOUL.md` | Agent 人格 + 增长偏好 | 用户填写 |
| `constitution.md` | 项目宪法（不可协商原则） | 用户填写 |
| `docs/operations/GROWTH_STRATEGY.md` | 增长策略（目标+渠道+实验计划） | 用户填写 |
| `.harness/FEATURES.md` | 动态实验状态看板 | session-end 批量同步 |

## LOOP 循环引擎

### state.yaml Schema

```yaml
# 必填
current_task: 001-blog-seo-experiment
iteration: 2
stage: experiment     # plan / experiment / measure / revise
status: running       # running / retrying / done / failed / needs-human / blocked
started_at: "2026-06-21T14:30:00"

# 可选（失败时）
last_error: "实验数据样本不足，无法得出显著结论"
last_error_at: "2026-06-21T14:45:00"

# 可选（子阶段）
substage: "ab-test"
```

### 断点续传

会话中断后，session-start 读取 `state.yaml`，恢复到中断点继续。

### 超限保护

| 循环类型 | 迭代上限 | 超限处理 |
|---------|:---:|---------|
| content | 3 | 请求人类介入 |
| seo | 5 | 请求人类介入 |
| experiment | 3 | 请求人类介入 |
| optimization | 3 | 请求人类介入 |
| monetization | 3 | 请求人类介入 |
| lifecycle | 5 | 请求人类介入 |
| 总循环 | 10 | 请求人类介入 |

## harness 家族

harness-growth 是 harness 家族的**运营增长**成员，专注让产品被用起来。其他成员通过文档交接协作：

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| harness-pm | 产品研究/市场/PRD | 消费 pm 产出，反馈增长数据 |
| harness-solo | 工程开发 | 产出 `solo-to-growth.md` → 本框架消费 |
| harness-design | UI/视觉设计（按需） | 产出设计稿 → 本框架参考 |
| **harness-growth（本框架）** | **运营增长** | 产出 `growth-to-pm.md` → 反馈给 pm |

## 增长四原则详解

### 1. Experiment-Driven（实验驱动）

**增长是实验，不是拍脑袋，每个动作有假设有度量。**

- 每个增长动作先写假设（"做 X 会让 Y 提升 Z%"）
- 每个实验定义度量指标（primary metric + guardrail metrics）
- 没有假设和度量的动作不做
- 实验失败也是结论，记录归档

### 2. Content-First（内容优先）

**内容质量 > 数量，不做内容农场。**

- 一篇高质量内容 > 十篇低质内容
- 不为 SEO 堆砌关键词、不生产同质化内容
- 内容必须对用户有价值，不是为算法写

### 3. Long-Term（长期主义）

**SEO 是长期投资，不做黑帽，不刷量。**

- 不做关键词堆砌、隐藏文本、链接农场
- 不刷点击、刷下载、刷评分
- 接受 SEO 见效慢（3-6 个月），做对的事

### 4. Data-Loop（数据闭环）

**每个实验有结论，每个结论有行动，形成闭环。**

- 实验结束必须写结论（有效/无效/不确定）
- 有效 → 放大；无效 → 停止；不确定 → 重新设计实验
- 闭环：假设 → 实验 → 度量 → 结论 → 行动 → 新假设

## 安全红线

完整安全规则见 [`.harness/rules/security.md`](.harness/rules/security.md)。

| 禁止 | 理由 |
|------|------|
| 黑帽 SEO | 搜索引擎惩罚风险，损害长期品牌 |
| 刷量（点击/下载/评分/粉丝） | 虚假数据污染决策，违反平台规则 |
| 泄露用户 PII | 隐私合规风险（GDPR/CCPA） |
| 抓取竞品非公开数据 | 法律风险，违反 ToS |
| 修改 `.git/hooks/` | 破坏 git 钩子完整性 |

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

**[⬆ 回到顶部](#harness-growth)**

</div>
