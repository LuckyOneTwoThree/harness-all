---
name: retention-analysis
description: Retention curve analysis, including Cohort matrix / natural cycle / plateau detection / RBM assessment
triggers:
  - When retention needs to be analyzed
  - User operations Workflow
  - Growth review report Workflow
  - User asks to "analyze retention"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/retention-analysis.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
---

# Retention Analysis — Retention Curve Analysis

## Iron Rules
- Retention must use **Cohort analysis** — can't just look at total DAU/MAU
- Must determine whether the retention curve **plateaus** — no plateau = leaky bucket
- RBM principle: before retention meets the bar, don't do large-scale acquisition

## Process

1. **Determine the natural usage cycle**
   | Product type | Natural cycle | Notes |
   |--------------|---------------|-------|
   | Social/News | Daily | Used daily |
   | SaaS/Tools | Weekly | Used weekly |
   | E-commerce | Monthly | Buys monthly |
   | Travel/Real estate | Quarterly/Yearly | Low frequency |

2. **Build Cohort retention matrix**
   ```
   | Sign-up week | W0 | W1 | W2 | W3 | W4 | W5 | W6 |
   |--------------|-----|-----|-----|-----|-----|-----|-----|
   | May W1 | 100% | 45% | 32% | 28% | 25% | 23% | 22% |
   | May W2 | 100% | 48% | 35% | 30% | 27% | 25% | - |
   | May W3 | 100% | 52% | 38% | 33% | 30% | - | - |
   ```

3. **Horizontal analysis (cohort decay)**
   - Retention curve shape: L-shaped (good) / logarithmic (medium) / linear decline (poor)
   - Does it plateau? (After some week, the retention rate no longer drops significantly)
   - Where is the plateau? (> 20% is healthy, < 10% is a leaky bucket)

4. **Vertical analysis (cohort comparison)**
   - Do new cohorts retain better or worse than old cohorts?
   - If new cohorts retain worse: is it acquisition quality dropping? Or onboarding getting worse?
   - If new cohorts retain better: what change caused the improvement?

5. **RBM assessment**
   ```
   RBM determination:
   - Does the retention curve plateau? [Yes/No]
   - Plateau position: [X%]
   - Industry benchmark: [Y%]
   - Assessment: [Meets bar / Close / Below bar]
   - Recommendation: [Can acquire / Fix retention first]
   ```

6. **Facebook 40-20-10 reference rule** (for mobile social)
   - Day-1 retention ≥ 40%
   - Day-7 retention ≥ 20%
   - Day-30 retention ≥ 10%
   > Note: varies a lot across categories; for reference only

7. **Produce retention report**
   Write to `docs/operations/retention-analysis.md`, including:
   - Cohort retention matrix
   - Retention curve chart (text description of trend)
   - Horizontal/vertical analysis
   - RBM assessment conclusion
   - Optimization recommendations

## Prohibitions
- Don't look only at total DAU/MAU (masks cohort differences)
- Don't ignore retention curve shape (linear decline = leaky bucket)
- Don't recommend large-scale acquisition when retention is below bar (RBM principle)
- Don't ignore cohort comparison (a drop in new cohort retention is a danger signal)

## Relationship to LOOP
This skill runs in the **MEASURE phase** of LOOP(lifecycle).

## Relationship to Workflow
This skill is step 4 of **lifecycle-operations-workflow**.
It is also part of **growth-review-workflow**.
