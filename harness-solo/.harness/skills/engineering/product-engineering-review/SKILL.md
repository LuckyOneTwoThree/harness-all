---
name: product-engineering-review
description: Performs product-level cross-feature consistency review after all features are implemented. Use after new-product-engineering's per-feature LOOPs complete, before product-level handoff. Complements single-feature verify.
---
# Product Engineering Review

## When to use
- After all features in an ENGINEERING_PLAN.md complete their per-feature LOOPs (tdd → verify → code-review)
- Before product-level handoff (solo-to-growth.md / solo-to-ops.md)
- Cross-feature consistency check needed (single-feature verify cannot catch these)

## Inputs
- docs/engineering/ENGINEERING_PLAN.md
- docs/engineering/TECH_STACK.md
- docs/product/FEATURES.md (status board)
- All per-feature artifacts: loops/specs/<feature>/{spec.md, evidence.md}
- Source code (all features combined)
- package.json / lockfile (or equivalent dependency manifest)
- Database migration files / ORM entity definitions (if backend is involved)

## Outputs
- loops/specs/<product-task>/product-review-evidence.md

## Overview

Product-level cross-feature consistency review. Single-feature verify checks one feature in isolation; product-engineering-review checks whether all features work together as a coherent product. Catches: API contract mismatches, dependency conflicts, data model conflicts, config naming drift, shared module duplication, integration failures.

Only checks **hard consistency that causes runtime/integration failures**. Does NOT check soft consistency (code style — handled by lint; state management strategy — bounded mixing is acceptable).

## Process

### 1. API Contract Consistency Check

Cross-feature function signature / return type / error handling alignment:

- Grep all exported functions across all features (e.g., `export function`, `export const`, `def `, `func `)
- For functions called across feature boundaries, verify:
  - Parameter names and types match
  - Return type matches the caller's expectation
  - Error handling contract is consistent (thrown exceptions vs returned error objects vs Result types)

**Pass criteria**:
- No cross-feature function call where the caller's expected signature differs from the implementation
- Error handling strategy uniform across feature boundaries (don't mix "throw on error" and "return null on error" for the same API surface)

**Fail example**:
```
F01 Auth exports: function getUser(): { id: string, name: string }
F03 Dashboard calls: const { userId, username } = getUser()  ← expects different field names
```

### 2. Dependency Conflict Check

Read package.json / lockfile (or requirements.txt / go.mod / Cargo.toml):

- Detect duplicate packages with different versions
- Detect peer dependency conflicts
- Verify all features use the same major version of shared libraries (e.g., React 18 vs React 19)

**Pass criteria**:
- Zero version conflicts in lockfile
- All features use the same major version of shared dependencies

**Fail example**:
```
F01 Auth:        "react-query": "^5.0.0"
F03 Dashboard:   "react-query": "^4.5.0"  ← major version conflict
```

### 3. Data Model Consistency Check

Review database schema / entity definitions / migration scripts:

- Check all migration files for conflicting table/column definitions
- Verify ORM entity definitions align with migrations
- Check that features sharing an entity (e.g., `User`) use the same field names and types

**Pass criteria**:
- No conflicting migration scripts (same table modified inconsistently)
- Shared entities have consistent field definitions across features
- Migration order is unambiguous (no circular migration dependencies)

**Fail example**:
```
F01 Auth migration: CREATE TABLE users (id UUID, email TEXT, name TEXT)
F03 Dashboard entity: class User { userId: string; email: string; username: string }  ← field name mismatch (id vs userId, name vs username)
```

### 4. Config Consistency Check

Grep all `process.env.*` / config key references / feature flag names:

- Verify environment variable names are unified (e.g., all use `DATABASE_URL`, not mixed with `DB_URL`)
- Verify config key naming follows a consistent convention (camelCase / snake_case / UPPER_SNAKE)
- Verify feature flag naming is consistent

**Pass criteria**:
- No duplicate config keys with different naming for the same purpose
- Config naming convention uniform across features

**Fail example**:
```
F01 Auth:     process.env.AUTH_SECRET
F02 Register: process.env.JWT_SECRET  ← different name for the same concept
F03 Dashboard: process.env.API_BASE_URL
F04 Settings: process.env.BACKEND_URL  ← different name for the same concept
```

### 5. Shared Module Reuse Check

Cross-reference ENGINEERING_PLAN.md Section 3 (Shared Infrastructure) with actual imports:

- For each shared infrastructure module, verify features import it rather than re-implementing
- Grep for utility function patterns (format*, parse*, validate*) across all features
- Detect semantic duplication (same functionality, different function name)

**Pass criteria**:
- Shared infrastructure modules are imported, not re-implemented
- No semantic duplication of utilities across features

**Fail example**:
```
ENGINEERING_PLAN says I04 Utility Functions includes formatDate
F03 Dashboard: imports { formatDate } from '@/utils'  ✓
F04 Settings:   defines its own formatDateString() with same logic  ✗ duplication
```

### 6. Integration Runnability Check

The final and most important check — does the product actually run when all features are combined:

- Run the app startup command (from TECH_STACK.md)
- Run the full test suite (not just per-feature tests)
- Verify cross-feature user flows work end-to-end (reference ENGINEERING_PLAN.md Section 6 integration checkpoints)

**Pass criteria**:
- App starts without errors
- Full test suite passes (show output, not "should pass")
- Cross-feature user flows complete successfully (e.g., register → login → dashboard → settings)

**Fail example**:
```
$ npm run build
ERROR: Type conflict in F03 Dashboard — useUser() returns { id } but Dashboard expects { userId }
$ npm test
FAIL F03 Dashboard: cannot read property 'userId' of undefined
```

### 7. Severity Labeling

| Severity | Meaning | Handling |
|----------|---------|----------|
| `Critical:` | Blocking (integration failure, runtime error, data model conflict) | Must fix; return to specific feature's LOOP |
| No prefix | Must change | Must fix |
| `Nit:` | Optional | Record directly |

### 8. Output Review Report

Write to `loops/specs/<product-task>/product-review-evidence.md`:

```markdown
# Product Engineering Review Evidence

## API Contract Consistency
- ✓ Cross-feature function signatures consistent (checked N exported functions)
- ✗ F03 Dashboard expects getUser() to return { userId, username }, but F01 Auth returns { id, name }

## Dependency Conflict
- ✓ No version conflicts in package-lock.json
- ✓ All features use React 18.2.0

## Data Model Consistency
- ✓ Migrations are unambiguous
- ✗ F03 Dashboard entity User.username does not exist in F01 Auth migration (only `name` column)

## Config Consistency
- ✓ Environment variable naming unified
- ✗ F01 uses AUTH_SECRET, F02 uses JWT_SECRET for the same purpose

## Shared Module Reuse
- ✓ I04 formatDate imported by F03
- ✗ F04 re-implements formatDate as formatDateString (duplication)

## Integration Runnability
- ✗ Build fails: type conflict in F03 Dashboard
- ✗ Full test suite: 2 failures in F03

## Critical Findings
#### C001: getUser() return type mismatch between F01 and F03
- Impact: Runtime error when Dashboard accesses userId
- Fix: Align F03 Dashboard's expectation with F01 Auth's implementation (or update F01's return type if F03's is correct)

#### C002: F04 re-implements formatDate
- Impact: Code duplication, maintenance risk
- Fix: Replace F04's formatDateString with import from I04

## Review Conclusion
- [ ] Pass / [ ] Fail
- Failure reason: <if fail, list Critical findings>
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Each feature passed verify, product is fine" | Single-feature verify can't catch cross-feature contract mismatches or integration failures |
| "Type checking is the compiler's job" | The compiler catches syntax errors, not semantic contract drift (e.g., returning `{ id }` when caller expects `{ userId }` — both are valid objects) |
| "Dependency conflict is rare" | Common when features are developed independently; lockfile merge conflicts are a real integration failure |
| "Integration testing is too slow" | A failed production deploy is far slower; IC5 (final integration test) is the cheapest place to catch integration failures |
| "Config naming is cosmetic" | Config drift causes deployment failures in production environments, not in development |

## Red Flags

- Skipping integration runnability check (most common product-level failure)
- Treating dependency conflict as "lockfile will resolve it" — lockfile resolution can silently pick the wrong version
- Not cross-referencing ENGINEERING_PLAN.md Section 3 for shared module reuse
- Approving with open Critical findings
- Running only per-feature tests instead of the full test suite

## Verification

- [ ] API contract consistency checked across all features (evidence: report contains exported function comparison)
- [ ] Dependency conflict checked via lockfile inspection (evidence: report contains version conflict list)
- [ ] Data model consistency checked (evidence: report contains migration + entity cross-reference)
- [ ] Config consistency checked (evidence: report contains env var / config key comparison)
- [ ] Shared module reuse checked against ENGINEERING_PLAN Section 3 (evidence: report contains duplication list)
- [ ] Integration runnability checked (evidence: report contains actual build + test output)
- [ ] Review conclusion clear (pass/fail + reason)

## Relationship with LOOP

- Stage: Out-of-LOOP gate, runs after all per-feature LOOPs + per-feature verify + per-feature code-review pass
- Product-level review; does not replace per-feature verify
- On failure: Critical → return to specific feature's LOOP for fix; Nit → record only
- Does not consume iterations (out-of-LOOP)
- On pass, enters product-level handoff (solo-to-growth.md + solo-to-ops.md)
