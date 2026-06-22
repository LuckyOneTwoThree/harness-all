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
  - docs/handoff/ops-to-pm-template.md
writes:
  - memory/progress.md
  - memory/baseline.json
  - memory/archives/
  - FEATURES.md
  - docs/handoff/ops-to-pm.md
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

2. **批量更新 FEATURES.md**
   扫描 `.harness/loops/specs/*/state.yaml`：
   - status 为 `done` 的任务 → FEATURES.md 对应任务状态改 `done`
   - status 为 `running` 的任务 → 状态保持 `in_progress`
   - 记录最后更新日期

3. **写入 baseline.json**（供 entropy-check 用）
   统计当前项目指标写入 `.harness/memory/baseline.json`：
   ```json
   {
     "timestamp": "YYYY-MM-DDTHH:MM:SSZ",
     "files": <文件数>,
     "loc": <代码行数>,
     "deps": <依赖数>,
     "todos": <TODO数>
   }
   ```
   统计方式（Agent 用工具完成，不依赖 bash）：
   - files：用 Glob 扫描 IaC 文件（.tf/.yml/.yaml）+ 脚本文件
   - loc：用 Read 读取每个文件，按行数累加
   - deps：读 Terraform/K8s 依赖清单
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

5. **提取重要发现**（如有）
   本次会话如果有值得长期沉淀的知识（故障结论、运维模式、踩坑），写入 `memory/knowledge-base.md`

6. **产出交接文档**（可选，满足条件时执行）
   如果本次会话完成了**可反馈给 PM 的运维任务**（如部署成功、SLA 报告、故障复盘），按 `docs/handoff/ops-to-pm-template.md` 模板产出 `docs/handoff/ops-to-pm.md`：

   **触发条件**（任一满足）：
   - 本次会话有任务状态从 `running` 变为 `done`（部署成功）
   - 本次会话处理了线上故障（需通报 PM）
   - 用户明确要求"准备 SLA 报告给 PM"
   - 本次会话发现生产环境隐患（需 PM 规划修复）

   **产出内容**（按 ops-to-pm-template.md 填写）：
   - 大盘可用性摘要（SLA、资源使用率与成本）
   - 事故与故障通报（如有）
   - 运维对业务的建议（如：需规划数据冷热分离、需容灾重构）

   **注意**：
   - 如本次会话无对外可交付产出（纯监控配置、纯 IaC 维护），跳过本步骤
   - 如 `ops-to-pm.md` 已存在，追加本次内容，不覆盖历史
   - 文件名固定为 `ops-to-pm.md`，不要按日期拆分（下游只看最新状态）

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
- 如执行了步骤 6，记录"产出 ops-to-pm.md，包含 X 项反馈"
