# PM Pipeline

The shared routing contract and format conventions for PM workflows. Each workflow file declares its module sequence (ASCII flow diagram) and workflow-specific rules; this file defines the shared structures that all PM workflows follow.

## Mode Selection

All PM workflows support three execution modes. Workflows declare their `default_mode` in frontmatter; users can switch anytime by saying "switch to standard/skip mode".

| Mode | Stops | Feel | Suitable For |
|------|-------|------|--------------|
| `deep` | 3 stops (Exploration Gate + Dialog 2/3) + 5 👤 | New domain / unclear direction / needs exploration | First-time PM, unfamiliar market |
| `standard` | Module boundaries only | Balanced | Have ideas but need validation, routine iteration |
| `skip` | No exploration stops, auto-run | Fastest but risky | Domain expert with data already in `docs/discovery/`; safety fallback triggers if exploration data missing |

> Skip mode without prior exploration data auto-downgrades to standard (see AGENTS.md).

## Exploration Gate (Module 1 hard gate)

The Exploration Gate is a single-stop hard check that must pass before entering Module 2. Objective checks (must all pass):

- Target users clear? (Persona confidence ≥ 0.7)
- Core problem validated? (Problem statement human-confirmed)
- Market opportunity viable? (TAM/SOM has data)
- Business model feasible? (Value proposition clear)

⏸ Review with user (minimum question set):
1. Do these findings match your understanding?
2. Is there any important missing information?
3. Moving to strategy phase next, is the direction right?

⚠️ Forbidden: entering Module 2 directly without asking user.

## LOOP Validation Cycle

PM workflows use a LOOP validation cycle for RESEARCH-type modules (typically Module 3: Ideation & Design). The cycle:

```
┌─────────────────────────────────┐
│ RESEARCH (Module N)             │
│  - orchestrator/skill execution │
└──────────┬──────────────────────┘
           ▼
┌─────────────────────────────────┐
│ VALIDATE                        │
│  - PRD 4 quality gates          │
│  - Confidence check (≥0.7 auto) │
│  - Human approval               │
│  - Constitution compliance      │
└──────────┬──────────────────────┘
           │
           ├── Pass → exit LOOP ──→
           │
           └── Fail
                 │
                 ▼
┌─────────────────────────────────┐
│ REVISE                          │
│  - Supplement data / optimize   │
│  - Regenerate output            │
└──────────┬──────────────────────┘
           │
           └── Back to RESEARCH ──┘
```

Iteration limits (per workflow type):
- Research type (new-product): 5 times
- Iteration type: 3 times
- Exceed limit → request human intervention

## PRD 4 Quality Gates

All PRD-producing modules must pass these 4 gates before exit:

1. **Completeness** — all required PRD sections present
2. **Consistency** — no contradictions between sections
3. **Ambiguity elimination** — no vague terms without definitions
4. **Traceability** — every feature traces to an AC; every AC traces to a user need

## Confidence Propagation

| Confidence | Action |
|-----------|--------|
| ≥ 0.7 | Auto-propagate downstream |
| 0.3–0.7 | Mark `confidence: medium`, human confirmation required |
| < 0.3 | **Blocks automatic propagation**; force human decision |

## Human Decision Points (👤)

`👤` marks human decision points in workflow diagrams. Even if a workflow omits `👤`, the general rules in AGENTS.md still apply. Key human decisions include:

- Solution selection / priority / strategic direction
- PRD final approval
- Persona confirmation
- Opportunity brief approval
- Strategy direction confirmation

## Key Checkpoints Format

Each workflow lists its checkpoints as a checkbox list. Checkpoints must be verifiable (not subjective). Format:

```markdown
- [ ] <checkpoint description>? (<verification method>)
```

## Failure Handling Format

Each workflow declares its failure handling in a table:

| Failure point | Handling |
|--------|---------|
| <failure description> | <handling action> |

Common failure handling across all workflows:
- LOOP iteration exceeds limit → request human intervention, don't force
- Confidence < 0.3 → block, request human confirmation
- PRD quality gate not passed → revise and re-validate, no skipping

## Handoff Batch Rules

When a PM workflow produces a `pm-to-engineering.md` handoff, the batch delivery protocol applies. See `docs/handoff/templates/pm-to-engineering-template.md` for the full template.

| Batch type | When to use | ac_ids envelope |
|-----------|-------------|-----------------|
| `full` | First-time delivery | All AC IDs (engineering reads full list from prd.json) |
| `incremental` | Subsequent deliveries (iteration/pivot) | ALL valid AC IDs (unchanged + added + modified), never just the changed subset |

**Incremental batch fields**:
- `batch.id`: previous batch id + 1
- `batch.added_acs`: new AC IDs for new features
- `batch.modified_acs`: AC IDs whose semantics changed (these get NEW IDs; old IDs go to `superseded_acs`)
- `batch.superseded_acs`: old AC IDs replaced by new ones + any withdrawn ACs
- `batch.unchanged_acs`: all valid AC IDs from previous handoff NOT in added/modified/superseded

## Session Boundary

Every PM workflow starts with `session-start` (load context, confirm scope) and ends with `session-end` (archive + baseline + update FEATURES.md + output `docs/handoff/pm-to-engineering.md`).

## Relationship with Engineering Pipeline

When PM hands off to engineering, the engineering framework follows its own `engineering-pipeline.md` (4-phase: design-intake → frontend → backend → integration). PM does not control engineering's phase routing; PM only provides:
- `project_mode` / `exploration_mode` / `task_type` / `scope` (advisory routing)
- PRD + stable AC IDs
- Design asset paths
- Business context digest
