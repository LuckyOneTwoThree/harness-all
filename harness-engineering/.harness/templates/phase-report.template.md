---
# All frontmatter keys are required (machine-checked). Empty placeholders block phase transition.
phase: <N>                       # required: true — 0 | 1 | 2 | 3
phase_name: <phase-name>         # required: true — design-intake | frontend | backend | integration
task_id: <task-id>               # required: true
report_path: <loops/specs/<task>/phase-N-<phase-name>-report.md>  # required: true
created_at: <YYYY-MM-DDTHH:MM:SS±HH:MM>  # required: true — ISO-8601
---

# Phase <N>: <Phase Name> Report

> Written by the phase's verify step at the CHECKPOINT point of the 4-phase engineering pipeline.
> File path: `loops/specs/<task>/phase-N-<phase-name>-report.md` (e.g., `phase-1-frontend-report.md`).
> A confirmed report is the only valid transition between phases; verbal confirmation is insufficient.
>
> Sections marked `<!-- required: true -->` are mandatory and machine-checked. Omitting or leaving a
> placeholder unfilled blocks the phase transition. Fill only the phase-specific sub-section matching
> this phase; delete the other three or write `n/a — not <phase> phase`.

## Outcome summary
<!-- required: true -->
<1-2 sentence summary of what was delivered in this phase>

## Acceptance IDs produced
<!-- required: true -->
<!-- Phase 0: none unless frontend ACs apply; Phase 1: AC-xxx if frontend ACs; Phase 2: BAC-xxx; Phase 3: IAC-xxx. Write "none" if no IDs were produced. -->
- <AC-xxx | BAC-xxx | IAC-xxx>: <one-line description>

## Artifacts produced
<!-- required: true -->
<!-- e.g., contract.json, tokens.json, component-bindings.json, migration files, source files -->
- <artifact path 1>
- <artifact path 2>

## Evidence citations
<!-- required: true -->
<!-- For each acceptance ID above, cite the evidence.md line-range or block heading that proves it. If no IDs were produced, write "none — no acceptance IDs in this phase". -->
- <AC-xxx | BAC-xxx | IAC-xxx> → evidence.md:<line-range or `## Phase N` block heading>

## Contract deviations
<!-- required: true -->
<!-- Per the Contract Deviation Protocol in rules/engineering-pipeline.md. Deviations are recorded in contract.json.deviations[] as the single source of truth. Here, list the DEV-<task>-<N> IDs recorded during this phase (or "None") and surface concrete impacts for downstream phases in `## Downstream notes`. Silent deviation is prohibited. -->
- None
- <!-- or --> DEV-<task>-<N>: <affected contract field> — severity: <Minor|Major> — <reason> (recorded in contract.json.deviations[])

## Downstream notes
<!-- required: true -->
<!-- Anything the next phase needs to know. Examples: "component-bindings.json has mock_api paths at /api/mock/*"; "migration down-script tested on scratch DB"; "DEV-<task>-N changed <field>, Phase 2 must update <handler>". -->
- <note for next phase>

## Open risks / pending items
<!-- required: true -->
<!-- Anything not fully resolved. Examples: "AC traceability incomplete in degraded mode"; "👤 human review needed for color contrast". Write "None" if all clear. -->
- <risk or pending item>

---

## Phase-specific mandatory sub-sections

### Phase 0 — design-intake
<!-- required: true (when phase == 0) -->
- token_source path: <path/to/tokens.source>
- token_source sha256: <sha256-hex>
- entities count: <N>
- degraded-mode waiver: <waiver ID from risk-model.md, or "none">

### Phase 1 — frontend
<!-- required: true (when phase == 1) -->
- component IDs: [CMP-xxx, CMP-yyy]
- component-bindings.json path: <loops/specs/<task>/component-bindings.json>
- mock_api paths: [/api/mock/<route>, ...]

### Phase 2 — backend
<!-- required: true (when phase == 2) -->
- BAC IDs with endpoint paths:
  - <BAC-xxx> → <HTTP METHOD> <endpoint path>
  - <BAC-yyy> → <HTTP METHOD> <endpoint path>
- migration files:
  - up: <path> — verified on scratch DB: yes | no
  - down: <path> — verified on scratch DB: yes | no

### Phase 3 — integration
<!-- required: true (when phase == 3) -->
- IAC IDs list: [IAC-xxx, IAC-yyy]
- AC/BAC/IAC reconciliation result: <all-reconciled | mismatches: [list]>
- mock→real switch status: <success | partial | failed — details>
