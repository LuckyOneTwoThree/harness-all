---
workflow_id: A
name: new-product
description: "Build a new product from 0 to 1 through exploration, strategy, PRD design, and engineering handoff"
default_mode: deep
---

# Workflow A: Build New Product from 0 to 1

> Applicable scenario: Complete product process for new product from 0 to 1
> Core mode: Exploration Gate → LOOP validation → PRD output → Engineering handoff
> Default mode: deep (mandatory exploration first, pause dialog before each module)

## Mode Selection Guide

| Mode | Stops | Feel | Suitable For |
|------|-------|------|--------------|
| `deep` (default) | 3 stops (Exploration Gate + Dialog 2/3) + 5 👤 | New domain / unclear direction / needs exploration | First-time PM, unfamiliar market |
| `standard` | Module boundaries only | Balanced | Have ideas but need validation, routine iteration |
| `skip` | No exploration stops, auto-run | Fastest but risky | Domain expert with data already in `docs/discovery/`; safety fallback triggers if exploration data missing |

> Tip: Say "switch to standard/skip mode" anytime. Skip mode without prior exploration data auto-downgrades to standard (see AGENTS.md).

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm task scope
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 1: Exploration & Discovery       │
│                                         │
│  ⏸ Step 0: Direction alignment          │
│  (must complete before research starts) │
│                                         │
│  Minimum question set:                  │
│  1. What product do you want to build?  │
│     What problem does it solve?         │
│  2. Who are the target users? How well  │
│     do you know them?                   │
│  3. What data/insights do you already   │
│     have?                               │
│  4. What hypotheses need validation?    │
│  5. What constraints (budget/time/     │
│     technology)?                        │
│                                         │
│  Adjust execution strategy based on     │
│  user answers:                          │
│  - Sufficient data → skip some          │
│    exploration                          │
│  - Vague ideas → complete exploration   │
│  - Clear direction → focus on           │
│    validation                           │
│                                         │
│  ⚠️ Forbidden: starting research        │
│  directly without asking user           │
│                                         │
│  Research (after direction aligned):    │
│  - user-research-orchestrator           │
│    (User research: VOC+behavior+        │
│     modeling+interviews+report)         │
│    👤 Persona confirmation (Human       │
│      Decision Point)                    │
│  - market-orchestrator                  │
│    (Market analysis: TAM/SOM+PEST+      │
│     competitors)                        │
│  - insight-analysis                     │
│    (Need insight: JTBD+5Whys+Kano)      │
│  - opportunity-definition               │
│    (Opportunity identification:         │
│     scoring+problem statement+HMW)      │
│    👤 Opportunity brief approval        │
│      (Human Decision Point)             │
│                                         │
│  ★ Exploration Gate (hard check +       │
│    review, single stop)                 │
│                                         │
│  Objective checks (must all pass):      │
│  - Target users clear? (Persona          │
│    confidence ≥0.7)                     │
│  - Core problem validated? (Problem     │
│    statement human-confirmed)           │
│  - Market opportunity viable? (TAM/SOM  │
│    has data)                            │
│  - Business model feasible? (Value      │
│    proposition clear)                   │
│                                         │
│  ⏸ Review with user (minimum set):     │
│  1. Do these findings match your       │
│     understanding?                      │
│  2. Is there any important missing      │
│     information?                        │
│  3. Moving to strategy phase next, is   │
│     the direction right?                │
│                                         │
│  ⚠️ Forbidden: entering module 2        │
│  directly without asking user           │
└────────┬────────────────────────────────┘
         │ User confirmed
         ▼
┌─────────────────────────────────────────┐
│ Module 2: Business Strategy             │
│                                         │
│  - business-orchestrator                │
│    (Business model: canvas+value        │
│     fit+pricing+stakeholder+            │
│     strategy-report)                    │
│  - positioning-strategy                 │
│    (Product positioning: positioning    │
│     statement)                          │
│  - planning-orchestrator                │
│    (Strategic planning: proposal+OKR+   │
│     North Star+roadmap)                 │
│    👤 Strategy direction confirmation   │
│      (Human Decision Point)             │
│                                         │
│  Output: docs/strategy/PRODUCT_STRATEGY.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ ⏸ Exploration Dialog 2: Strategy       │
│   direction confirmation                │
│                                         │
│  Minimum question set:                  │
│  1. Is the strategy direction consistent│
│     with your expectations?             │
│  2. Do OKR and roadmap priorities need  │
│     adjustment?                         │
│  3. Ready to enter PRD generation       │
│     phase?                              │
└────────┬────────────────────────────────┘
         │ User confirmed
         ▼
┌─────────────────────────────────────────┐
│              LOOP Validation            │
│  ┌─────────────────────────────────┐    │
│  │ Module 3: Ideation & Design     │    │
│  │   (RESEARCH)                    │    │
│  │  - ideation-workshop            │    │
│  │    (Idea divergence: workshop)  │    │
│  │  - prd-orchestrator             │    │
│  │    (PRD generation, design      │    │
│  │     handed to harness-design)   │    │
│  │    👤 PRD final approval        │    │
│  │      (Human Decision Point)     │    │
│  │  - validation-orchestrator      │    │
│  │    (Validation: hypothesis map+ │    │
│  │     MVP+experiment+usability)   │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ VALIDATE                        │    │
│  │  - PRD 4 quality gates          │    │
│  │  - Confidence check (≥0.7 auto  │    │
│  │    pass)                        │    │
│  │  - Human approval (solution     │    │
│  │    selection/priority)          │    │
│  │  - Constitution compliance      │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail                     │
│                   │                      │
│                   ▼                      │
│  ┌─────────────────────────────────┐    │
│  │ Revise output (REVISE)          │    │
│  │  - Supplement data / optimize   │    │
│  │    solution                     │    │
│  │  - Regenerate PRD               │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             └── Back to RESEARCH ────────┘
│                                          │
│  Iteration limit: 5 times (research type)│
│  Exceed limit → request human            │
│  intervention                            │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Module 4: Metrics Design                │
│                                         │
│  - metrics-orchestrator                 │
│    (Metrics system+tracking plan+       │
│     dashboard design)                   │
│                                         │
│  Output: docs/metrics/metrics-system.md │
│        + docs/metrics/tracking-plan.md  │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ ⏸ Exploration Dialog 3: PRD & metrics  │
│   confirmation                          │
│                                         │
│  Minimum question set:                  │
│  1. Do PRD feature priorities need      │
│     adjustment?                         │
│  2. Does the metrics system cover your  │
│     core concerns?                      │
│  3. Any technical concerns with the     │
│     tracking plan?                      │
│  4. Ready to enter monitoring design    │
│     and handoff phase?                  │
└────────┬────────────────────────────────┘
         │ User confirmed
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Monitoring Preparation        │
│ (★ prevent launching blind)            │
│                                         │
│  - monitoring-orchestrator              │
│    (Monitoring config: alert rules+     │
│     attribution model+user feedback     │
│     loop)                               │
│                                         │
│  Depends on: metrics-orchestrator's     │
│  tracking plan                          │
│  Output: docs/monitoring/monitoring-config.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive + baseline + update FEATURES.md
│                 │  + Output docs/handoff/pm-to-solo.md
│                 │    (PRD + design spec + tracking plan handoff to engineering)
│                 │  + Conditional: when involves design requirements → also produce pm-to-design.md; when involves growth strategy → also produce pm-to-growth.md
│                 │  + Prompt next step: enter launch after engineering complete
└─────────────────┘
```

## Key Checkpoints

- [ ] Exploration Gate passed? (Target users/core problem/market opportunity/business model)
- [ ] PRODUCT_STRATEGY.md updated? (Produced by planning-orchestrator, setup only fills skeleton)
- [ ] PRD passed 4 quality gates? (Completeness/consistency/ambiguity elimination/traceability)
- [ ] Confidence check passed? (Low-confidence items human-confirmed)
- [ ] Tracking plan designed? (Produced by metrics-orchestrator)
- [ ] Monitoring system established? (Produced by monitoring-orchestrator, prevent launching blind)
- [ ] docs/handoff/pm-to-solo.md handoff document produced?

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Exploration Gate not passed | Stop and ask user, supplement research data |
| LOOP iteration exceeds 5 times | Request human intervention, don't force |
| PRD quality gate not passed | Revise and re-validate, no skipping |
| Confidence < 0.3 | Block, request human confirmation whether to continue |
| Monitoring config missing | Must complete monitoring-orchestrator output before session-end |

## Next Steps

- Engineering development complete → enter **launch** workflow (acceptance & release)
- Product already live needs growth → enter **growth** workflow
- Product needs data-driven optimization → enter **optimization** workflow
