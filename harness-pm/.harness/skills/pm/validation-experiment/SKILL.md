---
name: validation-experiment
description: Used when designing validation experiment plans. Validation experiment auto-design tool, based on assumption map and MVP scope, intelligently selects validation methods and designs experiment plans, including parameter design for A/B testing and usability testing. Keywords: experiment design, A/B testing, sample size, validation method, validation plan, test design. This Skill is only responsible for selecting validation methods and outputting the experiment design framework; it does not generate specific usability test task scripts (handled by validation-usability).
---
# Validation Experiment Auto-Design

## When to use
- How to validate this hypothesis
- Help me design an A/B test
- How to make an experiment plan

## Outputs
- docs/metrics/experiment-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Experiments are the court of judgment for hypotheses**—every experiment must correspond to a hypothesis; an experiment without a hypothesis is waste
2. **Maximum confidence at minimum cost**—experiment design pursues cost minimization, not perfect data
3. **Statistical significance is the baseline**—sample size and confidence level must be set in advance; post-hoc adjustment is cheating
4. **Failed experiments are as valuable as successful ones**—falsifying a hypothesis is equivalent to confirming one; the key is what was learned

### Basic Information

| Attribute | Value |
|------|-----|
| Pipeline ID | 12 |
| Name | Validation Experiment Auto-Design |
| Execution Mode | 🤖→👤 AI suggests, human approves |
| Inputs | Assumption map + MVP scope + available traffic/user data |

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Assumption map | JSON | Yes | docs/product/PRD.md ("Assumption Map" section) | Assumption map output by Pipeline 10 |
| MVP scope | JSON | Yes | docs/product/PRD.md ("MVP Plan" section) | MVP scope output by Pipeline 11 |
| Available traffic/user data | JSON | ○ | User-provided | Current user count, DAU, new users, etc. |

### Input Format
```json
{
  "assumption_map": [...],
  "mvp_scope": {...},
  "traffic_data": {
    "daily_active_users": 10000,
    "new_users_daily": 500,
    "weekly_users": 50000,
    "conversion_rate": 0.03
  }
}
```

## Execution Steps

### Step 1: Validation Method Selection [Core]

**Decision tree**:

```
Start
  ↓
Is traffic sufficient for A/B testing?
  ↓
Yes → Consider A/B testing
No → Consider usability testing
  ↓
Cost considerations
  ↓
Wizard MVP / Prototype testing / Landing page testing
```

**Validation method comparison**:

| Method | Applicable Scenario | Cost | Reliability |
|------|----------|------|--------|
| A/B testing | Sufficient traffic, needs quantitative validation | High | ⭐⭐⭐⭐⭐ |
| Usability testing | Insufficient traffic, needs qualitative insights | Medium | ⭐⭐⭐⭐ |
| Landing page testing | Value hypothesis validation | Low | ⭐⭐⭐ |
| Wizard MVP | Feasibility validation | High | ⭐⭐⭐⭐ |
| Prototype testing | Usability hypothesis validation | Low | ⭐⭐⭐⭐ |

**Selection rules**:

| Condition | Recommended Method |
|------|----------|
| DAU > 5000, and hypothesis is quantifiable | A/B testing |
| DAU < 5000 | Usability testing |
| Need to quickly validate value hypothesis | Landing page testing |
| Need to validate technical feasibility | Wizard MVP |

### Step 2: Experiment Plan Design [Core]

#### A/B Test Design Plan

```json
{
  "experiment_design": {
    "type": "A/B_TEST",
    "experiment_group": "Experiment group description",
    "control_group": "Control group description",
    "split_ratio": "50/50",
    "primary_metric": "Primary metric",
    "secondary_metrics": ["Secondary metrics"],
    "sample_size": 10000,
    "duration_days": 14,
    "minimum_detectable_effect": "MDE",
    "stopping_criteria": {
      "significance_level": 0.05,
      "statistical_power": 0.8,
      "early_stopping_conditions": ["Reached significance"]
    }
  }
}
```

**Parameter calculation description**:

| Parameter | Description | Calculation Basis |
|------|------|----------|
| sample_size | Required sample size | Based on MDE, significance level, statistical power |
| duration_days | Experiment duration | sample_size / daily average traffic |
| split_ratio | Traffic split ratio | Commonly 50/50, adjustable |

#### Usability Test Design Framework

When method = usability testing, this Skill only outputs **method selection + experiment framework**, and does not generate specific usability test task scripts.

```json
{
  "method_selection": {
    "selected_method": "USABILITY_TEST",
    "reason": "Insufficient traffic or needs qualitative insights"
  },
  "experiment_framework": {
    "hypothesis": "Usability hypothesis to be validated",
    "metrics": ["Task completion rate", "Task duration", "Error rate"],
    "sample_size": 8,
    "duration_days": 7
  }
}
```

> ⚠️ **Responsibility boundary**: Specific test task scripts (task_script), recruitment screening questionnaires (recruitment_criteria) and other detailed artifacts are generated by the **validation-usability** Skill; this Skill does not output these fields. When method=USABILITY_TEST, downstream validation-usability consumes this Skill's method_selection and experiment_framework.

### Step 3: Outcome Prediction [Core]

**Three scenarios**:

```json
{
  "outcome_scenarios": {
    "optimistic": {
      "condition": "Metric lift ≥ MDE",
      "action": "Proceed with development, continue monitoring"
    },
    "neutral": {
      "condition": "Metric has lift but not significant",
      "action": "Extend experiment or adjust plan"
    },
    "pessimistic": {
      "condition": "Metric has no lift or declines",
      "action": "Re-examine hypothesis or adjust plan"
    }
  }
}
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Experiment plan and validation metrics | Core conclusion + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, includes all Step outputs |
| deep | Full plan + experiment design optimization + statistical power analysis + result interpretation framework | Full artifact + extended analysis + deep inference |

## Output


**Output validation rules**: See section below
**Storage path**: `docs/metrics/experiment-report.md ("Experiment Design" section)`
**Output file**: experiment_plan.json

**Output Schema example** (experiment_plan.json with A/B test and usability test entries) and the **field validation rules table**:

> See [Reference/output-schema-and-validation.md](./Reference/output-schema-and-validation.md) for the complete experiment_plan.json example (experiments array with EXP001 A/B_TEST and EXP002 USABILITY_TEST, approval_status, ai_recommendation) and the field validation rules table (experiments[].id/assumption_id/type/hypothesis/method/metrics/sample_size/duration/confidence_level/cost_estimate/result).

## Decision Rules

| Rule | Condition | Action |
|------|------|------|
| Human review | All experiment plans | Must be human-reviewed |
| Insufficient sample size | sample_size > available traffic | Lower MDE or switch to usability testing |
| Duration too long | duration_days > 30 | Consider increasing traffic or lowering MDE |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Method selection has basis (decision tree result has explanation)
- [ ] Experiment design complete (includes all necessary parameters)

### P1 Checks (must pass for standard/deep)

- [ ] Success criteria clear (has quantifiable metrics)
- [ ] Scenario prediction complete (all three scenarios present)
- [ ] Termination conditions clear (includes significance/power requirements)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision record complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|----------|------------|
| Assumption map missing | User provides hypothesis description, design experiment | Lacks structured hypothesis data, experiment design may not be precise enough | Require user to provide hypothesis description and priority or upload assumption-map file |
| MVP plan missing | User provides solution description, design experiment | Lacks MVP plan data, experiment variables may not be focused enough | Require user to provide MVP plan description or upload validation-mvp output file |
| Assumption map + MVP plan both missing | User provides hypothesis and solution description, design experiment | Overall confidence reduced, experiment design may not be complete enough | Require user to provide hypothesis description and solution overview |
| All upstream files missing | Prompt user to execute prior stages first, or design experiment based on user description | Output is only a basic experiment framework | Require user to provide core hypotheses, solution description, and available resources |

## Output Validation Rules

> See [Reference/output-schema-and-validation.md](./Reference/output-schema-and-validation.md#output-validation-rules) for the field validation rules table (experiments[].id/assumption_id/type/hypothesis/method/metrics/sample_size/duration/confidence_level/cost_estimate/result).

## Upstream Change Response

### Upstream Change Impact

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Assumption map change (hypothesis add/remove/score change) | Experiment hypotheses, experiment priority | Flag affected experiments, suggest human confirm whether to redesign |
| Solution design change | Experiment design details | Flag affected experiment designs, suggest human confirm whether to adjust |
| Resource constraint change | Experiment cost estimate, sample size | Flag affected cost and sample size, suggest human confirm whether to adjust |

### Downstream Notification Mechanism

| Experiment Design Change Type | Notification Scope | Notification Method |
|-----------------|----------|----------|
| Experiment add/remove | validation-mvp | Mark experiment change, trigger MVP scope adjustment |
| Experiment priority change | validation-mvp | Mark priority change, trigger MVP validation plan update |
| Experiment result update | validation-mvp | Mark result update, trigger MVP hypothesis validation status update |

---

## Usage Example

> See [Reference/usage-example.md](./Reference/usage-example.md) for a complete end-to-end example: input (assumption_map + traffic_data), AI analysis (traffic assessment, hypothesis type, recommended method, experiment design), and output (validation_experiment JSON).
