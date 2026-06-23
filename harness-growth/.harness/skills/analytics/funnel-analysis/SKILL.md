---
name: funnel-analysis
description: Funnel analysis, including conversion rate, bottleneck localization, segment differences, and optimization recommendations
triggers:
  - When conversion funnel needs to be analyzed
  - Growth review report Workflow
  - User asks to "analyze the funnel"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/funnel-analysis.md
quality_gates: []
max_iterations: 1
---

# Funnel Analysis — Funnel Analysis

## Iron Rules
- Funnels must be based on **actual event data**, not "estimates"
- Must locate the **biggest churn step** — resources are limited, focus on the largest bottleneck
- Must perform **segment comparison** — overall funnel may mask segment differences

## Process

1. **Define funnel steps**
   Define based on the product's core conversion path:
   ```
   Example (sign-up conversion funnel):
   Visit landing page → Click sign-up → Fill form → Email verification → Complete sign-up → First use

   Example (purchase conversion funnel):
   Browse product → Add to cart → Start checkout → Fill info → Complete payment
   ```

2. **Calculate conversion rate per step**
   ```
   | Step | Users | Conversion rate | Cumulative conversion | Churned | Churn rate |
   |------|-------|-----------------|----------------------|---------|------------|
   | Visit landing page | 10,000 | 100% | 100% | - | - |
   | Click sign-up | 3,500 | 35% | 35% | 6,500 | 65% |
   | Fill form | 2,800 | 80% | 28% | 700 | 20% |
   | Email verification | 2,100 | 75% | 21% | 700 | 25% |
   | Complete sign-up | 2,000 | 95% | 20% | 100 | 5% |
   | First use | 1,200 | 60% | 12% | 800 | 40% |
   ```

3. **Locate the biggest churn step**
   - Largest absolute churn: Visit → Click sign-up (6,500 churned)
   - Largest relative churn: Email verification → Complete sign-up (25% churn)
   - Prioritize: steps with the largest absolute churn (biggest impact)

4. **Segment comparison**
   ```
   | Step | New users | Existing users | Mobile | Desktop |
   |------|-----------|----------------|--------|---------|
   | Visit | 100% | 100% | 100% | 100% |
   | Sign-up | 28% | 45% | 22% | 35% |
   | Activation | 10% | 30% | 8% | 18% |
   ```

5. **Churn cause analysis**
   For the biggest churn step, analyze causes:
   - Technical issues (slow page load / bug)
   - Design issues (too many steps / long form / unclear CTA)
   - Value issues (users don't see value / don't trust)
   - External factors (competitors / budget / timing)

6. **Produce optimization recommendations**
   ```
   | Step to optimize | Current conversion | Target conversion | Optimization direction | Expected impact |
   |------------------|--------------------|--------------------|------------------------|-----------------|
   | Visit → Sign-up | 35% | 45% | Optimize landing page value proposition | +1000 users |
   | Email verification | 75% | 90% | Switch to instant verification | +300 users |
   | Sign-up → Activation | 60% | 75% | Optimize onboarding | +300 users |
   ```

7. **Write report**
   Write to `docs/operations/funnel-analysis.md`

## Prohibitions
- Don't estimate the funnel when there's no data
- Don't look only at the overall funnel without segment comparison
- Don't ignore the biggest churn step
- Don't report data without optimization recommendations

## Relationship to LOOP
This skill does not run inside LOOP; it is an **analysis tool**.

## Relationship to Workflow
This skill is part of **growth-review-workflow** and a data source for aarr-diagnosis.
