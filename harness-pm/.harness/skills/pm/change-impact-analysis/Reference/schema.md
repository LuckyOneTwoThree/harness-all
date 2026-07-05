# Change Impact Analysis - Schema 定义

本文档收录 Change Impact Analysis Skill 的输出 JSON Schema、最终输出结构与字段验证规则。

## Output Schema

```json
{
  "type": "object",
  "required": ["output_id", "change_id", "classification", "impact_analysis", "review_needed"],
  "properties": {
    "output_id": {"type": "string", "description": "Output unique identifier"},
    "change_id": {"type": "string", "description": "Change request ID"},
    "generated_at": {"type": "string", "description": "Generation time"},
    "classification": {"type": "object", "description": "Change classification, including level and reasons"},
    "impact_analysis": {"type": "object", "description": "Impact analysis, including functional/IA/user flow/prototype/interaction specification multi-dimensions"},
    "review_needed": {"type": "boolean", "description": "Whether re-review is needed"},
    "review_decision": {"type": "object", "description": "Review decision, including review scope and content"},
    "version_updates": {"type": "object", "description": "Version linkage update recommendations"},
    "summary": {"type": "object", "description": "Change impact summary, including impact scope and risk level"}
  }
}
```

## Final Output Structure

```json
{
  "output_id": "change_impact_report_xxx",
  "change_id": "CR_2024_001",
  "generated_at": "ISO8601",
  "classification": {
    "level": "L3",
    "level_description": "Major change",
    "reasons": [...]
  },
  "impact_analysis": {
    "functional": {...},
    "ia": {...},
    "userflow": {...},
    "prototype": {...},
    "interaction_spec": {...}
  },
  "review_needed": true,
  "review_decision": {...},
  "version_updates": {
    "prd": {...},
    "ia": {...},
    "userflow": {...}
  },
  "summary": {
    "impact_scope": "Multiple feature modules",
    "estimated_effort_days": 10,
    "risk_level": "medium"
  }
}
```

## Output Field Descriptions

| Field | Type | Description |
|------|------|------|
| classification | JSON | Change level and reasons |
| impact_analysis | JSON | Multi-dimensional impact analysis details |
| review_needed | boolean | Whether re-review is needed |
| review_decision | JSON | Review scope and content |
| version_updates | JSON | Version linkage update recommendations |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| output_id | string | Yes | Output unique identifier |
| change_id | string | Yes | Change request ID, must match input change_id |
| generated_at | string | Yes | Generation time, ISO 8601 format |
| classification | object | Yes | Change classification |
| classification.level | string | Yes | Change level, enum: L1/L2/L3/L4 |
| classification.level_description | string | Yes | Level description |
| classification.reasons | array | Yes | Classification reasons list, cannot be empty |
| classification.confidence | number | Yes | Classification confidence, range 0.0-1.0 |
| impact_analysis | object | Yes | Impact analysis |
| impact_analysis.functional | object | Yes | Functional impact analysis, contains directly_affected/indirectly_affected/dependent_features |
| impact_analysis.functional.directly_affected | array | Yes | Directly affected features list, each item contains feature_id/feature_name/impact_type |
| impact_analysis.ia | object | Yes | IA impact analysis, contains directly_affected_nodes/structure_changes/navigation_path_impact |
| impact_analysis.userflow | object | Yes | User flow impact analysis, contains directly_affected_flows/node_changes/dead_end_risks |
| impact_analysis.prototype | object | No | Prototype impact analysis, contains affected_pages/component_changes/design_consistency |
| impact_analysis.interaction_spec | object | No | Interaction specification impact analysis, contains affected_states/animation_changes/gesture_changes |
| review_needed | boolean | Yes | Whether re-review is needed |
| review_decision | object | No | Review decision (required when review_needed is true), contains level/review_scope/review_content/review_deadline |
| review_decision.level | string | No | Review level, enum: L1_optional/L2_suggested/L3_mandatory/L4_strategic |
| review_decision.review_scope | array | No | Review role list, each item contains role/reason |
| version_updates | object | No | Version linkage update recommendations, contains prd/ia/userflow |
| version_updates.prd | object | No | PRD version update recommendations, contains current_version/new_version/sections_to_update |
| version_updates.ia | object | No | IA version update recommendations, contains current_version/new_version/nodes_to_update |
| version_updates.userflow | object | No | User flow version update recommendations, contains flows_to_add/flows_to_modify/flows_to_delete |
| summary | object | Yes | Change impact summary |
| summary.impact_scope | string | Yes | Impact scope description |
| summary.estimated_effort_days | number | Yes | Estimated impact person-days, must be ≥0 |
| summary.risk_level | string | Yes | Risk level, enum: low/medium/high/critical |
