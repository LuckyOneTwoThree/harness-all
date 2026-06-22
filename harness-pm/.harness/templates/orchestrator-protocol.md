# orchestrator-protocol.md

> 用途：orchestrator 编排协议规范，定义 orchestrator 如何编排 pipeline skill。
>
> 所有 orchestrator（type: "orchestrator" 的 skill）必须遵循本协议。orchestrator 只负责**编排**，不负责**执行**——具体工作由 pipeline skill 完成。

## 1. orchestrator 职责定义

orchestrator 是**编排者**，不是**执行者**。

| 职责 | 说明 |
|------|------|
| 调度 pipeline skill | 按 stage 顺序/并行/条件调用子 skill |
| 传递上下文 | 将上游 skill 的输出作为下游 skill 的输入 |
| 把关质量门（gate） | 每个 stage 结束时检查 gate 条件，未通过则阻断或降级 |
| 生成阶段总结 | post_pipeline 阶段产出 `output/phase-reports/<orchestrator-name>.json` |
| 衔接下游 | 声明 primary/alternatives 下游 orchestrator |

**禁止事项**：
- orchestrator 不直接产出业务文档（docs/），文档由 pipeline skill 产出
- orchestrator 不替代 pipeline skill 做具体分析工作
- orchestrator 不跳过 gate 检查直接进入下一 stage

## 2. 编排模式

orchestrator 支持三种编排模式，在 Pipeline 的 `stages` 中通过 `depends_on` 声明：

### 2.1 顺序编排（Sequential）

stage 之间有依赖关系，前一个完成后才执行下一个。

```yaml
stages:
  - id: phase-1
    name: "步骤一"
    depends_on: []
    skills: [skill-a]
  - id: phase-2
    name: "步骤二"
    depends_on: [phase-1]
    skills: [skill-b]
```

### 2.2 并行编排（Parallel）

无依赖关系的 stage 可并行执行，用于加速采集类任务。

```yaml
stages:
  - id: phase-1
    name: "并行采集"
    depends_on: []
    skills:
      - skill-a
      - skill-b
    gate:
      condition: "skill-a.json + skill-b.json 均已生成且验证通过"
      fail_action: "失败子 skill 使用降级方案继续，不阻塞另一子 skill"
```

### 2.3 条件编排（Conditional）

根据上游结果或上下文决定是否执行某 stage，通过 `gate.condition` 控制。

```yaml
stages:
  - id: phase-2
    name: "条件步骤"
    depends_on: [phase-1]
    skills: [skill-c]
    gate:
      condition: "phase-1 产出包含 X 字段时执行"
      fail_action: "跳过本阶段，标注'条件未满足'"
```

## 3. 与 pipeline skill 的接口

orchestrator 与 pipeline skill 之间通过**输入输出契约**协作。

### 3.1 输入契约

orchestrator 向 pipeline skill 传递：
- 用户提供的基础参数（category_keywords、target_market 等）
- 上游 skill 的产出引用（`<skill-name> → <output-file>.json`）
- 上下文变量（如 segment_data、retention_data）

### 3.2 输出契约

pipeline skill 必须产出：
- **业务文档**：写入 `docs/<module>/<file>.md` 的指定章节
- **机器数据**（可选）：写入 JSON 供下游 skill 消费

### 3.3 调用规范

每个 pipeline skill 的调用块应包含：

```
Skill: <skill-name>
输入:
  <param>: <来源>
输出: docs/<module>/<file>.md（"<章节>"）
验证: <验证条件>
模式: 🤖 / 🤖→👤
```

- `模式: 🤖` 表示 AI 自动执行
- `模式: 🤖→👤` 表示 AI 执行后需人类审批

## 4. 状态管理

orchestrator 通过以下机制在 stage 之间传递上下文：

| 传递方式 | 用途 | 示例 |
|---------|------|------|
| 文件引用 | 跨 stage 传递结构化产出 | `tam_som_ref: docs/discovery/market-analysis.md` |
| JSON 数据 | 跨 skill 传递机器消费数据 | `output/metrics/<id>.json` |
| 上下文变量 | 同一 stage 内共享参数 | `user_segment_data` |
| memory/progress.md | 跨 session 持久化进度 | orchestrator 完成状态 |

**上下文传递规则**：
- 上游 skill 的输出路径作为下游 skill 的输入参数显式声明
- orchestrator 不修改 pipeline skill 的产出文件，只引用
- 跨 session 状态写入 `memory/progress.md`，由 session-start/session-end 管理

## 5. 错误处理

pipeline skill 失败时，orchestrator 按以下策略降级：

| 异常类型 | 处理策略 |
|---------|---------|
| 单个 skill 失败（并行 stage） | 不阻塞同 stage 其他 skill，失败 skill 标注"降级执行" |
| 单个 skill 失败（顺序 stage） | 尝试降级方案继续；无法降级则阻断该 stage，请求人类介入 |
| gate 条件未通过 | 按 `fail_action` 处理：补充输入 / 检查上游 / 降级执行 |
| 上游数据全部缺失 | 降级为轻量版流程，基于 AI 知识库生成，标注"推断值" |
| 阶段总结生成失败 | 基于已完成的 skill 输出生成部分总结，缺失项标注"数据缺失" |
| 迭代超限 | 阻断自动传递，请求人类介入（详见 LOOP.md） |

**降级原则**：
- 降级产出必须标注"降级执行"或"推断值"
- 降级产出需人类确认后才可传递给下游
- 置信度 < 0.3 的降级产出阻断自动传递

## 6. 编排协议示例

以下是一个完整的 orchestrator Pipeline 示例：

```yaml
pipeline: example-orchestrator
version: 1.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/example-orchestrator.json

stages:
  # 阶段1：并行采集（无依赖）
  - id: phase-1
    name: "并行采集"
    depends_on: []
    skills:
      - skill-a
      - skill-b
    gate:
      condition: "skill-a.json + skill-b.json 均已生成且验证通过"
      fail_action: "失败子 skill 使用降级方案继续，不阻塞另一子 skill"

  # 阶段2：整合分析（依赖阶段1）
  - id: phase-2
    name: "整合分析"
    depends_on: [phase-1]
    skills: [skill-c]
    gate:
      condition: "执行摘要包含3条核心发现，Feature Matrix 已更新"
      fail_action: "检查上游数据是否完整或补充输入参数"

  # 阶段3：人类审批（依赖阶段2）
  - id: phase-3
    name: "人类审批"
    depends_on: [phase-2]
    skills: [skill-d]
    gate:
      condition: "人类审批通过，决策记录已写入 approval.json"
      fail_action: "重新提交修订方案，迭代上限3次"
```

### 阶段总结结构（post_pipeline 产出）

`output/phase-reports/<orchestrator-name>.json` 必须包含以下6项结构（均不可为空）：

1. **执行概览**：编排器名称与版本、执行时间、子 skill 执行状态（成功/失败/降级）
2. **关键发现**：每个子 skill 的核心输出摘要（1-3条）、跨子 skill 的交叉洞察
3. **决策记录**：人类决策点及决策结果、AI 自动决策及依据
4. **产出清单**：所有输出文件路径及内容摘要、产出质量评估（是否通过验证）
5. **风险与待办**：未通过验证的项、降级执行的项、建议后续跟进的事项
6. **下游衔接**：本编排器产出可被哪些下游编排器消费、推荐的下一步编排器

### 下游衔接声明

```yaml
下游衔接:
  primary: <next-orchestrator>（<触发条件>）
  alternatives:
    - target: <alternative-orchestrator>
      reason: <选择原因>
      condition: <触发条件>
  special_cases:
    - target: <skill-name>
      reason: <选择原因>
      condition: <触发条件>
```
