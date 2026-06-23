---
workflow_id: E
name: launch
default_mode: skip
---

# Workflow E: Acceptance & Release

> Applicable scenario: Product feature acceptance, version release, gradual rollout
> Core mode: Pre-release check (hard gate) → acceptance → release notes → handoff

## Differences from Other Workflows

| Dimension | new-product | **launch** |
|------|-------------|------------|
| Goal | Product design | Acceptance & release |
| Prerequisite | Exploration & discovery | **Product design complete (PRD approved)** |
| LOOP | research→validate | **No LOOP (validation-focused)** |
| Output | PRD + design spec | **Acceptance report + release notes + handoff document** |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm release scope
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Pre-release check (★ hard gate)         │
│                                         │
│  - All PRD features accepted?           │
│  - PRODUCT_STRATEGY success metrics met?│
│  - Tracking plan implemented?           │
│  - Security compliance check passed?    │
│  - Constitution compliant?              │
│  - Engineering feedback (solo-to-pm.md) │
│    confirmed?                           │
│                                         │
│  ★ Any item not met → no release        │
│                                         │
│  ★ Tracking not implemented → call      │
│    metrics-orchestrator to supplement   │
│    tracking plan, then re-check         │
└────────┬────────────────────────────────┘
         │ Pass
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Acceptance & Release (via     │
│   release-orchestrator)                 │
│                                         │
│  - release-orchestrator                 │
│    (Release orchestrator, schedules the │
│     following sub-skills)               │
│    ├── quality-acceptance               │
│    │   (Quality acceptance: feature+    │
│    │    performance+security+experience)│
│    ├── release-auto-checklist           │
│    │   (Release checklist)              │
│    ├── release-gradual                  │
│    │   (Gradual rollout plan)           │
│    └── release-notes                    │
│        (Release notes)                  │
│                                         │
│  Output: docs/monitoring/release-notes.md │
│        + docs/monitoring/monitoring-config.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive + update FEATURES.md (status → launched)
│                 │  + Record release info to progress.md
│                 │  + Output docs/handoff/pm-to-solo.md (monitoring config handoff)
└─────────────────┘
```

## Key Checkpoints

- [ ] All PRD features accepted? (Check AC item by item)
- [ ] Success metrics met? (Show data)
- [ ] Tracking plan implemented? (Events collectible)
- [ ] Security compliance check passed?
- [ ] Release notes written? (Added/Fixed/Changed)
- [ ] Gradual rollout plan made?
- [ ] Monitoring alerts configured?

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Feature not accepted | No release, complete acceptance first |
| Success metrics not met | Analyze cause, decide whether to release |
| Security compliance not passed | Fix before release, no ignoring |
| Tracking not implemented | Call metrics-orchestrator to supplement tracking plan, then re-check |

## Safety Principles

1. **No auto-release**: Release requires explicit user confirmation
2. **Gradual first**: Gradual rollout before full release, reduce risk
3. **Monitoring required**: Monitoring alerts must be configured before release
4. **Rollback ready**: Rollback plan must be prepared before release

## Next Steps

- Need growth after release → enter **growth** workflow
- Data anomaly after release → enter **diagnosis** workflow
- Need data-driven optimization after release → enter **optimization** workflow
- P0 incident after release → enter **incident-response** workflow
