# metrics-dashboard — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

**Storage Path**: `docs/metrics/dashboard.md`

**Output File**: `dashboard_config.json`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["dashboards", "configuration_files"],
  "properties": {
    "dashboards": {"type": "array", "description": "Dashboard configuration list, including strategic/tactical/operational dashboards"},
    "configuration_files": {"type": "object", "description": "Platform configuration files, including platform type and Dashboard JSON configuration"}
  }
}
```

```json
{
  "dashboards": [
    {
      "name": "Strategic Dashboard",
      "type": "strategic",
      "owner": "Product Owner",
      "widgets": [
        {
          "type": "kpi",
          "metric": "north_star_metric",
          "visualization": "number_with_trend",
          "refresh_interval": "daily"
        },
        {
          "type": "chart",
          "metric": "l1_metrics",
          "visualization": "line_chart",
          "refresh_interval": "daily"
        }
      ],
      "alerts": [
        {
          "metric": "north_star_metric",
          "condition": "daily_change",
          "threshold": 0.15,
          "severity": "P0",
          "notification": "slack:#product-alerts"
        }
      ]
    }
  ],
  "configuration_files": {
    "platform": "amplitude",
    "dashboard_json": {...}
  }
}
```

---

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| dashboards | array | Yes | Dashboard configuration list, must include at least 1 strategic dashboard |
| dashboards[].name | string | Yes | Dashboard name, cannot be empty |
| dashboards[].type | string | Yes | Dashboard type, enum: strategic/tactical/operational |
| dashboards[].owner | string | Yes | Dashboard owner |
| dashboards[].widgets | array | Yes | Widget list, must include at least 1 Widget |
| dashboards[].widgets[].type | string | Yes | Widget type, enum: kpi/chart/table/funnel |
| dashboards[].widgets[].metric | string | Yes | Associated metric name |
| dashboards[].widgets[].visualization | string | Yes | Visualization type |
| dashboards[].widgets[].refresh_interval | string | Yes | Refresh frequency |
| dashboards[].alerts | array | No | Alert rule list |
| dashboards[].alerts[].metric | string | Conditionally required | Alert associated metric, required when alerts present |
| dashboards[].alerts[].threshold | number | Conditionally required | Alert threshold, required when alerts present |
| dashboards[].alerts[].severity | string | Conditionally required | Alert severity, enum: P0/P1/P2/P3 |
| configuration_files | object | Yes | Platform configuration files |
| configuration_files.platform | string | Yes | Platform type |
| configuration_files.dashboard_json | object | Yes | Dashboard JSON configuration |

## Upstream Change Response

When upstream inputs change, this skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| North Star metric change | Strategic Dashboard's KPI Widget and alert rules | Update Strategic Dashboard's core Widget, recalculate alert thresholds, mark for human confirmation |
| L1/L2 metric add/remove | Tactical/Operational Dashboard Widget assignment | Re-execute metric auto-assignment, mark added/removed Widgets, preserve human-confirmed layouts |
| Actionable metric change | Operational Dashboard Widgets and alerts | Update Operational Dashboard, re-evaluate alert configuration |
| Tracking event add/remove | Widget data source marking | Update Widget data source status, mark "pending configuration" or "ready" |
| Metric definition modification | Associated Widget calculation logic | Update Widget display logic, mark for human confirmation |

When Dashboard configuration itself changes, the notification mechanism to downstream:

| Configuration Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Dashboard structure change | Module 7 (Product Metrics Operations) | Mark dashboard structure change, trigger monitoring configuration update |
| Alert rule change | Operations team, Product team | Mark alert change, trigger alert notification configuration update |
| Widget add/remove | Module 7 (Product Metrics Operations) | Mark Widget change, trigger data source validation |

---
