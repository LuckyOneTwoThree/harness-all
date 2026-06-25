---
name: kpi-tree
description: Break down the North Star Metric into a KPI Tree, producing experimentable input metrics
---
# KPI Tree — Metric Breakdown

## When to use
- When the NSM is defined and needs to be broken down
- Growth strategy formulation Workflow
- User asks to "break down metrics

## Inputs
- docs/operations/GROWTH_STRATEGY.md
- docs/handoff/pm-to-growth.md

## Outputs
- docs/operations/GROWTH_STRATEGY.md
- memory/knowledge-base.md

## Iron Rules
- Each layer's metrics must be **experimentable**
- Upper and lower layers must have a **causal, not merely correlational**, relationship
- Break down to **actionable leaf metrics** (the level where experiments can be directly designed)

## Process

1. **Read the NSM**
   From `docs/operations/GROWTH_STRATEGY.md`, read the defined North Star Metric

2. **First-layer breakdown (formula breakdown)**
   Break down the NSM with a math formula:
   ```
   NSM = A × B × C

   Example (Airbnb):
   Nights booked = Active hosts × Average nights booked per host
                 = (New hosts + Existing hosts × retention) × (Booking rate × Average booked nights)
   ```

3. **Second-layer breakdown (funnel breakdown)**
   For each first-layer metric, break down by funnel:
   ```
   New hosts = Visitors × Sign-up conversion rate × Host verification conversion rate
   ```

4. **Third-layer breakdown (experimentable metrics)**
   Break down to the level where experiments can be directly designed:
   ```
   Sign-up conversion rate = Landing page conversion rate × Form completion rate × Email verification rate
   ```

5. **Annotate experimentability**
   For each leaf metric, assess:
   - Directly experimentable? (e.g., "form field count" → can A/B test)
   - Indirectly influenceable? (e.g., "brand awareness" → needs to be influenced via content/SEO)
   - Not influenceable? (e.g., "total market size" → external factor)

6. **Produce KPI Tree**
   ```
   NSM: [North Star Metric]
   ├── First-layer metric A: [metric] (current → target)
   │   ├── Second-layer metric A1: [metric]
   │   │   ├── Leaf metric A1.1: [experimentable metric] ← experiment direction
   │   │   └── Leaf metric A1.2: [experimentable metric]
   │   └── Second-layer metric A2: [metric]
   └── First-layer metric B: [metric]
       └── ...
   ```

7. **Write to growth strategy document**
   Update the "KPI Tree" section of `docs/operations/GROWTH_STRATEGY.md`

## Prohibitions
- Don't stop at a layer that can't be experimented on (the purpose of breakdown is to guide experiments)
- Don't substitute correlation for causation (correlation ≠ causation)
- Don't ignore external factors (annotate which are uncontrollable)

## Relationship to LOOP
This skill does not run inside LOOP; it is a **strategic-level** breakdown.

## Relationship to Workflow
This skill is step 2 of **growth-strategy-workflow**.
Output is used by hypothesis-generation to reference experiment directions.
