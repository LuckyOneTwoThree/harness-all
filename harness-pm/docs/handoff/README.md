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
- `engineering-to-pm.md` — harness-engineering hands off to harness-pm (Engineering → Product, feedback)

## Usage

1. Producer generates a current pointer and self-contained package from the template.
2. Transfer the complete package directory to the consumer's `docs/handoff/packages/`.
3. Consumer validates and receipts the package before using its content.

## Templates

- `templates/handoff-template.md` — Generic handoff template
- `templates/pm-to-engineering-template.md` — harness-pm → harness-engineering dedicated template (includes PRD path + AC-xxx + feature priorities + tracking plan + user-provided design asset paths)

Copy and fill in based on actual conditions.

## harness-pm Handoff Responsibilities

### Produced (pm hands off to downstream)
- `pm-to-engineering.md` — PRD + AC-xxx + tracking plan + user-provided design asset paths → handed off to engineering for development

### Consumed (downstream hands off to pm)
- `engineering-to-pm.md` — Engineering feedback (implemented features / technical constraints / open issues)

## Versioning

- The fixed `<source>-to-<target>.md` file is the current pointer and contains one latest contract.
- Before replacement, archive the previous contract as `archive/<handoff_id>.md`.
- Every contract uses the template frontmatter envelope and records `supersedes`.
- Optional consumer acknowledgements belong in `receipts/`; consumers never edit producer contracts.

## Write Access

Contract documents follow one-way write permission isolation (per ARCHITECTURE.md §4.3). Only the source framework may write/modify a contract document; consumers read-only. Templates are scaffolds and do not participate in cross-framework flow until instantiated.
