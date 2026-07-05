# Evidence Template — Reference

The full structure of `loops/specs/<feature>/evidence.md`. Follow this layout verbatim; the Agent and downstream reviewers (code-review, harness-pm) parse these sections by heading.

> **Multi-phase evidence**: each phase (0/1/2/3) appends its own evidence block to this file. Do NOT overwrite previous phase evidence — use a phase-scoped `## Phase N` heading and continue below the prior phase's block.

## Template

```markdown
# Verification Evidence

## Phase 0 — design-intake
### Time
YYYY-MM-DD HH:MM

### 1. Test Results
$ <command>
<actual output>

### 2. Acceptance Criteria
#### Product AC (Phase 0 scope)
- AC-F01-001: ✓ ...
- AC-F01-002: ✓ ...

### 3. Constitution Compliance
- [x] Zero new dependencies
- [x] APIs have tests
- [x] Migration scripts

### 4. Security Scan
Method: Agent Grep scan / optional bash security-check.sh
<actual output, listing the patterns scanned and hits>

### 5. Entropy Check
Method: Agent Glob+Read statistics / optional bash entropy-check.sh
<actual output or "skipped">

### 6. Frontend Verification (if involved)
Method: invoke webapp-testing skill
<actual output or "no frontend code changes, skipped">

### 7. Documentation
- README.md updated (if user-facing behavior changed): <yes/no — n/a if no user-facing change>
- API docs updated (if public API changed): <yes/no — n/a if no public API change>
- Component spec updated (if component contract changed): <yes/no — n/a if no contract change>

## Phase 1 — frontend
### Time
YYYY-MM-DD HH:MM
### 1. Test Results
$ <command>
<actual output>
### 2. Acceptance Criteria
#### Product AC (Phase 1 scope)
- AC-F01-001: ✓ ...
#### Frontend component contract compliance
- contract.json#CMP-XXX: ✓ component implemented, token refs verified
(If no frontend ACs apply, fill in "no frontend AC in this phase")

## Phase 2 — backend
### Time
YYYY-MM-DD HH:MM
### 1. Test Results
$ <command>
<actual output>
### 2. Acceptance Criteria
#### Backend AC (produced in Phase 2)
- BAC-F01-001: ✓ POST /todos returns 201 (src/api/todos.test.ts:14)
- BAC-F01-002: ✓ GET /todos/:id returns 404 for unknown id (src/api/todos.test.ts:22)
(If no backend ACs apply, fill in "no backend AC in this phase")

## Phase 3 — integration
### Time
YYYY-MM-DD HH:MM
### 1. Test Results
$ <command>
<actual output>
### 2. Acceptance Criteria
#### Integration AC (produced and verified in Phase 3)
- IAC-F01-001: ✓ E2E create-todo flow passes (manual trace + contract-verify output)
- IAC-F01-002: ✓ mock→real switch succeeds without business-code edits
(If no integration ACs apply, fill in "no integration AC in this phase")
```

## Section-by-Section Instructions

### Phase headings
- Each of the 4 phases (0/1/2/3) appends its own evidence block under a `## Phase N — <name>` heading.
- Do NOT overwrite evidence from prior phases — later phases build on earlier evidence.
- A phase with no work in this feature writes `no work in this phase` under its heading and keeps the heading.

### Time
Use the local timezone. Write the wall-clock time at the moment you start writing evidence, not when the verify run began. Format: `YYYY-MM-DD HH:MM` (24-hour, no seconds).

### 1. Test Results
- Paste the **exact** test command you ran after the `$ ` prompt, then the actual stdout/stderr below it.
- Include the failure summary if any test failed. Do not summarize as "all green" — paste the runner's own summary line (e.g. `Tests: 12 passed, 12 total`).
- If the runner emits more than 200 lines, paste the tail that contains the summary plus any failing assertions; do not paste the whole log.
- Truncation must be marked with `... (N lines truncated)`.

### 2. Acceptance Criteria
- Use one line per AC. Mark `✓` only if you can cite a specific test, assertion, or demo output. Mark `✗` and write the reason otherwise.
- **Product ACs** (`AC-xxx`) come from `spec.md`'s `AC-xxx` lines; produced by PM, verified across phases.
- **Backend ACs** (`BAC-xxx`) come from `spec.md`'s `BAC-xxx` lines; produced by api-implementation / data-layer in Phase 2, verified by Phase 3.
- **Integration ACs** (`IAC-xxx`) come from `spec.md`'s `IAC-xxx` lines; produced and verified by mock-to-real-switch / contract-verify / e2e-verification in Phase 3.
- If no ACs apply in a phase, write `no <phase> AC in this phase` under the heading — do not delete the heading.
- An AC that cannot be verified at the current layer is marked `needs <next-phase> verification` (not `✗`).

### 3. Constitution Compliance
- One checkbox per clause in `constitution.md`. Use `[x]` for satisfied, `[ ]` for not satisfied, and append a reason after any `[ ]`.
- "Zero new dependencies" must reflect the actual `git diff` of lockfiles, not your memory.
- "APIs have tests" must list each new public API and the test file that covers it.
- "Migration scripts" must reference the migration filename if a schema change was made, or write `n/a — no schema changes` if none.

### 4. Security Scan
- Record the method used (`Agent Grep scan` or `bash security-check.sh`).
- For each pattern scanned, list: pattern identifier, files scanned, hits, and disposition per hit.
- See `Reference/security-patterns.md` for the pattern catalog and reporting format.
- A line that says only `security scan passed` violates the Iron Rule.

### 5. Entropy Check
- Record the method used (`Agent Glob+Read statistics` or `bash entropy-check.sh`).
- Paste the actual numbers: current file count, baseline file count, growth %; current loc, baseline loc, growth %; new deps list; TODO/FIXME count.
- If the entropy check was skipped, write `skipped — <reason>` (e.g. `skipped — no baseline.json present`).
- See `Reference/entropy-baseline.md` for the schema and thresholds.

### 6. Frontend Verification
- Only present if frontend code (`.tsx` / `.vue` / `.svelte` / `.html` / `.css`) was changed in this iteration.
- Record that you invoked the `webapp-testing` skill and paste its summary output: build result, type check result, lint result, structural verification, frontend security.
- If no frontend code was changed, write `no frontend code changes, skipped` — do not delete the heading.

### 7. Documentation
- Verify documentation alignment for every user-facing, API, or contract change made in this iteration.
- README.md: updated when user-facing behavior changed; write `n/a — no user-facing change` otherwise.
- API docs: updated when a public API changed; write `n/a — no public API change` otherwise.
- Component spec: updated when the component contract changed; write `n/a — no contract change` otherwise.
- Do not delete the heading even if all items are `n/a`.

## Sample Evidence

```markdown
# Verification Evidence

## Phase 0 — design-intake
### Time
2026-03-14 09:42

### 1. Test Results
$ npx stylelint tokens.css
> 0 problems

### 2. Acceptance Criteria
#### Product AC (Phase 0 scope)
no product AC verified in this phase

### 3. Constitution Compliance
- [x] Zero new dependencies (package.json unchanged)
- [x] APIs have tests — n/a — no API changes in Phase 0
- [x] Migration scripts — n/a — no schema changes

### 4. Security Scan
Method: Agent Grep scan
- Pattern 1 — Secret Leakage: scanned docs/handoff/contract.json, 0 hits

### 5. Entropy Check
Method: Agent Glob+Read statistics
- files: current 142, baseline 140, growth 1.4% — OK

### 6. Frontend Verification (if involved)
no frontend code changes, skipped

### 7. Documentation
- README.md updated: n/a — no user-facing change
- API docs updated: n/a — no public API change
- Component spec updated: yes — contract.json produced

## Phase 2 — backend
### Time
2026-03-14 11:15

### 1. Test Results
$ npm test -- --run
> harness-engineering@3.0.0 test
> vitest run

 ✓ src/api/todos.test.ts (3 tests) 4ms
Test Files  1 passed (1)
     Tests  3 passed (3)

### 2. Acceptance Criteria
#### Backend AC (produced in Phase 2)
- BAC-F01-001: ✓ POST /todos returns 201 (src/api/todos.test.ts:14)
- BAC-F01-002: ✓ GET /todos/:id returns 404 for unknown id (src/api/todos.test.ts:22)

## Phase 3 — integration
### Time
2026-03-14 14:30

### 1. Test Results
$ npm test -- --run
> vitest run
 ✓ src/integration/e2e.test.ts (2 tests) 8ms
Test Files  1 passed (1)
     Tests  2 passed (2)

### 2. Acceptance Criteria
#### Integration AC (produced and verified in Phase 3)
- IAC-F01-001: ✓ E2E create-todo flow passes (src/integration/e2e.test.ts:5)
- IAC-F01-002: ✓ mock→real switch succeeds without business-code edits (contract-verify output)
```

## What NOT to write

- `should pass` — the Iron Rule forbids it.
- `theoretically working` — theories are not evidence.
- `I believe the tests pass` — belief is not output.
- `no problem found` without listing what you checked — the reader cannot audit a blank check.
- Truncated test output without a truncation marker — readers cannot tell whether content was elided.
- Overwriting prior-phase evidence — each phase appends, never overwrites.
