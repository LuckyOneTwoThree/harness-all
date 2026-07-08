# Experiment Configuration Example

> Extracted from SKILL.md. Complete experiment configuration YAML for A/B test design (Step 5).

## Step 5: Experiment Configuration Generation

Generate complete experiment configuration:

```yaml
ab_test_design:
  created_at: "2024-01-15T10:00:00Z"

  # Experiment basic info
  experiment:
    id: "exp_20240115_simplified_register"
    name: "Simplified Registration Flow Experiment"
    owner: "product_team"
    priority: "high"

  # Structured hypothesis
  hypothesis:
    original: "Simplifying the registration flow can improve conversion rate"
    structured: |
      If we simplify the registration flow from 5 steps to 3 steps,
      then the registration completion rate will increase by 10%,
      because users face less friction,
      for all new users on iOS and Android.

    components:
      change: "Simplify registration from 5 steps to 3 steps"
      expected_outcome: "Registration rate +10%"
      mechanism: "Reduced user friction"
      target_users: "New users on iOS and Android"

  # Metric selection
  metrics:
    primary_metric:
      name: "registration_completion_rate"
      definition: "Number of users who completed registration / Number of users who started registration"
      baseline_value: 0.35
      minimum_detectable_effect: 0.10  # 10% relative lift

    guardrail_metrics:
      - name: "d7_retention_rate"
        definition: "7-day retention rate after registration"
        baseline_value: 0.42
        acceptable_change: -0.02  # Allow 2% decline
      # ... same structure can be extended

    secondary_metrics:
      - name: "registration_abandon_rate"
        definition: "Registration abandonment rate"
      # ... same structure can be extended

  # Sample size calculation
  sample_size:
    per_group: 12400
    total: 24800
    daily_eligible_users: 4000
    expected_duration_days: 7
    minimum_duration_days: 5

    assumptions:
      baseline_rate: 0.35
      mde: 0.10
      significance_level: 0.05
      statistical_power: 0.80

  # Traffic split plan
  traffic_split:
    strategy: "random"
    allocation:
      control: 50
      treatment: 50

    targeting:
      platform: ["ios"]  # ... same structure can be extended
      user_type: "new_user"
      exclusion:
        - registered_users
        # ... same structure can be extended

    hash_salt: "exp_reg_2024_v1"

  # Termination conditions
  termination_conditions:
    automatic:
      - condition: "Reached target sample size"
        action: "Trigger result analysis"
      # ... same structure can be extended

    manual:
      - condition: "Guardrail metric significantly declined"
        action: "Alert + human decision"
      # ... same structure can be extended

    minimum_runtime_days: 5
    maximum_runtime_days: 30

  # Experiment variants
  variants:
    control:
      name: "Current registration flow"
      description: "5-step registration flow, including email and phone verification"
      config: {}

    treatment:
      name: "Simplified registration flow"
      description: "3-step registration flow, phone verification only"
      config:
        steps: 3
        required_fields: ["phone"]
        optional_fields: ["email", "nickname"]
        skip_verification: false

  # Technical configuration
  technical:
    platform: "internal_ab_platform"
    layer: 2
    mutex_group: "registration_flow"
    traffic_allocation: 100  # 100% of available traffic

  # Risk assessment
  risk_assessment:
    overall_risk: "low"
    reasons:
      - "Only affects new user registration flow"
      # ... same structure can be extended
    mitigation:
      - "Configure real-time monitoring"
      # ... same structure can be extended
```
