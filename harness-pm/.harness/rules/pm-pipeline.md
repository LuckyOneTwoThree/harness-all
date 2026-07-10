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

## PRD.md Write Ownership

`docs/product/PRD.md` is written by multiple skills. To prevent data loss from overlapping writes:

| Skill | Write Mode | Owned Sections |
|------|-----------|---------------|
| design-prd | Generate Mode: full overwrite; Import Mode: rewrite 9 core sections only | 9 core PRD sections (Problem Statement → Open Issues) |
| change-impact-analysis | Append-only (replace own section) | "Change Impact Analysis" |
| ideation-workshop | Append-only (replace own section) | "Creative Solutions" |
| validation-assumption-map | Append-only (replace own section) | "Assumption Map" |
| validation-mvp | Append-only (replace own section) | "MVP Plan" |
| validation-usability | Append-only (replace own section) | "Usability Testing" |

Rules:
- Each section is owned by exactly one skill; no cross-writing
- design-prd's `prd.json` projection covers only the 9 core sections; append-only sections are Markdown-only
- If a downstream consumer needs an append-only section's data, that skill's own JSON output is the source of truth

## Draft PRD Status

When design-prd runs with `draft_mode=true` (triggered by quick-prd workflow):
- PRD.md header includes `> **Status**: DRAFT`
- prd.json includes `metadata.status: "draft"`
- Quality gates run in best-effort mode (Gate 1-3) or skipped (Gate 4)
- Draft PRD can coexist with append-only sections from other skills
- Draft PRD is usable for coding/handoff but NOT production-ready
- **Upgrade path**: draft → validated via new-product or iteration workflow (design-prd Import Mode reads draft, applies full quality gates with `draft_mode=false`)
- **Production launch block**: launch workflow must verify PRD.md does NOT contain "Status: DRAFT" before proceeding; if draft found, require upgrade first

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

## Orchestrator Handoff Chain

The 17 orchestrators form a handoff chain that is **cyclic by design** (product work is a loop, not a one-way pipeline). The primary handoff path:

```
user-research-orchestrator → market-orchestrator
        ↓
business-orchestrator → planning-orchestrator
        ↓
prd-orchestrator → metrics-orchestrator
        ↓
monitoring-orchestrator → diagnosis-orchestrator → iteration-orchestrator
        ↓ (loops back to prd-orchestrator for next iteration)
release-orchestrator → monitoring-orchestrator (post-release tracking)

Side chains:
- analysis-orchestrator → decision-orchestrator → prd-orchestrator (data-driven decisions loop back to PRD)
- experiment-orchestrator → decision-orchestrator (experiment results feed decisions)
- growth-orchestrator (self-contained 8-phase pipeline; side exits to iteration-orchestrator)
- activation-orchestrator → retention-management (activation completion routes to retention; growth-orchestrator phase-4 also dispatches retention-management — both paths are valid and idempotent)
- revenue-orchestrator → growth-orchestrator (revenue optimization returns to growth diagnosis)
- validation-orchestrator → prd-orchestrator (validation conclusions update PRD)
```

Key properties:
- **Cyclic is intentional**: monitoring → diagnosis → iteration → prd → metrics → monitoring is the product iteration loop; it is NOT a circular dependency bug
- **Multiple entry points**: any orchestrator can be entered standalone (e.g., health-check workflow enters diagnosis-orchestrator in snapshot_mode)
- **Idempotent dispatch**: when two orchestrators can reach the same pipeline skill (e.g., retention-management via activation-orchestrator or growth-orchestrator), both paths produce the same output; the skill's own inputs determine behavior, not the caller
- **Downstream connection declarations**: each orchestrator's SKILL.md declares its `downstream_connection` (primary + alternatives + special_cases); the chain above is the aggregate of those declarations
