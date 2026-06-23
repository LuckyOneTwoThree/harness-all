---
name: session-end
description: 会话收尾，归档进度 + 写 baseline + 更新看板 + 可选产出交接文档
triggers:
  - 任务完成声称前
  - 用户结束会话时
  - 会话上下文接近上限时
reads:
  - memory/progress.md
  - loops/specs/*/state.yaml
  - FEATURES.md
  - docs/handoff/handoff-template.md
  - docs/handoff/pm-to-design-template.md
  - docs/handoff/pm-to-solo-template.md
  - docs/handoff/pm-to-growth-template.md
  - docs/discovery/user-research.md
  - docs/discovery/market-analysis.md
writes:
  - memory/progress.md
  - memory/baseline.json
  - memory/archives/
  - FEATURES.md
  - docs/handoff/pm-to-solo.md
  - docs/handoff/pm-to-design.md
  - docs/handoff/pm-to-growth.md
---

# Session End — 会话收尾

## 铁律
会话结束前必须归档，不允许"裸退"——下次会话会失忆

## 流程

1. **更新 progress.md**
   在当前会话块补全：
   - 完成的事项（带证据摘要）
   - 待续事项（下次会话需要知道的上下文）
   - 关键决策（本次会话做出的重要决定）
   - 探索模式（如本次会话使用了 workflow，记录当前 exploration_mode 及切换历史）

2. **批量更新 FEATURES.md**
   扫描 `.harness/loops/specs/*/state.yaml`：
   - status 为 `done` 的任务 → FEATURES.md 对应功能状态改 `approved` 或 `review`
   - status 为 `running` 的任务 → 状态保持 `in_progress`
   - 记录最后更新日期

3. **写入 baseline.json**（供 entropy-check 用）
   统计当前项目指标写入 `.harness/memory/baseline.json`：
   ```json
   {
     "timestamp": "YYYY-MM-DDTHH:MM:SSZ",
     "docs": <文档数>,
     "skills_used": <使用的skill数>,
     "outputs": <产出文件数>,
     "pending_decisions": <待决策数>
   }
   ```
   统计方式（Agent 用工具完成，不依赖 bash）：
   - docs：用 Glob 扫描 docs/ 下的 .md 文件
   - skills_used：从 progress.md 统计本次会话调用的 skill
   - outputs：用 Glob 扫描 docs/ 下的 .md 文件
   - pending_decisions：从 FEATURES.md 统计 pending/review 状态的功能

4. **执行归档**（硬性指令，跨平台）
   按以下步骤操作（不依赖 bash 脚本）：

   **步骤 4.1：检测 progress.md 行数**
   - 用 Read 读取 `.harness/memory/progress.md`
   - 统计行数（≤200 行 → 跳过归档，直接进入步骤 5）

   **步骤 4.2：切档（行数 > 200 时）**
   - 用 Read 读取完整 progress.md 内容
   - 找到最后一个 `## 会话:` 标记的位置（保留最后一个完整会话块）
   - 将标记之前的内容切出，归档到 `.harness/memory/archives/YYYY-MM-DD-HHMM-progress.md`
   - 用 Write 写回 progress.md：只保留最后一个会话块 + 顶部说明行
   - 用 Write 写入归档文件：切出的历史内容

5. **提取重要发现**（如有）
   本次会话如果有值得长期沉淀的知识（产品决策、用户洞察、市场发现），写入 `memory/knowledge-base.md`

6. **产出交接文档**（可选，满足条件时执行）

   **写权限单向隔离（不可协商）**：交接文档只有产出方可以写入。`pm-to-solo.md` 只有 PM 能写，`pm-to-design.md` 只有 PM 能写，`pm-to-growth.md` 只有 PM 能写，以此类推。消费方只能读取，禁止修改上游交接文档。如需反馈，通过 `AskUserQuestion` 让用户转达，或写入自己的出站交接文档。

   根据本次会话产出类型，生成对应的交接文档：

   **6a. 产出 pm-to-solo.md**（产品 → 工程）
   如果本次会话完成了**可交接给工程**的产品设计（如 PRD、设计规范、埋点方案），按 `docs/handoff/pm-to-solo-template.md` 模板产出 `docs/handoff/pm-to-solo.md`：

   **触发条件**（任一满足）：
   - 本次会话有功能状态从 `in_progress` 变为 `approved`
   - 用户明确要求"准备交接给工程"
   - 完成的任务涉及 PRD、设计规范、埋点方案等工程需要的产出

   **产出内容**（按 pm-to-solo-template.md 填写）：
   - 产品基本信息（产品类型 / 技术栈 / 平台 / 当前阶段）
   - PRD 路径 + AC-xxx 清单
   - **业务上下文摘要**（Business Context Digest，见 6a.1）
   - 功能优先级（P0/P1/P2）
   - 埋点方案路径（如有）
   - 设计资产状态（待 harness-design 产出 / 已就绪）

   **6a.1 业务上下文摘要提取**（6a 子步骤）：
   - 读取 `docs/discovery/user-research.md` 和 `docs/discovery/market-analysis.md`（如不存在则跳过，摘要填"无业务上下文摘要，按 AC 自行判断"）
   - **只提取影响工程决策的约束**，不提取用户画像/心理模型/审美偏好（那些给 design，不给工程）
   - 提取范围：影响架构/技术选型/性能要求/容量规划/数据规模的约束
   - 每条约束填写：约束项 + 工程影响 + 来源（文件名#章节）
   - 写入 pm-to-solo.md 的"业务上下文摘要"章节

   **6b. 产出 pm-to-design.md**（产品 → 设计）
   如果本次会话完成了**可交接给设计**的产品需求（如 PRD、定位陈述、Persona、用户画像），按 `docs/handoff/pm-to-design-template.md` 模板产出 `docs/handoff/pm-to-design.md`：

   **触发条件**（任一满足）：
   - 本次会话产出了 PRD 或更新了 PRD 的核心字段（产品类型/目标受众/Persona/AC）
   - 用户明确要求"准备交接给设计"
   - 完成的任务涉及定位陈述、用户画像、功能需求等设计消费所需内容

   **产出内容**（按 pm-to-design-template.md 填写）：
   - 产品类型 / 目标受众 / 技术栈
   - Persona 路径 / 定位陈述
   - PRD 路径（含 AC-xxx 编号清单）
   - 风格关键词 / 不做清单
   - 已有设计系统资产路径（如有）

   **注意**：
   - 如本次会话无对外可交付产出（纯调研、纯分析），跳过本步骤
   - 如 `pm-to-solo.md` / `pm-to-design.md` / `pm-to-growth.md` 已存在，追加本次交付内容，不覆盖历史
   - 文件名固定，不要按日期拆分（下游只看最新状态）
   - 多个文件可同时产出（如本次会话同时完成了 PRD 和 OKR，PRD 交设计，OKR 交增长）

   **6c. 产出 pm-to-growth.md**（产品 → 增长）
   如果本次会话完成了**可交接给增长**的产品数据（如 OKR、北极星指标、增长假设、埋点方案），按 `docs/handoff/pm-to-growth-template.md` 模板产出 `docs/handoff/pm-to-growth.md`：

   **触发条件**（任一满足）：
   - 本次会话产出了 OKR 或定义了北极星指标
   - 用户明确要求"准备交接给增长"
   - 完成的任务涉及指标定义、增长假设、埋点方案等增长消费所需内容

   **产出内容**（按 pm-to-growth-template.md 填写）：
   - 产品类型 / 目标受众 / 当前阶段
   - 定位陈述 / 北极星指标
   - OKR 清单 / Persona 增长特征
   - 增长假设 / 已有数据资产路径（如有）

   **6d. AC 格式校验**（交接文档必须通过）
   对步骤 6a/6b/6c 产出的交接文档执行验收标准格式校验：
   - 扫描交接文档中的验收标准，检查编号格式是否为 `AC-NNN`（如 AC-001, AC-002）
   - 检查编号是否连续（不允许 AC-001 后直接跳到 AC-003）
   - 检查每个 AC 是否包含：描述 + 验证方式
   - 如发现格式异常（如"验收标准一"、编号不连续、缺少验证方式），**阻断交接**，要求修正后重新产出

## 禁止事项
- 不更新 progress.md 就结束（下次会话失忆）
- 不执行归档步骤 4（progress.md 无限膨胀）
- 不写 baseline.json（entropy-check 无法计算增长率）
- 在无 bash 环境下强行执行 .sh 脚本（会卡死）

## 与 LOOP 的关系
本 skill 在 LOOP 之后执行，是会话的收尾。
session-start → ... → LOOP → ... → session-end

## 证据要求
session-end 完成后，progress.md 必须包含：
- 本次会话做了什么
- 下次会话需要继续什么
- 归档操作的实际结果（如"progress.md 从 250 行切到 45 行，归档到 archives/2026-06-20-1900-progress.md"）
- 如执行了步骤 6a，记录"产出 pm-to-solo.md，包含 X 个交付项 + 业务上下文摘要 X 条约束"
- 如执行了步骤 6b，记录"产出 pm-to-design.md，包含 PRD 路径 + X 条 AC + Persona 路径"
- 如执行了步骤 6c，记录"产出 pm-to-growth.md，包含 OKR + 北极星指标 + X 条增长假设"
