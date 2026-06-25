---
name: sample-size-calc
description: Calculate required A/B test sample size and experiment duration based on statistical power
---
# Sample Size Calculation — Sample Size Calculation

## When to use
- When sample size needs to be calculated during experiment design
- Called by the experiment-design skill
- User asks "how long does this experiment need to run

## Inputs
- loops/specs/<experiment>/spec.md

## Outputs
- loops/specs/<experiment>/spec.md

## Iron Rules
- Sample size calculation must be based on a **preset MDE**, not back-solved from post-experiment data
- Significance level defaults to α=0.05, statistical power defaults to 1-β=0.8; if adjusted, the reason must be stated
- Experiment duration must cover a **full natural cycle** (at least 7 days); cannot stop just because the sample size is reached

## Process

1. **Read experiment parameters**
   From spec.md, read:
   - Primary metric type: ratio (conversion rate / CTR) or continuous (AOV / duration)
   - Baseline value: the current value of the primary metric
   - Minimum Detectable Effect (MDE): the minimum change to detect
   - Significance level (α): default 0.05
   - Statistical power (1-β): default 0.8

2. **Calculate required sample size**

   ### Ratio metrics (conversion rate / CTR)
   Two-proportion z-test formula:
   ```
   n = (Z_{α/2} + Z_{β})² × [p1(1-p1) + p2(1-p2)] / (p1-p2)²

   Where:
   - p1 = baseline conversion rate
   - p2 = baseline + MDE (absolute lift)
   - Z_{α/2} = 1.96 (α=0.05, two-sided)
   - Z_{β} = 0.84 (power=0.8)
   - n = required sample size per group
   ```

   ### Continuous metrics (AOV / duration)
   t-test formula:
   ```
   n = 2 × (Z_{α/2} + Z_{β})² × σ² / Δ²

   Where:
   - σ = metric standard deviation (must be obtained from historical data)
   - Δ = MDE (expected change)
   ```

3. **Calculate experiment duration**
   ```
   Daily traffic = Total traffic / 7 (or get daily UV from analytics)
   Required days = (n × 2) / daily traffic
   Final experiment duration = max(required days, 7 days)
   ```
   - Take the larger of required days and 7 days (to ensure a full cycle)
   - If required days > 30 days, recommend splitting the experiment or adjusting the MDE

4. **Output calculation results**
   Append a "Sample Size Calculation" section to spec.md:
   ```
   ## Sample Size Calculation

   | Parameter | Value |
   |-----------|-------|
   | Primary metric type | Ratio / Continuous |
   | Baseline value | [e.g., 35%] |
   | MDE | [e.g., 3%] |
   | Significance level α | 0.05 |
   | Statistical power 1-β | 0.8 |
   | Required sample size per group | [e.g., 8,500] |
   | Total sample size | [e.g., 17,000] |
   | Daily average traffic | [e.g., 1,200 UV/day] |
   | Required experiment days | [e.g., 15 days] |
   | Final experiment duration | [e.g., 15 days] (≥7 days) |
   ```

5. **Feasibility assessment**
   - If experiment duration > 30 days: recommend increasing MDE or focusing on high-traffic pages
   - If total sample size > 50% of monthly traffic: recommend lowering MDE or extending the period
   - If MDE < 1%: warn "detecting tiny effects requires huge samples; consider whether it's worth it"

## Common reference tables

### Ratio metric sample size quick reference (α=0.05, power=0.8)

| Baseline conversion rate | MDE=1% | MDE=3% | MDE=5% | MDE=10% |
|--------------------------|--------|--------|--------|---------|
| 5% | 152,000 | 17,000 | 6,100 | 1,500 |
| 10% | 290,000 | 32,000 | 11,600 | 2,900 |
| 20% | 509,000 | 56,000 | 20,000 | 5,100 |
| 35% | 695,000 | 77,000 | 27,800 | 6,950 |
| 50% | 784,000 | 87,000 | 31,400 | 7,850 |

> Per-group sample size. Total sample size = per-group × 2.

## Prohibitions
- Don't back-solve MDE from post-experiment data (data snooping bias)
- Don't omit statistical power (only looking at p<0.05 leads to false positives)
- Don't design experiments shorter than 7 days (cyclicality bias)
- Don't force-launch experiments when traffic is insufficient (failing to reach sample size = invalid experiment)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP, called by experiment-design.
PLAN → EXPERIMENT → MEASURE

## Relationship to Workflow
This skill is step 4 of **growth-experiment-workflow** (called by experiment-design).
