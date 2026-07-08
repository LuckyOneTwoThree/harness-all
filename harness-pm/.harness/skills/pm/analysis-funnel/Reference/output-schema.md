# Output Schema and Validation Rules

This file is referenced by `SKILL.md` for the `analysis-funnel` skill.

## Output Schema

```json
{
  "type": "object",
  "required": ["funnel_name", "steps", "overall_conversion"],
  "properties": {
    "funnel_name": {"type": "string", "description": "Funnel name"},
    "date_range": {"type": "object", "description": "Analysis time range, including start and end dates"},
    "steps": {"type": "array", "description": "Funnel step data, including event name, count, and conversion rate"},
    "overall_conversion": {"type": "number", "description": "Overall conversion rate"},
    "vs_last_period": {"type": "object", "description": "Comparison with previous period, including change trend and key steps"},
    "critical_drop": {"type": "object", "description": "Critical drop-off analysis, including dimension breakdown and potential causes"}
  }
}
```


## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| funnel_analysis | object | Yes | Funnel analysis root object |
| funnel_analysis.funnel_name | string | Yes | Funnel name |
| funnel_analysis.date_range | object | Yes | Analysis time range |
| funnel_analysis.date_range.start | string | Yes | Start date |
| funnel_analysis.date_range.end | string | Yes | End date |
| funnel_analysis.steps | array | Yes | Funnel step data, at least 2 steps |
| funnel_analysis.steps[].step | number | Yes | Step number |
| funnel_analysis.steps[].name | string | Yes | Step name |
| funnel_analysis.steps[].event | string | Yes | Event name |
| funnel_analysis.steps[].count | number | Yes | User count |
| funnel_analysis.steps[].conversion_from_previous | number | Yes | Step-to-step conversion rate |
| funnel_analysis.overall_conversion | number | Yes | Overall conversion rate |
| funnel_analysis.vs_last_period | object | Yes | Comparison with previous period |
| funnel_analysis.critical_drop | object | Yes | Critical drop-off analysis |
| funnel_analysis.critical_drop.step | string | Yes | Drop-off step |
| funnel_analysis.critical_drop.dropoff_rate | number | Yes | Drop-off rate |
| funnel_analysis.critical_drop.potential_causes | array | Yes | Potential causes list |

