---
name: diagnosis-competition
description: Used when tracking competitor dynamics and formulating response strategies. Competitor dynamics tracking and response, monitoring competitor feature changes, assessing dynamic changes in own advantages, generating response strategies and tracking effectiveness. Keywords: competitor tracking, competitor analysis, competitor monitoring, feature changes, competitive analysis, competitor changes, competitor dynamics, competitor made a move, opponent made a move.
metadata:
  module: "Product Monitoring & Iteration"
  sub-module: "Issue Diagnosis"
  type: "pipeline"
  version: "2.1"
  domain_tags: ["Internet", "SaaS", "General"]
  triggers:
    - "What to do when competitors update again"
    - "How to respond when opponent adds new feature"
    - "How to track competitor dynamics"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output competitor diagnosis and feature comparison"
  deep_description: "Full diagnosis + competitor strategic reasoning + differentiation opportunity identification + competitive response roadmap"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/monitoring/diagnosis-report.md
writes:
  - docs/monitoring/diagnosis-report.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# Competitor Dynamics Tracking and Response 🤖

## Core Principles

1. **Feature changes are signals not noise**: Each competitor feature change reflects their strategic intent; the key is to identify intent rather than list changes
2. **Advantages are dynamic not static**: Competitive advantages are constantly changing; yesterday's lead does not guarantee tomorrow's lead
3. **Response strategies must be trackable**: The value of a strategy lies in execution and effectiveness validation, rather than staying at the recommendation level

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Competitor data | JSON | Yes | Competitor monitoring system → competitor data | Feature list, version updates, user reviews |
| Self data | JSON | Yes | Product data platform → self data | Feature list, user reviews, satisfaction |
| Market data | JSON | ○ | Industry report → market data | Industry trends, user demand changes |
| Historical tracking | JSON | ○ | docs/monitoring/diagnosis-report.md ("Competitor Diagnosis" section) | Historical competitor analysis reports |

## Execution Steps

### Step 1: Feature Change Monitoring [Conditional]

**Goal**: Identify competitor recent feature changes

**Monitoring channels**:
- Competitor official websites/update logs
- App store update records
- User review aggregation
- Social media discussions
- Industry media coverage

**Change type classification**:

| Type | Definition | Attention Level |
|------|------|----------|
| New feature | New capability unique to competitor | P0 |
| Feature optimization | Experience/performance improvement of existing feature | P1 |
| Feature retirement | Discontinued feature | P2 |
| Pricing adjustment | Pricing strategy change | P1 |
| Ecosystem expansion | Partner/integration changes | P2 |

**Output format**:

```yaml
feature_changes:
  - competitor: Competitor A
    change_type: new_feature | enhancement | deprecation | pricing | ecosystem
    feature_name: Data Analytics
    change_date: 2026-06-15
    description: Core features similar, positioning differentiated
    user_reaction:
      sentiment: positive | negative | neutral
      volume: 128
      key_themes: [Experience improvement, Faster response]
    source: https://example.com/changelog
    priority: P0 | P1 | P2
```

### Step 2: Advantage Dynamic Assessment [Core]

**Goal**: Assess changes in own advantages/disadvantages relative to competitors

**Assessment dimensions**:

| Dimension | Metric | Data Source |
|------|------|----------|
| Feature leadership | Unique feature count vs competitor | Feature comparison matrix |
| User experience | Rating comparison, feature usability | App Store/Google Play |
| Performance metrics | Response time, stability comparison | Third-party reviews |
| Value perception | Cost-effectiveness, brand awareness | User research |
| Ecosystem richness | Integration count, API openness | Technical documentation |

**Assessment methods**:
- Radar chart multi-dimensional comparison
- Trend line change analysis
- User review semantic analysis

**Output format**:

```yaml
advantage_changes:
  period: 2026-05-01 to 2026-06-15
  dimensions:
    - dimension: feature_leadership
      previous_status: leading | parity | lagging
      current_status: leading | parity | lagging
      change: improved | unchanged | declined
      delta: Unique feature count increased from 8 to 10
    - dimension: user_experience
      previous_status: leading | parity | lagging
      current_status: leading | parity | lagging
      change: improved | unchanged | declined
      delta: App Store rating dropped from 4.5 to 4.4
  overall_trend:
    direction: gaining | holding | losing
    confidence: 85%
  critical_changes:
    - description: "Competitor X launched Y feature, narrowing feature gap"
      impact_level: high | medium | low
```

### Step 3: Response Strategy Generation [Core]

**Goal**: Generate response strategies based on competitor dynamics

**Strategy types**:

| Strategy Type | Applicable Scenario | Execution Requirements |
|----------|----------|----------|
| Accelerate | Competitor seizing market share | Rapid iteration, high priority |
| Differentiate | Competitor feature homogenization | Find unique value points |
| Defend | Competitor threatening core features | Consolidate moat |
| Monitor | Impact uncertain | Continuous monitoring, reserve plans |

**Strategy generation rules**:

```yaml
response_strategy:
  - competitor_change:
      feature: Data Analytics
      change_type: new_feature
    recommended_approach: accelerate | differentiate | defend | monitor
    action:
      title: Launch differentiated data analytics module
      description: Add custom dashboard capability on top of competitor features
      options:
        - option: aggressive
          description: "Fast follow-up, feature first"
          timeline: 2-4 weeks
          priority: P0
          resource_needed: 13
        - option: balanced
          description: "Differentiated implementation"
          timeline: 4-8 weeks
          priority: P1
          resource_needed: 8
        - option: conservative
          description: "Continue observing, wait for more information"
          timeline: tbd
          priority: P2
    selected_option: balanced
    tracking:
      status: planned | in_progress | completed | dismissed
      milestones: [...]
```

### Step 4: Effectiveness Tracking [Conditional]

**Goal**: Track the execution effectiveness of response strategies

**Tracking metrics**:
- Strategy execution completeness
- User feedback after feature release
- Market share changes
- User rating changes

**Tracking report**:

```yaml
effect_tracking:
  strategy_id: STR-001
  execution:
    planned_date: 2026-06-20
    actual_date: 2026-06-22
    completed: true | false
  outcome:
    user_feedback:
      sentiment_change: +0.3
      volume: 256
    market_impact:
      share_change: +1.5%
      new_users: 1200
    competitive_position:
      status_change: improved | unchanged | declined
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Competitor diagnosis and feature comparison | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full diagnosis + competitor strategic reasoning + differentiation opportunity identification + competitive response roadmap | Full artifact + extended analysis + deep reasoning |

## Output


**Output file path**: `docs/monitoring/diagnosis-report.md ("Competitor Diagnosis" section)`
**Output Schema**:

```json
{
  "type": "object",
  "required": ["report_id", "feature_changes", "advantage_changes", "response_strategy"],
  "properties": {
    "report_id": {"type": "string", "description": "Report unique identifier"},
    "generated_at": {"type": "string", "description": "Generation time"},
    "period": {"type": "object", "description": "Analysis period, including start and end times"},
    "feature_changes": {"type": "object", "description": "Feature change summary, including total and P0/P1 counts"},
    "advantage_changes": {"type": "object", "description": "Advantage changes, including gaining/holding/losing dimensions"},
    "response_strategy": {"type": "array", "description": "Response strategy list, including competitor, feature, and priority"}
  }
}
```

```
├── 2026-06-15/
│   ├── feature_changes.yaml
│   ├── advantage_changes.yaml
│   ├── response_strategy.yaml
│   └── effect_tracking.yaml
└── latest/
    └── competition_report.md
```

### Competitor Response Output Format

```yaml
competition_response:
  report_id: a1b2c3d4-e5f6-7890-abcd-ef1234567890
  generated_at: 2026-06-15T10:00:00Z
  period: 2026-05-01 to 2026-06-15
  feature_changes:
    total: 12
    p0_count: 2
    p1_count: 5
  advantage_changes:
    gaining: [feature_leadership, ecosystem]
    holding: [user_experience]
    losing: [pricing]
  response_strategy:
    - id: STR-001
      competitor: Competitor A
      feature: Data Analytics
      approach: accelerate
      action: Launch differentiated data analytics module
      timeline: 4
      priority: P0
      tracking:
        status: planned
```

## Decision Rules

| Scenario | Decision Rule |
|------|----------|
| Competitor launches disruptive feature | Immediately generate response strategy, mark P0 |
| Advantage gap narrows < 10% | Generate defense strategy |
| Multiple competitors homogenize | Trigger differentiation strategy generation |
| Strategy execution delayed | Re-evaluate priority |
| Major market environment change | Re-evaluate overall strategy |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Competitor coverage completeness ≥ 90%
- [ ] Feature change identification timeliness ≤ 7 days

### P1 Checks (must pass for standard/deep)

- [ ] Advantage assessment consistent with actual market feedback
- [ ] Strategy executability ≥ 80%
- [ ] Effectiveness tracking coverage 100%
- [ ] Report completeness (all dimensions)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Competitor data | User provides competitor name list, AI tracks competitor dynamics based on public information and industry knowledge | AI knowledge-based competitor tracking report, data sources and confidence need to be labeled |
| Self data | User provides own product feature list and user reviews, AI performs manual comparison | User input-based advantage/disadvantage analysis, lacks data validation |
| Market data | Skip industry trend analysis, strategy recommendations based only on feature comparison | Strategy recommendations without industry trends |
| Historical tracking | Skip historical trend analysis, only output current snapshot | Competitor status snapshot report, no trend comparison |

### Data Acquisition Notes

When upstream files are missing, obtain necessary data through the following methods:

1. **Competitor data missing**: Ask user to provide competitor name list, AI will track competitor feature dynamics based on public information (official websites, app stores, industry reports, etc.) and AI knowledge base, labeling data sources and confidence in output
2. **Self data missing**: Ask user to provide own product feature list and core metrics (user ratings, feature coverage, etc.), AI will perform manual comparative analysis with competitors based on user input
3. **Market data missing**: AI skips industry trend analysis, response strategies generated only based on feature comparison results, recommend supplementing market data later to improve strategy

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| report_id | string | Yes | Report unique identifier |
| feature_changes | object | Yes | Feature change summary, must contain total/p0_count/p1_count |
| feature_changes.total | number | Yes | Total change count, must be ≥0 |
| advantage_changes | object | Yes | Advantage changes, must contain gaining/holding/losing |
| response_strategy | array | Yes | Response strategy list, each item must contain id/competitor/feature/approach/priority |
| response_strategy[].priority | string | Yes | Priority, only P0/P1/P2 allowed |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| Competitor monitoring system | Competitor data format change | Feature change parsing and classification | Adapt to new format, update change type classification |
| Product data platform | Self feature list change | Advantage comparison matrix | Update comparison baseline, re-evaluate advantages/disadvantages |
| Industry report | Market data update | Industry trends and strategy recommendations | Update trend analysis, adjust strategy priority |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| competitor-monitoring-report | Competitor tracking data updated | Write to output file | Feature changes and advantage changes |
| diagnosis-orchestrator | Competitor tracking completed | Output file updated | Tracking completion status and key findings |
| iteration-backlog-grooming | P0-level competitor change | Write to output file | Emergency response strategy and priority |
