# Iteration Retrospective - Schema 定义

本文档收录 Iteration Retrospective Skill 的输出 JSON Schema、文件结构与字段验证规则。

## Output Schema

```json
{
  "type": "object",
  "required": ["iteration_id", "summary", "metrics_analysis"],
  "properties": {
    "generated_at": {"type": "string", "description": "Generation time"},
    "iteration_id": {"type": "string", "description": "Iteration ID"},
    "period": {"type": "object", "description": "Iteration period, including start and end times"},
    "trigger_id": {"type": "string", "description": "Trigger event ID (if adjusted)"},
    "trigger_type": {"type": "string", "description": "Trigger type: monitoring_alert/feedback/strategy_change"},
    "impact_assessment": {"type": "object", "description": "Change impact assessment, including scope/schedule/quality impact"},
    "recommended_option": {"type": "string", "description": "Recommended adjustment plan ID"},
    "options": {"type": "array", "description": "Optional adjustment plan list, including type, score, and trade-offs"},
    "needs_human_decision": {"type": "boolean", "description": "Whether human decision is required"},
    "summary": {"type": "object", "description": "Iteration summary, including completion rate, quality status, and score"},
    "metrics_analysis": {"type": "object", "description": "Metrics analysis, including delivery/quality/collaboration/efficiency four dimensions"},
    "problem_identification": {"type": "object", "description": "Problem identification, including total count and P1/P2 counts"},
    "improvement_suggestions": {"type": "array", "description": "Improvement suggestion list, each item must have owner and validation criteria"}
  }
}
```

## Output File Structure

```
├── iteration-retrospective.json
├── iteration-retrospective.md
├── adjustment/
│   ├── TRG-001/
│   │   ├── impact_assessment.yaml
│   │   ├── adjustment_options.yaml
│   │   ├── risk_assessment.yaml
│   │   ├── communication_draft.md
│   │   └── needs_human_decision.yaml
│   └── latest/
│       └── adjustment_recommendation.md
└── retrospective/
    ├── Sprint-26/
    │   ├── summary.md
    │   ├── metrics_analysis.yaml
    │   ├── problem_identification.yaml
    │   └── improvement_suggestions.yaml
    └── latest/
        └── retrospective_report.md
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| iteration_id | string | Yes | Iteration ID, cannot be empty |
| summary | object | Yes | Iteration summary, must contain delivery_completion/quality_status/overall_score |
| metrics_analysis | object | Yes | Metrics analysis, must contain delivery/quality/collaboration/efficiency four dimensions |
| impact_assessment | object | No | Change impact assessment, must contain affected_items/scope/severity |
| adjustment_options | array | No | Adjustment plan list, at least 2 plans |
| adjustment_options[].recommendation_score | number | No | Recommendation score, range 0-100 |
| risk_assessment | object | No | Risk assessment, must contain risk_level/mitigation |
| communication_draft | object | No | Communication draft, must contain stakeholders/message |
| problem_identification | object | No | Problem identification, must contain total_problems/p1_count |
| improvement_suggestions | array | No | Improvement suggestion list, each item must have owner and validation criteria |
