# Business Pricing - 决策表

本文档收录 Business Pricing Skill 的降级策略与上下游变更响应表。

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| bmc.json | User provides product description → recommend pricing based on industry benchmarks | Value proposition and cost structure lack BMC data support, pricing may deviate from reality | Require user to provide product features, target users, and cost structure description or upload bmc.json file |
| Competitor pricing data (competitor-analysis.json) | User provides product description → recommend pricing based on industry benchmarks | Competitor matrix is empty, market gaps cannot be identified, pricing lacks competitor anchoring | Require user to provide competitor names, pricing tiers, and prices or upload competitor-analysis.json file |
| bmc.json + Competitor pricing data | User provides product description and target market → recommend pricing based on industry benchmarks | Overall confidence reduced, options lack data anchoring | Require user to provide product description, competitor pricing, and industry benchmark data |
| All upstream files missing | Prompt user to execute prior stages first, or recommend pricing based on user-provided product description and industry benchmarks | Overall confidence significantly reduced, options are only industry benchmark references | Require user to provide product features, target users, competitor pricing, and cost structure info |
| Willingness-to-pay inference data (user provided) | If user does not provide willingness-to-pay inference data, prompt user to provide or skip related steps | Willingness-to-pay analysis missing, pricing options lack user-side validation | Require user to provide user willingness-to-pay survey data or price sensitivity test results |

## Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| bmc.json value proposition update | Value anchors of pricing options need adjustment | Reassess pricing rationale of each option, update value premium basis |
| bmc.json customer segment change | Willingness-to-pay segmentation and tier target users | Re-execute Step 2 and Step 3, adjust pricing by new segments |
| bmc.json cost structure change | Unit economics metrics need recalculation | Recalculate LTV/CAC and payback period |
| competitor-analysis competitor pricing update | Competitor pricing matrix and market gaps | Re-execute Step 1, update competitor benchmarking |

## Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Pricing option adjustment | business-strategy-report, stakeholder-analysis | Output file version number + change summary |
| Unit economics metric change | business-strategy-report | Output file version number + change summary |
| Competitor pricing matrix update | positioning-strategy | Output file version number + change summary |
