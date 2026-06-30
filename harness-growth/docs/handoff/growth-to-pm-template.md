---
schema_version: "1.0"
handoff_id: "<GROWTH-PM-YYYYMMDD-NNN>"
producer: "harness-growth"
consumer: "harness-pm"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
ac_ids: []
artifacts: []
---

# Handoff: harness-growth → harness-pm

> This template is the **producer template** for harness-growth, used to generate `growth-to-pm.md` as feedback to harness-pm.
> When the session-end skill produces this contract document, copy this template and fill in the actual content.

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed 3 rounds of Q2 growth experiments, content channel CAC reduced from $17 to $9>

## Experiment Results

| Experiment ID | Experiment name | Hypothesis | Primary metric | Conclusion | Statistical significance |
|---------|---------|------|---------|------|-----------|
| G-001 | <experiment name> | <doing X will increase Y by Z%> | <metric name: baseline → experiment> | Effective/Ineffective/Inconclusive | p<0.05 / confidence interval |
| G-002 | <experiment name> | <hypothesis> | <metric> | <conclusion> | <p-value> |

### Experiment Details

> Expand on each experiment: design, sample size, duration, groups, data, conclusion.

#### G-001: <experiment name>

- **Hypothesis**: <doing X will increase Y by Z%>
- **Primary metric**: <metric name> (baseline <value> → target <value>)
- **Guardrail metric**: <metric name> (to prevent side effects)
- **Experiment design**: sample <N>, duration <days>, groups <A/B>
- **Result**: <actual data>
- **Conclusion**: Effective / Ineffective / Inconclusive
- **Action recommendation**: Scale up / Stop / Redesign

## User Feedback

| Feedback source | Content summary | Priority | Suggested action |
|---------|---------|--------|---------|
| <channel: support / social media / survey> | <feedback summary> | P0/P1/P2 | <suggestion> |
| <channel> | <feedback summary> | <priority> | <suggestion> |

### Feedback Analysis

<Categorize and aggregate the collected user feedback to distill common issues and opportunities.>

## Growth Recommendations

Based on experiment data and user feedback, recommendations for the next product steps:

| Recommendation | Basis | Priority | Impact scope |
|------|------|--------|---------|
| <Recommendation 1: e.g., "Optimize registration flow"> | <Experiment G-001 data + user feedback> | P0 | <Acquisition conversion> |
| <Recommendation 2: e.g., "Add feature X"> | <User feedback aggregation> | P1 | <Retention> |
| <Recommendation 3> | <basis> | <priority> | <scope> |

## Metric Anomalies (if any)

| Metric | Baseline | Current | Change | Cause analysis |
|------|------|------|------|---------|
| <metric name> | <value> | <value> | <±X%> | <attribution analysis> |

> Record only anomalous fluctuations (outside the normal range); do not record routine fluctuations.

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Scale up experiment X | Conversion rate increased 15%, statistically significant | Roll out site-wide |
| Stop channel Y | ROI < 1, no improvement for 3 consecutive months | Reallocate resources |

## Open Items

Issues for harness-pm to handle or confirm with harness-growth:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Suggested Next Steps

harness-pm should prioritize:

1. Consume the experiment conclusions + growth recommendations in this file
2. Incorporate effective experiments into iteration planning (iteration-orchestrator)
3. Incorporate user feedback into the backlog (backlog-grooming)

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Growth bottleneck X | High/Medium/Low | <action> |
| Metric anomaly Y | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-pm's insight / iteration skills will auto-detect this file and read the experiment conclusions + growth recommendations.
If not auto-detected, you can manually point the Agent to this file path to read it.
