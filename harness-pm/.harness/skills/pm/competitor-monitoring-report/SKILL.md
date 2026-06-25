---
name: competitor-monitoring-report
description: Used when summarizing competitor tracking data into a complete, deliverable monitoring report. Auto-generates competitor monitoring reports including competitor dynamics summary, feature change tracking, market strategy changes, threat assessment, and response recommendations. Keywords: competitor monitoring report, competitor dynamics, feature tracking, threat assessment, competitor response, competitor report, what are competitors doing.
---
# Competitor Monitoring Report Generation

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/discovery/market-analysis.md
- docs/monitoring/diagnosis-report.md

## Outputs
- docs/monitoring/diagnosis-report.md
- memory/progress.md

## Core Principle

**Competitor monitoring is not snooping, but strategic awareness**

The core value of competitor monitoring reports lies in transforming scattered competitor information into structured strategic insights. The purpose of monitoring is not to imitate competitors, but to understand market landscape changes and identify threats and opportunities.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Competitor tracking data | markdown | Yes | diagnosis-competition | Feature changes, advantage/disadvantage changes, response strategies |
| Competitor intelligence | markdown | No | market-competitor-analysis | Competitor dynamics, reputation, pricing |
| Competitor classification | markdown | No | market-competitor-analysis | Four-quadrant classification, competitor positioning |
| Monitoring period | text | No | User input | Time range covered by the report |

### Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact |
|----------|----------|----------|
| No competitor tracking data | Generate report based on competitor intelligence, label "tracking data missing" | Report lacks feature change tracking details |
| No competitor intelligence | Generate framework based on user-provided info, label "pending analysis supplementation" | Report is framework-level, lacks intelligence support |
| No competitor classification | Default to monitoring direct competitors, label "classification pending supplementation" | Only covers direct competitors; indirect/substitute competitors missing |
| No monitoring period | Default to last 30 days, label "period pending confirmation" | Report coverage may be inaccurate |

## Execution Steps

### Step 1: Competitor Dynamics Summary [Core]

Summarize all competitor dynamics within the monitoring period:

1. **Major dynamics**: Funding/M&A/Executive changes/Strategic transformation
2. **Product dynamics**: New feature launches/Feature retirements/Major redesigns
3. **Market dynamics**: New market entry/Pricing adjustments/Channel changes
4. **Sentiment dynamics**: Positive/negative sentiment, user reputation changes

### Step 2: Feature Change Tracking [Conditional]

Track competitor feature changes in detail:

1. **New features**: Feature description, target users, overlap with own product
2. **Feature optimizations**: Optimization content, user experience changes
3. **Feature retirements**: Retired features, possible reasons
4. **Feature comparison matrix**: Competitor comparison update across core feature dimensions

### Step 3: Market Strategy Changes [Conditional]

Analyze competitor market strategy changes:

1. **Pricing strategy changes**: Price adjustments, new pricing models, promotional campaigns
2. **Channel strategy changes**: New channel development, channel focus shifts
3. **Target market changes**: New user segments, new industry/geographic expansion
4. **Partnership ecosystem changes**: New partners, integration expansions

### Step 4: Threat Assessment [Core]

Assess the threat of competitor dynamics to own product:

1. **Direct threats**: Competitor features directly replace own core features
2. **Indirect threats**: Competitor strategy changes affect own market position
3. **Opportunity windows**: Competitor mistakes or vacated market space
4. **Threat level**: 🔴 Severe / 🟠 High / 🟡 Medium / 🟢 Low

### Step 5: Response Recommendations [Deep]

Generate response recommendations based on threat assessment:

1. **Immediate response** (1-2 weeks): Emergency response to severe threats
2. **Short-term response** (1-2 months): Feature alignment or differentiation strategy
3. **Long-term response** (quarterly+): Strategic adjustment or new direction exploration
4. **Monitoring enhancement**: Competitors or dimensions requiring increased monitoring

### Step 6: Report Assembly [Core]

Assemble the above content into a complete monitoring report.

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Competitor dynamics summary and threat level | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full report + competitor trend forecast + strategic impact reasoning + response strategy roadmap | Full artifact + extended analysis + deep reasoning |

## Output

### Output Files

| File | Path | Description |
|------|------|------|
| Competitor monitoring report | `docs/monitoring/diagnosis-report.md ("Competitor Monitoring Report" section)` | Human-readable complete report |
| Structured data | `docs/monitoring/diagnosis-report.md ("Competitor Monitoring Report" section)` | Machine-consumable structured data |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["monitoring_period", "summary", "dynamics", "threat_assessment"],
  "properties": {
    "monitoring_period": {"type": "object", "description": "Monitoring period, including start and end dates"},
    "report_date": {"type": "string", "description": "Report date"},
    "summary": {"type": "object", "description": "Executive summary, including monitored competitor count, major dynamics, and threat level"},
    "dynamics": {"type": "object", "description": "Competitor dynamics summary, including major/product/market/sentiment dynamics"},
    "feature_changes": {"type": "object", "description": "Feature change tracking, including new/optimized/retired and comparison matrix"},
    "market_strategy_changes": {"type": "array", "description": "Market strategy changes list"},
    "threat_assessment": {"type": "object", "description": "Threat assessment, including direct/indirect threats and opportunity windows"},
    "response_recommendations": {"type": "object", "description": "Response recommendations, including immediate/short-term/long-term and monitoring enhancement"}
  }
}
```

### Markdown Report Structure

```markdown
# Competitor Monitoring Report: 2026-Q2

## 1. Executive Summary
- Monitoring period / Monitored competitor count / Major dynamics count / Threat level

## 2. Competitor Dynamics Summary
- Major dynamics
- Product dynamics
- Market dynamics
- Sentiment dynamics

## 3. Feature Change Tracking
- New features
- Feature optimizations
- Feature retirements
- Feature comparison matrix update

## 4. Market Strategy Changes
- Pricing strategy
- Channel strategy
- Target market
- Partnership ecosystem

## 5. Threat Assessment
- Direct threats
- Indirect threats
- Opportunity windows
- Threat level matrix

## 6. Response Recommendations
- Immediate response
- Short-term response
- Long-term response
- Monitoring enhancement recommendations
```

### JSON Structure

```json
{
  "monitoring_period": { "start": "", "end": "" },
  "report_date": "",
  "summary": {
    "competitors_monitored": 0,
    "major_events": 0,
    "threat_level": "severe|high|medium|low"
  },
  "dynamics": {
    "major": [],
    "product": [],
    "market": [],
    "sentiment": []
  },
  "feature_changes": {
    "new_features": [],
    "optimizations": [],
    "retirements": [],
    "comparison_matrix": {}
  },
  "market_strategy_changes": [],
  "threat_assessment": {
    "direct_threats": [],
    "indirect_threats": [],
    "opportunities": [],
    "threat_matrix": {}
  },
  "response_recommendations": {
    "immediate": [],
    "short_term": [],
    "long_term": [],
    "monitoring_enhancement": []
  }
}
```

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Dynamics coverage complete (all 3 dimensions of product/market/sentiment analyzed)
- [ ] Threat assessment has basis (each threat supported by specific competitor dynamics)

### P1 Checks (must pass for standard/deep)

- [ ] Response recommendations actionable (each recommendation has time range and responsible party)
- [ ] Feature comparison updated (comparison matrix reflects latest competitor status)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| monitoring_period | object | Yes | Monitoring period, must contain start/end |
| summary | object | Yes | Executive summary, must contain competitors_monitored/major_events/threat_level |
| summary.threat_level | string | Yes | Threat level, only severe/high/medium/low allowed |
| dynamics | object | Yes | Competitor dynamics, must contain major/product/market/sentiment |
| threat_assessment | object | Yes | Threat assessment, must contain direct_threats/indirect_threats/opportunities |
| response_recommendations | object | No | Response recommendations, must contain immediate/short_term/long_term |

## Decision Rules

- When threat level is severe/high, must include immediate response recommendations (executable within 1-2 weeks)
- When competitor features directly overlap, prioritize differentiation strategy assessment over feature alignment
- When monitoring data covers ≥ 3 competitors, generate complete comparison matrix
- Decision points requiring human confirmation: threat level determination, response strategy priority, monitoring competitor scope adjustment

## Degradation Strategy

- When no competitor tracking data: Generate report based on competitor analysis, label "tracking data missing"
- When no competitor classification: Default to monitoring direct competitors, label "classification pending supplementation"
- When competitor analysis is incomplete: Generate report framework, label missing dimensions as "pending analysis supplementation"
- When data unavailable: Generate qualitative analysis report based on user-provided info, label "needs data validation"

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| diagnosis-competition | Feature change data update | Feature change tracking and threat assessment | Update feature comparison matrix and threat level |
| market-competitor-analysis | Competitor intelligence update | Competitor dynamics summary and market strategy analysis | Update dynamics summary and strategy changes |
| market-competitor-analysis | Competitor classification change | Monitoring scope and threat assessment | Adjust monitoring competitor scope |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| diagnosis-orchestrator | Monitoring report generation complete | Output file update | Report completion status and key threat level |
| iteration-backlog-grooming | Threat level is severe/high | Write to output file | Competitor threat and immediate response recommendations |
