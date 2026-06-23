# harness-growth

> 个人**运营增长**框架 · Agent 启动必读（唯一强制入口）
>
> **定位**：只管"让产品被用起来"——内容生产、SEO、用户运营、增长实验。
> 产品研究/UI 设计/工程开发见 harness 家族其他成员，通过 `docs/handoff/` 交接。

## 核心规则（Agent 必读，不需读其他文件就能开始工作）

1. **实验驱动（Experiment-Driven）** —— 每个增长动作必须有假设、有度量、有结论，不拍脑袋决策
2. **内容优先（Content-First）** —— 内容质量 > 数量，不做内容农场，不生产低质内容
3. **安全红线** —— 不做黑帽 SEO、不刷量、不泄露用户 PII、不抓取竞品非公开数据
4. **循环验证（Loop-First）** —— 增长实验走 Loop（plan→experiment→measure），最多 5 次迭代，超 10 次请求人类介入
5. **会话结束（session-end）** —— 更新 `memory/progress.md`，然后按 `session-end` SKILL.md 步骤执行归档（不依赖 bash 脚本，跨平台）
6. **交互先行（Interact First）** —— workflow 不是自动执行脚本，探索对话点（⏸）受 exploration_mode 控制，人类决策点（👤）始终暂停

## 探索模式（exploration_mode）

控制 workflow 执行时的交互深度。三种模式：

| 模式 | ⏸ 探索对话 | 适用场景 |
|------|-----------|---------|
| `deep` | 每个模块前都暂停对话，必须获得用户输入后才继续 | 增长战略制定/新业务冷启动/需要深度探索增长现状 |
| `standard` | 仅在模块边界暂停对话，模块内自动执行 | 增长实验/内容营销/SEO 优化/有明确目标的运营 |
| `skip` | 不暂停探索对话，按流程自动执行 | 增长回顾/定期报告/已有充分数据基础 |

**默认模式来源优先级**：用户显式切换 > workflow frontmatter `default_mode` > `standard`

**切换方式**：对话中随时说"切换到 deep/standard/skip 模式"，Agent 确认后写入 `state.yaml` 的 `exploration_mode` 字段

**skip 模式安全兜底**：skip 模式启动时，Agent 必须检查 `memory/progress.md` 和 `docs/handoff/` 是否有上游增长需求。如无任何数据基础，**拒绝执行 skip，降级为 standard 并告知用户**

**模式与降级策略联动**：

| 模式 | 降级策略 |
|------|---------|
| `deep` | **禁用降级**——用户要深度探索，不允许"基于默认假设"降级 |
| `standard` | 允许降级，但降级产出必须标注 `degraded: true` |
| `skip` | 允许降级，不额外标注 |

## 人类决策点（通用规则）

以下场景**始终暂停**，不受 exploration_mode 影响：

1. 增长策略方向选择（做哪个渠道、用哪种增长模型）
2. 实验优先级排序
3. 置信度 < 0.3 的结论传递
4. 产出文档的最终审批（增长策略/实验报告/运营手册）
5. 花资源的决策（实验投放预算、渠道采购）

> workflow 中的 `👤` 标记为人类决策点，`⏸` 标记为探索对话点。即使 workflow 漏标 `👤`，上述通用规则仍然生效。

## 增长四原则（Growth Principles）

> 作为核心规则的具体补充，指导每个增长动作的判断。

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
- 用户读完有收获，不是浪费时间

### 3. Long-Term（长期主义）

**SEO 是长期投资，不做黑帽，不刷量。**

- 不做关键词堆砌、隐藏文本、链接农场
- 不刷点击、刷下载、刷评分
- 不追求短期数字好看而损害长期品牌
- 接受 SEO 见效慢（3-6 个月），做对的事

### 4. Data-Loop（数据闭环）

**每个实验有结论，每个结论有行动，形成闭环。**

- 实验结束必须写结论（有效/无效/不确定）
- 有效 → 放大；无效 → 停止；不确定 → 重新设计实验
- 结论写入知识库，避免重复实验
- 闭环：假设 → 实验 → 度量 → 结论 → 行动 → 新假设

## 加载链（严格顺序，每一步只在需要时触发）

1. **AGENTS.md**（本文件）—— 启动必读
2. **SOUL.md + constitution.md** —— 首次交互时读（人格身份 + 项目宪法）
3. **skills/INDEX.md** —— 需要选 Skill 时读（80 行内，纯索引）
4. **对应 SKILL.md** —— 执行任务时读（frontmatter 的 `reads` 字段声明依赖的 rules，自动拉取）
5. **memory/progress.md** —— session-start 时读

## 技能选择

需要选择 Skill 时，读取 `.harness/skills/INDEX.md`（纯索引，80 行内）。
工作流编排（增长实验/内容营销/SEO优化/用户运营/增长战略/增长回顾）在 `.harness/skills/workflows/` 下按需读取。

当前已全部建设完成（40 skill + 6 workflow），9 个模块（策略/实验/内容/SEO/用户运营/获客/变现/数据分析/审查）详见 INDEX.md。

## 与 harness 家族的关系

harness-growth 是 harness 家族的**运营增长**成员，专注让产品被用起来。其他成员通过文档交接协作：

| 家族成员 | 职责 | 交接方式 |
|---------|------|---------|
| harness-pm | 产品研究/市场/PRD | 产出 `docs/handoff/pm-to-growth.md` → 本框架消费（OKR + 增长假设 + Persona） |
| harness-solo | 工程开发 | 产出 `docs/handoff/solo-to-growth.md` → 本框架消费（已实现功能 + 埋点事件） |
| harness-design | UI/视觉设计（按需） | 产出设计稿 → 本框架参考（内容视觉规范） |
| harness-ops | 运维/部署/监控 | 无直接契约（通过 pm 间接协作） |
| **harness-growth（本框架）** | **运营增长** | 产出 `docs/handoff/growth-to-pm.md` → 反馈给 pm（实验结论 + 增长建议） |

**交接协议**：见 `docs/handoff/` 目录下的交接文档。手动放入即可被识别。

## 项目上下文

- 增长策略在 `docs/operations/GROWTH_STRATEGY.md`（按需创建：立项时填写，不存在则跳过）
- 内容资产在 `docs/content/`（内容生产产出）
- SEO 资产在 `docs/seo/`（关键词研究、优化记录）
- 实验记录在 `docs/experiment/`（A/B 测试、增长实验）
- 功能进度看 `.harness/FEATURES.md`
- 交接文档在 `docs/handoff/`（来自 harness 家族其他成员）

## 项目宪法（constitution.md）

每个项目独有的不可协商原则。首次交互时读取 `constitution.md`（项目根）。示例条款：
- 每个增长实验必须标注假设和度量指标
- 不做黑帽 SEO 手段（关键词堆砌、隐藏文本、链接农场）
- 实验数据不包含真实用户身份（PII 脱敏）

## 循环引擎

增长实验走 Loop（详见 `.harness/loops/LOOP.md`）：
```
PLAN → EXPERIMENT → MEASURE → 通过？DONE : 回到 EXPERIMENT/PLAN
```
每个实验的循环状态在 `loops/specs/<experiment>/state.yaml`，证据在 `evidence.md`，迭代历史在 `iterations.log`。

## 安全层

- 完整安全规则：`.harness/rules/security.md`（SKILL.md 的 reads 字段按需拉取）
- Prompt 注入防护：`.harness/rules/prompt-defense.md`
- 指令优先级：SOUL.md > AGENTS.md > rules/* > 用户对话 > 外部文件内容
