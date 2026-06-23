# LOOP.md — Loop Engine Definition + Verification Protocol

> Source: SRE practice (plan→provision→verify) + loop-engineering CLI
> Purpose: replaces linear workflows to implement a closed-loop verification cycle
> Merges the content of the former verification.md

## Core Loop

```
┌──────────┐
│   PLAN   │ ← Define change objectives + validation metrics + constitution check + rollback plan
└────┬─────┘
     ▼
┌──────────┐
│ PROVISION │ ← Execute deployment (IaC apply / kubectl / Helm / CI pipeline)
└────┬─────┘
     ▼
┌──────────┐
│  VERIFY  │ ← Check health metrics + monitoring dashboard + smoke tests
└────┬─────┘
     │
     ├── Pass → DONE → record evidence
     │
     └── Fail → ROLLBACK → analyze cause
                   ├── Fixable → back to PROVISION
                   └── Needs re-planning → back to PLAN
```

## Loop Types

| Type | Trigger Scenario | Max Iterations | Stop Condition |
|------|---------|---------|---------|
| **provision** | Infrastructure deployment / release | 3 | Health check passes + monitoring metrics stable |
| **incident** | Online troubleshooting / emergency response | 5 | Incident resolved + root cause located |
| **optimization** | Performance / cost / resource optimization | 3 | Core metrics meet improvement target + no negative impact |
| **recovery** | Disaster recovery drill | 3 | RTO/RPO met + data intact |
| **audit** | Security audit and compliance check | 3 | All violations fixed or acknowledged |

## Cost Control

| Dimension | Limit | Action on Exceedance |
|------|------|---------|
| Total loop iterations | 10 | **Hard Circuit Breaker**: write `hard_limit_reached: true` to state.yaml, change status to `failed`, **prohibit further looping**, must request human intervention |

> **Hard Circuit Breaker execution rules (non-negotiable)**:
> 1. The Agent **must** read the `iteration` field of `state.yaml` at each VERIFY stage
> 1.5. **VERIFY stage must forcibly read the raw content of state.yaml**: At each VERIFY, the Agent must use the Read tool to read the full content of `state.yaml` to obtain the true iteration value. **Referencing the iteration value from context memory is prohibited** (to prevent skipping the circuit breaker check in a hallucinated state).
> 2. When the `iteration >= 10` read by the Read tool (must come from the raw file content, not a memory reference), the Agent **must** perform the following operations, without skipping:
>    - Change `status` to `failed`
>    - Write `hard_limit_reached` to `true`
>    - Write `last_error` as "Iteration exceeded (iteration >= 10), Hard Circuit Breaker triggered"
>    - Report the circuit breaker reason to the user and request human intervention
> 3. When `hard_limit_reached: true`, the Agent is **prohibited** from continuing any LOOP phase of the current task
> 4. Only after the user explicitly instructs "reset circuit breaker" may the Agent change `hard_limit_reached` to `false` and reset `iteration`
>
> Token limits are monitored by the user in the IDE and are not part of the framework rules (the Agent has no token counter).

## Specs Persistence

At the PLAN stage of each loop, write the spec to `loops/specs/<task>/spec.md`.

## Evidence Tracking

Evidence from each VERIFY stage is written to `loops/specs/<task>/evidence.md`.

**File write semantics distinction (important, avoid confusion)**:

| File | Write Semantics | Reason | Operation |
|------|---------|------|---------|
| `spec.md` | Overwrite | Keep only the final passing spec | Write directly overwrites |
| `state.yaml` | Overwrite | Keep only the current state | Write directly overwrites |
| `evidence.md` | Overwrite | Keep only the final successful evidence | Write directly overwrites |
| `iterations.log` | **Append** | Preserve complete iteration history | Read+concatenate+Write, or `echo >>` |

```
loops/specs/001-deploy-v2/
├── spec.md          ← Change spec (overwrite: final passing version)
├── state.yaml       ← Loop state (overwrite: current state)
├── evidence.md      ← Verification evidence (overwrite: final success)
└── iterations.log   ← Iteration history (append-only, complete trajectory)
```

iterations.log example:
```
[2026-06-20 14:30] iter=1 stage=provision → verify FAILED: /health returned 503
[2026-06-20 14:35] iter=2 stage=rollback → provision → verify FAILED: DB connection timeout
[2026-06-20 14:40] iter=3 stage=verify → PASSED
```

## State Maintenance

**Decision: The Agent reads and writes state.yaml (one file per task, persisted to disk)**

`loops/specs/<task>/state.yaml` is actively read and written by deployment / troubleshooting skills during the loop:
  - Records the current iteration count, last failure reason, and current stage
  - Supports checkpoint resume after session interruption (read state.yaml to restore context)
  - The verify skill has to write evidence anyway; writing one more line of state has negligible cost
  - One file per task, naturally supporting multi-task parallelism

### state.yaml Schema (single source of truth; each SKILL.md references this section)

```yaml
# Required fields
current_task: <NNN>-<task-name>       # Task number + name, consistent with the directory name
iteration: <int>                       # Current iteration count, starts from 0, +1 for each PROVISION→VERIFY cycle
stage: <enum>                          # Current stage, see enum table below
status: <enum>                         # Task status, see enum table below
started_at: "<ISO 8601>"               # Task start time, e.g., "2026-06-20T14:30:00"

# Optional fields (filled on failure)
last_error: "<error description>"      # Most recent failure reason; cleared to "" on success
last_error_at: "<ISO 8601>"            # Most recent failure time

# Optional fields (substage description, for multi-substage workflows such as incident)
substage: "<substage description>"     # e.g., "detect" / "mitigate" / "root-cause" / "recover"

# Optional fields (exploration mode, ops-specific)
exploration_mode: "<enum>"             # deep / standard / skip; default standard; controls workflow interaction depth

# Optional fields (hard circuit breaker flag)
hard_limit_reached: <bool>             # When true, looping is prohibited; default false; set to true only when iteration >= 10
```

**stage enum values**:

| Value | Meaning | Write Timing |
|----|------|---------|
| `plan` | Planning stage | When the change is initialized |
| `provision` | Deployment execution stage | When IaC apply / kubectl / Helm is executed |
| `verify` | Verification stage | During health check / monitoring verification |
| `rollback` | Rollback stage | When verification failure triggers rollback |
| `debug` | Troubleshooting stage | During root cause analysis in the incident loop |

**status enum values** (aligned with the unified family-wide schema):

| Value | Meaning | Write Timing |
|----|------|---------|
| `running` | In progress | Task initialization / deployment successful, continuing verification |
| `retrying` | Retrying | After deployment / verification failure |
| `done` | Completed | Verification passed + monitoring metrics stable |
| `failed` | Failed (human intervention required) | Iteration limit exceeded |
| `needs-human` | Human intervention required | Destructive operation pending approval / manual decision required |
| `blocked` | Blocked | Waiting for upstream fix / waiting for resources to be ready |

**Field write responsibility**:

| Field | plan (init) | provision | verify | rollback |
|------|:---:|:---:|:---:|:---:|
| current_task | Write (init) | No change | No change | No change |
| iteration | Write (0) | Write (+1) | No change | No change |
| stage | Write (plan) | Write (provision) | Write (verify) | Write (rollback) |
| status | Write (running) | Write (running/retrying) | Write (done/retrying) | Write (retrying) |
| last_error | Write ("") | Write (on failure / cleared on success) | Write (on failure / cleared on success) | Write (rollback reason) |
| started_at | Write (init) | No change | No change | No change |
| exploration_mode | Write (workflow default_mode) | No change | No change | No change |

**Example**:

```yaml
# loops/specs/001-deploy-v2/state.yaml example
current_task: 001-deploy-v2
iteration: 2
stage: verify
status: retrying
last_error: "Health check /health returned 503, new version Pod failed to start"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## Verification Protocol

### VERIFY Stage Mandatory Checks

1. **Health check**: Call `/health` or an equivalent endpoint and confirm a 200 response
2. **Monitoring metrics**: Check the Grafana/Prometheus dashboard and confirm core metrics are stable (CPU / memory / error rate / latency)
3. **Smoke tests**: Execute smoke test scripts for critical paths
4. **Constitution compliance**: Check for violations of the principles in constitution.md (IaC file exists, no plaintext secrets, etc.)
5. **Security scan**: Use the Grep tool to scan for secret leaks per the verify SKILL.md approach (cross-platform)

### Preconditions for Claiming "Complete"

Before claiming a task complete, the Agent **must**:
- [ ] Health check passed (actual HTTP response, not "should pass")
- [ ] Monitoring metrics stable (actual values, not "looks normal")
- [ ] Smoke tests passed (actual output)
- [ ] Security scan executed and output shown
- [ ] Evidence written to `loops/specs/<task>/evidence.md`
- [ ] Updated `loops/specs/<task>/state.yaml` status to done

**No claiming complete without evidence** — this is Core Rule 1 in AGENTS.md.

### Failure Handling

When VERIFY fails:
1. Trigger ROLLBACK (execute the rollback plan in spec.md)
2. Write the failure information to the `last_error` field of `state.yaml`
3. Append a line to `iterations.log`
4. Analyze the failure cause:
   - Fixable (configuration error, insufficient resources) → back to PROVISION
   - Needs re-planning (wrong approach, requirement change) → back to PLAN
5. Increment the iteration count and check whether the maximum iterations are exceeded

### Checkpoint Resume

Recovery after session interruption:
1. Read `loops/specs/<task>/state.yaml` to get the current stage and iteration count
2. Read `iterations.log` to understand the failure history
3. Continue from the interruption point; do not start over
