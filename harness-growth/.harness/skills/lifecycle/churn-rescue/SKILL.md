---
name: churn-rescue
description: Churn early-warning model design + win-back campaign design, with cost gating
triggers:
  - When user churn rate is high
  - User operations Workflow
  - User asks to "design a win-back strategy"
reads:
  - docs/operations/segments.md
  - memory/knowledge-base.md
  - rules/security.md
writes:
  - docs/operations/churn-rescue-plan.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# Churn Rescue — Churn Early Warning and Win-Back

## Iron Rules
- Win-back cost must be lower than user LTV/3 — otherwise it's not worth it
- Must intervene **before the user fully churns** — too-late intervention is ineffective
- Win-back outreach must be **differentiated** — different churn causes need different win-back strategies

## Process

1. **Define churn**
   - What counts as "churned"? (30/60/90 days inactive?)
   - What counts as "churn risk"? (activity dropped X%?)
   - Different products define it differently (SaaS = monthly, social = daily)

2. **Churn early-warning model**
   Identify pre-churn signals:
   ```
   | Signal | Meaning | Warning threshold | Intervention timing |
   |--------|---------|-------------------|---------------------|
   | Activity frequency drop | Core action frequency < 50% of baseline | 7 consecutive days | Immediately |
   | Session duration shortened | Average duration < 50% of baseline | 3 consecutive sessions | Immediately |
   | Feature usage reduction | Number of features used < 50% of baseline | 7 consecutive days | Within 1 week |
   | Key flow not completed | Stuck at a step | Not completed within 24h | Within 24h |
   | Negative feedback | Submitted complaint / low rating | Immediately | Immediately |
   ```

3. **Segmented churn cause analysis**
   Different users churn for different reasons:
   | Churn cause | Share | Characteristics | Win-back strategy |
   |-------------|-------|-----------------|-------------------|
   | Didn't reach aha moment | 40% | Didn't complete core action on day 1 | Re-guide onboarding |
   | Value mismatch | 25% | Gradually decreased after being active | Research + product improvement |
   | Competitor substitution | 15% | Was active then switched to competitor | Emphasize differentiated value |
   | Experience issues | 10% | Has negative feedback | Fix + compensate |
   | Natural churn | 10% | Use case disappeared | Low-cost outreach |

4. **Design win-back campaign**
   Design differentiated win-back for different churn causes:
   ```
   | Segment | Outreach channel | Outreach content | Incentive | Expected win-back rate | Cost/person |
   |---------|------------------|------------------|-----------|-----------------------|-------------|
   | Didn't reach aha | Email + push | New feature guidance | None | 15% | ¥2 |
   | Value mismatch | Email | Survey | Coupon | 8% | ¥5 |
   | Competitor substitution | Email | Differentiated comparison | Discount | 5% | ¥10 |
   ```

5. **Cost gating**
   ```
   Win-back cost = Outreach cost + Incentive cost
   Expected LTV = Expected lifetime value after the user returns
   Cost gating: Win-back cost ≤ LTV/3
   ```

6. **Design trigger timing**
   - Warning stage (activity decline): low-cost outreach (push/email)
   - Early churn (7-30 days inactive): medium-cost outreach (+ incentive)
   - Deep churn (30+ days): high-cost outreach (+ large incentive) or no win-back

7. **Produce win-back plan**
   Write to `docs/operations/churn-rescue-plan.md`

8. **Update knowledge base**
   Write segments and win-back strategies to the "user segment library" in `memory/knowledge-base.md`

## Prohibitions
- Don't win back only after the user has fully churned (too late = ineffective)
- Don't use a generic win-back strategy (different churn causes need differentiation)
- Don't ignore cost gating (win-back cost > LTV/3 = not worth it)
- Don't frequently disturb users (control outreach frequency to avoid unsubscriptions)

## Relationship to LOOP
This skill runs in the **EXPERIMENT phase** of LOOP(lifecycle).

## Relationship to Workflow
This skill is step 5 of **lifecycle-operations-workflow**.
