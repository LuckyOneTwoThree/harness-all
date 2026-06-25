---
name: executing-plans
description: Execute the spec.md produced by writing-plans, advancing through the task sequence with checkpoints
---
# Executing Plans — Plan Execution

## When to use
- After writing-plans completes
- When spec.md is ready and coding is about to start
- When the user says "start executing" / "go" / "let's go

## Inputs
- loops/LOOP.md
- loops/specs/<feature>/spec.md
- loops/specs/<feature>/state.yaml
- docs/engineering/TECH_STACK.md

## Outputs
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/iterations.log

## Iron Rule
**Advance through the task sequence in spec.md; a checkpoint is mandatory after each task.** Do not skip tasks; do not batch changes across multiple tasks before verifying.

## Process

1. **Load spec.md**
   - Read `loops/specs/<feature>/spec.md` and confirm the task list (T1, T2, T3...)
   - Read `loops/specs/<feature>/state.yaml` to confirm which task to resume from (resumable from breakpoint)
   - Read `docs/engineering/TECH_STACK.md` to confirm the test/lint/build commands

2. **Execute task by task** (each task goes through a small loop)

   For each task T<N> in spec.md:

   **2.1 Enter ACT (hand off to the tdd skill)**
   - Invoke the `test-driven-development` skill: red (write a failing test) → green (minimal implementation) → refactor
   - Update per the "state.yaml Schema" in LOOP.md:
     - `iteration`: +1
     - `stage`: `act`
     - `status`: `running`

   **2.2 Enter VERIFY (hand off to the verify skill)**
   - Invoke the `verify` skill: run tests + check against ACs + constitution + security
   - Update state.yaml: `stage`: `verify`

   **2.3 Checkpoint (manual confirmation point)**
   - Report the completion status of this task to the user:
     ```
     ✅ T<N> complete
     - Files changed: [list]
     - Tests: [passed/total]
     - AC progress: AC-xxx ✓
     ```
   - Ask the user: "T<N> is complete, continue to T<N+1>?"
   - User confirms → continue to the next task
   - User requests adjustments → return to writing-plans to modify spec.md

3. **Failure Handling**
   - verify fails → invoke `systematic-debugging` to find the root cause → return to 2.1 and redo
   - Iteration limit exceeded (see the loop type table in LOOP.md) → stop and request human intervention

4. **All Tasks Complete**
   - All T<N> complete + all ACs ✓ → exit this skill
   - Enter the `requesting-code-review` skill for the final review

## Checkpoint Strategy

| Scenario | Strategy |
|------|------|
| Small task granularity (2-5 minutes) | Checkpoint at every task so the user controls the pace |
| User says "batch execute" | May execute 2-3 tasks in a row before a unified checkpoint, but a verify failure must stop immediately |
| User away (autonomous) | Execute continuously until verify fails or all tasks complete; record checkpoints in iterations.log |

## Division of Labor with Other Skills

| Skill | Responsibility | Timing |
|-------|------|------|
| writing-plans | Write spec.md (task breakdown) | PLAN phase |
| **executing-plans** | Schedule task execution (this skill) | ACT+VERIFY scheduling |
| test-driven-development | Red-green-refactor for a single task | ACT phase |
| verify | Comprehensive verification for a single task | VERIFY phase |
| systematic-debugging | Find root cause on failure | On VERIFY failure |

## Prohibitions
- Skipping checkpoints to change multiple tasks in a row (loss-of-control risk)
- Starting without reading state.yaml (may repeat completed tasks)
- Continuing to the next task after a verify failure (errors accumulate)
- Task granularity exceeding 5 minutes without further breakdown (spec.md breakdown is inadequate; return to writing-plans)

## Relationship with LOOP
This skill is the **scheduler** of the LOOP cycle and does not write code itself:
- executing-plans schedules → tdd executes ACT → verify executes VERIFY → on failure, return to systematic-debugging
- All tasks in a spec.md complete = LOOP ends
