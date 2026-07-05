# analysis-anomaly — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output


**Output File Path**: `docs/metrics/data-analysis-report.md ("Anomaly Analysis" section)`
**Output Schema**:

```json
{
  "type": "object",
  "required": ["metric_name", "current_value", "severity", "attribution"],
  "properties": {
    "metric_name": {"type": "string", "description": "Anomalous metric name"},
    "current_value": {"type": "number", "description": "Current value"},
    "expected_range": {"type": "array", "description": "Expected range"},
    "deviation": {"type": "string", "description": "Deviation degree"},
    "severity": {"type": "string", "description": "Severity: P0/P1/P2/P3"},
    "attribution": {"type": "object", "description": "Attribution info, including authenticity judgment, related events, and recommended actions"},
    "trend_chart_url": {"type": "string", "description": "Trend chart URL"},
    "raw_data_url": {"type": "string", "description": "Raw data URL"}
  }
}
```

```yaml
anomaly_report:
  timestamp: "2024-01-15T10:30:00Z"

  # Basic info
  metric_name: "dau_conversion_rate"
  current_value: 12.3
  expected_range: [15.0, 20.0]
  deviation: -27%

  # Severity
  severity: "P1"  # P0/P1/P2/P3

  # Attribution info
  attribution:
    is_real: true
    scope:
      affected_users: 150000
      affected_platforms: ["iOS", "Android"]
      affected_features: ["Homepage Recommendation"]
      duration: "ongoing"

    related_events:
      - type: "product_release"
        name: "v2.5.0 Release"
        time: "2024-01-15T08:00:00Z"
        confidence: 0.85
      - type: "marketing_campaign"
        name: "New Year Promotion"
        time: "2024-01-14T00:00:00Z"
        confidence: 0.3

    most_likely_cause: |
      Homepage recommendation algorithm changes in v2.5.0,
      causing recommendation content to match user interests less well

    confidence: 0.85

    evidence:
      - "Anomaly occurred within 2 hours of version release"
      - "iOS and Android both declined, excluding client-side issues"
      - "Outside activity hours, excluding marketing impact"

    recommended_action: |
      1. Immediately check v2.5.0 homepage recommendation algorithm changes
      2. If cannot be located within 2 hours, prepare rollback
      3. Prepare A/B test to validate hypothesis

    needs_human_confirmation: true

  # Auxiliary info
  trend_chart_url: "docs/metrics/data-analysis-report.md (\"Anomaly Analysis\" section)"
  raw_data_url: "docs/metrics/data-analysis-report.md (\"Anomaly Analysis\" section)"
```

### Storage Path

All anomaly analysis content is written to `docs/metrics/data-analysis-report.md ("Anomaly Analysis" section)`, no subdirectories created.

### Configuration Example

```yaml
# Metric anomaly detection configuration
anomaly_detection:
  core_metrics:
    - name: "dau"
      threshold_type: "absolute"
      min_value: 1000000
      max_value: null
      alert_on: "below"

    - name: "dau_conversion_rate"
      threshold_type: "statistical"
      std_multiplier: 3
      min_change_pct: 5
      alert_on: "both"

    - name: "revenue_daily"
      threshold_type: "relative"
      vs_last_week_pct: -15
      alert_on: "below"

  notification:
    channels:
      - type: "slack"
        url: "${SLACK_WEBHOOK}"
      - type: "phone"
        for_severity: ["P0"]
```
