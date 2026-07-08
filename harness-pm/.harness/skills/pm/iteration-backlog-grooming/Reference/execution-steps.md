# iteration-backlog-grooming — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Execution Steps

### Step 1: Issue Priority Assessment [Core]

**Goal**: Prioritize Backlog items based on a multi-dimensional scoring model

**Assessment Model**:

```
Priority Score = Business Impact × User Value × Urgency × Effort Adjusted
```

**Scoring Dimensions**:

| Dimension | Weight | Scoring Criteria |
|------|------|----------|
| Business Impact | 30% | Revenue impact, brand impact, strategic value |
| User Value | 25% | User request frequency, pain point intensity |
| Urgency | 25% | Alert impact, competitive threat, compliance requirements |
| Effort Adjusted | 20% | Resource requirements, dependencies, risk |

**Scoring Formula**:

```yaml
priority_score:
  business_impact:
    score: 0-10
    factors:
      revenue_impact: 7.5
      brand_impact: 6.0
      strategic_value: 8.0
  user_value:
    score: 0-10
    factors:
      request_frequency: 12
      pain_point_intensity: 7.0
  urgency:
    score: 0-10
    factors:
      alert_impact: 5.0
      competitive_threat: 6.5
      compliance_requirement: 3.0
  effort_adjusted:
    score: 0-10
    factors:
      resource_requirement: 8
      dependencies: 3
      technical_risk: 4.0
  final_score: 7.2
```

### Step 2: Technical Debt Impact Analysis [Conditional]

**Goal**: Quantify the impact of technical debt on Backlog items, making hidden costs explicit

**Impact Types**:

| Type | Impact Metric | Quantification Method |
|------|----------|----------|
| Development efficiency | Extra effort ratio | Debt vs new features within a Sprint |
| Defect rate | Bug density | Bugs per thousand lines of code |
| Performance degradation | Response time increment | Before/after optimization comparison |
| Maintenance cost | Code complexity | Cyclomatic Complexity |

**Debt Classification**:

```yaml
technical_debt_impact:
  - debt_id: TD-001
    category: code_quality | performance | security | architecture
    severity: critical | high | medium | low
    affected_systems: [order_service, payment_service]
    metrics:
      development_overhead: 15%
      defect_rate_impact: 8%
      performance_impact: 12%
    affected_backlog_items: [US-101, US-205]
    interest_accrued: 2.5
```

### Step 3: Dependency Analysis [Conditional]

**Goal**: Identify dependency, synergy, and conflict relationships between requirements to inform restructuring

**Relationship Types**:

| Type | Description | Handling |
|------|------|----------|
| Dependency | A must come before B | Enforce order |
| Synergy | A and B work better together | Suggest combining |
| Mutual exclusion | A and B cannot be done simultaneously | Mark conflict |
| Technical debt link | New feature affected by debt | Debt first |

**Dependency Output**:

```yaml
linked_issues:
  - item_id: US-101
    dependencies:
      - depends_on: US-098
        type: hard | soft
        reason: Depends on user authentication module completion
    synergies:
      - related_to: US-103
        reason: "Implement together to maximize value"
    technical_debt_blockers:
      - debt_id: TD-001
        impact: "Reduces development efficiency by 20%"
```

### Step 4: Backlog Restructuring [Deep]

**Goal**: Generate Backlog restructuring recommendations based on priority scores and dependency analysis

**Restructuring Strategies**:

| Strategy | Applicable Scenario | Action |
|------|----------|------|
| Urgent priority | Alerts/major Bugs | Raise priority, mark P0 |
| Batch combination | Related debt/features | Package as Epic |
| Delay handling | Low-priority long-tail requirements | Move to Icebox |
| Split handling | Large-granularity items | Split into smaller stories |
| Dependency sorting | Items with prerequisites | Sort by dependency chain |

**Restructuring Recommendation Format**:

```yaml
reorganization_suggestions:
  - action: prioritize | combine | postpone | split | reorder
    target:
      item_id: US-101
      current_position: 5
      suggested_position: 1
    reason: Linked to P0 alert, needs priority handling
    impact:
      effort_saved: 3
      risk_reduced: 20%
      value_delivered: Early fix of payment chain risk
```
