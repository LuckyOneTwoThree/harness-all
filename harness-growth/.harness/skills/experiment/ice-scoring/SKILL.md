---
name: ice-scoring
description: ICE/RICE scoring and ranking of the growth hypothesis backlog to determine experiment priority
triggers:
  - When there are multiple hypotheses to rank
  - PLAN phase of the growth experiment Loop, after hypothesis-generation
reads:
  - loops/specs/<experiment>/spec.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<experiment>/spec.md
quality_gates: []
max_iterations: 2
---

# ICE Scoring — Hypothesis Priority Ranking

## Iron Rules
- Each hypothesis must be scored; "by gut feel" ranking is not allowed
- Scoring is based on evidence, not optimism — Confidence must be supported by data/case studies
- Ranking results must record the rationale, to enable retrospective on "why we picked this at the time"

## Process

1. **Read hypothesis list**
   From `loops/specs/<experiment>/spec.md`, read the hypothesis list produced by hypothesis-generation

2. **ICE scoring**
   Score each hypothesis on three dimensions (1-10):

   | Dimension | Meaning | Scoring basis |
   |-----------|---------|---------------|
   | **Impact** | Degree of impact on the North Star Metric / primary metric | 10 = directly impacts NSM, 5 = impacts secondary metric, 1 = weak impact |
   | **Confidence** | Confidence that the hypothesis holds | 10 = strongly supported by data/cases, 5 = theoretical basis but no data, 1 = pure guess |
   | **Ease** | Implementation difficulty (higher = easier) | 10 = a few hours, 5 = 1-2 weeks, 1 = cross-team, multi-month |

   ICE Score = Impact × Confidence × Ease

3. **RICE extension (optional)**
   If finer ranking is needed, upgrade to RICE:
   - Reach: how many users affected (estimate by users reached in the period)
   - Impact: impact per user (0.25/0.5/1/2/3)
   - Confidence: confidence level (50%/80%/100%)
   - Effort: person-weeks (higher = harder)
   - RICE Score = (Reach × Impact × Confidence) / Effort

4. **Rank and filter**
   - Sort by ICE/RICE Score in descending order
   - Mark the Top 3 hypotheses as "this week's priority experiments"
   - Mark low-scoring hypotheses as "hold off" and record the reason

5. **Record decision rationale**
   Append the ranking table to spec.md:
   ```
   | Hypothesis ID | Hypothesis summary | Impact | Confidence | Ease | ICE Score | Decision | Reason |
   |---------------|---------------------|--------|------------|------|-----------|----------|--------|
   | H-001 | ... | 8 | 7 | 9 | 504 | Priority | High impact + high confidence + easy to implement |
   | H-002 | ... | 9 | 4 | 5 | 180 | Hold off | High impact but low confidence; need research first |
   ```

6. **Update spec.md**
   Write the ranking results to the "Priority Ranking" section of spec.md

## Scoring reference standards

### Impact scoring reference
| Score | Meaning | Example |
|-------|---------|---------|
| 9-10 | Directly impacts North Star Metric | Lifting activation rate → directly impacts NSM (weekly active) |
| 7-8 | Impacts a first-order input metric | Lifting sign-up conversion rate → impacts new user count |
| 5-6 | Impacts a secondary metric | Lifting page dwell → indirectly impacts conversion |
| 1-4 | Weak or indirect impact | Changing a button color |

### Confidence scoring reference
| Score | Meaning | Support type |
|-------|---------|--------------|
| 8-10 | High confidence | Has historical experiment data / industry cases / user research |
| 5-7 | Medium confidence | Has theoretical basis / competitor practice / qualitative feedback |
| 1-4 | Low confidence | Pure intuition / no data |

### Ease scoring reference
| Score | Meaning | Implementation cost |
|-------|---------|---------------------|
| 8-10 | Quick to do | A few hours - 1 day, no dev needed |
| 5-7 | Medium cost | 1-2 weeks, small amount of dev |
| 1-4 | High cost | Cross-team / multi-month / major refactor |

## Prohibitions
- Don't skip scoring and pick hypotheses directly (loses ranking basis)
- Don't give all hypotheses full marks (loses discrimination)
- Don't ignore Confidence (high-impact, low-confidence hypotheses are risky)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP, after hypothesis-generation.
PLAN(hypothesis-generation → ice-scoring → experiment-design) → EXPERIMENT → MEASURE

## Relationship to Workflow
This skill is step 2 of **growth-experiment-workflow**.
