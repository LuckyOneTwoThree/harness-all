# Output Schema and Validation Rules

This file is referenced by `SKILL.md` for the `user-research-report` skill.

## user-research-report.json structure — Output Schema

```json
{
  "type": "object",
  "required": ["report_metadata", "executive_summary", "personas", "insights", "recommendations"],
  "properties": {
    "report_metadata": {"type": "object", "description": "Report metadata, including product name, research objectives, and confidence"},
    "executive_summary": {"type": "object", "description": "Executive summary, including overview, key findings, and top recommendation"},
    "personas": {"type": "array", "description": "User persona list"},
    "journey": {"type": "object", "description": "User journey, including stages, emotion curve, and key moments"},
    "insights": {"type": "array", "description": "Core insight list"},
    "recommendations": {"type": "array", "description": "Action recommendation list"}
  }
}
```

## Output validation rules

| Field path | Type | Required | Description |
|----------|------|------|------|
| report_metadata | object | Yes | Report metadata |
| report_metadata.product | string | Yes | Product name |
| report_metadata.research_goals | string[] | Yes | Research objectives list, cannot be empty |
| report_metadata.generated_at | string | Yes | Generation timestamp |
| report_metadata.data_sources | string[] | Yes | Data source list |
| report_metadata.overall_confidence | number | Yes | Overall confidence, 0-1 |
| executive_summary | object | Yes | Executive summary |
| executive_summary.overview | string | Yes | Research overview, one paragraph |
| executive_summary.key_findings | string[] | Yes | Key findings, must be ≥3 |
| executive_summary.top_recommendation | string | Yes | Top 1 action recommendation |
| personas | array | Yes | User persona list, 2-4 personas |
| personas[].name | string | Yes | User group name |
| personas[].demographics | object | No | Demographic information |
| personas[].goals | string[] | No | Goals & motivations list |
| personas[].pain_points | string[] | No | Core pain points list |
| personas[].quotes | string[] | Yes | Representative quotes, each Persona ≥2 |
| journey | object | No | User journey |
| journey.stages | array | No | Journey stage list |
| journey.stages[].name | string | Yes | Stage name |
| journey.stages[].behaviors | string[] | Yes | User behaviors |
| journey.stages[].touchpoints | string[] | No | Touchpoint list |
| journey.stages[].emotion_peak | string | No | Emotion peak description |
| journey.stages[].emotion_valley | string | No | Emotion valley description |
| journey.stages[].pain_points | string[] | Yes | Pain points |
| journey.stages[].opportunities | string[] | Yes | Opportunities |
| journey.stages[].metrics | object | No | Key metrics (conversion rate, retention rate, etc.) |
| journey.aha_moment | string | No | Aha Moment description |
| journey.churn_signals | string[] | No | Churn signal list |
| insights | array | Yes | Core insight list, ≤15 items |
| insights[].id | string | Yes | Insight ID, format INS-XXX |
| insights[].category | string | Yes | Insight category enum: need/pain_point/behavior/opportunity |
| insights[].observation | string | Yes | Observation description |
| insights[].evidence | string | Yes | Evidence and source |
| insights[].implication | string | Yes | Product implication |
| insights[].scope | string | Yes | Impact scope enum: global/local |
| recommendations | array | Yes | Action recommendation list, ≥3 items |
| recommendations[].id | string | Yes | Recommendation ID, format REC-XXX |
| recommendations[].description | string | Yes | Recommendation description |
| recommendations[].linked_insights | string[] | Yes | Linked insight ID list |
| recommendations[].expected_impact | string | Yes | Expected impact |
| recommendations[].priority | string | Yes | Priority enum: P0/P1/P2 |
| recommendations[].validation_method | string | Yes | Validation method |

