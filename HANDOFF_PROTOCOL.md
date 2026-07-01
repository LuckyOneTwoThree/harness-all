# Handoff Protocol

## Current Pointer and History

- `docs/handoff/<source>-to-<target>.md` is the **current pointer**. It contains exactly one latest contract.
- Before replacing a current pointer, archive its unchanged content to `docs/handoff/archive/<handoff_id>.md`.
- Consumers read only the current pointer unless explicitly auditing history.
- Consumers never modify the producer's contract. Optional acknowledgements go to `docs/handoff/receipts/<handoff_id>-receipt.json`.

## Required Envelope

Every dedicated handoff begins with YAML frontmatter containing `schema_version`, `handoff_id`, `producer`, `consumer`, `created_at`, `source_revision`, `supersedes`, `status`, `ac_ids`, and `artifacts`. Frameworks that distinguish family-produced contracts from degraded output (e.g., harness-solo) additionally carry a `mode` field (`family` | `standalone-fallback`); generic inbound templates remain mode-free. For solo-produced handoffs, `mode` is mandatory and validated by `validate-handoff.ps1`; other producers may omit it.

`handoff_id` is immutable and follows `<SOURCE>-<TARGET>-<YYYYMMDD>-<NNN>`. `supersedes` points to the previous handoff ID or is `null`. When a handoff supersedes an already-consumed one, consumers compare the new envelope `ac_ids` against previously implemented ACs to flag rework (removed ACs) and new scope (added ACs). The `validate-handoff.ps1` script enforces supersedes freshness: when `supersedes` is non-null, its date segment must be older than the current handoff's date segment.

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

Before consumption, validate the schema version, ready status, target consumer, freshness/supersedes chain, envelope-manifest parity, path containment, hashes, and exact parity between envelope `ac_ids` and body AC/DAC IDs. A failed delivery is not partially consumed; the last valid contract remains active.

After acceptance or rejection, write `docs/handoff/receipts/<handoff_id>-receipt.json`. Consumers never edit the producer contract.

## Publication Rules

1. Generate with `status: draft`.
2. Build and validate the portable package, required fields, stable AC references, and artifact hashes.
3. Obtain any domain-required human approval.
4. Archive the previous current pointer.
5. Write the new current pointer with `status: ready`.
6. Record the handoff ID in `memory/progress.md`.

Templates are schemas for new contracts, not history containers. Never append a second delivery body to a current-pointer file.
