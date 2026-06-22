---
name: session-end
description: 会话收尾，归档进度 + 写 baseline + 更新看板 + 可选产出交接文档 growth-to-pm.md
triggers:
  - 任务完成声称前
  - 用户结束会话时
  - 会话上下文接近上限时
reads:
  - memory/progress.md
  - loops/specs/*/state.yaml
  - FEATURES.md
  - docs/handoff/growth-to-pm-template.md
writes:
  - memory/progress.md
  - memory/baseline.json
  - memory/archives/
  - FEATURES.md
  - docs/handoff/growth-to-pm.md
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
   - 实验结论（本次会话得出的增长结论）

2. **批量更新 FEATURES.md**
   扫描 `.harness/loops/specs/*/state.yaml`：
   - status 为 `done` 的实验 → FEATURES.md 对应实验状态改 `done`
   - status 为 `running` 的实验 → 状态保持 `in_progress`
   - 记录最后更新日期

3. **写入 baseline.json**（供 entropy-check 用）
   统计当前项目指标写入 `.harness/memory/baseline.json`：
   ```json
   {
     "timestamp": "YYYY-MM-DDTHH:MM:SSZ",
     "files": <文件数>,
     "loc": <文档行数>,
     "experiments": <实验数>,
     "todos": <TODO数>
   }
   ```
   统计方式（Agent 用工具完成，不依赖 bash）：
   - files：用 Glob 扫描文档文件（排除 .git/dist）
   - loc：用 Read 读取每个文档文件，按行数累加
   - experiments：扫描 `loops/specs/*/state.yaml` 数量
   - todos：用 Grep 搜索 `TODO|FIXME|XXX` 注释

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

   **步骤 4.3：可选脚本兜底**
   如果当前环境 bash 可用（如 macOS/Linux/Git Bash），可执行：
   ```bash
   bash .harness/scripts/archive-progress.sh
   ```
   脚本逻辑与上述步骤一致，作为可选兜底。**Windows 或无 bash 环境下，必须用步骤 4.1-4.2 的工具操作。**

5. **提取重要发现**（如有）
   本次会话如果有值得长期沉淀的知识（实验结论、增长模式、踩坑），写入 `memory/knowledge-base.md`
   增长框架特有：实验结论必须写入知识库，避免重复实验

6. **产出交接文档**（可选，满足条件时执行）
   如果本次会话完成了**可反馈给 harness-pm** 的增长工作（实验结论、增长数据、用户洞察），按 `docs/handoff/growth-to-pm-template.md` 模板产出 `docs/handoff/growth-to-pm.md`：

   **触发条件**（任一满足）：
   - 本次会话有实验状态从 `in_progress` 变为 `done`，且结论有效/无效明确
   - 用户明确要求"准备交接给 pm/产品"
   - 发现重要的用户行为洞察、增长瓶颈、市场信号

   **产出内容**（按模板填写）：
   - 阶段总结：本次完成了什么增长工作
   - 产出物清单：实验结论、增长数据、用户洞察等（pm 决策需要知道的）
   - 验收标准：从 spec.md 复制已验证的假设
   - 建议下一步：pm 可以做什么（如"实验证明用户偏好 X，建议产品方向调整"）

   **注意**：
   - 如本次会话无可反馈产出（纯内容生产、纯 SEO 优化无结论），跳过本步骤
   - 如 `growth-to-pm.md` 已存在，追加本次结论，不覆盖历史
   - 文件名固定为 `growth-to-pm.md`，不要按日期拆分（pm 只看最新状态）

## 禁止事项
- 不更新 progress.md 就结束（下次会话失忆）
- 不执行归档步骤 4（progress.md 无限膨胀）
- 不写 baseline.json（entropy-check 无法计算增长率）
- 在无 bash 环境下强行执行 .sh 脚本（会卡死）
- 实验结论不写入 knowledge-base.md（导致重复实验）

## 与 LOOP 的关系
本 skill 在 LOOP 之后执行，是会话的收尾。
session-start → ... → LOOP → ... → session-end

## 证据要求
session-end 完成后，progress.md 必须包含：
- 本次会话做了什么
- 下次会话需要继续什么
- 归档操作的实际结果（如"progress.md 从 250 行切到 45 行，归档到 archives/2026-06-20-1900-progress.md"，不能只写"已归档"）
- 如执行了步骤 6，记录"产出 growth-to-pm.md，包含 X 个反馈项"
- 如有实验结论，记录"结论写入 knowledge-base.md"
