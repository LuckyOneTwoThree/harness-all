---
name: executing-plans
description: Execute the spec.md produced by writing-plans, advancing through the task sequence with checkpoints
---
# Executing Plans — Plan Execution

## When to use
- After writing-plans completes
- When spec.md is ready and coding is about to start
- When the user says "start executing" / "go" / "let's go"

## Inputs
- loops/LOOP.md
- loops/specs/<feature>/spec.md
- loops/specs/<feature>/state.yaml
- docs/engineering/TECH_STACK.md
- docs/handoff/component-map.json (optional, required when spec.md contains `Contract: component-map.json#<Component>` tasks)

## Outputs
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/iterations.log

## Iron Rule
**Advance through the task sequence in spec.md; a checkpoint is mandatory after each task.** Do not skip tasks; do not batch changes across multiple tasks before verifying. state.yaml is the single source of truth for the resume position — never rely on memory.

## Process

1. **Load spec.md**
   - Read `loops/specs/<feature>/spec.md` and confirm the task list (T1, T2, T3...)
   - Read `loops/specs/<feature>/state.yaml` to confirm which task to resume from (resumable from breakpoint)
   - Read `docs/engineering/TECH_STACK.md` to confirm the test/lint/build commands
   - If any of the three is missing or stale, STOP and request the missing input before proceeding

2. **Execute task by task** (each task goes through a small loop)

   For each task T<N> in spec.md:

   **2.1 Enter ACT (task-type routing + handoff)**

   Before dispatching, inspect the task description to decide the route:

   - **Frontend component task** — task description contains a `Contract: component-map.json#<Component>` line:
     1. Invoke the `frontend-implementation` skill first — it reads `docs/handoff/component-map.json` for the named component's props/states/usedBy, and produces structure/styling/state guidance for that component.
     2. Then invoke the `test-driven-development` skill: red (failing test for component behavior per the contract) → green (minimal implementation following frontend-implementation's guidance) → refactor.
     3. If `docs/handoff/component-map.json` is missing while a `Contract:` line exists, STOP — this is a handoff defect; do not guess the contract, request harness-design to deliver it.
   - **Logic/backend task** — task description has no `Contract:` line:
     1. Invoke the `test-driven-development` skill directly: red → green → refactor.

   Update per the "state.yaml Schema" in LOOP.md:
     - `iteration`: +1
     - `stage`: `act`
     - `status`: `running`

   **2.2 Enter VERIFY (hand off to the verify skill)**
   - Invoke the `verify` skill: run tests + check against ACs + constitution + security
   - Update state.yaml: `stage`: `verify`

   **2.3 Checkpoint (manual confirmation point)**
   - Report the completion status of this task to the user:
     ```
     T<N> complete
     - Files changed: [list]
     - Tests: [passed/total]
     - AC progress: AC-xxx ✓
     ```
   - Ask the user: "T<N> is complete, continue to T<N+1>?"
   - Branch by user response:
     - **User confirms** → proceed to the next task
     - **User requests adjustment** → return to writing-plans, modify spec.md, then resume from the affected task
     - **User unresponsive (autonomous mode)** → check the verify result:
       - verify **passed** → proceed to the next task; append a checkpoint line to `iterations.log`:
         ```
         [YYYY-MM-DD HH:MM] iter=<N> task=T<N> checkpoint=PASSED
         ```
       - verify **failed** → STOP, do not guess user intent, set `state.yaml` `status: blocked`, wait for human input

3. **Failure Handling**
   - verify fails → invoke `systematic-debugging` to find the root cause → return to 2.1 and redo
   - Iteration limit exceeded (see the loop type table in LOOP.md) → stop and request human intervention
   - Same task fails 3+ times → spec or approach is wrong; stop retrying and return to writing-plans

4. **All Tasks Complete**
   - All T<N> complete + all ACs ✓ → exit this skill
   - Enter the `requesting-code-review` skill for the final review

## Checkpoint Strategy

Choose the checkpoint cadence based on the user's presence and task granularity:

| Scenario | Strategy |
|------|------|
| Small task granularity (2-5 minutes) | Checkpoint at every task so the user controls the pace |
| User says "batch execute" | May execute 2-3 tasks in a row before a unified checkpoint, but a verify failure must stop immediately |
| User away (autonomous) | Execute continuously until verify fails or all tasks complete; record checkpoints in iterations.log |

## Division of Labor with Other Skills

This skill schedules; it does not write code or run tests itself. Each collaborator owns one phase.

| Skill | Responsibility | Timing |
|-------|------|------|
| writing-plans | Write spec.md (task breakdown, with `Contract:` lines for frontend tasks) | PLAN phase |
| **executing-plans** | Schedule task execution + route by task type (this skill) | ACT+VERIFY scheduling |
| frontend-implementation | Read component-map.json, produce structure/styling/state guidance for a named component | ACT phase, before tdd, only for tasks with `Contract:` line |
| test-driven-development | Red-green-refactor for a single task | ACT phase |
| verify | Comprehensive verification for a single task | VERIFY phase |
| systematic-debugging | Find root cause on failure | On VERIFY failure |

## Prohibitions
- Skipping checkpoints to change multiple tasks in a row (loss-of-control risk)
- Starting without reading state.yaml (may repeat completed tasks)
- Continuing to the next task after a verify failure (errors accumulate)
- Task granularity exceeding 5 minutes without further breakdown (spec.md breakdown is inadequate; return to writing-plans)
- Writing implementation code directly — this skill is a scheduler; code is written by the tdd skill
- Updating state.yaml from memory instead of reading the raw file first
- Guessing user intent in autonomous mode when verify fails (silent retry is forbidden)

## Anti-Rationalization Table

Each row below names a shortcut you may be tempted to take, the rationalization that makes it feel acceptable, and why it fails. When you catch yourself reaching for the rationalization, stop and follow the rule instead.

| Shortcut taken | Rationalization | Why it fails |
|----------------|-----------------|--------------|
| Start executing without reading spec.md | "I remember the plan." | Memory is unreliable; spec.md is the single source of truth and plans drift between sessions. |
| Skip the checkpoint because the task is small | "It's just a tiny task." | Small tasks can still drift from ACs; checkpoints are how drift gets caught before it compounds. |
| Continue to the next task after a verify failure | "The next task might fix it." | Failures accumulate; the later the fix, the harder it is to localize the root cause. |
| Write implementation code yourself | "It's faster than dispatching." | executing-plans is a scheduler; writing code is the tdd skill's job — violating this destroys the LOOP division of labor. |
| Delay updating state.yaml | "I'll update it later." | The LOOP engine reads state.yaml to resume; a stale state equals lost progress and duplicated work. |
| Guess user intent in autonomous mode | "They probably want me to keep going." | A failed verify is a hard stop; guessing intent silently violates the checkpoint contract. |
| Skip frontend-implementation for a `Contract:` task and go straight to tdd | "tdd can write the component anyway." | Without frontend-implementation reading component-map.json, tdd guesses props/states; the implementation drifts from the design contract and verify cannot catch it (verify checks ACs, not the full props/states contract). |
| Guess the component contract when component-map.json is missing | "I roughly remember the design." | A missing component-map.json is a handoff defect; guessing produces a fabricated contract that silently diverges from design. STOP and request it from harness-design. |

## Red Flags
Stop and reconcile immediately when any of these appear:
- `iterations.log` shows the same task failing 3+ times — the spec or the approach is wrong; return to writing-plans or systematic-debugging instead of retrying.
- `state.yaml` `stage` does not match the actual work being done — the engine has lost sync with reality; re-read state.yaml before any further action.
- The user says "continue" twice in a row without reviewing the checkpoint output — confirm they actually read it before proceeding; silence is not consent.
- An AC is marked `✓` in the checkpoint report but verify was never run — the mark is fabricated; rerun verify before continuing.
- A single task takes more than 15 minutes of wall-clock time — the task granularity is too coarse; return to writing-plans to split it.
- A task with a `Contract: component-map.json#<Component>` line is dispatched directly to tdd without frontend-implementation — the contract is being ignored; redo the task via frontend-implementation first.
- frontend-implementation is invoked but `docs/handoff/component-map.json` does not exist — handoff defect; STOP and request it from harness-design rather than guessing the contract.

## Relationship with LOOP
This skill is the **scheduler** of the LOOP cycle and does not write code itself:
- executing-plans schedules → (frontend-implementation if `Contract:` task, then) tdd executes ACT → verify executes VERIFY → on failure, return to systematic-debugging
- All tasks in a spec.md complete = LOOP ends
