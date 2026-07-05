# diagnosis-health — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Health score and issue list | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full diagnosis + health trend analysis + root cause deep reasoning + improvement priority roadmap | Full artifact + extended analysis + deep reasoning |

## Output


**Output file path**: `docs/monitoring/diagnosis-report.md ("Health Diagnosis" section)`
**Output Schema**:

```json
{
  "type": "object",
  "required": ["report_id", "overall_score", "scores_by_dimension"],
  "properties": {
    "report_id": {"type": "string", "description": "Report unique identifier"},
    "generated_at": {"type": "string", "description": "Generation time"},
    "period": {"type": "object", "description": "Assessment period, including start and end times"},
    "overall_score": {"type": "number", "description": "Overall health score"},
    "score_trend": {"type": "string", "description": "Score trend: improving/stable/declining"},
    "scores_by_dimension": {"type": "object", "description": "Scores by dimension, including performance/availability/satisfaction/business"},
    "trend_analysis": {"type": "object", "description": "Trend prediction, including 7-day and 30-day predicted changes"},
    "bottlenecks": {"type": "array", "description": "Bottleneck list, including severity and dimension"},
    "recommendations": {"type": "array", "description": "Improvement recommendations list, including priority and expected impact"}
  }
}
```

```
├── 2026-06-15/
│   ├── overall_score.md
│   ├── dimension_scores.yaml
│   ├── trend_analysis.yaml
│   ├── bottlenecks.yaml
│   └── recommendations.md
└── latest/
    └── health_report.md
```

### Health Report Output Format

```yaml
health_diagnosis:
  report_id: b2c3d4e5-f6a7-8901-bcde-f12345678901
  generated_at: 2026-06-15T10:00:00Z
  period:
    start: 2026-06-08T00:00:00Z
    end: 2026-06-15T00:00:00Z
  overall_score: 86
  score_trend: improving
  scores_by_dimension:
    performance: 85
    availability: 92
    satisfaction: 78
    business: 88
  trend_analysis:
    predicted_change_7d: -1
    predicted_change_30d: -3
  bottlenecks:
    - id: BOT-001
      severity: P1
      dimension: satisfaction
  recommendations:
    - priority: high
      action: "Optimize payment flow"
      expected_impact: "+5 NPS"
```
