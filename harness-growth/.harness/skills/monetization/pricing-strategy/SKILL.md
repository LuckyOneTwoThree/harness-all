---
name: pricing-strategy
description: Pricing strategy recommendations, including value / cost / competitor perspectives + Van Westendorp price sensitivity
---
# Pricing Strategy — Pricing Strategy

## When to use
- When a new product needs pricing
- When existing pricing needs adjustment
- Monetization optimization Workflow
- User asks to "help us with pricing

## Inputs
- docs/handoff/pm-to-growth.md
- memory/knowledge-base.md

## Outputs
- docs/operations/pricing-strategy.md

## Iron Rules
- Pricing must be **value-based**, not cost-plus
- Must consider both **competitor pricing** and **user willingness to pay**
- Must design **price tiers** (Free / Basic / Pro / Enterprise), not a single price

## Process

1. **Three-perspective pricing analysis**

   ### Value-based pricing
   - How much value does the product create for users? (time saved / revenue increased / cost reduced)
   - How much are users willing to pay for the value? (10-30% of the value)
   ```
   Value quantification:
   - Time saved: X hours/month × ¥Y/hour = ¥Z/month
   - Revenue increased: +X% conversion × ¥Y revenue = ¥Z/month
   Pricing reference: 10-30% of value = ¥A-¥B/month
   ```

   ### Cost-based pricing
   - Marginal cost + fixed cost allocation
   - Gross margin target (SaaS typically > 70%)
   ```
   Cost: ¥X/user/month
   Target gross margin: 80%
   Minimum price: ¥X / (1-0.8) = ¥Y
   ```

   ### Competitor-based pricing
   ```
   | Competitor | Price | Features | Difference |
   |------------|-------|----------|------------|
   | A | ¥99/month | Full features | We are better |
   | B | ¥49/month | Basic | We are more complete |
   | C | ¥199/month | Advanced | We are cheaper |
   ```

2. **Van Westendorp price sensitivity test** (if survey data is available)
   - Too cheap (doubt quality): ¥X
   - Cheap (good deal): ¥Y
   - Expensive (need to consider): ¥Z
   - Too expensive (won't buy): ¥W
   - Optimal price range: [cheap - expensive] = [¥Y, ¥Z]

3. **Price tier design**
   ```
   | Tier | Price | Features | Target users |
   |------|-------|----------|--------------|
   | Free | ¥0 | Basic features | Trial / spread |
   | Basic | ¥49/month | Core features | Individual users |
   | Pro | ¥99/month | Full features | Professional users |
   | Enterprise | ¥299/month | Full features + support | Teams / enterprises |
   ```

4. **Free strategy design**
   - Feature gating: which features are limited in the free version?
   - Usage gating: how much usage is limited in the free version?
   - Trial strategy: time-limited full-feature trial vs perpetual free basic version
   - Credit card gating: require a credit card? (reduces trials but improves paid quality)

5. **Produce pricing plan**
   Write to `docs/operations/pricing-strategy.md`

## Prohibitions
- Don't price based only on cost (ignores user-perceived value)
- Don't use a single price (lacks price anchor and choice)
- Don't ignore competitor pricing (users will compare)
- Don't change prices frequently (damages trust; recommend annual price adjustments)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP(monetization).

## Relationship to Workflow
This skill is step 1 of monetization optimization workflows.
