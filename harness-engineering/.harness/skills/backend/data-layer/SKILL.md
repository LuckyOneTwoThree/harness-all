---
name: data-layer
description: "Phase 2 skill. Use when designing the database schema, ORM models, and migration scripts from the PRD entities + API contract — produces schema files, ORM models, and reversible migrations consumed by api-implementation."
---
# Data Layer (Phase 2)

## When to use

- Phase 2 (backend) of the 4-phase engineering pipeline.
- Need to design the database schema, ORM models, and migration scripts from the PRD entities.
- Runs before (or alongside) `api-implementation` so endpoints have a persistence layer to call.
- Phase 2 LOOP ACT owner for the data layer outcome; hands Red/Green/Refactor to `test-driven-development` for model/repo tests.

## Inputs

- `docs/handoff/pm-to-engineering.md` (current pointer, validated by session-start) — PRD entities list + fields + relationships + the API contract section (drives query shapes). In degraded mode (no PM handoff), this is derived from user conversation + `contract.json`.
- `docs/handoff/contract.json` — entities surfaced from Phase 0/1. **Read `entities[]` for the authoritative field list and `deviations[]` for Phase 1 contract deviations** (e.g., a field added to an entity during frontend review via `DEV-<task>-<N>` with `detected_at_phase: 1` and `field` touching `entities.<entity_id>.fields`). Deviations with `severity: major` require explicit user approval before schema change; `minor` additions are incorporated directly.
- `loops/specs/<task>/phase-1-frontend-report.md` — Phase 1 downstream notes and contract deviation summary; surfaces manual adjustments that impact the data model (e.g., "DEV-<task>-1 added `priority` to entities.Todo — Phase 2 data-layer must add the column").
- `docs/engineering/TECH_STACK.md` — ORM + database + `project_mode`.
- `loops/specs/<task>/spec.md` and `state.yaml`.
- `.harness/rules/engineering-pipeline.md`, `rules/security.md`, `constitution.md`.

## Outputs

- Schema files (e.g. `prisma/schema.prisma`, `db/schema.sql`, or framework-equivalent).
- ORM models under the project-mode location below.
- Migration scripts (up + down) under the project-mode location below.
- **BAC-xxx IDs** for each entity/migration behavior (allocated per `acceptance-id-protocol.md`; tracked in `spec.md` "Backend AC" section and `phase-2-backend-report.md`).
- Updated `state.yaml`.
- Verify owns `evidence.md`; this skill owns the per-attempt terminal outcome.

## Project Mode Adaptation

Read `docs/engineering/TECH_STACK.md` `project_mode`:

| Mode | Schema | ORM models | Migrations |
|------|--------|------------|------------|
| `fullstack` | `db/schema.*` | `db/models/` | `db/migrations/` |
| `separate` | `server/db/schema.*` | `server/db/models/` | `server/db/migrations/` |

When `project_mode` is unset, infer from the existing directory layout and record the inference in `state.yaml`.

## Iron Rule

**Every migration must be reversible.** A migration without a down script is incomplete. Data-layer changes are the highest-risk mutation in the pipeline — a non-reversible migration can lock the system out of its own data.

## Hard Gates

1. Confirm `TECH_STACK.md` declares ORM + database + `project_mode` before writing any schema.
2. The schema must cover every entity documented in the PRD. An undocumented entity is a planning gap; do not invent entities the PRD does not authorize.
3. Every migration has both an `up` and a `down` script. The `down` script must actually reverse the `up` (dropping a column added; restoring the prior type), not be a stub.
4. Schema changes are tested: model/repo tests fail first (Red), then pass (Green).
5. **Field coverage (forward)**: every field listed in `contract.json.entities[].fields[]` (the authoritative field list, including fields added via Phase 1 `deviations[]`) must map to a schema column with the correct type, nullability, and constraints. A missing field blocks the phase checkpoint; do not silently drop fields the contract authorizes. Fields added via `severity: major` deviations require explicit user approval before incorporation — if a major deviation is recorded but not yet approved, block the current outcome, surface the deviation to the user for approval, and do not proceed until approval is granted or the deviation is withdrawn.

## Process

### 1. Enter the Attempt

Read raw `state.yaml`, spec, and the PRD entities + API contract. Reject terminal/broken state. Before any mutation: enforce attempt limits, increment `iteration` exactly once, persist `stage: act`, `status: running`, and select one entity (or one tightly-coupled entity group) as the current outcome.

### 2. Schema Design (from PRD entities)

For each selected entity:

- map PRD fields to columns with correct types, nullability, and defaults;
- declare primary keys, foreign keys, and indexes (driven by the API contract's query/filter patterns);
- declare relationships (1:1, 1:N, N:M) per the PRD;
- enforce uniqueness constraints documented in the PRD;
- record the entity ↔ table/column mapping in `state.yaml` notes or an adjacent design note.

Coverage check: every PRD entity in scope has a schema definition. Missing entities block; do not silently skip.

### 3. ORM Mapping

Map the schema to the project's ORM (Prisma / TypeORM / SQLAlchemy / Drizzle / etc. per `TECH_STACK.md`). Models reflect the schema exactly; relationships are typed; cascading deletes are explicit and intentional (record the reason for every cascade).

### 4. Red — Failing Model/Repo Test

Write one behavior-focused test (create / read / relationship traversal / constraint enforcement) for the selected entity. Run it and confirm it fails for the intended reason — not a missing migration or a connection error. Never add a duplicate test merely to repeat the Red ceremony.

### 5. Green — Generate Migration + Run It

Generate the migration for the schema change (up + down). Apply `up`. Run the focused test until green. Confirm `down` reverses `up` on a scratch database (or the test database) — this is mandatory, not optional polish.

### 6. Refactor

With the focused test green, improve only code touched by this entity when it materially improves clarity or removes duplication. Rerun the affected test set after every structural change. Refactor is optional; do not manufacture churn.

### 7. Inline Verify-Fast (merged)

This skill owns the per-attempt fast verification inline. Keep `stage: act`, `status: running`, and the current iteration. Perform the 4 fast-verify duties before declaring the attempt outcome:

1. **Validate tests** — reuse the exact green output from step 5 only when produced in the same execution context; otherwise rerun the affected test set. Reject `0 tests`, stale output, or a different command than claimed.
2. **AC/BAC check + BAC reverse coverage** — confirm the stable AC/BAC IDs exercised by this entity have evidence. Additionally, perform **BAC reverse coverage**: verify that every entity behavior implemented in this attempt (create/read/update/delete/relationship traversal/constraint enforcement) has a corresponding BAC-xxx ID declared in `spec.md`. If a behavior is implemented without a BAC, this is a `missing-bac` finding — do not pass until the BAC is allocated and recorded. This prevents BAC under-coverage from reaching Phase 3.
3. **Changed-file security scan** — run the quick security scan on changed files and disposition every hit (sensitive columns plaintext, missing index on a foreign key, cascade-delete risk).
4. **Append terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt.

On pass: `stage: verify`, `status: running`, `substage_progress[<active-phase>].verify_state: inline-passed`, clear error. Continue to the next entity; set `substage_progress[<active-phase>].verify_state: awaiting-full` when all planned entities are done.
On failure: `stage: verify`, `status: retrying`, `substage_progress[<active-phase>].verify_state: inline-failed`, concrete error, then route by cause. At the recommended failed-attempt limit, set `needs-human`. A failed attempt 10 triggers the hard breaker.

Do not append a second attempt record. This inline step writes the one terminal outcome.

## Failure Handling

- Known implementation defect: `status: retrying`, concrete `last_error`; verify/debug decides next route.
- Requirement/spec defect (entity missing from PRD): stop mutation and return to PLAN.
- Unknown cause: invoke `systematic-debugging`.
- Never increment during failure handling.

## Prohibited

- Designing schema for entities not documented in the PRD.
- Shipping a migration without a working `down` script.
- Stub `down` scripts (`// TODO`, empty function, `throw new Error('not implemented')`).
- Plaintext storage of sensitive columns (passwords, tokens, PII) — follow `rules/security.md`.
- Silently dropping a column or table without a migration that documents the data disposition.
- Writing schema/models before a failing model/repo test for the intended behavior.
- Running a second independent TDD/verification lifecycle instead of returning constraints to the canonical pipeline.

## Verification

- [ ] Iteration increment occurred once before mutation.
- [ ] Schema covers every PRD entity in scope (no missing, no invented).
- [ ] Every field in `contract.json.entities[].fields[]` (including Phase 1 deviation additions) maps to a schema column; no authorized field silently dropped.
- [ ] ORM models reflect the schema exactly; relationships typed; cascades documented.
- [ ] Every migration has `up` + `down`; `down` verified to reverse `up`.
- [ ] Sensitive columns handled per `rules/security.md`.
- [ ] Inline fast-verify received actual output, not a prediction.

## Relationship with LOOP

- Phase: 2 (backend)
- ACT owner: `data-layer` → `test-driven-development`
- After all planned entities pass inline fast verification, `verify` runs verify-full once for the phase, then the checkpoint writes `phase-2-backend-report.md`.

## Division of Labor with Other Skills

| Skill | Responsibility |
|-------|------|
| api-implementation | Endpoint code that consumes the ORM models + migrations produced here |
| test-driven-development | Owns the Red/Green/Refactor cycle once the model/repo test is written |
| migration | Major ORM/database upgrades (v3→v4) go through the migration flow |
| verify | verify-full evidence gate for phase 2 |
