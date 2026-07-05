---
workflow_id: H
name: pivot
description: "Execute strategic adjustments including repositioning, business model changes, and roadmap revisions"
default_mode: deep
---

# Workflow H: Strategic Adjustment

> Applicable scenario: Product transformation, repositioning, new market entry, major strategic direction adjustment
> Core mode: Strategy retrospective → repositioning → LOOP validation → contract update
> Default mode: deep (mandatory exploration first, pause dialog before each module)

## Differences from Other Workflows

| Dimension | new-product | iteration | **pivot** |
|------|-------------|-----------|-----------|
| Goal | 0→1 new product | Feature-level change | **Strategic-level adjustment** |
| Trigger | New product initiation | Clear change requirement | **Strategic direction change** |
| Impact | Brand new output | Changed module PRD | **PRD+positioning+OKR+roadmap all updated** |
| LOOP | Exploration→design | Change→design | **Strategy→positioning→planning** |

## Trigger Conditions

- Major business environment changes (market/competition/policy)
- Product positioning needs redefinition
- Target user group shift
- Business model needs adjustment
- North Star Metric needs reselection
- Roadmap needs major revision

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm reason for strategic adjustment
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 1: Strategy Retrospective        │
│                                         │
│  ⏸ Step 0: Direction alignment          │
│  (must complete before research starts) │
│                                         │
│  Minimum question set:                  │
│  1. Why adjust strategy? What are the   │
│     trigger factors?                    │
│  2. What is the new direction? How does │
│     it differ from the old direction?   │
│  3. What data do you have to support    │
│     this adjustment?                    │
│  4. What constraints exist?             │
│                                         │
│  ⚠️ Forbidden: starting research        │
│  directly without asking user           │
│                                         │
│  Research (after direction aligned):    │
│  - user-research-orchestrator           │
│    (Re-validate user needs, new Persona)│
│    👤 New Persona confirmation          │
│      (Human Decision Point)             │
│  - market-orchestrator                  │
│    (Re-evaluate market, new TAM/SOM/    │
│     competitors)                        │
│  - insight-analysis                     │
│    (Re-insight needs, new JTBD)         │
│                                         │
│  ★ Exploration Gate (hard check +       │
│    review, single stop)                 │
│                                         │
│  Objective checks:                      │
│  - Is strategic adjustment reason       │
│    sufficient? (Data-supported)         │
│  - Are new target users validated?      │
│  - Is new market opportunity viable?    │
│  👤 Hard gate result approval           │
│    (Human Decision Point)               │
│                                         │
│  ⏸ Review with user (minimum set):     │
│  1. Do retrospective findings match     │
│     your expectations?                  │
│  2. Is data support for new direction   │
│     sufficient?                         │
│  3. Moving to repositioning phase, is   │
│     the direction right?                │
└────────┬────────────────────────────────┘
         │ User confirmed
         ▼
┌─────────────────────────────────────────┐
│              LOOP Validation            │
│  ┌─────────────────────────────────┐    │
│  │ Module 2: Repositioning         │    │
│  │   (RESEARCH)                    │    │
│  │  - business-orchestrator        │    │
│  │    (New business model+value    │    │
│  │     fit+pricing+stakeholder+    │    │
│  │     strategy-report)            │    │
│  │  - positioning-strategy         │    │
│  │    (New positioning statement)  │    │
│  │  - planning-orchestrator        │    │
│  │    (New OKR+North Star+roadmap) │    │
│  │  - metrics-orchestrator          │    │
│  │    (if North Star changes:       │    │
│  │     validate+break down new NS, │    │
│  │     propagate to tracking-plan  │    │
│  │     + dashboard)                 │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ VALIDATE                        │    │
│  │  - Strategy consistency check   │    │
│  │  - Contract change impact       │    │
│  │    analysis                     │    │
│  │  - Human approval (strategy     │    │
│  │    direction)                   │    │
│  │    👤 Strategy direction         │    │
│  │      confirmation (Human        │    │
│  │      Decision Point)            │    │
│  │  - Stakeholder alignment        │    │
│  │    confirmation                 │    │
│  │    👤 Stakeholder alignment      │    │
│  │      (Human Decision Point)     │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail → back to RESEARCH ─┘
│                                          │
│  Iteration limit: 5 times (pivot type)  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Contract Update (★ change impact        │
│   analysis)                             │
│                                         │
│  - change-impact-analysis               │
│    (Assess impact on existing PRD/      │
│     metrics/tracking)                   │
│  - Update PRODUCT_STRATEGY.md           │
│  - Update PRD.md (if positioning change │
│    affects features)                    │
│  - metrics-orchestrator (if North Star  │
│    changes; validate+break down+        │
│    propagate to tracking/dashboard)      │
│                                         │
│  Output: docs/strategy/PRODUCT_STRATEGY.md │
│        + docs/product/PRD.md            │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive + update FEATURES.md
│                 │  + Output docs/handoff/pm-to-solo.md (strategic change handoff)
│                 │  + Notify harness family members of strategic adjustment
│                 │  + Conditional: when involves design requirements → also produce pm-to-design.md
└─────────────────┘
```

## Key Checkpoints

- [ ] Strategic adjustment reason data-supported? (Not gut feeling)
- [ ] New positioning validated by users?
- [ ] New business model feasible?
- [ ] Stakeholders aligned?
- [ ] Change impact analysis complete? (Impact on existing PRD/metrics/tracking)
- [ ] Human approved strategic direction?

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Strategic adjustment reason insufficient | Supplement data, don't pivot on intuition |
| New positioning failed validation | Back to LOOP for repositioning |
| Stakeholders not aligned | Hold alignment meeting, don't force push |
| Change impact too large | Phase implementation, reduce risk |

## Next Steps

- Need product redesign after strategic adjustment → enter **new-product** workflow
- Need feature iteration after strategic adjustment → enter **iteration** workflow
- Need release after strategic adjustment → enter **launch** workflow
