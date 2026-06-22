<div align="center">

# harness-solo

### 个人工程开发框架 · 让 Agent 按工程原则写代码

**只管"写代码"这件事** · 需求探索 · TDD · 调试 · 验证 · 代码审查

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#跨平台兼容)
[![Principles](https://img.shields.io/badge/principles-Karpathy%204-orange.svg)](#卡帕西原则详解)
[![Workflows](https://img.shields.io/badge/workflows-7-purple.svg)](#工作流详解)
[![Skills](https://img.shields.io/badge/skills-20-red.svg)](#核心特性)

**[English](README.en.md)** · **[快速开始](#快速开始)** · **[目录结构](#目录结构)**

</div>

---

> 产品研究 / UI 设计 / 运营增长见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 这是什么

harness-solo 是一套**给 AI Agent 用的工程开发框架**。它不是代码库，而是一套规则 + 技能 + 工作流 + 状态管理机制，让 Agent 在帮你写代码时：

- **先思考再动手**（Think Before Coding）
- **用最小代码解决问题**（Simplicity First）
- **只碰必须碰的代码**（Surgical Changes）
- **循环验证直到达成**（Goal-Driven Execution）

这四条是 [Andrej Karpathy](https://github.com/multica-ai/andrej-karpathy-skills) 观察提炼的工程原则，也是本框架的核心约束。

## 核心特性

### 卡帕西四原则（已整合到 AGENTS.md + SOUL.md）

| 原则 | 含义 | 落地方式 |
|------|------|---------|
| Think Before Coding | 不代替用户做假设，不隐藏困惑 | brainstorming 硬门：需求模糊时停下问 |
| Simplicity First | 不做 speculative 抽象 | verify 熵检查 + dependency-management 审批门 |
| Surgical Changes | 只改必须改的代码 | refactor 工作流强调"不加功能" |
| Goal-Driven Execution | 把指令转成可验证目标 | LOOP 循环：plan→act→verify，失败不继续 |

### LOOP 循环引擎

```
PLAN → ACT → VERIFY → 通过？DONE : 回到 PLAN/ACT
```

- 每功能一个 `state.yaml`，支持断点续传
- 迭代上限保护：超 5 次请求人类介入
- 证据驱动：没有测试输出不声称完成

### 7 个工作流覆盖完整开发周期

```
setup（立项）→ new-feature/bugfix/refactor/optimize/migration（开发）→ release（发版）
```

| 工作流 | 场景 | 迭代上限 |
|--------|------|:---:|
| setup | 新项目立项引导 | 无 LOOP |
| new-feature | 新功能开发 | 5 |
| bugfix | Bug 修复 | 3 |
| refactor | 重构（不改行为） | 3 |
| optimize | 性能优化 | 3 |
| migration | 框架升级/API 迁移 | 3 |
| release | 版本发布 | 无 LOOP |

### 20 个 Skill（16 工程 + 4 元）

**工程 skill**：brainstorming / writing-plans / executing-plans / test-driven-development / test-coverage / systematic-debugging / performance-optimization / migration / dependency-management / frontend-implementation / verify / webapp-testing / requesting-code-review / receiving-code-review / writing-skills / writing-documentation

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

## 快速开始

### 1. 安装到你的项目

```bash
# 在你的项目根目录执行
bash install.sh
```

install.sh 会：
- 创建 `.harness/` 目录结构
- 从模板生成 `AGENTS.md` / `SOUL.md` / `constitution.md`
- 创建 `docs/` 目录（product/engineering/acceptance/decisions/handoff）
- 初始化 `docs/product/PROJECT.md` 和 `docs/engineering/TECH_STACK.md`

> Windows 用户：用 Git Bash 或 WSL 运行 install.sh。

### 2. 填写项目配置

运行 setup 工作流，Agent 会引导你填写：
- `SOUL.md`：人格 + 技术偏好
- `constitution.md`：项目宪法（不可协商原则）
- `docs/product/PROJECT.md`：产品需求（含验收标准）
- `docs/engineering/TECH_STACK.md`：技术栈（测试/构建/lint 命令）

### 3. 开始开发

对 Agent 说：
- "我要做一个 Todo CLI" → 进入 new-feature 工作流
- "这个 Bug 是..." → 进入 bugfix 工作流
- "这段代码太慢" → 进入 optimize 工作流
- "发版" → 进入 release 工作流

Agent 会自动读取对应工作流，按流程推进。

## 目录结构

```
harness-solo/
├── AGENTS.md                          # 启动必读（唯一强制入口）
├── SOUL.md                            # Agent 人格 + 工程价值观
├── constitution.md                    # 项目宪法（不可协商原则）
├── install.sh                         # 冷启动安装脚本
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # 动态功能状态看板
│   ├── gates/                         # 外部检查门（预留）
│   ├── hooks/                         # git hooks（pre-commit/pre-push）
│   ├── loops/
│   │   └── LOOP.md                    # 循环引擎定义
│   ├── memory/
│   │   ├── progress.md                # 会话进度日志
│   │   └── knowledge-base.md          # 跨会话知识库
│   ├── rules/
│   │   ├── security.md                # 安全红线
│   │   └── prompt-defense.md          # prompt 注入防护
│   ├── scripts/
│   │   ├── verify-harness.sh          # 框架健康检查
│   │   ├── security-check.sh          # 安全扫描（可选）
│   │   ├── entropy-check.sh           # 熵检查（可选）
│   │   └── archive-progress.sh        # 进度归档（可选）
│   ├── skills/
│   │   ├── INDEX.md                   # skill 索引（40 行内）
│   │   ├── engineering/               # 16 个工程 skill
│   │   ├── meta/                      # 4 个元 skill
│   │   └── workflows/                 # 7 个工作流
│   └── templates/                     # 10 个文档模板
│       ├── AGENTS.md.template
│       ├── SOUL.md.template
│       ├── constitution.md.template
│       ├── PROJECT.md.template
│       ├── TECH_STACK.md.template
│       ├── SKILL.md.template
│       ├── spec.md.template
│       ├── ADR.md.template
│       ├── evidence.md.template
│       └── progress.md.template
└── docs/
    ├── product/                       # 产品需求（PROJECT.md）
    ├── engineering/                   # 技术文档（TECH_STACK.md 等）
    ├── acceptance/                    # 验收文档
    ├── decisions/                     # 架构决策记录（ADR）
    └── handoff/                       # harness 家族交接文档
        ├── README.md
        └── handoff-template.md
```

## 文档体系

### 核心文件

| 文件 | 作用 | 谁写 |
|------|------|------|
| `AGENTS.md` | 启动入口，核心规则 + 卡帕西原则 | 框架提供，项目可定制 |
| `SOUL.md` | Agent 人格 + 技术偏好 | setup 工作流引导填写 |
| `constitution.md` | 项目宪法（不可协商原则） | setup 工作流引导填写 |
| `docs/product/PROJECT.md` | 产品需求（功能+AC+里程碑） | brainstorming 维护 |
| `docs/engineering/TECH_STACK.md` | 技术栈（测试/构建/lint 命令） | setup 工作流引导填写 |
| `.harness/FEATURES.md` | 动态功能状态看板 | session-end 批量同步 |

### 文档间职责分工

| 维度 | PROJECT.md | FEATURES.md | spec.md |
|------|-----------|-------------|---------|
| 定位 | 需求定义 | 状态看板 | 单功能规格 |
| 时机 | 立项时写 | 开发中更新 | writing-plans 产出 |
| AC 层级 | 项目级验收条件 | — | 单功能细化验收条件（覆盖前者） |
| 状态 | 不含状态列 | 含状态列 | 不含状态列 |

## 工作流详解

### setup（立项引导）

```
install.sh 执行 → 引导填写 SOUL/constitution/PROJECT/TECH_STACK → 验证配置完整性
```

### new-feature（新功能开发）

```
session-start → brainstorming（硬门）→ writing-plans → LOOP(executing-plans→tdd→verify) → code-review → session-end
```

**brainstorming 硬门**（5 项检查，任何一条不满足停下问）：
- 需求是否清晰？
- 验收标准是否可测试？
- 宪法是否合规？
- 用户是否确认？
- 技术是否可行？

### bugfix（Bug 修复）

```
session-start → systematic-debugging（根因分析）→ LOOP(tdd→verify) → code-review → session-end
```

### refactor（重构）

```
session-start → brainstorming（确认边界）→ writing-plans → 前置：建立测试守护网 → LOOP(executing-plans→tdd→verify) → code-review → session-end
```

### optimize（性能优化）

```
session-start → performance-optimization(MEASURE→IDENTIFY→FIX→VERIFY→GUARD) → code-review → session-end
```

**铁律**：没有 baseline 数字不许改代码。

### migration（代码迁移）

```
session-start → 决策硬门 → brainstorming → writing-plans → LOOP(增量迁移→verify) → 验证零用量 → 移除旧系统 → session-end
```

### release（发版）

```
session-start → 发版前置检查（硬门）→ writing-documentation(CHANGELOG) → 版本号管理 → 构建+验证 → 打 tag → code-review → session-end
```

**发版硬门**：
- FEATURES.md 所有功能 done
- PROJECT.md 成功指标达标
- 全量测试通过
- 安全扫描无 critical/high
- constitution 合规

## LOOP 循环引擎

### state.yaml Schema

```yaml
# 必填
current_feature: 001-todo-cli
iteration: 2
stage: act          # plan / act / verify / debug
status: running     # running / done / needs-human / blocked
started_at: "2026-06-21T14:30:00"

# 可选（失败时）
last_error: "测试失败：Expected 3, got 2"
last_error_at: "2026-06-21T14:45:00"

# 可选（子阶段，用于 optimize/migration）
substage: "measure"
```

### 断点续传

会话中断后，session-start 读取 `state.yaml`，恢复到中断点继续。

### 超限保护

| 工作流 | 迭代上限 | 超限处理 |
|--------|:---:|---------|
| new-feature | 5 | 请求人类介入 |
| bugfix | 3 | 请求人类介入 |
| refactor | 3 | 请求人类介入 |
| optimize | 3 | 请求人类介入 |
| migration | 3 | 请求人类介入 |
| 总循环 | 10 | 请求人类介入 |

## harness 家族

harness-solo 是 harness 家族的**工程开发**成员，专注写代码。其他成员通过文档交接协作：

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| harness-pm | 产品研究/市场/PRD | 产出 `docs/handoff/pm-to-solo.md` → 本框架消费 |
| **harness-solo（本框架）** | **工程开发** | 产出 `docs/handoff/solo-to-growth.md` → 交给增长 |
| harness-design | UI/视觉设计（按需） | 产出设计稿 → 本框架实现 |
| harness-growth | 内容/SEO/数据（按需） | 消费本框架产出 |

## 卡帕西原则详解

### 1. Think Before Coding（先思考，后编码）

**不要代替用户做假设，不要隐藏困惑。**

- 需求模糊时，先列出可能的理解，让用户选择
- 不确定时提问，不要猜
- 实现前简要说明方案，特别是有 tradeoff 时
- 发现方案过度复杂时，主动提出更简单路径

### 2. Simplicity First（简单优先）

**用最小代码解决问题，不做 speculative 抽象。**

- 不添加未被请求的功能
- 不为一次性代码创建抽象
- 不添加不需要的"灵活性"或"配置性"
- 不为不可能发生的场景写错误处理
- 如果 200 行可以写成 50 行，重写它

### 3. Surgical Changes（手术刀式修改）

**只碰必须碰的代码，清理自己制造的混乱。**

- 不改与当前任务无关的代码、注释、格式
- 不重构没坏的东西
- 匹配现有风格，即使你更喜欢另一种
- 自己的改动产生了未使用变量/导入/函数 → 清理掉
- 预先存在的死代码，可以提但不动

### 4. Goal-Driven Execution（目标驱动执行）

**把指令转成可验证目标，循环直到达成。**

| 不要这样说 | 要这样说 |
|-----------|---------|
| "加个验证" | "写测试覆盖无效输入，然后让测试通过" |
| "修这个 Bug" | "写一个复现 Bug 的测试，然后让它通过" |
| "重构 X" | "确保重构前后测试都通过，且复杂度下降" |

## 安全红线

完整安全规则见 [`.harness/rules/security.md`](.harness/rules/security.md)。

| 禁止 | 理由 |
|------|------|
| 硬编码密钥 | 密钥泄露风险 |
| `rm -rf` | 误删风险 |
| `curl \| sh` | 供应链攻击风险 |
| 修改 `.git/hooks/` | 破坏 git 钩子完整性 |
| `git push --force` 到 main | 覆盖他人提交 |

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

**[⬆ 回到顶部](#harness-solo)** · **[English](README.en.md)**

</div>
