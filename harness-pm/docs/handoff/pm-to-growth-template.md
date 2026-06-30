---
schema_version: "1.0"
handoff_id: "<PM-GROWTH-YYYYMMDD-NNN>"
producer: "harness-pm"
consumer: "harness-growth"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
ac_ids: []
artifacts: []
---

# Handoff: harness-pm → harness-growth

> Generated at: YYYY-MM-DD HH:MM
> Source framework: harness-pm
> Target framework: harness-growth

## Phase Summary

<One-sentence summary of what was done in this phase. e.g., Completed V1 product positioning + North Star metric definition + OKR breakdown>

## Product Basics

| Field | Value | Notes |
|------|-----|------|
| Product name | <name> | |
| Product type | <web app / mobile app / desktop / landing page / ...> | Determines growth channel strategy |
| Target audience | <audience description> | Influences acquisition strategy |
| Current stage | <MVP / PMF / Scaling / ...> | Determines growth focus |

## Positioning Statement

<One-sentence positioning, from positioning skill output. e.g., A one-stop project management tool for indie developers>

## North Star Metric

| Field | Value | Notes |
|------|-----|------|
| Metric name | <e.g., Weekly Active Users / Paid Users> | |
| Current value | <value> | If no data, fill in "To be measured" |
| Target value | <value> | Target for this phase |

## OKR

> From planning-okr skill output.

| Objective | Key Result | Current value | Target value | Cycle |
|-----------|------------|--------|--------|------|
| <Objective 1> | <KR1> | <value> | <value> | <e.g., 2026 Q2> |
| <Objective 1> | <KR2> | <value> | <value> | |
| <Objective 2> | <KR3> | <value> | <value> | |

## Persona

| Persona | Path | Growth traits |
|---------|------|---------|
| Primary user | artifacts/research/user-research.md ("User Personas" section) | <acquisition channel preference / willingness to pay> |
| Secondary user | artifacts/research/user-research.md ("User Personas" section) | <acquisition channel preference / willingness to pay> |

> Persona data is stored in the "User Personas" section of user-research.md.

## Existing Data Assets (if any)

| Asset | Path | Notes |
|------|------|------|
| Metric definitions | artifacts/metrics/definitions.md | <if any> |
| Tracking plan | artifacts/metrics/tracking-plan.md | <if any> |
| Historical experiments | artifacts/metrics/experiments/ | <if any> |
| Decision records | artifacts/metrics/decision-report.md | <if any> |

> For a brand-new project, fill in "None".

## Growth Hypotheses

<List of growth hypotheses to validate, e.g.,:>
- Hypothesis 1: Content marketing acquisition CAC < $7
- Hypothesis 2: Free trial → paid conversion rate > 5%
- Hypothesis 3: Day-7 retention > 30%

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Prioritize growth channel X | Target audience match + controllable CAC | Acquisition strategy |
| Skip channel Y | ROI below expectations | Scope boundary |

## Open Items

Issues for harness-growth to handle or confirm with harness-pm:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Suggested Next Steps

harness-growth should prioritize:

1. Consume the OKR + growth hypotheses in this file
2. Design growth experiments (A/B tests)
3. Set up metric dashboards + alerts

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Baseline data missing | High/Medium/Low | <action> |
| Metric definitions unclear | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

harness-growth's growth experiment skill will auto-detect this file and read the OKR + growth hypotheses.
If not auto-detected, you can manually point the Agent to this file path to read it.
