# LOOP.md — PM Loop Engine Definition + Validation Protocol

> Purpose: Replaces linear workflows to implement a cyclic validation loop for product work
> Difference from harness-solo's LOOP: solo is plan→act→verify (test-driven); pm is plan→research→validate (data-driven)

## Core Loop

```
┌──────────┐
│   PLAN   │ ← Define research goals + decision criteria + constitution check
└────┬─────┘
     ▼
┌──────────┐
│ RESEARCH │ ← Execute research / analysis / modeling (invoke PM skill)
└────┬─────┘
     ▼
┌──────────┐
│ VALIDATE │ ← Validate conclusions + human review + confidence check
└────┬─────┘
     │
     ├── Pass → DELIVER → Record evidence + produce deliverables
     │
     └── Fail → Analyze the cause
                   ├── Insufficient data → back to RESEARCH
                   └── Wrong direction → back to PLAN
```

## Loop Types

| Type | Trigger Scenario | Max Iterations | Stop Condition |
|------|---------|---------|---------|
| **research** | User research / market analysis | 5 | Sufficient data + confidence ≥ 0.7 |
| **prd** | PRD generation / solution design | 5 | Quality gates passed + human approval |
| **iteration** | Iteration on an existing product | 3 | Acceptance criteria met |
| **growth** | Growth experiment | 3 | Experiment results meet target |
| **pivot** | Strategic adjustment / repositioning | 5 | Strategic consistency + human approval |

## Cost Control

| Dimension | Limit | Action on Exceedance |
|------|------|---------|
| Total loop count | 10 | **Hard Circuit Breaker**: Write `hard_limit_reached: true` to state.yaml, change status to `failed`, **further looping is prohibited**, must request human intervention |

> **Hard Circuit Breaker execution rules (non-negotiable)**:
> 1. At each VALIDATE stage, the Agent **must** read the `iteration` field of `state.yaml`
> 1.5. **VALIDATE stage must forcibly read the raw contents of state.yaml**: At each VALIDATE, the Agent must use the Read tool to read the full contents of `state.yaml` to obtain the true iteration value. **Referencing the iteration value from context memory is prohibited** (to prevent skipping the circuit breaker check in a hallucination state).
> 2. When attempt 10 fails, or a new ACT is requested while `iteration >= 10`, trigger the breaker. A successful attempt 10 may complete normally:
>    - Change `status` to `failed`
>    - Write `hard_limit_reached` to `true`
>    - Write `last_error` as "Iteration limit exceeded (iteration >= 10), hard circuit breaker triggered"
>    - Report the circuit breaker reason to the user and request human intervention
> 3. When `hard_limit_reached: true`, the Agent is **prohibited** from continuing any LOOP stage of the current task
> 4. Only after the user explicitly instructs "reset circuit breaker" may the Agent change `hard_limit_reached` to `false` and reset `iteration`
>
> Token limits are monitored by the user in the IDE and are not part of the framework rules (the Agent has no token counter).

## Specs Persistence

At the PLAN stage of each loop, write the spec to `loops/specs/<task>/spec.md`.

## Evidence Tracking

Evidence from each VALIDATE stage is written to `loops/specs/<task>/evidence.md`.

**File write semantics distinction (important, to avoid confusion)**:

| File | Write Semantics | Reason | How |
|------|---------|------|---------|
| `spec.md` | Overwrite | Keep only the final passed spec | Write directly overwrites |
| `state.yaml` | Overwrite | Keep only the current state | Write directly overwrites |
| `evidence.md` | Overwrite | Keep only the final successful evidence | Write directly overwrites |
| `iterations.log` | **Append** | Preserve full iteration history | Read + concatenate + Write, or `echo >>` |

```
loops/specs/001-market-research/
├── spec.md          ← Task spec (overwrite: final passed version)
├── state.yaml       ← Loop state (overwrite: current state)
├── evidence.md      ← Validation evidence (overwrite: final success)
└── iterations.log   ← Iteration history (append-only, full trajectory)
```

iterations.log example:
```
[2026-06-20 14:30] iter=1 stage=research → validate FAILED: Insufficient user feedback data (<500 entries)
[2026-06-20 14:35] iter=2 stage=research → validate FAILED: Persona confidence < 0.7
[2026-06-20 14:40] iter=3 stage=validate → PASSED: Confidence 0.8, human approval passed
```

## State Maintenance

Shared counting, status-transition, and circuit-breaker semantics are defined in `STATE_PROTOCOL.md`; `state.schema.json` validates the common state shape. In particular, iteration increments exactly once immediately before RESEARCH begins, never again during failure handling.

**Decision: The Agent reads and writes state.yaml (one file per task, persisted to disk)**

`loops/specs/<task>/state.yaml` is actively read and written by PM skills during the loop:
  - Records the current iteration count, last failure reason, and current stage
  - Supports resuming from a checkpoint after a session interruption (read state.yaml to restore context)
  - One file per task, naturally supporting parallel work on multiple product lines

### state.yaml Schema (single source of truth; each SKILL.md references this section)

```yaml
# Required fields
current_task: <NNN>-<task-name>          # Task number + name, consistent with the directory name
iteration: <int>                          # Current iteration count, starts at 0, +1 per RESEARCH→VALIDATE loop
stage: <enum>                             # Current stage, see enum table below
status: <enum>                            # Task status, see enum table below
started_at: "<ISO 8601>"                  # Task start time, e.g., "2026-06-20T14:30:00"

# Optional fields (filled on failure)
last_error: "<error description>"          # Most recent failure reason; cleared to "" on success
last_error_at: "<ISO 8601>"               # Most recent failure time

# Optional fields (substage description, for multi-substage workflows)
substage: "<substage description>"         # e.g., "voice-analysis" / "persona-modeling" / "prd-generation"

# Optional fields (exploration mode, pm-specific)
exploration_mode: "<enum>"                 # deep / standard / skip; default standard; controlled by workflow default_mode and user switching

# Optional fields (hard circuit breaker flag)
hard_limit_reached: <bool>                 # True after failed attempt 10 or blocked attempt 11; successful attempt 10 may complete
```

**stage enum values**:

| Value | Meaning | When Written |
|----|------|---------|
| `plan` | Planning stage | On task initialization |
| `research` | Research stage | When a PM skill executes research / analysis |
| `validate` | Validation stage | During quality gates / human review |
| `revise` | Revision stage | When revising output based on feedback |

**status enum values (globally unified standard)**:

| Value | Meaning | When Written |
|----|------|---------|
| `running` | Task is in progress | On task initialization / research success continues |
| `retrying` | Task failed, retry or auto-rollback in progress | After validation failure |
| `done` | Task successfully validated and completed | Validation passed + human approval passed |
| `failed` | Task failed and retries exhausted | Iteration limit exceeded |
| `needs-human` | Human intervention required (e.g., must approve, auto-repair failed) | When paused at a human decision point |
| `blocked` | Task is blocked (e.g., waiting for upstream deliverable, waiting for environment permissions) | When an exploration hard gate is not passed |

**Field write responsibility**:

| Field | Task initialization | PM skill (research) | verify (validate) |
|------|:---:|:---:|:---:|
| current_task | Write | No change | No change |
| iteration | Write (0) | Write (+1) | No change |
| stage | Write (plan) | Write (research) | Write (validate) |
| status | Write (running) | Write (running/retrying) | Write (done/retrying/needs-human) |
| exploration_mode | Write (workflow default_mode) | No change | No change |
| last_error | Write ("") | Write (on failure / cleared on success) | Write (on failure / cleared on success) |
| started_at | Write (on initialization) | No change | No change |

**Example**:

```yaml
# loops/specs/001-market-research/state.yaml example
current_task: 001-market-research
iteration: 3
stage: validate
status: retrying
last_error: "Persona confidence 0.6 < 0.7, more data needed"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## Validation Protocol

### Required Checks at the VALIDATE Stage

1. **Data sufficiency**: Check whether the required fields of the output JSON are complete (per each skill's output validation rules)
2. **Confidence check**: Inferential fields with confidence ≥ 0.7 may propagate automatically; < 0.3 blocks
3. **Quality gates**: Contract outputs such as PRD must pass 4 gates (completeness / consistency / ambiguity elimination / traceability)
4. **Constitution compliance**: Check for violations of the principles in constitution.md
5. **Human approval**: Key decision points (solution selection / priority / strategic direction) must be confirmed by a human

### Prerequisites for Claiming "Completion"

Before claiming a task is complete, the Agent **must**:
- [ ] Show the actual output (JSON / Markdown, not "should have been generated")
- [ ] Check against acceptance criteria item by item, marking each ✓/✗
- [ ] Check confidence; mark low-confidence items and request human confirmation
- [ ] Run quality gate checks (if contract outputs such as PRD are involved)
- [ ] Write evidence to `loops/specs/<task>/evidence.md`
- [ ] Update the status in `loops/specs/<task>/state.yaml` to done

**No claiming completion without evidence** — this is Core Rule 3 of AGENTS.md.

### Failure Handling

When VALIDATE fails:
1. Write the failure information to the `last_error` field of `state.yaml`
2. Append a line to `iterations.log`
3. Analyze the failure cause:
   - Insufficient data (little feedback / small sample) → back to RESEARCH to gather more data
   - Wrong direction (hypothesis not supported / requirements changed) → back to PLAN to re-plan
   - Quality not met (gates not passed / low confidence) → back to RESEARCH to improve the output
4. Check the current iteration against the recommended and hard limits; do not increment here. The next RESEARCH attempt increments exactly once when it begins

### Checkpoint Resume

Recovery after a session interruption:
1. Read `loops/specs/<task>/state.yaml` to get the current stage and iteration count
2. Read `iterations.log` to understand the failure history
3. Continue from the interruption point; do not start from scratch
