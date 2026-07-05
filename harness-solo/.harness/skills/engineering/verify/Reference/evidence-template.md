# Evidence Template — Reference

The full structure of `loops/specs/<feature>/evidence.md`. Follow this layout verbatim; the Agent and downstream reviewers (code-review, harness-pm) parse these sections by heading.

## Template

```markdown
# Verification Evidence

## Time
YYYY-MM-DD HH:MM

## 1. Test Results
$ <command>
<actual output>

## 2. Acceptance Criteria
### Engineering AC
- AC-F01-001: ✓ ...
- AC-F01-002: ✓ ...

### Design AC (if frontend is involved)
- DAC-P01-001: ✓ ...
- DAC-002: ...
(If there is no design-to-solo.md, fill in "no design AC")

## 3. Constitution Compliance
- [x] Zero new dependencies
- [x] APIs have tests
- [x] Migration scripts

## 4. Security Scan
Method: Agent Grep scan / optional bash security-check.sh
<actual output, listing the patterns scanned and hits>

## 5. Entropy Check
Method: Agent Glob+Read statistics / optional bash entropy-check.sh
<actual output or "skipped">

## 6. Frontend Verification (if involved)
Method: invoke webapp-testing skill
<actual output or "no frontend code changes, skipped">

## 7. Documentation
- README.md updated (if user-facing behavior changed): <yes/no — n/a if no user-facing change>
- API docs updated (if public API changed): <yes/no — n/a if no public API change>
- Component spec updated (if component contract changed): <yes/no — n/a if no contract change>
```

## Section-by-Section Instructions

### Time
Use the local timezone. Write the wall-clock time at the moment you start writing evidence, not when the verify run began. Format: `YYYY-MM-DD HH:MM` (24-hour, no seconds).

### 1. Test Results
- Paste the **exact** test command you ran after the `$ ` prompt, then the actual stdout/stderr below it.
- Include the failure summary if any test failed. Do not summarize as "all green" — paste the runner's own summary line (e.g. `Tests: 12 passed, 12 total`).
- If the runner emits more than 200 lines, paste the tail that contains the summary plus any failing assertions; do not paste the whole log.
- Truncation must be marked with `... (N lines truncated)`.

### 2. Acceptance Criteria
- Use one line per AC. Mark `✓` only if you can cite a specific test, assertion, or demo output. Mark `✗` and write the reason otherwise.
- Engineering ACs come from `spec.md`'s `AC-xxx` lines; Design ACs come from `spec.md`'s `DAC-xxx` lines (originally flowed in from `docs/handoff/design-to-solo.md`).
- If `design-to-solo.md` does not exist, write `no design AC` under the Design AC heading — do not delete the heading.
- For Design ACs, cite the verification method: `contrast 4.8:1 ≥ 4.5:1, verified with axe-core`, `no overflow at 375px viewport, screenshot in evidence`.
- A design AC that cannot be verified at the engineering layer is marked `needs harness-design review` (not `✗`).

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

## Time
2026-03-14 09:42

## 1. Test Results
$ npm test -- --run
> harness-solo@1.0.0 test
> vitest run

 ✓ src/auth/login.test.ts (3 tests) 4ms
 ✓ src/auth/token.test.ts (2 tests) 3ms
Test Files  2 passed (2)
     Tests  5 passed (5)

## 2. Acceptance Criteria
### Engineering AC
- AC-F01-001: ✓ login() returns token within 200ms (src/auth/login.test.ts:14)
- AC-F01-002: ✓ token refresh extends expiry by 60min (src/auth/token.test.ts:22)

### Design AC (if frontend is involved)
no design AC

## 3. Constitution Compliance
- [x] Zero new dependencies (package.json unchanged)
- [x] APIs have tests — login(), refreshToken()
- [x] Migration scripts — n/a — no schema changes

## 4. Security Scan
Method: Agent Grep scan
- Pattern 1 — Secret Leakage: scanned src/auth/*.ts, 0 hits
- Pattern 2 — Hardcoded Credentials: scanned src/auth/*.ts, 0 hits
- Pattern 3 — Dangerous Shell Commands: scanned src/auth/*.ts, 0 hits
- Pattern 4 — .gitignore: read .gitignore; .env, node_modules/, dist/ all present

## 5. Entropy Check
Method: Agent Glob+Read statistics
- files: current 142, baseline 140, growth 1.4% — OK
- loc: current 8421, baseline 8200, growth 2.7% — OK
- deps: 0 new (baseline 18, current 18) — OK
- TODO/FIXME: 4 (baseline 4) — OK

## 6. Frontend Verification (if involved)
no frontend code changes, skipped

## 7. Documentation
- README.md updated: n/a — no user-facing change
- API docs updated: n/a — no public API change
- Component spec updated: n/a — no contract change
```

## What NOT to write

- `should pass` — the Iron Rule forbids it.
- `theoretically working` — theories are not evidence.
- `I believe the tests pass` — belief is not output.
- `no problem found` without listing what you checked — the reader cannot audit a blank check.
- Truncated test output without a truncation marker — readers cannot tell whether content was elided.
