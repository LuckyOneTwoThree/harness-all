---
name: four-fits-assessment
description: Product-Channel-Model-Market Fit four-dimensional assessment, diagnosing the root cause of growth bottlenecks
---
# Four Fits Assessment — Four-Fit Assessment

## When to use
- When growth is stuck and the problem is unclear
- Growth strategy formulation Workflow
- User asks to "assess growth feasibility

## Inputs
- docs/operations/GROWTH_STRATEGY.md
- docs/handoff/pm-to-growth.md

## Outputs
- docs/operations/GROWTH_STRATEGY.md

## Iron Rules
- The four Fits are **intercoupled** — a break in any one will stall growth
- Assessment must be based on **data/facts**, not "feels like it should match"
- Below-bar results must come with a **fix direction**

## Process

1. **Product-Market Fit (PMF) assessment**
   - Does the product meet a core need of some market?
   - Sean Ellis Test: ≥ 40% of users "very disappointed"?
   - Does the retention curve plateau?
   - Assessment: [Meets bar / Close / Below bar]

2. **Product-Channel Fit (PCF) assessment**
   - Does the product form match the native user behavior of some channel?
   - | Channel | Suited product type | Do we match |
     |---------|----------------------|-------------|
     | SEO/Content | Has long-tail demand, informational product | ? |
     | Viral | Social/collaboration, has sharing attributes | ? |
     | Paid | Has clear LTV > CAC | ? |
     | Social | Visual, has spreadability | ? |
   - Assessment: [Meets bar / Close / Below bar]

3. **Channel-Model Fit (CMF) assessment**
   - Does the channel's CAC match the business model's LTV?
   - LTV/CAC ≥ 3? (health standard)
   - Is CAC controllable at scale?
   - Assessment: [Meets bar / Close / Below bar]

4. **Model-Market Fit (MMF) assessment**
   - Does the business model (subscription / transaction / ads) match the target market's willingness to pay?
   - Is price elasticity reasonable?
   - Does ARPU cover cost?
   - Assessment: [Meets bar / Close / Below bar]

5. **Comprehensive assessment**
   ```
   | Fit type | Status | Bottleneck | Fix direction |
   |----------|--------|------------|---------------|
   | PMF | ✅/⚠️/❌ | [reason if below bar] | [fix direction] |
   | PCF | ✅/⚠️/❌ | | |
   | CMF | ✅/⚠️/❌ | | |
   | MMF | ✅/⚠️/❌ | | |
   ```

6. **Produce fix recommendations**
   - If PMF is below bar: polish the product first; don't invest in growth
   - If PCF is below bar: adjust the product form to fit the channel, or switch channels
   - If CMF is below bar: optimize CAC or lift LTV
   - If MMF is below bar: adjust pricing or the business model

## Prohibitions
- Don't do large-scale acquisition when PMF is below bar (leaky bucket)
- Don't ignore any Fit (the four are intercoupled)
- Don't just assess without fixing (the purpose of assessment is action)

## Relationship to LOOP
This skill does not run inside LOOP; it is a **strategic-level** assessment.

## Relationship to Workflow
This skill is step 5 of **growth-strategy-workflow**.
If any Fit is below bar, go back to nsm-definition to re-examine.
