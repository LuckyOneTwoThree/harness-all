---
name: iteration-backlog-grooming
description: Used when grooming and prioritizing the product Backlog. Backlog grooming tool responsible for issue priority assessment, technical debt impact analysis, and restructuring recommendations.
---
# Backlog Grooming & Priority Assessment 🤖

## When to use
- The requirement pool is messy, how to organize it
- How to prioritize the backlog
- Too many requirements, which to do first
- Need to insert a requirement, how to reorder
- How to re-prioritize
- Keywords: Backlog grooming, priority assessment, technical debt, requirement restructuring

## Outputs
- docs/monitoring/iteration-plan.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Priority is the quantitative expression of resource allocation**: The essence of Backlog sorting is deciding where resources go; every sort change means reallocation of resources
2. **Dependencies are leverage**: Identify dependency and synergy relationships between requirements—doing related requirements together is 3x more efficient than doing them separately
3. **Technical debt is a hidden cost that must be made explicit**: Technical debt that doesn't enter the Backlog will never be repaid; it must carry weight in the priority score
4. **Data-driven attribution, not subjective impressions**: Validate "feelings" with metric data to avoid impression bias masking real problems

### Trigger Conditions

| Trigger Condition | Description | Priority |
|----------|------|--------|
| Monitoring anomaly | Monitoring system detects an anomaly | P0 |
| Major feedback | Large volume of user complaints or key customer feedback | P0 |
| Strategic change | Significant change in business strategy or market environment | P1 |
| Resource change | Team member additions/reductions or available time changes | P2 |

## Basic Information

| Item | Value |
|------|-----|
| Module | Product Monitoring & Iteration |
| Sub-module | Iteration Optimization |
| Type | pipeline |
| Version | 2.0 |
| Interaction Mode | AI suggests, human approves |
| Execution Depth | standard (default) |

## Interaction Mode

🤖→👤 AI suggests, human approves

- AI automatically completes Backlog grooming, priority scoring, technical debt analysis, and restructuring recommendations
- Human approval focus: whether priority sorting is reasonable, whether technical debt weight is appropriate, whether restructuring recommendations are executable
- Human can ask AI to adjust scoring dimensions or weights; AI regenerates
- After Product Owner approval, outputs prioritized_items for prd-orchestrator consumption

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Requirement pool | JSON array | Yes | Project management system → Requirement pool | User stories, feature requirements, Bugs |
| Technical debt | JSON | Yes | Code quality platform → Technical debt | Debt list, impact assessment |
| Monitoring alerts | JSON | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Unresolved technical issues for urgent priority strategy |
| User feedback | JSON | ○ | Feedback system → User feedback | Complaints, feature requests, suggestions for user value scoring |
| Resource constraints | JSON | ○ | User-provided | Team capacity, available time, dependencies (for effort-adjusted dimension scoring) |
| Quality metrics | JSON | ○ | Test platform/CI/CD → Quality data | Defect count, code coverage, rework rate for technical debt impact analysis |
| Monitoring data | JSON | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Stability, performance change data for debt impact assessment |

**Important**: This Skill has no cross-module dependencies and does not depend on pm-project module outputs; it can execute independently. Resource constraints are provided directly by the user rather than retrieved from pm-project.

## execution-steps Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/execution-steps.md](Reference/execution-steps.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Output

**Output file path**: `docs/monitoring/iteration-plan.md`

### Output Depth Levels

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Backlog priority sorting | Core conclusions + minimum viable deliverable, only Step 1 priority sorting |
| standard | Full Backlog grooming (current default) | Full deliverable, includes all Step 1-4 outputs |
| deep | Full grooming + extended analysis | Full deliverable + technical debt interest trends + long-term roadmap assessment |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["prioritized_items", "backlog_size", "summary"],
  "properties": {
    "generated_at": {"type": "string", "description": "Generation time"},
    "backlog_size": {"type": "object", "description": "Backlog size, including total item count and total story points"},
    "prioritized_items": {"type": "array", "description": "Sorted requirement list, including scores, impact, and dependencies"},
    "technical_debt_priority": {"type": "array", "description": "Technical debt priority list, including interest and priority"},
    "reorganization_summary": {"type": "object", "description": "Restructuring recommendation summary, including promoted/combined/postponed/split counts"},
    "linked_issues": {"type": "object", "description": "Dependency relationships, including dependencies and synergies"},
    "summary": {"type": "object", "description": "Grooming summary, including key findings and recommendations"}
  }
}
```

**Output File Structure**:

```
├── iteration-backlog-grooming.json
├── iteration-backlog-grooming.md
├── backlog/
│   ├── prioritized_items.yaml
│   ├── linked_issues.yaml
│   ├── technical_debt_impact.yaml
│   └── reorganization_suggestions.md
└── latest/
    └── backlog_recommendation.md
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| prioritized_items | array | Yes | Priority-sorted requirement list, each item must contain id/title/priority_score |
| prioritized_items[].priority_score | number | Yes | Priority score, range 0-100 |
| linked_issues | object | No | Dependency relationships, must contain dependency/synergy |
| technical_debt_impact | object | No | Technical debt impact assessment |
| reorganization_suggestions | array | No | Restructuring recommendation list |
| backlog_size | object | Yes | Backlog size, must contain total_items/total_story_points |
| summary | object | Yes | Grooming summary, must contain key_findings/recommendations |

## Decision Rules

| Scenario | Decision Rule |
|------|----------|
| Alert-linked items | Auto-promote priority +2 (max P0) |
| Technical debt interest rate ≥0.7 (fix cost/delay cost) | Mark as "recommended priority repayment", priority +1 |
| Dependency chain conflict | Sort by longest chain first, blocking item priority ≥ blocked item |
| Team capacity utilization ≥90% | Freeze low-priority items (score ≤3), prioritize high-value items |
| Team capacity utilization 70%-90% | Normal scheduling, low-priority items optional |
| New high-priority item (score ≥8) | Evaluate replacing lowest-scored item in current Sprint |
| New medium-priority item (score 5-7) | Add to Backlog, evaluate next Sprint |
| Requirement score ≤3 with no alert link | Downgrade to "watch list", remove if no progress for 2 consecutive Sprints |

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Requirement pool | User provides current requirement list (title + brief), AI re-sorts based on user input | Priority sorting based on user input, lacks system data support |
| Technical debt | Skip technical debt impact analysis, debt weight set to zero in priority score | Sort results without debt impact |
| Monitoring alerts | Skip alert correlation analysis, urgent priority strategy unavailable | Sort results without alert correlation |
| User feedback | User value score inferred from requirement description, mark low confidence | Low-confidence user value score |
| Resource constraints | Skip capacity validation, mark "manual capacity confirmation required" in plan | Adjustment plan without capacity validation |
| Quality metrics | User provides defect count and rework data, AI performs quality analysis directly | Quality analysis based on user input |
| Monitoring data | Skip monitoring data analysis, mark "stability data missing" in debt assessment | Debt assessment without stability dimension |

### Data Acquisition Instructions

When upstream files are missing, obtain necessary data through the following methods:

1. **Requirement pool missing**: Please provide the current requirement list, including requirement title, brief, and type (feature/Bug/optimization); AI will perform priority scoring and sorting based on the provided information
2. **Technical debt missing**: Skip debt impact analysis step, remove debt-related weights from priority scoring formula; recommend supplementing debt list later to improve sorting
3. **Monitoring alerts missing**: Skip alert correlation analysis, cannot auto-promote urgent item priority; recommend user manually flag urgent items
4. **User feedback missing**: User value dimension score will be inferred from requirement description, mark this dimension as low confidence in output; recommend manual confirmation
5. **Resource constraints missing**: Skip capacity matching validation during plan generation, all plans marked "manual team capacity confirmation required"; recommend supplementing resource data later
6. **Quality metrics missing**: Please provide key quality data (Bug count, severity distribution, rework count); AI will perform quality dimension analysis accordingly
7. **Monitoring data missing**: Skip stability analysis, mark stability data missing in debt assessment; recommend exporting from monitoring system to supplement

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Priority score coverage 100%
- [ ] prioritized_items list non-empty
- [ ] Each item contains id/title/priority_score

### P1 Checks (must pass for standard/deep)

- [ ] Dependency relationships completely identified
- [ ] Technical debt impact assessment accurate
- [ ] Restructuring recommendations executable
- [ ] No critical dependencies missed
- [ ] Plan executability ≥ 80%

### P2 Checks (must pass for deep only)

- [ ] Technical debt impact analysis complete (debt interest rate trends, repayment priority sorting, quantified impact on delivery velocity)
- [ ] Comparison with previous Backlog version complete
- [ ] Long-term roadmap assessment generated (3-6 month iteration roadmap, key milestones, resource demand forecast)

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| Project management system | Requirement status change | Priority sorting and dependency analysis | Recalculate priority scores |
| Code quality platform | Technical debt update | Debt impact assessment and weights | Update debt weights and impact scores |
| monitoring-alert-detection | Alert data update | Urgent priority strategy | Update alert correlation and priority promotion |
| Test platform/CI/CD | Quality metrics change | Technical debt impact analysis | Update defect statistics and coverage |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| iteration-orchestrator | Backlog grooming complete | Output file update | Grooming completion status and key conclusions |
| prd-orchestrator | prioritized_items generated | Output file update | Sorted requirement list for design consumption |
