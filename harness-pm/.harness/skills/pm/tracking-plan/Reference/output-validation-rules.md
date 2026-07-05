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
