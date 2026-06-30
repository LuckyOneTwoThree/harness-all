# Acceptance ID Protocol

Acceptance criteria are durable cross-framework identifiers, not list positions.

## Formats

- Product criterion: `AC-<feature>-<sequence>`, for example `AC-F01-001`.
- Page-scoped design criterion: `DAC-<page>-<sequence>`, for example `DAC-P03-002`.
- Cross-page design criterion: `DAC-GLOBAL-<sequence>`.

Each registry entry also records `source_handoff_id`, `scope`, `revision_introduced`, optional `related_ac_ids`, and lifecycle status.

## Rules

- The producer allocates an ID once. Consumers preserve it byte-for-byte.
- Gaps are valid. Never renumber, recycle, or derive a DAC number from an AC number.
- Changed meaning gets a new ID; the old ID becomes `superseded` with a pointer to the replacement.
- The same ID must have the same normalized text everywhere in one delivery.
- Envelope `ac_ids`, contract body, PRD JSON, and downstream specs must have exact set parity.
- Feature-local specs may contain global IDs, but may not restart numbering.

