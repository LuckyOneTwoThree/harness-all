---
name: ranking-tracking
description: Ranking tracking and fluctuation attribution, including algorithm update detection / competitor changes / content performance feedback
---
# Ranking Tracking — Ranking Tracking and Attribution

## When to use
- After SEO optimization is published, when rankings need to be tracked
- MEASURE phase of the SEO optimization Loop
- User asks to "check ranking changes
- When rankings fluctuate abnormally

## Inputs
- docs/seo/keyword-research.md
- memory/knowledge-base.md
- loops/specs/<seo>/state.yaml

## Outputs
- docs/seo/ranking-report.md
- memory/knowledge-base.md
- loops/specs/<seo>/state.yaml
- loops/specs/<seo>/iterations.log

## Iron Rules
- Ranking data must be based on **actual queries**, not "should have gone up"
- Ranking fluctuations must be **attributed** — algorithm update / competitor change / our optimization / external factor
- Must track ranking, traffic, and CTR together — ranking up but traffic not up may be a problem
- Conclusions must be written to the knowledge base and fed back to the next round of SEO optimization

## Process

1. **Read target keywords**
   From `docs/seo/keyword-research.md` and the "SEO asset library" in the knowledge base, read the tracking keyword list

2. **Ranking data collection**
   For each target keyword, get:
   - Current ranking
   - Previous ranking (compare change)
   - Historical trend (30/60/90 days)
   - SERP features (featured snippet / PAA / images / videos)

   > Data source: user-provided ranking reports / screenshots, or Agent queries via WebSearch

3. **Ranking change analysis**
   ```
   | Keyword | Previous rank | Current rank | Change | CTR | Traffic | Trend |
   |---------|---------------|--------------|--------|-----|---------|-------|
   | how to do X | 15 | 8 | ↑7 | 3.2% | 450 | ↑ |
   | X vs Y | 5 | 5 | — | 5.1% | 200 | — |
   | what is X | 8 | 22 | ↓14 | 1.1% | 50 | ↓ |
   ```

4. **Fluctuation attribution**
   Attribute ranking fluctuations (±5 positions or more):

   ### Our actions
   - Did we do onpage optimization recently? (corresponding optimization record)
   - Did we publish new content recently?
   - Did we change URLs / structure recently?

   ### Algorithm updates
   - Any Google algorithm update announcement? (core update / helpful content update / link spam update)
   - Multiple keywords fluctuating at the same time? (may be an algorithm update)
   - Is the industry as a whole affected? (check whether competitor rankings also fluctuate)

   ### Competitor changes
   - Did competitors publish new content?
   - Did competitors do optimization?
   - Did new competitors enter the SERP?

   ### Technical issues
   - Any technical errors on the page? (lost indexing / CWV regression / mobile issues)
   - Has the site been hacked / injected with spam content?

5. **Traffic and CTR analysis**
   - Ranking up + traffic up = normal
   - Ranking up + traffic flat = CTR issue (title / Meta not attractive)
   - Ranking up + traffic down = search volume dropping or SERP feature change
   - Ranking down + traffic down = needs optimization

6. **Produce ranking report**
   Write to `docs/seo/ranking-report.md`:
   ```markdown
   # Ranking Tracking Report: <date>

   ## Overview
   - Tracked keywords: N
   - Ranking up: N
   - Ranking down: N
   - Ranking unchanged: N
   - Top 10 keywords: N
   - Top 3 keywords: N

   ## Ranking change details
   [Ranking change table]

   ## Fluctuation attribution
   | Keyword | Change | Attribution | Action recommendation |
   |---------|--------|-------------|-----------------------|
   | how to do X | ↑7 | onpage optimization took effect | Continue optimizing related words |
   | what is X | ↓14 | Suspected algorithm update | Observe for 1-2 weeks |

   ## CTR optimization opportunities
   | Keyword | Rank | CTR | Optimization recommendation |
   |---------|------|-----|------------------------------|
   | X vs Y | 5 | 5.1% | Adding numbers to the title can lift CTR |
   ```

7. **Update knowledge base**
   - Update the ranking and traffic of each keyword in the "SEO asset library"
   - Record effective SEO optimization patterns in the "growth pattern repository"
   - Record ineffective or harmful actions in the "lessons learned"

8. **Update state.yaml**
   - stage: measure
   - status: done (ranking meets bar) / retrying (needs continued optimization)
   - Append to iterations.log

9. **Feed back to the next round**
   - Keywords with rising rankings → summarize success patterns and apply to other keywords
   - Keywords with declining rankings → analyze causes and adjust strategy
   - Keywords with unchanged rankings → consider whether deeper optimization is needed

## Prohibitions
- Don't claim ranking changes without data
- Don't ignore ranking drops (may be technical issues or algorithm updates)
- Don't look only at rankings and ignore traffic (ranking up but traffic flat = CTR issue)
- Don't skip attribution (not knowing why it changed = can't reuse the learning)

## Relationship to LOOP
This skill runs in the **MEASURE phase** of LOOP(seo); it is the last step of MEASURE.
PLAN(research → serp) → EXPERIMENT(onpage → technical) → MEASURE(ranking) → DONE / back to PLAN

## Relationship to Workflow
This skill is step 5 (the last step) of **seo-optimization-workflow**.
The ranking data produced feeds back to keyword-research, forming an SEO compounding Loop.
