# Iteration Retrospective - 示例集

本文档收录 Iteration Retrospective Skill 各步骤的 YAML 输出示例。

## Step 1.1: Impact Assessment Output 示例

```yaml
impact_assessment:
  trigger_event:
    type: monitoring_alert | user_feedback | strategic_change | resource_change
    severity: P0 | P1 | P2
    description: Payment service error rate spike
  scope_impact:
    affected_items:
      - item_id: US-110
        current_status: in_progress | planned
        impact_type: replace | postpone | remove | add
        story_points_affected: 5
    total_story_points: 5
    percentage_of_iteration: 15%
  schedule_impact:
    original_end_date: 2026-06-30
    estimated_end_date: 2026-07-03
    days_delayed: 3
  quality_impact:
    risk_level: high | medium | low
    areas_affected: [payment, checkout]
  team_impact:
    workload_change: +10%
    context_switches: 2
  business_impact:
    kpis_affected: [payment_success_rate, conversion_rate]
    impact_assessment: Payment success rate decline affects GMV
```

## Step 1.2: Adjustment Plan Generation 示例

```yaml
adjustment_options:
  - option_id: OPT-001
    option_type: insert | replace | postpone | split
    title: Insert payment fix and postpone report optimization
    description: Insert payment fix into current iteration, postpone report optimization to next iteration
    changes:
      items_to_add:
        - item_id: US-201
          story_points: 5
          source: monitoring_alert
      items_to_remove:
        - item_id: US-105
          story_points: 5
          reason: Priority lower than payment fix
      items_to_modify:
        - item_id: US-110
          modification: Split into frontend and backend subtasks
    tradeoffs:
      scope: "Forfeit report export feature"
      schedule: "Delay 3 days"
      quality: "Introduce insufficient test coverage risk"
      business: "Affects report-related KPIs"
    risks:
      - risk: Compressed testing time may cause defect leakage
        likelihood: high | medium | low
        mitigation: Increase regression test case coverage
    recommendation_score: 78
```

## Step 1.3: Risk Assessment Output 示例

```yaml
risk_assessment:
  option_id: OPT-001
  overall_risk_score: 3.5
  risk_breakdown:
    technical_risk:
      score: 3
      concerns: [High complexity of payment module]
    schedule_risk:
      score: 4
      concerns: [Iteration time already half elapsed]
    quality_risk:
      score: 2
      concerns: [Adequate regression test coverage]
    communication_risk:
      score: 3
      concerns: [Need to sync PO and stakeholders]
  mitigation_plan:
    - risk: Insufficient testing time
      strategy: avoid | mitigate | transfer | accept
      action: Add testing resources and prioritize regression testing
```

## Step 1.4: Communication Draft 示例

```yaml
communication_draft:
  recipients:
    - team_members
  subject: "Iteration Sprint-26 Change Notice"
  sections:
    change_summary:
      content: "Due to payment service alert, this iteration inserts payment fix task"
    impact:
      content: "Impact scope: 2 story points replaced, iteration delayed 3 days"
    decisions:
      content: "Decision: Insert US-201, postpone US-105 to next iteration"
    timeline:
      content: "New planned completion date: 2026-07-03"
    questions_contact:
      content: "Contact PO Zhang San for any questions"
```

## Step 2: Data Collection Scope 示例

```yaml
data_collection:
  iteration_id: Sprint-26
  period:
    start: 2026-06-01T00:00:00Z
    end: 2026-06-15T00:00:00Z
  delivery_data:
    planned_items: 12
    completed_items: 10
    planned_story_points: 40
    completed_story_points: 36
    carry_over_items: 2
  quality_data:
    bugs_found: 18
    bugs_fixed: 15
    bug_leakage_rate: 4%
    code_coverage: 82%
    deployment_frequency: 3
  team_feedback:
    retro_items: 8
    top_votes: [Frequent requirement changes, Unstable test environment]
    sentiment: positive | neutral | negative
  monitoring_data:
    availability: 99.2%
    performance_change: +50ms
    incidents: 1
```

## Step 3.1: Delivery Analysis 示例

```yaml
delivery_analysis:
  completion_rate: 90%
  velocity_actual: 36
  velocity_planned: 40
  velocity_accuracy: 0.9
  change_rate: 12%
  carry_over_items:
    - item_id: US-108
      reason: Dependent external interface not ready
  assessment: good | acceptable | needs_improvement
```

## Step 3.2: Quality Analysis 示例

```yaml
quality_analysis:
  bug_density: 0.5
  bug_leakage_rate: 4%
  code_coverage: 82%
  deployment_stability:
    success_rate: 95%
    rollbacks: 1
  assessment: good | acceptable | needs_improvement
```

## Step 3.3: Collaboration Analysis 示例

```yaml
collaboration_analysis:
  team_satisfaction_score: 3.8
  top_positives:
    - Smooth cross-team collaboration
  top_pain_points:
    - Untimely communication of requirement changes
  cross_team_collaboration:
    score: 3.5
    issues: [Interface integration delays]
  assessment: good | acceptable | needs_improvement
```

## Step 3.4: Efficiency Analysis 示例

```yaml
efficiency_analysis:
  team_throughput: 0.9
  context_switches:
    average: 3
    total: 24
  blocked_time_percentage: 15%
  dependency_issues:
    - issue: Waiting for design team to deliver visual assets
      duration: 2
      impact: 5
  assessment: good | acceptable | needs_improvement
```

## Step 4: Problem Identification Output 示例

```yaml
problem_identification:
  - problem_id: PRB-001
    category: process | technical | collaboration | environment
    severity: P1 | P2 | P3
    description: Requirements changed twice mid-iteration
    evidence:
      - metric: change_rate
        value: 12%
        baseline: 5%
        deviation: +7%
    root_cause_analysis:
      - question: "Why are requirement changes frequent?"
        answer: "Insufficient alignment between PO and business stakeholders"
    impact:
      items_affected: 3
      effort_lost: 5
      quality_impact: Rework caused compressed testing time
```

## Step 5: Improvement Suggestions 示例

```yaml
improvement_suggestions:
  - suggestion_id: IMP-001
    problem_id: PRB-001
    category: process | technical | collaboration | environment
    title: Establish requirement change review mechanism
    description: Requirement changes during iteration require dual confirmation from PO and Tech Lead
    expected_outcome:
      metric_improvement:
        - metric: change_rate
          current: 12%
          target: 5%
    action_items:
      - action: Create requirement change process document
        owner: PO
        deadline: 2026-06-25
    effort_required:
      story_points: 2
      time_estimate: 3
    priority: P1 | P2 | P3
    recommendation_score: 8.5
```
