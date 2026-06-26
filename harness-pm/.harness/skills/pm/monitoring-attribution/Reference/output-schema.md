# Output Schema and File Structure

> Extracted from SKILL.md. Output schema JSON and output file tree for anomaly attribution analysis.

## Output Schema

```json
{
  "type": "object",
  "required": ["alert_id", "root_cause", "impact_scope", "remediation"],
  "properties": {
    "alert_id": {"type": "string", "description": "Alert ID, linked to monitoring-alert-detection output"},
    "timestamp": {"type": "string", "description": "Attribution analysis time"},
    "alert_validation": {"type": "object", "description": "Alert authenticity confirmation, including is_real/confidence/validation_checks"},
    "root_cause": {"type": "object", "description": "Root cause analysis, including 5 Why chain, summary, category, and confidence"},
    "candidate_root_causes": {"type": "array", "description": "Candidate root cause ranking list, output when root cause is uncertain"},
    "impact_scope": {"type": "object", "description": "Impact scope, including level, affected users, features, and business metrics"},
    "impact_trend": {"type": "object", "description": "Impact trend, including trend direction and growth rate"},
    "remediation": {"type": "object", "description": "Remediation suggestions, including immediate action list and estimated resolution time"},
    "long_term_fixes": {"type": "array", "description": "Long-term fix plan list"},
    "needs_human_escalation": {"type": "boolean", "description": "Whether human escalation is needed"},
    "postmortem_suggestion": {"type": "object", "description": "Retrospective suggestions, including trigger condition, scope, and action items"},
    "report_id": {"type": "string", "description": "Attribution report unique identifier"},
    "generated_at": {"type": "string", "description": "Generation time"}
  }
}
```

## Output File Structure

```
├── monitoring-attribution.json
├── monitoring-attribution.md
├── anomaly/
│   ├── ALT-001/
│   │   ├── alert_validation.md
│   │   ├── root_cause.md
│   │   ├── impact_assessment.md
│   │   ├── remediation.md
│   │   └── needs_human_escalation.yaml
│   └── attribution_summary.md
└── postmortem/
    └── ALT-001/
        └── postmortem_report.md
```
