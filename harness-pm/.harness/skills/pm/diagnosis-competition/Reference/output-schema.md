# diagnosis-competition — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output


**Output file path**: `docs/monitoring/diagnosis-report.md ("Competitor Diagnosis" section)`
**Output Schema**:

```json
{
  "type": "object",
  "required": ["report_id", "feature_changes", "advantage_changes", "response_strategy"],
  "properties": {
    "report_id": {"type": "string", "description": "Report unique identifier"},
    "generated_at": {"type": "string", "description": "Generation time"},
    "period": {"type": "object", "description": "Analysis period, including start and end times"},
    "feature_changes": {"type": "object", "description": "Feature change summary, including total and P0/P1 counts"},
    "advantage_changes": {"type": "object", "description": "Advantage changes, including gaining/holding/losing dimensions"},
    "response_strategy": {"type": "array", "description": "Response strategy list, including competitor, feature, and priority"}
  }
}
```

```
├── 2026-06-15/
│   ├── feature_changes.yaml
│   ├── advantage_changes.yaml
│   ├── response_strategy.yaml
│   └── effect_tracking.yaml
└── latest/
    └── competition_report.md
```

### Competitor Response Output Format

```yaml
competition_response:
  report_id: a1b2c3d4-e5f6-7890-abcd-ef1234567890
  generated_at: 2026-06-15T10:00:00Z
  period: 2026-05-01 to 2026-06-15
  feature_changes:
    total: 12
    p0_count: 2
    p1_count: 5
  advantage_changes:
    gaining: [feature_leadership, ecosystem]
    holding: [user_experience]
    losing: [pricing]
  response_strategy:
    - id: STR-001
      competitor: Competitor A
      feature: Data Analytics
      approach: accelerate
      action: Launch differentiated data analytics module
      timeline: 4
      priority: P0
      tracking:
        status: planned
```
