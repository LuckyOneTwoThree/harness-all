<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# 输出 Schema / 洞察输出示例 / 输出校验规则

## 输出Schema

```json
{
  "type": "object",
  "required": ["dace_status", "okr_tracking", "insight_id", "source", "narrative", "action_options"],
  "properties": {
    "dace_status": {"type": "object", "description": "DACE循环状态，包含当前阶段和进度"},
    "okr_tracking": {"type": "object", "description": "OKR追踪数据，包含目标、关键结果和达成率"},
    "action_log": {"type": "array", "description": "行动日志，包含已执行决策和待执行项"},
    "cycle_report": {"type": "object", "description": "周期报告，包含分析结论和执行建议"},
    "insight_id": {"type": "string", "description": "洞察唯一标识"},
    "created_at": {"type": "string", "description": "创建时间"},
    "source": {"type": "object", "description": "洞察来源，包含类型和置信度"},
    "narrative": {"type": "string", "description": "故事化叙述，包含背景、发现、影响和建议"},
    "action_options": {"type": "array", "description": "决策选项列表，包含预期效果、风险和置信度"},
    "decision_boundary": {"type": "object", "description": "决策边界，包含类型和自动执行资格"},
    "decision_maker": {"type": "string", "description": "决策人角色"},
    "deadline": {"type": "string", "description": "决策截止时间"}
  }
}
```

## 洞察输出示例

```yaml
data_insight:
  insight_id: "insight_20240115_001"
  created_at: "2024-01-15T14:30:00Z"

  source:
    type: "experiment_result"
    experiment_id: "exp_20240115_simplified_register"
    confidence: "high"

  narrative: |
    ## 简化注册流程实验洞察

    ### 背景
    产品团队在2024年1月15日启动了简化注册流程实验，
    将5步注册流程缩短为3步。
    实验持续14天，共24830名用户参与。

    ### 发现
    实验组（简化流程）的注册转化率达到38.1%，
    相比对照组（标准流程）的35.2%提升了8.2个百分点。
    这个结论有99.9%的可信度（p=0.001）。

    更重要的是，这个提升是稳定的——
    从实验第1天到第14天，效果没有衰减，
    说明这不是用户的新奇效应，而是真实的体验改善。

    ### 影响
    如果我们全量发布这个功能：
    - 每月预计新增注册用户 **+12%**（约3.6万用户/月）
    - 按照当前转化漏斗，预计带来 **+8%** 的DAU增长

    ### 风险
    我们检查了所有护栏指标：
    - 用户7日留存：42.0% → 41.8%（下降0.2%，可接受）
    - DAU：保持稳定
    - 崩溃率：无变化

    所有护栏指标都在安全范围内。

    ### 建议
    **建议全量发布简化注册流程。**
    这是低风险高回报的改动，数据支持立即执行。

  action_options:
    - option: "全量发布简化注册流程"
      option_id: "opt_001"
      expected_effect:
        primary: "注册转化率 +8.2%"
        secondary: ["DAU +2%", "新用户 +12%"]
      risk: "low"
      confidence: "high"

    - option: "分平台发布（先iOS）"
      option_id: "opt_002"
      expected_effect:
        primary: "iOS转化 +5.2%"
        secondary: ["Android待验证"]
      risk: "medium"
      confidence: "medium"

    - option: "继续实验2周"
      option_id: "opt_003"
      expected_effect:
        primary: "更多数据验证"
        secondary: ["降低不确定性"]
      risk: "low"
      confidence: "low"

  decision_boundary:
    type: "data_decision"
    description: |
      数据明确支持"全量发布"选项：
      - 统计显著（p=0.001）
      - 实际意义显著（+8.2%）
      - 护栏指标全部安全
      - 无新奇效应

    auto_execute_eligible: true

    automation_conditions:
      - condition: "技术团队确认可发布"
        required: true
      - condition: "监控告警已配置"
        required: true
      - condition: "回滚方案已准备"
        required: true

    override_conditions:
      - condition: "业务策略变更"
        action: "暂停自动执行，等待人工确认"

  recommended_action:
    action: "全量发布简化注册流程"
    priority: "high"
    reason: "数据支持充分，风险低，收益显著"

    next_steps:
      - step: 1
        task: "技术评审"
        owner: "engineering"
        deadline: "2024-01-17"
      - step: 2
        task: "配置监控告警"
        owner: "data_team"
        deadline: "2024-01-18"
      - step: 3
        task: "发布部署"
        owner: "engineering"
        deadline: "2024-01-19"
      - step: 4
        task: "发布后监控"
        owner: "data_team"
        duration: "2 weeks"
```

## 输出文件结构

```
docs/metrics/decision-report.md（"DACE决策"章节）
├── dace_status.json
├── okr_tracking.json
├── action_log.json
├── dace_cycle_report.md
├── decision_insight.json
└── insight_library.json
```

## 输出校验规则

| 字段路径 | 类型 | 必填 | 说明 |
|----------|------|------|------|
| dace_status | object | 是 | DACE循环状态 |
| dace_status.cycle_id | string | 是 | 循环ID |
| dace_status.current_phase | string | 是 | 当前阶段，枚举值：Define/Analyze/Conclude/Execute |
| dace_status.phase_history | array | 是 | 阶段历史 |
| okr_tracking | object | 是 | OKR追踪数据 |
| okr_tracking.objectives | array | 是 | 目标列表 |
| okr_tracking.objectives[].id | string | 是 | 目标ID |
| okr_tracking.objectives[].progress | number | 是 | 进度百分比 |
| okr_tracking.objectives[].status | string | 是 | 状态，枚举值：on_track/at_risk/behind |
| action_log | array | 是 | 行动日志 |
| action_log[].action_id | string | 是 | 行动ID |
| action_log[].action | string | 是 | 行动描述 |
| action_log[].status | string | 是 | 状态，枚举值：approved/in_progress/completed |
| data_insight | object | 否 | 数据洞察根对象（Analyze阶段产出） |
| data_insight.insight_id | string | 是 | 洞察唯一标识 |
| data_insight.created_at | string | 是 | 创建时间 |
| data_insight.source | object | 是 | 洞察来源 |
| data_insight.source.type | string | 是 | 来源类型，枚举值：experiment_result/anomaly/funnel_analysis/retention_analysis |
| data_insight.source.confidence | string | 是 | 来源置信度 |
| data_insight.narrative | string | 是 | 故事化叙述 |
| data_insight.action_options | array | 是 | 决策选项列表，至少2个 |
| data_insight.action_options[].option_id | string | 是 | 选项ID |
| data_insight.action_options[].expected_effect | object | 是 | 预期效果 |
| data_insight.action_options[].risk | string | 是 | 风险等级 |
| data_insight.action_options[].confidence | string | 是 | 置信度 |
| data_insight.decision_boundary | object | 是 | 决策边界 |
| data_insight.decision_boundary.type | string | 是 | 边界类型，枚举值：data_decision/data_reference/human_decision |
| data_insight.decision_boundary.auto_execute_eligible | boolean | 是 | 是否可自动执行 |
| data_insight.recommended_action | object | 是 | 推荐行动 |
| data_insight.recommended_action.action | string | 是 | 行动描述 |
| data_insight.recommended_action.priority | string | 是 | 优先级 |
