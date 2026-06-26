# Retention Management - Output Schema & Validation Rules

Field-level schema and validation rules for the `retention-management` skill outputs (`retention-management.json`, `retention-management.md`).

## Output Schema

```json
{
  "type": "object",
  "required": ["churn_prevention", "segments", "strategies"],
  "properties": {
    "churn_prevention": {"type": "object", "description": "Churn prediction and intervention results, including model, risk users, and intervention strategies"},
    "segments": {"type": "array", "description": "User segmentation data, including tier name, count, characteristics, and health score"},
    "segment_overview": {"type": "object", "description": "Overview per tier, including count and average health score"},
    "strategies": {"type": "array", "description": "List of tiered operation strategies, including goals, actions, and success metrics"},
    "personalized_content": {"type": "array", "description": "List of personalized outreach content, including content type, theme, and channel"}
  }
}
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| churn_prevention | object | Yes | Churn prediction and intervention results, must include risk_model/high_risk_users/interventions |
| churn_prevention.risk_model | object | Yes | Prediction model, must include model_type/features/accuracy |
| churn_prevention.risk_model.model_type | string | Yes | Model type |
| churn_prevention.risk_model.features | array | Yes | Model feature list |
| churn_prevention.risk_model.features[].feature_name | string | Yes | Feature name |
| churn_prevention.risk_model.features[].importance | number | No | Feature importance |
| churn_prevention.risk_model.accuracy | number | Yes | Model accuracy, must be >0.75 |
| churn_prevention.risk_thresholds | object | Yes | Risk thresholds, must include high_risk/medium_risk/low_risk |
| churn_prevention.high_risk_users | array | Yes | High-risk user list, each item must include user_id/risk_score/risk_level |
| churn_prevention.high_risk_users[].user_id | string | Yes | User ID |
| churn_prevention.high_risk_users[].risk_score | number | Yes | Risk score, range 0-1 |
| churn_prevention.high_risk_users[].risk_level | string | Yes | Risk level, only allows high/medium/low/stable |
| churn_prevention.high_risk_users[].primary_churn_signals | string[] | No | Primary churn signals |
| churn_prevention.high_risk_users[].recommended_intervention | string | No | Recommended intervention |
| churn_prevention.interventions | array | Yes | Intervention strategy list, each item must include trigger_condition/intervention_type/channel |
| churn_prevention.interventions[].trigger_condition | string | Yes | Trigger condition |
| churn_prevention.interventions[].intervention_type | string | Yes | Intervention type, enum: email/in_app/push/call |
| churn_prevention.interventions[].channel | string | Yes | Outreach channel |
| churn_prevention.interventions[].content_theme | string | No | Content theme |
| churn_prevention.tracking | object | No | Effectiveness tracking, must include response_rate/churn_prevention_rate/roi |
| segments | array | Yes | User segmentation data, must cover at least new/growing/mature/dormant/churned 5 tiers |
| segments[].segment_id | string | Yes | Segment identifier, only allows new_user/growing_user/mature_user/at_risk/churned |
| segments[].count | number | Yes | Segment user count, must be ≥0 |
| segments[].health_score | number | Yes | Health score, range 0-1 |
| segments[].characteristics | object | No | Segment characteristics |
| segments[].characteristics.avg_tenure | string | No | Average lifecycle |
| segments[].characteristics.key_behaviors | string[] | No | Key behaviors |
| strategies | array | Yes | Operation strategy list, at least 5 (1 per tier) |
| strategies[].segment | string | Yes | Target segment |
| strategies[].key_actions | string[] | No | Key action list |
| strategies[].success_metrics | array | Yes | Success metric list, at least 1 |
| personalized_content | array | No | Personalized content list |
| personalized_content[].content_type | string | Yes | Content type, enum: email/in_app/push/sms |
| personalized_content[].theme | string | Yes | Content theme |
| personalized_content[].channels | string[] | No | Outreach channel list |
| personalized_content[].frequency | string | No | Outreach frequency |
