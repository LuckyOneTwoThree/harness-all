# release-gradual Output Schema

> This document is split from the release-gradual SKILL.md and contains the complete output data structure definition, final output structure, output field descriptions, and output validation rules.

## Output Schema

```json
{
  "type": "object",
  "required": ["gradual_release"],
  "properties": {
    "gradual_release": {
      "type": "object",
      "description": "Gradual release root object",
      "required": ["strategy", "monitoring", "rollback_plan"],
      "properties": {
        "strategy": {
          "type": "object",
          "description": "Release strategy",
          "required": ["type", "stages"],
          "properties": {
            "type": {"type": "string", "description": "Strategy type, enum: canary/blue_green/rolling/feature_flag"},
            "stages": {
              "type": "array",
              "description": "List of release stages, minimum 2",
              "items": {
                "type": "object",
                "required": ["name", "traffic_percentage", "duration", "success_criteria", "rollback_criteria"],
                "properties": {
                  "name": {"type": "string", "description": "Stage name"},
                  "traffic_percentage": {"type": "number", "description": "Traffic percentage, 0-100"},
                  "duration": {"type": "string", "description": "Duration"},
                  "success_criteria": {"type": "object", "description": "Success criteria"},
                  "rollback_criteria": {"type": "object", "description": "Rollback criteria"}
                }
              }
            }
          }
        },
        "monitoring": {
          "type": "object",
          "description": "Monitoring configuration",
          "required": ["metrics", "alert_rules"],
          "properties": {
            "metrics": {"type": "array", "description": "List of monitoring metrics"},
            "alert_rules": {"type": "array", "description": "List of alert rules"}
          }
        },
        "rollback_plan": {
          "type": "object",
          "description": "Rollback plan",
          "required": ["trigger_conditions", "steps"],
          "properties": {
            "trigger_conditions": {"type": "array", "description": "Trigger conditions"},
            "steps": {"type": "array", "description": "Rollback steps"}
          }
        }
      }
    }
  }
}
```

## Final Output Structure

```json
{
  "gradual_release": {
    "strategy": {
      "type": "canary",
      "stages": [
        {
          "name": "phase_1",
          "traffic_percentage": 1,
          "duration": "30m",
          "success_criteria": { /* see Step 1.2 Release Plan Generation */ },
          "rollback_criteria": { /* see Step 3.2 Stage Status Evaluation */ }
        }
      ]
    },
    "monitoring": {
      "metrics": [ { /* see Step 3.1 Metric Collection */ } ],
      "alert_rules": [ { /* see Guardrail Metric Configuration */ } ]
    },
    "rollback_plan": {
      "trigger_conditions": [ { /* see Step 4.1 Rollback Trigger Conditions */ } ],
      "steps": [ { /* see Step 4.2 Rollback Execution */ } ]
    }
  }
}
```

## Output Field Descriptions

| Field | Type | Description |
|------|------|------|
| gradual_release | object | Gradual release root object |
| gradual_release.strategy | object | Release strategy |
| gradual_release.strategy.type | string | Strategy type |
| gradual_release.strategy.stages | array | List of release stages |
| gradual_release.monitoring | object | Monitoring configuration |
| gradual_release.rollback_plan | object | Rollback plan |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| gradual_release | object | Yes | Gradual release root object |
| gradual_release.strategy | object | Yes | Release strategy |
| gradual_release.strategy.type | string | Yes | Strategy type, enum: canary/blue_green/rolling/feature_flag |
| gradual_release.strategy.stages | array | Yes | List of release stages, minimum 2 |
| gradual_release.strategy.stages[].name | string | Yes | Stage name |
| gradual_release.strategy.stages[].traffic_percentage | number | Yes | Traffic percentage, 0-100 |
| gradual_release.strategy.stages[].duration | string | Yes | Duration |
| gradual_release.strategy.stages[].success_criteria | object | Yes | Success criteria |
| gradual_release.strategy.stages[].rollback_criteria | object | Yes | Rollback criteria |
| gradual_release.monitoring | object | Yes | Monitoring configuration |
| gradual_release.monitoring.metrics | array | Yes | List of monitoring metrics |
| gradual_release.monitoring.alert_rules | array | Yes | List of alert rules |
| gradual_release.rollback_plan | object | Yes | Rollback plan |
| gradual_release.rollback_plan.trigger_conditions | array | Yes | Trigger conditions |
| gradual_release.rollback_plan.steps | array | Yes | Rollback steps |
