# Change Impact Analysis - 示例集

本文档收录 Change Impact Analysis Skill 的输入与各步骤输出 JSON 示例。

## Change Request Structure 示例

```json
{
  "change_id": "CR_2024_001",
  "title": "Add WeChat login to login flow",
  "requester": "product_manager_zhang",
  "created_at": "ISO8601",
  "change_type": "functional",
  "description": "Add WeChat authorization login method on top of existing phone number login",
  "affected_scope": ["Login module", "User center"],
  "proposed_solution": "Introduce WeChat OpenID authorization mechanism",
  "priority": "high",
  "expected_completion": "2024-02-01"
}
```

## Step 1: Classification Output 示例

```json
{
  "classification": {
    "level": "L3",
    "level_description": "Major change",
    "reasons": [
      "Core login flow underwent major change",
      "Need to add WeChat authorization service dependency"
    ],
    "confidence": 0.92
  }
}
```

## Step 2.1: Functional Impact Matrix 示例

```json
{
  "functional_impact": {
    "directly_affected": [
      {"feature_id": "F001", "feature_name": "Phone login", "impact_type": "modified"}
    ],
    "indirectly_affected": [
      {"feature_id": "F002", "feature_name": "User registration", "impact_type": "needs_regression"},
      {"feature_id": "F003", "feature_name": "Third-party binding", "impact_type": "needs_regression"}
    ],
    "dependent_features": [
      {"feature_id": "F004", "feature_name": "Order creation", "reason": "Depends on user login state"}
    ]
  }
}
```

## Step 2.2: IA Impact Matrix 示例

```json
{
  "ia_impact": {
    "directly_affected_nodes": [
      {"node_id": "IA001", "node_name": "User center", "impact_type": "modified"}
    ],
    "structure_changes": [
      {"node_id": "IA002", "node_name": "Login method", "change_type": "add", "parent": "User center"}
    ],
    "navigation_path_impact": [
      {"path": "Home→Login→WeChat authorization", "change_type": "new"}
    ]
  }
}
```

## Step 2.3: User Flow Impact Matrix 示例

```json
{
  "userflow_impact": {
    "directly_affected_flows": [
      {"flow_id": "UF001", "flow_name": "Login flow", "impact_type": "modified"}
    ],
    "node_changes": [
      {"node_id": "UF001_N3", "node_name": "WeChat authorization", "change_type": "add"}
    ],
    "dead_end_risks": [
      {"risk": "No exit path for users without WeChat binding", "severity": "high"}
    ]
  }
}
```

## Step 2.4: Prototype Impact Matrix 示例

```json
{
  "prototype_impact": {
    "affected_pages": [
      {"page_id": "P001", "page_name": "Login page", "change_type": "modify"}
    ],
    "component_changes": [
      {"component": "WechatLoginButton", "change_type": "new"}
    ],
    "design_consistency": {
      "consistency_score_before": 0.92,
      "consistency_score_after": 0.85,
      "violations": ["New button does not follow design token specification"]
    }
  }
}
```

## Step 2.5: Interaction Specification Impact Matrix 示例

```json
{
  "interaction_spec_impact": {
    "affected_states": [
      {"state": "loading", "scenario": "WeChat authorization in progress", "change_type": "add"}
    ],
    "animation_changes": [
      {"animation": "wechat_auth_loading", "change_type": "new"}
    ],
    "gesture_changes": []
  }
}
```

## Step 3: Re-review Necessity Output 示例

```json
{
  "review_decision": {
    "required": true,
    "level": "L3_mandatory_review",
    "review_scope": [
      {"role": "Product manager", "reason": "Core feature change"},
      {"role": "Test lead", "reason": "Test scope expansion"}
    ],
    "review_content": [
      "WeChat login technical solution",
      "Compatibility with existing login flow",
      "Regression test plan"
    ],
    "review_deadline": "ISO8601"
  }
}
```

## Step 4.1: PRD Version Update 示例

```json
{
  "prd_version_update": {
    "current_version": "1.2.0",
    "new_version": "1.3.0",
    "update_type": "minor_version",
    "sections_to_update": [
      {"chapter": "3. Login feature", "change_type": "modify", "suggestion": "Add WeChat login section"}
    ],
    "update_proposal": "See attached PRD update recommendations"
  }
}
```

## Step 4.2: IA Version Update 示例

```json
{
  "ia_version_update": {
    "current_version": "1.2.0",
    "new_version": "1.3.0",
    "nodes_to_update": [
      {"node_id": "IA001", "node_name": "User center", "change_type": "modify", "suggestion": "Add WeChat login sub-node"}
    ],
    "update_proposal": "See attached IA update recommendations"
  }
}
```

## Step 4.3: User Flow Version Update 示例

```json
{
  "userflow_version_update": {
    "flows_to_add": [
      {"flow_id": "NEW_001", "flow_name": "WeChat login flow", "priority": "P0"}
    ],
    "flows_to_modify": [
      {"flow_id": "UF_001", "flow_name": "Login flow", "change": "Add WeChat login branch"}
    ],
    "flows_to_delete": [],
    "estimated_redesign_effort_hours": 16
  }
}
```

## Execution Log 示例

```json
{
  "execution_id": "exec_p2_xxx",
  "pipeline": "change-impact-analysis",
  "change_id": "CR_2024_001",
  "started_at": "ISO8601",
  "completed_at": "ISO8601",
  "steps": [
    {"step": "step_1_classification", "status": "completed", "duration_ms": 500},
    {"step": "step_2_impact_analysis", "status": "completed", "duration_ms": 2000},
    {"step": "step_3_review_decision", "status": "completed", "duration_ms": 800},
    {"step": "step_4_version_updates", "status": "completed", "duration_ms": 600}
  ],
  "output_ref": "output_ref_xxx",
  "quality_checks_passed": true
}
```
