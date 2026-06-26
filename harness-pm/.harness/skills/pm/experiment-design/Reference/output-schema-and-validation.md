# Output Schema and Validation Rules

> Extracted from SKILL.md. Output JSON schema and field validation rules for experiment design.

## Output Schema

```json
{
  "type": "object",
  "required": ["hypothesis", "primary_metric", "sample_size", "traffic_allocation"],
  "properties": {
    "hypothesis": {"type": "object", "description": "Structured hypothesis, containing If-Then-Because-For"},
    "primary_metric": {"type": "object", "description": "Primary metric definition, including name and calculation method"},
    "guardrail_metrics": {"type": "array", "description": "Guardrail metric list, covering retention/revenue/technical dimensions"},
    "sample_size": {"type": "object", "description": "Sample size estimation, including calculation parameters and results"},
    "traffic_allocation": {"type": "object", "description": "Traffic split plan, including ratios and layering strategy"},
    "termination_conditions": {"type": "object", "description": "Termination conditions, including early termination and maximum duration"},
    "risk_assessment": {"type": "object", "description": "Risk assessment and mitigation measures"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| ab_test_design | object | Yes | Experiment design root object |
| ab_test_design.experiment | object | Yes | Experiment basic info |
| ab_test_design.experiment.id | string | Yes | Experiment ID |
| ab_test_design.experiment.name | string | Yes | Experiment name |
| ab_test_design.hypothesis | object | Yes | Structured hypothesis |
| ab_test_design.hypothesis.structured | string | Yes | If-Then-Because-For format hypothesis |
| ab_test_design.metrics | object | Yes | Metric system |
| ab_test_design.metrics.primary_metric | object | Yes | Primary metric |
| ab_test_design.metrics.primary_metric.name | string | Yes | Primary metric name |
| ab_test_design.metrics.primary_metric.baseline_value | number | Yes | Baseline value |
| ab_test_design.metrics.guardrail_metrics | array | Yes | Guardrail metric list, at least 2 |
| ab_test_design.sample_size | object | Yes | Sample size calculation |
| ab_test_design.sample_size.per_group | number | Yes | Sample size per group |
| ab_test_design.sample_size.total | number | Yes | Total sample size |
| ab_test_design.sample_size.expected_duration_days | number | Yes | Expected days |
| ab_test_design.traffic_split | object | Yes | Traffic split plan |
| ab_test_design.termination_conditions | object | Yes | Termination conditions |
| ab_test_design.risk_assessment | object | Yes | Risk assessment |
