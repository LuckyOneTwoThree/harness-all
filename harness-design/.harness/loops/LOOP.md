# LOOP.md — Loop Engine Definition + Verification Protocol

> Source: ospec (plan→act→verify) adapted to a design loop (plan→design→verify+lint)
> Purpose: replaces linear workflows to implement a closed verification loop
> Merges the original verification.md content

## Core Loop

```
┌─────────────────────────────────────────────────────┐
│  PLAN (inline, no standalone skill)                 │
│  - Read the AC-xxx list from DESIGN_BRIEF.md        │
│  - Constitution check                               │
│  - Initialize state.yaml + spec.md                  │
└─────────────────────┬───────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  LOOP (inside the loop body)                        │
│  ┌─────────────┐                                    │
│  │   DESIGN    │ ← Execute design (call design skill)│
│  └──────┬──────┘                                    │
│         ▼                                           │
│  ┌─────────────┐                                    │
│  │   VERIFY    │ ← verify skill: AC + constitution + basic a11y │
│  └──────┬──────┘                                    │
│         ▼                                           │
│  ┌─────────────┐                                    │
│  │    LINT     │ ← design-lint skill: mechanical rules (script execution) │
│  └──────┬──────┘                                    │
│         │                                           │
│         ├── All passed → exit LOOP                  │
│         ├── Fixable → back to DESIGN (iteration +1) │
│         └── Exceeds max iteration → request human intervention │
└─────────────────────────────────────────────────────┘
                      ▼
┌─────────────────────────────────────────────────────┐
│  Outside-LOOP Gate (final review, non-loop)         │
│  ┌─────────────────┐                                │
│  │ DESIGN-REVIEW   │ ← Five-Axis + Doubt-Driven     │
│  └────────┬────────┘                                │
│           ├── Pass → enter handoff                  │
│           └── Fail → back to LOOP (fixable) or PLAN (needs replanning) │
│                      ▼                              │
│  ┌─────────────────┐                                │
│  │ ACCESSIBILITY   │ ← WCAG 2.1 AA dedicated review │
│  └────────┬────────┘                                │
│           ├── Pass → enter handoff                  │
│           └── Fail → back to LOOP                   │
└─────────────────────────────────────────────────────┘
```

**Key boundaries**:
- Inside LOOP = verify + design-lint (fast checks, run on every iteration)
- Outside LOOP = design-review + accessibility-audit (deep review, run once after LOOP exits)
- design-review is not inside the LOOP, to avoid spawning a sub-agent for Doubt-Driven adversarial review on every iteration

## Loop Types

| Type | Trigger Scenario | Max Iterations | Stop Condition |
|------|------------------|----------------|----------------|
| **visual-design** | Visual design tasks | 5 | verify + lint pass + AC satisfied |
| **interaction-design** | Interaction design tasks | 5 | verify + lint pass + AC satisfied |
| **wireframe** | Wireframe / low-fidelity prototype | 5 | verify + lint pass + AC satisfied |
| **component** | Component design (Button/Input/Card, etc.) | 5 | verify + lint pass + AC satisfied |

**Removal notes**:
- `prototype` changed to `wireframe`, semantics more accurate (the output is low-fidelity wireframes, not interactive prototypes)
- `redesign` removed (redesign is a workflow scenario; internally it still uses the visual-design loop)

## Cost Control

| Dimension | Limit | Over-limit Action |
|-----------|-------|-------------------|
| Iterations within a single LOOP | 10 | **Hard Circuit Breaker**: write `hard_limit_reached: true` to state.yaml, change status to `failed`, **prohibited from continuing the loop**, must request human intervention |

**Semantic notes**:
- "Single LOOP" refers to the iteration count within the same loop type (visual-design / interaction-design / wireframe / component)
- Different loop types are different tasks, counted independently (e.g., new-design's wireframe/visual/interaction 3 LOOPs each count separately)
- The max 5 within a workflow is a recommended upper bound; 10 is the hard circuit breaker threshold (5 < 10, leaving 5 iterations of tolerance)

> **Hard Circuit Breaker Execution Rules (non-negotiable)**:
> 1. The Agent **must** read the `iteration` field of `state.yaml` at every VERIFY/LINT stage
> 1.5. **VERIFY stage must mandatorily read the raw state.yaml content**: At every VERIFY, the Agent must use the Read tool to read the full contents of `state.yaml` to obtain the real iteration value. **Referencing the iteration value from context memory is prohibited** (to prevent skipping circuit breaker checks in hallucination states).
> 2. When the `iteration >= 10` read by the Read tool (must come from raw file content, not memory reference), the Agent **must** perform the following, without skipping:
>    - Change `status` to `failed`
>    - Write `hard_limit_reached` to `true`
>    - Write `last_error` as "Iteration exceeded (iteration >= 10), hard circuit breaker triggered"
>    - Report the circuit breaker reason to the user and request human intervention
> 3. When `hard_limit_reached: true`, the Agent is **prohibited** from continuing any LOOP phase of the current task
> 4. Only after the user explicitly instructs "reset circuit breaker" may the Agent change `hard_limit_reached` to `false` and reset `iteration`
>
> Token limits are monitored by the user in the IDE and are not part of framework rules (the Agent has no token counter).

## Specs Persistence

At the PLAN stage of each loop, write the spec to `loops/specs/<task>/spec.md`.

## Evidence Tracking

Evidence from each VERIFY/LINT stage is written to `loops/specs/<task>/evidence.md`.

**File write semantics distinction (important, avoid confusion)**:

| File | Write Semantics | Reason | Operation |
|------|-----------------|--------|-----------|
| `spec.md` | Overwrite | Keep only the final passed spec | Write directly overwrites |
| `state.yaml` | Overwrite | Keep only the current state | Write directly overwrites |
| `evidence.md` | Overwrite | Keep only the final successful evidence | Write directly overwrites |
| `iterations.log` | **Append** | Preserve complete iteration history | Read+concatenate+Write, or `echo >>` |
| `lint-report.md` | Overwrite | Keep only the latest lint report | Write directly overwrites |

```
loops/specs/001-login-page/
├── spec.md          ← Design spec (overwrite: final passed version)
├── state.yaml       ← Loop state (overwrite: current state)
├── evidence.md      ← Verification evidence (overwrite: final success)
├── lint-report.md   ← Lint report (overwrite: latest run)
└── iterations.log   ← Iteration history (append-only, full trajectory)
```

iterations.log example:
```
[2026-06-20 14:30] iter=1 stage=design → verify FAILED: AC-002 not satisfied (missing hover state)
[2026-06-20 14:35] iter=2 stage=design → lint FAILED: L001 hardcoded #3B82F6
[2026-06-20 14:40] iter=3 stage=verify+lint → PASSED
```

Why designed this way?
  - spec.md / state.yaml / evidence.md overwrite → keep only the latest state, no context pollution
  - iterations.log append-only → preserve complete iteration history, debug shows failure trajectory
  - lint-report.md overwrite → only care about the latest lint result
  - All artifacts of one task in one directory → good cohesion, no cross-directory lookup

## Task Granularity

`<task>` in `loops/specs/<task>/` has three levels of granularity. Use the correct level based on the workflow:

| Granularity | Naming Pattern | Example | Used by workflow | State directory |
|-------------|----------------|---------|------------------|-----------------|
| Component-level | `<NNN>-<component-name>` | `002-button` | design-system-setup, new-design (component task) | `loops/specs/002-button/` |
| Page-level | `<NNN>-<page-name>` | `001-login-page` | new-design (page task) | `loops/specs/001-login-page/` |
| Product-level | `<NNN>-<product-name>` | `001-shopping-app` | new-product-design | `loops/specs/001-shopping-app/` (product) + `loops/specs/001-shopping-app-home/` (per page) |

**Rules**:
- `<NNN>` is a zero-padded 3-digit sequence number, unique within the framework
- Product-level tasks nest per-page tasks: product-level state.yaml tracks overall progress, per-page state.yaml tracks page progress
- On session resume for a product-level task: read product-level state.yaml first to find current page, then read that page's state.yaml for LOOP position
- Single-page workflows (new-design, design-iteration) use page-level or component-level; never product-level
- If a page is part of a product-level task, its task name must include the product name prefix (e.g., `001-shopping-app-home`, not just `002-home`) to keep all pages of one product grouped in directory listing

## State Maintenance

**Decision: Agent reads/writes state.yaml (one file per task, persisted to disk)**

`loops/specs/<task>/state.yaml` is actively read/written by design/verify/lint skills in the loop:
  - Records current iteration count, last failure reason, current stage
  - Supports checkpoint resume after session interruption (read state.yaml to restore context)
  - verify/lint skills have to write evidence anyway; one extra state line has negligible cost
  - One file per task, naturally supports parallel design tasks

### state.yaml Schema (single source, each SKILL.md references this section)

```yaml
# Required fields
current_task: <NNN>-<task-name>           # Task number + name, consistent with directory name
iteration: <int>                           # Current iteration count, starts from 0, +1 per DESIGN→VERIFY+LINT loop
stage: <enum>                              # Current stage, see enum table below
status: <enum>                             # Task status, see enum table below
started_at: "<ISO 8601>"                   # Task start time, e.g., "2026-06-20T14:30:00"

# Optional fields (filled on failure)
last_error: "<error description>"          # Most recent failure reason; cleared to "" on success
last_error_at: "<ISO 8601>"                # Most recent failure time

# Optional field (sub-stage description, for multi-sub-stage workflows)
substage: "<sub-stage description>"        # e.g., "visual" / "interaction" / "wireframe" / "component"

# Optional field (exploration mode, design-specific)
exploration_mode: "<enum>"                 # deep / standard / skip, default standard, controls workflow interaction depth

# Optional field (hard circuit breaker flag)
hard_limit_reached: <bool>                 # When true, continuing the loop is prohibited; default false; set true only when iteration >= 10
```

**stage enum values**:

| Value | Meaning | Write Timing |
|-------|---------|--------------|
| `plan` | Planning stage | When PLAN initializes inline |
| `design` | Design stage | When visual-design/interaction-design/wireframe/component-design completes |
| `verify` | Verification stage | When verify skill runs checks |
| `lint` | Lint stage | When design-lint skill runs checks |
| `review` | Final review stage (outside LOOP) | When design-review runs |

**status enum values (global unified spec)**:

| Value | Meaning | Write Timing |
|-------|---------|--------------|
| `running` | Task is executing | PLAN init / design succeeds and continues |
| `retrying` | Task failed, retrying or auto-rolling back | After design/verify/lint failure |
| `done` | Task successfully verified and completed | LOOP exit + design-review + accessibility-audit pass |
| `failed` | Task failed and retries exhausted | Iteration exceeded (hit max iteration circuit breaker threshold) |
| `needs-human` | Human intervention needed (e.g., must approve, auto-fix failed) | Auto-fix failed / hit an operation requiring human approval |
| `blocked` | Task blocked (e.g., waiting for upstream deliverables, waiting for environment permissions) | Waiting for upstream deliverables / waiting for environment permissions / dependencies not ready |

**Field write responsibility**:

| Field | PLAN (inline) | design skill | verify/lint | design-review |
|-------|:---:|:---:|:---:|:---:|
| current_task | Write (init) | No change | No change | No change |
| iteration | Write (0) | Write (+1) | No change | No change |
| stage | Write (plan) | Write (design) | Write (verify/lint) | Write (review) |
| status | Write (running) | Write (running/retrying) | Write (retrying/done) | Write (done/retrying) |
| exploration_mode | Write (workflow default_mode) | No change | No change | No change |
| last_error | Write ("") | Write (on failure / cleared on success) | Write (on failure / cleared on success) | Write (on failure / cleared on success) |
| started_at | Write (init) | No change | No change | No change |

**Example**:

```yaml
# loops/specs/001-login-page/state.yaml example
current_task: 001-login-page
iteration: 3
stage: lint
status: retrying
last_error: "Lint L001: hardcoded #3B82F6, should use token color.primary"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

### Product-level state.yaml (additional fields)

The basic schema above applies to a single page/component task. Product-level workflows (`new-product-design`) need to track the "currently executing page" and "completion status of all pages". To avoid overloading the `substage` field (whose original semantics is the sub-stage within a single task, e.g., visual/interaction/wireframe/component), the following dedicated fields are added to the **product-level** state.yaml only:

```yaml
# Product-level additional fields (only present in product-level state.yaml)
current_nested_task: "<NNN>-<product-name>-<page-name>"  # Currently executing nested sub-task, e.g. "001-shopping-app-login"; only used by product-level workflows
nested_progress: "<progress overview>"                    # Nested sub-task progress overview, e.g. "P01:done, P02:running, P03:pending"
```

**Notes**:
- The `substage` field restores its original semantics (visual/interaction/wireframe/component sub-stages) and is no longer used to track nested sub-tasks (e.g., do not write `substage: page-P03`)
- On session resume for a product-level task: read `current_nested_task` to locate the current page, then read that page's state.yaml for the LOOP position

## Verification Protocol (original verification.md content)

### Inside-LOOP Checks (VERIFY + LINT)

**VERIFY stage required checks** (verify skill):

1. **Design completeness**: Does the design draft cover all acceptance criteria
2. **Acceptance criteria**: Check each AC-xxx in spec.md line by line for satisfaction
3. **Constitution compliance**: Check for violations of constitution.md principles
4. **Basic accessibility**: Contrast + keyboard navigation (quick check, not full)
5. **Deliverability check**: Are annotations / specs complete

**LINT stage required checks** (design-lint skill):

1. **Token consistency**: L001-L005 (color/spacing/radius/font-size/shadow must come from tokens)
2. **Component consistency**: L006-L008 (same semantic component ≤3 implementations / variant merging / complete states)
3. **Layout consistency**: L009-L010 (alignment baseline / grid column count)
4. **Anti AI-slop**: L011-L015 (prohibit Inter/purple gradient/uniform radius/Lorem ipsum)

**Lint failure handling**: When design-lint fails, update the `last_error` field of state.yaml, format: `Lint L00X: <description>`, reusing the existing field; do not add a new lint_status field.

### Outside-LOOP Checks (final gate)

**DESIGN-REVIEW** (design-review skill):

1. **Five-Axis Review**: Visual hierarchy / spacing & alignment / color contrast / component consistency / accessibility
2. **Doubt-Driven adversarial review**: CLAIM → EXTRACT → DOUBT → RECONCILE → STOP
   - Nit/FYI level: record directly, no adversarial debate triggered
   - Critical level: triggers fresh-context sub-agent adversarial review
3. **Severity Labeling**: Critical / no prefix / Nit / FYI

**ACCESSIBILITY-AUDIT** (accessibility-audit skill):

1. WCAG 2.1 AA full check (contrast / keyboard / screen reader / responsive / reduced-motion)

### Preconditions for Claiming "Complete"

Before claiming a task complete, the Agent **must**:
- [ ] All inside-LOOP verify passed (each AC-xxx ✓)
- [ ] All inside-LOOP design-lint passed (no error-level violations)
- [ ] Outside-LOOP design-review passed (Five-Axis + Doubt-Driven)
- [ ] Outside-LOOP accessibility-audit passed (WCAG 2.1 AA)
- [ ] Write evidence to `loops/specs/<task>/evidence.md`
- [ ] Update `loops/specs/<task>/state.yaml` status to done

**No claiming completion without evidence** — this is a core rule of AGENTS.md.

### Failure Handling

**Inside-LOOP failure** (verify/lint):
1. Write failure info to the `last_error` field of `state.yaml`
2. Append a line to `iterations.log`
3. Analyze the failure reason:
   - Fixable (insufficient contrast, lint violation, missing state) → back to DESIGN
   - Needs replanning (requirement misunderstanding, direction deviation) → back to PLAN
4. Iteration count +1, check whether max iteration is exceeded

**Outside-LOOP failure** (design-review/accessibility-audit):
1. Write failure info to the `last_error` field of `state.yaml`
2. Analyze the failure reason:
   - Fixable (visual hierarchy issue, contrast not met) → back to LOOP (re-DESIGN)
   - Needs replanning (direction deviation, requirement misunderstanding) → back to PLAN
3. Does not consume iteration count (outside-LOOP failures are not counted)

### Checkpoint Resume

Resume after session interruption:
1. Read `loops/specs/<task>/state.yaml` to get the current stage and iteration count
2. Read `iterations.log` to understand failure history
3. Continue from the interruption point; do not start from scratch
4. If `stage` is `review`, the LOOP has exited; continue with the outside-LOOP gate
