---
name: performance-optimization
description: Performance Optimization — measure→identify→fix→verify→guard closed loop
---
# Performance Optimization — Performance Optimization

## When to use
- When the user reports a performance issue
- When performance benchmarks are not met
- During the optimize loop of LOOP
- When frontend Web Vitals metrics degrade

## Inputs
- loops/LOOP.md
- loops/STATE_PROTOCOL.md
- loops/state.schema.json
- rules/security.md
- constitution.md
- docs/product/PROJECT.md
- docs/engineering/TECH_STACK.md

## Outputs
- `loops/specs/<feature>/state.yaml` (stage/iteration/error)
- per-attempt terminal outcome in `iterations.log` (written by this skill's inline verify-fast)
- benchmark data and re-measurement evidence returned to verify for `evidence.md`

## Iron Rule
**Measure before optimize.** Optimization without profile data is guessing, and guessing leads to premature optimization — adding complexity without improving the real problem.

## Loop Type
This skill corresponds to the **optimize** loop in LOOP.md: a maximum of 3 iterations; the stop condition is meeting the benchmark.

## Process

### 1. MEASURE — Establish a baseline
No numbers, no optimization. Measure first, change later.

**Optimization target source**: Read the "non-functional requirements" field of `docs/product/PROJECT.md` as the optimization target baseline (e.g. P95 < 200ms). If PROJECT.md has no explicit performance requirements, confirm the target with the user before starting.

**Backend/General**:
- Use the project's existing benchmark command (read `docs/engineering/TECH_STACK.md` to confirm)
- No benchmark → use the `time` command or the language's built-in profiler on the critical path
- Record: QPS / latency (P50/P95/P99) / memory / CPU

**Frontend** (if applicable):
- Lighthouse (Synthetic): Performance score + LCP / CLS / INP
- web-vitals (RUM, if integrated): real user data
- Bundle size: record the gzipped size after `npm run build`

**Performance budget reference** (not hard requirements, for comparison):
- JS bundle: < 200KB gzipped
- LCP: ≤ 2.5s
- INP: ≤ 200ms
- CLS: ≤ 0.1

Keep the baseline command, environment, and numbers as structured results for verify; verify writes evidence.md.

### 2. IDENTIFY — Locate the real bottleneck
**Only fix bottlenecks confirmed by measurement, not places where "I think it's slow".**

- Use profiler output to find hotspots (most time-consuming functions / slowest-rendering components / slowest SQL)
- Use a symptom tree to locate: which layer is slow? (network / DB / compute / render)
- Bisection verification: comment out the suspected module; did performance improve?

Common bottleneck quick reference:
- DB: N+1 queries, missing indexes, full table scans
- Frontend: long unpaged lists, images without `loading="lazy"`, missing `width/height` causing CLS
- Compute: deeply nested loops, repeated computation that can be cached
- Network: uncompressed, uncached, too many serial requests

### 3. FIX — Change only this one bottleneck
- Change only one bottleneck at a time (changing multiple makes it impossible to tell which one worked)
- Changes follow the surgical changes principle — touch only the code that must be touched
- Do not opportunistically refactor unrelated code (that's refactor's job)

### 4. Return Domain Verification Data
- Re-measure using the **same** method as in step 1
- Show before/after comparison numbers:
  ```
  ## Performance Comparison
  | Metric | Before | After | Improvement |
  |------|--------|-------|------|
  | P95 latency | 850ms | 320ms | -62% |
  | Bundle size | 340KB | 185KB | -46% |
  ```
- Run the full test suite and confirm **no behavioral regression** (performance optimization is a subset of refactor; behavior is unchanged)
- Numbers did not improve → return to IDENTIFY and re-locate (you may have fixed the wrong bottleneck)

### 4.5. Inline Verify-Fast (merged)

- **Validate tests + benchmark re-measurement**: reuse the exact output from step 4 only when produced in the same execution context and neither command, code, nor attempt changed; otherwise rerun. Reject `0 tests`, stale output, or different commands.
- **AC/DAC check**: every stable AC/DAC for this task has evidence; frontend tasks reference contract/binding by stable component ID.
- **Changed-file security scan**: quick scan on changed files and disposition every hit (cite `verify/Reference/security-patterns.md` Patterns 1-3).
- **Append terminal outcome**: append exactly one PASSED/FAILED line to `iterations.log`; do not append a second attempt record.

Pass → `stage: verify, status: running, clear error`. Fail → `stage: verify, status: retrying, concrete error`. Numbers did not improve → return to IDENTIFY (domain-specific route, not a retry). At the recommended failed-attempt limit (3 for optimize), set `needs-human`. Never increment during failure handling.

### 5. GUARD — Prevent regression
- Add regression tests or monitoring to prevent performance regression:
  - Backend: include benchmarks in CI
  - Frontend: bundle size check / Lighthouse CI
- If the project has no CI infrastructure, return "recommend adding monitoring" to verify for evidence

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "This optimization definitely works" | You only know after you change and measure; change one then measure |
| "Adding React.memo can't hurt" | Overuse is as bad as underuse; profile proves it's needed |
| "The user's machine shouldn't be slow" | Your machine is not the user's machine; test on a representative environment |

## State Maintenance

Follow `.harness/loops/STATE_PROTOCOL.md`: increment once before mutation; the ACT skill appends the per-attempt terminal outcome via inline verify-fast; verify owns `evidence.md` (full verification only).

## Prohibitions
- Changing without measuring (guess-based optimization)
- Changing multiple bottlenecks at once (cannot attribute)
- Not running tests after optimization (behavioral regression is worse than the performance issue)
- Optimizing without guarding (performance will silently regress)
- Overusing memo/useMemo/cache (adds complexity without measured benefit)

## Relationship with LOOP

Corresponds to the optimize loop: MEASURE/IDENTIFY = PLAN, FIX = ACT, re-measurement data returns to verify, GUARD never mutates a task after `done`. See `.harness/loops/LOOP.md`.

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| systematic-debugging | Root cause analysis of performance issues (when the bottleneck is not obvious) |
