---
name: experiment-analysis
description: Analyze A/B testing data, calculate statistical significance / confidence intervals / effect size, detect SRM and segment heterogeneity
---
# Experiment Analysis — Experiment Data Analysis

## When to use
- After experiment data collection is complete
- MEASURE phase of the growth experiment Loop
- User asks "how did the experiment turn out

## Inputs
- loops/specs/<experiment>/spec.md
- loops/LOOP.md

## Outputs
- loops/specs/<experiment>/evidence.md
- loops/specs/<experiment>/state.yaml
- loops/specs/<experiment>/iterations.log

## Iron Rules
- **No claiming completion without data** — must show actual data, not "should be effective"
- Must check **SRM (Sample Ratio Mismatch)** — if SRM triggers, the experiment is invalid
- Must report **effect size and confidence interval**, not just the p-value
- Must check **segment heterogeneity** — overall non-significance does not mean all segments are non-significant

## Process

1. **Read experiment design**
   From spec.md, read:
   - Primary metric and baseline/target values
   - Guardrail metrics and thresholds
   - Hypothesis statement and falsification conditions
   - Expected sample size and actual sample size

2. **Data integrity check**
   - Has the sample size reached the expected level? (If not, warn "insufficient sample, low conclusion reliability")
   - Does the experiment duration cover a full cycle? (At least 7 days)
   - Is there missing/anomalous data? (e.g., a day with data gap)

3. **SRM detection (required)**
   Sample Ratio Mismatch detection:
   ```
   Expected ratio: control 50% / variant 50%
   Actual ratio: control N1 / variant N2

   Chi-square statistic = (|N1 - N_expected| - 0.5)² / N_expected × 2
   p_value = 1 - chi2.cdf(chi-square statistic, df=1)

   If p_value < 0.001 → SRM triggered, experiment invalid, need to investigate traffic split bug
   ```
   **When SRM triggers**: stop analysis, log to iterations.log, require investigation of the split implementation

4. **Primary metric significance test**

   ### Ratio metrics (z-test)
   ```
   z = (p_control - p_variant) / sqrt(p_pooled × (1-p_pooled) × (1/n1 + 1/n2))
   p_value = 2 × (1 - norm.cdf(|z|))
   Confidence interval = (p_v - p_c) ± 1.96 × SE
   ```

   ### Continuous metrics (t-test)
   ```
   t = (mean_c - mean_v) / sqrt(s_c²/n1 + s_v²/n2)
   Degrees of freedom = Welch-Satterthwaite formula
   p_value = 2 × (1 - t.cdf(|t|, df))
   ```

5. **Effect size calculation**
   - Absolute lift: p_variant - p_control
   - Relative lift: (p_variant - p_control) / p_control × 100%
   - Cohen's h (effect size for ratios): h = 2 × arcsin(√p_v) - 2 × arcsin(√p_c)
   - Interpretation: h<0.2 small effect, 0.2-0.5 medium, 0.5-0.8 large, >0.8 very large

6. **Guardrail metric check**
   Check each guardrail metric defined in spec.md:
   - If any guardrail metric triggers the red line → mark "guardrail triggered", do not recommend full rollout
   - Guardrail not triggered → mark "guardrail passed"

7. **Segment heterogeneity analysis (required)**
   Split analysis by preset dimensions:
   - New users vs existing users
   - Mobile vs desktop
   - Different regions/channels
   - High-frequency users vs low-frequency users

   Output segment comparison table:
   ```
   | Segment | Control | Variant | Lift | p-value | Significant? |
   |---------|---------|---------|------|---------|--------------|
   | New users | 30% | 36% | +6% | 0.02 | ✓ |
   | Existing users | 45% | 46% | +1% | 0.45 | ✗ |
   ```
   **Insight**: if a segment is significant but the overall is not, record "segment heterogeneity, recommend full rollout for that segment"

8. **Write evidence.md**
   ```markdown
   # Experiment Evidence: <experiment-name>

   ## Experiment meta info
   - Experiment period: YYYY-MM-DD to YYYY-MM-DD
   - Total sample size: N
   - Split ratio: 50/50

   ## SRM detection
   - Expected ratio: 50/50
   - Actual ratio: 50.2/49.8
   - p_value: 0.35
   - Conclusion: SRM not triggered ✓

   ## Primary metric results
   | Metric | Control | Variant | Absolute lift | Relative lift | p-value | Confidence interval | Significant? |
   |--------|---------|---------|----------------|----------------|---------|---------------------|--------------|
   | Sign-up conversion rate | 35.2% | 38.8% | +3.6% | +10.2% | 0.012 | [0.8%, 6.4%] | ✓ |

   ## Guardrail metrics
   | Metric | Control | Variant | Threshold | Passed? |
   |--------|---------|---------|-----------|---------|
   | Day-1 retention | 42% | 41.5% | ≥41% | ✓ |
   | Page load | 1.2s | 1.3s | ≤1.4s | ✓ |

   ## Segment heterogeneity
   [Segment comparison table]

   ## Conclusion
   [Significant / not significant + whether to recommend full rollout]
   ```

9. **Update state.yaml**
   - stage: measure
   - status: done (if passed) or retrying (if redesign needed)
   - last_error: failure reason (if significance not reached)

10. **Append to iterations.log**
    ```
    [YYYY-MM-DD HH:MM] iter=N stage=measure → [PASSED/FAILED]: [conclusion summary]
    ```

## Prohibitions
- Don't skip SRM detection and analyze directly (SRM invalidates conclusions entirely)
- Don't draw conclusions based only on the p-value (effect size and confidence interval matter equally)
- Don't ignore segment analysis (overall non-significance may mask segment differences)
- Don't force conclusions when the sample is insufficient (low power = high false-negative rate)

## Relationship to LOOP
This skill runs in the **MEASURE phase** of LOOP.
PLAN → EXPERIMENT → MEASURE(this skill) → pass? DONE : back to PLAN/EXPERIMENT

## Relationship to Workflow
This skill is step 5 of **growth-experiment-workflow** (analysis after experiment execution).
Output is used by experiment-conclusion to generate the final conclusion and decision recommendation.
