# monitoring-alert-detection Schema & Decision Tables

> This document is split from the monitoring-alert-detection SKILL.md and contains the output JSON schema, output file structure, output validation rules, and decision rules table.

## Output Schema

```json
{
  "type": "object",
  "required": ["metrics", "alert_id", "classification", "dashboards", "report_id", "alerts", "oncall_schedule"],
  "properties": {
    "metrics": {"type": "array", "description": "Monitoring metric config list, including name, category, threshold, and baseline"},
    "alert_policies": {"type": "object", "description": "Alert policy config"},
    "suppression_rules": {"type": "object", "description": "Convergence rule config"},
    "alert_id": {"type": "string", "description": "Alert ID"},
    "timestamp": {"type": "string", "description": "Alert time"},
    "classification": {"type": "object", "description": "Alert classification, including layer, category, and confidence"},
    "correlation": {"type": "object", "description": "Correlation analysis, including correlation type, related alerts, and correlation score"},
    "dashboards": {"type": "array", "description": "Dashboard config list, including role, title, and widgets"},
    "report_id": {"type": "string", "description": "Report unique identifier"},
    "generated_at": {"type": "string", "description": "Generation time"},
    "alerts": {"type": "array", "description": "Alert list, including severity, escalation level, and actions taken"},
    "oncall_schedule": {"type": "object", "description": "On-call arrangement, including current and next on-call info"},
    "oncall_reports": {"type": "array", "description": "On-call reports, including alert count, SLA compliance rate, and average resolution time"}
  }
}
```

## Output File Structure

```
├── monitoring-alert-detection.json
├── monitoring-alert-detection.md
├── core_paths.md
├── metrics/
│   ├── availability/
│   │   └── alert_rule.yaml
│   ├── latency/
│   │   └── alert_rule.yaml
│   ├── error_rate/
│   │   └── alert_rule.yaml
│   └── [custom_metrics]/
│       └── alert_rule.yaml
├── alert_policies.yaml
├── suppression_rules.yaml
├── oncall_handbook.md
├── anomaly/
│   ├── ALT-001/
│   │   ├── classification.md
│   │   └── correlation.md
│   └── escalation_queue.md
├── dashboards/
│   ├── executive/
│   │   └── business_overview.yaml
│   ├── shared/
│   │   ├── alert_dashboard.yaml
│   │   └── system_health_dashboard.yaml
│   └── templates/
│       └── dashboard_template.yaml
├── escalation/
│   ├── alerts/
│   │   └── 2026-06-15/
│   │       ├── ALT-001/
│   │       │   ├── severity.yaml
│   │       │   ├── escalation_chain.yaml
│   │       │   └── notification_status.yaml
│   │       └── escalation_summary.yaml
│   ├── oncall_schedule/
│   │   └── 2026-W24.yaml
│   └── oncall_reports/
│       └── 2026-06-15.yaml
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| core_paths | array | Yes | Core path list, at least 1 path |
| core_paths[].path_name | string | Yes | Path name |
| metrics | object | Yes | Monitoring metric config, grouped by path |
| alert_policies | array | Yes | Alert policy list, at least 1 rule |
| suppression_rules | array | No | Suppression rule list |
| oncall_handbook | object | No | On-Call handbook, must contain escalation_paths/emergency_procedures |
| classification | object | Yes | Alert classification, must contain alert_type/severity/service |
| classification.severity | string | Yes | Severity, only P0/P1/P2/P3 allowed |
| correlation | object | No | Correlation analysis, must contain is_correlated/related_alerts |
| dashboard_config | object | Yes | Dashboard config, must contain role/panels |
| dashboard_config.role | string | Yes | Role name |
| dashboard_config.panels | array | Yes | Panel list, at least 1 panel |
| shared_views | object | No | Shared view config |
| templates | array | No | Template list |
| alert_classification | object | Yes | Alert severity grading, must contain alert_id/severity/category |
| alert_classification.severity | string | Yes | Severity, only Critical/High/Medium/Low allowed |
| escalation_chain | array | Yes | Escalation chain, at least 1 level |
| notification_records | array | No | Notification records, each item must contain channel/recipient/status |
| oncall_report | object | No | On-call report, must contain total_alerts/resolved_count |

## Decision Rules

| Scenario | Decision Rule |
|------|----------|
| Metric coverage < 80% | Mark warning, prompt to supplement metrics, list missing core metrics |
| Metric coverage 80%-95% | Mark notice, recommend supplementing non-core metrics |
| Threshold conflict (same metric ≥ 2 alert rules) | Keep the rule with highest severity, mark others as duplicate and disable |
| Insufficient baseline data (< 7 days historical data) | Use static threshold as fallback, mark "needs data supplementation, auto-switch to dynamic baseline after 7 days" |
| New service added | Auto-inherit basic alert template (CPU ≥ 80%, memory ≥ 85%, error rate ≥ 1%), prompt for dedicated config |
| P0 service alert missing | Force supplement golden signal alerts, cannot skip |
| Alert noise rate ≥ 15% | Auto-tighten thresholds by 10%, mark for human review |
| Alert storm (≥ 5 alerts/5 minutes) | Merge into single alert, mark primary cause, suppress related alerts |
| Impact scope expanding (affected user growth ≥ 20%/10 minutes) | Auto-escalate severity by 1 level (up to P0) |
| Impact scope expanding (affected user growth 5%-20%/10 minutes) | Auto-escalate severity by 1 level |
| Too many metrics | Auto-group, collapse low priority |
| Too many alerts | Show only unresolved alerts |
| Slow page load | Lazy-load low-priority components |
| Role change | Auto-adjust metric config |
| Metric has no data | Show "No Data" status |
| Critical without ACK | Escalate to L2 after 5 minutes |
| Repeated identical alerts | Merge notifications, avoid spamming |
| On-Call no response | Escalate to Manager |
| High false positive rate | Feedback to adjust thresholds |
| Escalation timeout | Auto-notify emergency contact |
