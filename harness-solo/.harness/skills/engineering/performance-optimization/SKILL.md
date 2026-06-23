---
name: performance-optimization
description: Performance Optimization — measure→identify→fix→verify→guard closed loop
triggers:
  - When the user reports a performance issue
  - When performance benchmarks are not met
  - During the optimize loop of LOOP
  - When frontend Web Vitals metrics degrade
reads:
  - loops/LOOP.md
  - rules/security.md
  - constitution.md
  - docs/product/PROJECT.md
  - docs/engineering/TECH_STACK.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/evidence.md
  - loops/specs/<feature>/iterations.log
---

# Performance Optimization — Performance Optimization

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

Write the baseline numbers into evidence.md.

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

### 4. VERIFY — Measure again and confirm the improvement
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

### 5. GUARD — Prevent regression
- Add regression tests or monitoring to prevent performance regression:
  - Backend: include benchmarks in CI
  - Frontend: bundle size check / Lighthouse CI
- If the project has no CI infrastructure, record "recommend adding monitoring" in evidence.md

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "I think it's slow here" | Your feeling is not evidence; profile first |
| "It should be faster after optimization" | "Should" is not evidence; measure again and compare |
| "This optimization definitely works" | You only know after you change and measure; change one then measure |
| "Adding React.memo can't hurt" | Overuse is as bad as underuse; profile proves it's needed |
| "The user's machine shouldn't be slow" | Your machine is not the user's machine; test on a representative environment |

## State Maintenance

Update per the "state.yaml Schema" in LOOP.md:
- `stage`: `act` (FIX phase) / `verify` (VERIFY phase)
- `iteration`: +1 (per MEASURE→FIX→VERIFY cycle)
- `last_error`: on failure, fill in "metric did not improve: <details>"

**Update iterations.log (append only, overwriting is forbidden)**:
```
[YYYY-MM-DD HH:MM] iter=<N> stage=verify → P95 850ms→320ms ✓
```

## Prohibitions
- Changing without measuring (guess-based optimization)
- Changing multiple bottlenecks at once (cannot attribute)
- Not running tests after optimization (behavioral regression is worse than the performance issue)
- Optimizing without guarding (performance will silently regress)
- Overusing memo/useMemo/cache (adds complexity without measured benefit)

## Relationship with LOOP
This skill corresponds to the optimize loop of LOOP:
- MEASURE/IDENTIFY = PLAN (locate the problem)
- FIX = ACT (change code)
- VERIFY = VERIFY (compare numbers + no test regression)
- GUARD = post-DONE protection

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| performance-optimization | measure→identify→optimize→verify closed loop |
| tdd | Behavioral protection during optimization (tests must not regress) |
| verify | Comprehensive verification after optimization |
| systematic-debugging | Root cause analysis of performance issues (when the bottleneck is not obvious) |
