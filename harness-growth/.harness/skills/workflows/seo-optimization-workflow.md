---
workflow_id: D
name: seo-optimization-workflow
default_mode: standard
---

# Workflow: SEO Optimization Workflow

> LOOP type: seo
> Trigger scenarios: Monthly SEO optimization cycle, new site SEO launch, ranking anomaly fluctuations
> Orchestration Skill: keyword-research → serp-analysis → onpage-optimization → technical-seo-audit → [publish optimization] → ranking-tracking

## Flowchart

```
┌─────────────────────┐
│ keyword-research     │  Keyword research (expansion/intent/difficulty/priority)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ serp-analysis        │  SERP competitor analysis (content gap/opportunity)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ onpage-optimization  │  On-page optimization (title/Meta/content/internal links/Schema)
└─────────┬───────────┘
          ▼
┌─────────────────────┐
│ technical-seo-audit  │  Technical audit (crawler/CWV/indexing/mobile)
│    [Quality Gate]    │
└─────────┬───────────┘
          │ P0 issues fixed
          ▼
   [Publish optimization, external]
   (Engineering team launches optimization plan)
          ▼
┌─────────────────────┐
│ ranking-tracking     │  Ranking tracking and attribution
└─────────────────────┘
```

## Quality Gates

| Gate | Checks | On Failure |
|--------|---------|-----------|
| After technical-seo-audit | P0 issues (indexing blocked/robots errors) must be fixed | Block publish, fix P0 first |
| Before ranking-tracking | Optimization plan is live | Wait for launch before tracking |

## Data Flow

| Stage | Output | Storage Location |
|------|------|---------|
| keyword-research | Keyword list | docs/seo/keyword-research.md + knowledge-base.md |
| serp-analysis | SERP analysis report | docs/seo/serp-analysis.md |
| onpage-optimization | Optimization plan | docs/seo/onpage-optimization.md |
| technical-seo-audit | Technical audit report | docs/seo/technical-audit.md |
| ranking-tracking | Ranking report | docs/seo/ranking-report.md + knowledge-base.md |

## Interaction with LOOP

```
LOOP(seo):
  PLAN:       keyword-research → serp-analysis
  EXPERIMENT: onpage-optimization → technical-seo-audit → [publish]
  MEASURE:    ranking-tracking
  Pass? DONE : Back to PLAN (new keywords) / EXPERIMENT (adjust optimization)
```

## Feedback Loop

ranking-tracking output feeds back to keyword-research:
- Keywords with rising rankings → summarize success patterns, apply to other keywords
- Keywords with falling rankings → analyze cause, adjust strategy
- New opportunity keywords → input for next round of keyword-research

## Usage

Tell the Agent:
- "Run an SEO optimization" → Start from keyword-research
- "Research keywords" → Start from keyword-research
- "Analyze competitor SERP" → Start from serp-analysis
- "Optimize this page" → Start from onpage-optimization
- "Check technical SEO" → Start from technical-seo-audit
- "View ranking changes" → Start from ranking-tracking
