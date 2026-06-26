# decision-culture Schema

> This document is split from the decision-culture SKILL.md and contains the output JSON schema, output file structure, and output validation rules.

## Output Schema

```json
{
  "type": "object",
  "required": ["report_type", "report_date", "key_metrics"],
  "properties": {
    "report_type": {"type": "string", "description": "Report type: daily/weekly/monthly/quarterly"},
    "report_date": {"type": "string", "description": "Report date"},
    "key_metrics": {"type": "array", "description": "Key metrics list, including name, current value, and change trend"},
    "anomalies": {"type": "array", "description": "Anomaly metrics list"},
    "action_items": {"type": "array", "description": "Action items list"},
    "engagement_stats": {"type": "object", "description": "Report engagement statistics"}
  }
}
```

## Output File Structure

```
docs/metrics/decision-report.md ("Data Culture" section)
├── culture/
│   ├── daily/
│   │   └── {date}_daily_summary.md
│   ├── weekly/
│   │   └── {week}_weekly_report.md
│   ├── monthly/
│   │   └── {month}_monthly_report.md
│   └── quarterly/
│       └── {quarter}_quarterly_report.md
├── dashboards/
│   ├── daily_dashboard.yaml
│   └── metrics_overview.yaml
└── engagement/
    └── report_analytics.yaml
```

Output files: {date}_daily_summary.md, {week}_weekly_report.md, {month}_monthly_report.md, {quarter}_quarterly_report.md, daily_dashboard.yaml, metrics_overview.yaml, report_analytics.yaml

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| report_type | string | Yes | Report type, enum values: daily/weekly/monthly/quarterly |
| report_date | string | Yes | Report date |
| key_metrics | array | Yes | Key metrics list, at least 1 item |
| key_metrics[].name | string | Yes | Metric name |
| key_metrics[].value | number | Yes | Current value |
| key_metrics[].change | string | Yes | Change trend |
| key_metrics[].status | string | Yes | Status, enum values: healthy/warning/critical |
| anomalies | array | No | Anomaly metrics list |
| action_items | array | Yes | Action items list |
| action_items[].description | string | Yes | Action description |
| action_items[].owner | string | No | Owner |
| action_items[].deadline | string | No | Deadline |
| engagement_stats | object | No | Report engagement statistics |
