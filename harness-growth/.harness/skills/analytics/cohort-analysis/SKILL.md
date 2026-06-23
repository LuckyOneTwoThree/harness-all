---
name: cohort-analysis
description: Cohort analysis, including cohort retention matrix, horizontal/vertical comparison, and trend identification
triggers:
  - When retention needs to be analyzed
  - Growth review report Workflow
  - User asks to "run a Cohort analysis"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/cohort-analysis.md
quality_gates: []
max_iterations: 1
---

# Cohort Analysis — Cohort Analysis

## Iron Rules
- Cohorts must be grouped by **sign-up time** — users who sign up at different times behave differently
- Must perform both **horizontal (cohort decay) and vertical (cohort comparison)** analysis
- Retention data must be based on **core actions**, not logins

## Process

1. **Define cohort grouping**
   - Group by sign-up week/month
   - Track retention for N weeks/N months per group
   - Example: users who signed up in week 1 of May, track W0-W8 retention

2. **Build cohort retention matrix**
   ```
   | Sign-up week | W0 | W1 | W2 | W3 | W4 | W5 | W6 | W7 | W8 |
   |--------------|-----|-----|-----|-----|-----|-----|-----|-----|-----|
   | May W1 | 100% | 45% | 32% | 28% | 25% | 23% | 22% | 21% | 20% |
   | May W2 | 100% | 48% | 35% | 30% | 27% | 25% | 24% | 23% | - |
   | May W3 | 100% | 52% | 38% | 33% | 30% | 28% | - | - | - |
   | May W4 | 100% | 55% | 40% | 35% | 32% | - | - | - | - |
   | Jun W1 | 100% | 58% | 42% | - | - | - | - | - | - |
   ```

3. **Horizontal analysis (cohort decay)**
   For each cohort, analyze the retention curve shape:
   - **L-shaped curve**: rapid decline then flattens (healthy)
   - **Logarithmic curve**: slow continuous decline (medium)
   - **Linear decline**: continuous churn without flattening (leaky bucket)
   - **Smile curve**: declines then rises (rare; product improvements cause re-engagement)

4. **Vertical analysis (cohort comparison)**
   - New cohort retention > old cohort? → Product is improving
   - New cohort retention < old cohort? → Product is degrading or acquisition quality is dropping
   - Compare different cohorts at the same W: W1 retention 45%→48%→52%→55%→58% (continuous improvement)

5. **Trend identification**
   - Retention plateau position: trending to 20% (May W1) vs trending to 25% (May W4) → improvement
   - Speed to reach plateau: W4 flattens vs W6 flattens → accelerating
   - First-week retention: 45%→58% → onboarding improvement

6. **Segmented cohorts (optional)**
   Build cohorts by user segment:
   - New users vs existing users
   - Paid users vs free users
   - Different channel sources

7. **Produce cohort report**
   Write to `docs/operations/cohort-analysis.md`, including:
   - Cohort retention matrix
   - Horizontal/vertical analysis conclusions
   - Trend identification
   - Optimization recommendations

## Prohibitions
- Don't define retention by login (login ≠ usage; use core actions)
- Don't look only horizontally and skip vertical (vertical is needed to identify trends)
- Don't ignore retention curve shape (shape matters more than absolute values)
- Don't draw conclusions when cohort sample < 100 (insufficient sample)

## Relationship to LOOP
This skill does not run inside LOOP; it is an **analysis tool**.

## Relationship to Workflow
This skill is part of **growth-review-workflow** and a data source for retention-analysis.
