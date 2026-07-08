<!-- Reference material extracted from SKILL.md, consult as needed -->
<!-- Merged from step-analyze.md + step-define-conclude-execute.md, organized by step number (Step 1, 2, 3, 4) -->

# Steps Reference

## Source: step-define-conclude-execute.md

### Step 1: Define Example

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

## Source: step-analyze.md

### Step 2: Analyze (Insight Generation) Examples

#### 2.1 Data Collection and Analysis Example

Automatically collect and analyze data:

```yaml
analyze:
  status: "automated"
  execution_mode: "continuous"

  data_sources:
    - type: "metrics"
      name: "daily_metrics"
      frequency: "hourly"

    - type: "experiments"
      name: "ab_test_results"
      frequency: "on_completion"

    - type: "events"
      name: "product_events"
      frequency: "realtime"

  analyses_performed:
    - type: "anomaly_detection"
      findings:
        - metric: "dau_conversion"
          status: "warning"
          change: -3.2%
          reason: "Registration flow change impact"

    - type: "experiment_summary"
      findings:
        - experiment: "Simplified Registration Experiment"
          result: "positive"
          lift: +8.2%

    - type: "funnel_analysis"
      findings:
        - funnel: "Purchase conversion"
          conversion: 7.2%
          critical_drop: "step_1_to_2"
```

#### 2.2 From Numbers to Stories

```
Data analysis → Business narrative
```

**Transformation principles**:

| Data Language | Business Language |
|---------|---------|
| Conversion rate dropped 3.2% | "Out of every 100 visitors, 3 fewer complete registration" |
| p-value=0.001 | "This conclusion has 99.9% confidence" |
| Confidence interval [2%,5%] | "We are confident the improvement is between 2% and 5%" |
| D7 retention 28.5% | "After one week, about 30% of users are still using it" |

**Narrative template**:

```yaml
narrative_template: |
  ## Insight Title

  ### Background
  How did [product/feature] perform in [time range]?

  ### Findings
  We found [core data change], which means [business impact].

  ### Impact
  Without intervention, [impact level] is expected after [time].
  With successful intervention, [benefit] is expected.

  ### Recommendation
  Based on the data, we recommend [specific action].
```

#### 2.3 Decision Recommendation Generation Example

Generate multiple actionable decision options:

```yaml
action_options:
  - option_id: "opt_001"
    option_name: "Full release of new feature"
    description: "Release the experimental group's new registration flow to all users"

    expected_effect:
      primary_metric: "+8.2% registration conversion rate"
      secondary_metrics:
        - "Registered users +12%"
        - "Overall DAU +2%"

    risk:
      level: "low"
      factors:
        - "All guardrail metrics safe"
        - "Stable effect with no novelty effect"
        - "Can be quickly rolled back"

    confidence:
      level: "high"
      basis:
        - "Statistically significant (p=0.001)"
        - "Complete experiment period (14 days)"
        - "Sufficient sample size (24830)"

    resource_requirements:
      engineering: "2 person-days (release deployment)"
      qa: "1 person-day (regression testing)"

    timeline:
      ready_for_release: "In 2 days"

    prerequisites:
      - "Technical review passed"
      - "Monitoring alerts configured"

  - option_id: "opt_002"
    option_name: "Phased release"
    description: "Release iOS first, then Android after stabilization"

    expected_effect:
      primary_metric: "+5.2% iOS registration conversion rate"
      secondary_metrics:
        - "Android effect to be verified"

    risk:
      level: "medium"
      factors:
        - "Android effect uncertain"
        - "Maintaining two sets of logic"

    confidence:
      level: "medium"
      basis:
        - "iOS statistically significant"
        - "Android effect not significant"
```

#### 2.4 Decision Boundary Annotation Example

Distinguish different types of decisions:

```yaml
decision_boundary:
  type: "data_decision"
  criteria:
    - "Statistically significant (p < 0.01)"
    - "Practically significant (exceeds threshold)"
    - "Guardrail metrics safe"
    - "No major risks"
  auto_execute_eligible: true

  automation_level: "full"

  human_oversight:
    required: false
    notification_only: true

decision_boundary:
  type: "data_reference"
  criteria:
    - "Data supports a certain option"
    - "But there is uncertainty"
    - "Or involves strategic considerations"
  auto_execute_eligible: false

  human_oversight:
    required: true
    decision_maker: "product_manager"
    deadline: "3 business days"
```

#### 2.5 Insight Summary Example

```yaml
insights_gathered:
  - insight: "Simplified registration flow can improve new user conversion"
    confidence: "high"
    source: "ab_test"

  - insight: "High drop-off rate at add-to-cart step"
    confidence: "medium"
    source: "funnel_analysis"

  - insight: "iOS retention outperforms Android"
    confidence: "high"
    source: "retention_analysis"
```

## Source: step-define-conclude-execute.md

### Step 3: Conclude (Decision Options) Example

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

### Step 4: Execute (Execution Tracking) Example

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
