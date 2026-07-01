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

## Mode Boundary

> **PM owns product analytics alerts; Ops owns system observability; Growth owns growth experimentation attribution.**
>
> | Alert Type | Owner | Scope |
> |------------|-------|-------|
> | Product metric anomaly (DAU drop, conversion rate decline) | PM (this skill) | Business metric thresholds |
> | Infrastructure alert (CPU, memory, latency, uptime) | Ops | System health |
> | Experiment attribution (A/B test significance) | Growth | Growth experimentation |
>
> **Boundary**: This skill produces product-level alert rules (business metric thresholds + notification config). It does NOT configure infrastructure monitoring dashboards or SLO alerting rules.

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

> See [Reference/examples.md](./Reference/examples.md) for the Alert Rule Parameters YAML example.

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

> See [Reference/examples.md](./Reference/examples.md) for the Alert Classification Output YAML example.

#### 2.2 Correlation Analysis [Conditional]

**Analysis Methods**:
- Time window correlation (alert times are close)
- Service topology correlation (same service chain)
- Metric fluctuation correlation (anomalies occur simultaneously)
- Change event correlation (triggered after release/config change)

> See [Reference/examples.md](./Reference/examples.md) for the Correlation Analysis Output YAML example.

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

> See [Reference/examples.md](./Reference/examples.md) for the Role Requirement Mapping YAML example.

#### 3.2 Core Metric Grouping [Conditional]

**Grouping Strategy**:

| Group Type | Description | Example |
|----------|------|------|
| Business view | Core business metrics | Order volume, conversion rate, DAU |
| Technical view | System technical metrics | CPU, memory, latency |
| Alert view | Current alerts and events | Active alerts, historical events |
| Service view | Grouped by service/component | User service, order service |

> See [Reference/examples.md](./Reference/examples.md) for the Metric Grouping Output YAML example.

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

> See [Reference/examples.md](./Reference/examples.md) for the Visualization Component Config YAML example.

#### 3.4 Dashboard Template Generation [Deep]

> See [Reference/examples.md](./Reference/examples.md) for the Dashboard Template Structure YAML example.

### Step 4: Alert Escalation [Conditional]

**Goal**: Alert severity grading and escalation handling, ensuring critical alerts reach responsible parties in time

#### 4.1 Auto Severity Grading [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Alert Severity Grading Model and Grading Output YAML examples.

#### 4.2 Escalation Chain Trigger [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Escalation Rules and Escalation Execution Output YAML examples.

#### 4.3 Notification Sending [Conditional]

**Notification Channels**:

| Channel | Applicable Severity | Content Format |
|------|----------|----------|
| SMS | Critical, High | Brief summary + link |
| Phone Call | Critical | Voice broadcast + confirmation |
| Slack | All | Detailed card + actions |
| Email | Medium, Low | Full report |
| PagerDuty | All | Standard format |

> See [Reference/examples.md](./Reference/examples.md) for the Notification Template and Send Status YAML examples.

#### 4.4 On-Call Report [Deep]

> See [Reference/examples.md](./Reference/examples.md) for the On-Call Report YAML example.

## Output

**Output File Path**: `docs/monitoring/monitoring-config.md ("Alert Rules" section)`

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Core path monitoring + basic alert rules | Core conclusions + minimum viable artifact, only outputs Step 1.1-1.2 core paths and alert rules |
| standard | Full monitoring system (current default) | Full artifact, including all Step 1-4 outputs |
| deep | Full system + extended analysis | Full artifact + capacity planning + chaos engineering plan + SRE maturity assessment + decision records + risk assessment |

> See [Reference/schema.md](./Reference/schema.md) for the Output JSON Schema, Output File Structure, Output Validation Rules, and Decision Rules table.

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

> See [Reference/degradation-strategy.md](./Reference/degradation-strategy.md) for the Upstream File Missing Degradation Plan table and Data Acquisition Notes.

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
