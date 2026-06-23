<div align="center">

# harness-design

### 个人 UI 设计框架 · 让 Agent 按设计原则做设计

**只管"好看好用"这件事** · 视觉设计 · 交互设计 · 原型产出 · 设计规范

[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Platform](https://img.shields.io/badge/platform-cross--platform-green.svg)](#跨平台兼容)
[![Principles](https://img.shields.io/badge/principles-Design%204-orange.svg)](#设计四原则详解)
[![Workflows](https://img.shields.io/badge/workflows-6-purple.svg)](#工作流详解)
[![Skills](https://img.shields.io/badge/skills-18-red.svg)](#核心特性)

**[快速开始](#快速开始)** · **[目录结构](#目录结构)**

</div>

---

> 产品研究 / 工程开发 / 运营增长见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 这是什么

harness-design 是一套**给 AI Agent 用的 UI 设计框架**。它不是代码库，而是一套规则 + 技能 + 工作流 + 状态管理机制，让 Agent 在帮你做设计时：

- **以用户为中心**（User-Centered）
- **系统优先**（System-First）
- **可访问性内建**（Accessible by Design）
- **可交付**（Deliverable）

这四条是本框架的核心约束，对应 harness-solo 的卡帕西四原则。

## 核心特性

### 设计四原则（已整合到 AGENTS.md + SOUL.md）

| 原则 | 含义 | 落地方式 |
|------|------|---------|
| User-Centered | 不假设用户审美，用 Persona 驱动 | design-brief 硬门：需求模糊时停下问 |
| System-First | 不重复造轮子，先建设计系统 | design-system + tokens.json 统一管理 |
| Accessible by Design | WCAG 2.1 AA 是硬约束 | accessibility-audit 强制检查 |
| Deliverable | 设计稿必须可交付实现 | design-handoff-spec 产出标注/规格/component-map.json |

### LOOP 循环引擎

```
PLAN（内联）→ LOOP(DESIGN → VERIFY → LINT) → LOOP 外门禁(DESIGN-REVIEW + ACCESSIBILITY-AUDIT)
```

- 每任务一个 `state.yaml`，支持断点续传
- LOOP 内 = verify + design-lint（快速检查）
- LOOP 外 = design-review + accessibility-audit（深度审查）
- 迭代上限保护：超 5 次请求人类介入
- 证据驱动：没有审查通过不声称完成

### 6 个工作流覆盖完整设计周期

```
setup（立项）→ new-design/design-iteration/design-system-setup/redesign（设计）→ design-handoff（交付）
```

| 工作流 | 场景 | LOOP 类型 | 迭代上限 |
|--------|------|---------|:---:|
| setup | 新项目立项引导 | 无 LOOP | - |
| new-design | 新设计任务（从0到1） | wireframe/visual/interaction | 5/5/5 |
| design-iteration | 设计迭代（已有设计优化） | visual（必跑）+ interaction（条件性） | 5/5 |
| design-system-setup | 设计系统从0到1 | component | 5 |
| redesign | 重设计（大改版） | visual（必跑）+ interaction（条件性） | 5/5 |
| design-handoff | 设计交付 | 无 LOOP | - |

### 18 个 Skill（14 设计 + 4 元）

**设计 skill**：
- 需求与推荐：design-brief / design-recommendation
- 设计系统：design-system / design-system-import / design-system-refactor
- 设计产出：visual-design / interaction-design / wireframe / component-design
- 审查与验证：verify / design-lint / design-review / accessibility-audit
- 交付：design-handoff-spec

**元 skill**：session-start / session-end / skill-maintenance / memory-maintenance

### 数据驱动设计推荐

基于 `.harness/data/design/` 下的 8 个 CSV 文件，根据产品类型自动推荐风格/配色/字体/落地页模式：

| 数据文件 | 作用 |
|---------|------|
| reasoning.csv | 推理规则（产品类型 → 推荐 + Decision_Rules） |
| products.csv | 产品类型映射 |
| styles.csv | 风格库 |
| colors.csv | 配色库 |
| typography.csv | 字体库 |
| landing.csv | 落地页模式 |
| ux-guidelines.csv | UX 规则 |
| vibes.csv | 氛围词到 token 的映射 |

### 反 AI 同质化（Anti AI-Slop）

整合自 anthropics/skills + addyosmani/agent-skills，作为硬约束：

- 禁用 Inter/Roboto/Arial 作为主字体
- 禁用 #6366f1 紫色和紫蓝渐变
- 禁用统一圆角（rounded-2xl 全场）
- 禁用 Lorem ipsum 占位文本
- 由 design-lint skill 用 Node.js 脚本机械检查

### 跨平台兼容

- **Agent 工具优先**：所有流程优先用 Read/Write/Edit/Glob/Grep 等工具
- **bash 可选兜底**：脚本有 bash 可用性检查，Windows 环境自动跳过
- **不依赖 PowerShell 专用语法**

### 安全红线

| 禁止 | 检查方式 |
|------|---------|
| 设计稿泄露真实用户 PII | security.md + verify 扫描 |
| 截图包含敏感信息 | security.md + Agent 拒绝 |
| 设计文件包含密钥 | security.md + Agent 拒绝 |

## 快速开始

### 1. 安装到你的项目

```bash
# 在你的项目根目录执行
bash install.sh
```

install.sh 会：
- 创建 `.harness/` 目录结构
- 从模板生成 `AGENTS.md` / `SOUL.md` / `constitution.md`
- 创建 `docs/` 目录（visual/interaction/prototype/design-system/handoff）
- 初始化 `docs/visual/DESIGN_BRIEF.md` 和 `docs/design-system/DESIGN.md`

> Windows 用户：用 Git Bash 或 WSL 运行 install.sh。

### 2. 填写项目配置

运行 setup 工作流，Agent 会引导你填写：
- `SOUL.md`：人格 + 设计偏好
- `constitution.md`：项目宪法（不可协商原则）
- `docs/visual/DESIGN_BRIEF.md`：设计需求（含 AC-xxx 验收标准）
- `docs/design-system/DESIGN.md`：设计系统（10 段标准格式）

### 3. 开始设计

对 Agent 说：
- "我要设计一个登录页" → 进入 new-design 工作流
- "这个页面的配色优化下" → 进入 design-iteration 工作流
- "建立设计系统" → 进入 design-system-setup 工作流
- "这个模块要重做" → 进入 redesign 工作流
- "准备交付给工程" → 进入 design-handoff 工作流

Agent 会自动读取对应工作流，按流程推进。

## 目录结构

```
harness-design/
├── AGENTS.md                          # 启动必读（唯一强制入口）
├── SOUL.md                            # Agent 人格 + 设计价值观
├── constitution.md                    # 项目宪法（不可协商原则）
├── install.sh                         # 冷启动安装脚本
├── .gitignore
├── .harness/
│   ├── VERSION
│   ├── FEATURES.md                    # 动态设计任务状态看板
│   ├── loops/
│   │   └── LOOP.md                    # 循环引擎定义
│   ├── memory/
│   │   ├── progress.md                # 会话进度日志
│   │   └── knowledge-base.md          # 跨会话知识库
│   ├── rules/
│   │   ├── security.md                # 安全红线
│   │   └── prompt-defense.md          # prompt 注入防护
│   ├── skills/
│   │   ├── INDEX.md                   # skill 索引（80 行内）
│   │   ├── design/                    # 14 个设计 skill
│   │   ├── meta/                      # 4 个元 skill
│   │   └── workflows/                 # 6 个工作流
│   ├── data/design/                   # 数据驱动设计推荐（8 个 CSV）
│   ├── craft/                         # 通用工艺规则
│   │   ├── anti-ai-slop.md
│   │   ├── common-rules.md
│   │   ├── typography.md
│   │   └── color.md
│   └── templates/                     # 文档模板
└── docs/
    ├── visual/                        # 视觉设计（DESIGN_BRIEF.md 等）
    ├── interaction/                   # 交互设计
    ├── prototype/                     # 原型（wireframe 等）
    ├── design-system/                 # 设计系统（DESIGN.md / tokens.json 等）
    └── handoff/                       # harness 家族交接文档
```

## 文档体系

### 核心文件

| 文件 | 作用 | 谁写 |
|------|------|------|
| `AGENTS.md` | 启动入口，核心规则 + 设计四原则 | 框架提供，项目可定制 |
| `SOUL.md` | Agent 人格 + 设计偏好 | setup 工作流引导填写 |
| `constitution.md` | 项目宪法（不可协商原则） | setup 工作流引导填写 |
| `docs/visual/DESIGN_BRIEF.md` | 设计需求（功能+AC-xxx+里程碑） | design-brief 维护 |
| `docs/design-system/DESIGN.md` | 设计系统（10 段标准格式） | design-system 维护 |
| `docs/design-system/tokens.json` | Token（W3C 格式，机器可读） | design-system 维护 |
| `.harness/FEATURES.md` | 动态设计任务状态看板 | session-end 批量同步 |

## 工作流详解

### setup（立项引导）

```
session-start → design-brief（硬门）→ design-recommendation → design-system → session-end
```

### new-design（新设计任务）

```
session-start → design-brief（硬门）→ PLAN → LOOP(wireframe→verify→lint) → LOOP(visual→verify→lint) → LOOP(interaction→verify→lint) → design-review → accessibility-audit → session-end
```

**design-brief 硬门**（5 项检查，任何一条不满足停下问）：
- 设计需求是否清晰？
- 验收标准是否可测试（AC-xxx）？
- 宪法是否合规？
- 用户是否确认？
- 技术是否可行？

### design-iteration（设计迭代）

```
session-start → Chesterton's Fence 分析 → PLAN → LOOP(visual→verify→lint) → [LOOP(interaction→verify→lint) 条件性] → design-review → accessibility-audit → session-end
```

### design-system-setup（设计系统从0到1）

```
session-start → design-brief → design-recommendation → design-system → PLAN → LOOP(component→verify→lint) → design-review → session-end
```

### redesign（重设计）

```
session-start → design-brief（硬门）→ design-system-import → 差异分析 → PLAN → LOOP(visual→verify→lint) → [LOOP(interaction→verify→lint) 条件性] → design-review → accessibility-audit → session-end
```

### design-handoff（设计交付）

```
session-start → 前置条件检查（硬门）→ design-handoff-spec（含 Pre-Delivery Checklist）→ session-end（产出 design-to-solo.md + component-map.json）
```

## LOOP 循环引擎

### 循环类型

| 类型 | 触发场景 | 最大迭代 |
|------|---------|:---:|
| visual-design | 视觉设计任务 | 5 |
| interaction-design | 交互设计任务 | 5 |
| wireframe | 线框图/低保真原型 | 5 |
| component | 组件设计 | 5 |

### state.yaml Schema

```yaml
# 必填
current_task: 001-login-page
iteration: 2
stage: lint         # plan / design / verify / lint / review
status: retrying    # running / retrying / done / failed
started_at: "2026-06-21T14:30:00"

# 可选（失败时）
last_error: "Lint L001: 硬编码 #3B82F6，应使用 token color.primary"
last_error_at: "2026-06-21T14:45:00"
```

### 断点续传

会话中断后，session-start 读取 `state.yaml`，恢复到中断点继续。

### 超限保护

| 工作流 | 迭代上限 | 超限处理 |
|--------|:---:|---------|
| new-design | 5/5/5（3 个 LOOP 各自计数） | 请求人类介入 |
| design-iteration | 5 | 请求人类介入 |
| design-system-setup | 5 | 请求人类介入 |
| redesign | 5 | 请求人类介入 |
| 单 LOOP 硬熔断 | 10 | 停止，请求人类介入 |

## harness 家族

harness-design 是 harness 家族的**UI 设计**成员，专注好看好用。其他成员通过文档交接协作：

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| harness-pm | 产品研究/市场/PRD | 产出 `docs/handoff/pm-to-design.md` → 本框架消费 |
| **harness-design（本框架）** | **UI/视觉/交互设计** | 产出 `docs/handoff/design-to-solo.md` → 交给工程 |
| harness-solo | 工程开发 | 消费本框架产出的设计稿 |
| harness-growth | 内容/SEO/数据（按需） | 消费本框架产出 |

## 设计四原则详解

### 1. User-Centered（以用户为中心）

**不假设用户审美，用 Persona 和场景驱动设计决策。**

- 需求模糊时，先列出可能的理解，让用户选择
- 不确定时提问，不要猜
- 设计时带入 Persona 和使用场景，不凭个人喜好

### 2. System-First（系统优先）

**不重复造轮子，先建设计系统再画页面。**

- 不添加未被请求的设计元素
- 不为一次性页面创建新组件
- 如果现有 token 能覆盖，不新建 token

### 3. Accessible by Design（可访问性内建）

**WCAG 2.1 AA 是硬约束，不是事后补。**

- 对比度、键盘导航、屏幕阅读器从设计阶段就考虑
- 不为"好看"牺牲可访问性
- 每份设计稿必须标注可访问性合规等级

### 4. Deliverable（可交付）

**设计稿必须可被工程实现，标注/切图/规格齐全。**

| 不要这样说 | 要这样说 |
|-----------|---------|
| "做个好看的按钮" | "AC-001: 按钮 4 种状态，标注尺寸+颜色+圆角" |
| "这个页面要现代" | "AC-001: 页面用 12 栅格 / AC-002: 主色 #xxx / AC-003: 间距 8px 基准" |

## 安全红线

完整安全规则见 [`.harness/rules/security.md`](.harness/rules/security.md)。

| 禁止 | 理由 |
|------|------|
| 设计稿泄露真实用户 PII | 隐私泄露风险 |
| 截图包含敏感信息 | 信息泄露风险 |
| 设计文件包含密钥 | 密钥泄露风险 |
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

**[⬆ 回到顶部](#harness-design)**

</div>
