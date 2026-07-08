# Output Examples

## Complete user-research-report.json Example

```json
{
  "report_metadata": {
    "product": "Product Name",
    "research_goals": [],
    "generated_at": "Timestamp",
    "data_sources": [],
    "overall_confidence": 0.0
  },
  "executive_summary": {
    "overview": "One paragraph",
    "key_findings": [],
    "top_recommendation": ""
  },
  "personas": [
    {
      "name": "User group name",
      "demographics": {},
      "goals": [],
      "pain_points": [],
      "quotes": []
    }
  ],
  "journey": {
    "stages": [
      {
        "name": "Stage name",
        "behaviors": [],
        "touchpoints": [],
        "emotion_peak": "",
        "emotion_valley": "",
        "pain_points": [],
        "opportunities": [],
        "metrics": {}
      }
    ],
    "aha_moment": "",
    "churn_signals": []
  },
  "insights": [
    {
      "id": "INS-001",
      "category": "need/pain_point/behavior/opportunity",
      "observation": "Observation description",
      "evidence": "Evidence and source",
      "implication": "Product implication",
      "scope": "global/local"
    }
  ],
  "recommendations": [
    {
      "id": "REC-001",
      "description": "Recommendation description",
      "linked_insights": ["INS-001"],
      "expected_impact": "Expected impact",
      "priority": "P0/P1/P2",
      "validation_method": "Validation method"
    }
  ]
}
```

