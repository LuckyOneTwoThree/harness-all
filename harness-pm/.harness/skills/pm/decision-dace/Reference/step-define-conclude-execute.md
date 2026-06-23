<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 1 / Step 3 / Step 4 Examples

## Step 1: Define Example

Automatically establish the OKR tracking system:

```yaml
define:
  status: "automated"
  trigger: "OKR update or quarter start"

  output:
    current_cycle: "2024_Q1"
    cycle_id: "dace_2024_Q1"

    objectives:
      - id: "obj_1"
        text: "Improve user engagement"
        owner: "product_team"

        key_results:
          - id: "kr_1_1"
            text: "DAU reaches 12 million"
            metric: "dau"
            baseline: 10500000
            target: 12000000
            current: 10800000
            progress: 30

          - id: "kr_1_2"
            text: "D7 retention rate reaches 30%"
            metric: "d7_retention"
            baseline: 0.25
            target: 0.30
            current: 0.285
            progress: 70

      - id: "obj_2"
        text: "Improve commercial revenue"
        owner: "biz_team"

        key_results:
          - id: "kr_2_1"
            text: "Monthly revenue reaches 50 million"
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

## Step 3: Conclude (Decision Options) Example

AI generates decision recommendations, humans make the final decision:

```yaml
conclude:
  status: "human_decision"
  human_participation: true

  automated_analysis:
    options_considered: 3

    recommendations:
      - priority: 1
        action: "Full release of simplified registration flow"
        rationale: "Experimental data shows 8.2% conversion improvement, guardrail metrics safe"
        expected_outcome: "New user registration conversion +8.2%"
        risk_level: "low"

      - priority: 2
        action: "Optimize add-to-cart flow"
        rationale: "Funnel analysis shows add-to-cart is a key drop-off point"
        expected_outcome: "Overall conversion improvement potential +15%"
        risk_level: "medium"

      - priority: 3
        action: "Retention optimization for Android"
        rationale: "Android retention is lower than iOS, needs targeted optimization"
        expected_outcome: "Android D7 retention +5%"
        risk_level: "medium"

  human_decision_required:
    decision_type: "strategy_confirmation"
    decision_maker: "product_director"
    deadline: "2024-01-20"

    context_provided:
      - "Complete experiment analysis report"
      - "Risk assessment"
      - "Resource allocation requirements"
      - "Timeline planning"
```

## Step 4: Execute (Execution Tracking) Example

Track execution effectiveness:

```yaml
execute:
  status: "tracking"
  tracking_mode: "automated"

  approved_actions:
    - action_id: "act_001"
      action: "Full release of simplified registration flow"
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

      verdict: "Feature performance meets expectations, continue monitoring"
```
