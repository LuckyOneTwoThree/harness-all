---
workflow_id: E
name: lifecycle-operations-workflow
description: "Manage user lifecycle through segmentation, onboarding design, aha-moment identification, and churn rescue"
default_mode: standard
---

# Workflow: Lifecycle Operations Workflow

> LOOP type: lifecycle / optimization
> Trigger scenarios: Lifecycle operations ongoing, retention optimization initiative
> Orchestration Skill: user-segmentation → onboarding-design → aha-moment-identification → retention-analysis → churn-rescue

## Flowchart

```
┌─────────────────────┐
│ user-segmentation    │  User segmentation (RFM/lifecycle/value)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ onboarding-design    │  Onboarding flow design
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ aha-moment-identify  │  Aha Moment identification and validation
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ retention-analysis   │  Retention curve analysis (Cohort/RBM)
│    [Measurement Gate]│
└─────────┬───────────┘
          │ Retention not met
          ▼
┌─────────────────────┐
│ churn-rescue         │  Churn alert + rescue campaign
└─────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| After retention-analysis | Retention curve trending flat | Not flat → enter churn-rescue |
| Before churn-rescue | Rescue cost ≤ LTV/3 | Cost exceeds → adjust rescue strategy |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| user-segmentation | Segment definitions | docs/operations/segments.md + knowledge-base.md |
| onboarding-design | Onboarding plan | docs/operations/onboarding-plan.md |
| aha-moment-identification | Aha Moment definition | docs/operations/aha-moment.md + knowledge-base.md |
| retention-analysis | Retention report | docs/operations/retention-analysis.md |
| churn-rescue | Rescue plan | docs/operations/churn-rescue-plan.md + knowledge-base.md |

## Interaction with LOOP

```
LOOP(lifecycle):
  PLAN:       user-segmentation → onboarding-design → aha-moment-identification
  EXPERIMENT: [launch onboarding/outreach]
  MEASURE:    retention-analysis → churn-rescue
  Pass? DONE : Back to PLAN (adjust segmentation/onboarding)
```

## Feedback Loop

retention-analysis and churn-rescue outputs feed back to user-segmentation:
- Segments with improved retention → summarize success patterns
- Segments with severe churn → adjust segmentation rules or operations strategy
- Rescue effectiveness → update outreach strategy in segment library

## Usage

Tell the Agent:
- "Analyze user segments" → Start from user-segmentation
- "Design onboarding" → Start from onboarding-design
- "Find aha moment" → Start from aha-moment-identification
- "Analyze retention" → Start from retention-analysis
- "Design rescue strategy" → Start from churn-rescue
