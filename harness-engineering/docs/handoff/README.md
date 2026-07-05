# Handoff Document Directory

Transfer complete `packages/<handoff_id>/` directories, not standalone Markdown files. Consumers validate the manifest, hashes, target, status, freshness, and stable-ID parity before use, then write a receipt.

This directory stores handoff documents between harness family frameworks.

## Handoff Protocol

Each handoff document follows a unified format so that downstream framework Agents can quickly understand upstream outputs.

## Document Naming Convention

```
<source-framework>-to-<target-framework>.md
```

For example:
- `pm-to-engineering.md` — harness-pm hands off to harness-engineering (Product → Engineering)
- `engineering-to-pm.md` — harness-engineering hands off to harness-pm (Engineering → Product)

## Usage

1. Producer generates a current pointer and self-contained package from the template.
2. Transfer the complete package directory to the consumer's `docs/handoff/packages/`.
3. Consumer validates and receipts the package before using its content.

## Templates

- `templates/handoff-template.md` — Generic handoff template
- `templates/engineering-to-pm-template.md` — harness-engineering → harness-pm dedicated template (engineering feedback: implementation status / blockers, on demand)

Copy and fill in based on actual conditions.

## Versioning

- The fixed `<source>-to-<target>.md` file is the current pointer and contains one latest contract.
- Before replacement, archive the previous contract as `archive/<handoff_id>.md`.
- Every contract uses the template frontmatter envelope and records `supersedes`.
- Optional consumer acknowledgements belong in `receipts/`; consumers never edit producer contracts.

## Write Access

Contract documents follow one-way write permission isolation (per the family-level ARCHITECTURE.md §4.3, in the harness-all repo root). Only the source framework may write/modify a contract document; consumers read-only. Templates are scaffolds and do not participate in cross-framework flow until instantiated.
