# Output Schema, Example, and A/B Test Template

> Extracted from SKILL.md. Output schema JSON, full example, and A/B test design template for acquisition analysis.

## Output Schema

```json
{
  "type": "object",
  "required": ["channel_assessment", "funnel_analysis", "optimization_suggestions"],
  "properties": {
    "channel_assessment": {"type": "object", "description": "Channel evaluation results, including channel details, tiering, and summary metrics"},
    "funnel_analysis": {"type": "object", "description": "Funnel analysis, including stage data and key drop-off nodes"},
    "optimization_suggestions": {"type": "array", "description": "List of optimization recommendations, including priority, issue, plan, and expected lift"},
    "ab_test_designs": {"type": "array", "description": "List of A/B test design plans"}
  }
}
```

## Full Example (`acquisition_analysis`)

```json
{
  "channel_assessment": {
    "channels": [
      {
        "name": "Education Industry Exhibition",
        "scale": "Annual reach of 50,000+ education institution decision makers",
        "volume": 10000,
        "conversion_rate": 0.035,
        "cost_per_acquisition": 45.00,
        "roi": 2.5,
        "quality_score": 0.85,
        "classification": "primary|test|observation"
      }
    ],
    "primary_channels": ["Education Industry Exhibition", "SEO/SEM Organic", "Content Marketing"],
    "test_channels": ["Social Ads", "Community Operations", "Affiliate Marketing"],
    "observation_channels": ["PR/Brand", "Cross-industry Collaboration", "Video Ads"],
    "total_new_users": 50000,
    "blended_cac": 35.00,
    "blended_roi": 2.2
  },
  "funnel_analysis": {
    "stages": [
      {
        "name": "Registration",
        "volume": 100000,
        "conversion_rate": 0.05,
        "drop_off_rate": 0.95,
        "avg_time_spent": 30
      }
    ],
    "critical_drop_off": {
      "from_stage": "Visit",
      "to_stage": "Registration",
      "drop_off_rate": 0.85,
      "impact_score": 0.9
    }
  },
  "optimization_suggestions": [
    {
      "priority": 1,
      "stage": "Visit→Registration",
      "issue": "Registration form has too many fields, education institution users have low willingness to fill out",
      "solution": "Simplify registration form to 3 required fields, support WeChat scan one-click registration",
      "expected_improvement": "Expected 15% conversion rate lift",
      "effort": "medium"
    }
  ],
  "ab_test_designs": [
    {
      "test_id": "TEST_001",
      "hypothesis": "Simplifying the registration flow can reduce visit-to-registration drop-off",
      "control": "Current 6-field registration form",
      "treatment": "3-field simplified registration form + WeChat scan registration",
      "primary_metric": "Visit→Registration conversion rate",
      "secondary_metrics": ["Registration completion time", "Post-registration activation rate"],
      "min_sample_size": 10000,
      "estimated_duration": "7 days"
    }
  ]
}
```

## A/B Test Design Template

```yaml
test_id: "ACQ_TEST_{seq}"
name: "Test name"
hypothesis: "If...then... hypothesis"
variants:
  control: "Control group plan description"
  treatment: "Treatment group plan description"
metrics:
  primary: "Primary metric"
  secondary: ["List of secondary metrics"]
  guardrail: ["Guardrail metrics"]
design:
  min_sample_per_variant: 1000
  runtime_days: 7
  mde: 0.05
success_criteria:
  - primary_metric_lift: ">=5%"
  - guardrail_metrics: "No significant decline"
```
