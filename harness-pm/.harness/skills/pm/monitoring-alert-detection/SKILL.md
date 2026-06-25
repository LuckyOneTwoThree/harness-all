---
name: monitoring-alert-detection
description: Used when monitoring product metrics and detecting anomalies. Monitoring alert detection tool responsible for data collection, threshold monitoring, anomaly detection, and alert generation. Keywords: monitoring, alert, anomaly detection, threshold, data collection.
---
# Monitoring Alert Detection 🤖

## When to use
- Set up monitoring system
- Configure alert rules
- Metric anomaly detection
- How to monitor core paths

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/metrics/metrics-system.md
- docs/monitoring/monitoring-config.md
- docs/monitoring/release-notes.md

## Outputs
- docs/monitoring/monitoring-config.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **The starting point of a monitoring system is core paths, not metric piling**: First identify core business paths, then configure metrics and alerts for those paths; avoid monitoring everything yet missing the critical
2. **Alert rules are a balance between signal and noise**: Too many alerts equals no alerts; every alert must be worth human attention
3. **The On-Call handbook is the last mile of the monitoring system**: A monitoring system without an On-Call handbook is incomplete; an alert that rings with no one knowing how to handle it equals no monitoring
4. **Dashboards serve roles, not data**: Different roles focus on different metrics; dashboards must be customized by role
5. **Escalation is protection, not buck-passing**: The purpose of escalation is to get the right people involved at the right time, not to shirk responsibility

## Basic Information

- **Skill type**: pipeline
- **Module**: Product Monitoring & Iteration / Monitoring & Alerting
- **Version**: 2.0
- **Interaction mode**: 🤖 AI auto-execution (system configuration type)
- **Upstream Skills**: metrics-system (metrics system), release-gradual (release info)
- **Downstream Skill**: monitoring-attribution (anomaly attribution analysis consumes this Skill's anomaly detection output)

## Interaction Mode

🤖 AI auto-execution (system configuration type)

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Product architecture | JSON/file | Yes | User-provided | System architecture diagram, component relationships, dependency chains |
| Metrics system | JSON | Yes | docs/metrics/metrics-system.md | Business and technical metric definitions to monitor |
| SLA requirements | JSON | Yes | User-provided | Availability, response time, throughput requirements |
| Existing monitoring | JSON | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Existing monitoring config and alert rules |
| Release info | object | ○ | docs/monitoring/release-notes.md ("Canary Plan" section) | Recent release records |
| Config change records | object | ○ | User-provided | Configuration modification history |
| Traffic change data | object | ○ | User-provided | Traffic trends and anomaly fluctuations |
| User roles | string[] | Yes | User-provided | Roles needing Dashboard access |
| Existing Dashboard | JSON | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Existing Dashboard config (if any) |
| On-Call schedule | JSON | Yes | On-call management system → schedule | On-call schedule and contact info |
| Knowledge base | JSON | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Issue handling guides and historical cases |

## Execution Steps

### Step 1: Monitoring System Establishment [Core]

**Goal**: Establish a core path monitoring system, configure metric collection and alert rules

#### 1.1 Core Path Identification [Core]

**Method**:
- Analyze architecture docs to extract service components
- Identify the main user request path
- Map inter-service dependencies
- Flag single points of failure risk

**Output**: Core path list, including entry service → core service → data layer → external dependencies

#### 1.2 Metric-Alert Rule Generation [Core]

**Metric Types**:
- Golden signals: latency, traffic, errors, saturation
- Business metrics: conversion rate, order volume, DAU/MAU
- Custom metrics: specific business events

**Alert Rule Configuration**:

| Rule Type | Generation Method | Parameter Source |
|----------|----------|----------|
| Static threshold | Fixed value + SLA requirements | SLA/SLO definitions |
| Historical baseline | Statistical historical data | 7d/30d mean/standard deviation |
| Dynamic threshold | Trend analysis + anomaly detection | Prediction interval |
| Composite alert | Multi-metric combination logic | Business rules |

**Alert Parameters**:

```yaml
alert_rule:
  name: api_response_time_p95_alert
  severity: critical | high | medium | low
  threshold:
    operator: > | < | >= | <=
    value: 2000
  baseline:
    method: historical | moving_average | seasonal
    window: 7d | 30d | custom
    deviation: 3σ
  sensitivity: high | medium | low
  evaluation_interval: 1m
  for: 5m
```

#### 1.3 Alert Convergence Rules [Conditional]

**Convergence Strategies**:
- Alert grouping: Aggregate by service/component/time window
- Alert suppression: Parent-child alert relationships, high priority suppresses low priority
- Silence rules: Auto-silence during maintenance windows
- Dedup rules: Merge identical alert notifications

#### 1.4 On-Call Handbook Generation [Deep]

**Handbook Content**:
- Problem description
- Self-check checklist
- Common causes
- Quick fix steps
- Escalation conditions
- Related document links

### Step 2: Anomaly Detection [Conditional]

**Goal**: Detect metric anomalies in real time, identify trend shifts and sudden fluctuations, generate alert events

> **Scope Boundary Note**: This step is only responsible for anomaly identification, alert classification, and correlation analysis. Identified anomalies are output to monitoring-attribution for attribution analysis (root cause localization, impact assessment, remediation suggestions).

#### 2.1 Alert Classification [Conditional]

**Classification Dimensions**:

| Category | Subcategory | Characteristics |
|------|------|------|
| System layer | Infrastructure | CPU/Memory/Disk/Network |
| System layer | Container | Pod/Container restart/Resource limits |
| System layer | Middleware | Database/Cache/Message queue |
| Application layer | Service response | Timeout/Connection failure/Resource exhaustion |
| Application layer | Error exceptions | Exception stack/Business exceptions |
| Business layer | Business metrics | Conversion rate/Order volume/Payment failure |
| Business layer | User behavior | DAU anomaly/Feature usage anomaly |
| External layer | Third-party services | API timeout/Return error |
| External layer | CDN/DNS | Access anomaly/Certificate issues |

**Output**:

```yaml
classification:
  layer: system | application | business | external
  category: database
  confidence: 0.0-1.0
  related_alerts: [ALT-001, ALT-002]
```

#### 2.2 Correlation Analysis [Conditional]

**Analysis Methods**:
- Time window correlation (alert times are close)
- Service topology correlation (same service chain)
- Metric fluctuation correlation (anomalies occur simultaneously)
- Change event correlation (triggered after release/config change)

**Output**:

```yaml
correlation:
  is_correlated: true | false
  correlation_type: time | topology | metrics | change
  related_alerts: [ALT-001, ALT-002]
  correlation_score: 0.0-1.0
  root_alert: ALT-001 | null
```

### Step 3: Dashboard Configuration [Conditional]

**Goal**: Build visualization dashboards aggregating key metrics and alert status

#### 3.1 Role Perspective Determination [Conditional]

**Role Categories**:

| Role | Focus | Refresh Rate | Detail Level |
|------|--------|----------|----------|
| Executive | Business health, overall status | Low | Summary |
| Product Owner | Feature status, user metrics | Medium | Overview |
| Engineering Lead | System status, alerts | High | Detailed |
| On-Call Engineer | Current alerts, issue diagnosis | Real-time | Detailed |
| Business Analyst | Business metrics, conversion funnel | Medium | Business |

**Role Requirement Mapping**:

```yaml
role_requirements:
  - role: executive
    focus_areas:
      - business_health
      # ... same structure extensible
    alert_preference: critical_only
    refresh_rate: 15m
  # ... same structure extensible
```

#### 3.2 Core Metric Grouping [Conditional]

**Grouping Strategy**:

| Group Type | Description | Example |
|----------|------|------|
| Business view | Core business metrics | Order volume, conversion rate, DAU |
| Technical view | System technical metrics | CPU, memory, latency |
| Alert view | Current alerts and events | Active alerts, historical events |
| Service view | Grouped by service/component | User service, order service |

**Metric Grouping Output**:

```yaml
metric_groups:
  - group_id: GRP-001
    group_name: Core Business Metrics
    role: executive
    metrics:
      - metric_name: api_response_time_p95
        data_source: apm
        visualization: time_series
      # ... same structure extensible
    priority: high | medium | low
    refresh_interval: 15
```

#### 3.3 Visualization Component Selection [Deep]

**Component Types**:

| Component Type | Applicable Metrics | Characteristics |
|----------|----------|------|
| Time Series | Trend metrics | Shows changes over time |
| Gauge | Status metrics | Shows current value/target |
| Stat | Single value | Quick overview |
| Table | List data | Detailed data display |
| Alert List | Alert data | Real-time alert status |
| Heatmap | Distribution metrics | Shows distribution patterns |

**Component Config**:

```yaml
widget_config:
  - widget_id: WDG-001
    widget_type: time_series | gauge | stat | table | alert_list | heatmap
    title: API Response Time Trend
    metrics:
      - name: api_response_time_p95
        aggregation: avg | sum | max | min
    visualization:
      color_scheme: green_yellow_red | blue | custom
      thresholds:
        warning: 1000
        critical: 2000
      time_range: 1h | 6h | 24h | 7d | custom
    layout:
      width: 1 | 2 | 4 | 6 | 12
      height: 1 | 2 | 3
      position: 1_2
```

#### 3.4 Dashboard Template Generation [Deep]

**Template Structure**:

```yaml
dashboard_template:
  - dashboard_id: DASH-001
    role: executive
    title: Business Overview
    description: Business health view for senior management
    widgets:
      - widget_id: WDG-001
        widget_type: stat
        title: Today's Order Volume
        metrics:
          - name: daily_orders
            data_source: business_db
        layout:
          width: 3
          height: 1
      # ... same structure extensible
    filters:
      - filter_type: time_range
        default: 7d
      # ... same structure extensible
    refresh_interval: 15m
```

### Step 4: Alert Escalation [Conditional]

**Goal**: Alert severity grading and escalation handling, ensuring critical alerts reach responsible parties in time

#### 4.1 Auto Severity Grading [Conditional]

**Grading Model**:

```yaml
alert_severity:
  critical:
    criteria:
      - service_availability < 99%
      - error_rate > 5%
      - response_time_p99 > 5000ms
      - affected_users > 10000
    response_time_sla: 5 minutes
  high:
    criteria:
      - service_availability < 99.5%
      - error_rate > 1%
      - response_time_p99 > 2000ms
      - affected_users > 1000
    response_time_sla: 15 minutes
  medium:
    criteria:
      - service_availability < 99.9%
      - error_rate > 0.5%
      - response_time_p99 > 1000ms
    response_time_sla: 1 hour
  low:
    criteria:
      - non_functional_metrics
      - warning_thresholds
    response_time_sla: next_business_day
```

**Grading Output**:

```yaml
alert_classification:
  alert_id: ALT-001
  original_severity: high
  assessed_severity: critical
  confidence: 85%
  factors:
    - factor: service_impact
      contribution: 0.8
    # ... same structure extensible
  adjusted: true | false
  adjustment_reason: Affected users exceed 10,000, escalated to critical
```

#### 4.2 Escalation Chain Trigger [Conditional]

**Escalation Rules**:

```yaml
escalation_rules:
  - rule_id: ESC-001
    trigger:
      severity: critical
      duration: 5 minutes
      not_acknowledged: true
    escalation_chain:
      - level: 1
        recipients: [oncall_primary]
        notification_channels: [sms, call, slack]
      # ... same structure extensible
  # ... same structure extensible
```

**Escalation Execution Output**:

```yaml
escalation_chain:
  alert_id: ALT-001
  current_level: 1
  escalation_history:
    - timestamp: 2026-06-15T10:05:00Z
      level: 1
      action: initial_notification
      recipients: [Zhang San]
      status: sent | delivered | acknowledged
  next_escalation:
    timestamp: 2026-06-15T10:10:00Z
    level: 2
    trigger_reason: Not acknowledged within 5 minutes, escalating to L2
```

#### 4.3 Notification Sending [Conditional]

**Notification Channels**:

| Channel | Applicable Severity | Content Format |
|------|----------|----------|
| SMS | Critical, High | Brief summary + link |
| Phone Call | Critical | Voice broadcast + confirmation |
| Slack | All | Detailed card + actions |
| Email | Medium, Low | Full report |
| PagerDuty | All | Standard format |

**Notification Template**:

```yaml
notification:
  channels:
    - channel: sms
      content: |
        [CRITICAL] Order Service
        Response time P99 exceeds 5 seconds, affecting 5,000 users
        Details: https://monitor.example.com/alerts/ALT-001
    # ... same structure extensible
```

**Send Status**:

```yaml
notification_status:
  alert_id: ALT-001
  notifications:
    - channel: sms
      recipient: 13800138000
      status: sent | delivered | failed
      sent_at: 2026-06-15T10:05:00Z
    # ... same structure extensible
  acknowledgment:
    required: true | false
    acknowledged_by: Zhang San
    acknowledged_at: 2026-06-15T10:08:00Z
```

#### 4.4 On-Call Report [Deep]

**Report Content**:

```yaml
oncall_report:
  period:
    start: 2026-06-08T00:00:00Z
    end: 2026-06-15T00:00:00Z
  oncall_engineer:
    name: Li Si
    primary: true
  summary:
    total_alerts: 24
    critical: 2
    high: 5
    medium: 10
    low: 7
  response_metrics:
    average_acknowledgment_time: 3
    average_resolution_time: 45
    sla_compliance: 95%
  top_alerts:
    - alert_id: ALT-001
      severity: critical
      title: Order service response timeout
      acknowledged_at: 2026-06-15T10:08:00Z
      resolved_at: 2026-06-15T10:45:00Z
  unresolved_alerts:
    - alert_id: ALT-018
      severity: medium
      reason: Pending root cause confirmation, transferred to backend team
  action_items:
    - description: Optimize database connection pool config
      owner: Wang Wu
      deadline: 2026-06-20
```

## Output

**Output File Path**: `docs/monitoring/monitoring-config.md ("Alert Rules" section)`

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Core path monitoring + basic alert rules | Core conclusions + minimum viable artifact, only outputs Step 1.1-1.2 core paths and alert rules |
| standard | Full monitoring system (current default) | Full artifact, including all Step 1-4 outputs |
| deep | Full system + extended analysis | Full artifact + capacity planning + chaos engineering plan + SRE maturity assessment + decision records + risk assessment |

**Output Schema**:

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

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Core path coverage ≥ 95%
- [ ] Each core path has at least 4 golden signals
- [ ] Alert rules have no conflicts or omissions
- [ ] SLA requirements have corresponding metric support

### P1 Checks (must pass for standard/deep)

- [ ] Alert noise rate < 15%
- [ ] All P0 services have On-Call handbooks
- [ ] Alert classification accuracy ≥ 85%
- [ ] Escalation marks have no omissions
- [ ] All roles have corresponding Dashboards
- [ ] Core metric coverage ≥ 90%
- [ ] Alert config correct
- [ ] Alert severity accuracy ≥ 90%
- [ ] Escalation trigger timeliness 100%
- [ ] Notification delivery rate ≥ 99%
- [ ] SLA response time met
- [ ] Escalation chain config correct

### P2 Checks (only deep must pass)

- [ ] Visualization component selection reasonable
- [ ] Layout aesthetic, clear hierarchy
- [ ] Refresh rate matches role needs
- [ ] On-call report completeness 100%
- [ ] Capacity planning output (resource utilization forecast, scaling thresholds, capacity redundancy assessment)
- [ ] Chaos engineering plan generated (fault injection scenarios, blast radius assessment, recovery verification plan)
- [ ] SRE maturity assessment completed (five-dimensional scoring: monitoring/alerting/response/postmortem/automation)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Metrics system | User provides core business metric list, supplement golden signals based on generic metric template | Basic monitoring metric config, lacks metrics system support |
| Product architecture | User provides service component list, infer dependencies based on generic microservice architecture | Basic core path list, dependencies are inferred |
| SLA requirements | User provides availability targets for key services, use industry default thresholds (99.9%/99.5%/99%) | Alert rules based on default thresholds |
| Existing monitoring | Skip compatibility check, generate monitoring config from scratch | Brand-new monitoring config |
| Release info | Skip change correlation analysis, mark "cannot exclude change factors" in anomaly detection | Detection results excluding change correlation |
| Config change records | Skip config change correlation, mark "cannot exclude config change factors" in anomaly detection | Detection results excluding config correlation |
| Traffic change data | Skip traffic analysis dimension, mark traffic data missing in anomaly detection | Detection results missing traffic dimension |
| User roles | Use default role template (Executive/Engineering/On-Call), user adjusts later | Generic role Dashboard template |
| Existing Dashboard | Generate Dashboard config from scratch, mark potential conflicts with existing config | Brand-new Dashboard config |
| On-Call schedule | User provides current on-call contact info, AI configures escalation chain based on this | Escalation chain based on user input |
| Alert rules | Use default escalation rules (Critical 5min/High 15min/Medium 1h), mark for human confirmation | Escalation config based on default rules |
| Knowledge base | On-Call handbook does not include historical case references, mark "no historical cases" | On-Call handbook without historical references |

### Data Acquisition Notes

When upstream files are missing, obtain necessary data through the following methods:

1. **Metrics system missing**: Ask user to provide core business metric list (e.g., order volume, conversion rate, DAU, etc.); AI will auto-supplement generic golden signals (latency, traffic, error rate, saturation) based on product type
2. **Product architecture missing**: Ask user to provide service component list or system name list; AI will infer service dependencies based on generic architecture patterns, and mark inferred items for human confirmation in output
3. **SLA requirements missing**: Ask user to provide availability targets for key services (e.g., "Payment service needs 99.9% availability"); services not specified use industry default standards, with default values marked in output for human review
4. **Alert data missing**: Ask user to describe anomaly phenomena, including: symptom manifestations, occurrence time, affected services/features, impact scope (user count/feature points); AI will classify anomalies based on the description
5. **Context data missing** (release/config change/traffic change): AI will explicitly mark factors that cannot be excluded in anomaly detection, recommending manual investigation of these dimensions
6. **User roles missing**: Use default role template to generate Dashboards, including three standard views: Executive overview, Engineering details, On-Call real-time; user can adjust based on actual role needs
7. **On-Call schedule missing**: Ask user to provide current on-call personnel names and contact info (phone/Slack/email); AI will configure escalation notification chain based on this
8. **Alert rules missing**: Use default escalation rule template (Critical→5min→L1/L2/L3, High→15min→L1/L2); mark default rules in output for human review and confirmation

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

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| metrics-system | Metric definition change | Monitoring metric config and alert rules | Update metric mapping and alert thresholds |
| User-provided - Product architecture | Architecture change | Core paths and service dependencies | Re-identify core paths and dependency chains |
| User-provided - SLA | SLA target change | Alert thresholds and grading criteria | Adjust alert rules and escalation conditions |
| release-gradual | Release record update | Change correlation analysis | Update correlation events and anomaly detection |
| User-provided - Roles | Role requirement change | Dashboard layering and panel layout | Redesign role views |
| On-call management system | Schedule change | Notification recipients and escalation chain | Update On-Call schedule and notification config |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| monitoring-orchestrator | Monitoring alert detection complete | Output file update | Build completion status and key config |
| monitoring-attribution | Anomaly alert triggered | Output file update | Anomaly event list, alert classification, and correlation analysis results |
| iteration-backlog-grooming | P0 alert triggered | Write to output file | Emergency alert and escalation details |
