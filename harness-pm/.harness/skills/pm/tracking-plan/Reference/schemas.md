# Schemas (All Schema & Input/Output Definitions)

Merged reference material for tracking-plan schemas: input schemas, output schemas, output validation rules, escalation schema, document structure schema, and the detailed-guidance input table. Provenance is preserved per source file below.

---

## Source: input-schemas.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Input Schema

> Source: Metric system and existing tracking inventory JSON schema in SKILL.md "Input" section

## Metric System (from Pipeline 1)

```json
{
  "north_star": {
    "name": "string",
    "calculation": "string"
  },
  "l1_metrics": [...],
  "l2_metrics": [...],
  "actionable_metrics": [...]
}
```

---

## Existing Tracking Inventory (Optional)

```json
[
  {
    "event_name": "string",
    "trigger": "string",
    "properties": [
      {
        "name": "string",
        "type": "string"
      }
    ],
    "last_modified": "2026-01-01"
  }
]
```

---

## Source: output-schemas.md

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

---

## Source: output-validation-rules.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Output Field Validation Rules Table

> Source: Field validation rules table in SKILL.md "Output Validation Rules" section

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| tracking_plan | array | Yes | Tracking event list |
| tracking_plan[].event_name | string | Yes | Event name, lowercase underscore format |
| tracking_plan[].display_name | string | Yes | Event display name |
| tracking_plan[].trigger | object | Yes | Trigger condition definition |
| tracking_plan[].trigger.description | string | Yes | Trigger description |
| tracking_plan[].trigger.timing | string | Yes | Trigger timing, enum values: on_action/immediate/on_exit |
| tracking_plan[].properties | array | Yes | Property list |
| tracking_plan[].properties[].name | string | Yes | Property name |
| tracking_plan[].properties[].type | string | Yes | Property type |
| tracking_plan[].properties[].required | boolean | Yes | Whether required |
| tracking_plan[].analysis_purpose | string | Yes | Analysis purpose |
| tracking_plan[].linked_metric | string | Yes | Linked metric |
| tracking_plan[].priority | string | Yes | Priority, enum values: high/medium/low |
| tracking_plan[].status | string | Yes | Status, enum values: pending/approved/implemented |
| quality_check | object | Yes | Quality check results |
| quality_check.naming_compliance | boolean | Yes | Whether naming specification passes |
| quality_check.property_completeness | number | Yes | Property completeness rate, ≥0.8 |
| quality_check.core_path_coverage | number | Yes | Core path coverage rate, ≥0.9 |
| quality_check.prd_consistency | object | Yes | PRD consistency validation results |

---

## Source: escalation-schema.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Escalation Output Schema

> Source: Escalation output schema in SKILL.md "Escalation Path → Escalation Output"

## Escalation Output

```json
{
  "escalation": {
    "trigger": "string",
    "reason": "string",
    "affected_events": ["string"],
    "ai_recommendation": {},
    "requires_human_action": true,
    "human_decision_needed": [
      "Business logic confirmation",
      "Privacy compliance confirmation",
      "Tracking priority adjustment"
    ]
  }
}
```

---

## Source: step5-document-schema.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Step 5: Tracking Document Structure Schema

> Source: Document structure schema in SKILL.md "Step 5: Generate Tracking Document"

## Document Structure

```json
{
  "tracking_document": {
    "version": "1.0",
    "generated_date": "2026-05-08",
    "overview": {
      "total_events": 100,
      "new_events": 30,
      "updated_events": 10,
      "existing_events": 60
    },
    "events": [
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
        "status": "pending|approved|implemented",
        "source": "metrics_prd|existing|new"
      }
    ]
  }
}
```

---

## Source: progressive-disclosure.md

# tracking-plan — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| PRD | string/file | Yes | User-provided | PRD document content (including feature descriptions, user flows, core paths, business rules) |
| Metric System | JSON | Yes | docs/metrics/metrics-system.md | North Star Metric, L1/L2/action metrics |
| Existing Tracking Inventory | JSON array | ○ | User-provided | Existing tracking event inventory |

### PRD (Required)

**PRD document content**, including:
- Product feature descriptions
- User flow descriptions
- Core path definitions
- Business rule descriptions

**Supported formats**:
- Markdown
- Word document
- Structured JSON
- Wireframes + descriptions

---

### Metric System (from Pipeline 1)

> 📋 For input JSON schema, see "Metric System" section above in this file

---

### Existing Tracking Inventory (Optional)

> 📋 For input JSON schema, see "Existing Tracking Inventory" section above in this file

---
