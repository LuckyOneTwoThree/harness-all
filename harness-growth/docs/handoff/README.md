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
- `solo-to-growth.md` — harness-solo hands off to harness-growth (Engineering → Growth)
- `growth-to-pm.md` — harness-growth hands off to harness-pm (Growth → Product, feedback growth data)
- `pm-to-growth.md` — harness-pm hands off to harness-growth (Product → Growth, passing product strategy)

## This Framework's Handoff Documents

### Consumed (upstream → this framework)
- `solo-to-growth.md` — from harness-solo, includes new feature launch info, trackable events, API endpoints, etc.
- `pm-to-growth.md` — from harness-pm, includes product strategy, target users, growth goals, etc.

### Produced (this framework → downstream)
- `growth-to-pm.md` — feedback to harness-pm, includes experiment conclusions, growth data, user insights, etc., to help product decisions

## Usage

1. Producer generates a current pointer and self-contained package from the template.
2. Transfer the complete package directory to the consumer's `docs/handoff/packages/`.
3. Consumer validates and receipts the package before using its content.

## Templates

| Template | Purpose |
|------|------|
| `templates/handoff-template.md` | Generic handoff template |
| `templates/growth-to-pm-template.md` | Dedicated template for growth feedback to product |

> Inbound templates (pm-to-growth / solo-to-growth) are provided by the source framework and are not stored in this framework.

## Versioning

- The fixed `<source>-to-<target>.md` file is the current pointer and contains one latest contract.
- Before replacement, archive the previous contract as `archive/<handoff_id>.md`.
- Every contract uses the template frontmatter envelope and records `supersedes`.
- Optional consumer acknowledgements belong in `receipts/`; consumers never edit producer contracts.

## Write Access

Contract documents follow one-way write permission isolation (per ARCHITECTURE.md §4.3). Only the source framework may write/modify a contract document; consumers read-only. Templates are scaffolds and do not participate in cross-framework flow until instantiated.
