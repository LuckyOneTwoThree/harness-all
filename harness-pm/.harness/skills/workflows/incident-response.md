---
workflow_id: I
name: incident-response
description: "Respond to P0-level incidents through rapid detection, emergency fix, and post-incident retrospective"
default_mode: skip
---

# Workflow I: Incident Response

> Shared pipeline conventions (mode selection, Exploration Gate, LOOP cycle, PRD quality gates, confidence propagation, handoff batch rules): see .harness/rules/pm-pipeline.md

> Applicable scenario: P0-level online incidents, major user complaints, security vulnerabilities and other emergencies
> Core mode: Detection → diagnosis → fix release → retrospective (no LOOP, rapid response)

## Differences from Other Workflows

| Dimension | diagnosis | launch | **incident-response** |
|------|-----------|--------|----------------------|
| Urgency | Low (reactive diagnosis) | Medium (planned release) | **High (emergency response)** |
| Goal | Diagnose problem | Acceptance & release | **Quick stop bleeding + retrospective** |
| LOOP | None | None | **None (fast track)** |
| Human intervention | Report review | Release approval | **Human command throughout** |

## Trigger Conditions

- P0-level online incident (core feature unavailable)
- Major security vulnerability
- Large-scale user complaints
- Data breach incident
- Regulatory compliance issues

## Process

```
┌─────────────────┐
│ session-start   │  Emergency load, confirm incident level
│                 │  ★ Human command throughout, AI assists
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Incident Detection &          │
│ Attribution (fast track)                │
│                                         │
│  - monitoring-orchestrator              │
│    (Monitoring alerts + anomaly         │
│     attribution, quick location)        │
│  - diagnosis-orchestrator               │
│    (Health diagnosis + competitor       │
│     check, phase-1/2 only)              │
│                                         │
│  ★ Fast track: skip full diagnosis,     │
│    only do root cause location          │
│  Output: docs/monitoring/diagnosis-report.md │
└────────┬────────────────────────────────┘
         │ Root cause located
         ▼
┌─────────────────────────────────────────┐
│ Human Decision Point (★ must approve)   │
│                                         │
│ - Fix solution selection (hotfix/       │
│   rollback/degradation)                 │
│ - Impact scope assessment confirmation  │
│ - Communication strategy approval       │
│   (internal/external/regulatory)        │
└────────┬────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Emergency Fix Release         │
│                                         │
│  - release-orchestrator                 │
│    (Emergency release channel)          │
│    ├── quality-acceptance (quick        │
│    │   acceptance)                      │
│    ├── release-auto-checklist (emergency│
│    │   check)                           │
│    ├── release-gradual (direct full or  │
│    │   quick gradual)                   │
│    └── release-notes (incident fix      │
│        notes)                           │
│                                         │
│  Output: docs/monitoring/release-notes.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Retrospective (post-incident) │
│                                         │
│  - iteration-orchestrator               │
│    (Iteration retrospective: root       │
│     cause + improvement measures +      │
│     prevention plan)                    │
│  - monitoring-orchestrator              │
│    (Supplement monitoring, prevent      │
│     recurrence)                         │
│                                         │
│  Output: docs/monitoring/monitoring-config.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive incident report
│                 │  + Update FEATURES.md
│                 │  + Record to memory/knowledge-base.md
│                 │  + Output incident retrospective document
└─────────────────┘
```

## Key Checkpoints

- [ ] Incident root cause located? (Not surface symptoms)
- [ ] Fix solution human-approved?
- [ ] Impact scope assessed?
- [ ] Communication strategy executed? (Internal/external)
- [ ] Retrospective complete? (Root cause + improvement + prevention)
- [ ] Monitoring supplemented? (Prevent recurrence)

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Root cause cannot be quickly located | Rollback to stop bleeding first, deep diagnosis afterward |
| Fix solution has risk | Prioritize rollback, then plan fix solution |
| Monitoring missing | Emergency supplement monitoring, no blind operation |

## Safety Principles

1. **Human command throughout**: AI assists analysis, decision power with humans
2. **Stop bleeding first**: Restore service first, then pursue perfect fix
3. **Communication required**: Incidents must be communicated timely, no hiding
4. **Retrospective required**: Every incident must have retrospective, no repeating mistakes

## Next Steps

- Need deep optimization after incident fix → enter **optimization** workflow
- Incident exposes strategic issues → enter **pivot** workflow
- Incident involves feature changes → enter **iteration** workflow
