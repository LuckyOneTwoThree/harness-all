---
name: prd-orchestrator
description: 当需要生成PRD或评估PRD变更影响时使用。产品需求指挥官，调度design-prd/change-impact-analysis。负责PRD生成与PRD变更影响评估。视觉/交互/组件/原型等设计产出已迁移至harness-design，本编排器仅负责PM合规的产品需求部分。关键词：产品设计、PRD、写PRD、产品文档、需求文档、变更影响分析。
metadata:
  module: "产品构思与设计"
  sub-module: "产品需求"
  type: "orchestrator"
  version: "11.0"
  domain_tags: ["通用"]
  trigger_examples:
    - "帮我写PRD"
    - "生成产品需求文档"
    - "PRD变更了，分析一下影响"
    - "评估这个需求变更的影响范围"
---

# 产品需求指挥官

## 核心原则

1. **上游质量决定下游效率**——PRD质量门禁不可绕过，垃圾进垃圾出
2. **PRD 是唯一契约**——PM 与下游（design/solo）通过 PRD + AC-xxx 编号协作，不直接产出设计文件
3. **变更必须评估影响**——PRD 变更时触发 change-impact-analysis，评估对下游设计/工程的影响

## 职责边界

本编排器**仅负责 PM 合规的产品需求部分**：
- ✅ PRD 生成（design-prd）
- ✅ PRD 变更影响分析（change-impact-analysis）
- ✅ 通过 `docs/handoff/pm-to-design.md` 和 `docs/handoff/pm-to-solo.md` 与下游协作

本编排器**不负责**以下内容（已迁移至 harness-design）：
- ❌ 信息架构（IA）→ harness-design 的 wireframe + design-brief
- ❌ 用户流程 → harness-design 的 interaction-design
- ❌ 原型设计 → harness-design 的 wireframe + visual-design
- ❌ 交互规范 → harness-design 的 interaction-design
- ❌ 设计交接 → harness-design 的 design-handoff-spec

## 异常处理

| 异常类型 | 处理策略 |
|----------|----------|
| 子Skill输出文件缺失 | 阻塞当前阶段，输出缺失项清单，提示人类补充上游输入 |
| 子Skill质量检查未通过 | 阻塞进入下一阶段，输出未通过项详情，提示人类确认是否修复或接受风险 |
| 上下文接近上限 | 优先保留当前阶段内容，将已完成阶段的输出摘要为关键结论写入文件 |
| 人类决策超时未响应 | 暂停编排流程，保留当前状态，等待人类决策后继续 |
| 上游输入数据格式异常 | 尝试兼容解析，解析失败则降级为用户提供描述，标注"数据格式异常" |
| 阶段总结生成失败 | 基于已完成的子Skill输出生成部分总结，缺失项标注"数据缺失"，不阻塞编排完成 |

## 编排协议

遵循 [orchestrator-protocol.md](../../../../templates/orchestrator-protocol.md) 编排协议。

## Pipeline

```yaml
pipeline: prd-orchestrator
version: 11.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/prd-orchestrator.json

stages:
  - id: phase-0
    name: "UI反馈处理"
    depends_on: []
    skills: []
    trigger: 用户提供（UI/UX反馈） 存在时
    gate:
      condition: "反馈建议已评估，接受/拒绝已决定"
      fail_action: "标注未处理反馈，不阻塞主流程"

  - id: phase-1
    name: "产品需求文档"
    depends_on: [phase-0]
    skills: [design-prd]
    gate:
      condition: "PRD 4道质量门禁全部通过"
      fail_action: "门禁1或2失败阻塞流程，输出缺失项清单"

  - id: phase-2
    name: "变更影响分析"
    depends_on: [phase-1]
    skills: [change-impact-analysis]
    trigger: PRD变更时触发
    gate:
      condition: "影响矩阵覆盖所有下游产出，重做清单可执行"
      fail_action: "补充缺失的下游影响项"
```

## 阶段执行计划

#### 处理 UI 反馈（phase-0，条件执行）

```
触发条件: 用户提供（UI/UX反馈） 存在
动作: 评估UI→PM反馈建议
输入:
  design_feedback: 用户提供（UI/UX反馈）
处理流程:
  1. 读取 design_feedback.json
  2. 按 target_artifact 分组 suggestions
  3. 对每个 suggestion 评估：
     - 接受：标记为 accepted，纳入后续阶段修改范围
     - 拒绝：标记为 rejected，记录拒绝理由
  4. ⏸ 人类确认反馈处理结果
  5. 对 accepted 的 suggestions：
     - 若 target_artifact 为 prd.json：在 phase-1 中纳入修改范围
  6. 处理完成后删除 design_feedback.json，避免重复消费
输出: 反馈处理结果（accepted/rejected 清单）
验证: 反馈建议已逐项评估，处理结果已人类确认
模式: 🤖→👤
```

#### 调用 design-prd

```
Skill: design-prd
输入:
  ideation_workshop: docs/product/PRD.md（"创意方案"章节）
  strategic_output: 用户提供
  requirement_context: 用户提供（product_name必填）
输出: docs/product/PRD.md
验证: PRD 4道质量门禁全部通过
模式: 🤖→👤
```

#### 调用 change-impact-analysis

```
Skill: change-impact-analysis
输入:
  prd_change: 用户提供（PRD变更内容）
  current_prd: docs/product/PRD.md
输出: docs/product/PRD.md（"变更影响分析"章节）
验证: 影响矩阵覆盖所有下游产出；重做清单可执行
模式: 🤖→👤
```

> 注：变更影响分析原先评估对 IA/userflow/prototype/interaction-spec 等设计产出的影响，
> 这些产出已迁移至 harness-design。本阶段现在仅评估对 PRD 自身和下游交接契约的影响，
> 对设计产出的影响评估由 harness-design 负责，通过 docs/handoff/pm-to-design.md 通知。

### 阶段总结（post_pipeline）

所有子Skill执行完成后，必须生成阶段总结文档，写入 `output/phase-reports/prd-orchestrator.json`，包含以下6项结构（均不可为空）：

1. **执行概览**：编排器名称与版本、执行时间、子Skill执行状态（成功/失败/降级）
2. **关键发现**：每个子Skill的核心输出摘要（1-3条）、跨子Skill的交叉洞察
3. **决策记录**：人类决策点及决策结果、AI自动决策及依据
4. **产出清单**：所有输出文件路径及内容摘要、产出质量评估（是否通过验证）
5. **风险与待办**：未通过验证的项、降级执行的项、建议后续跟进的事项
6. **下游衔接**：本编排器产出可被哪些下游编排器消费、推荐的下一步编排器

| 参数 | 值 |
|------|-----|
| 子Skill输出路径 | docs/product/PRD.md |
| 总结输出路径 | output/phase-reports/prd-orchestrator.json |
| 审批记录路径 | output/approvals/{orchestrator-name}/{stage-id}.approval.json |

下游衔接:
  primary: metrics-orchestrator（PRD完成，为功能点设计指标体系和埋点方案）
  alternatives:
    - target: validation-orchestrator
      reason: PRD中存在高风险假设需验证
      condition: PRD中标记为高风险的功能点占比>30%时
  cross_framework:
    - target: harness-design（通过 docs/handoff/pm-to-design.md 交接）
      reason: PRD 确认后，harness-design 消费 PRD 进行视觉/交互/组件设计
      condition: PRD 通过质量门禁后自动触发交接文档生成
    - target: harness-solo（通过 docs/handoff/pm-to-solo.md 交接）
      reason: PRD 确认后，harness-solo 消费 PRD + AC-xxx 进行工程实现
      condition: PRD 通过质量门禁后自动触发交接文档生成

## 阶段卡口

| 卡口 | 条件 | 未通过处理 |
|------|------|------------|
| PRD生成完成 | design-prd输出文件已生成且非空 | 门禁1或2失败阻塞流程，输出缺失项清单 |
| 变更影响分析完成 | change-impact-analysis输出文件已生成且非空 | 补充缺失的下游影响项 |
| 阶段总结已生成 | output/phase-reports/prd-orchestrator.json 已生成且6项结构均非空 | 补充缺失结构项后重新生成 |

## 人类决策点

| 决策点 | 触发条件 | 决策内容 |
|--------|----------|----------|
| UI反馈处理确认 | phase-0，design_feedback.json存在时 | 确认接受/拒绝UI侧的反馈建议 |
| PRD层级确认 | AI自动分级置信度<0.7 | 确认PRD层级（L/S/X） |
