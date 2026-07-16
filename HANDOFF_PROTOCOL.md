# Handoff Protocol

> **Scope**: harness-all is a **framework collection**. This protocol defines how independent frameworks exchange contracts. Today's handoff types: `pm-to-engineering.md` + `engineering-to-pm.md`. When extension frameworks (data / qa / security) join the family, new handoff types (e.g., `engineering-to-qa.md`, `qa-to-engineering.md`) are added following the same envelope schema — no protocol changes needed.

## Current Pointer and History

- `docs/handoff/<source>-to-<target>.md` is the **current pointer**. It contains exactly one latest contract.
- Before replacing a current pointer, archive its unchanged content to `docs/handoff/archive/<handoff_id>.md`.
- Consumers read only the current pointer unless explicitly auditing history.
- Consumers never modify the producer's contract. Optional acknowledgements go to `docs/handoff/receipts/<handoff_id>-receipt.json`.

## Required Envelope

Every dedicated handoff begins with YAML frontmatter containing `schema_version`, `handoff_id`, `producer`, `consumer`, `created_at`, `source_revision`, `supersedes`, `status`, `ac_ids`, `batch`, and `artifacts`.

`handoff_id` is immutable and follows `<SOURCE>-<TARGET>-<YYYYMMDD>-<NNN>` (e.g., `PM-ENGINEERING-20260706-001`). `supersedes` points to the previous handoff ID or is `null`. When a handoff supersedes an already-consumed one, consumers use the envelope `batch` field as the primary change signal (with first-consumption guard: if no prior handoff was consumed, ALL ACs are treated as added). The `validate-handoff.ps1` script enforces supersedes freshness: when `supersedes` is non-null, its date segment must be strictly older than the current handoff's date segment (same-day incremental iterations are allowed, e.g., PM-ENGINEERING-20260706-002 may supersede PM-ENGINEERING-20260706-001).

### Batch Delivery (incremental handoffs)

When a producer delivers a subsequent handoff (e.g., PM iteration after MVP, Engineering reverse feedback after a feature delivery), the envelope MUST carry a `batch` field:

- `batch.type`: `full` (first-time delivery) or `incremental` (subsequent deliveries)
- `batch.added_acs` / `batch.modified_acs` / `batch.superseded_acs` / `batch.unchanged_acs`: AC ID lists partitioning the change scope
- `ac_ids` MUST always be the FULL SET of valid AC IDs (= `added_acs` + `modified_acs` + `unchanged_acs`), never just the changed subset — this prevents AC loss if a previous handoff was never consumed
- Superseded AC IDs do NOT appear in `ac_ids`
- Body uses a `Change` column to mark each AC as `[added]`, `[unchanged]`, `[modified]`, or `[superseded]` (with pointer to replacement)

#### Forward vs Reverse batch semantics

The `modified_acs` field has different semantics depending on whether the channel is forward delivery or reverse feedback:

| Channel type | Examples | `modified_acs` contains | `superseded_acs` contains |
|---|---|---|---|
| **Forward delivery** (producer owns ACs) | PM→Engineering | New replacement AC IDs (old IDs go to `superseded_acs`) | Old AC IDs being replaced/retired |
| **Reverse feedback** (producer does NOT own ACs) | Engineering→PM | Same AC IDs with changed feedback content (re-triage needed) | AC IDs whose feedback was withdrawn (AC itself may still be valid in PM's PRD) |

For both channel types: `ac_ids = added_acs + modified_acs + unchanged_acs`; superseded AC IDs never appear in `ac_ids`. The difference is only in what `modified_acs` and `superseded_acs` mean: forward = AC replacement, reverse = feedback content change/withdrawal.

**Worked examples**:

| Channel | First delivery | Incremental delivery | Consumer-side action |
|---------|----|----|----|
| PM → Engineering (`pm-to-engineering.md`) | `batch.type: full`, `batch.id: 1`, all ACs in `added_acs` | PM iteration after MVP: `batch.type: incremental`, `batch.id: 2`, new ACs in `added_acs`, retired ACs in `superseded_acs`, untouched ACs in `unchanged_acs` | Engineering session-start uses `batch` as primary signal; first-consumption guard treats ALL as `[added]` if no prior handoff was consumed |
| Engineering → PM (`engineering-to-pm.md`) | `batch.type: full`, `batch.id: 1`, all feedback ACs in `added_acs` | Subsequent Engineering reverse feedback after another feature delivery: `batch.type: incremental`, `batch.id: 2`, new feedback ACs in `added_acs`, withdrawn suggestions in `superseded_acs` (PM skips re-triage per prd-orchestrator phase 0 Branch B step 3 pre-filter), carried-forward undecided suggestions in `unchanged_acs` | PM session-start batch-aware detection; routes to Branch B; Branch B pre-filters `superseded_acs` items as "already-decided" |

> **Implemented Features reference**: When Engineering produces `engineering-to-pm.md`, the body's "Implemented Features" section is the data source for PM's FEATURES.md Cross-Framework Reconciliation (see `DOMAIN_BOUNDARIES.md`). The `batch` field partitions AC-level changes; the Implemented Features section reports feature-level status independently. Both are required for the consumer to detect drift correctly.

## Portable Package

The transferable unit is the complete `docs/handoff/packages/<handoff_id>/` directory, never a Markdown file by itself:

```text
<handoff_id>/
├── manifest.json
├── contract.md
└── artifacts/
    └── <consumer-required files>
```

All paths are package-relative. The manifest records the contract and every artifact's SHA-256 and byte size. Absolute paths, `..`, and references to producer-local files outside the package are invalid. The installed schema is `.harness/rules/handoff-manifest.schema.json`.

## Consumer Gate and Receipt

Before consumption, validate the schema version, ready status, target consumer, freshness/supersedes chain, envelope-manifest parity, path containment, hashes, and exact parity between envelope `ac_ids` and body AC IDs. Envelope `ac_ids` contains only cross-framework `AC-xxx` IDs; engineering-internal `BAC-xxx` / `IAC-xxx` do NOT appear in the envelope (per `acceptance-id-protocol.md`) — they are tracked in phase reports and `spec.md` instead. A failed delivery is not partially consumed; the last valid contract remains active.

After acceptance or rejection, write `docs/handoff/receipts/<handoff_id>-receipt.json`. Consumers never edit the producer contract.

## Publication Rules

1. Generate with `status: draft`.
2. Build and validate the portable package, required fields, stable AC references, and artifact hashes.
3. Obtain any domain-required human approval.
4. Archive the previous current pointer.
5. Write the new current pointer with `status: ready`.
6. Record the handoff ID in `memory/progress.md`.

Templates are schemas for new contracts, not history containers. Never append a second delivery body to a current-pointer file.
