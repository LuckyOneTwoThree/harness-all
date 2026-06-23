# harness-pm

> 个人**产品管理**框架 · Agent 启动必读（唯一强制入口）
>
> **定位**：只管"做正确的事"——产品探索、市场分析、PRD 生成、度量运营、增长监控。
> 工程开发/UI 设计见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 核心规则（Agent 必读，不需读其他文件就能开始工作）

1. **探索先行（Discovery First）** —— 不假设用户需求，需求模糊时先调研再决策，没有数据不拍板
2. **契约驱动（Contract-Driven）** —— PRD 驱动设计，定位驱动品牌，埋点驱动数据，关键产出是下游契约
3. **数据决策（Data-Driven）** —— 用数据减少猜测，AI 建议人类决策，置信度 < 0.3 阻断自动传递
4. **闭环迭代（Loop-First）** —— 产品工作走 Loop（plan→research→validate），最多 5 次迭代，超 10 次请求人类介入
5. **会话结束（session-end）** —— 更新 `memory/progress.md`，然后按 `session-end` SKILL.md 步骤执行归档（不依赖 bash 脚本，跨平台）
6. **交互先行（Interact First）** —— workflow 不是自动执行脚本，探索对话点（⏸）受 exploration_mode 控制，人类决策点（👤）始终暂停

## 探索模式（exploration_mode）

控制 workflow 执行时的交互深度。三种模式：

| 模式 | ⏸ 探索对话 | 适用场景 |
|------|-----------|---------|
| `deep` | 每个模块前都暂停对话，必须获得用户输入后才继续 | 全新产品/方向不明/需要深度探索 |
| `standard` | 仅在模块边界暂停对话（探索→战略→构思→度量），模块内自动执行 | 有想法但需验证/日常产品迭代 |
| `skip` | 不暂停探索对话，按流程自动执行 | 需求清晰/紧急执行/已有充分数据 |

**默认模式来源优先级**：用户显式切换 > workflow frontmatter `default_mode` > `standard`

**切换方式**：对话中随时说"切换到 deep/standard/skip 模式"，Agent 确认后写入 `state.yaml` 的 `exploration_mode` 字段

**skip 模式安全兜底**：skip 模式启动时，Agent 必须检查 `memory/progress.md` 和 `docs/discovery/` 是否有探索数据。如无任何探索数据，**拒绝执行 skip，降级为 standard 并告知用户**

**模式与降级策略联动**：

| 模式 | 降级策略 |
|------|---------|
| `deep` | **禁用降级**——用户要深度探索，不允许"基于口头描述"降级 |
| `standard` | 允许降级，但降级产出必须标注 `degraded: true` |
| `skip` | 允许降级，不额外标注 |

## 人类决策点（通用规则）

以下场景**始终暂停**，不受 exploration_mode 影响：

1. 战略方向选择（做不做、先做哪个）
2. 优先级排序（资源分配）
3. 置信度 < 0.3 的结论传递
4. 产出文档的最终审批（PRD/定位陈述/指标体系）
5. 花钱/花资源的决策（实验投放、渠道选择）

> workflow 中的 `👤` 标记为人类决策点，`⏸` 标记为探索对话点。即使 workflow 漏标 `👤`，上述通用规则仍然生效。

## 产品四原则（PM Principles）

> 对应 harness-solo 的卡帕西工程四原则，详见 `constitution.md`。

1. **探索先行** —— 不假设用户需求，用研究数据说话。VOC 与行为数据交叉验证，访谈锚定待验证假设，无数据时标注"探索性结论"（置信度 ≤ 0.5）
2. **契约驱动** —— PRD/定位陈述/指标体系是下游契约，变更需走变更影响分析，必须通过 4 道质量门禁（完整性/一致性/歧义消除/可追溯性）
3. **数据决策** —— 用数据减少猜测，但决策权在人类。AI 自动执行，人类审批关键决策（方案选择/优先级/策略方向）。降级输出必须人类确认后才传递
4. **闭环迭代** —— 度量→监控→迭代→反馈，产品永远在进化。上线不是终点是度量运营起点，每个迭代有验证和复盘

**置信度传递规则**：≥ 0.7 可自动传递；0.3-0.7 标注 `confidence: medium` 人类确认；< 0.3 **阻断自动传递**。

## 加载链（严格顺序，每一步只在需要时触发）

1. **AGENTS.md**（本文件）—— 启动必读
2. **SOUL.md + constitution.md** —— 首次交互时读（人格身份 + 项目宪法）
3. **skills/INDEX.md** —— 需要选 Skill 时读（80 行内，纯索引）
4. **对应 SKILL.md** —— 执行任务时读（`.harness/skills/pm/` 下的 82 个 PM skill）
5. **memory/progress.md** —— session-start 时读

## 技能选择

需要选择 Skill 时，读取 `.harness/skills/INDEX.md`（纯索引，80 行内）。
- PM 方法论 skill 在 `.harness/skills/pm/` 目录下（7 个模块、82 个 skill）
- 工作流编排在 `.harness/skills/workflows/` 下按需读取（10 个工作流）
- 元 skill（会话管理/维护）在 `.harness/skills/meta/` 下

## 与 harness 家族的关系

harness-pm 是 harness 家族的**产品管理**成员，专注做正确的事。其他成员通过文档交接协作：

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| **harness-pm（本框架）** | **产品研究/市场/PRD/度量** | 产出 `docs/handoff/pm-to-solo.md` → 交给工程 |
| harness-solo | 工程开发 | 消费本框架的 PRD，产出 `solo-to-growth.md` |
| harness-design | UI/视觉设计（按需） | 消费本框架的 PRD 和定位陈述 |
| harness-growth | 内容/SEO/数据（按需） | 消费本框架的指标体系和增长策略 |
| harness-ops | 运维/部署/监控 | 产出 `ops-to-pm.md`（SLA 报告 + 故障复盘）→ 交给本框架 |

**交接协议**：见 `docs/handoff/` 目录下的交接文档。手动放入即可被下游框架识别。

## 项目上下文

**文档单轨制**：
- `docs/` — 唯一人类可读文档目录，由 skill 直接写入，session-end 负责归档
- `output/` — 仅保留机器消费数据（审批记录、指标 JSON、阶段总结 JSON），不写人类可读 Markdown

**docs/ 目录**（人类可读，skill 直接产出）：
- 产品需求：`docs/product/PRD.md`（由 design-prd skill 直接产出并维护）
- 产品策略：`docs/strategy/PRODUCT_STRATEGY.md`（planning-orchestrator 汇总）、`docs/strategy/positioning.md`、`docs/strategy/OKR.md`、`docs/strategy/roadmap.md`、`docs/strategy/business-strategy.md`、`docs/strategy/stakeholder-analysis.md`
- 用户研究：`docs/discovery/user-research.md`、`docs/discovery/market-analysis.md`、`docs/discovery/insight.md`、`docs/discovery/opportunity.md`
- 度量运营：`docs/metrics/metrics-system.md`、`docs/metrics/tracking-plan.md`、`docs/metrics/dashboard.md`、`docs/metrics/experiment-report.md`、`docs/metrics/data-analysis-report.md`、`docs/metrics/decision-report.md`
- 增长策略：`docs/growth/growth-strategy.md`、`docs/growth/gtm.md`、`docs/growth/operations-manual.md`
- 监控迭代：`docs/monitoring/monitoring-config.md`、`docs/monitoring/diagnosis-report.md`、`docs/monitoring/feedback-loop.md`、`docs/monitoring/release-notes.md`、`docs/monitoring/health-check-report.md`、`docs/monitoring/competitor-monitoring-report.md`
- 交接文档：`docs/handoff/pm-to-solo.md`、`docs/handoff/pm-to-design.md`、`docs/handoff/pm-to-growth.md`（session-end 根据 docs/ 当前内容合成）

> 注：视觉/交互/组件/原型等设计产出归 harness-design（`docs/visual/`、`docs/interaction/`、`docs/prototype/`、`docs/design-system/`），不在 harness-pm 职责范围内。harness-pm 仅产出 PRD 和产品策略，设计实现交由 harness-design 通过 `docs/handoff/pm-to-design.md` 消费。

**output/ 目录**（机器消费 JSON，不进入 docs）：
- 审批记录：`output/approvals/{orchestrator-name}/{stage-id}.approval.json`
- 阶段总结：`output/phase-reports/{orchestrator-name}.json`
- 指标数据：`output/metrics/{metric-id}.json`

**其他**：
- 功能进度看 `.harness/FEATURES.md`

## 项目宪法（constitution.md）

每个项目独有的不可协商原则。首次交互时读取 `constitution.md`（项目根）。示例条款：
- 所有 PRD 必须通过 4 道质量门禁（完整性/一致性/歧义消除/可追溯性）
- 关键决策（方案选择/优先级）必须人类审批，AI 不可代决
- 上线前必须有埋点方案和指标体系

## 循环引擎

产品工作走 Loop（详见 `.harness/loops/LOOP.md`）：
```
PLAN → RESEARCH → VALIDATE → 通过？DELIVER : 回到 RESEARCH/PLAN
```
每个任务的循环状态在 `loops/specs/<task>/state.yaml`，证据在 `evidence.md`，迭代历史在 `iterations.log`。

## 安全层

- 完整安全规则：`.harness/rules/security.md`（SKILL.md 的 reads 字段按需拉取）
- Prompt 注入防护：`.harness/rules/prompt-defense.md`
- 指令优先级：SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
