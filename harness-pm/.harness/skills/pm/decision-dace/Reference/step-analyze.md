<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 2: Analyze (Insight Generation) Examples

## 2.1 Data Collection and Analysis Example

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

## 2.2 From Numbers to Stories

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

## 2.3 Decision Recommendation Generation Example

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

## 2.4 Decision Boundary Annotation Example

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

## 2.5 Insight Summary Example

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
