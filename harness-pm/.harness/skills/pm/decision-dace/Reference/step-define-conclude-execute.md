<!-- 从 SKILL.md 提取的参考材料，按需查阅 -->

# Step 1 / Step 3 / Step 4 示例

## Step 1: Define（定义）示例

自动建立OKR追踪体系：

```yaml
define:
  status: "automated"
  trigger: "OKR更新或季度开始"

  output:
    current_cycle: "2024_Q1"
    cycle_id: "dace_2024_Q1"

    objectives:
      - id: "obj_1"
        text: "提升用户活跃度"
        owner: "product_team"

        key_results:
          - id: "kr_1_1"
            text: "DAU达到1200万"
            metric: "dau"
            baseline: 10500000
            target: 12000000
            current: 10800000
            progress: 30

          - id: "kr_1_2"
            text: "D7留存率达到30%"
            metric: "d7_retention"
            baseline: 0.25
            target: 0.30
            current: 0.285
            progress: 70

      - id: "obj_2"
        text: "提升商业化收入"
        owner: "biz_team"

        key_results:
          - id: "kr_2_1"
            text: "月收入达到5000万"
            metric: "monthly_revenue"
            baseline: 42000000
            target: 50000000
            current: 45500000
            progress: 43.75

    success_metrics:
      primary: ["dau", "d7_retention", "monthly_revenue"]
      supporting: ["dau_conversion", "arpu", "paying_users"]
      guardrail: ["user_satisfaction", "app_crash_rate"]
```

## Step 3: Conclude（决策选项）示例

AI生成决策建议，人类做出最终决定：

```yaml
conclude:
  status: "human_decision"
  human_participation: true

  automated_analysis:
    options_considered: 3

    recommendations:
      - priority: 1
        action: "全量发布简化注册流程"
        rationale: "实验数据显示转化提升8.2%，护栏指标安全"
        expected_outcome: "新用户注册转化+8.2%"
        risk_level: "low"

      - priority: 2
        action: "优化加购环节流程"
        rationale: "漏斗分析显示加购是关键流失点"
        expected_outcome: "整体转化提升潜力+15%"
        risk_level: "medium"

      - priority: 3
        action: "针对Android做留存优化"
        rationale: "Android留存低于iOS，需针对性优化"
        expected_outcome: "Android D7留存+5%"
        risk_level: "medium"

  human_decision_required:
    decision_type: "strategy_confirmation"
    decision_maker: "product_director"
    deadline: "2024-01-20"

    context_provided:
      - "实验完整分析报告"
      - "风险评估"
      - "资源配置需求"
      - "时间规划"
```

## Step 4: Execute（执行追踪）示例

追踪执行效果：

```yaml
execute:
  status: "tracking"
  tracking_mode: "automated"

  approved_actions:
    - action_id: "act_001"
      action: "全量发布简化注册流程"
      approved_by: "product_director"
      approved_at: "2024-01-18"

      implementation:
        planned_date: "2024-01-22"
        rollout_plan: "100% traffic"

      tracking:
        metrics:
          - name: "registration_completion_rate"
            baseline: 0.35
            target: 0.38
            current: 0.381

        status: "released"
        release_date: "2024-01-22"

        monitoring:
          daily_check: true
          alert_threshold: -0.02

  results_tracked:
    - action_id: "act_001"
      days_since_release: 3

      results:
        metric: "registration_completion_rate"
        baseline: 0.35
        current: 0.378
        change: +8.0%
        status: "on_track"

      guardrail_status:
        - metric: "d7_retention"
          baseline: 0.42
          current: 0.419
          change: -0.2%
          status: "safe"

      verdict: "功能表现符合预期，继续监控"
```
