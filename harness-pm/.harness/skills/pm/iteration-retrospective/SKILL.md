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

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.1: Impact Assessment Output" for the impact calculation YAML example.

#### 1.2 Adjustment Plan Generation [Core]

**Plan Types**:

| Plan Type | Applicable Scenario | Cost |
|----------|----------|------|
| Insert | P0 urgent issue must be handled | Delay other items |
| Replace | Low-priority item of equal value available | Forfeit some features |
| Postpone | Low-priority items can be delayed | Delayed delivery |
| Split | Some features can be delivered first | Phased delivery |

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.2: Adjustment Plan Generation" for the plan generation YAML example.

#### 1.3 Risk Assessment [Conditional]

**Risk Matrix**:

| Risk Category | Assessment Dimensions | Scoring Method |
|----------|----------|----------|
| Technical risk | Complexity, dependencies, technical challenges | 1-5 score |
| Schedule risk | Time pressure, change frequency | 1-5 score |
| Quality risk | Test coverage, defect rate | 1-5 score |
| Communication risk | Stakeholder satisfaction, expectation management | 1-5 score |

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.3: Risk Assessment Output" for the risk assessment YAML example.

#### 1.4 Communication Draft [Deep]

**Stakeholders**:
- Team members
- Product Owner
- Stakeholders
- Customers (if applicable)

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.4: Communication Draft" for the communication template YAML example.

### Step 2: Data Collection [Conditional]

**Goal**: Collect delivery, quality, team feedback, and monitoring data during iteration execution

**Data Sources**:

| Data Type | Data Source | Collection Method |
|----------|--------|----------|
| Delivery data | Project management system | API/Export |
| Quality data | Test platform, CI/CD | API/Export |
| Team feedback | Retro tool, meeting notes | Text/Export |
| Monitoring data | Monitoring system, log platform | API/Export |

> See [Reference/examples.md](./Reference/examples.md) → "Step 2: Data Collection Scope" for the data collection YAML example.

### Step 3: Multi-Dimensional Analysis [Conditional]

**Goal**: Analyze iteration execution effectiveness across delivery, quality, collaboration, and efficiency dimensions

#### 3.1 Delivery Analysis [Conditional]

**Metrics**:

| Metric | Definition | Target |
|------|------|------|
| Delivery completion rate | Completed story points / Planned story points | ≥ 85% |
| Delivery forecast accuracy | Actual / Planned | 0.9-1.1 |
| Requirement change rate | Changed items / Total items | < 15% |

> See [Reference/examples.md](./Reference/examples.md) → "Step 3.1: Delivery Analysis" for the analysis YAML example.

#### 3.2 Quality Analysis [Conditional]

**Metrics**:

| Metric | Definition | Target |
|------|------|------|
| Bug density | Bug count / Story point count | < 0.5 |
| Bug leakage rate | Production Bugs / Test-discovered Bugs | < 5% |
| Code coverage | Covered code lines / Total code lines | ≥ 80% |

> See [Reference/examples.md](./Reference/examples.md) → "Step 3.2: Quality Analysis" for the analysis YAML example.

#### 3.3 Collaboration Analysis [Deep]

**Metrics**:

| Metric | Definition | Data Source |
|------|------|----------|
| Team satisfaction | Team satisfaction score for iteration | Retro |
| Cross-team collaboration | Collaboration effectiveness with other teams | Retro |
| Communication efficiency | Information alignment level | Subjective evaluation |

> See [Reference/examples.md](./Reference/examples.md) → "Step 3.3: Collaboration Analysis" for the analysis YAML example.

#### 3.4 Efficiency Analysis [Deep]

**Metrics**:

| Metric | Definition | Calculation Method |
|------|------|----------|
| Team throughput | Story points / Person-days | Total points / Total person-days |
| Context switching | Task interruption count | Statistics |
| Blocked time ratio | Blocked time / Total time | Log statistics |

> See [Reference/examples.md](./Reference/examples.md) → "Step 3.4: Efficiency Analysis" for the analysis YAML example.

### Step 4: Problem Identification [Conditional]

**Goal**: Identify problems in the iteration based on multi-dimensional analysis and perform root cause analysis

**Problem Classification**:

| Category | Identification Method | Priority |
|------|----------|--------|
| Process problems | Recurring blockers, changes | P1 |
| Technical problems | Defect patterns, performance bottlenecks | P1 |
| Collaboration problems | Communication issues, dependency issues | P2 |
| Environment problems | Tool instability, environment issues | P2 |

> See [Reference/examples.md](./Reference/examples.md) → "Step 4: Problem Identification Output" for the problem identification YAML example.

### Step 5: Improvement Suggestions [Deep]

**Goal**: Generate trackable, verifiable improvement suggestions based on problem identification

> See [Reference/examples.md](./Reference/examples.md) → "Step 5: Improvement Suggestions" for the suggestion format YAML example.

## Output

**Output file path**: `docs/monitoring/iteration-retrospective.md`

### Output Depth Levels

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Iteration retrospective core conclusions | Core conclusions + minimum viable deliverable, only completion analysis and key problems |
| standard | Full iteration retrospective (current default) | Full deliverable, includes all Step 1-5 outputs |
| deep | Full retrospective + extended analysis | Full deliverable + competitor iteration comparison + long-term roadmap assessment + decision records |

> See [Reference/schema.md](./Reference/schema.md) for output JSON schema, output file structure, and output validation rules.

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

When upstream files are missing, this Skill can execute independently through user-provided data.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Degradation Strategy - Upstream File Missing" and "Data Acquisition Instructions" for the full degradation table and data acquisition methods.

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

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Upstream Change Impact Table" and "Downstream Notification Mechanism Table" for change impact and notification details.
