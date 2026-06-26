# Business Model Canvas - 决策表

本文档收录 Business Model Canvas Skill 的决策树逻辑、降级策略与上下游变更响应表。

## Revenue Model Decision Tree (Step 3a)

```
Start
  │
  ├─ Product form = Physical goods?
  │     └─ Yes → Checkpoint: Need subscription service?
  │           ├─ Yes → Revenue model = Subscription + One-time purchase
  │           └─ No → Revenue model = One-time sales
  │
  ├─ Product form = Software/Digital service?
  │     └─ Yes → Checkpoint: User usage frequency?
  │           ├─ High frequency (>1 time/week) → Revenue model = Subscription
  │           ├─ Medium frequency (1 time/month) → Revenue model = Usage-based billing
  │           └─ Low frequency (<1 time/month) → Revenue model = Project-based/One-time
  │
  ├─ Product form = Platform service?
  │     └─ Yes → Revenue model = Platform commission/revenue share
  │
  └─ Multi-sided market?
        ├─ Yes → Revenue model = Subscription + Platform commission
        └─ No → Select based on product form
```

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| product_context missing | User provides product description and target users → generate BMC based on description | Customer segments and value propositions lack discovery stage data support, overall confidence drops from 0.8 to 0.5, related canvas blocks confidence ≤ 0.4, annotate needs_human_validation: true | Require user to provide product concept, target user persona, and core pain point description |
| market_data missing | User provides competitor and industry info → infer market size and competitor models based on description | Revenue model and cost structure lack market benchmark data, pricing reference missing, related canvas blocks confidence ≤ 0.4 | Require user to provide competitor business models, industry typical pricing, and market size data |
| product_context + market_data both missing | User provides product description and target users → generate BMC based on description | Each module's overall confidence drops from 0.8 to 0.5, more assumption items, related canvas blocks confidence ≤ 0.3, annotate auto_filled: true | Require user to provide product description, target user persona, competitor info, and industry pricing reference |
| All upstream files missing | Prompt user to execute prior stages first, or generate BMC directly based on user-provided product description and target users | Overall confidence drops from 0.8 to 0.3, most content is assumption inference, related canvas blocks confidence ≤ 0.3, annotate auto_filled: true | Require user to provide product concept, target users, value proposition, or upload persona.json/opportunity-definition.json files |

## Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| persona.json user persona update | Customer segments, customer relationships modules need re-population | Re-execute Step 1 and Step 7, annotate change source |
| opportunity-definition update | Value proposition, revenue model may need adjustment | Re-evaluate value proposition priority, check revenue model match |
| competitor-analysis competitor data update | Value proposition differentiation, revenue model pricing reference | Re-execute Step 2 and Step 3, update competitor benchmarking data |
| Market size data change | Revenue expectations and cost structure | Recalculate unit economics indicators, update market size assumptions |

## Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Customer segment adjustment | business-value-fit, business-pricing | Output file version number + change summary |
| Value proposition change | business-value-fit, positioning-strategy | Output file version number + change summary |
| Revenue model change | business-pricing | Output file version number + change summary |
| Cost structure change | business-pricing, business-strategy-report | Output file version number + change summary |
