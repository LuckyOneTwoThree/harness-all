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

## Allocation Granularity

IDs are allocated per **independently verifiable behavior unit**, not per file or per line. One ID must have exactly one evidence citation.

### AC-xxx (Product criterion)
- **Granularity**: one AC per product-verifiable user behavior (e.g., "user can create a todo", "user can filter by status").
- Allocated by PM in the PRD. Engineering consumes them; engineering never creates AC IDs.

### BAC-xxx (Backend criterion)
- **Granularity for `data-layer`**: one BAC per **entity behavior** — create, read, update, delete, relationship traversal, or constraint enforcement. Example: `BAC-F01-001` = "Todo entity: create with required fields"; `BAC-F01-002` = "Todo entity: user_id FK constraint enforced".
- **Granularity for `api-implementation`**: one BAC per **endpoint contract** — method + path + response shape + auth outcome. Example: `BAC-F01-100` = "POST /api/todos returns 201 with created todo; 401 without auth; 422 on validation failure".
- A single endpoint may satisfy multiple BACs if it has distinct auth/validation/error behaviors worth tracking separately.
- **Reverse coverage** (per Phase 2 inline verify-fast): every implemented endpoint/entity behavior must have a corresponding BAC. An endpoint without a BAC is a `missing-bac` finding.

### IAC-xxx (Integration criterion)
- **Granularity for `mock-to-real-switch`**: one IAC per **switch unit** — a config flip or endpoint group migration from mock to real. Example: `IAC-F01-001` = "Todo API switched from /api/mock/todos to /api/todos".
- **Granularity for `contract-verify`**: one IAC per **contract consistency check** — frontend ↔ backend shape match, or backend ↔ PRD contract match. Example: `IAC-F01-100` = "POST /api/todos request/response shape matches contract.json component TodoForm".
- **Granularity for `e2e-verification`**: one IAC per **AC-driven user flow** — a complete end-to-end path traced from an AC. Example: `IAC-F01-200` = "E2E flow: user creates todo → appears in list → persists on refresh (traces AC-F01-001)".
- IACs are the terminal acceptance layer: Phase 3 verify-full confirms every BAC has at least one IAC re-verifying it, and every AC has at least one IAC tracing it end-to-end.

## Multi-Producer Allocation (BAC & IAC)

When multiple skills in the same phase allocate IDs from the same sequence (BAC in Phase 2; IAC in Phase 3), producers MUST use non-overlapping numeric ranges to prevent collision. The range is scoped per `feature_id` (the `F##` segment of the ID), so different features have independent 001-999 spaces.

### BAC-xxx — Phase 2 (two producers)

| Producer | Range | Example |
|----------|-------|---------|
| `data-layer` | `001`–`099` | `BAC-F01-001` = "Todo entity: create with required fields" |
| `api-implementation` | `100`–`999` | `BAC-F01-100` = "POST /api/todos returns 201 with created todo; 401 without auth" |

If `data-layer` exceeds 99 entity behaviors for a single feature (rare), overflow into the `900`–`999` range reserved for data-layer overflow, and surface a 👤 warning that BAC density is high.

### IAC-xxx — Phase 3 (three producers)

| Producer | Range | Example |
|----------|-------|---------|
| `mock-to-real-switch` | `001`–`099` | `IAC-F01-001` = "Todo API switched from /api/mock/todos to /api/todos" |
| `contract-verify` | `100`–`199` | `IAC-F01-100` = "POST /api/todos request/response shape matches contract.json component TodoForm" |
| `e2e-verification` | `200`–`999` | `IAC-F01-200` = "E2E flow: user creates todo → appears in list → persists on refresh" |

If `mock-to-real-switch` or `contract-verify` exceeds its range (rare), overflow into the `800`–`999` reserved range and surface a 👤 warning.

### Allocation hygiene

- The first producer to enter a phase claims the lowest available ID in its range; subsequent producers in the same phase start from their own range floor, not from the last allocated ID.
- An ID once allocated is immutable — even if the behavior is later removed, the ID is retired, never reassigned.
- Cross-phase re-verification (e.g., Phase 3 re-verifying a Phase 2 BAC) does NOT allocate a new BAC — it produces an IAC that references the existing BAC.
- `spec.md` "Backend AC" and "Integration AC" sections MUST list the producing skill next to each ID so ownership is auditable (e.g., `BAC-F01-001 (data-layer)`, `IAC-F01-100 (contract-verify)`).
