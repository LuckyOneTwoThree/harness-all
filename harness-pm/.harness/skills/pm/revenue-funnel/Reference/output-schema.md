# revenue-funnel — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Revenue Funnel" section)`

**Output file**: revenue_funnel.json

**Output Schema**:

```json
{
  "type": "object",
  "required": ["funnel", "bottlenecks"],
  "properties": {
    "funnel": {"type": "object", "description": "Payment funnel data, including user count and conversion rate per stage"},
    "bottlenecks": {"type": "array", "description": "Bottleneck analysis list, including drop-off rate, impact score, and cause"},
    "optimization_suggestions": {"type": "array", "description": "Optimization suggestion list, including problem, solution, and expected lift"},
    "paywall_timing": {"type": "object", "description": "Paywall timing suggestion, including optimal timing, type, and trial period"}
  }
}
```

`revenue_funnel` (stages array can be extended with more stages using the same structure)
```json
{
  "funnel": {
    "stages": [
      {
        "name": "Registered users",
        "count": 100000,
        "percentage": 1.0
      }
    ],
    "overall_conversion_rate": 0.03,
    "avg_time_to_pay": 14.5
  },
  "bottlenecks": [
    {
      "from_stage": "Active users",
      "to_stage": "Payment intent users",
      "drop_off_rate": 0.833,
      "impact_score": 0.9,
      "likely_cause": "Lack of payment value perception"
    }
  ],
  "optimization_suggestions": [
    {
      "target_stage": "Active → Payment intent",
      "problem": "Insufficient payment value perception",
      "solution": "Optimize value demonstration and trial experience",
      "expected_improvement": "Conversion rate +20%",
      "priority": 1
    }
  ],
  "paywall_timing": {
    "optimal_timing": "After user completes Aha Moment",
    "optimal_paywall_type": "Feature-limited",
    "recommended_trial_period": "7 days",
    "expected_conversion_lift": "15%"
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| funnel | object | Yes | Payment funnel data, must include stages/overall_conversion_rate |
| funnel.stages | array | Yes | Stage data, each item must include name/count |
| funnel.stages[].name | string | Yes | Stage name, cannot be empty |
| funnel.stages[].count | number | Yes | Stage user count, must be ≥0 |
| funnel.stages[].percentage | number | No | Percentage |
| funnel.overall_conversion_rate | number | Yes | Overall conversion rate, range 0-1 |
| funnel.avg_time_to_pay | string | No | Average payment conversion cycle |
| bottlenecks | array | Yes | Bottleneck list, each item must include from_stage/to_stage/drop_off_rate/impact_score |
| bottlenecks[].from_stage | string | Yes | Drop-off start stage |
| bottlenecks[].to_stage | string | Yes | Drop-off target stage |
| bottlenecks[].drop_off_rate | number | Yes | Drop-off rate, range 0-1 |
| bottlenecks[].impact_score | number | Yes | Impact score, range 0-1 |
| bottlenecks[].likely_cause | string | No | Likely cause |
| optimization_suggestions | array | No | Optimization suggestion list, each item must include target_stage/problem/solution |
| optimization_suggestions[].target_stage | string | Yes | Target stage |
| optimization_suggestions[].problem | string | Yes | Problem description |
| optimization_suggestions[].solution | string | Yes | Solution |
| optimization_suggestions[].expected_improvement | string | No | Expected improvement effect |
| optimization_suggestions[].priority | number | No | Priority |
| paywall_timing | object | No | Paywall timing, must include optimal_timing/optimal_paywall_type |
| paywall_timing.optimal_timing | string | Yes | Optimal trigger timing |
| paywall_timing.optimal_paywall_type | string | Yes | Optimal paywall type |
| paywall_timing.recommended_trial_period | string | No | Recommended trial period |
| paywall_timing.expected_conversion_lift | string | No | Expected conversion lift |
