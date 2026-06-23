---
name: nrr-analysis
description: NRR breakdown and improvement plan, including reduce churn + expansion + upsell analysis
triggers:
  - When net retention revenue needs to be analyzed
  - Monetization optimization Workflow
  - Growth review report
  - User asks to "analyze NRR"
reads:
  - memory/knowledge-base.md
writes:
  - docs/operations/nrr-report.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
---

# NRR Analysis — NRR Analysis and Improvement

## Iron Rules
- NRR must be **broken down** into three factors: churn / contraction / expansion — looking only at the total can't locate the problem
- NRR > 100% is the hallmark of a healthy SaaS — < 100% means revenue is shrinking
- Improvement plans must **quantify the expected impact** — can't just say "reduce churn"

## Process

1. **Calculate NRR**
   ```
   NRR = (Beginning ARR - Churned ARR - Contracted ARR + Expansion ARR) / Beginning ARR × 100%

   Example:
   Beginning ARR: ¥1,000,000
   Churned ARR: -¥80,000 (customers leaving)
   Contracted ARR: -¥50,000 (customers downgrading)
   Expansion ARR: +¥200,000 (customer expansion / upsell)
   NRR = (1,000,000 - 80,000 - 50,000 + 200,000) / 1,000,000 = 107%
   ```

2. **NRR breakdown analysis**
   ```
   | Factor | Amount | % of beginning ARR | Industry benchmark | Assessment |
   |--------|--------|---------------------|--------------------|------------|
   | Churn | -¥80K | -8% | <-5% | ⚠️ High |
   | Contraction | -¥50K | -5% | <-3% | ⚠️ High |
   | Expansion | +¥200K | +20% | >+15% | ✅ Excellent |
   | NRR | +7% | 107% | >100% | ✅ Meets bar |
   ```

3. **Churn analysis (reduce Churn)**
   - Which customers churned? (segment: enterprise vs SMB)
   - Churn reasons? (product / service / price / competitor)
   - Pre-churn signals? (usage frequency drop / negative feedback)
   - Recommendation: [specific measures to reduce churn]

4. **Contraction analysis (reduce Contraction)**
   - Which customers downgraded? (from Pro → Basic)
   - Downgrade reasons? (features unused / price-sensitive / budget cut)
   - Recommendation: [specific measures to reduce contraction]

5. **Expansion analysis (add Expansion)**
   - Which customers expanded? (from Basic → Pro / added seats)
   - Expansion triggers? (deeper usage / team growth / new features)
   - Recommendation: [specific measures to amplify expansion]

6. **NRR improvement plan**
   ```
   | Measure | Type | Expected impact | Priority |
   |---------|------|-----------------|----------|
   | Churn early warning + proactive intervention | Reduce Churn | NRR +2% | P0 |
   | Expansion trigger automation | Add Expansion | NRR +3% | P0 |
   | Contraction retention messaging | Reduce Contraction | NRR +1% | P1 |
   | High-value customer success | Reduce Churn | NRR +1% | P1 |
   ```

7. **Produce NRR report**
   Write to `docs/operations/nrr-report.md`
   Sync to `memory/knowledge-base.md`

## NRR industry benchmarks

| NRR level | Assessment | Notes |
|-----------|------------|-------|
| > 130% | Excellent | Top-tier SaaS (e.g., Snowflake) |
| 110-130% | Good | Healthy SaaS |
| 100-110% | Acceptable | Maintaining, not shrinking |
| 90-100% | Warning | Revenue shrinking |
| < 90% | Critical | Needs urgent intervention |

## Prohibitions
- Don't look only at the NRR total without breakdown (can't locate the problem)
- Don't ignore contraction (contraction is also revenue loss)
- Don't focus only on reducing churn and ignore expansion (expansion is the lever for NRR improvement)
- Don't estimate NRR without data

## Relationship to LOOP
This skill runs in the **MEASURE phase** of LOOP(monetization).

## Relationship to Workflow
This skill is step 3 of monetization optimization workflows, and a data source for growth-review-workflow.
