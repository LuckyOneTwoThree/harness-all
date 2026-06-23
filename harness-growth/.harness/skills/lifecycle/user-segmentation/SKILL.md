---
name: user-segmentation
description: User segmentation (RFM / lifecycle / value tiering); Segment is a first-class citizen that can be reused
triggers:
  - When users need differentiated operations
  - User operations Workflow
  - User asks to "segment users"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/segments.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 2
---

# User Segmentation — User Segmentation

## Iron Rules
- Segments must be **actionable** — must enable differentiated operations, otherwise meaningless
- Segment is a **first-class citizen** — written to the knowledge base, reusable by outreach/experiments/dashboards
- Segmentation dimensions must be based on **behavioral data**, not just demographics

## Process

1. **Determine the segmentation goal**
   - Is it for differentiated outreach? For experiment targeting? For analysis?
   - Different goals call for different segmentation methods

2. **Choose a segmentation method**

   ### RFM segmentation (suited for e-commerce / transactional)
   | Dimension | Meaning | Score |
   |-----------|---------|-------|
   | Recency | How long since the last purchase | Higher when more recent |
   | Frequency | Purchase frequency | Higher when more frequent |
   | Monetary | Spend amount | Higher when more |

   ### Lifecycle segmentation (suited for SaaS / tools)
   | Stage | Definition | Operations goal |
   |-------|------------|-----------------|
   | New user | Signed up < 7 days ago | Activation |
   | Active user | Core action within 7 days | Retention + habit |
   | Silent user | Inactive 7-30 days | Reactivation |
   | Churned user | Inactive 30+ days | Win-back |

   ### Value tiering (suited for subscription / SaaS)
   | Tier | Definition | Operations goal |
   |------|------------|-----------------|
   | High value | Top 10% LTV | Retain + Upsell |
   | Medium value | 10-50% LTV | Lift value |
   | Low value | Bottom 50% | Activate or drop |

3. **Define segmentation rules**
   Each segment must have **explicit rules** (queryable / computable):
   ```
   Segment ID: S-001
   Name: High-frequency active users
   Rule: Core action ≥ 5 times within 7 days AND signed up > 30 days
   Size: 1,200 (15%)
   Retention: 85%
   LTV: ¥450
   Operations strategy: Habit reinforcement + Upsell
   ```

4. **Write to segment library**
   Write segment definitions to `docs/operations/segments.md`
   Sync to the "user segment library" in `memory/knowledge-base.md`

5. **Segment actionability check**
   - Does each segment have a clear operations strategy?
   - Are segments mutually exclusive? (A user should not belong to multiple mutually exclusive segments)
   - Can segments be updated dynamically? (Users auto-migrate as behavior changes)

## Prohibitions
- Don't build non-actionable segments (e.g., "male users" — and then what?)
- Don't build overly granular segments (each segment < 100 people has no statistical meaning)
- Don't build static segments (not updating as behavior changes = segment becomes stale)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP(lifecycle/optimization).

## Relationship to Workflow
This skill is step 1 of **lifecycle-operations-workflow**.
Segments can be reused by onboarding-design / churn-rescue / experiment-design.
