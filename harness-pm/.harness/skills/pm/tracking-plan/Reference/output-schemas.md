<!-- Reference material extracted from SKILL.md, consult as needed -->

# Overall Output Schema and tracking_plan Schema

> Source: Output schema and tracking_plan schema in SKILL.md "Output" section

## Output Schema

```json
{
  "type": "object",
  "required": ["tracking_plan", "quality_check"],
  "properties": {
    "tracking_plan": {"type": "array", "description": "Tracking event list, including event definitions, properties, trigger conditions, etc."},
    "quality_check": {"type": "object", "description": "Quality check results, including naming compliance, property completeness, path coverage, etc."}
  }
}
```

## tracking_plan

```json
{
  "tracking_plan": [
    {
      "event_name": "string",
      "display_name": "string",
      "trigger": {
        "description": "string",
        "timing": "on_action|immediate|on_exit",
        "conditions": ["string"]
      },
      "properties": [
        {
          "name": "string",
          "type": "string|string[]|number|boolean",
          "required": true,
          "description": "string",
          "example": "string"
        }
      ],
      "analysis_purpose": "string",
      "linked_metric": "string",
      "priority": "high|medium|low",
      "status": "pending|approved|implemented"
    }
  ],
  "quality_check": {
    "naming_compliance": true,
    "property_completeness": 0.95,
    "core_path_coverage": 0.92,
    "anomaly_coverage": true,
    "redundancy_detected": [],
    "prd_consistency": {
      "forward_coverage": 0.92,
      "backward_coverage": 0.88,
      "consistency_score": 0.90,
      "status": "pass"
    }
  }
}
```
