---
workflow_id: A
name: setup
description: "Initialize a new harness-growth project by guiding users through filling in core configuration files"
default_mode: skip
---

# Workflow: Project Onboarding

> Applicable scenario: A new project using harness-growth for the first time, needs to initialize config files
> Core mode: Guide the user in filling out constitution.md / SOUL.md / GROWTH_STRATEGY.md
> Note: GROWTH_STRATEGY.md only fills in the skeleton info known to the user at this stage; the full strategy is enriched by the growth-strategy-workflow.

## Differences from Other Workflows

| Dimension | growth-strategy-workflow | **setup** |
|------|-------------|----------|
| Goal | Formulate complete growth strategy | Initialize project config |
| Prerequisite | setup completed | **install.sh executed** (setup.md itself lives in .harness/, so reaching this workflow proves install.sh ran) |
| LOOP | experiment | **No LOOP (configuration-focused)** |
| Output | Complete NSM/KPI Tree/AARRR/Growth Loops | **Configuration files filled with skeleton** |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm first-time use
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Sanity-check config files are in place  │
│                                         │
│  - AGENTS.md / SOUL.md / constitution.md│
│    exist in project root?               │
│  - docs/operations/GROWTH_STRATEGY.md   │
│    exists?                              │
│                                         │
│  ★ If any missing → prompt to re-run    │
│    install.sh or copy from              │
│    .harness/templates/ manually         │
└────────┬────────────────────────────────┘
         │ All present
         ▼
┌─────────────────────────────────────────┐
│ Soft-check upstream handoff (non-blocking)│
│                                         │
│  - docs/handoff/solo-to-growth.md       │
│    exists?                              │
│                                         │
│  ★ If exists → read it for product /    │
│    metric context to prefill growth     │
│    goals and target users               │
│  ★ If missing → note "no upstream       │
│    handoff; user will provide info      │
│    manually" and continue (non-blocking)│
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ Fill in         │  Persona + growth preferences
│ SOUL.md         │  - Content type preferences (blog / docs / social)
│                 │  - Channel preferences (SEO / community / paid)
│                 │  - Experiment methodology preferences (A/B / cohort)
│                 │  - Tool preferences (GA / Mixpanel / Ahrefs)
└────────┬────────┘
         ▼
┌─────────────────┐
│ Fill in         │  Project constitution
│ constitution.md │  - Derived from growth characteristics (not copying generic rules)
│                 │  - Each clause verifiable
│                 │  - Example: every experiment must have hypothesis + metric / no black-hat SEO / no PII in experiment data
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Fill in GROWTH_STRATEGY.md (skeleton)   │
│                                         │
│  - Project overview (one sentence)      │
│  - Background & motivation              │
│  - Growth goals (current → target,      │
│    time window)                         │
│  - Target users (role × scenario ×      │
│    need × channel)                      │
│  - Out of scope (boundaries)            │
│                                         │
│  ★ Only fill in skeleton info known to  │
│    user                                 │
│  ★ Full NSM / KPI Tree / AARRR /        │
│    Growth Loops are enriched by         │
│    growth-strategy-workflow             │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ Validate        │  - All 4 files filled in?
│ configuration   │  - Constitution clauses verifiable?
│ completeness    │  - GROWTH_STRATEGY goals quantifiable?
│                 │  - Upstream handoff noted (if any)?
└────────┬────────┘
         │ Pass
         ▼
┌─────────────────┐
│ session-end     │  Record onboarding info to progress.md
│                 │  - Product overview / growth goals / key constitution points
│                 │  - Next step: enter growth-strategy-workflow for full strategy
└─────────────────┘
```

## Key Checkpoints

- [ ] SOUL.md's growth preferences filled?
- [ ] constitution.md clauses verifiable? (Not "growth should be good", but "every experiment must label hypothesis + primary metric")
- [ ] GROWTH_STRATEGY.md growth goals quantifiable? (Not "increase users", but "monthly organic traffic +20% in 3 months")
- [ ] Upstream handoff (solo-to-growth.md) noted if present?
- [ ] All 5 files (AGENTS.md, SOUL.md, constitution.md, GROWTH_STRATEGY.md, progress.md) saved?

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Config files missing (partial install) | Prompt to re-run install.sh or copy from .harness/templates/ manually |
| Constitution clauses not verifiable | Help user rewrite as verifiable descriptions |
| GROWTH_STRATEGY goals not quantifiable | Help user rewrite as quantifiable descriptions (current baseline → target → time window) |
| No upstream handoff | Non-blocking; prompt user to provide product/metric info manually, or suggest running harness-solo first |

## Division of Labor with install.sh

| Stage | Responsibility |
|------|------|
| install.sh | Copy template files to project directory (mechanical operation) |
| **setup workflow** | Guide user to fill in template content (intelligent guidance) |

install.sh only ensures "files in place"; setup workflow ensures "content filled correctly".
