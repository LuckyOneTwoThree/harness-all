---
name: metrics-dashboard
description: Use when configuring a product metrics Dashboard. Dashboard Auto-Configuration designs Dashboard structure based on metric hierarchy, auto-assigns metrics to each Dashboard, and configures alert rules and thresholds. Keywords: Dashboard configuration, data dashboard, metric visualization, alert configuration, monitoring panel, dashboard setup, data report.
---
# Dashboard Auto-Configuration

## When to use
- Help me build a data dashboard
- Configure a monitoring panel
- Create a Dashboard showing all key metrics

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/metrics/dashboard.md
- dashboard_config.json

## Core Principles

1. **Full Analysis**: Systematically analyze all available data without missing key dimensions
2. **Real-time Awareness**: Metrics system design supports real-time monitoring and rapid response
3. **Automated Attribution**: Anomaly fluctuations are automatically attributed to specific causes, reducing manual investigation
4. **Explicit Decision Rules**: Every alert and escalation condition has clear quantitative rules

## Interaction Mode

🤖→👤 AI Suggests, Human Approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| metric_system | JSON | Yes | docs/metrics/metrics-system.md | Metrics system (including North Star, L1/L2/actionable metrics) |
| tracking_plan | JSON array | Yes | docs/metrics/tracking-plan.md | Tracking plan |
| user_roles | string[] | ○ | User-provided | Dashboard user roles |
| dashboard_platform | string | ○ | User-provided | Visualization platform (amplitude/grafana/datadog) |

```json
{
  "metric_system": {
    "north_star": {...},
    "l1_metrics": [...],
    "l2_metrics": [...],
    "actionable_metrics": [...]
  },
  "tracking_plan": [...],
  "user_roles": ["Product Manager", "Operations", "Management"],
  "dashboard_platform": "amplitude|grafana|datadog"
}
```

---

## Execution Steps

### Step 1: Dashboard Structure Design [Core]

**Task**: Design Dashboard structure based on metric hierarchy

**Rules**:
- Strategic Dashboard (1): Displays North Star metric and L1 metric trends, for management
- Tactical Dashboard (N): Divided by user lifecycle (AARRR) or business line, for PMs
- Operational Dashboard (N): Divided by feature module or team, for specific operators

**Execution**:
1. Design Dashboard count and types based on metric system hierarchy
2. Determine each Dashboard's theme and positioning
3. Plan navigation relationships between Dashboards

---

### Step 2: Metric Auto-Assignment [Core]

**Task**: Auto-assign metrics to each Dashboard

**Rules**:
- North Star metric → Strategic Dashboard
- L1 metrics → Tactical Dashboard
- L2 metrics → Assigned to Tactical or Operational Dashboard based on L1 affiliation
- Actionable metrics → Operational Dashboard

**Execution**:
1. Traverse metric system, assign by hierarchy rules
2. Mark each Widget's data source
3. Determine refresh frequency (Strategic Dashboard: daily, Tactical Dashboard: hourly, Operational Dashboard: per-minute)

---

### Step 3: Alert Rule Configuration [Core]

**Task**: Configure alert rules for key metrics

**Rules**:
- North Star metric: Configure daily period-over-period alert (threshold: ±15%)
- L1 metrics: Configure weekly period-over-period alert (threshold: ±10%)
- Metrics triggered by anomaly detection: Auto-inherit anomaly detection alert configuration

**Execution**:
1. Generate alert rules based on statistical thresholds (mean ± 2σ) or historical baseline
2. Determine alert severity (P0/P1/P2/P3)
3. Configure notification channels and recipients

---

### Step 4: Dashboard Configuration Generation [Core]

**Task**: Generate Dashboard configurations for each platform

**Supported Platforms**:
- Amplitude / Mixpanel / GrowingIO (commonly used domestically)
- Grafana / Datadog (technical monitoring)
- Custom JSON configuration

**Execution**:
1. Generate corresponding configuration format based on target platform
2. Generate Widget definitions (type, position, size)
3. Configure Dashboard layout and theme

---

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Core metric dashboard design | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full dashboard + drill-down analysis design + alert rule system + data governance specs | Full artifact + extended analysis + deep inference |

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Decision Rules

### Auto-Execution Rules
- Metric assignment auto-executes by hierarchy rules
- Alert thresholds configured by default values

### Human Decision Points
- Dashboard layout requires human confirmation (🤖→👤)
- Alert thresholds can be adjusted based on actual conditions
- Dashboard naming and ownership decided by human

### Escalation Rules
- When alert count exceeds 50, prompt to streamline alerts
- When Dashboard count exceeds 10, prompt to merge or archive

---

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] All metrics assigned to Dashboards
- [ ] Each Dashboard has at least 1 Widget

### P1 Checks (standard/deep must pass)

- [ ] North Star metric appears on Strategic Dashboard
- [ ] Alert rules fully configured
- [ ] Dashboard configuration parses correctly
- [ ] Dashboard layout reasonableness
- [ ] Alert threshold setting reasonableness
- [ ] Access permission configuration
- [ ] Navigation structure clarity

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Metrics system missing | Prompt user to provide core metric list, generate basic Dashboard configuration based on metric list | Dashboard hierarchy simplified, no strategic/tactical/operational layering |
| Tracking plan missing | Skip data source marking step, Widget data source marked "pending configuration" | Cannot confirm data collection feasibility |
| Metrics system + Tracking plan both missing | User provides core metric list → generate basic Dashboard configuration | Output basic Dashboard configuration, data source and refresh frequency marked "to be confirmed" |
| user_roles missing | If user does not provide user_roles, prompt user to provide or skip steps related to this input | Dashboard role layering missing, use default role configuration |
| dashboard_platform missing | If user does not provide dashboard_platform, prompt user to provide or skip steps related to this input | Use generic JSON configuration format, platform-specific configuration marked "to be specified" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Core Metric List**: Names and definitions of key metrics to monitor
- **Target User Roles** (optional): Primary Dashboard user roles (Management/PM/Operations)
- **Dashboard Platform** (optional): Visualization platform used (Amplitude/Grafana/Datadog, etc.)

---

## Context Dependencies

- **Depends on Prior Pipelines**: Pipeline 1 (Metrics System Auto-Construction), Pipeline 2 (Tracking Plan Auto-Generation)
- **Consumed by Subsequent Pipelines**: Dashboard monitoring in Module 7 (Product Metrics Operations)

---

## Key Principles

### Data-Driven Visualization
- Select chart types best suited for displaying metric trends
- KPI cards show current value and trend
- Line charts show time series changes

### Alert Layering
- P0: Core metric anomaly, requires immediate handling
- P1: Important metric anomaly, requires same-day handling
- P2: General metric anomaly, requires attention
- P3: Minor deviation, can be ignored

### High Actionability
- Each Dashboard has a clear target user
- Each Widget has a clear data source description
- Each alert has clear handling guidance
