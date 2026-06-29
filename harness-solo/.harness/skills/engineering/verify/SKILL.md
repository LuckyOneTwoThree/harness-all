---
name: verify
description: Delivery Verification — mandatory comprehensive check before claiming completion
---
# Verify — Delivery Verification

## When to use
- Before claiming a task is complete (mandatory)
- During the VERIFY phase of LOOP
- Before merge/push

## Inputs
- loops/LOOP.md
- rules/security.md
- constitution.md
- docs/handoff/pm-to-solo.md (optional, conditional on upstream handoff)
- docs/handoff/design-to-solo.md (optional, conditional on upstream handoff)
- docs/handoff/component-map.json (optional, conditional on upstream handoff)
- docs/handoff/tokens.json (optional, conditional on design handoff)
- docs/handoff/tokens.css (optional, conditional on design handoff)
- loops/specs/<feature>/spec.md
- Reference/security-patterns.md
- Reference/evidence-template.md
- Reference/entropy-baseline.md

## Outputs
- loops/specs/<feature>/evidence.md
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/iterations.log

## Iron Rule
**No claiming completion without evidence.** "Should have passed" is not evidence; you must show the actual output.

## Process

## Two-Layer Verification

Verification runs at two points in the LOOP cycle:

1. **verify-fast** (inside LOOP, per iteration): 3 steps — tests + AC + quick security scan
   - Purpose: catch regressions quickly without overhead of full checks
   - Trigger: after each tdd Red→Green→Refactor cycle
   - Pass → continue to next task or exit LOOP
   - Fail → back to tdd

2. **verify-full** (after LOOP exits, before code-review): 9 steps — full comprehensive check
   - Purpose: final gate before claiming feature complete
   - Trigger: all tasks in spec.md done + verify-fast passed
   - Pass → enter code-review
   - Fail → back to LOOP

### verify-fast (per iteration, 3 steps)

### Fast 1. Test Pass Check
Run the project's test command and **show the full output** (not the four words "tests passed"). All pass → continue. Any failure → write to `state.yaml`'s `last_error` and return to tdd.

### Fast 2. Acceptance Criteria Check
Check each `AC-xxx` (and `DAC-xxx` if present) for the current task item by item. Mark `✓` only when you can cite a specific test, assertion, or demo. Component contract check (if `Contract:` lines exist): cross-check props/states/engineeringComponent against `component-map.json`.

### Fast 3. Quick Security Scan
Grep the changed files for `password|secret|api_key|token|rm -rf` patterns. **Show the hits and dispositions.** No hits → continue. Hits → continue only after disposition.

---

### verify-full (LOOP exit gate)

Run all nine steps in order. Each step is summarized below; the Reference files carry the canonical detail.

### Full 1. Test Pass Check
Run the project's test command and **show the full output** (not the four words "tests passed"). All pass → continue. Any failure → write to `state.yaml`'s `last_error` and return to tdd. Paste the runner's own summary line into evidence.

### Full 2. Acceptance Criteria Item-by-Item Check
Read every `AC-xxx` (engineering, from `spec.md`) and `DAC-xxx` (design, flowed in from `design-to-solo.md`) and check each one. Mark `✓` only when you can cite a specific test, assertion, or demo; mark `✗` with a reason otherwise. Design ACs that cannot be verified at the engineering layer are marked `needs harness-design review`, not `✗`. All `✓` → continue. Any `✗` → return to tdd (engineering AC) or feed back to harness-design (design AC).

**Component contract check (frontend tasks only)**: if `spec.md` contains tasks with `Contract: component-map.json#<Component>` lines, for each such component cross-check the implemented code against `docs/handoff/component-map.json`:
- Every prop in the contract's `props` object is accepted by the component (no missing/extra props).
- Every state in the contract's `states` array is handled (default/hover/active/disabled/loading etc.).
- The `engineeringComponent` name matches the actual code component name.
A mismatch is a `✗` with reason `contract drift: <field> mismatch`. This check is in addition to AC/DAC — the ACs may pass while the component silently drifts from the contract (e.g., missing `loading` state that no AC explicitly covers).

### Full 3. Constitution Compliance Check
Read `constitution.md` and check item by item: unapproved new dependencies, APIs without tests, schema changes without migration scripts, plus any project-specific clauses. Use the actual `git diff` of lockfiles — do not rely on memory.

### Full 4. Security Scan (mandatory, cross-platform)
Use Method A (Agent-driven Grep/Read; works on Windows) or Method B (optional `bash .harness/scripts/security-check.sh`). Scope every pattern to the files changed in this iteration. Apply the false-positive rules before escalating any hit. **Show the actual hits and dispositions**; do not write only "security scan passed". For the full pattern catalog, hit policies, and false-positive guidance, see `Reference/security-patterns.md`.

### Full 5. Entropy Check (cross-platform)
Read `.harness/memory/baseline.json` and compare current metrics (files, loc, deps, TODO/FIXME) against the baseline. Apply the WARN/FAIL thresholds: `files` growth > 20% AND absolute delta > 50; `loc` growth > 50%; `deps` more than 3 new (WARN) or 6 new (FAIL); `todos` count > 20 or growth > 50% (WARN), > 50 (FAIL). Method A uses Glob/Read/Grep; Method B uses `bash .harness/scripts/entropy-check.sh`. On Windows you must use Method A. For the schema, threshold derivation, and skip rules, see `Reference/entropy-baseline.md`.

### Full 6. Frontend Verification (if frontend code is involved)
Use Glob to scan the files changed in this iteration. If any match `*.tsx` / `*.vue` / `*.svelte` / `*.html` / `*.css`, invoke the `webapp-testing` skill for build, type check, lint, structural, and frontend-security verification. Merge the results into the "Frontend Verification" section of evidence.md. If no frontend code was changed, write `no frontend code changes, skipped` and move on.

### Full 7. Token Compliance Check (if design tokens exist)
If `docs/handoff/tokens.json` or `docs/handoff/tokens.css` exists, scan the frontend files changed in this iteration for hardcoded values that should use design tokens:

- **Color values**: Grep for `#[0-9a-fA-F]{3,8}\b` and `rgb\(` / `rgba\(` in changed `*.tsx` / `*.vue` / `*.svelte` / `*.html` / `*.css` files. Compare hits against `tokens.json` color tokens. Any color not in tokens → `✗` with reason `hardcoded color: <value> (use token: <suggested-token>)`.
- **Spacing values**: Grep for `\b\d+px\b` / `\b\d+rem\b` in changed style/code files. Compare against spacing tokens. Exceptions: `0px` / `0rem` (always allowed), values inside `calc()` expressions (allowed if operands are tokens). Any spacing not in tokens → `✗` with reason `hardcoded spacing: <value>`.
- **Font sizes**: Grep for `font-size:` declarations. Compare against type scale tokens. Any font-size not in tokens → `✗`.

If no tokens files exist, write `no design tokens found, skipped` and move on. Show the actual hits and dispositions — do not write only "token check passed".

### Full 8. Write Evidence
Summarize the actual output of steps 1–7 into `evidence.md` using the canonical template. Every section heading must be present even when the answer is `skipped` or `n/a`. For the full template, section-by-section instructions, and a worked sample, see `Reference/evidence-template.md`.

### Full 9. Update State
Update `state.yaml` per the schema in `loops/LOOP.md`: `stage: verify`, `status: done` (all pass) or `retrying` (any failure), `last_error: ""` on success or the error description on failure. Append (never overwrite) a line to `iterations.log`:
```
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → PASSED
```

## Red Flags — stop on sight
Any of the following means the verify run is invalid; stop and reconcile before continuing:
- Test output reports `0 tests` or `no tests found` — the suite did not actually run.
- `evidence.md` contains `should pass`, `theoretically`, `I believe`, or `no problem` without supporting output.
- `git diff` touches 5+ files that have no relationship to the spec being verified.
- An AC is marked `✓` but no test, assertion, or demo output is cited next to it.
- The security scan reports a secret-leakage hit and you continue without resolving or documenting its disposition.
- `state.yaml` is updated without reading its current raw content first.

## Anti-Rationalization Table

| Shortcut taken | Rationalization | Why it fails |
|----------------|-----------------|--------------|
| Skip the security scan | "This project has no sensitive data." | You do not know what you do not scan; leakage is found by scanning, not by assumption. |
| Skip the entropy check | "The project is still small." | Small projects inflate too; early checks are cheapest, late discoveries are not. |
| Write "should pass" in evidence | "I ran it, it's fine." | "Should" is not evidence — paste the actual runner output and dispositions. |
| Pass an AC marked partially satisfied | "Most of it works." | Partial pass = partial fail; return to tdd until every AC is fully `✓` or explicitly deferred. |
| Update `state.yaml` from memory | "I remember the state." | Memory is unreliable and not auditable; read the raw file before writing. |
| Whitelist all security hits as false positives | "They are just fixtures." | Each hit requires an explicit disposition citing the file path and reason; blanket whitelisting hides real leaks. |
| Skip the component contract check because all ACs passed | "ACs are green, the component is fine." | ACs cover behavior; the contract covers props/states. A component can pass all ACs yet still drift from the contract (e.g., missing `loading` state no AC mentions). Contract drift surfaces only at integration, when it is expensive to fix. |

## Prohibitions
- Skipping any check.
- Writing only "passed" without showing the actual output (violates the Iron Rule).
- Claiming completion while tests fail.
- Saying "no problem" without running the security scan.
- Skipping frontend verification when frontend code is involved (step 6).
- Overwriting `iterations.log` instead of appending.

## Relationship with LOOP
This skill corresponds to the VERIFY phase of LOOP.
- tdd (ACT) → verify (VERIFY) → pass → may enter code-review
- tdd (ACT) → verify (VERIFY) → fail → systematic-debugging → return to tdd

## Division of Labor with Other Skills
| Skill | Responsibility | Timing |
|-------|------|------|
| tdd | Write tests, run tests | ACT phase |
| verify | Comprehensive verification (tests+AC+constitution+security+entropy) | VERIFY phase |
| code-review | Code quality review | After LOOP |
