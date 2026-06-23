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
  - docs/handoff/solo-to-growth-template.md
  - docs/handoff/solo-to-ops-template.md
writes:
  - memory/progress.md
  - memory/baseline.json
  - memory/archives/
  - FEATURES.md
  - docs/handoff/solo-to-growth.md
  - docs/handoff/solo-to-ops.md
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
   - status 为 `done` 的功能 → FEATURES.md 对应功能状态改 `done`
   - status 为 `running` 的功能 → 状态保持 `in_progress`
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
   - files：用 Glob 扫描源文件（排除 node_modules/.git/dist）
   - loc：用 Read 读取每个源文件，按行数累加
   - deps：读 package.json/Cargo.toml/go.mod 等依赖清单
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
   本次会话如果有值得长期沉淀的知识（技术决策、踩坑、模式），写入 `memory/knowledge-base.md`

6. **产出交接文档**（可选，满足条件时执行）

   **写权限单向隔离（不可协商）**：交接文档只有产出方可以写入。`solo-to-growth.md` 只有 Solo 能写，`solo-to-ops.md` 只有 Solo 能写。消费方只能读取，禁止修改上游交接文档。如需反馈，通过 `AskUserQuestion` 让用户转达，或写入自己的出站交接文档。

   如果本次会话完成了**可发布/可交付给下游**的功能（如 harness-growth 需要的新 API、新页面），按 `docs/handoff/solo-to-growth-template.md` 模板产出 `docs/handoff/solo-to-growth.md`：

   **触发条件**（任一满足）：
   - 本次会话有功能状态从 `in_progress` 变为 `done`
   - 用户明确要求"准备交接给增长/运营"
   - 完成的功能涉及对外 API、用户可见页面、可埋点的事件

   **产出内容**（按 solo-to-growth-template.md 填写）：
   - 已实现功能清单（API 端点 / 页面路径 / 事件名）
   - 验收标准（AC-xxx + DAC-xxx，已通过）
   - 性能指标（LCP / INP / API 响应 / 测试覆盖率）
   - 埋点事件清单（事件名 / 触发时机 / 参数 / 关联 AC）
   - 已知问题与限制

   **注意**：
   - 如本次会话无对外可交付产出（纯重构、纯 Bug 修复），跳过本步骤
   - 如 `solo-to-growth.md` 已存在，追加本次交付内容，不覆盖历史
   - 文件名固定为 `solo-to-growth.md`，不要按日期拆分（下游只看最新状态）

7. **产出运维交接文档**（可选，满足条件时执行）
   如果本次会话完成了**代码合并到主干并需要发布上线**的功能，按 `docs/handoff/solo-to-ops-template.md` 模板产出 `docs/handoff/solo-to-ops.md`：

   **触发条件**（任一满足）：
   - 本次会话有功能已合并到主干（main/master）且计划发布上线
   - 用户明确要求"准备发布"或"准备交接给运维"
   - 本次变更涉及环境变量、数据库 Migration、部署配置变更

   **产出内容**（按 solo-to-ops-template.md 填写）：
   - 交付物版本（镜像 Tag 或代码 Commit Hash）
   - 环境变量清单（本次部署需增/删/改的配置项）
   - 数据库脚本（是否包含 Migration 及其执行顺序）
   - 冒烟测试（验证部署成功的检查点）
   - 回滚方案（出错时的降级或代码回滚措施）

   **注意**：
   - 如本次会话无发布上线计划（纯本地开发、未合并主干），跳过本步骤
   - 如 `solo-to-ops.md` 已存在，追加本次交付内容，不覆盖历史
   - 文件名固定为 `solo-to-ops.md`，不要按日期拆分（下游只看最新状态）

   **AC 格式校验**（交接文档必须通过）
   对步骤 6/7 产出的交接文档执行验收标准格式校验：
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
- 归档操作的实际结果（如"progress.md 从 250 行切到 45 行，归档到 archives/2026-06-20-1900-progress.md"，不能只写"已归档"）
- 如执行了步骤 6，记录"产出 solo-to-growth.md，包含 X 个交付项"
- 如执行了步骤 7，记录"产出 solo-to-ops.md，包含交付物版本 / 环境变量 / 数据库脚本 / 冒烟测试 / 回滚方案"
