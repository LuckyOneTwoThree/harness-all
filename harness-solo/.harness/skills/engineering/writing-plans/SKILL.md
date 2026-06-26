---
name: writing-plans
description: Task breakdown — output an executable spec.md
---
# Writing Plans — Task Breakdown

## When to use
- After brainstorming passes
- Before starting a multi-step task
- When entering the PLAN phase of LOOP

## Inputs
- loops/LOOP.md
- constitution.md
- rules/security.md
- docs/product/PROJECT.md
- docs/handoff/pm-to-solo.md
- docs/handoff/design-to-solo.md
- docs/handoff/component-map.json

## Outputs
- loops/specs/<feature>/spec.md
- loops/specs/<feature>/state.yaml

## Iron Rule
**Write the spec before writing code.** Starting work with an unclear spec = the root cause of rework.

## Process

1. **Create the feature directory**
   Create a feature directory under `.harness/loops/specs/`:
   ```
   .harness/loops/specs/<NNN>-<feature-name>/
   ```
   Numbering rule: NNN is a three-digit number, incremented in creation order (001, 002, ...)
   **Query the next number**: use Glob to scan the `.harness/loops/specs/*` directories and take the max number +1.
   For the first creation (when the directory is empty), start from 001.

   *Exit condition: Glob confirms the new directory exists on disk and NNN = previous max + 1 (or 001 for the first feature).*

2. **Write spec.md**
   Include the following sections:
   ```markdown
   # <feature name>

   ## Goal
   [One-sentence goal, from brainstorming]

   ## Acceptance Criteria

   ### Engineering AC (from pm-to-solo.md / brainstorming)
   - AC-001: [testable description]
   - AC-002: [testable description]

   ### Design AC (from design-to-solo.md, if frontend is involved)
   - DAC-001: [testable design description, e.g. "contrast ≥4.5:1"]
   - DAC-002: [testable design description, e.g. "no overflow at 375px"]

   ## Task Breakdown
   - [ ] T1: [task 1, completable in 2-5 minutes]
   - [ ] T2: [task 2]
   - [ ] T3: [task 3]

   ## Technical Solution
   [Brief: which files to change, what modules to add, key design decisions]

   ## Out of Scope
   [Explicit boundaries to avoid scope creep]
   ```

   **AC source notes**:
   - Engineering AC (AC-xxx): from the PRD (`docs/product/PRD.md` Section 7.1) or `docs/product/prd.json` `features[].acceptance_criteria[]` or brainstorming; describes feature behavior
   - Design AC (DAC-xxx): from `docs/handoff/design-to-solo.md`; describes visual/interaction constraints
   - If there is no design-to-solo.md, skip the Design AC section
   - DAC numbering follows the AC-xxx numbering in design-to-solo.md, with a D prefix to distinguish the source

   *Exit condition: spec.md contains Goal, Acceptance Criteria (AC-xxx list), and Task Breakdown sections, and every AC carries a source annotation (pm-to-solo.md / brainstorming / design-to-solo.md).*

3. **Task Granularity Control**
   Each task should be:
   - Completable in 2-5 minutes (if too large, keep splitting)
   - Independently verifiable (after completion, you can run a test to confirm)
   - Have a clear deliverable (code/test/config)

   *Exit condition: every task in the Task Breakdown fits the 2-5 minute window and has an explicit input (what it consumes) and output (code/test/config it produces).*

4. **Initialize state.yaml**
   Initialize the fields defined in the "state.yaml Schema" section of `loops/LOOP.md`:
   ```yaml
   current_feature: <NNN>-<feature-name>
   iteration: 0
   stage: plan
   status: running
   last_error: ""
   started_at: "YYYY-MM-DDTHH:MM:SS"
   ```
   For field meanings and enum values, see LOOP.md; this SKILL.md does not redefine them.

   *Exit condition: state.yaml is parseable by a YAML parser, with iteration=0 and stage=plan.*

5. **Constitution Review**
   Check that the task breakdown complies with the constitution:
   - Has every new dependency been approved?
   - Do new APIs have a test task?
   - Do schema changes have a migration script task?

   *Exit condition: every checkbox in the constitution review checklist is ticked ✓; un-ticked items are escalated to the user, not silently ignored.*

## Prohibitions
- Task granularity too large ("implement the user system" is not a task, it's an epic)
- Acceptance criteria that are not testable
- Skipping state.yaml initialization (LOOP cannot resume from a breakpoint)
- Not updating spec.md after writing it (if you find the spec is wrong during execution, go back and fix it)

## Anti-Rationalization Table

| Anti-pattern | Common excuse | Why it doesn't hold |
|---|---|---|
| Coding directly without writing spec.md | "I have it all in my head" | executing-plans needs a spec input; without spec.md the LOOP engine cannot schedule tasks |
| ACs without a source annotation | "I came up with them all myself" | ACs without a source cannot be traced back during verify, so failures cannot be routed to the right owner |
| Task granularity too large | "This feature is one thing" | Tasks > 5 minutes cannot be covered by a single tdd cycle and stall LOOP |
| Skipping state.yaml initialization | "I'll create it when I start coding" | The LOOP engine depends on state.yaml; without it, iteration tracking cannot start |
| Skipping constitution review | "Review is too slow" | The constitution is the bottom line; skipping it equals no review and propagates risk into execution |

## Red Flags
- A task description contains the word "and" — it is likely two tasks stitched together and must be split.
- spec.md has no DAC section even though the feature touches the frontend (design-to-solo.md exists).
- state.yaml is missing or has `iteration > 0` at the plan stage — LOOP has already been started or the file was never created.
- AC descriptions contain "should be", "easy to", or "user-friendly" — they are not testable and must be rewritten as "given X, then Y".
- A single task is estimated at > 5 minutes — granularity is too coarse for the tdd cycle and must be split further.

## Relationship with LOOP
This skill corresponds to the PLAN phase of LOOP.
- Output spec.md = the deliverable of PLAN
- Initialize state.yaml = the starting point of LOOP
- writing-plans → LOOP(tdd→verify) → on failure, return to writing-plans to re-plan
