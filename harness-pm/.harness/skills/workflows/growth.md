---
workflow_id: C
name: growth
description: "Drive growth breakthroughs by diagnosing bottlenecks, designing experiments, and validating solutions"
default_mode: standard
---

# Workflow C: Growth Breakthrough

> Applicable scenario: Need to acquire users, improve retention, monetize
> Core mode: Growth diagnosis → LOOP experiment validation → full release

## Ownership Mode Gate

At workflow start, establish the operating mode:

- **Family mode** (user intentionally combines PM + Growth): PM diagnoses the product problem, defines goals/hypotheses/guardrails and approval criteria, then produces `docs/handoff/pm-to-growth.md`. harness-growth owns channel execution, content/SEO/user operations, live experiments, statistical analysis, and returns `growth-to-pm.md`. PM consumes that evidence and decides roadmap impact.
- **Standalone mode** (PM is the only harness): the local Module 5/6 skills remain available as a fallback. Mark generated growth execution output `mode: standalone-fallback`.

Do not silently execute both paths. The user chooses the mode when it is not already explicit.

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm growth goals
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Module 6: Growth Diagnosis              │
│                                         │
│  - growth-orchestrator                  │
│    (Growth model + strategy report +    │
│     GTM + operations manual)            │
│  - Identify growth bottlenecks (by      │
│    growth-orchestrator internal         │
│    conditional trigger scheduling):     │
│    ├── Acquisition issues →             │
│    │   acquisition-analysis             │
│    ├── Activation issues →              │
│    │   activation-orchestrator          │
│    ├── Retention issues →               │
│    │   retention-management             │
│    └── Monetization issues →            │
│        revenue-orchestrator             │
│      (If pricing issue identified →     │
│       backtrack to business-            │
│       orchestrator to adjust pricing)   │
│                                         │
│  Output: docs/growth/growth-strategy.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│              LOOP Validation            │
│  ┌─────────────────────────────────┐    │
│  │ Module 5: Experiment Design     │    │
│  │   (RESEARCH)                    │    │
│  │  - experiment-orchestrator      │    │
│  │    (Experiment design:          │    │
│  │     hypothesis+metrics+guardrails)│   │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ VALIDATE                        │    │
│  │  - Experiment design soundness  │    │
│  │  - Guardrail metric definition  │    │
│  │  - Human approval of experiment │    │
│  │    plan                         │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail → back to RESEARCH ─┘
│                                          │
│  Iteration limit: 3 times (growth type) │
│  Note: Experiment execution is run by   │
│  humans in real environment, AI only    │
│  handles design + result analysis       │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────────────────────────┐
│ Module 7: Experiment Result Analysis    │
│   & Release                             │
│                                         │
│  - Experiment result analysis           │
│    (experiment-orchestrator execution   │
│    phase + decision-orchestrator for    │
│    decision)                            │
│  - If experiment succeeds →             │
│    release-orchestrator (full release   │
│    of growth solution)                  │
│  - If experiment fails → back to growth │
│    diagnosis for replanning             │
│                                         │
│  Output: docs/metrics/experiment-report.md │
│    + docs/monitoring/monitoring-config.md │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ session-end     │  Archive + update FEATURES.md
│                 │  + Standalone: record results in memory/knowledge-base.md
│                 │  + Family: produce pm-to-growth.md before execution,
│                 │    then consume growth-to-pm.md for roadmap decisions
└─────────────────┘
```

## Key Checkpoints

- [ ] Growth bottleneck identified? (Which stage: acquisition/activation/retention/monetization)
- [ ] Growth strategy data-supported? (Not gut feeling)
- [ ] If pricing issue identified, backtracked to business-orchestrator?
- [ ] Experiment design sound? (Hypothesis+metrics+guardrails)
- [ ] Human approved experiment plan?
- [ ] Experiment results analyzed? (experiment-execution + decision-orchestrator)
- [ ] Ownership mode recorded? (family handoff or standalone fallback; never both)

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Growth bottleneck unclear | Supplement data analysis, locate bottleneck stage |
| Experiment design unsound | Revise hypothesis and metrics, redesign |
| Experiment failed | Analyze cause, back to growth diagnosis for replanning |
| Pricing issue identified | Backtrack to business-orchestrator's business-pricing to adjust pricing strategy |

## Next Steps

- Need enhanced monitoring after growth solution release → enter **launch** workflow's monitoring preparation
- Growth data needs deep analysis → enter **optimization** workflow
- Growth hits bottleneck needing diagnosis → enter **diagnosis** workflow
