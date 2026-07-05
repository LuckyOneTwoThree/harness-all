# Acceptance ID Protocol

Acceptance criteria are durable cross-framework identifiers, not list positions.

## Formats

- **Product criterion**: `AC-<feature>-<sequence>`, for example `AC-F01-001`. Produced by PM; consumed and verified by engineering across phases.
- **Backend criterion**: `BAC-<feature>-<sequence>`, for example `BAC-F01-001`. Produced and consumed by engineering Phase 2 (backend: api-implementation / data-layer); verified by Phase 3 (integration).
- **Integration criterion**: `IAC-<feature>-<sequence>`, for example `IAC-F01-001`. Produced and consumed by engineering Phase 3 (integration: mock-to-real-switch / contract-verify / e2e-verification); verifies frontend ↔ backend contract consistency and end-to-end user flows.

> **Note on `DAC-xxx`** (design AC): **retired in v3.0.0**. The legacy design-AC concept was dissolved — design constraints now flow into `contract.json` + `tokens.json` produced by Phase 0 (design-intake). Existing references to `DAC-xxx` in legacy documents should be treated as migrated to either a `contract.json` component constraint or an `AC-xxx` (when the constraint is product-verifiable).

Each AC/BAC/IAC ID is tracked across `spec.md`, `evidence.md`, and handoff envelopes (no separate registry file). The combined record across these files captures `source_handoff_id`, `scope`, `revision_introduced`, optional `related_ac_ids`, and lifecycle status.

## Rules

- The producer allocates an ID once. Consumers preserve it byte-for-byte.
- Gaps are valid. Never renumber, recycle, or derive a BAC/IAC number from an AC number.
- Changed meaning gets a new ID; the old ID becomes `superseded` with a pointer to the replacement.
- **Superseded AC expression in new handoffs**: when a producer delivers a new handoff that supersedes a previous one, superseded AC IDs do NOT appear in the envelope `ac_ids` list (only their replacement IDs do). The body uses a `Change` column to mark the superseded AC as `[superseded]` with a pointer to the replacement ID (e.g., "superseded by AC-F03-002"). This ensures `validate-handoff.ps1`'s envelope/body ID parity check passes (superseded IDs are excluded from both sides) while preserving audit traceability in the body.
- The same ID must have the same normalized text everywhere in one delivery.
- Envelope `ac_ids`, contract body, PRD JSON, and downstream specs must have exact set parity.
- Feature-local specs may contain global IDs, but may not restart numbering.
- BAC/IAC IDs follow the same supersede rules: changed meaning gets a new ID; the old ID becomes `superseded` with a pointer to the replacement. BAC/IAC IDs do NOT appear in cross-framework handoff `ac_ids` (they are engineering-internal); they appear in phase reports and `spec.md` instead.

## Production / Verification Matrix

| ID type | Produced by | Verified by | Tracked in |
|---------|------------|-------------|------------|
| `AC-xxx` | PM | engineering Phase 1/2/3 (per scope) | `spec.md` + `evidence.md` + handoff envelope `ac_ids` |
| `BAC-xxx` | engineering Phase 2 (api-implementation / data-layer) | engineering Phase 3 (contract-verify / e2e-verification) | `spec.md` + `evidence.md` + phase-2-backend-report.md |
| `IAC-xxx` | engineering Phase 3 (mock-to-real-switch / contract-verify / e2e-verification) | engineering Phase 3 (verify-full) | `spec.md` + `evidence.md` + phase-3-integration-report.md |
