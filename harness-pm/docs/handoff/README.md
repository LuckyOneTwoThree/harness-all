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
- `solo-to-pm.md` — harness-solo hands off to harness-pm (Engineering → Product, feedback)
- `pm-to-design.md` — harness-pm hands off to harness-design (Product → Design)
- `pm-to-growth.md` — harness-pm hands off to harness-growth (Product → Growth)
- `growth-to-pm.md` — harness-growth hands off to harness-pm (Growth → Product, data feedback)

## Usage

1. Producer generates a current pointer and self-contained package from the template.
2. Transfer the complete package directory to the consumer's `docs/handoff/packages/`.
3. Consumer validates and receipts the package before using its content.

## Templates

- `templates/handoff-template.md` — Generic handoff template
- `templates/pm-to-solo-template.md` — harness-pm → harness-solo dedicated template (includes PRD path + AC-xxx + feature priorities + tracking plan)
- `templates/pm-to-design-template.md` — harness-pm → harness-design dedicated template (includes PRD path + AC-xxx + Persona + style keywords)
- `templates/pm-to-growth-template.md` — harness-pm → harness-growth dedicated template (includes OKR + North Star metric + growth hypotheses)

Copy and fill in based on actual conditions.

## harness-pm Handoff Responsibilities

### Produced (pm hands off to downstream)
- `pm-to-solo.md` — PRD + design specs + tracking plan → handed off to engineering for development
- `pm-to-design.md` — PRD + positioning statement → handed off to UI design
- `pm-to-growth.md` — Metric system + growth strategy → handed off to growth operations

### Consumed (downstream hands off to pm)
- `solo-to-pm.md` — Engineering feedback (implemented features / technical constraints / open issues)
- `growth-to-pm.md` — Growth data feedback (experiment results / user feedback)
- `ops-to-pm.md` — Ops feedback (SLA summary / incident notices / ops recommendations)
- `design-to-pm.md` — Design feedback (on demand)

## Versioning

- The fixed `<source>-to-<target>.md` file is the current pointer and contains one latest contract.
- Before replacement, archive the previous contract as `archive/<handoff_id>.md`.
- Every contract uses the template frontmatter envelope and records `supersedes`.
- Optional consumer acknowledgements belong in `receipts/`; consumers never edit producer contracts.

## Write Access

Contract documents follow one-way write permission isolation (per ARCHITECTURE.md §4.3). Only the source framework may write/modify a contract document; consumers read-only. Templates are scaffolds and do not participate in cross-framework flow until instantiated.
