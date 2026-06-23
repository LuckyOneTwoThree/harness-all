# Handoff Document Directory

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
| `handoff-template.md` | Generic handoff template |
| `ops-to-pm-template.md` | Dedicated template for ops feedback to product |

> Inbound templates (solo-to-ops) are provided by the source framework harness-solo and are not stored in this framework.

## Usage

1. The upstream framework produces a handoff document from the template and places it in this directory
2. session-start automatically scans this directory and reminds the user when new handoff documents are found
3. After the downstream framework consumes a document, it records "Consumed X handoff document" in progress.md

## Naming Convention

- Filename is fixed (no date): `<source>-to-<target>.md`
- Downstream only looks at the latest state; historical versions are not retained
- For historical tracing, check git log
