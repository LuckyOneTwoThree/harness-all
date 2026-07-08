---
name: experiment-execution
description: Used when executing A/B tests, analyzing results, and generating complete reports. A/B test auto-execution, analysis, and report generation; AI automatically performs monitoring during experiment runtime and analysis after experiment completion, including statistical testing, business significance assessment, multi-dimensional drill-down, novelty effect detection, and generates a complete A/B test report containing experiment overview, statistical conclusions, effect analysis, and action recommendations.
---
# A/B Test Auto-Execution, Analysis & Reporting

## When to use
- AB test finished, help me analyze the results
- Experiment data looks different, is it significant
- Help me monitor a running experiment
- Help me produce a complete AB test report
- Experiment done, write a summary report
- Organize experiment results into a presentable document
- Keywords: A/B test execution, statistical testing, experiment analysis, novelty effect, experiment monitoring, experiment result analysis, AB test finished help me analyze results, how to read experiment data, is it significant, A/B test report, experiment report, statistical conclusion, effect analysis, experiment summary, produce an experiment report, AB test summary, experiment result presentation

## Outputs
- docs/metrics/experiment-report.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Statistically significant ≠ practically effective**: The p-value only tells you "a difference exists"; the effect size tells you "how big the difference is and whether it's worth doing"
2. **Heterogeneity is the hidden truth**: An overall positive may mask a negative for some segment; without drill-down you don't know the true effect
3. **Novelty effect is the experiment trap**: Initial effects may decay over time; stability is what makes it credible
4. **The experiment report is the basis for decisions, not a pile of data**: The core value of the report is converting statistical conclusions into actionable recommendations, answering "what should we do" and "why"

## Interaction Mode

### In-Run Monitoring Mode

```
Scheduled execution (daily/every 4 hours)
├── Data sync check
├── Sample size progress
├── Primary metric trend
├── Guardrail metric check
├── Statistical significance check
└── Anomaly detection
```

### Post-Completion Analysis + Report Mode

```
Trigger condition: Termination condition reached
├── Lock data
├── Statistical analysis
├── Drill-down analysis
├── Generate conclusions
├── Generate report
└── Output recommendations
```

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Experiment design document | object | Yes | docs/metrics/experiment-report.md ("Experiment Design" section) | Experiment plan output by experiment-design |
| Experiment data | object | Yes | User-provided | Grouped data, metric data, guardrail metric data |
| Termination conditions | object | Yes | docs/metrics/experiment-report.md ("Experiment Design" section) | Sample size target, run duration, minimum detectable effect |
| Product background | text | No | User input | Product stage, business goals, historical experiments |

## Execution Steps

### Step 1: Experiment Monitoring & Result Analysis (original experiment-execution) [Core]

Statistical testing, business significance assessment, multi-dimensional drill-down, novelty effect detection

#### 1.1 Statistical Significance Testing

##### Test Method Selection

| Metric Type | Test Method | Description |
|---------|---------|------|
| Proportion (conversion rate) | Z-test / Chi-square test | Binomial distribution |
| Mean (revenue) | T-test / Mann-Whitney | Normal/non-normal |
| Distribution (duration) | KS test | Distribution difference |
| Multi-metric | FDR correction | Multiple testing |

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.1: Statistical Significance Testing Output" for the output format YAML example.

#### 1.2 Practical Business Significance Assessment

Statistically significant ≠ practically effective

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.2: Practical Business Significance" for the assessment YAML example.

#### 1.3 Multi-Dimensional Drill-Down Analysis [Conditional]

##### Heterogeneous Effect Detection

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.3: Heterogeneous Effect Detection" for the heterogeneous effects YAML example.

#### 1.4 Novelty Effect Detection [Deep]

Detect abnormal initial user behavior:

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.4: Novelty Effect Detection" for the novelty check YAML example.

#### 1.5 Decision Recommendation Generation

> See [Reference/examples.md](./Reference/examples.md) → "Step 1.5: Decision Recommendation" for the decision recommendation YAML example.

### Step 2: A/B Test Report Generation (from experiment-report) [Conditional]

Experiment overview, statistical conclusions, effect analysis, action recommendations

#### 2.1 Experiment Overview Assembly

Extract core elements from the experiment design plan:

1. **Experiment identity**: Experiment name, ID, run period, sample size
2. **Hypothesis statement**: Null hypothesis H₀ and alternative hypothesis H₁
3. **Metric system**: Core metric (OEC), guardrail metrics, secondary metrics
4. **Traffic split plan**: Experiment/control group ratio, traffic share, layering strategy

#### 2.2 Statistical Conclusion Extraction

Extract statistical conclusions from experiment execution results:

1. **Core metric conclusion**: Effect size, confidence interval, p-value, statistical power
2. **Guardrail metric check**: Whether each guardrail metric triggered alert threshold
3. **Sample size validation**: Whether actual sample size meets preset MDE requirement
4. **Statistical significance determination**: Significant/not significant/marginal, with judgment basis

#### 2.3 Effect Deep Analysis

Multi-dimensional analysis of core effects:

1. **Effect size interpretation**: Absolute lift, relative lift, business impact conversion
2. **Heterogeneous effects**: Drill-down analysis by user segments (new/returning, platform, region, etc.)
3. **Novelty effect assessment**: Short-term effect vs long-term effect prediction
4. **Interaction effects**: Potential interactions with other running experiments

#### 2.4 Action Recommendation Generation

Based on statistical conclusions and effect analysis, generate tiered action recommendations:

| Conclusion Type | Recommendation Level | Action |
|----------|----------|------|
| Core metric significantly positive + guardrail safe | 🟢 Strongly recommend full release | Full release + monitoring plan |
| Core metric significantly positive + guardrail at risk | 🟡 Conditional recommendation | Phased full release + guardrail-specific optimization |
| Core metric not significant | 🔵 Need more information | Extend duration/increase sample/adjust metrics |
| Core metric significantly negative | 🔴 Recommend termination | Terminate experiment + root cause analysis |
| Heterogeneous effect significant | 🟠 Segment strategy | Differentiated release by segment |

#### 2.5 Report Assembly

Assemble the above content into a complete report.

> See [Reference/examples.md](./Reference/examples.md) → "Markdown Report Structure" for the report template, and "Structured Report Data Example" for the JSON report data example.

## Output

**Storage path**: `docs/metrics/experiment-report.md ("Experiment Results" section)`

**Output files**:

| File | Path | Description |
|------|------|------|
| Experiment result data | `docs/metrics/experiment-report.md ("Experiment Results" section)` | Machine-consumable experiment result data |
| A/B test report | `docs/metrics/experiment-report.md ("Experiment Results" section)` | Human-readable complete report |
| Structured report data | `docs/metrics/experiment-report.md ("Experiment Results" section)` | Machine-consumable structured report data |

> See [Reference/output-schema.md](./Reference/output-schema.md) for output JSON schema and output validation rules.
> See [Reference/examples.md](./Reference/examples.md) → "Experiment Result Data Example" for the result data YAML example.

## Decision Rules

| Condition Combination | Decision |
|---------|------|
| Primary metric significant + meaningful, guardrail safe | Full release |
| Primary metric significant, guardrail has issues | Analyze guardrail cause, then decide |
| Primary metric not significant | Continue experiment or terminate |
| Novelty effect present | Extend experiment |
| Heterogeneity significant | Release by segment |

## Quality Checks

- [ ] Experiment group traffic allocation correct (P0)
- [ ] Guardrail metrics did not trigger alerts (P0)
- [ ] Experiment data collection complete (P0)
- [ ] Statistical significance calculation correct (P0)
- [ ] Statistical conclusions consistent with data (P1)
- [ ] Action recommendations consistent with conclusions (P1)
- [ ] Guardrail metrics fully covered (P1)
- [ ] Heterogeneous effects analyzed (at least 3 segment dimensions) (P2)

## Degradation Strategy

When upstream files are missing, this Skill can execute independently through user-provided data.

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Degradation Strategy - Upstream File Missing" and "Data Acquisition Instructions" for the full degradation table and data acquisition methods.

## Upstream Change Response

> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Upstream Change Response" for upstream/downstream change impact and notification mechanism tables.
> See [Reference/decision-tables.md](./Reference/decision-tables.md) → "Execution Frequency" for monitoring/analysis/report execution frequency.
