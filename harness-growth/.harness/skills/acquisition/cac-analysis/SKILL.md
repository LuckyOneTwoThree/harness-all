---
name: cac-analysis
description: CAC calculation and channel comparison, including LTV/CAC ratio and scaling inflation assessment
---
# CAC Analysis — CAC Calculation and Analysis

## When to use
- When acquisition cost needs to be calculated
- Post-campaign performance evaluation
- Growth review reports
- User asks "calculate CAC

## Inputs
- memory/knowledge-base.md

## Outputs
- docs/operations/cac-report.md
- memory/knowledge-base.md

## Iron Rules
- CAC must include **all acquisition costs** (ads + labor + tools), not just ad spend
- Must be calculated **separately by channel** — CAC varies significantly across channels
- Must assess **CAC inflation at scale** — low CAC at small scale does not mean low CAC at scale

## Process

1. **Collect cost data**
   ```
   | Cost Item | Amount | Notes |
   |-----------|--------|-------|
   | Ad spend | ¥10,000 | Ad spend across channels |
   | Content production | ¥3,000 | Content creation cost (allocated) |
   | Tooling | ¥500 | Analytics/paid media tools |
   | Labor | ¥5,000 | Operator time (allocated) |
   | Total cost | ¥18,500 | |
   ```

2. **Calculate CAC**
   ```
   CAC = Total acquisition cost / New users acquired

   Example:
   Total cost = ¥18,500
   New users = 370
   CAC = ¥50
   ```

3. **CAC by channel**
   ```
   | Channel | Spend | Acquired users | CAC | Conversion rate |
   |---------|-------|----------------|-----|-----------------|
   | SEO | ¥3,000 | 200 | ¥15 | 5.0% |
   | Paid search | ¥8,000 | 100 | ¥80 | 3.0% |
   | Social ads | ¥5,000 | 50 | ¥100 | 1.5% |
   | Referral | ¥2,500 | 20 | ¥125 | - |
   ```

4. **LTV/CAC ratio assessment**
   ```
   LTV = ARPU × Average lifetime
   LTV/CAC ≥ 3 → Healthy
   LTV/CAC 1-3 → Needs optimization
   LTV/CAC < 1 → Loss-making
   ```

5. **Scaling CAC inflation assessment**
   - CAC is low at small-scale testing (precise targeting)
   - CAC rises at scale (audience expansion + increased competition)
   - Assessment: expected CAC change after doubling budget

6. **Channel comparison and optimization recommendations**
   ```
   | Channel | CAC | LTV/CAC | Scaling inflation | Recommendation |
   |---------|-----|---------|-------------------|----------------|
   | SEO | ¥15 | 30.0 | Low | Scale up investment |
   | Paid search | ¥80 | 5.6 | Medium | Maintain + optimize |
   | Social ads | ¥100 | 4.5 | High | Hold off on scaling |
   ```

7. **Produce CAC report**
   Write to `docs/operations/cac-report.md`
   Sync to `memory/knowledge-base.md`

## Prohibitions
- Don't count only ad spend and ignore labor/tools (understates true CAC)
- Don't ignore scaling inflation (small-scale CAC ≠ scaled CAC)
- Don't recommend scaling when LTV/CAC < 3 (loss risk)

## Relationship to LOOP
This skill does not run inside LOOP; it is an **analysis tool**.

## Relationship to Workflow
This skill is part of acquisition campaign workflows and a data source for growth-review-workflow.
