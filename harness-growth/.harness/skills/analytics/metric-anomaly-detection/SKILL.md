---
name: metric-anomaly-detection
description: Metric anomaly detection and attribution, including fluctuation detection, root cause analysis, and impact assessment
---
# Metric Anomaly Detection — Metric Anomaly Detection

## When to use
- When metrics show abnormal fluctuation
- Growth review report Workflow
- User asks to "analyze metric anomaly

## Inputs
- memory/knowledge-base.md
- loops/specs/*/state.yaml

## Outputs
- docs/operations/anomaly-report.md
- memory/knowledge-base.md

## Iron Rules
- Anomalies must be based on **statistical thresholds** (±2σ or ±3σ), not "feels off"
- Must perform **root cause analysis** — not just "metric dropped", find out why
- Must assess **impact scope** — how many users / how much revenue affected

## Process

1. **Define normal baseline**
   - Calculate mean and standard deviation of the metric over the past 30 days
   - Define anomaly threshold: mean ± 2σ (outside the 95% confidence interval is anomalous)
   - Account for cyclicality (weekday vs weekend, seasonality)

2. **Anomaly detection**
   ```
   | Metric | Baseline | Current | Deviation | Anomaly? |
   |--------|----------|---------|-----------|----------|
   | DAU | 5000±500 | 3500 | -3σ | ✅ Abnormal drop |
   | Conversion rate | 5.2%±0.5% | 3.1% | -4.2σ | ✅ Abnormal drop |
   | Retention rate | 35%±3% | 34% | -0.3σ | ❌ Normal fluctuation |
   ```

3. **Root cause analysis**
   For each anomalous metric, investigate along these dimensions:

   ### Technical factors
   - Any service downtime / error rate increase?
   - Any page load slowdown?
   - Any feature bug?
   - Any deployment change?

   ### Product factors
   - Any feature sunset / redesign?
   - Any onboarding flow change?
   - Any paywall adjustment?

   ### External factors
   - Any competitor action (price cut / new product)?
   - Any industry event (policy / news)?
   - Any seasonality (holiday / school term)?
   - Any traffic source change (SEO ranking / ad budget)?

   ### Data factors
   - Any tracking event loss / change?
   - Any data pipeline delay?
   - Any metric definition change?

4. **Impact assessment**
   ```
   | Anomalous metric | Impact scope | Affected users | Affected revenue | Duration |
   |------------------|--------------|----------------|------------------|----------|
   | DAU drop | Whole site | -1500 | -¥3000/day | 3 days |
   | Conversion drop | Sign-up flow | -200 conversions | -¥5000/day | 2 days |
   ```

5. **Attribution conclusion**
   ```
   Anomaly: [metric] [dropped/rose] [X%]
   Root cause: [most likely cause + confidence]
   Impact: [users / revenue / duration]
   Recommendation: [fix / observe / ignore]
   ```

6. **Produce anomaly report**
   Write to `docs/operations/anomaly-report.md`
   Sync major anomalies to the "lessons learned" section of `memory/knowledge-base.md`

## Anomaly priority

| Priority | Definition | Response time |
|----------|------------|---------------|
| P0 | Core metric anomaly (DAU / revenue / conversion) | Immediately |
| P1 | Secondary metric anomaly (retention / activation) | Within 24h |
| P2 | Tertiary metric anomaly (page PV / clicks) | Observe only |

## Prohibitions
- Don't judge anomalies by "feels off" (use statistical thresholds)
- Don't report anomalies without attribution ("metric dropped" is not a conclusion)
- Don't ignore data factors (tracking loss can cause "fake drops")
- Don't blindly fix without confirming root cause (might fix the wrong thing)

## Relationship to LOOP
This skill does not run inside LOOP; it is a **monitoring tool**.
Anomaly detection may trigger LOOP(experiment) to validate a fix.

## Relationship to Workflow
This skill is part of **growth-review-workflow**.
