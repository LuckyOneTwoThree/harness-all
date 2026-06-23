---
name: content-performance
description: Analyze content performance (traffic/dwell/conversion/ROI), produce reuse recommendations, and feed back to the ideation stage
triggers:
  - When data is available after content is published
  - MEASURE phase of the content marketing Loop
  - User asks to "analyze content performance"
reads:
  - docs/content/published/
  - memory/knowledge-base.md
  - loops/specs/<content>/state.yaml
writes:
  - docs/content/performance-report.md
  - memory/knowledge-base.md
  - loops/specs/<content>/state.yaml
  - loops/specs/<content>/iterations.log
quality_gates: []
max_iterations: 1
---

# Content Performance — Content Performance Analysis

## Iron Rules
- Must analyze based on **actual data**, not "feels like it did well"
- Must report both successful and failed content — failed content insights are equally valuable
- Must produce **reuse recommendations** — which content is worth adapting into other forms
- Conclusions must be written to the knowledge base and fed back to the next round of ideation

## Process

1. **Collect data**
   - Read publish records from `docs/content/published/`
   - Get performance data per channel (provided by user or read from analytics tools):
     - Traffic: UV/PV
     - Dwell: average dwell time, scroll depth
     - Conversion: conversion rate, conversion count
     - Ranking: target keyword ranking changes
     - Social: likes / comments / shares / reposts

2. **Performance evaluation**
   For each piece of content, evaluate:

   | Metric | Excellent | Acceptable | Below threshold |
   |--------|-----------|------------|-----------------|
   | UV (monthly) | > target | 50-100% of target | < 50% of target |
   | Average dwell | > 3 min | 1-3 min | < 1 min |
   | Conversion rate | > target | 50-100% of target | < 50% of target |
   | Keyword ranking | Top 3 | Top 10 | No ranking |
   | Social engagement | > target | 50-100% of target | < 50% of target |

3. **Attribution analysis**
   - High-performing content: why is it good? (accurate topic / good title / deep content / right channel)
   - Low-performing content: why is it poor? (off-topic / weak title / shallow content / wrong channel / high competition)
   - Distill reusable success patterns and failure lessons

4. **Reuse recommendations**
   For high-performing content, recommend reuse directions:
   ```
   | Content ID | Current form | Performance | Reuse recommendation | Target channel |
   |------------|--------------|-------------|----------------------|----------------|
   | C-001 | Blog | UV 5000 | Adapt into video script | TikTok/Video accounts |
   | C-001 | Blog | UV 5000 | Summarize as Thread | Twitter |
   | C-003 | Blog | UV 800 | Rewrite title and republish | Blog (A/B test title) |
   ```

5. **Write performance report**
   Produce `docs/content/performance-report.md`:
   ```markdown
   # Content Performance Report: <period>

   ## Overview
   - Published content count: N
   - Total UV: N
   - Average conversion rate: X%
   - Top 3 content: ...

   ## Per-content details
   | Content ID | Title | Channel | UV | Dwell | Conversion | Ranking | Rating |
   |------------|-------|---------|-----|-------|------------|---------|--------|

   ## Success patterns
   - [Reusable success patterns]

   ## Failure lessons
   - [Avoidable failure causes]

   ## Reuse recommendations
   - [Reuse directions for high-performing content]
   ```

6. **Update knowledge base**
   Append each content's performance data to the "content performance library" table in `memory/knowledge-base.md`
   Append success/failure patterns to the "growth pattern repository" table

7. **Update state.yaml**
   - stage: measure
   - status: done
   - Append to iterations.log

8. **Feed back to ideation**
   Topic directions of high-performing content → reference for the next round of content-ideation
   Topic directions of low-performing content → mark "validated as low-efficiency, hold off"

## Prohibitions
- Don't draw conclusions without data
- Don't report only successes and skip failures
- Don't omit reuse recommendations (content reuse is the key to growth compounding)
- Don't forget to write to the knowledge base (the next round of ideation needs to reference it)

## Relationship to LOOP
This skill runs in the **MEASURE phase** of LOOP(content); it is the last step of MEASURE.
PLAN(ideation) → EXPERIMENT(creation → review → distribution) → MEASURE(performance) → DONE

## Relationship to Workflow
This skill is step 5 (the last step) of **content-marketing-workflow**.
The performance data produced feeds back to content-ideation, forming a content compounding Loop.
