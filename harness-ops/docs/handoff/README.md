# Handoff Document Directory

Transfer complete `packages/<handoff_id>/` directories, not standalone Markdown files. Consumers validate the manifest, hashes, target, status, freshness, and stable-ID parity before use, then write a receipt.

> This directory stores handoff documents between harness-ops and other members of the harness family.
> Handoff protocol: upstream framework produces document → human feeds it to downstream framework → downstream framework consumes and executes.

## Handoff Document List

### Received handoff documents (from upstream)

| Document | Source | Purpose |
|------|------|------|
| `solo-to-ops.md` | harness-solo | Engineering deliverables, including image tag + environment variable list + database migration scripts + rollback plan |

### Produced handoff documents (sent to downstream)

| Document | Target | Purpose |
|------|------|------|
| `ops-to-pm.md` | harness-pm | SLA report + post-mortem + ops recommendations to business |

## Templates

| Template | Purpose |
|------|------|
| `templates/handoff-template.md` | Generic handoff template |
| `templates/ops-to-pm-template.md` | Dedicated template for ops feedback to product |

> Inbound templates (solo-to-ops) are provided by the source framework harness-solo and are not stored in this framework.

## Usage

1. Producer generates a current pointer and self-contained package from the template.
2. Transfer the complete package directory to the consumer's `docs/handoff/packages/`.
3. Consumer validates and receipts the package before deployment use.

## Naming Convention

- Filename is fixed (no date): `<source>-to-<target>.md`
- Downstream only looks at the latest state; historical versions are not retained
- For historical tracing, check git log

## Versioning

- The fixed `<source>-to-<target>.md` file is the current pointer and contains one latest contract.
- Before replacement, archive the previous contract as `archive/<handoff_id>.md`.
- Every contract uses the template frontmatter envelope and records `supersedes`.
- Optional consumer acknowledgements belong in `receipts/`; consumers never edit producer contracts.

## Write Access

Contract documents follow one-way write permission isolation (per ARCHITECTURE.md §4.3). Only the source framework may write/modify a contract document; consumers read-only. Templates are scaffolds and do not participate in cross-framework flow until instantiated.
