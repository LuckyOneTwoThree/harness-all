---
name: migration
description: Code Migration — framework upgrades/API migration/data migration, guarding against regressions
---
# Migration — Code Migration

## When to use
- On major version upgrades of frameworks/libraries
- On API migration
- On data migration
- When removing deprecated code

## Inputs
- loops/LOOP.md
- loops/STATE_PROTOCOL.md
- loops/state.schema.json
- rules/security.md
- constitution.md
- docs/engineering/TECH_STACK.md

## Outputs
- `loops/specs/<feature>/state.yaml` (stage/iteration/error)
- per-attempt terminal outcome in `iterations.log` (written by this skill's inline verify-fast)
- migration/equivalence evidence returned to verify for `evidence.md`

## Iron Rule
**Build the replacement first, then deprecate the old system.** Do not deprecate without a replacement in place — users (including future you) will be stuck unable to use either the old or the new.

## Loop Type
This skill corresponds to the **migration** loop in LOOP.md: a maximum of 3 iterations; the stop condition is migrated consumer equivalence + no test regressions.

## Migration Decision (hard gate)

Before starting a migration, answer the following questions. If any item is not satisfied → do not migrate:

- [ ] **Does the old system still have unique value?** If yes, it cannot be removed
- [ ] **How many consumers depend on it?** Use Grep to search for call sites of the old API and list them
- [ ] **Does a replacement exist?** If not → build the replacement first (go through the new-feature workflow)
- [ ] **Migration cost vs. maintenance cost?** Migration cost > 2-3 years of maintenance cost → not worth it
- [ ] **Is test coverage sufficient?** Does the old system have test coverage? If not → add tests first (go through the test-coverage skill)

**Hyrum's Law warning**: with enough users, every observable behavior (including bugs, timing quirks) will be depended upon. Migration is harder than you think.

## Process

### 1. Build the Replacement
- The replacement must cover all key use cases of the old system
- Write a migration guide (`docs/migration-guide-<feature>.md`)
- The replacement must have tests (go through the tdd skill)

### 2. Choose a Migration Strategy

| Strategy | Applicable Scenario | Risk |
|------|---------|------|
| **Strangler Pattern** | Gradual replacement, new and old run in parallel | Low, can roll back at any time |
| **Adapter Pattern** | Old interface delegates to new implementation | Low, interface-compatible |
| **Feature Flag** | Gradual user-by-user rollout | Medium, requires flag management |
| **Big Bang** | One-time switch | High, not recommended |

**Default to the Strangler Pattern**, unless the replacement is fully interface-compatible with the old system and an Adapter can be used.

### 3. Incremental Migration + Inline Verify-Fast (merged)

- **Migrate one consumer at a time** (use Grep to find call sites and change them one by one). Do not batch-change multiple consumers before testing (errors accumulate, attribution is impossible).
- For each migrated consumer, this skill owns the per-attempt fast verification inline (verify-fast is no longer a separate skill invocation). Keep `stage: act`, `status: running`, and the current iteration. Perform these 4 fast-verify duties before declaring the attempt outcome:
  1. **Validate tests + equivalence** — run the full test suite and confirm behavior matches the old system (equivalence); reject `0 tests`, stale output, or a different command than claimed.
  2. **AC/BAC/IAC check** — confirm the stable AC/BAC/IAC IDs exercised by this task have evidence; cite component contract/binding by stable component ID when frontend code is touched (e.g., React/Vue major version upgrade touching component modules).
  3. **Changed-file security scan** — run the quick security scan on changed files and disposition every hit.
  4. **Append terminal outcome** — append exactly one terminal PASSED/FAILED line to `iterations.log` for this attempt.
- On pass: `stage: verify, status: running, substage_progress[<active-phase>].verify_state: inline-passed`, clear error. Continue to the next consumer or hand off to verify-full (set `substage_progress[<active-phase>].verify_state: awaiting-full` when all consumers are done).
- On failure: `stage: verify, status: retrying, substage_progress[<active-phase>].verify_state: inline-failed`, concrete error, then route by cause. At the recommended failed-attempt limit, set `needs-human`. A failed attempt 10 triggers the hard breaker.
- Do not append a second attempt record. This inline step writes the one terminal outcome.

### 4. Verify Zero Active Usage
Before removing the old code, you **must** prove there are no active consumers:
- Use Grep to search for call sites of the old API → should be 0
- Check whether config files and environment variables still reference the old system
- If metrics/logs are available, confirm zero active traffic

**Without evidence of zero active usage, do not delete the old code.**

### 5. Remove the Old System
- Treat cleanup as its own planned ACT attempt after zero-usage evidence; increment before deletion and preserve rollback.
- Delete the old code + old tests + old docs + old config
- Run the full test suite and confirm no regressions
- Update `docs/engineering/TECH_STACK.md`
- If ADRs exist, write a new ADR recording the migration decision (supersede the old one)

## Data Migration Specifics (backend scope only)

Data migration (DB schema / data format) has additional requirements:
- **Migration scripts must be generated** (required by constitution.md)
- Migration scripts must have rollback scripts
- Test on backup data first
- For large data volumes, migrate in batches and verify each batch

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "It still works, why remove it?" | Unmaintained code accumulates security debt |
| "Someone might need it later" | It can be rebuilt when truly needed; keeping code "just in case" is more expensive than rebuilding |
| "Users will migrate on their own" | They won't; you must provide tools/docs |
| "Doing it all at once is faster" | Big Bang is high-risk; incremental migration is reversible |
| "Keep the old code for now, don't delete" | Keeping it = continued maintenance cost + confusion |

## State Maintenance

Follow `.harness/loops/STATE_PROTOCOL.md`: increment once before mutation; this skill owns the per-attempt terminal outcome via inline verify-fast; verify owns `evidence.md` (full verification only).

## Prohibited
- Deprecating the old system without a replacement
- Deleting old code without evidence of zero active usage
- Big Bang migration (unless the interface is fully compatible and test coverage is sufficient)
- Migration without test coverage (Beyonce Rule: if migration of untested code breaks, it's not the migration's fault)
- Data migration without a rollback script
- Adding new features to a deprecated old system

## Verification

- [ ] Migration Decision hard gate passed before starting (all 5 items satisfied).
- [ ] Replacement built and tested before any deprecation (step 1).
- [ ] Migration strategy explicitly chosen (Strangler Pattern default; step 2).
- [ ] One consumer migrated per attempt; full test suite + equivalence confirmed each time (step 3).
- [ ] Zero active usage proven before old code removal (step 4 — Grep + config + metrics).
- [ ] Old code + tests + docs + config all removed together (step 5).
- [ ] `docs/engineering/TECH_STACK.md` updated to reflect the migration (step 5).
- [ ] Data migration (if applicable): rollback script exists, tested on backup data first.
- [ ] Inline verify-fast's 4 duties performed; terminal outcome appended to `iterations.log`.

## Relationship with LOOP

Corresponds to the migration loop: build replacement = PLAN, incremental migration = ACT (with inline verify-fast per consumer), zero-usage/equivalence evidence aggregated at verify-full, remove old code = final ACT before DONE. See `.harness/loops/LOOP.md`.

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| test-coverage | Add test coverage before migration (Beyonce Rule) |
| writing-documentation | Migration guide + ADR |
| dependency-management | Dependency upgrades (minor versions go through this skill; major versions go through migration) |
