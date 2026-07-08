---
name: data-analysis-report
description: Use when producing a complete data analysis report. Data Insight Report Auto-Generation integrates funnel analysis, retention analysis, anomaly detection, and decision insight data, supplements trend interpretation and action recommendations, and outputs a structured Markdown report.
---
# Data Insight Report Auto-Generation

## When to use
- Help me produce this month's data analysis report
- Summarize the recent data situation
- Generate an operations weekly report
- Keywords: data analysis report, data insight report, operations report, data report, analysis report, produce a data report, help write operations analysis, summarize data situation

## Outputs
- docs/metrics/data-analysis-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Data speaks, insights drive** — Data is the starting point, insight is the endpoint, action is the purpose
2. **Anomalies first** — Anomalies deserve more attention than normal states; anomalies are signals for improvement
3. **Deep attribution** — Don't just say "what", also answer "why"
4. **Actionable conclusions** — Every insight must correspond to an actionable action

## Interaction Mode

🤖→👤 AI Suggests, Human Approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| Funnel Analysis | JSON | ○ | docs/metrics/data-analysis-report.md ("Funnel Analysis" section) | Funnel health, conversion rate, drop-off points |
| Retention Analysis | JSON | ○ | docs/metrics/data-analysis-report.md ("Retention Analysis" section) | Retention curve, churn warning, cohorts |
| Anomaly Detection | JSON | ○ | docs/metrics/data-analysis-report.md ("Anomaly Analysis" section) | Anomalous metrics, attribution, impact scope |
| Decision Insights | JSON | ○ | docs/metrics/decision-report.md ("DACE Decision" section) | Data-driven decision recommendations |
| Metrics System | JSON | ○ | docs/metrics/metrics-system.md | Metric definitions and baselines |
| Analysis Time Range | string | Yes | User-provided | e.g., "2025 Q1", "Last 30 days" |
| Product/Business Info | string | ○ | User-provided | Product name, core business metrics |

## Execution Steps

### Step 1: Data Overview and Core Metrics [Core]

Integrate metrics system and analysis data to generate a data overview:

**Core Metrics Dashboard**:

| Metric | Current Value | Period-over-period | Year-over-year | Trend | Status |
|------|--------|---------|---------|------|------|
| North Star Metric | | | | ↑↓→ | 🟢🟡🔴 |
| Core Conversion Rate | | | | | |
| Retention Rate (D7/D30) | | | | | |
| DAU/MAU | | | | | |
| ARPU | | | | | |

**Data Quality Statement**:
- Data coverage scope
- Data completeness assessment
- Known data biases

### Step 2: Funnel Health Analysis [Core]

Integrate funnel data to generate the funnel analysis section:

**Full-Link Funnel**:
```
Impression → Click → Register → Activate → First Payment → Repurchase
  ↓      ↓      ↓      ↓       ↓         ↓
 95%   45%   32%   68%    25%      40%
```

**Key Findings**:
- Biggest drop-off stage (step with highest drop-off rate)
- Biggest improvement space (step where conversion rate improvement has the largest overall impact)
- Stage with biggest period-over-period change
- Anomaly fluctuation points

**Each Key Finding Includes**:
- Data facts (precise numbers)
- Period-over-period/year-over-year comparison
- Possible causes (at least 2 hypotheses)
- Validation recommendations

### Step 3: Retention and Lifecycle Analysis [Core]

Integrate retention data to generate the retention analysis section:

**Retention Curve Description**:
- Day 1/Day 7/Day 30 retention rates
- Retention curve shape (L-shape/declining/stable)
- Cohorts comparison (retention differences across user batches)

**Lifecycle Stage Partition**:

| Stage | Definition | Proportion | Characteristics |
|------|------|------|------|
| New | 0-3 days after registration | | High activity, high churn risk |
| Growing | 4-14 days | | Feature exploration, habit formation |
| Mature | 15-90 days | | Stable usage, value perception |
| Declining | 90+ days with declining activity | | Decreasing usage frequency |
| Churned | Inactive for N consecutive days | | Needs recall strategy |

**Churn Warning**:
- High-risk user characteristics
- Pre-churn behavior signals
- Recall window period

### Step 4: Anomaly Attribution Analysis [Core]

Integrate anomaly detection data to generate the anomaly analysis section:

**Anomaly Event List**:

| Time | Metric | Anomaly Type | Deviation | Impact Scope | Attribution | Confidence |
|------|------|---------|---------|---------|------|--------|
| | | Spike/Drop/Trend shift | ±X% | Users/Revenue | Internal/External cause | High/Medium/Low |

**Attribution Analysis Framework**:
- Internal causes: Product changes, technical failures, operations activities
- External causes: Market changes, competitor actions, seasonal factors
- Data causes: Statistical bias, data missing, definition changes

### Step 5: Insights and Action Recommendations [Core]

Integrate all analysis data to distill insights and action recommendations:

**Insight Distillation Rules**:
- Each insight = data fact + business implication + action direction
- Insights sorted by business impact

**Action Recommendation Template**:

| Priority | Recommendation | Target Metric | Expected Lift | Implementation Difficulty | Validation Method |
|--------|------|---------|---------|---------|---------|
| P0 | | | | Low/Medium/High | A/B testing/Before-after comparison |
| P1 | | | | | |
| P2 | | | | | |

**Recommendation Categories**:
- Quick Win: Low difficulty, high impact
- Core Optimization: Medium difficulty, high impact
- Long-term Investment: High difficulty, high impact
- Watchlist: Needs more data validation

### Step 6: Report Assembly [Core]

**Report Structure**:

```
# {Product Name} Data Analysis Report ({Time Range})

## output-schema Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/output-schema.md](Reference/output-schema.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| report_metadata | object | Yes | Report metadata |
| report_metadata.product | string | Yes | Product name |
| report_metadata.time_range | string | Yes | Analysis time range |
| report_metadata.data_sources | array | Yes | Data sources list |
| report_metadata.data_quality | string | Yes | Data quality statement |
| executive_summary | object | Yes | Executive summary |
| executive_summary.key_findings | array | Yes | Key findings list, at least 3 |
| executive_summary.top_recommendation | string | Yes | Top recommendation |
| funnel_analysis | object | No | Funnel analysis section |
| retention_analysis | object | No | Retention analysis section |
| anomaly_analysis | object | No | Anomaly analysis section |
| insights | array | Yes | Insight list, at least 1 |
| insights[].id | string | Yes | Insight ID |
| insights[].fact | string | Yes | Data fact |
| insights[].implication | string | Yes | Business implication |
| insights[].action_direction | string | Yes | Action direction |
| recommendations | array | Yes | Recommendation list, at least 3 |
| recommendations[].id | string | Yes | Recommendation ID |
| recommendations[].priority | string | Yes | Priority, enum: P0/P1/P2 |
| recommendations[].validation_method | string | Yes | Validation method |

## Upstream Change Response

When upstream inputs change, this skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Funnel analysis data update | Funnel analysis section | Update funnel data, re-evaluate drop-off points and improvement opportunities |
| Retention analysis data update | Retention analysis section | Update retention data, re-evaluate lifecycle and churn warning |
| Anomaly detection data update | Anomaly analysis section | Update anomaly events and attribution, re-evaluate insights |
| Decision insight update | Insights and recommendations sections | Update insights and recommendations, mark for human confirmation |
| Metrics system change | Core metrics dashboard | Update metric definitions and baselines, re-evaluate data overview |

When analysis report itself changes, the notification mechanism to downstream:

| Report Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| P0 recommendation added | decision-dace | Mark P0 recommendation, trigger DACE Conclude |
| Key finding change | decision-culture | Mark finding change, trigger report push |
| Data quality statement change | All downstream | Mark quality change, trigger data source check |

---

## Decision Rules

| Condition | Decision |
|------|------|
| Only funnel data available | Focus on funnel analysis, retention and anomaly sections marked "lacking data" |
| Only retention data available | Focus on retention and lifecycle, funnel section marked "lacking data" |
| No anomaly data | Skip anomaly analysis section, mark "no anomaly detection data" |
| All analysis data missing | Generate framework report based on product info and AI knowledge, mark "lacking empirical data" |
| Time range > 1 year | Recommend splitting into quarterly reports |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Executive summary contains 3 key findings + Top 1 recommendation
- [ ] Core metrics dashboard complete

### P1 Checks (standard/deep must pass)

- [ ] Funnel analysis includes biggest drop-off point and improvement opportunity
- [ ] Retention analysis includes lifecycle stages
- [ ] Each insight has data fact + business implication
- [ ] At least 3 action recommendations, each with priority and validation method
- [ ] Data definitions and limitations explained

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| funnel_analysis missing | Funnel section marked "lacking funnel data" | Missing conversion analysis |
| retention_analysis missing | Retention section marked "lacking retention data" | Missing lifecycle analysis |
| anomaly_analysis missing | Skip anomaly analysis section | Missing anomaly attribution |
| decision-dace missing | Action recommendations derived from data analysis | Recommendations may not be deep enough |
| metrics-system missing | Core metrics based on user-provided info | Metric definitions may be incomplete |
- If user does not provide analysis time range, prompt user to provide or skip steps related to this input
- If user does not provide product/business info, prompt user to provide or skip steps related to this input
