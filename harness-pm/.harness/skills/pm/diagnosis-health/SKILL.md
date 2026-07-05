---
name: diagnosis-health
description: Used when diagnosing product health. Automated product health diagnosis, collecting multi-dimensional data for comprehensive scoring, trend prediction, and bottleneck identification, outputting a health report.
---
# Automated Product Health Diagnosis 🤖

## When to use
- Is the product healthy right now
- Help me do a health check
- How is the product status
- Keywords: health score, product diagnosis, multi-dimensional scoring, health check, product health, health rating, product physical exam, how is the status

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/monitoring/diagnosis-report.md

## Outputs
- docs/monitoring/diagnosis-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Health is a leading indicator not a lagging report**: The purpose of health scoring is not to record the past, but to predict the future—discovering hidden risks before users perceive problems
2. **Tiered scoring independent tracking**: Performance/availability/satisfaction/business four tiers scored independently, ensuring each tier can be independently located and tracked
3. **Bottlenecks determine resource allocation**: The ultimate goal of health diagnosis is to identify bottlenecks; resources go where the bottlenecks are

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Performance data | JSON | Yes | APM/monitoring system → performance data | Response time, throughput, resource utilization |
| Availability data | JSON | Yes | Monitoring system → availability data | SLA achievement rate, MTTR, MTBF |
| User satisfaction | JSON | Yes | Feedback system → satisfaction data | NPS, CSAT, feedback, complaints |
| Business metrics | JSON | Yes | Data analytics platform → business metrics | Conversion rate, GMV, DAU/MAU, retention |
| Competitor dynamics | JSON | ○ | docs/monitoring/diagnosis-report.md ("Competitor Diagnosis" section) | Competitor health comparison data |

## Execution Steps

### Step 1: Data Collection Standardization [Core]

**Goal**: Collect and standardize data across dimensions

**Data source mapping**:

| Dimension | Data Source | Collection Method |
|------|--------|----------|
| Performance | APM/monitoring system | API/export |
| Availability | Monitoring system/incident management | API/export |
| Satisfaction | Feedback system/survey tools | API/export |
| Business | Data analytics platform | SQL/API |

**Standardization processing**:
- Time alignment (unified to the same time window)
- Metric normalization (0-100 or 0-1 range)
- Outlier handling (removal/smoothing)
- Missing value imputation (interpolation/mean)

**Output format**:

```yaml
raw_data:
  collected_at: 2026-06-15T10:00:00Z
  time_window:
    start: 2026-06-08T00:00:00Z
    end: 2026-06-15T00:00:00Z
  dimensions:
    performance:
      metrics: {...}
    availability:
      metrics: {...}
    satisfaction:
      metrics: {...}
    business:
      metrics: {...}
  data_quality:
    completeness: 95%
    accuracy: 98%
    freshness: 5
```

### Step 2: Dimension Scoring [Core]

**Goal**: Calculate scores for each health dimension

**Scoring methods**:

| Dimension | Metric Weights | Scoring Algorithm |
|------|----------|----------|
| Performance | Response time 40%, Throughput 30%, Resources 30% | Baseline deviation scoring |
| Availability | SLA 50%, MTTR 25%, Failure frequency 25% | Target achievement scoring |
| Satisfaction | NPS 40%, CSAT 30%, Complaint rate 30% | Industry benchmark scoring |
| Business | Conversion rate 30%, Retention 30%, GMV 40% | Trend period-over-period scoring |

**Scoring formula**:

```
score = Σ(metric_weight × metric_score)
metric_score = min(100, (actual / baseline) × 100)
```

**Output format**:

```yaml
scores_by_dimension:
  performance:
    score: 85
    trend: improving | stable | declining
    metrics:
      - name: response_time_p95
        value: 120ms
        baseline: 150ms
        score: 125
  availability:
    score: 92
    trend: stable
    metrics:
      - name: sla_achievement
        value: 99.9%
        target: 99.95%
        score: 99.5
  satisfaction:
    score: 78
    trend: declining
    metrics:
      - name: nps
        value: 35
        benchmark: 40
        score: 87.5
  business:
    score: 88
    trend: improving
    metrics:
      - name: conversion_rate
        value: 4.2%
        baseline: 4.0%
        score: 105
```

### Step 3: Trend Prediction [Core]

**Goal**: Predict future health trends based on historical data

**Analysis methods**:
- Moving Average (MA)
- Exponential Smoothing (Holt-Winters)
- Trend Extrapolation (linear/polynomial regression)

**Prediction dimensions**:
- 7-day trend prediction
- 30-day trend prediction
- Seasonality analysis (if applicable)

**Output format**:

```yaml
trend_analysis:
  prediction_horizon: 7d | 30d
  overall_trend:
    direction: up | down | stable
    change_rate: -2%
    confidence: 88%
  dimension_trends:
    - dimension: performance
      current: 85
      predicted_7d: 83
      predicted_30d: 80
      risk_alert: true | false
```

### Step 4: Bottleneck Identification [Core]

**Goal**: Identify key bottlenecks affecting overall health

**Analysis methods**:
- Dimension weighted contribution analysis
- Period-over-period/year-over-year anomaly detection
- Competitor benchmarking analysis

**Bottleneck grading**:

| Level | Definition | Response Requirement |
|------|------|----------|
| P0 | Severely threatens business metrics | Immediate handling |
| P1 | Significantly impacts user experience | Handle this week |
| P2 | Hidden risks exist | Plan to handle |
| P3 | Optimization items | Continuous follow-up |

**Output format**:

```yaml
bottlenecks:
  - id: BOT-001
    dimension: satisfaction
    severity: P1
    description: "NPS declining for 3 consecutive weeks"
    root_cause: "Payment flow conversion rate decline"
    impact_score: 8
    affected_metrics: [nps, conversion_rate]
    recommendation: "Optimize payment flow"
```

### Step 5: Comprehensive Report [Core]

**Goal**: Generate a comprehensive health diagnosis report

**Report structure**:
1. Executive Summary (Overall Score + Key Findings)
2. Detailed Scoring by Dimension
3. Trend Analysis
4. Bottleneck List
5. Improvement Recommendations

## Progressive-Disclosure Guidance
The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Decision Rules

| Scenario | Decision Rule |
|------|----------|
| Dimension score < 60 | Mark red alert, generate dedicated diagnosis |
| Dimension score 60-75 | Mark yellow alert, include in improvement plan |
| Dimension score > 85 | Mark green, maintain monitoring |
| Predicted trend declining | Generate preventive recommendations |
| Data missing > 30% | Mark data quality issue, skip dimension scoring |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Data collection completeness ≥ 90%
- [ ] Scoring calculation accuracy (sample validation)

### P1 Checks (must pass for standard/deep)

- [ ] Trend prediction deviation ±10%
- [ ] Bottleneck identification coverage ≥ 90%
- [ ] Recommendation executability ≥ 80%
- [ ] Report generation timeliness (< 5 minutes)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Performance data | User provides response time, throughput, and other key performance metric values, AI scores directly | Performance dimension direct scoring result, lacks automated collection data |
| Availability data | User provides SLA achievement rate, failure count, and other metrics, AI scores directly | Availability dimension direct scoring result, lacks automated collection data |
| User satisfaction | User provides NPS/CSAT scores and complaint rate data, AI scores directly | Satisfaction dimension direct scoring result, lacks automated collection data |
| Business metrics | User provides conversion rate, GMV, DAU/MAU, retention, and other metrics, AI scores directly | Business dimension direct scoring result, lacks automated collection data |
| Competitor dynamics | Skip competitor benchmarking, bottleneck identification based only on own data | Health report without competitor benchmarking |

### Data Acquisition Notes

When upstream files are missing, obtain necessary data through the following methods:

1. **Multi-dimensional data missing**: Ask user to provide key metric values for each dimension, AI will score dimensions directly based on user-provided data, skipping automated collection and standardization steps
2. **Partial dimension missing**: Only score dimensions with data, missing dimensions marked as "insufficient data", overall score calculated only based on available dimensions with confidence labeled
3. **Competitor dynamics missing**: Skip competitor benchmarking analysis, bottleneck identification relies only on own data trends and threshold judgments, recommend supplementing competitor data later to improve analysis

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| report_id | string | Yes | Report unique identifier |
| overall_score | number | Yes | Overall health score, range 0-100 |
| score_trend | string | Yes | Score trend, only improving/stable/declining allowed |
| scores_by_dimension | object | Yes | Scores by dimension, must contain performance/availability/satisfaction/business |
| trend_analysis | object | No | Trend prediction, must contain predicted_change_7d/predicted_change_30d |
| bottlenecks | array | No | Bottleneck list, each item must contain id/severity/dimension |
| bottlenecks[].severity | string | Yes | Severity, only P0/P1/P2/P3 allowed |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| APM/monitoring system | Performance metric definition change | Performance dimension scoring and baseline comparison | Recalculate scores per new definition |
| Monitoring system | Availability data format change | Availability dimension scoring | Adapt to new format, supplement missing fields |
| Feedback system | Satisfaction metric change | Satisfaction dimension scoring | Update scoring algorithm and weights |
| Data analytics platform | Business metric definition change | Business dimension scoring and trend prediction | Recalculate scores and predictions per new definition |

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| diagnosis-orchestrator | Health diagnosis completed | Output file updated | Diagnosis completion status and key bottlenecks |
| monitoring-attribution | Health score anomaly | Write to output file | Anomalous dimensions and bottleneck details |
| iteration-retrospective | P0/P1 bottleneck identified | Write to output file | Bottleneck description and improvement recommendations |
