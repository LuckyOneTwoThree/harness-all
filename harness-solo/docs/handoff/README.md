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
- `pm-to-solo.md` — harness-pm hands off to harness-solo (Product → Engineering)
- `solo-to-growth.md` — harness-solo hands off to harness-growth (Engineering → Growth)
- `design-to-solo.md` — harness-design hands off to harness-solo (Design → Engineering)

## Usage

1. Producer generates a current pointer and self-contained package from the template.
2. Transfer the complete package directory to the consumer's `docs/handoff/packages/`.
3. Consumer validates and receipts the package before using its content.

## Templates

- `handoff-template.md` — Generic handoff template
- `solo-to-pm-template.md` — harness-solo → harness-pm dedicated template (engineering feedback: implementation status / blockers, on demand)
- `solo-to-growth-template.md` — harness-solo → harness-growth dedicated template (includes implemented features list + AC-xxx + performance metrics + tracking events)
- `solo-to-ops-template.md` — harness-solo → ops dedicated template (engineering handoff to ops: deployment checklist + config items + monitoring alerts + rollback plan)

Copy and fill in based on actual conditions.

## Versioning

- The fixed `<source>-to-<target>.md` file is the current pointer and contains one latest contract.
- Before replacement, archive the previous contract as `archive/<handoff_id>.md`.
- Every contract uses the template frontmatter envelope and records `supersedes`.
- Optional consumer acknowledgements belong in `receipts/`; consumers never edit producer contracts.

## Write Access

Contract documents follow one-way write permission isolation (per ARCHITECTURE.md §4.3). Only the source framework may write/modify a contract document; consumers read-only. Templates are scaffolds and do not participate in cross-framework flow until instantiated.
