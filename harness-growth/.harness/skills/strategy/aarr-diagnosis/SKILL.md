---
name: aarr-diagnosis
description: AARRR funnel diagnosis, finding the weakest link as the priority growth direction
triggers:
  - When growth bottlenecks need to be diagnosed
  - Growth strategy formulation Workflow
  - Growth review report Workflow
  - User asks to "diagnose growth issues"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/GROWTH_STRATEGY.md
quality_gates: []
max_iterations: 1
---

# AARR Diagnosis — AARRR Funnel Diagnosis

## Iron Rules
- Diagnosis must be based on **actual data**, not "feels like retention has a problem"
- Must find the **weakest link** — resources are limited, focus on the biggest bottleneck
- Must give **priority recommendations** — which link to fix first

## Process

1. **Collect data for each AARRR stage**
   | Stage | Key metric | Current value | Industry benchmark |
   |-------|------------|---------------|--------------------|
   | Acquisition | UV / sign-ups | ? | - |
   | Activation | Activation rate / day-1 retention | ? | 30-60% |
   | Retention | Day-7 / day-30 retention | ? | 20-40% |
   | Revenue | Paid conversion rate / ARPU | ? | 2-10% |
   | Referral | K-factor / invitation rate | ? | 0.1-0.5 |

2. **Calculate funnel conversion rates**
   ```
   Visitor → Sign-up: X%
   Sign-up → Activation: Y%
   Activation → Retention: Z%
   Retention → Paid: W%
   Paid → Referral: V%
   ```

3. **Identify weak links**
   - Which stage has the **lowest** conversion rate?
   - Which stage is **below the industry benchmark** by the most?
   - Which stage has **dropped the most** recently?

4. **Priority assessment**
   | Stage | Conversion rate | vs benchmark | Impact on NSM | Priority |
   |-------|-----------------|--------------|---------------|----------|
   | Activation | 15% | -45% | High (affects retention) | P0 |
   | Retention | 25% | -15% | High | P1 |
   | Acquisition | - | - | Medium | P2 |

5. **Produce diagnosis report**
   ```
   ## AARRR Diagnosis Conclusion
   Weakest link: [stage name] (conversion rate X%, below benchmark by Y%)
   Priority direction: [which stage to fix first]
   Expected impact: [impact on NSM after fixing]
   ```

## Prohibitions
- Don't diagnose without data
- Don't ignore industry benchmarks (no comparison = no judgment)
- Don't fix all stages at once (scattered resources = none get fixed)

## Relationship to LOOP
This skill does not run inside LOOP; it is a **diagnostic tool**.
Output is used by hypothesis-generation to reference experiment directions.

## Relationship to Workflow
This skill is step 3 of **growth-strategy-workflow**, and part of **growth-review-workflow**.
