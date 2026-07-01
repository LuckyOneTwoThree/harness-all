---
name: writing-plans
description: Converts clarified requirements into one executable feature spec and initializes canonical LOOP state.
---
# Writing Plans

## When to use

- After requirements are sufficiently clear.
- Before any standard/deep LOOP task.
- When verification proves the current plan is wrong.

Quick-fix does not invoke this skill.

## Inputs

- `.harness/rules/engineering-pipeline.md`
- `.harness/loops/state.schema.json`
- `constitution.md`, `PROJECT.md`, `TECH_STACK.md`
- validated PM/Design contracts when present

## Outputs

- `loops/specs/<task>/spec.md`
- initial or explicitly revised `state.yaml`

## One Process, Two Depths

Standard and deep use the same artifact shape and state semantics. Deep adds architecture/dependency/data-migration analysis and an explicit user decision when tradeoffs are material; it is not a second implementation of this process.

## Process

1. **Allocate task directory** — use zero-padded kebab-case naming and do not reuse an existing task ID.
2. **Write spec.md** from `.harness/templates/spec.md.template`:
   - one outcome-oriented goal;
   - stable AC/DAC IDs with source/revision;
   - in/out boundaries;
   - tasks with one independently verifiable result, normally 15–45 minutes;
   - expected files/tests and verification command;
   - frontend contract + binding references by stable component ID.
3. **Assess impact**:
   - standard: dependencies, schema/migration, security, public API;
   - deep: also architecture alternatives, rollback, operational impact, cross-feature contracts.
4. **Initialize state once**:

```yaml
current_task: <NNN>-<feature-name>
iteration: 0
stage: plan
status: running
last_error: ""
started_at: "<ISO-8601>"
exploration_mode: <standard|deep>
hard_limit_reached: false
```

Validate against `state.schema.json`. `ready` is not a valid status.

5. **Gate** — unresolved material decisions become `needs-human` before ACT. Otherwise begin the selected ACT skill.

**Session boundary recommendation**: for deep/long tasks, consider starting a new session to execute this plan. Plan-stage context (exploration, alternatives, discarded options) can pollute execution-stage focus. The spec + state.yaml carry everything needed to resume; no context loss occurs across a clean session boundary.

## Replanning

When an active task returns to PLAN:

- preserve task ID and attempt history;
- revise spec.md with a short change record/source;
- set `stage: plan`, keep the current iteration, and never reset the breaker without explicit user authorization;
- do not allocate a new task merely for a fix within the same accepted outcome.

## Plan Quality Gate

- Every criterion is stable, testable, and source-traceable.
- Every task has explicit input/output and a verification method.
- Frontend tasks cite both semantic contract and engineering binding.
- Dependency/schema/public API impacts are represented as tasks or explicitly n/a.
- The plan does not prescribe speculative abstractions or unrelated cleanup.

## Relationship with LOOP

Exclusively owns PLAN artifacts and initialization. See `.harness/loops/LOOP.md`.
