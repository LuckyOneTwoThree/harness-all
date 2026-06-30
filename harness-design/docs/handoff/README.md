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
- `pm-to-design.md` — harness-pm hands off to harness-design (Product → Design)
- `design-to-solo.md` — harness-design hands off to harness-solo (Design → Engineering)

## Usage

1. Producer generates a current pointer and self-contained package from the template.
2. Transfer the complete package directory to the consumer's `docs/handoff/packages/`.
3. Consumer validates and receipts the package before using its content.

## Templates

- `handoff-template.md`: Generic handoff template
- `design-to-solo-template.md`: harness-design → harness-solo template with stable AC/DAC IDs and semantic component contract reference

- `design-to-pm-template.md`: harness-design to harness-pm product feedback with stable feedback IDs and evidence

Copy and fill in based on actual conditions.

## Data Files

- Runtime `component-contract.json` is generated only from approved project design; no sample is installed in `docs/handoff/`. The framework-neutral example lives at `.harness/templates/component-contract.example.json`. Harness-solo separately owns `component-bindings.json`.

## Versioning

- The fixed `<source>-to-<target>.md` file is the current pointer and contains one latest contract.
- Before replacement, archive the previous contract as `archive/<handoff_id>.md`.
- Every contract uses the template frontmatter envelope and records `supersedes`.
- Optional consumer acknowledgements belong in `receipts/`; consumers never edit producer contracts.

## Write Access

Contract documents follow one-way write permission isolation (per ARCHITECTURE.md §4.3). Only the source framework may write/modify a contract document; consumers read-only. Templates are scaffolds and do not participate in cross-framework flow until instantiated.
