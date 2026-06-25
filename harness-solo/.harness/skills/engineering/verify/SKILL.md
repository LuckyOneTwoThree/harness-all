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
- docs/handoff/pm-to-solo.md
- docs/handoff/design-to-solo.md
- docs/handoff/component-map.json
- loops/specs/<feature>/spec.md

## Outputs
- loops/specs/<feature>/evidence.md
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/iterations.log

## Iron Rule
**No claiming completion without evidence.** "Should have passed" is not evidence; you must show the actual output.

## Process

### 1. Test Pass Check
Run the project's test command and **show the full output** (not just the four words "tests passed"):
```bash
<the project's test command>
```
- All pass → continue
- Any failure → write to state.yaml's last_error and return to tdd

### 2. Acceptance Criteria Item-by-Item Check
Read the AC-xxx and DAC-xxx in spec.md and check item by item (both sources):

**Engineering ACs** (from spec.md's AC-xxx):
```
## Acceptance Criteria - Engineering AC
- AC-001: ✓ <how it is satisfied, citing a test or demo>
- AC-002: ✓ <how it is satisfied>
- AC-003: ✗ <not satisfied, reason>
```

**Design ACs** (from spec.md's DAC-xxx, flowed in from design-to-solo.md):
```
## Acceptance Criteria - Design AC
- DAC-001: ✓ <how it is satisfied, e.g. "contrast 4.8:1 ≥ 4.5:1, verified with axe-core">
- DAC-002: ✓ <how it is satisfied, e.g. "no overflow at 375px viewport, screenshot in evidence">
- DAC-003: ✗ <not satisfied, reason>
```

**Design AC check methods**:
- Visual (contrast/spacing/font size) → compare against design token values, or use browser DevTools
- Responsive (breakpoints/overflow) → use webapp-testing's responsive tests
- Interaction (hover/focus/animation) → manual demo or E2E test
- If a design AC cannot be verified at the engineering layer (e.g. pure visual feel), mark it as "needs harness-design review"

- All ✓ → continue
- Any ✗ → return to tdd to add the implementation (engineering AC) or feed back to harness-design (when the design AC is unreasonable)

### 3. Constitution Compliance Check
Read constitution.md and check item by item:
- [ ] Are unapproved new dependencies introduced? (see the approval flow in the `dependency-management` skill)
- [ ] Do new APIs have tests?
- [ ] Do schema changes have migration scripts? (see the `migration` skill)
- [ ] Other project-specific clauses

### 4. Security Scan (mandatory, cross-platform)

**Method A (recommended; the Agent uses tools, no bash dependency)**:

Following the checklist in `rules/security.md`, the Agent uses tools to scan the files changed in this change:

- **Secret leakage**: use Grep to search for sensitive patterns in changed files:
  ```
  (sk-|api[_-]?key|secret|password|token|AKIA|ghp_)[=:]\s*['"]?[A-Za-z0-9+/=_-]{16,}
  ```
  Hit → mark as leakage; must fix and re-verify

- **Hardcoded credentials**: use Grep to search for IPs/DB connection strings/private key headers:
  ```
  BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|mongodb://|postgres://|redis://.*:.*@
  ```

- **Dangerous commands**: use Grep to search for `rm -rf|curl.*\|.*sh|wget.*\|.*sh`

- **.gitignore check**: use Read to read .gitignore and confirm .env / node_modules / dist etc. are ignored

**Method B (optional script fallback)**:
If bash is available in the current environment, you may run:
```bash
bash .harness/scripts/security-check.sh
```
The script logic is the same as Method A, as an optional fallback. **On Windows or in environments without bash, you must use Method A.**

**Show the full output**; do not just write "security check passed".
- Pass → continue
- Fail → fix and re-verify

### 5. Entropy Check (optional, cross-platform)

**Method A (recommended; the Agent uses tools)**:

Read `.harness/memory/baseline.json` (written by the last session-end) and compare against current metrics:

- **files growth rate**: use Glob to count the current number of source files and compare against baseline.files
  - Growth > 20% and absolute value > 50 → WARN (possible file explosion)
- **loc growth rate**: use Read to sum the current lines of code and compare against baseline.loc
  - Growth > 50% → WARN (possible over-implementation)
- **deps growth**: read the dependency list and compare against baseline.deps
  - More than 3 new → WARN (possible dependency bloat)
- **todos backlog**: use Grep to search for TODO/FIXME
  - Count > 20 or growth > 50% over baseline → WARN (tech debt accumulating)

**Method B (optional script fallback)**:
If bash is available in the current environment, you may run:
```bash
bash .harness/scripts/entropy-check.sh
```

If there are WARNs, evaluate whether to refactor before delivery.

### 6. Frontend Verification (if frontend code is involved)
Use Glob to scan the files changed in this change; if they include `*.tsx` / `*.vue` / `*.svelte` / `*.html` / `*.css`, invoke the `webapp-testing` skill for frontend-specific verification:
- Build verification (mandatory)
- Type check (if TypeScript)
- Lint check (if any)
- Structural verification (components/accessibility/routing)
- Frontend security (XSS / hardcoded addresses)

Merge the results into the "Frontend Verification" section of evidence.md. If there are no frontend code changes, skip this step.

### 7. Write Evidence
Summarize the actual output of the above 6 items into evidence.md:
```markdown
# Verification Evidence

## Time
YYYY-MM-DD HH:MM

## 1. Test Results
$ <command>
<actual output>

## 2. Acceptance Criteria
### Engineering AC
- AC-001: ✓ ...
- AC-002: ✓ ...

### Design AC (if frontend is involved)
- DAC-001: ✓ ...
- DAC-002: ✓ ...
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
```

### 8. Update State
Update per the "state.yaml Schema" in `loops/LOOP.md`:
- `stage`: `verify`
- `status`: `done` (all pass) or `retrying` (any failure)
- `last_error`: clear to "" on success; fill in error description on failure

For full field definitions and write responsibilities, see LOOP.md.

**Update iterations.log (must append, overwriting is forbidden)**:
- Tool approach: first Read the current iterations.log → append the new line → Write it back
- Or terminal command: `echo "[YYYY-MM-DD HH:MM] iter=<N> stage=verify → PASSED" >> .harness/loops/specs/<feature>/iterations.log`
- Do not use Write to overwrite iterations.log directly (it would erase historical iteration records)

```
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → PASSED
```

## Prohibitions
- Skipping any check
- Writing only "passed" without showing the actual output (violates the iron rule)
- Claiming completion while tests fail
- Saying "no problem" without running the security scan
- Skipping frontend verification when frontend code is involved (step 6)

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
