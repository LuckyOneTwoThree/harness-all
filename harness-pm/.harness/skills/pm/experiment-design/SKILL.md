---
name: experiment-design
description: Used when designing a new A/B test experiment. A/B test auto-design, AI automatically performs hypothesis structuring, metric selection, sample size calculation, traffic split design, and experiment configuration generation.
---
# A/B Test Auto-Design

## When to use
- I want to validate if the new homepage improves conversion, help me design an AB test
- How many samples does this feature change need
- Help me design a traffic split experiment plan
- Keywords: A/B test design, experiment design, sample size calculation, traffic split plan, hypothesis testing, do an AB test, want to validate this change, how to design an experiment

## Outputs
- docs/metrics/experiment-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Hypothesis before experiment**: Experiments without structured hypotheses are blind exploration; If-Then-Because-For are all indispensable
2. **Guardrail metrics are as important as primary metrics**: Primary metrics measure "whether it works", guardrail metrics measure "whether it's safe"; both are indispensable
3. **Sample size determines credibility**: Experiments with insufficient statistical power are worse than no experiment; MDE and sample size must be determined in the design phase

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Hypothesis statement | string | Yes | User-provided | Business problem or improvement idea |
| Available traffic | number | Yes | User-provided | Number of users eligible for the experiment |
| Metric system | JSON | ○ | docs/metrics/metrics-system.md | Product key metric definitions |
| Historical data | JSON | ○ | analysis-funnel / analysis-retention | Baseline data for sample size calculation |

## Execution Steps

### Step 1: Hypothesis Structuring [Core]

Transform the raw hypothesis into a structured Hypothesis:

```
Raw hypothesis → Structured Hypothesis
```

**Structured template**:

```
If [we do this change]
Then [this metric] will [increase/decrease]
Because [our hypothesis about why]
For [these users]
```

**Example**:

```
Raw: Simplifying the registration flow can improve conversion rate

After structuring:
If we simplify the registration flow from 5 steps to 3 steps
Then the registration completion rate will increase by 10%
Because users face less friction
For all new users on iOS and Android
```

### Step 2: Metric Auto-Selection [Core]

#### Primary Metric

| Selection Criteria | Description |
|---------|------|
| Directly measures hypothesis | Corresponds to the "then" part of the hypothesis |
| High sensitivity | Can detect expected changes |
| Business relevant | Related to core business goals |

#### Guardrail Metrics

Prevent experiments from having negative impact on the product:

| Type | Example | Threshold |
|-----|------|------|
| Core retention | D7 retention | Must not decline > 2% |
| Revenue metric | ARPU | Must not decline > 5% |
| Technical metric | Page load time | Must not increase > 20% |
| Experience metric | Crash rate | Must not increase > 50% |

#### Secondary Metrics

Provide additional insights:

- Segmentation dimension metrics (for drill-down)
- Correlation metrics (for attribution)
- Exploratory metrics (for discovery)

### Step 3: Sample Size Auto-Calculation [Core]

```
Sample size calculation formula:
n = 2 * (Zα + Zβ)² * p̄(1-p̄) / MDE²

Where:
- Zα: Significance level (usually 1.96 for α=0.05)
- Zβ: Statistical power (usually 0.84 for power=80%)
- p̄: Baseline conversion rate
- MDE: Minimum detectable effect
```

**Calculator configuration**:

```yaml
sample_size_calculation:
  significance_level: 0.05
  statistical_power: 0.80

  # Primary metric parameters
  primary_metric:
    baseline_rate: 0.15  # Baseline conversion rate 15%
    minimum_detectable_effect: 0.10  # Minimum detectable lift 10%
    relative_mde: 0.015  # Absolute lift 1.5% (15% * 10%)

  result:
    sample_size_per_group: 12400
    total_sample_size: 24800
    expected_duration_days: 7
```

### Step 4: Traffic Split Design [Core]

#### Split Principles

| Principle | Description |
|-----|------|
| Randomness | Users randomly assigned |
| Uniformity | Each group's feature distribution consistent |
| Independence | Users only in one experiment group |
| Consistency | User experience stable |

#### Split Layers

```
Traffic
├── Layer 1: Experience consistency experiments
├── Layer 2: Core functionality experiments
├── Layer 3: Personalization experiments
└── Layer 4: Marketing experiments
```

#### Split Ratios

| Scenario | Recommended Ratio | Description |
|-----|---------|------|
| Standard test | 50/50 | Highest statistical power |
| High risk | 90/10 | Reduce impact surface |
| High uncertainty | 50/25/25 | Multi-option comparison |
| Canary release | 95/5 | Minimum traffic validation |

### Step 5: Experiment Configuration Generation [Core]

Generate complete experiment configuration:

> See [Reference/experiment-config-example.md](./Reference/experiment-config-example.md) for the full ab_test_design YAML example (experiment info, structured hypothesis, metrics, sample size, traffic split, termination conditions, variants, technical config, risk assessment).

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Experiment design and hypothesis | Core conclusion + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, includes all Step outputs |
| deep | Full design + statistical power calculation + multivariate experiment plan + result interpretation framework | Full artifact + extended analysis + deep inference |

## Output

**Storage path**: `docs/metrics/experiment-report.md ("Experiment Design" section)`

**Output file**: experiment_design.json

**Output Schema** and validation rules:

> See [Reference/output-schema-and-validation.md](./Reference/output-schema-and-validation.md) for the output JSON schema (hypothesis, primary_metric, guardrail_metrics, sample_size, traffic_allocation, termination_conditions, risk_assessment) and the field validation rules table.

### Required Outputs

1. **Experiment design plan**: Complete experiment configuration
2. **Sample size estimation**: Sample requirements based on statistical calculation
3. **Risk assessment**: Experiment risks and mitigation measures

### Auxiliary Outputs

1. **Historical reference**: Results reference from similar experiments
2. **Recommendation list**: Pre-launch checklist items
3. **Monitoring configuration**: Experiment monitoring dashboard configuration

## Execution Checklist

```
□ Hypothesis structuring complete
□ Primary metric clearly defined
□ Guardrail metrics set
□ Sample size calculation complete
□ Traffic split plan design complete
□ Termination conditions set
□ Technical configuration complete
□ Risk assessment complete
□ Experiment configuration reviewed and approved
```

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Hypothesis statement change | Structured hypothesis and metric selection | Re-structure hypothesis, update metric selection |
| Available traffic change | Sample size calculation and experiment duration | Recalculate sample size, update expected experiment duration |
| Metric system change | Primary metric and guardrail metrics | Update metric selection, re-evaluate guardrail metric coverage |
| Historical data change | Baseline value and MDE | Update baseline value, recalculate sample size |

When experiment design itself changes, the downstream notification mechanism:

| Design Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Primary metric change | experiment-execution | Mark primary metric change, trigger execution configuration update |
| Guardrail metric change | experiment-execution | Mark guardrail change, trigger monitoring configuration update |
| Traffic split plan change | experiment-execution | Mark traffic split change, trigger split configuration update |

---

## Decision Rules

| Situation | Handling |
|------|----------|
| Available traffic < sample size requirement | Extend experiment duration or increase traffic split ratio |
| Guardrail metric threshold breached | Pause experiment, human decision |
| MDE too small leading to excessive sample size | Adjust MDE or accept longer experiment duration |
| Multiple experiments competing for same traffic layer | Queue by priority or use orthogonal layering |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Hypothesis structured (If-Then-Because-For)
- [ ] Primary metric directly corresponds to hypothesis

### P1 Checks (must pass for standard/deep)

- [ ] Guardrail metrics cover retention, revenue, and technical dimensions
- [ ] Sample size calculation parameters are justified

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision record complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Hypothesis statement missing | Cannot execute, user needs to describe hypothesis | - |
| Available traffic missing | Use conservative default value (5% of total traffic), mark "to be confirmed" | Sample size calculation based on conservative assumption, experiment duration may be longer |
| Metric system missing | Infer primary and guardrail metrics based on hypothesis description, mark "to be confirmed" | Metric selection based on inference, may not be comprehensive |
| Hypothesis statement + available traffic + metric system all missing | User describes hypothesis → design experiment based on description | Output experiment design plan, key parameters marked "to be confirmed" |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degradation generation:
- **Hypothesis description**: The improvement idea and expected effect to be validated
- **Available traffic** (optional): Number of users or traffic ratio eligible for the experiment
- **Key metrics** (optional): Primary metrics and guardrail metrics the experiment focuses on

## Design Principles

| Principle | Description |
|-----|------|
| Single variable | Only change one factor per experiment |
| Sufficient sample | Ensure statistical power |
| Reasonable duration | Cover complete user cycle |
| Guardrail protection | Prevent negative impact |
| Repeatable | Support repeated validation |
