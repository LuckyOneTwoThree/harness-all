---
name: iteration-retrospective
description: Used when assisting with iteration retrospectives. Iteration retrospective tool responsible for completion analysis, problem identification, improvement suggestions, and communication draft generation. Keywords: iteration retrospective, completion analysis, problem identification, improvement suggestions, Retro.
---
# Iteration Retrospective & Adjustment 🤖

## When to use
- Need to retrospective this iteration
- Sprint is over, how to summarize
- How did the iteration go
- Need to adjust the iteration plan, what to do
- Need to insert a requirement, how to reorder

## Outputs
- docs/monitoring/iteration-retrospective.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **The purpose of retrospectives is improvement, not blame**: Retrospectives must establish psychological safety, otherwise the team will only report good news and hide problems
2. **Data-driven attribution, not subjective impressions**: Validate "feelings" with metric data to avoid impression bias masking real problems
3. **Improvement suggestions must be trackable and verifiable**: Every improvement suggestion must have an owner and validation criteria, otherwise the retrospective is just going through the motions
4. **Priority adjustment is not re-sorting, but reallocating resources**: Every adjustment means breaking existing commitments; cascading impacts must be assessed
5. **Change impact assessment precedes adjustment decisions**: Quantify impact before deciding on adjustments—avoid knee-jerk adjustments that cause greater chaos
6. **Risk assessment is the guardrail for adjustments**: Every adjustment must come with a risk assessment to ensure it doesn't introduce bigger problems

### Trigger Conditions

| Trigger Condition | Description | Priority |
|----------|------|--------|
| Monitoring anomaly | Monitoring system detects an anomaly | P0 |
| Major feedback | Large volume of user complaints or key customer feedback | P0 |
| Strategic change | Significant change in business strategy or market environment | P1 |
| Resource change | Team member additions/reductions or available time changes | P2 |
| Iteration end | Sprint cycle ends, retrospective needed | P1 |

## Basic Information

| Item | Value |
|------|-----|
| Module | Product Monitoring & Iteration |
| Sub-module | Iteration Optimization |
| Type | pipeline |
| Version | 2.0 |
| Interaction Mode | Human-AI collaboration |
| Execution Depth | standard (default) |

## Interaction Mode

👤↔🤖 Human-AI collaboration

- Human provides iteration execution status, team feedback, and adjustment needs
- AI automatically completes data analysis, problem identification, improvement suggestion generation, and adjustment plan evaluation
- Human approval focus: whether problem attribution is accurate, whether improvement suggestions are executable, whether adjustment plan risks are acceptable
- Human can ask AI to supplement analysis dimensions or adjustment plans; AI regenerates
- Improvement suggestions and adjustment plans take effect after team confirmation

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Current iteration plan | JSON | Yes | User-provided or project management system | Sprint Backlog, commitments, as baseline for retrospective and adjustment |
| Iteration completion | JSON | Yes | User-provided or project management system | Completed/incomplete items, story points, for completion analysis |
| Resource constraints | JSON | ○ | User-provided or project management system | Team capacity, available time, dependencies, for adjustment plan capacity validation |
| Trigger event | JSON | ○ | Monitoring system/feedback system → Trigger event | Anomaly details, feedback content, strategic changes, for change impact assessment |
| Change requirements | JSON | ○ | User-provided | Added/modified/removed items, for adjustment plan generation |
| Quality metrics | JSON | Yes | Test platform/CI/CD → Quality data | Defect count, code coverage, rework rate, for quality analysis |
| Team feedback | JSON | ○ | Retro tool → Team feedback | Retro meeting notes, voting results, for collaboration analysis |
| Monitoring data | JSON | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Stability, performance change data, for stability analysis |
| Monitoring alerts | JSON | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Alerts during iteration, for problem identification |

**Important**: This Skill's iteration plan and completion data are provided by the user or exported from the project management system, with no cross-module hard dependencies; it can execute independently.

## Execution Steps

### Step 1: Change Impact Assessment [Core]

**Goal**: Assess the impact on the current iteration based on trigger events, providing quantitative basis for adjustment decisions

#### 1.1 Impact Dimension Assessment [Core]

**Impact Dimensions**:

| Dimension | Assessment Content | Metric |
|------|----------|------|
| Scope impact | Which items need adjustment | Item count, story points |
| Schedule impact | Impact on delivery time | Days delayed |
| Quality impact | Impact on quality standards | Risk level |
| Team impact | Impact on team morale and efficiency | Workload change |
| Business impact | Impact on business goals | KPI changes |

**Impact Calculation**:

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

#### 1.2 Adjustment Plan Generation [Core]

**Plan Types**:

| Plan Type | Applicable Scenario | Cost |
|----------|----------|------|
| Insert | P0 urgent issue must be handled | Delay other items |
| Replace | Low-priority item of equal value available | Forfeit some features |
| Postpone | Low-priority items can be delayed | Delayed delivery |
| Split | Some features can be delivered first | Phased delivery |

**Plan Generation**:

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

#### 1.3 Risk Assessment [Conditional]

**Risk Matrix**:

| Risk Category | Assessment Dimensions | Scoring Method |
|----------|----------|----------|
| Technical risk | Complexity, dependencies, technical challenges | 1-5 score |
| Schedule risk | Time pressure, change frequency | 1-5 score |
| Quality risk | Test coverage, defect rate | 1-5 score |
| Communication risk | Stakeholder satisfaction, expectation management | 1-5 score |

**Risk Assessment Output**:

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

#### 1.4 Communication Draft [Deep]

**Stakeholders**:
- Team members
- Product Owner
- Stakeholders
- Customers (if applicable)

**Communication Template**:

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

### Step 2: Data Collection [Conditional]

**Goal**: Collect delivery, quality, team feedback, and monitoring data during iteration execution

**Data Sources**:

| Data Type | Data Source | Collection Method |
|----------|--------|----------|
| Delivery data | Project management system | API/Export |
| Quality data | Test platform, CI/CD | API/Export |
| Team feedback | Retro tool, meeting notes | Text/Export |
| Monitoring data | Monitoring system, log platform | API/Export |

**Data Collection Scope**:

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

### Step 3: Multi-Dimensional Analysis [Conditional]

**Goal**: Analyze iteration execution effectiveness across delivery, quality, collaboration, and efficiency dimensions

#### 3.1 Delivery Analysis [Conditional]

**Metrics**:

| Metric | Definition | Target |
|------|------|------|
| Delivery completion rate | Completed story points / Planned story points | ≥ 85% |
| Delivery forecast accuracy | Actual / Planned | 0.9-1.1 |
| Requirement change rate | Changed items / Total items | < 15% |

**Analysis**:

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

#### 3.2 Quality Analysis [Conditional]

**Metrics**:

| Metric | Definition | Target |
|------|------|------|
| Bug density | Bug count / Story point count | < 0.5 |
| Bug leakage rate | Production Bugs / Test-discovered Bugs | < 5% |
| Code coverage | Covered code lines / Total code lines | ≥ 80% |

**Analysis**:

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

#### 3.3 Collaboration Analysis [Deep]

**Metrics**:

| Metric | Definition | Data Source |
|------|------|----------|
| Team satisfaction | Team satisfaction score for iteration | Retro |
| Cross-team collaboration | Collaboration effectiveness with other teams | Retro |
| Communication efficiency | Information alignment level | Subjective evaluation |

**Analysis**:

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

#### 3.4 Efficiency Analysis [Deep]

**Metrics**:

| Metric | Definition | Calculation Method |
|------|------|----------|
| Team throughput | Story points / Person-days | Total points / Total person-days |
| Context switching | Task interruption count | Statistics |
| Blocked time ratio | Blocked time / Total time | Log statistics |

**Analysis**:

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

### Step 4: Problem Identification [Conditional]

**Goal**: Identify problems in the iteration based on multi-dimensional analysis and perform root cause analysis

**Problem Classification**:

| Category | Identification Method | Priority |
|------|----------|--------|
| Process problems | Recurring blockers, changes | P1 |
| Technical problems | Defect patterns, performance bottlenecks | P1 |
| Collaboration problems | Communication issues, dependency issues | P2 |
| Environment problems | Tool instability, environment issues | P2 |

**Problem Identification Output**:

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

### Step 5: Improvement Suggestions [Deep]

**Goal**: Generate trackable, verifiable improvement suggestions based on problem identification

**Suggestion Format**:

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

## Output

**Output file path**: `docs/monitoring/iteration-retrospective.md`

### Output Depth Levels

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Iteration retrospective core conclusions | Core conclusions + minimum viable deliverable, only completion analysis and key problems |
| standard | Full iteration retrospective (current default) | Full deliverable, includes all Step 1-5 outputs |
| deep | Full retrospective + extended analysis | Full deliverable + competitor iteration comparison + long-term roadmap assessment + decision records |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["iteration_id", "summary", "metrics_analysis"],
  "properties": {
    "generated_at": {"type": "string", "description": "Generation time"},
    "iteration_id": {"type": "string", "description": "Iteration ID"},
    "period": {"type": "object", "description": "Iteration period, including start and end times"},
    "trigger_id": {"type": "string", "description": "Trigger event ID (if adjusted)"},
    "trigger_type": {"type": "string", "description": "Trigger type: monitoring_alert/feedback/strategy_change"},
    "impact_assessment": {"type": "object", "description": "Change impact assessment, including scope/schedule/quality impact"},
    "recommended_option": {"type": "string", "description": "Recommended adjustment plan ID"},
    "options": {"type": "array", "description": "Optional adjustment plan list, including type, score, and trade-offs"},
    "needs_human_decision": {"type": "boolean", "description": "Whether human decision is required"},
    "summary": {"type": "object", "description": "Iteration summary, including completion rate, quality status, and score"},
    "metrics_analysis": {"type": "object", "description": "Metrics analysis, including delivery/quality/collaboration/efficiency four dimensions"},
    "problem_identification": {"type": "object", "description": "Problem identification, including total count and P1/P2 counts"},
    "improvement_suggestions": {"type": "array", "description": "Improvement suggestion list, each item must have owner and validation criteria"}
  }
}
```

**Output File Structure**:

```
├── iteration-retrospective.json
├── iteration-retrospective.md
├── adjustment/
│   ├── TRG-001/
│   │   ├── impact_assessment.yaml
│   │   ├── adjustment_options.yaml
│   │   ├── risk_assessment.yaml
│   │   ├── communication_draft.md
│   │   └── needs_human_decision.yaml
│   └── latest/
│       └── adjustment_recommendation.md
└── retrospective/
    ├── Sprint-26/
    │   ├── summary.md
    │   ├── metrics_analysis.yaml
    │   ├── problem_identification.yaml
    │   └── improvement_suggestions.yaml
    └── latest/
        └── retrospective_report.md
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| iteration_id | string | Yes | Iteration ID, cannot be empty |
| summary | object | Yes | Iteration summary, must contain delivery_completion/quality_status/overall_score |
| metrics_analysis | object | Yes | Metrics analysis, must contain delivery/quality/collaboration/efficiency four dimensions |
| impact_assessment | object | No | Change impact assessment, must contain affected_items/scope/severity |
| adjustment_options | array | No | Adjustment plan list, at least 2 plans |
| adjustment_options[].recommendation_score | number | No | Recommendation score, range 0-100 |
| risk_assessment | object | No | Risk assessment, must contain risk_level/mitigation |
| communication_draft | object | No | Communication draft, must contain stakeholders/message |
| problem_identification | object | No | Problem identification, must contain total_problems/p1_count |
| improvement_suggestions | array | No | Improvement suggestion list, each item must have owner and validation criteria |

## Decision Rules

| Scenario | Decision Rule |
|------|----------|
| P0 monitoring anomaly | Auto-recommend insertion, mark for human confirmation |
| Impact > 50% scope | Mark as requiring PO decision |
| Multiple options available | Recommend highest-scored option, list comparison |
| No available replacement items | Suggest postponement or split |
| Team opposition | Mark as requiring additional communication |
| Completion rate < 70% | Flag key problems, analyze root causes |
| Bug leakage rate > 10% | Trigger quality process review |
| Team satisfaction < 3/5 | Flag collaboration problems, require dedicated improvement |
| Same type of problem in two consecutive iterations | Mark as systemic defect |
| Cannot auto-identify root cause | Recommend dedicated manual analysis |

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Current iteration plan | User describes reasons and expectations for adjustment, AI generates adjustment plan based on description | Adjustment plan based on user description, lacks plan data validation |
| Iteration completion | User provides iteration completion (completed/incomplete items, story points), AI generates retrospective based on provided data | Retrospective report based on user input, lacks system data |
| Resource constraints | Skip capacity validation, mark "manual capacity confirmation required" in plan | Adjustment plan without capacity validation |
| Trigger event | User provides adjustment trigger reason (anomaly/feedback/strategic change), AI assesses accordingly | Impact assessment based on user input |
| Change requirements | User dictates items to add/remove/modify, AI organizes into structured change requirements | User dictation converted to structured change list |
| Quality metrics | User provides defect count and rework data, AI performs quality analysis directly | Quality analysis based on user input |
| Team feedback | Skip collaboration analysis dimension, mark "team feedback data missing" | Retrospective without collaboration dimension |
| Monitoring data | Skip monitoring data analysis, mark "stability data missing" in retrospective | Retrospective without stability dimension |
| Monitoring alerts | Skip alert correlation analysis, urgent priority strategy unavailable | Adjustment plan without alert correlation |

### Data Acquisition Instructions

When upstream files are missing, obtain necessary data through the following methods:

1. **Current iteration plan missing**: Please describe the reason for adjustment (e.g., "payment feature has online issue requiring insertion"), AI will generate adjustment plan based on description, including insert/replace/postpone options
2. **Iteration completion missing**: Please provide iteration completion, including: planned story points/actual completed story points, incomplete items and reasons, requirement changes; AI will generate retrospective report based on provided data
3. **Resource constraints missing**: Skip capacity matching validation during plan generation, all plans marked "manual team capacity confirmation required"; recommend supplementing resource data later
4. **Trigger event missing**: Please explain the adjustment trigger reason and urgency, AI will perform impact assessment and plan generation accordingly
5. **Change requirements missing**: Please dictate items to add/remove/modify, AI will organize into structured change list
6. **Quality metrics missing**: Please provide key quality data (Bug count, severity distribution, rework count); AI will perform quality dimension analysis accordingly
7. **Team feedback missing**: Skip collaboration analysis dimension, mark this dimension as data missing in retrospective; recommend supplementing through Retro meeting later
8. **Monitoring data missing**: Skip stability analysis, mark stability data missing in retrospective; recommend exporting from monitoring system to supplement
9. **Monitoring alerts missing**: Skip alert correlation analysis, cannot auto-promote urgent item priority; recommend user manually flag urgent items

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Iteration ID non-empty
- [ ] Completion analysis coverage 100%
- [ ] Adjustment plan count ≥ 2 (if trigger event exists)

### P1 Checks (must pass for standard/deep)

- [ ] Change impact assessment coverage 100% (if trigger event exists)
- [ ] Sprint capacity matched
- [ ] No critical dependencies missed
- [ ] Risk assessment completeness
- [ ] Decision marking accuracy
- [ ] Plan executability ≥ 80%
- [ ] Data collection completeness ≥ 95%
- [ ] Analysis covers all four dimensions
- [ ] Problem identification accuracy ≥ 80%
- [ ] Suggestion executability ≥ 75%
- [ ] Improvement suggestions have clear owners

### P2 Checks (must pass for deep only)

- [ ] Communication draft covers all stakeholders
- [ ] Comparison with previous iteration complete
- [ ] Competitor iteration comparison completed (competitor feature iteration cadence, strategy difference analysis, market trend benchmarking)
- [ ] Long-term roadmap assessment generated (3-6 month iteration roadmap, key milestones, resource demand forecast)

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| Project management system | Iteration plan change | Change impact assessment baseline | Reassess change impact |
| Project management system | Resource constraint change | Plan capacity validation | Re-validate plan feasibility |
| Project management system | Iteration completion data update | Delivery dimension analysis | Update completion rate and story point statistics |
| Test platform/CI/CD | Quality metrics change | Quality dimension analysis | Update defect statistics and coverage |
| monitoring-alert-detection | Alert data update | Urgent priority strategy | Update alert correlation and priority promotion |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| iteration-orchestrator | Iteration retrospective full process complete | Output file update | Retrospective completion status and key conclusions |
| iteration-backlog-grooming | Improvement suggestions generation complete | Output file update | Improvement items flow back to Backlog for next grooming round |
