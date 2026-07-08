# activation-onboarding — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Onboarding" section)`

**Output file**: onboarding_plan.json

**Output Schema**:

```json
{
  "type": "object",
  "required": ["current_effectiveness", "segment_strategies"],
  "properties": {
    "current_effectiveness": {"type": "object", "description": "Current Onboarding effectiveness assessment, including completion rate, drop-off points, and average completion time"},
    "segment_strategies": {"type": "array", "description": "List of segment Onboarding strategies, including segment characteristics and expected lift"},
    "personalized_content": {"type": "array", "description": "List of personalized guidance content, including content type and trigger conditions"},
    "ab_tests": {"type": "array", "description": "List of A/B test design plans"}
  }
}
```

`onboarding_optimization`
```json
{
  "current_effectiveness": {
    "overall_completion_rate": 0.45,
    "stage_completion_rates": {
      "welcome": 0.85,
      "profile_setup": 0.65,
      "first_action": 0.55,
      "aha_moment": 0.35
    },
    "drop_off_points": [
      {"stage": "profile_setup", "drop_off_rate": 0.24}
    ],
    "avg_time_to_complete": 12.5
  },
  "segment_strategies": [
    {
      "segment": "New user - technical background",
      "size": 5000,
      "characteristics": ["Has technical background", "Prefers self-service exploration"],
      "strategy": "Simplify guidance, provide advanced feature entry",
      "expected_improvement": "+20% activation rate"
    }
  ],
  "personalized_content": [
    {
      "segment": "New user - non-technical background",
      "content_type": "step_by_step_guide",
      "content": "Interactive tutorial guiding teachers step by step through course creation, content editing, and student invitation",
      "trigger": "Show immediately after registration"
    }
  ],
  "ab_tests": [
    {
      "test_id": "ONB_TEST_001",
      "hypothesis": "Step-by-step guidance vs. free exploration",
      "target_segment": "Non-technical users",
      "expected_lift": "15%"
    }
  ]
}
```

## A/B Test Design Template

```yaml
test_id: "ONB_TEST_{sequence}"
name: "Test name"
hypothesis: "Optimization hypothesis description"
target_segment: "Target user group"
variants:
  control:
    name: "Control group"
    description: "Current scheme description"
  treatment:
    name: "Treatment group"
    description: "Optimization scheme description"
metrics:
  primary: "Primary metric definition"
  secondary: ["Secondary metric list"]
  guardrail: ["Guardrail metric list"]
design:
  min_sample_per_variant: 2000
  runtime_days: 14
  mde: 0.05
success_criteria:
  - primary_metric_lift: ">=10%"
  - guardrail_metrics: "No significant decline"
  - statistical_significance: 0.95
```
