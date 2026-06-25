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
- rules/security.md
- constitution.md
- docs/engineering/TECH_STACK.md

## Outputs
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/evidence.md
- loops/specs/<feature>/iterations.log

## Iron Rule
**Build the replacement first, then deprecate the old system.** Do not deprecate without a replacement in place — users (including future you) will be stuck unable to use either the old or the new.

## Loop Type
This skill corresponds to the **refactor** loop in LOOP.md: a maximum of 3 iterations; the stop condition is no test regressions.

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

### 3. Incremental Migration
- **Migrate one consumer at a time** (use Grep to find call sites and change them one by one)
- For each migration:
  1. Change the call site to point to the new system
  2. Run the full test suite and confirm behavior matches
  3. Append to iterations.log: `[time] iter=<N> migrated <consumer> ✓`
- Do not batch-change multiple consumers before testing (errors accumulate, attribution is impossible)

### 4. Verify Zero Active Usage
Before removing the old code, you **must** prove there are no active consumers:
- Use Grep to search for call sites of the old API → should be 0
- Check whether config files and environment variables still reference the old system
- If metrics/logs are available, confirm zero active traffic

**Without evidence of zero active usage, do not delete the old code.**

### 5. Remove the Old System
- Delete the old code + old tests + old docs + old config
- Run the full test suite and confirm no regressions
- Update `docs/engineering/TECH_STACK.md`
- If ADRs exist, write a new ADR recording the migration decision (supersede the old one)

## Data Migration Specifics

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

Update per the "state.yaml Schema" in LOOP.md:
- `stage`: `act` (during migration) / `verify` (verifying zero usage)
- `iteration`: +1 (per consumer migrated)
- `last_error`: on failure, fill in "<consumer> migration failed: <reason>"

**Update iterations.log (append only, overwriting is forbidden)**:
```
[YYYY-MM-DD HH:MM] iter=<N> stage=act → migrated <consumer> ✓
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → zero active usage confirmed
```

## Prohibitions
- Deprecating the old system without a replacement
- Deleting old code without evidence of zero active usage
- Big Bang migration (unless the interface is fully compatible and test coverage is sufficient)
- Migration without test coverage (Beyonce Rule: if migration of untested code breaks, it's not the migration's fault)
- Data migration without a rollback script
- Adding new features to a deprecated old system

## Relationship with LOOP
This skill corresponds to the refactor loop of LOOP:
- Build replacement = PLAN (plan the new system)
- Incremental migration = ACT (change consumers one by one)
- Verify zero usage + no test regression = VERIFY
- Remove old code = DONE

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| migration | Migration decisions + incremental migration process |
| tdd | Red-green-refactor for the replacement |
| test-coverage | Add test coverage before migration (Beyonce Rule) |
| verify | No-regression verification after migration |
| writing-documentation | Migration guide + ADR |
| dependency-management | Dependency upgrades (minor versions go through this skill; major versions go through migration) |
