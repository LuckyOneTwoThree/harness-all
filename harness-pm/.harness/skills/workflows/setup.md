---
workflow_id: G
name: setup
description: "Initialize a new harness-pm project by guiding users through filling in core configuration files"
default_mode: skip
---

# Workflow G: Project Initiation Guide

> Applicable scenario: New project using harness-pm for the first time, needs to initialize configuration files
> Core mode: Guide filling in constitution.md / SOUL.md / PRODUCT_STRATEGY.md / PRD.md

## Differences from Other Workflows

| Dimension | new-product | **setup** |
|------|-------------|----------|
| Goal | Product work | Initialize project configuration |
| Prerequisite | None | **install.sh executed** (setup.md itself lives in .harness/, so reaching this workflow proves install.sh ran) |
| LOOP | research→validate | **No LOOP (configuration-focused)** |
| Output | Product documents | **Configuration files fully filled in** |

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
│  - docs/strategy/PRODUCT_STRATEGY.md    │
│    exists?                              │
│  - docs/product/PRD.md exists?          │
│                                         │
│  ★ If any missing → prompt to re-run    │
│    install.sh or copy from              │
│    .harness/templates/ manually         │
└────────┬────────────────────────────────┘
         │ All present
         ▼
┌─────────────────┐
│ Fill in SOUL.md │  Persona + product preferences
│                 │  - Product type preferences (SaaS/e-commerce/tools)
│                 │  - Methodology preferences (JTBD/Kano/North Star)
│                 │  - Tool preferences (Figma/Notion/Mixpanel)
└────────┬────────┘
         ▼
┌─────────────────┐
│ Fill in         │  Project constitution
│ constitution.md │  - Derived from product characteristics (not copying generic rules)
│                 │  - Each clause verifiable
│                 │  - Example: PRD must pass 4 gates / key decisions require human approval
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Fill in PRODUCT_STRATEGY.md (skeleton)  │
│                                         │
│  - Product overview / background        │
│    motivation / target users            │
│  - Core value proposition               │
│  - Success metrics (quantifiable)       │
│  - Out of scope (boundaries)            │
│  - Milestones                           │
│                                         │
│  ★ Only fill in skeleton info known to  │
│    user                                 │
│  ★ Full output enriched and updated by  │
│    planning-orchestrator in new-product │
│    workflow                             │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Initialize PRD.md (skeleton)            │
│                                         │
│  - Create docs/product/PRD.md skeleton  │
│  - Mark "to be filled by design-prd     │
│    skill"                               │
│  - Don't write complete PRD at this     │
│    stage                                │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────┐
│ Validate        │  - All 4 files filled in?
│ configuration   │  - Constitution clauses verifiable?
│ completeness    │  - PRODUCT_STRATEGY metrics quantifiable?
│                 │  - PRD skeleton created?
└────────┬────────┘
         │ Pass
         ▼
┌─────────────────┐
│ session-end     │  Record initiation info to progress.md
│                 │  - Product name / type / constitution key points
│                 │  - Next step: enter new-product workflow
└─────────────────┘
```

## Key Checkpoints

- [ ] SOUL.md's product preferences filled?
- [ ] constitution.md clauses verifiable? (Not "product should be good", but "PRD must pass 4 gates")
- [ ] PRODUCT_STRATEGY.md success metrics quantifiable? (Not "users like it", but "DAU > 10000")
- [ ] PRD.md skeleton created?
- [ ] All 5 files (AGENTS.md, SOUL.md, constitution.md, PRODUCT_STRATEGY.md, PRD.md) saved?

## Failure Handling

| Failure point | Handling |
|--------|---------|
| Config files missing (partial install) | Prompt to re-run install.sh or copy from .harness/templates/ manually |
| Constitution clauses not verifiable | Help user rewrite as verifiable descriptions |
| PRODUCT_STRATEGY metrics not quantifiable | Help user rewrite as quantifiable descriptions |

## Division of Labor with install.sh

| Stage | Responsibility |
|------|------|
| install.sh | Copy template files to project directory (mechanical operation) |
| **setup workflow** | Guide user to fill in template content (intelligent guidance) |

install.sh only ensures "files in place", setup workflow ensures "content filled correctly".
