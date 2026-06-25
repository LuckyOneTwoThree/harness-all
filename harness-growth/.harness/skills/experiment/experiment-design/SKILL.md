---
name: experiment-design
description: Design experiment plans, including variables / control / primary metric / guardrail metrics / audience / split ratio
---
# Experiment Design — Experiment Design

## When to use
- When hypotheses have been ICE-ranked and an experiment plan needs to be designed
- PLAN phase of the growth experiment Loop, after ice-scoring

## Inputs
- loops/specs/<experiment>/spec.md
- loops/LOOP.md
- rules/security.md

## Outputs
- loops/specs/<experiment>/spec.md
- loops/specs/<experiment>/state.yaml

## Iron Rules
- Each experiment must have exactly one **primary metric** — multiple primary metrics lead to confused conclusions
- Must set **guardrail metrics** — to prevent experiment side effects (e.g., lifting conversion but hurting retention)
- Must define **falsification conditions** — what results would overturn the hypothesis
- Destructive experiments (that may lower core metrics) must have a manual fallback plan

## Process

1. **Confirm experiment hypothesis**
   From spec.md, read the top-ranked hypothesis by ICE, confirm:
   - Hypothesis statement (if X, then Y, because Z)
   - Primary metric (the metric the hypothesis is intended to affect)
   - Guardrail metrics (side-effect metrics to monitor)

2. **Design variables and control**
   - **Control group**: current version (status quo)
   - **Variant group**: apply the hypothesis change
   - Specify the change: UI / logic / copy / flow / algorithm
   - If there are multiple variables, split into multiple experiments (avoid confounding variables)

3. **Define metric system**
   ```
   Primary Metric:
     - Name: [e.g., "sign-up conversion rate"]
     - Definition: [users who completed sign-up / users who visited the sign-up page]
     - Baseline value: [current value, e.g., 35%]
     - Target value: [expected value, e.g., 40%]
     - Minimum Detectable Effect (MDE): [e.g., 3%]

   Guardrail Metrics:
     - [Metric 1]: [e.g., "day-1 retention rate", threshold: not lower than baseline - 1%]
     - [Metric 2]: [e.g., "page load time", threshold: not exceeding baseline + 200ms]
     - [Metric 3]: [e.g., "unsubscribe rate", threshold: not exceeding baseline + 0.5%]

   Secondary Metrics (optional):
     - [Segment metrics for deeper analysis]
   ```

4. **Determine audience and split**
   - **Audience definition**: which users the experiment affects (all / new users / a segment)
   - **Split ratio**: control 50% / variant 50% (standard), or small-traffic pilot first (e.g., 5%)
   - **Layering strategy**: if user layering is needed (device / region / new vs existing), declare the layering dimension
   - **Mutual exclusion rules**: whether mutually exclusive with running experiments

5. **Call sample-size-calc**
   Based on the primary metric's baseline, MDE, significance level, and statistical power, calculate the required sample size and experiment duration.
   Write the result to spec.md.

6. **Design experiment timeline**
   ```
   Experiment start: [date]
   Expected end: [start date + experiment duration]
   Minimum run period: [e.g., 7 days, to avoid cyclicality bias]
   Decision checkpoint: [e.g., check significance 3 days after reaching sample size]
   ```

7. **Design fallback plan (required for destructive experiments)**
   - Conditions to stop the experiment immediately (e.g., guardrail metric triggers red line)
   - Rollback plan if the experiment fails
   - Monitoring frequency during the experiment

8. **Write to spec.md**
   Write the full experiment plan to the "Experiment Design" section of spec.md

9. **Initialize state.yaml**
   Create `loops/specs/<experiment>/state.yaml`:
   ```yaml
   current_task: <NNN>-<experiment-name>
   iteration: 0
   stage: plan
   status: running
   started_at: "<ISO 8601>"
   last_error: ""
   substage: "experiment-design"
   ```

## Experiment design quality check

- [ ] Is the primary metric unique and quantifiable?
- [ ] Do guardrail metrics cover the main side-effect risks?
- [ ] Is the MDE realistic? (Too small requires huge sample; too large misses real effects)
- [ ] Is the split random and unbiased? (Avoid SRM)
- [ ] Does the experiment duration cover a full cycle? (At least 7 days, to avoid weekend/weekday bias)
- [ ] Does the destructive experiment have a fallback plan?

## Prohibitions
- Don't design experiments with multiple primary metrics (conclusions will be confused)
- Don't omit guardrail metrics (may amplify data side effects)
- Don't design overly short experiments (less than 7 days, high cyclicality bias)
- Don't design destructive experiments without a fallback (uncontrollable risk)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP; it is the last step of PLAN.
PLAN(hypothesis-generation → ice-scoring → experiment-design) → EXPERIMENT → MEASURE

## Relationship to Workflow
This skill is step 3 of **growth-experiment-workflow**.
After completion, enters the EXPERIMENT phase (experiment execution, usually done by engineering / external).
