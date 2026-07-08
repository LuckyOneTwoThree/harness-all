# Import Mode Execution Flow

> Detailed steps for design-prd Import Mode (external PRD normalization).
> Referenced by [SKILL.md §Import Mode](../SKILL.md#import-mode-external-prd-normalization).
> See also: [import-audit-checklist.md](import-audit-checklist.md) for the audit dimensions, [quality-checks.md](quality-checks.md) for Gate adaptation, [decision-tables.md](decision-tables.md) for decision tables.

## IM-1. Read & parse the external PRD

- Read the user's external PRD from ANY path (user-specified location — not restricted to docs/product/)
- Parse into the 9-section structure as best as possible (tolerant parsing — sections may be out of order or named differently)
- Identify which sections exist, which are missing, which are non-applicable

## IM-2. Run PRD Import Audit

- Apply the 5-dimension audit checklist from [import-audit-checklist.md](import-audit-checklist.md):
  - Dimension 1: Structural Completeness (P0-Block)
  - Dimension 2: Consistency (P1-Advise)
  - Dimension 3: Ambiguity & Overreach (P1-Advise)
  - Dimension 4: Value Signals (P2-Advisory)
  - Dimension 5: prd.json Projection Readiness (P0-Block)
- Produce an issues list with: issue ID, severity, location, description, suggested fix

## IM-3. Present issues to user for decision (👤 human decision point)

- Present all issues grouped by severity (P0-Block → P1-Advise → P2-Advisory)
- For each issue, the user chooses ONE of:
  - **Adopt**: accept the suggested fix (design-prd will apply it in IM-4)
  - **Keep**: preserve original content byte-for-byte (P1/P2 only; P0-Block cannot choose this — must fix or defer)
  - **Defer**: mark `deferred` with reason + owner + required_before (allowed for all levels)
- Record every decision in progress.md (issue ID, severity, decision, rationale)
- **Circuit-breaker**: once the user decides, the 4 Quality Gates in IM-5 MUST NOT re-challenge the same issue

## IM-4. Rebuild PRD.md + project prd.json (respecting user decisions)

- Apply only the fixes the user approved ("Adopt")
- Preserve "Keep" content byte-for-byte — do NOT rewrite, rephrase, or "optimize" it
- For "Defer" items, add a `deferred` marker in PRD.md with reason + owner + required_before
- Assign AC-xxx IDs for any AC that doesn't match `^AC-[A-Z0-9]+-[0-9]{3}$` (stable-ID rules apply — once assigned, cannot renumber/reuse)
- Normalize the 9-section structure (reorder sections, add missing section headers with `not_applicable` or `deferred` markers as appropriate)
- Write the rebuilt PRD.md to `docs/product/PRD.md` (framework standard location — overwrites any existing skeleton/placeholder)
- Project prd.json from the rebuilt PRD.md:
  - Compute source_sha256 (SHA-256 of the rebuilt PRD.md, lowercase hex)
  - Fill all 7 top-level arrays (features/pages/entities/user_flows/non_functional_requirements/tracking_plan/traceability)
  - Mark applicability per domain (applicable / not_applicable / deferred)
  - AC-xxx IDs projected to `features[].acceptance_criteria[].ac_id`
  - Write to `docs/product/prd.json` (framework standard location)
- For P1-Advise "Keep" decisions: record the issue in PRD.md Section 9.3 (Open Issues) with description + user rationale
- For P2-Advisory "Acknowledge" decisions: record in progress.md only (not in PRD.md Open Issues)

## IM-5. Execute 4 Quality Gates (with user-decision awareness)

- Run the same 4 Quality Gates as Generate Mode (see [quality-checks.md](quality-checks.md))
- **Gate recognizes user decisions**: for each P1-Advise issue the user chose "Keep", the Gate reads the progress.md record and does NOT re-flag it. The Gate only fails on NEW issues not covered by the audit.
- P0-Block issues that the user refused to fix (impossible by design — P0 cannot "Keep", only "Adopt" or "Defer") will cause Gate 1 to fail. If the user marked `deferred`, Gate 1 checks the deferred marker and passes (deferred is a valid structural state).
- If Gate fails on a NEW issue (not in audit list): record it, present to user, loop back to IM-3 for this new issue only (max 2 self-correction rounds, same as Generate Mode)

## IM-6. Output

- Write rebuilt `docs/product/PRD.md` (with user-approved fixes applied, "Keep" content preserved, deferred markers added, Open Issues recorded)
- Write `docs/product/prd.json` (with source_sha256 matching the rebuilt PRD.md)
- Update `memory/progress.md` with: Import Mode run summary, audit issues list, user decisions, Gate results
- The output is now ready for session-end to produce pm-to-engineering.md handoff document

## Import Mode Constraints

- ❌ MUST NOT call the requirements-collection/understanding/prioritization logic from Generate Mode Step 1-3 (the user already has requirements; no need to re-collect)
- ❌ MUST NOT overwrite PRD.md content the user chose to "Keep"
- ❌ MUST NOT auto-correct UI instruction overreach (Gate 3) without user approval — present as P1-Advise
- ❌ MUST NOT re-challenge issues the user already decided on (circuit-breaker)
- ✅ MUST assign stable AC-xxx IDs (once assigned, immutable per acceptance-id-protocol.md)
- ✅ MUST compute source_sha256 from the final rebuilt PRD.md
- ✅ MUST record all user decisions in progress.md for traceability

## Flow Diagram

```
External PRD
     ↓
[IM-1] Read & parse
     ↓
[IM-2] Audit (5 dimensions)
     ↓
[IM-3] Present issues → user decides (Adopt/Keep/Defer)  👤
     ↓
[IM-4] Rebuild PRD.md + project prd.json (respecting decisions)
     ↓
[IM-5] 4 Quality Gates (user-decision aware)
     ↓ pass
[IM-6] Output PRD.md + prd.json + progress.md
     ↓
Ready for session-end handoff production
```

If IM-5 Gate fails on a NEW issue → loop back to IM-3 (max 2 rounds).

## Import Mode Decision Tables

> Used when design-prd runs in Import Mode (external PRD normalization). See [SKILL.md §Import Mode](../SKILL.md#import-mode-external-prd-normalization) and [import-audit-checklist.md](import-audit-checklist.md).

### Mode Selection Decision

| Condition | Mode | Rationale |
|-----------|------|-----------|
| PRD.md exists with real content AND user says "import" / "I have a PRD" | Import Mode | User has existing PRD; avoid overwriting |
| PRD.md exists with real content BUT user says "regenerate" / "rewrite" | Generate Mode | User explicitly wants regeneration |
| PRD.md is skeleton/placeholder (from setup) | Generate Mode | No real content to preserve |
| PRD.md does not exist | Generate Mode | Nothing to import |
| User provides external PRD path (not docs/product/PRD.md) | Import Mode | External document needs normalization |

### User Decision Options per Severity

| Severity | Adopt (apply fix) | Keep (preserve original) | Defer (postpone) | Acknowledge (advisory only) |
|----------|-------------------|-------------------------|------------------|-----------------------------|
| P0-Block | ✅ Allowed | ❌ Not allowed | ✅ Allowed (with owner+required_before) | ❌ N/A |
| P1-Advise | ✅ Allowed | ✅ Allowed | ✅ Allowed | ❌ N/A |
| P2-Advisory | ✅ Allowed | ✅ Allowed | ✅ Allowed | ✅ Allowed |

### Decision Recording Locations

| Decision Type | Recorded in PRD.md §9.3 Open Issues | Recorded in progress.md | Applied to PRD.md content |
|---------------|-------------------------------------|-------------------------|----------------------------|
| P0-Block → Adopt | ❌ (fixed, not an open issue) | ✅ (decision log) | ✅ (fix applied) |
| P0-Block → Defer | ✅ (with deferred marker) | ✅ (decision log) | ✅ (deferred marker added) |
| P1-Advise → Adopt | ❌ (fixed) | ✅ (decision log) | ✅ (fix applied) |
| P1-Advise → Keep | ✅ (with user rationale) | ✅ (decision log) | ❌ (preserved byte-for-byte) |
| P1-Advise → Defer | ✅ (with deferred marker) | ✅ (decision log) | ✅ (deferred marker added) |
| P2-Advisory → Adopt | ❌ (fixed) | ✅ (decision log) | ✅ (fix applied) |
| P2-Advisory → Acknowledge | ❌ (advisory only) | ✅ (decision log) | ❌ (preserved) |
| P2-Advisory → Defer | ✅ (with deferred marker) | ✅ (decision log) | ✅ (deferred marker added) |

### Gate Failure Recovery in Import Mode

| Gate Failure Scenario | Recovery Action | Max Rounds |
|----------------------|-----------------|------------|
| Gate fails on issue user already decided (Keep/Defer) | ❌ Cannot happen (circuit-breaker prevents) | 0 |
| Gate fails on NEW P0 issue (not in audit) | Present to user, offer Adopt/Defer only | 2 |
| Gate fails on NEW P1 issue (not in audit) | Present to user, offer Adopt/Keep/Defer | 2 |
| Gate fails after 2 self-correction rounds | Output problem report, require human intervention | — |
| Gate 1 fails because user deferred a P0 but deferred marker is malformed | Prompt user to fix the deferred marker format (reason+owner+required_before) | 1 (marker format only) |

### AC ID Assignment in Import Mode

| External PRD AC State | Import Mode Action | Stable-ID Rule |
|----------------------|-------------------|----------------|
| AC already matches `AC-<feature>-<sequence>` format | Preserve as-is | ✅ Compliant |
| AC uses non-standard format (e.g., "AC1", "验收标准1") | Assign new AC-xxx ID; record mapping in progress.md | New ID is immutable (no renumber/reuse) |
| AC has no ID at all | Assign new AC-xxx ID | New ID is immutable |
| AC ID has gaps (e.g., AC-F01-001, AC-F01-003, skipping 002) | Preserve gaps | ✅ Gaps are allowed per acceptance-id-protocol.md |
| Two ACs share the same ID | Assign new ID to the duplicate; record in progress.md | Original ID preserved for first occurrence; new ID for duplicate |
| AC ID format correct but content changed from previous version | Assign new ID; mark old ID as `superseded` with pointer to new ID | Per acceptance-id-protocol.md supersede rules |
