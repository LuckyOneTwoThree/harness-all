# Metrics System Output Schema

This document defines the JSON output schema and validation rules for the `metric_system.json` file produced by the Metrics System Auto-Construction skill.

## Top-Level Output Schema

```json
{
  "type": "object",
  "required": ["metric_system"],
  "properties": {
    "metric_system": {"type": "object", "description": "Metrics system, including North Star metric, L1/L2 metrics, actionable metrics, and vanity metric alerts"}
  }
}
```

## metric_system Object Schema

```json
{
  "metric_system": {
    "north_star": {
      "name": "string",
      "definition": "string",
      "calculation": "string",
      "data_source": "string",
      "validation": { "is_vanity_free": true, "validation_date": "2026-05-08" }
    },
    "l1_metrics": [
      {
        "layer": "Acquisition|Activation|Retention|Revenue|Referral",
        "name": "string",
        "weight": 0.20,
        "calculation": "string",
        "data_source": "string",
        "l2_metrics": [
          { "name": "string", "calculation": "string", "data_source": "string", "type": "string", "is_actionable": true }
          // ... Same structure can be extended, at least 3 L2 metrics per L1
        ]
      }
      // ... Same structure can be extended, at least 3 L1 dimensions, weights sum to 1.0
    ],
    "actionable_metrics": [
      { "name": "string", "linked_l2": "string", "linked_l1": "string", "optimization_approach": "string" }
      // ... Same structure can be extended
    ],
    "vanity_alerts": [
      { "metric_name": "string", "alert_type": "string", "severity": "high|medium|low", "recommendation": "string", "suggested_replacement": {} }
      // ... Same structure can be extended
    ]
  }
}
```

---

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| metric_system | object | Yes | Metrics system root object |
| metric_system.north_star | object | Yes | North Star metric |
| metric_system.north_star.name | string | Yes | North Star metric name |
| metric_system.north_star.definition | string | Yes | North Star metric definition |
| metric_system.north_star.calculation | string | Yes | Calculation formula |
| metric_system.north_star.data_source | string | Yes | Data source |
| metric_system.north_star.validation | object | Yes | Validation result |
| metric_system.north_star.validation.is_vanity_free | boolean | Yes | Whether free of vanity characteristics |
| metric_system.l1_metrics | array | Yes | L1 metric list, at least 3 dimensions |
| metric_system.l1_metrics[].layer | string | Yes | AARRR dimension enum value |
| metric_system.l1_metrics[].name | string | Yes | L1 metric name |
| metric_system.l1_metrics[].weight | number | Yes | Weight, all L1 weights should sum to 1.0 |
| metric_system.l1_metrics[].l2_metrics | array | Yes | L2 metric list, at least 3 per L1 |
| metric_system.l1_metrics[].l2_metrics[].name | string | Yes | L2 metric name |
| metric_system.l1_metrics[].l2_metrics[].calculation | string | Yes | Calculation formula |
| metric_system.l1_metrics[].l2_metrics[].is_actionable | boolean | Yes | Whether it is an actionable metric |
| metric_system.actionable_metrics | array | Yes | Actionable metric list |
| metric_system.actionable_metrics[].name | string | Yes | Actionable metric name |
| metric_system.actionable_metrics[].linked_l2 | string | Yes | Linked L2 metric |
| metric_system.actionable_metrics[].optimization_approach | string | Yes | Optimization approach |
| metric_system.vanity_alerts | array | No | Vanity metric alert list |
