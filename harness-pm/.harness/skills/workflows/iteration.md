---
workflow_id: B
name: iteration
description: "Iterate on existing product features through change impact analysis, data diagnosis, and PRD updates"
default_mode: standard
---

# Workflow B: Existing Product Feature Iteration

> Shared pipeline conventions (mode selection, Exploration Gate, LOOP cycle, PRD quality gates, confidence propagation, handoff batch rules): see .harness/rules/pm-pipeline.md

> Applicable scenario: Existing product needs to add features/change requirements/optimize experience
> Core mode: Change impact analysis → LOOP validation → Engineering handoff

## Boundary with optimization (trigger condition decision tree)

```
Have clear change requirements (user feedback/business needs/missing features)?
├── Yes → iteration (change-driven)
│   Characteristics: Know what to change, need to assess impact + design change solution
└── No → Have data but no clear solution?
    ├── Yes → optimization (data-driven)
    │   Characteristics: Have data identifying problems, but don't know how to change, need data diagnosis + solution exploration
    └── No → Need strategic-level adjustment?
        └── Yes → pivot (strategic adjustment)
```

| Dimension | iteration | optimization |
|------|-----------|--------------|
| Trigger | Clear change requirement | Data-identified problem |
| Starting point | Change impact analysis | Data diagnosis |
| Design | Change module PRD update | Optimization solution PRD + validation |
| LOOP | Data diagnosis→solution design | Solution design→validation |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm iteration scope
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 3: Change Impact Analysis        │
│                                         │
│  - prd-orchestrator (requirement        │
│    analysis + change)                   │
│  - change-impact-analysis               │
│    (Change impact: affected modules +   │
│     risk + version_updates)             │
│                                         │
│  ★ Hard gate check:                     │
│  - Is change scope clear?               │
│  - Is impact assessment complete?       │
│  - Has user confirmed the change?       │
└────────┬────────────────────────────────┘
         │ Pass
         ▼
┌─────────────────────────────────────────┐
│              LOOP Validation            │
│  ┌─────────────────────────────────┐    │
│  │ Module 5: Data Diagnosis        │    │
│  │   (RESEARCH)                    │    │
│  │  - analysis-orchestrator        │    │
│  │    (Data analysis: anomalies+   │    │
│  │     funnel+retention)           │    │
│  │  - decision-orchestrator        │    │
│  │    (Decision loop: DACE+culture)│    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ Module 3: Solution Design       │    │
│  │   (RESEARCH)                    │    │
│  │  - prd-orchestrator             │    │
│  │    (PRD update for changed      │    │
│  │     modules only)               │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ VALIDATE                        │    │
│  │  - Post-change PRD quality gate │    │
│  │  - Data support sufficiency     │    │
│  │  - Human approval               │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail → back to RESEARCH ─┘
│                                          │
│  Iteration limit: 3 times (iteration type)│
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Iteration Decision            │
│                                         │
│  - iteration-orchestrator               │
│    (Backlog optimization + iteration    │
│     retrospective)                      │
│  - If release needed → enter launch     │
│    workflow                             │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive + update FEATURES.md
│                 │  + Output docs/handoff/pm-to-engineering.md (changed parts handoff to engineering)
└─────────────────┘
```

### Handoff batch rules (iteration scenario)

Iteration uses `incremental` batch (full vs incremental batch fields: see pm-pipeline.md Handoff Batch Rules).

**Critical**: even though Module 3 Solution Design only updates the PRD for changed modules (line 73), the handoff's `ac_ids` envelope and `unchanged_acs` MUST include ALL valid ACs from the previous delivery. This ensures:
- Engineering's session-start can correctly identify unchanged vs added ACs
- If a previous handoff was never consumed, no ACs are lost

**Body format**: unchanged ACs use one-line summary + reference to prior handoff; added/modified ACs use full Given-When-Then.

## Key Checkpoints

- [ ] Change impact analysis complete? (Affected modules/risks/version updates)
- [ ] Data diagnosis has conclusions? (Based on data analysis, not gut feeling)
- [ ] Post-change PRD passed quality gate?
- [ ] Human approved? (Solution selection/priority)

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Change scope unclear | Stop and ask user, clarify boundaries |
| Insufficient data | Supplement data analysis, don't iterate by feel |

## Next Steps

- Change needs release → enter **launch** workflow
- Change involves strategic adjustment → enter **pivot** workflow
- Change needs data-driven optimization → enter **optimization** workflow
