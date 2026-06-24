---
workflow_id: C
name: content-marketing-workflow
description: "Produce and distribute content through ideation, creation, review, multi-channel distribution, and performance tracking"
default_mode: standard
---

# Workflow: Content Marketing Workflow

> LOOP type: content
> Trigger scenarios: Content production cycle (weekly/biweekly)
> Orchestration Skill: content-ideation → content-creation → content-review → content-distribution → [publish] → content-performance

## Flowchart

```
┌─────────────────────┐
│ content-ideation     │  Topic selection (keyword × intent × value evaluation)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ content-creation     │  Creation (outline → draft → SEO optimization)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ content-review       │  Review (compliance/factual/brand/SEO four-dimensional review)
│    [Quality Gate]    │
└─────────┬───────────┘
          │ Pass
          ▼
┌─────────────────────┐
│ content-distribution │  Distribution (multi-channel adaptation, multi-purpose repurposing)
└─────────┬───────────┘
          ▼
   [Publish, external]
   (Publish to each channel)
          ▼
┌─────────────────────┐
│ content-performance  │  Measurement (traffic/engagement/conversion/reuse suggestions)
└─────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| content-review | Compliance + factual accuracy + brand consistency + SEO meets standard | Return to content-creation for revision |
| Before content-distribution | content-review must pass | Block publish |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| content-ideation | Topic list | docs/content/ideation-backlog.md + knowledge-base.md |
| content-creation | Content draft | docs/content/drafts/ |
| content-review | Review report | docs/content/drafts/*.review.md |
| content-distribution | Multi-channel versions | docs/content/published/ |
| content-performance | Performance report | docs/content/performance-report.md + knowledge-base.md |

## Interaction with LOOP

```
LOOP(content):
  PLAN:       content-ideation
  EXPERIMENT: content-creation → content-review → content-distribution
  MEASURE:    content-performance
  Pass? DONE : Back to PLAN (new topics) / EXPERIMENT (revise content)
```

## Feedback Loop

content-performance output feeds back to content-ideation:
- High-performing topic directions → reference for next round of topic selection
- Low-performing topic directions → tag as "validated low-efficiency"
- Successful patterns → write to knowledge base "growth pattern consolidation"

## Usage

Tell the Agent:
- "I want to create a piece of content about X" → Start from content-ideation
- "Help me write this content" → Start from content-creation
- "Review this content" → Start from content-review
- "Distribute this content" → Start from content-distribution (requires passing review first)
- "Analyze content performance" → Start from content-performance
