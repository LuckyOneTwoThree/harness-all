---
name: nsm-definition
description: North Star Metric definition and selection, guiding company-wide growth goal alignment
---
# NSM Definition — North Star Metric Definition

## When to use
- When a new project / product needs to define a growth metric
- Growth strategy formulation Workflow
- User asks to "define the North Star Metric

## Inputs
- docs/handoff/pm-to-growth.md
- memory/knowledge-base.md

## Outputs
- docs/operations/GROWTH_STRATEGY.md
- memory/knowledge-base.md

## Iron Rules
- The NSM must reflect the **core value users receive**, not commercial revenue
- The NSM must be a **leading indicator**, not a lagging one
- The NSM must be **breakdown-able into actionable input metrics**
- The whole company focuses on **one** NSM only

## Process

1. **Understand the product's core value**
   - Read `docs/handoff/pm-to-growth.md` (if available) to get product positioning and target audience
   - Answer: what is the core value the product creates for users?
   - Answer: what is the user's "aha moment" with the product?

2. **NSM candidate list**
   Generate candidate NSMs based on product type:

   | Product type | NSM direction | Classic examples |
   |--------------|---------------|------------------|
   | Social/Content | Time spent / content consumption | Spotify = listening time, Netflix = watch time |
   | SaaS/Tools | Core action completion count | Slack = daily active teams sending messages |
   | E-commerce/Transactional | Transaction volume | Airbnb = nights booked |
   | Marketplace/Platform | Two-sided match volume | Uber = weekly completed trips |
   | Media/Ads | UV/PV | Facebook = DAU |
   | Subscription/SaaS | Paid user activity | Paid user MAU |

3. **NSM selection criteria assessment**
   For each candidate NSM, assess:

   | Criterion | Description | Weight |
   |------------|-------------|--------|
   | Reflects core value | Does the NSM quantify the value users receive? | High |
   | Leading indicator | Does the NSM change before revenue changes? | High |
   | Breakdown-able | Can the NSM be broken down into experimentable input metrics? | High |
   | Measurable | Can the NSM be accurately measured? | Medium |
   | Cross-team consensus | Does the whole company understand and agree? | Medium |

4. **Determine the NSM**
   Select the highest-scoring candidate and define:
   ```
   North Star Metric: [metric name]
   Definition: [exact calculation formula]
   Current value: [if data is available]
   Target value: [this period's goal]
   Measurement cycle: [daily / weekly / monthly]
   ```

5. **Write to growth strategy document**
   Update the "North Star Metric" section of `docs/operations/GROWTH_STRATEGY.md`

## Prohibitions
- Don't pick a revenue-type metric as the NSM (revenue is an outcome, not user value)
- Don't pick vanity metrics (e.g., sign-up count — sign-up ≠ value realization)
- Don't pick metrics that can't be broken down (can't experiment = can't grow)
- Don't pick multiple NSMs (focusing on one enables alignment)

## Relationship to LOOP
This skill does not run inside LOOP; it is a **strategic-level** definition.
Usually runs in the growth strategy formulation Workflow.

## Relationship to Workflow
This skill is step 1 of **growth-strategy-workflow**.
