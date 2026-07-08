# Experiment Execution - Schema 定义

本文档收录 Experiment Execution Skill 的输出 JSON Schema 与字段验证规则。

## Output Schema

```json
{
  "type": "object",
  "required": ["experiment_id", "conclusion", "primary_metric", "summary", "action_recommendation"],
  "properties": {
    "experiment_id": {"type": "string", "description": "Experiment ID"},
    "analyzed_at": {"type": "string", "description": "Analysis time"},
    "experiment_info": {"type": "object", "description": "Experiment info, including name, duration, and sample size"},
    "conclusion": {"type": "string", "description": "Experiment conclusion: positive/negative/neutral/inconclusive"},
    "primary_metric": {"type": "object", "description": "Primary metric results, including control/treatment data and statistical testing"},
    "guardrail_metrics": {"type": "object", "description": "Guardrail metric results, including each metric change and safety judgment"},
    "heterogeneous_effects": {"type": "object", "description": "Heterogeneous effects, segmented analysis by platform/user type"},
    "novelty_check": {"type": "object", "description": "Novelty effect detection"},
    "experiment_name": {"type": "string", "description": "Experiment name"},
    "report_date": {"type": "string", "description": "Report date"},
    "summary": {"type": "object", "description": "Statistical conclusion summary, including conclusion, recommendation, and primary metric results"},
    "novelty_effect": {"type": "object", "description": "Novelty effect assessment"},
    "action_recommendation": {"type": "object", "description": "Action recommendations, including decision, rationale, risks, and follow-up experiments"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| ab_test_result | object | Yes | Experiment result root object |
| ab_test_result.experiment_id | string | Yes | Experiment ID |
| ab_test_result.analyzed_at | string | Yes | Analysis time |
| ab_test_result.conclusion | string | Yes | Experiment conclusion, enum: positive/negative/neutral/inconclusive |
| ab_test_result.primary_metric | object | Yes | Primary metric result |
| ab_test_result.primary_metric.name | string | Yes | Primary metric name |
| ab_test_result.primary_metric.control.value | number | Yes | Control group value |
| ab_test_result.primary_metric.treatment.value | number | Yes | Treatment group value |
| ab_test_result.primary_metric.lift.relative | number | Yes | Relative lift |
| ab_test_result.primary_metric.statistics.p_value | number | Yes | p-value |
| ab_test_result.primary_metric.statistics.statistically_significant | boolean | Yes | Whether statistically significant |
| ab_test_result.guardrail_metrics | object | Yes | Guardrail metric result |
| ab_test_result.heterogeneous_effects | object | No | Heterogeneous effects |
| ab_test_result.novelty_check | object | Yes | Novelty effect detection |
| ab_test_result.novelty_check.detected | boolean | Yes | Whether novelty effect detected |
| ab_test_result.decision_recommendation | object | Yes | Decision recommendation |
| ab_test_result.decision_recommendation.action | string | Yes | Recommended action, enum: full_release/partial_release/no_release/continue_experiment |
| ab_test_result.decision_recommendation.confidence | string | Yes | Confidence level |
| experiment_id | string | Yes | Experiment ID (report) |
| experiment_name | string | Yes | Experiment name (report) |
| report_date | string | Yes | Report date |
| summary | object | Yes | Statistical conclusion summary |
| summary.conclusion | string | Yes | Conclusion, enum: significant_positive/not_significant/significant_negative/marginal |
| summary.recommendation | string | Yes | Recommendation, enum: ship_full/ship_conditional/extend/terminate/segmented |
| summary.primary_metric | object | Yes | Primary metric result |
| summary.primary_metric.name | string | Yes | Primary metric name |
| summary.primary_metric.relative_lift | number | Yes | Relative lift |
| summary.primary_metric.p_value | number | Yes | p-value |
| summary.guardrail_status | array | Yes | Guardrail metric status list |
| heterogeneous_effects | array | No | Heterogeneous effect analysis |
| novelty_effect | object | No | Novelty effect assessment |
| action_recommendation | object | Yes | Action recommendation |
| action_recommendation.decision | string | Yes | Decision |
| action_recommendation.rationale | string | Yes | Rationale |
| action_recommendation.risks | array | Yes | Risk list |
| action_recommendation.next_experiments | array | No | Follow-up experiment recommendations |
