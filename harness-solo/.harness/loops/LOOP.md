# LOOP.md — Loop Engine Definition + Verification Protocol

> Source: ospec (plan→act→verify) + loop-engineering CLI
> Purpose: replaces linear workflows with a closed-loop verification cycle
> Merges the original verification.md content

## Core Loop

```
┌──────────┐
│   PLAN   │ ← Define goal + acceptance criteria + constitution check
└────┬─────┘
     ▼
┌──────────┐
│   ACT    │ ← Execute (code / design / test)
└────┬─────┘
     ▼
┌──────────┐
│  VERIFY  │ ← Run tests + check acceptance criteria
└────┬─────┘
     │
     ├── Pass → DONE → record evidence
     │
     └── Fail → analyze cause
                   ├── Fixable → back to ACT
                   └── Re-planning needed → back to PLAN
```

## Loop Types

| Type | Trigger scenario | Max iterations | Stop condition |
|------|---------|---------|---------|
| **feature** | New feature development | 5 | All tests pass + AC met |
| **bugfix** | Bug fix | 3 | Reproduction test passes |
| **optimize** | Performance optimization | 3 | Benchmark meets target |
| **refactor** | Refactoring | 3 | No test regression |

## Cost Control

| Dimension | Limit | Action on limit exceeded |
|------|------|---------|
| Total loop count | 10 | **Hard circuit breaker**: write `hard_limit_reached: true` to state.yaml, set status to `failed`, **further looping is prohibited**, must request human intervention |

> **Hard circuit breaker execution rules (non-negotiable)**:
> 1. At every VERIFY phase, the Agent **must** read the `iteration` field from `state.yaml`
> 1.5. **VERIFY phase must mandatorily read the raw contents of state.yaml**: At every VERIFY, the Agent must use the Read tool to read the full contents of `state.yaml` to obtain the true iteration value. **Referencing the iteration value from contextual memory is prohibited** (to prevent skipping the circuit breaker check in a hallucinated state).
> 2. When the `iteration >= 10` read by the Read tool (must come from the raw file content, not a memory reference), the Agent **must** perform the following operations, without skipping:
>    - Change `status` to `failed`
>    - Write `hard_limit_reached` to `true`
>    - Write `last_error` as "Iteration limit exceeded (iteration >= 10), hard circuit breaker triggered"
>    - Report the breaker reason to the user and request human intervention
> 3. When `hard_limit_reached: true`, the Agent is **prohibited** from continuing any LOOP phase of the current task
> 4. Only after the user explicitly instructs "reset the circuit breaker" may the Agent change `hard_limit_reached` to `false` and reset `iteration`
>
> Token limits are monitored by the user in the IDE and are not part of framework rules (the Agent has no token counter).

**Semantic notes**:
- "Single LOOP" refers to the iteration count within the same feature/bugfix/optimize/refactor cycle
- Different features' LOOPs are independent tasks, counted separately (e.g., new-product-engineering's per-feature LOOPs each count separately)
- The max 5 (per loop type table) is a recommended upper bound; 10 is the hard circuit breaker threshold (5 < 10, leaving 5 iterations of tolerance)

## Specs Persistence

During the PLAN phase of each loop, write the spec to `loops/specs/<feature>/spec.md`.

## Evidence Tracking

Evidence from each VERIFY phase is written to `loops/specs/<feature>/evidence.md`.

**File write semantics distinction (important, to avoid confusion)**:

| File | Write semantics | Reason | How to operate |
|------|---------|------|---------|
| `spec.md` | Overwrite | Keep only the final passing spec | Write directly overwrites |
| `state.yaml` | Overwrite | Keep only the current state | Write directly overwrites |
| `evidence.md` | Overwrite | Keep only the final successful evidence | Write directly overwrites |
| `iterations.log` | **Append** | Preserve full iteration history | Read+concatenate+Write, or `echo >>` |

```
loops/specs/001-user-login/
├── spec.md          ← Feature spec (overwrite: final passing version)
├── state.yaml       ← Loop state (overwrite: current state)
├── evidence.md      ← Verification evidence (overwrite: final success)
└── iterations.log   ← Iteration history (append-only, full trajectory)
```

iterations.log example:
```
[2026-06-20 14:30] iter=1 stage=act → verify FAILED: test_login_empty_password
[2026-06-20 14:35] iter=2 stage=act → verify FAILED: test_login_invalid_token
[2026-06-20 14:40] iter=3 stage=verify → PASSED
```

Why designed this way?
  - spec.md / state.yaml / evidence.md overwrite → keep only the latest state, don't pollute context
  - iterations.log append-only → preserve full iteration history; you can see failure trajectories when debugging
  - All artifacts of a feature live in one directory → good cohesion, no need to search across directories

## Task Granularity

`<feature>` in `loops/specs/<feature>/` has three levels of granularity. Use the correct level based on the workflow:

| Granularity | Naming Pattern | Example | Used by workflow | State directory |
|-------------|----------------|---------|------------------|-----------------|
| Infrastructure-level | `<NNN>-infra-<module-name>` (standalone) / `<NNN>-<product-name>-infra-<module-name>` (nested under a product-level task) | `002-infra-api-client` / `002-shopping-app-infra-api-client` | new-feature (standalone infrastructure task), new-product-engineering Phase 1 (nested) | `loops/specs/002-infra-api-client/` / `loops/specs/002-shopping-app-infra-api-client/` |
| Feature-level | `<NNN>-<feature-name>` | `001-user-auth` | new-feature (feature task), new-product-engineering Phase 2 | `loops/specs/001-user-auth/` |
| Product-level | `<NNN>-<product-name>` | `001-shopping-app` | new-product-engineering | `loops/specs/001-shopping-app/` (product) + `loops/specs/001-shopping-app-auth/` (per feature) |

**Rules**:
- `<NNN>` is a zero-padded 3-digit sequence number, unique within the framework
- Product-level tasks nest per-feature tasks: product-level state.yaml tracks overall progress, per-feature state.yaml tracks feature progress
- On session resume for a product-level task: read product-level state.yaml first to find current feature, then read that feature's state.yaml for LOOP position
- Single-feature workflows (new-feature, bugfix, refactor, optimize) use feature-level or infrastructure-level; never product-level
- If a feature is part of a product-level task, its task name must include the product name prefix (e.g., `001-shopping-app-auth`, not just `002-auth`) to keep all features of one product grouped in directory listing

## State Maintenance

**Decision: The Agent reads and writes state.yaml (one file per feature, persisted to disk)**

`loops/specs/<feature>/state.yaml` is actively read and written by the tdd/verify/systematic-debugging skills during the loop:
  - Records the current iteration count, last failure reason, and current stage
  - Supports checkpoint resume after session interruption (read state.yaml to restore context)
  - The verify skill writes evidence anyway; writing one more state line has negligible cost
  - One file per feature naturally supports parallel front-end / back-end development

### state.yaml Schema (single source of truth; each SKILL.md references this section)

```yaml
# Required fields
current_task: <NNN>-<feature-name>   # Feature number + name, consistent with the directory name
iteration: <int>                         # Current iteration count, starts at 0, +1 per ACT→VERIFY cycle
stage: <enum>                            # Current stage, see enum table below
status: <enum>                           # Feature status, see enum table below
started_at: "<ISO 8601>"                 # Feature start time, e.g. "2026-06-20T14:30:00"

# Optional fields (filled on failure)
last_error: "<error description>"         # Most recent failure reason; cleared to "" on success
last_error_at: "<ISO 8601>"              # Most recent failure time

# Optional field (substage description, for multi-substage workflows like optimize/migration)
substage: "<substage description>"        # e.g. "measure" / "identify" / "decide" / "remove", used alongside stage

# Optional field (exploration mode, solo-specific)
exploration_mode: "<enum>"                 # deep / standard / skip, default standard, controls workflow interaction depth

# Optional field (hard circuit breaker flag)
hard_limit_reached: <bool>                 # When true, further looping is prohibited; default false; set to true only when iteration >= 10
```

**stage enum values**:

| Value | Meaning | When written |
|----|------|---------|
| `plan` | Planning phase | When writing-plans initializes |
| `act` | Execution phase | When tdd red→green→refactor completes |
| `verify` | Verification phase | When the verify skill runs checks |
| `debug` | Debugging phase | When systematic-debugging analyzes root cause |

**status enum values** (globally unified):

| Value | Meaning | When written |
|----|------|---------|
| `running` | Task is currently executing | writing-plans initialization / tdd success continues |
| `retrying` | Task failed, currently retrying or auto-rolling back | After tdd/verify failure |
| `done` | Task successfully verified and completed | verify passes + code-review passes |
| `failed` | Task failed and retries exhausted | Iteration limit exceeded |
| `needs-human` | Requires human intervention (e.g., mandatory approval, auto-repair failed) | Auto-repair failed / mandatory human approval required |
| `blocked` | Task is blocked (e.g., waiting on upstream artifact, waiting on environment permissions) | Waiting on upstream artifact / waiting on environment permissions |

**Field write responsibility**:

| Field | writing-plans | tdd | verify | systematic-debugging |
|------|:---:|:---:|:---:|:---:|
| current_task | Write (initialize) | No change | No change | No change |
| iteration | Write (0) | Write (+1) | No change | No change |
| stage | Write (plan) | Write (act) | Write (verify) | Write (debug) |
| status | Write (running) | Write (running/retrying) | Write (done/retrying) | Write (retrying) |
| last_error | Write ("") | Write (on failure / cleared on success) | Write (on failure / cleared on success) | Write (root cause description) |
| started_at | Write (initialize) | No change | No change | No change |
| exploration_mode | Write (workflow default_mode) | No change | No change | No change |

**Example**:

```yaml
# loops/specs/001-user-login/state.yaml example
current_task: 001-user-login
iteration: 3
stage: verify
status: retrying
last_error: "test_auth.py::test_login_empty_password FAILED"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

### Product-level state.yaml (additional fields)

The basic schema above applies to a single feature/task. Product-level workflows (`new-product-engineering`) need to track the "currently executing feature" and "completion status of all features". To avoid overloading the `substage` field (whose original semantics is the sub-stage within a single task, e.g., optimize/migration), the following dedicated fields are added to the **product-level** state.yaml only:

```yaml
# Product-level additional fields (only present in product-level state.yaml)
current_nested_task: "<NNN>-<product-name>-<feature-name>"  # Currently executing nested sub-task, e.g. "001-shopping-app-auth"; only used by product-level workflows
nested_progress: "<progress overview>"                       # Nested sub-task progress overview, e.g. "F01:done, F02:done, F03:running, F04:pending"; or reference ENGINEERING_PLAN.md Section 2 Status column
```

**Notes**:
- The `substage` field restores its original semantics (optimize/migration sub-stages) and is no longer used to track nested sub-tasks (e.g., do not write `substage: feature-F03`)
- On session resume for a product-level task: read `current_nested_task` to locate the current feature, then read that feature's state.yaml for the LOOP position

## Verification Protocol (originally from verification.md)

### Two-Layer Verification (see verify/SKILL.md for full detail)

Verification runs at two points in the LOOP cycle:

1. **verify-fast** (inside LOOP, per iteration): 3 steps
   - Tests pass (show actual output)
   - AC check (current task's AC-xxx + DAC-xxx + component contract if applicable)
   - Quick security scan (Grep changed files for secrets/passwords patterns)
   - Pass → continue to next task or exit LOOP
   - Fail → back to tdd

2. **verify-full** (after LOOP exits, before code-review): 8 steps
   - Tests pass + AC item-by-item + Constitution compliance + Security scan (full) + Entropy check + Frontend verification + Write evidence + Update state
   - Pass → enter code-review
   - Fail → back to LOOP

### Prerequisites for claiming "done"

Before claiming a task is complete, the Agent **must**:
- [ ] Run tests and show the output (not "tests should pass", but actual output)
- [ ] Check against the acceptance criteria item by item, marking each ✓/✗
- [ ] Run a security scan (Approach A or Approach B) and show the output
- [ ] Write evidence to `loops/specs/<feature>/evidence.md`
- [ ] Update the status in `loops/specs/<feature>/state.yaml` to done

**No evidence, no claim of completion** — this is Core Rule #1 in AGENTS.md.

### Failure Handling

**Inside-LOOP failure** (verify):
1. Write the failure info to the `last_error` field in `state.yaml`
2. Append a line to `iterations.log`
3. Analyze the failure cause:
   - Fixable (test failure, minor bug) → back to ACT
   - Re-planning needed (design error, requirement change) → back to PLAN
4. Increment the iteration count and check whether the maximum iterations have been exceeded

**Outside-LOOP failure** (code-review):
1. Write failure info to the `last_error` field of `state.yaml`
2. Analyze the failure reason (Critical-level findings trigger re-entry):
   - Fixable (Critical code-review issue, fixable defect) → back to LOOP (re-ACT)
   - Needs replanning (design error, requirement change) → back to PLAN
3. Does not consume iteration count (outside-LOOP failures are not counted)

### Checkpoint Resume

Recovery after session interruption:
1. Read `loops/specs/<feature>/state.yaml` to get the current stage and iteration count
2. Read `iterations.log` to understand the failure history
3. Continue from the interruption point; do not start over
