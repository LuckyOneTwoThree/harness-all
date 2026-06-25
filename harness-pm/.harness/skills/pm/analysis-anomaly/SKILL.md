---
name: analysis-anomaly
description: Use when automatically detecting and attributing metric anomalies. Automated Data Analysis Engine, AI auto-executes 24/7 operation, responsible for metric health checks, anomaly detection, automated attribution, and insight push. Outputs a complete anomaly report when metric anomalies are detected. Keywords: anomaly detection, data analysis, automated attribution, metric monitoring, anomaly report, metric anomaly, data anomaly, anomaly alert, data has issues, metric suddenly dropped, data fluctuation. This skill is suitable for offline anomaly analysis scenarios, not for real-time monitoring.
---
# Automated Data Analysis Engine

## When to use
- DAU suddenly dropped 30% today, help me check the cause
- Metric anomaly alert, help me with attribution analysis
- Data fluctuation is too large, see what went wrong

## Outputs
- docs/metrics/data-analysis-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Anomalies deserve more attention than normal states**: Every anomaly is a signal for improvement; 24/7 uninterrupted detection ensures nothing is missed
2. **Attribution is more important than detection**: Discovering anomalies is only the starting point; the four-step attribution method (authenticity → scope → correlation → conclusion) converts anomalies into actions
3. **Tiered alerts, not one-size-fits-all**: P0 instant push + phone, P1 within 2 hours, P2 daily summary, P3 record only; rules front-loaded to reduce noise

## Interaction Mode

🤖 AI Auto-Execution (Data Analysis Type)

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| Metrics System | JSON | Yes | docs/metrics/metrics-system.md | List and definitions of core metrics to monitor |
| Real-time Data Stream | JSON | Yes | User-provided (real-time metric snapshot exported from data platform) | Metric time series data, field requirements: metric_name, timestamp, value, expected_range |
| Alert Rules | JSON | Yes | User-provided | Threshold configuration for various metric anomalies |
| Event Calendar | JSON | ○ | User-provided | External events such as product changes, operations activities, market events |

## Execution Steps

### Step 1: Hourly Core Metric Health Check [Core]

```
Execute hourly on schedule
├── Get current values of all core metrics
├── Calculate year-over-year (same period last week), period-over-period (last hour) changes
├── Compare against preset thresholds and historical fluctuation range
└── Mark metrics requiring attention
```

### Step 2: Anomaly Detection [Core]

| Detection Method | Description |
|---------|------|
| Statistical Threshold | Set upper/lower limits based on historical data (e.g., ±3σ) |
| Trend Deviation | Significant deviation from historical trend |
| Period-over-period Anomaly | Large fluctuation compared to recent data |
| Year-over-year Anomaly | Significant change compared to same period last year |

### Step 3: Automated Attribution [Core]

Four-step anomaly auto-attribution:

```
1. Confirm Authenticity
   ├── Exclude data latency issues
   ├── Exclude data pipeline failures
   ├── Exclude statistical noise (natural fluctuation)
   └── Confirm as real anomaly

2. Locate Scope
   ├── How many users affected
   ├── Which features/pages affected
   ├── Which platforms/channels affected
   └── How long it lasts

3. Correlate External Events
   ├── Product changes (version releases, feature flags)
   ├── Operations activities (promotions, pushes, popups)
   ├── Market events (competitor actions, trending events)
   └── Environmental factors (holidays, weather, emergencies)

4. Generate Attribution Conclusion
   ├── Most likely cause (most_likely_cause)
   ├── Confidence (confidence)
   ├── Supporting evidence (evidence)
   └── Recommended action (recommended_action)
```

### Step 4: Insight Push [Core]

Push based on anomaly severity:

- **P0 (Critical)**: Instant push + phone alert
- **P1 (Important)**: Notification within 2 hours
- **P2 (General)**: Daily summary
- **P3 (Info)**: Record only

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Anomaly diagnosis and root cause | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + root cause inference chain + impact scope assessment + prevention mechanism design | Full artifact + extended analysis + deep inference |

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

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| anomaly_report | object | Yes | Anomaly report root object |
| anomaly_report.metric_name | string | Yes | Anomalous metric name |
| anomaly_report.current_value | number | Yes | Current value |
| anomaly_report.expected_range | array | Yes | Expected range, [min, max] |
| anomaly_report.deviation | string | Yes | Deviation degree |
| anomaly_report.severity | string | Yes | Severity, enum: P0/P1/P2/P3 |
| anomaly_report.attribution | object | Yes | Attribution info |
| anomaly_report.attribution.is_real | boolean | Yes | Whether it is a real anomaly |
| anomaly_report.attribution.scope | object | Yes | Impact scope |
| anomaly_report.attribution.most_likely_cause | string | Yes | Most likely cause |
| anomaly_report.attribution.confidence | number | Yes | Confidence, 0-1 |
| anomaly_report.attribution.recommended_action | string | Yes | Recommended action |
| anomaly_report.attribution.needs_human_confirmation | boolean | Yes | Whether human confirmation needed |
| anomaly_report.trend_chart_url | string | No | Trend chart URL |
| anomaly_report.raw_data_url | string | No | Raw data URL |

## Upstream Change Response

When upstream inputs change, this skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Metrics system change | Monitoring metric list and thresholds | Update monitoring metric list, reload alert rules, mark for human confirmation |
| Alert rule change | Anomaly detection thresholds and push strategy | Reload alert rules, update detection parameters |
| Event calendar change | External events for attribution correlation | Update event correlation data, re-evaluate attribution of unconfirmed anomalies |
| Data source change | Data acquisition and calculation logic | Update data source config, validate data completeness |

When anomaly report itself changes, the notification mechanism to downstream:

| Report Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| P0/P1 anomaly added | decision-dace, data-analysis-report | Mark anomaly added, trigger insight conversion |
| Attribution conclusion change | decision-dace | Mark attribution change, trigger DACE Conclude |
| Severity level escalation | All downstream | Mark level escalation, trigger corresponding alert strategy |

---

## Decision Rules

| Condition | Action |
|-----|--------|
| P0 anomaly (core metric ↓ > 10%) | Instant push + phone alert + auto-create Incident |
| P1 anomaly (metric ↓ 3-10%) | Push within 2 hours + Slack notification |
| P2 anomaly (metric ↓ 1-3%) | Daily summary |
| P3 fluctuation (metric ↓ < 1%) | Record, continuous monitoring |
| Requires human confirmation | Send confirmation request, wait for response |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Anomaly detection covers all key metrics
- [ ] Anomaly severity classified correctly (P0/P1/P2)

### P1 Checks (standard/deep must pass)

- [ ] Root cause analysis supported by data
- [ ] Recommended actions are actionable

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Metrics system missing | Prompt user to provide metric data and anomaly description, perform attribution analysis based on description | Anomaly detection scope based on user description, may miss unmonitored metrics |
| Real-time data stream missing | User provides metric data and anomaly description → attribution analysis based on description | Cannot auto-detect anomalies, depends on user proactive discovery |
| No real-time data | Analyze based on historical anomaly reports and user-provided subjective descriptions, confidence ≤ 0.3 | Attribution conclusion confidence low, requires human verification |
| Metrics system + Real-time data stream both missing | User provides metric data and anomaly description → attribution analysis based on description | Output attribution analysis report based on description, marked "to be verified" |

- If user does not provide alert rules, prompt user to provide or skip steps related to this input
- If user does not provide event calendar, prompt user to provide or skip steps related to this input

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Metric Data**: Anomalous metric name, current value, baseline value, change magnitude
- **Anomaly Description**: Observed anomaly phenomenon and occurrence time
- **Recent Changes** (optional): Possibly related product changes or operations activities

### Execution Frequency

- **Normal Operation**: Executes once per hour
- **During P0 Anomaly**: Updates status every 15 minutes
- **Routine Report**: Generates daily report at 8:00
