# LOOP.md — Loop Engine Definition + Validation Protocol

> Purpose: Replaces linear workflows to implement a closed-loop growth validation cycle
> Growth Loop: PLAN → EXPERIMENT → MEASURE

## Core Loop

```
┌──────────┐
│   PLAN   │ ← Define growth hypothesis + metrics + experiment design + constitution check
└────┬─────┘
     ▼
┌──────────────┐
│ EXPERIMENT   │ ← Execute experiment (content production / SEO optimization / A/B testing / user operations)
└────┬─────────┘
     ▼
┌──────────┐
│  MEASURE │ ← Measure results + statistical significance + decision + human approval
└────┬─────┘
     │
     ├── Pass → DONE → Record evidence + write conclusion to knowledge base
     │
     └── Fail → Analyze cause
                   ├── Fixable → Back to EXPERIMENT
                   └── Needs replanning → Back to PLAN
```

## Loop Types

| Type | Trigger Scenario | Max Iterations | Stop Condition |
|------|---------|---------|---------|
| **content** | Content production and optimization | 3 | Content quality gate passed + metrics met |
| **seo** | SEO optimization | 5 | Ranking/traffic improvement targets met |
| **experiment** | A/B testing, growth experiments | 3 | Statistical significance achieved |
| **optimization** | Conversion funnel, retention optimization | 3 | Core metric improvement targets met |
| **monetization** | Pricing / payment conversion optimization | 3 | NRR target met (e.g., >120%) |
| **lifecycle** | Retention-focused optimization | 5 | Retention curve flattens and meets target |

## Cost Control

| Dimension | Limit | Over-Limit Action |
|------|------|---------|
| Total loop iterations | 10 | **Hard Circuit Breaker**: Write `hard_limit_reached: true` to state.yaml, change status to `failed`, **further looping is prohibited**, must request human intervention |

> **Hard Circuit Breaker execution rules (non-negotiable)**:
> 1. At every MEASURE stage, the Agent **must** read the `iteration` field of `state.yaml`
> 1.5. **MEASURE stage must mandatorily read the raw contents of state.yaml**: At every MEASURE, the Agent must use the Read tool to read the full contents of `state.yaml` to obtain the true iteration value. **Referencing the iteration value from contextual memory is prohibited** (to prevent skipping the circuit-breaker check under hallucination).
> 2. When the `iteration >= 10` read by the Read tool (must come from raw file contents, not memory reference), the Agent **must** perform the following operations, without skipping any:
>    - Change `status` to `failed`
>    - Write `hard_limit_reached` to `true`
>    - Write `last_error` as "Iteration limit exceeded (iteration >= 10), hard circuit breaker triggered"
>    - Report the circuit-breaker reason to the user and request human intervention
> 3. When `hard_limit_reached: true`, the Agent is **prohibited** from continuing any LOOP stage of the current task
> 4. Only after the user explicitly instructs "reset circuit breaker" may the Agent change `hard_limit_reached` to `false` and reset `iteration`
>
> Token limits are monitored by the user in the IDE and are not part of the framework rules (the Agent has no token counter).

## Specs Persistence

At the PLAN stage of each loop, write the spec to `loops/specs/<experiment>/spec.md`.

## Evidence Tracking

Evidence from each MEASURE stage is written to `loops/specs/<experiment>/evidence.md`.

**File write semantics distinction (important, to avoid confusion)**:

| File | Write Semantics | Reason | Operation |
|------|---------|------|---------|
| `spec.md` | Overwrite | Keep only the final passed spec | Write directly overwrites |
| `state.yaml` | Overwrite | Keep only the current state | Write directly overwrites |
| `evidence.md` | Overwrite | Keep only the final successful evidence | Write directly overwrites |
| `iterations.log` | **Append** | Preserve complete iteration history | Read+concatenate+Write, or `echo >>` |

```
loops/specs/001-blog-seo-experiment/
├── spec.md          ← Experiment spec (overwrite: final passed version)
├── state.yaml       ← Loop state (overwrite: current state)
├── evidence.md      ← Validation evidence (overwrite: final success)
└── iterations.log   ← Iteration history (append-only, complete trajectory)
```

iterations.log example:
```
[2026-06-20 14:30] iter=1 stage=experiment → measure FAILED: Insufficient sample size, cannot reach a significant conclusion
[2026-06-20 14:35] iter=2 stage=experiment → measure FAILED: Guardrail metric triggered, retention dropped in experiment group
[2026-06-20 14:40] iter=3 stage=measure → PASSED: Conversion rate increased 12% (p<0.05)
```

Why this design?
  - spec.md / state.yaml / evidence.md overwrite → Keep only the latest state, do not pollute context
  - iterations.log append-only → Preserve complete iteration history, allowing failure trajectories to be seen during review
  - All artifacts of one experiment in one directory → Good cohesion, no need to search across directories

## State Maintenance

**Decision: The Agent reads and writes state.yaml (one file per experiment, persisted to disk)**

`loops/specs/<experiment>/state.yaml` is actively read and written by the experiment/measure skill during the loop:
  - Records the current iteration count, last failure reason, and current stage
  - Supports resuming from a breakpoint after session interruption (read state.yaml to restore context)
  - The measure skill has to write evidence anyway; writing one extra line of state has negligible cost
  - One file per experiment naturally supports parallel experiments

### state.yaml Schema (single source of truth; each SKILL.md references this section)

```yaml
# Required fields
current_task: <NNN>-<experiment-name>      # Experiment number + name, consistent with the directory name
iteration: <int>                            # Current iteration count, starts at 0, +1 per EXPERIMENT→MEASURE loop
stage: <enum>                               # Current stage, see enum table below
status: <enum>                              # Experiment status, see enum table below
started_at: "<ISO 8601>"                    # Experiment start time, e.g., "2026-06-20T14:30:00"

# Optional fields (filled on failure)
last_error: "<error description>"           # Most recent failure reason; cleared to "" on success
last_error_at: "<ISO 8601>"                 # Most recent failure time

# Optional field (substage description, for multi-substage workflows)
substage: "<substage description>"          # e.g., "ab-test" / "keyword-research" / "content-draft", used with stage

# Optional field (exploration mode, growth-specific)
exploration_mode: "<enum>"                 # deep / standard / skip, defaults to standard, controls workflow interaction depth

# Optional field (hard circuit breaker flag)
hard_limit_reached: <bool>                 # When true, further looping is prohibited; defaults to false; set to true only when iteration >= 10
```

**stage enum values**:

| Value | Meaning | Write Timing |
|----|------|---------|
| `plan` | Planning stage | When PLAN stage initializes |
| `experiment` | Execution stage | While experiment is executing |
| `measure` | Measurement stage | When the measure skill performs checks |
| `revise` | Revision stage | When redesigning the experiment |

**status enum values** (unified with the harness family):

| Value | Meaning | Write Timing |
|----|------|---------|
| `running` | In progress | PLAN initialization / during experiment execution |
| `retrying` | Retrying | After measure failure |
| `done` | Completed | measure passed + growth review passed |
| `failed` | Failed (iteration limit exceeded, human intervention required) | Iteration limit exceeded |
| `needs-human` | Needs human decision (not a failure, but the Agent cannot continue) | Encountering constitution/ethics/permission boundaries |
| `blocked` | Blocked (waiting on external dependencies) | Waiting on upstream handoff / data / approval |

**Field write responsibilities**:

| Field | PLAN | EXPERIMENT | MEASURE | revise |
|------|:---:|:---:|:---:|:---:|
| current_task | Write (initialize) | No change | No change | No change |
| iteration | Write (0) | Write (+1) | No change | No change |
| stage | Write (plan) | Write (experiment) | Write (measure) | Write (revise) |
| status | Write (running) | Write (running/retrying) | Write (done/retrying) | Write (retrying) |
| last_error | Write ("") | Write (on failure / cleared on success) | Write (on failure / cleared on success) | Write (reason description) |
| started_at | Write (initialize) | No change | No change | No change |
| exploration_mode | Write (workflow default_mode) | No change | No change | No change |

**Example**:

```yaml
# loops/specs/001-blog-seo-experiment/state.yaml example
current_task: 001-blog-seo-experiment
iteration: 3
stage: measure
status: retrying
last_error: "Insufficient sample size, p=0.12 did not reach the 0.05 significance threshold"
last_error_at: "2026-06-20T14:35:00"
started_at: "2026-06-20T14:30:00"
```

## Validation Protocol

### MEASURE Stage Required Checks

1. **Data completeness**: Is the experiment data complete (sample size, duration, grouping)
2. **Statistical significance**: Has the core metric reached the significance threshold (typically p<0.05)
3. **Acceptance Criteria**: Check each hypothesis in spec.md item by item to verify it
4. **Guardrail metrics**: Check for side effects (e.g., retention drop, complaint increase)
5. **Constitution compliance**: Check for violations of constitution.md principles (black-hat SEO, fake traffic, PII leaks, etc.)

### Prerequisites for Claiming "Completion"

Before claiming an experiment is complete, the Agent **must**:
- [ ] Show experiment data (not "should work", but actual data)
- [ ] Check each hypothesis item by item, marking ✓/✗ (verified / falsified / inconclusive)
- [ ] Check statistical significance, show p-value or confidence interval
- [ ] Check guardrail metrics, confirm no side effects
- [ ] Write evidence to `loops/specs/<experiment>/evidence.md`
- [ ] Update the status in `loops/specs/<experiment>/state.yaml` to done
- [ ] Write the conclusion to `memory/knowledge-base.md` (effective / ineffective / inconclusive + action recommendation)

**No claiming completion without data** — this is Core Rule #1 in AGENTS.md.

### Failure Handling

When MEASURE fails:
1. Write the failure info to the `last_error` field of `state.yaml`
2. Append a line to `iterations.log`
3. Analyze the failure cause:
   - Fixable (insufficient sample, insufficient duration) → Back to EXPERIMENT (extend experiment / enlarge sample)
   - Needs replanning (wrong hypothesis, design flaw) → Back to PLAN
4. Increment the iteration count and check whether the maximum iterations have been exceeded

### Breakpoint Resumption

Resuming after a session interruption:
1. Read `loops/specs/<experiment>/state.yaml` to get the current stage and iteration count
2. Read `iterations.log` to understand the failure history
3. Continue from the interruption point; do not start from scratch
