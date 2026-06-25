---
name: landing-page-optimization
description: Landing page design and optimization, including value proposition/CTA/form/A-B testing recommendations
---
# Landing Page Optimization — Landing Page Optimization

## When to use
- Need to design a landing page after acquisition channels are decided
- Landing page conversion rate is low and needs optimization
- User asks to "optimize landing page

## Inputs
- docs/handoff/pm-to-growth.md
- docs/handoff/solo-to-growth.md

## Outputs
- docs/operations/landing-page-spec.md

## Iron Rules
- Landing page must be **message-matched** with the ad creative — deliver what the ad promises
- Each landing page focuses on **one CTA** — multiple CTAs distract attention
- Form fields should be as few as possible — each additional field drops conversion by 5-10%

## Process

1. **Define landing page goal**
   - Primary conversion goal: Sign-up / trial / purchase / download / booking
   - Secondary goals: Learn more / subscribe / share
   - One page, one primary CTA

2. **Value proposition design**
   ```
   Headline (H1): [Core value, < 15 chars]
   Subheadline: [Specific description, < 30 chars]
   Value point 1: [Feature/benefit]
   Value point 2: [Feature/benefit]
   Value point 3: [Feature/benefit]
   Social proof: [User count / rating / case study / Logo]
   CTA: [Call to action]
   ```

3. **Page structure design**
   ```
   Above the fold:
   - H1 headline + subheadline
   - Primary CTA
   - Trust badges / social proof

   Below the fold:
   - Feature deep-dive (image + text)
   - User case studies / testimonials
   - FAQ
   - Repeat CTA
   ```

4. **Form optimization**
   | Field count | Conversion impact | Suited scenario |
   |-------------|-------------------|-----------------|
   | 1-3 fields | Baseline | Free trial / sign-up |
   | 4-6 fields | -10~20% | Paid trial / booking |
   | 7+ fields | -30%+ | B2B leads / high-end services |

   - Keep only essential fields
   - Use smart defaults
   - Support social login (reduce typing)
   - Real-time validation (reduce submission failures)

5. **Trust elements**
   - User logos / numbers
   - Ratings / reviews
   - Security certifications / privacy commitments
   - Refund guarantee / free trial

6. **Performance optimization**
   - Load time < 3s (each extra 1s drops conversion by 7%)
   - Mobile responsiveness
   - Image compression + lazy load

7. **A/B testing recommendations**
   ```
   | Test item | Variant A | Variant B | Hypothesis |
   |-----------|-----------|-----------|------------|
   | Headline | Feature description | Value description | Value-oriented converts higher |
   | CTA | "Sign up" | "Start free" | Benefit-oriented CTA higher CTR |
   | Form | 5 fields | 3 fields | Fewer fields convert higher |
   ```

8. **Produce landing page spec**
   Write to `docs/operations/landing-page-spec.md`

## Prohibitions
- Don't build pages where ad and landing page are inconsistent (high bounce rate)
- Don't place multiple CTAs (distract attention)
- Don't design overly long forms (unless B2B high-value leads)
- Don't ignore mobile (mobile traffic is 50%+)

## Relationship to LOOP
This skill runs in the **EXPERIMENT phase** of LOOP(optimization).

## Relationship to Workflow
This skill is part of acquisition campaign workflows.
