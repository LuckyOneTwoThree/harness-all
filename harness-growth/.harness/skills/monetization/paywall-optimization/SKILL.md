---
name: paywall-optimization
description: Paywall design and optimization, including timing / messaging / feature gating / A-B testing recommendations
triggers:
  - When paid conversion rate is low and needs optimization
  - When a new product launches paid features
  - Monetization optimization Workflow
  - User asks to "optimize the paywall"
reads:
  - docs/operations/pricing-strategy.md
  - memory/knowledge-base.md
writes:
  - docs/operations/paywall-spec.md
quality_gates: []
max_iterations: 2
---

# Paywall Optimization — Paywall Optimization

## Iron Rules
- Paywall timing must come **after the user feels value** — showing it too early yields very low conversion
- Paywall messaging must **emphasize value**, not list features
- Must have a **free alternative path** — a hard paywall will anger users

## Process

1. **Determine paywall timing**
   | Timing type | Description | Conversion rate | Suited for |
   |-------------|-------------|-----------------|------------|
   | Right after sign-up | Hard paywall | Low (1-3%) | High-value / must-have |
   | After trial | N-day free trial | Medium (5-15%) | SaaS |
   | Usage-triggered | Free quota exhausted | High (10-25%) | Tools / content |
   | Feature-triggered | When advanced features are needed | High (15-30%) | Freemium |
   | Value-triggered | After experiencing core value | Highest (20-40%) | All |

2. **Paywall messaging design**
   ```
   ❌ Feature-oriented:
   "Upgrade to Pro for unlimited projects + advanced reports + API access + priority support"

   ✅ Value-oriented:
   "You've already created 3 projects — upgrade for unlimited projects and let your ideas run free"
   ```

3. **Feature gating strategy**
   ```
   | Feature | Free version | Paid version | Gating reason |
   |---------|--------------|--------------|---------------|
   | Basic features | ✅ | ✅ | Acquisition + experiencing value |
   | Advanced features | ❌ | ✅ | Incentive to pay |
   | Collaboration features | Limited | ✅ | Team monetization |
   | Data export | ❌ | ✅ | Enterprise monetization |
   | API | ❌ | ✅ | Developer monetization |
   ```

4. **Paywall UI design**
   - Clearly display price and tiers
   - Highlight the recommended tier ("Most popular" badge)
   - Annual discount anchor ("Save 20% on annual")
   - Trust elements (refund guarantee / cancel anytime / secure payment)
   - Simplify the purchase flow (1-2 steps)

5. **A/B testing recommendations**
   | Test item | Variant A | Variant B | Hypothesis |
   |-----------|-----------|-----------|------------|
   | Timing | After 7-day trial | Usage-triggered | Usage-triggered converts higher |
   | Messaging | Feature list | Value description | Value-oriented converts higher |
   | Price | Monthly ¥99 | Annual ¥799 (save 33%) | Annual lifts ARPU |
   | Gating | Feature gating | Usage gating | Feature gating converts higher |

6. **Produce paywall spec**
   Write to `docs/operations/paywall-spec.md`

## Prohibitions
- Don't show the paywall before the user has experienced value (very low conversion + hurts experience)
- Don't build a hard paywall (no free path = users leave immediately)
- Don't use feature lists as messaging (users buy value, not features)
- Don't ignore the annual option (annual lifts ARPU and retention)

## Relationship to LOOP
This skill runs in the **EXPERIMENT phase** of LOOP(monetization).

## Relationship to Workflow
This skill is step 2 of monetization optimization workflows.
