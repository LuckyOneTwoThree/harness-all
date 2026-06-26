---
name: decision-culture
description: Use when you need to drive a team's data-driven decision culture. Data culture automation, driving the implementation of data-driven decision culture through an automated reporting system of daily, weekly, monthly, and quarterly reports. Ensures the team always makes decisions based on data. Keywords: data culture, data-driven, decision culture, data literacy, reporting system, get teams to make decisions with data, build data habits, regular data report delivery.
---
# Data Culture Automation

## When to use
- Team doesn't habitually look at data, how to drive change
- Help me build a data-driven culture
- Set up regular data report delivery

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/metrics/decision-report.md

## Outputs
- docs/metrics/decision-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **No disturbance without anomalies**: The value of reports lies in signal-to-noise ratio, not quantity; noisy reports kill data culture
2. **Rhythm becomes habit**: Daily/weekly/monthly/quarterly automated rhythm transforms data-driven from "requirement" to "habit"
3. **Action-oriented**: Every report must have clear next steps; reports without action recommendations are data dumps
4. **Metrics-driven decision standards**: All decisions must follow a standardized decision process, ensuring decisions are traceable and reviewable

## Metrics-driven Decision Standards

### Decision Types and Required Data

| Decision Type | Required Data | Data Source |
|---------|---------|---------|
| Feature priority adjustment | Feature usage rate, retention impact, ROI estimate | Data analysis platform, experiment results |
| Resource allocation decision | Module ROI, business objective progress, bottleneck analysis | Financial data, product data, engineering data |
| Release timing decision | Experiment results, current metric status, risk assessment | Experiment platform, monitoring system |
| Experiment stop decision | Statistical significance, p-value, confidence interval, business impact | Experiment analysis platform |

### Decision Process

```
1. Clarify the decision objective
2. Collect required data
3. Analyze data and draw conclusions
4. Evaluate alternative options
5. Make a decision and record it
6. Follow up on decision results and review
```

### Decision Record Template

> See [Reference/examples.md](./Reference/examples.md) for the Decision Record Template YAML example.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| OKR Data | object | Yes | docs/metrics/decision-report.md ("DACE Decisions" section) | Objectives and Key Results, progress tracking data |
| Decision Records | object | Yes | docs/metrics/decision-report.md ("DACE Decisions" section) | Team historical decisions and data support status |
| Team Feedback | object | ○ | User-provided | Report usage rate, data literacy assessment |

## Execution Steps

### Execution Rhythm

```
┌─────────────────────────────────────────────────────────┐
│                   Data Culture Rhythm                     │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  Daily      Anomaly detection → Daily summary (no disturbance without anomalies)  │
│  │                                                        │
│  ▼                                                        │
│  Weekly     Feature Review → Experiment summary → Weekly report  │
│  │                                                        │
│  ▼                                                        │
│  Monthly    Complete report → OKR tracking → Monthly Review  │
│  │                                                        │
│  ▼                                                        │
│  Quarterly  Metrics system review → Strategic Review (human-led)  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### Daily Rhythm

#### Anomaly Detection (Automated) [Core]

```
Executed hourly
├── Core metrics health check
├── Anomaly detection
└── If anomaly detected: trigger alert
```

#### Daily Summary (No disturbance without anomalies) [Core]

> See [Reference/examples.md](./Reference/examples.md) for the Daily Summary YAML example.

### Weekly Rhythm

#### Monday: Feature Review [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Weekly Feature Review YAML example.

#### Mid-week: Experiment Summary [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Weekly Experiment Summary YAML example.

#### Friday: Weekly Report [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Weekly Report YAML example.

### Monthly Rhythm

#### Monthly OKR Tracking [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Monthly OKR Review YAML example.

#### Monthly Complete Report [Conditional]

> See [Reference/examples.md](./Reference/examples.md) for the Monthly Report YAML example.

### Quarterly Rhythm

#### Quarterly Metrics System Review [Deep]

> See [Reference/examples.md](./Reference/examples.md) for the Quarterly Metrics Review YAML example.

#### Quarterly Strategic Review (Human-led) [Deep]

```
Human-led quarterly review
├── Review Q1 objective completion
├── Set Q2 strategic direction
├── Adjust OKR system
└── Determine priority experiments
```

## Automated Report Configuration

> See [Reference/examples.md](./Reference/examples.md) for the Automated Report Configuration YAML example.

## Team Data Culture Metrics

> See [Reference/examples.md](./Reference/examples.md) for the Team Data Culture Metrics YAML example.

## Output Validation Rules

> See [Reference/schema.md](./Reference/schema.md) for the Output Validation Rules table.

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| OKR data change | OKR tracking section | Update OKR progress, re-evaluate deviation analysis |
| Decision record change | Data culture metrics | Update data-driven decision rate, re-evaluate culture health |
| Team feedback change | Report template and delivery strategy | Adjust report format and delivery timing |

When culture reports themselves change, the notification mechanism for downstream:

| Report Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| OKR progress behind >20% | decision-dace | Mark progress risk, trigger DACE Conclude |
| Data-driven decision rate decline | All downstream | Mark culture risk, trigger training recommendations |
| Report engagement decline | decision-culture | Mark engagement issue, trigger report optimization |

---

## Decision Rules

| Situation | Handling |
|------|----------|
| Core metric anomaly (↓>5%) | Immediate alert delivery, trigger focused analysis |
| OKR progress behind >20% | Annotate risk in weekly report, recommend strategy adjustment |
| Data-driven decision rate <70% | Deliver data culture training recommendations |
| Report open rate consistently declining | Optimize report format and delivery timing |

## Quality Check

- [ ] Daily summary produces no noisy alerts when no anomalies exist (P0)
- [ ] Weekly report includes OKR progress and experiment summary (P1)
- [ ] Monthly report includes complete metric trends and deviation analysis (P1)
- [ ] All data references in reports are traceable to data sources (P0)
- [ ] Quarterly review includes metrics system health assessment (P2)
- [ ] Strategic review includes culture maturity score (P2)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Analysis module outputs missing | User provides key metrics → Generate summary report | Report content based on user-provided metrics, lacks automated analysis depth |
| Anomaly detection output missing | Daily summary uses user-provided metric data | Daily report may miss unattended anomalies |
| Experiment results output missing | Experiment summary section in weekly report annotated "to be supplemented" | Experiment progress tracking missing |
| All analysis module outputs missing | User provides key metrics → Generate summary report | Output basic summary report, analysis dimensions annotated "to be supplemented" |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Key metrics**: Core metric names and current values to track
- **Metric targets** (optional): Target values and baselines for each metric
- **Team focus areas** (optional): Current business issues the team is most concerned about

## Output

> See [Reference/schema.md](./Reference/schema.md) for the Output JSON Schema and Output File Structure.

## Culture Promotion Principles

| Principle | Description |
|-----|------|
| No disturbance without anomalies | Reduce noise, only disturb when needed |
| Data consistency | All reports use the same data source |
| Action-oriented | Every report must have clear next steps |
| Continuous iteration | Optimize report format based on feedback |
| Transparency | Everyone can see the data |
