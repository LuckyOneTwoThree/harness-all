---
name: revenue-nrr
description: Use when tracking Net Revenue Retention. NRR Auto-Tracking and Early Warning Pipeline automatically calculates NRR, analyzes NRR trends, identifies churn warnings, and identifies expansion revenue opportunities.
---
# NRR Auto-Tracking and Early Warning

## When to use
- How to calculate Net Revenue Retention
- How are existing customer renewals doing
- How to view revenue retention trends
- Keywords: NRR, Net Revenue Retention, revenue retention, churn warning, expansion revenue, renewal rate, existing customer revenue, is revenue growing or declining

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md
- nrr_analysis.json

## Core Principles

1. **NRR is the revenue health thermometer**: NRR >100% means the product is self-growing; NRR <100% means the product is self-consuming
2. **Expansion is as important as churn**: Improving NRR requires both reducing churn and proactively identifying expansion opportunities
3. **Signal-driven, not cycle-driven**: Trigger actions based on risk signals and expansion signals, not waiting for monthly reports

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| Revenue data | object | Yes | User-provided | MRR, ARR, revenue details |
| User account data | object | Yes | User-provided | Payment status, product configuration |
| User behavior data | object | ○ | User-provided | Usage data, interaction data |

## NRR Definition and Calculation

### NRR (Net Revenue Retention)
NRR is the most important metric for measuring revenue health, reflecting the change in revenue contribution from existing customers during the reporting period.

```
NRR = (Starting revenue - Churned revenue + Expansion revenue) / Starting revenue

Where:
- Starting revenue: MRR at period start
- Churned revenue: Revenue lost due to churn
- Expansion revenue: Revenue gained from add-ons and price increases
```

### NRR Interpretation
| NRR Range | Meaning | Assessment |
|--------|------|------|
| NRR ≥ 120% | Excellent | Very strong revenue retention and expansion capability |
| NRR ≥ 110% | Good | Healthy growth, sustainable |
| NRR ≥ 100% | Passing | Barely retaining, needs improvement |
| NRR < 100% | Dangerous | Revenue continuously churning |

## Execution Steps

### Step 1: NRR Auto-Calculation [Core]

#### Revenue Data Processing
1. Calculate starting revenue: Beginning-of-month MRR
2. Calculate ending revenue: End-of-month MRR
3. Identify revenue change details:
   - New revenue (new paying customers)
   - Expansion revenue (add-ons, upgrades, price increases)
   - Contraction revenue (downgrades, reduced usage)
   - Churned revenue (churned, cancelled)

#### NRR Formula Implementation
```python
nrr = (start_mrr - churned_mrr + expansion_mrr) / start_mrr
```

#### Multi-dimensional Calculation
- Calculate NRR by user segment
- Calculate NRR by product line
- Calculate NRR by user scale
- Calculate NRR by industry

### Step 2: NRR Trend Analysis [Core]

#### Trend Metrics
| Metric | Description |
|------|------|
| Monthly NRR | NRR per month |
| Quarterly NRR | NRR per quarter |
| Annual rolling NRR | 12-month rolling NRR |
| NRR acceleration | NRR change trend |

#### Trend Analysis
- NRR month-over-month change
- NRR year-over-year change
- NRR breakdown analysis (expansion/contraction/churn ratio changes)

#### Predictive Analysis
Based on historical trends, predict future NRR:
- Optimistic forecast
- Baseline forecast
- Pessimistic forecast

### Step 3: Churn Warning [Core]

#### Churn Risk Signals
| Signal Type | Specific Signal | Risk Weight |
|---------|---------|---------|
| Activity signal | Usage frequency decline | High |
| Feature signal | Core feature usage reduction | High |
| Financial signal | Payment delay | High |
| Organizational signal | Key contact departure | Medium |
| Feedback signal | Negative feedback / NPS decline | Medium |
| Competitor signal | Signs of competitor usage | Low |

#### Risk User Tiering
| Risk Level | Definition | Response Strategy |
|---------|------|---------|
| Very high risk | Multiple churn signals + high value | Immediate intervention |
| High risk | Obvious churn signals | Intervene within 3 days |
| Medium risk | Some churn signals | Intervene within 1 week |
| Low risk | Minor churn signals | Continuous monitoring |

#### Churn Warning Trigger
```yaml
warning_rules:
  - condition: "usage_decline > 50% AND payment_delayed == true"
    level: "critical"
    action: "immediate_escalation"

  - condition: "usage_decline > 30%"
    level: "high"
    action: "customer_success_outreach"

  - condition: "nps_score < 6"
    level: "medium"
    action: "feedback_followup"
```

### Step 4: Expansion Opportunity Identification [Core]

#### Expansion Signals
| Signal Type | Specific Signal | Expansion Potential |
|---------|---------|---------|
| Usage signal | Usage reaches limit | High |
| Frequency signal | High-frequency use of core features | High |
| Collaboration signal | Team collaboration feature usage increase | Medium |
| Feature signal | Advanced feature usage increase | Medium |
| Need signal | Proactively asks for higher tier | High |

#### Expansion Opportunity Scoring
```python
expansion_score = (
    usage_intensity * 0.4 +
    feature_adoption * 0.3 +
    team_growth * 0.2 +
    engagement_score * 0.1
)
```

#### Expansion Strategy Recommendation
| Expansion Type | Trigger Condition | Recommended Strategy |
|---------|---------|---------|
| Upgrade | Usage reaches limit | Upgrade guidance + discount |
| Add-on | Team size expansion | Seat add-on recommendation |
| Extension | New business need | New product line recommendation |

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | NRR analysis and retention strategy | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + customer health score + churn prediction model + expansion opportunity identification | Full artifact + extended analysis + deep reasoning |

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Decision Rules

| Situation | Action |
|------|----------|
| NRR <100% | Trigger revenue churn alert, recommend emergency intervention |
| Churn risk signals ≥2 | Customer success intervention within 3 days |
| Expansion score >0.7 | Proactively recommend upgrade or add-on |
| NRR declines for 3 consecutive months | Trigger strategic-level review |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] NRR calculation includes expansion, contraction, and churn components
- [ ] Churn warning covers activity, feature, financial, and organizational 4 signal types

### P1 Checks (must pass for standard/deep)

- [ ] Expansion opportunity identification has scoring and recommendation strategy
- [ ] Multi-dimensional NRR calculation covers user segments and product lines

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| Revenue data missing | User provides revenue and churn data → calculate NRR | NRR calculation based on summary data provided by user | Require user to provide beginning-of-month MRR, expansion MRR, contraction MRR, churned MRR |
| Account data missing | Skip account-level NRR analysis, calculate only overall NRR | Cannot identify high churn risk accounts | Require user to provide paying account list, payment status, and product configuration info |
| User behavior data missing | Skip behavior-driven churn signal analysis, warn only based on revenue and account data | Churn warning lacks behavioral dimension, prediction precision reduced | Require user to provide user activity, feature usage frequency, and interaction data |
| Revenue data + account data both missing | User provides revenue and churn data → calculate NRR | Output basic NRR calculation, account-level analysis marked "pending supplement" | Require user to provide revenue summary data and customer tier distribution |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **Revenue data**: Beginning-of-month MRR, expansion MRR, contraction MRR, churned MRR
- **Churn data** (optional): Churned customer count and churned MRR
- **Customer tiering** (optional): Customer distribution by scale or value

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| User-provided - revenue data | MRR definition change | NRR calculation and trend analysis | Recalculate NRR per new definition |
| User-provided - account data | Payment status change | Churn warning and expansion opportunities | Update risk scores and expansion signals |
| User-provided - behavior data | Usage metric change | Churn signals and expansion signals | Update signal weights and trigger rules |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| revenue-upsell | Expansion opportunity change | Write to output file | New expansion opportunities and upgrade recommendations |
| revenue-funnel | NRR data update | Write to output file | NRR trends and payment conversion baseline |
| revenue-orchestrator | NRR tracking complete | Output file updated | NRR tracking completion status and key conclusions |

## Key Success Metrics

| Metric | Definition | Target Value |
|------|------|--------|
| NRR | Net Revenue Retention | ≥115% |
| Churn rate | Monthly churned MRR / beginning-of-month MRR | ≤3% |
| Expansion rate | Monthly expansion MRR / beginning-of-month MRR | ≥10% |
| Contraction rate | Monthly contraction MRR / beginning-of-month MRR | ≤2% |
| At-risk revenue ratio | High-risk user MRR / total MRR | ≤10% |
