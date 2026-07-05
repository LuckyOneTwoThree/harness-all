# Experiment Execution - 示例集

本文档收录 Experiment Execution Skill 各步骤的 YAML/JSON 输出示例与报告模板。

## Step 1.1: Statistical Significance Testing Output 示例

```yaml
statistical_test:
  method: "two_sample_proportion_z_test"

  results:
    control:
      sample_size: 12450
      rate: 0.352
      standard_error: 0.0043

    treatment:
      sample_size: 12380
      rate: 0.381
      standard_error: 0.0044

    test_statistic: 4.82
    p_value: 0.0000014
    confidence_interval:
      lower: 0.018
      upper: 0.040
      confidence_level: 0.95

  interpretation:
    is_significant: true
    significance_level: 0.05
    conclusion: "Experiment group significantly outperforms control group"
```

## Step 1.2: Practical Business Significance 示例

```yaml
practical_significance:
  absolute_lift: 0.029
  relative_lift: 0.082

  threshold:
    minimum_meaningful_lift: 0.02

  assessment:
    is_practically_significant: true
    business_verdict: "Worth full release"
    reasoning: "8.2% lift exceeds 5% business threshold, estimated annual revenue increase of 1.2M"
```

## Step 1.3: Heterogeneous Effect Detection 示例

```yaml
heterogeneous_effects:
  summary: "Significant platform difference found"

  dimension_analysis:
    platform:
      ios:
        lift: 0.052
        p_value: 0.001
        significant: true

      android:
        lift: 0.018
        p_value: 0.089
        significant: false

      conclusion: "iOS user effect significant, Android not significant"

    user_segment:
      new_users:
        lift: 0.041
        significant: true

      returning_users:
        lift: 0.015
        significant: false

      conclusion: "Mainly effective for new users"

    traffic_source:
      organic:
        lift: 0.045
        significant: true

      paid:
        lift: 0.022
        significant: false

      conclusion: "More effective for organic traffic"

  recommendations:
    - "Consider full release on iOS only"
    - "Optimize the Android version implementation"
    - "Targeted promotion for new users"
```

## Step 1.4: Novelty Effect Detection 示例

```yaml
novelty_check:
  enabled: true

  indicators:
    daily_trend:
      day_1: 0.15
      day_3: 0.09
      day_7: 0.08
      day_14: 0.082

    assessment:
      is_novelty_effect: false
      trend_stable: true
      conclusion: "Effect stable, no novelty effect"

    actions:
      if_novelty: "Extend experiment duration by 2 weeks"
      if_stable: "Can proceed to decision flow"
```

## Step 1.5: Decision Recommendation 示例

```yaml
decision_recommendation:
  overall_assessment:
    statistical_significance: true
    practical_significance: true
    guardrail_metrics_safe: true
    no_heterogeneous_risks: true
    novelty_effect_resolved: true

  conclusion: "positive"

  primary_metric:
    name: "registration_completion_rate"

    control:
      value: 0.352
      lower_ci: 0.344
      upper_ci: 0.360

    treatment:
      value: 0.381
      lower_ci: 0.373
      upper_ci: 0.389

    lift:
      absolute: 0.029
      relative: 0.082
      confidence_interval: [0.018, 0.040]

    statistics:
      p_value: 0.0000014
      statistically_significant: true
      practically_significant: true

  guardrail_metrics:
    - name: "d7_retention_rate"
      control: 0.42
      treatment: 0.418
      change: -0.47%
      safe: true
      verdict: "No significant impact"

    - name: "daily_active_users"
      control: 1000000
      treatment: 1001500
      change: +0.15%
      safe: true
      verdict: "No significant impact"

    - name: "app_crash_rate"
      control: 0.002
      treatment: 0.0021
      change: +5%
      safe: true
      verdict: "No significant impact"

  heterogeneous_effects:
    summary: "iOS effect significant (+5.2%), Android not significant (+1.8%)"
    recommendations:
      - "Consider platform-specific release strategy"
      - "Android version needs further optimization"

  novelty_check:
    detected: false
    trend: "stable"

  recommendation:
    action: "Full release"
    confidence: "high"

    reasoning:
      - "Primary metric lifted 8.2%, statistically significant"
      - "Practical business significance achieved"
      - "Guardrail metrics safe"
      - "Effect stable, no novelty effect"

    risks:
      - "Android effect uncertain, needs post-release monitoring"

    next_steps:
      - "Full release to iOS and Android"
      - "Monitor key metrics for 2 weeks post-release"
      - "If Android performance remains poor, consider rollback"
```

## Experiment Result Data Example (YAML)

```yaml
ab_test_result:
  experiment_id: "exp_20240115_simplified_register"
  analyzed_at: "2024-01-22T10:00:00Z"

  experiment_info:
    name: "Simplified Registration Flow Experiment"
    start_date: "2024-01-15"
    end_date: "2024-01-21"
    duration_days: 7
    total_sample: 24830

  conclusion: "positive"

  primary_metric:
    name: "registration_completion_rate"

    control:
      value: 0.352
      sample_size: 12450
      confidence_interval: [0.344, 0.360]

    treatment:
      value: 0.381
      sample_size: 12380
      confidence_interval: [0.373, 0.389]

    lift:
      absolute: 0.029
      relative: 0.082
      confidence_interval: [0.018, 0.040]

    statistics:
      p_value: 0.0000014
      test_method: "two_sample_z_test"
      statistically_significant: true
      practically_significant: true

  guardrail_metrics:
    d7_retention_rate:
      control: 0.42
      treatment: 0.418
      change: -0.47%
      safe: true

    daily_active_users:
      control: 1000000
      treatment: 1001500
      change: +0.15%
      safe: true

    app_crash_rate:
      control: 0.002
      treatment: 0.0021
      change: +5%
      safe: true

  heterogeneous_effects:
    platform:
      ios: { lift: 0.052, significant: true }
      android: { lift: 0.018, significant: false }
    user_type:
      new_users: { lift: 0.041, significant: true }
      returning_users: { lift: 0.015, significant: false }

  novelty_check:
    detected: false
    trend_stable: true

  decision_recommendation:
    action: "full_release"
    confidence: "high"
    reasoning:
      - "Primary metric lifted 8.2%"
      - "Guardrail metrics safe"
      - "No novelty effect"
```

## Markdown Report Structure 模板

```markdown
# A/B Test Report: {Experiment Name}

## 1. Experiment Overview
- Experiment ID / Run period / Sample size
- Hypothesis statement (H₀ / H₁)
- Metric system (Core / Guardrail / Secondary)
- Traffic split plan

## 2. Statistical Conclusions
- Core metric: effect size [CI] (p=xxx)
- Guardrail metrics: ✅/⚠️/❌ item-by-item check
- Sample size validation: met/not met
- Overall judgment: significantly positive / not significant / significantly negative

## 3. Effect Analysis
- Effect size interpretation (absolute/relative/business conversion)
- Heterogeneous effects (segment drill-down table)
- Novelty effect assessment
- Interaction effect check

## 4. Action Recommendations
- Recommended action + rationale
- Risk warnings
- Follow-up experiment recommendations

## 5. Appendix
- Statistical method description
- Data quality check
- Complete metric detail table
```

## Structured Report Data Example (JSON)

```json
{
  "experiment_id": "",
  "experiment_name": "",
  "report_date": "",
  "summary": {
    "conclusion": "significant_positive|not_significant|significant_negative|marginal",
    "recommendation": "ship_full|ship_conditional|extend|terminate|segmented",
    "primary_metric": {
      "name": "",
      "control_value": 0,
      "treatment_value": 0,
      "absolute_lift": 0,
      "relative_lift": 0,
      "confidence_interval": [0, 0],
      "p_value": 0,
      "statistical_power": 0
    },
    "guardrail_status": []
  },
  "heterogeneous_effects": [],
  "novelty_effect": {},
  "action_recommendation": {
    "decision": "",
    "rationale": "",
    "risks": [],
    "next_experiments": []
  }
}
```
