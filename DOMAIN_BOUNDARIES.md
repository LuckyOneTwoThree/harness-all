# Domain Boundaries and Routing

> Purpose: Prevent capability overlap from turning into duplicate execution. Each framework is independent, but family collaboration uses one clear owner per outcome.
>
> **Scope of this document**: harness-all is a **framework collection**. This document currently covers the 2 core frameworks (pm + engineering). When extension frameworks (data / qa / security) are added, their ownership rows and handoff rules will be appended here — the routing model is the same: one owner per outcome, contract documents bridge frameworks.

## Operating Modes

- **Degraded mode**: A framework may use its local fallback skills to complete domain-adjacent work when no upstream handoff exists. Engineering's design-intake supports degraded mode (derives a minimal contract from PRD + user conversation when no PM handoff or design assets are provided).
- **Family mode**: When both frameworks are intentionally combined, the owner below executes the work; the upstream framework defines constraints and consumes results.

The user chooses the operating mode. Do not infer that installed templates alone mean family mode.

## Ownership Matrix

| Outcome | Owner in family mode | Upstream contribution |
|---|---|---|
| Product strategy, PRD, product ACs, API contract spec | PM | Research and human decisions |
| Product analytics definitions, North Star, tracking requirements | PM | Research and human decisions |
| Design asset path collection (Figma / v0 export / md spec / image files) | PM (collects paths only) | User provides design assets |
| Design asset parsing → contract.json + tokens.json | Engineering (Phase 0 design-intake) | PM provides PRD + AC + design asset paths; Phase 0 supports 4 asset types: image (multimodal) / code (v0 export, tailwind config, shadcn) / markdown / Figma |
| Frontend implementation (UI code / state / styling) | Engineering (Phase 1) | contract.json + tokens.json + design assets (dual-input: contract layer + visual layer) |
| Backend implementation (API / data / migration) | Engineering (Phase 2) | API contract from contract.json |
| Integration verification (e2e / contract-check / mock-switch) | Engineering (Phase 3) | Frontend + backend code |
| Backend ACs (BAC-xxx) | Engineering (Phase 2) | Derived from API contract + product ACs |
| Integration ACs (IAC-xxx) | Engineering (Phase 3) | Derived from cross-phase integration requirements |
| Code, tests, architecture, engineering evidence | Engineering | PM ACs + API contract + design asset paths |
| Product-health interpretation and roadmap decision | PM | Engineering provides integration results + evidence |

> **Note on design assets**: In v3.0.0, design assets are **user-owned** (Figma / v0 / md / images). PM only collects the paths and forwards them in `pm-to-engineering.md`. PM never produces, transforms, or augments design output. Engineering's design-intake (Phase 0) parses these assets into a machine-readable `contract.json` + `tokens.json`. The previous design framework has been deleted; its responsibilities are split between PM (path collection) and Engineering Phase 0 (asset parsing).

## Naming Rules

- **product analytics**: User/product behavior metrics owned by PM.
- **API contract**: PM-owned specification of endpoints, methods, requests, responses, and error codes. Engineering implements against this contract; engineering does not modify the contract spec (changes flow back to PM via `engineering-to-pm.md`).
- **contract.json**: Engineering-owned parsed design contract (Phase 0 output). Derived from user design assets + PM's AC/API contract. Engineering may update this file as design assets change.

Avoid the unqualified word "monitoring" in new contracts when one of these precise terms applies.

## AC ID Ownership

| AC Type | Prefix | Owner | Notes |
|---------|--------|-------|-------|
| Product AC | `AC-<feature>-<sequence>` | PM | Source of truth; engineering preserves without renumbering |
| Backend AC | `BAC-<feature>-<sequence>` | Engineering (Phase 2) | Backend-specific criteria (API response codes, error handling, auth) |
| Integration AC | `IAC-<feature>-<sequence>` | Engineering (Phase 3) | End-to-end integration criteria |

> **DAC-xxx retired**: In v2.x, the design framework produced `DAC-xxx` IDs. In v3.0.0, design constraints are extracted into `contract.json` by engineering's design-intake phase and tracked as part of the frontend AC set (still `AC-xxx` scoped to the feature). The separate `DAC-` prefix is no longer used.

## Handoff Rules

In family mode:

1. PM produces `pm-to-engineering.md` with PRD + AC-xxx + API contract + design asset paths + routing fields (project_mode / exploration_mode / task_type / scope).
2. Engineering produces `engineering-to-pm.md` (on demand, when reverse feedback is triggered by any of the 4 tiers: scope/AC impact / TECH_STACK change / architecture decision / multi-bugfix accumulation).
3. Consumers read only; modification of the producer's contract is forbidden.
4. If no PM handoff exists, engineering runs in degraded mode (design-intake derives a minimal contract from user conversation + PRD if available).

## FEATURES.md Cross-Framework Reconciliation

PM and Engineering each maintain their own `FEATURES.md` with different status vocabularies reflecting their lifecycle perspectives:

| PM status (product lifecycle) | Engineering status (engineering lifecycle) | Meaning |
|-------------------------------|--------------------------------------------|---------|
| `pending` | `pending` | Not started |
| `in_progress` | — | PM in product design (Engineering not involved yet) |
| `review` | — | PM in internal review (Engineering not involved yet) |
| `approved` | `pending` | PM handoff ready; Engineering has not started |
| `developing` | `in_progress` / `review` | Engineering actively developing or in verify |
| `launched` | `done` | Engineering code-review passed AND PM launched |
| `blocked` | `blocked` | Blocked (reason may differ by framework) |

**Reconciliation rules**:

1. **PM session-start reconciliation step** (added to step 4 "Read the feature board"): when PM session-start reads `FEATURES.md`, if a `engineering-to-pm.md` handoff has been consumed (receipt exists), PM should cross-check: for each feature marked `done` in Engineering's `FEATURES.md` (reported via engineering-to-pm.md's "Implemented Features" section), PM's `FEATURES.md` should reflect at least `developing`. If PM still shows `approved` while Engineering reports `done`, flag the drift to the user.

2. **PM session-end reconciliation**: when PM session-end updates `FEATURES.md` (step 4 of update rules), if an Engineering `done` feature has been reported via consumed engineering-to-pm.md, PM may advance status to `launched` (after PM-internal launch decision) or leave at `developing` (if launch pending). PM never marks `launched` without its own launch decision.

3. **Engineering session-end reconciliation**: Engineering's `FEATURES.md` reflects only engineering lifecycle (`pending` → `in_progress` → `review` → `done`). Engineering does NOT consume PM's `FEATURES.md` directly; status synchronization flows through engineering-to-pm.md's "Implemented Features" section → PM session-start reconciliation.

4. **No direct write across frameworks**: PM never writes to Engineering's `FEATURES.md`; Engineering never writes to PM's `FEATURES.md`. Synchronization is handoff-driven, not direct-write.
