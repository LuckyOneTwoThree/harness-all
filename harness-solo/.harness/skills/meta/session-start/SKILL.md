---
name: session-start
description: Session start, load context to restore working state
---
# Session Start

## When to use
- When the Agent receives a new task
- When resuming work across sessions

## Inputs
- SOUL.md
- constitution.md
- memory/progress.md
- memory/knowledge-base.md
- .harness/FEATURES.md
- loops/specs/*/state.yaml
- docs/handoff/

## Outputs
- memory/progress.md

## Core Rules
Context must be loaded before the session starts; working in an "amnesic" state is not allowed.

## Process

1. **Load context**
   Restore the working state by reading the canonical sources in parallel, then report a consolidated summary to the user.

   - Read `.harness/memory/progress.md` and extract:
     - the **last session summary** (what was done, final state)
     - **open tasks** (started but not marked done)
     - **blocked items** (anything tagged `blocked` / `waiting`)
   - Glob `.harness/loops/specs/*/state.yaml` and read each file:
     - list every feature whose `stage` is not `done`
     - read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep")
     - if any in-progress feature exists, surface it for continuation
   - Glob `docs/handoff/` for unconsumed handoff documents:
     - if a `<source>-to-solo.md` file exists, report it (from harness-<source>)
     - if handoff references `docs/product/PRD.md` or `docs/product/prd.json`, verify those files exist and report their presence
     - if unconsumed handoffs exist, remind the user to prioritize them

   **Conditional triggers** (only fire when progress.md actually demands them — do not read unconditionally):
   - Read `.harness/memory/knowledge-base.md` **only if** progress.md references a knowledge-base entry (e.g., decision id, constraint name). When loaded, extract active decisions and technical constraints.
   - Read `.harness/FEATURES.md` **only if** progress.md mentions an iteration scope change (e.g., new iteration started, scope rebalanced, priority shifted). When loaded, confirm current iteration range and priority order.

   Report to the user in one consolidated message:
   > "Last session: X done, Y in progress, Z blocked. Found handoff: [list or none]. What to work on?"

   - Verify: you can state in one sentence "Last session ended with X done, Y open, Z blocked"; you have an explicit list of open features; you have explicitly checked `docs/handoff/` rather than assuming the user will tell you.

2. **Confirm scope and write the session block**
   Confirm with the user what this session will accomplish, then append a new session block to `progress.md` before any production work begins.
   ```
   ## Session: YYYY-MM-DD HH:MM
   ### Task
   [Session goal]
   ### Context
   - Open features: [list or "none"]
   - Handoff consumed: [yes/no/which]
   ```
   - Verify: the block is written before any production work begins; if the session is interrupted, this block is the recovery point.

## Failure Handling

- **progress.md does not exist** → This is the first session. Create an empty `progress.md` with just a title line, and tell the user: "First session detected — recommend running brainstorming to define the project goal."
- **knowledge-base.md does not exist** → Create an empty file with a title line, and tell the user: "knowledge-base.md will be populated by the first session-end; nothing to load yet."
- **state.yaml fails to parse** (YAML error, missing required fields) → Mark the feature as "needs repair" in your report. Do **not** auto-fix the file. Ask the user how to proceed.
- **Handoff document format is abnormal** (missing sections, unknown source) → Do not block the session. Mark a warning, report it to the user, and continue loading other context.

## Anti-Rationalization Table

| Anti-pattern | Common excuse | Why it doesn't hold |
|---|---|---|
| Skipping progress.md and starting directly | "I remember the last progress" | Cross-session memory is unreliable; progress.md is the single source of truth |
| Skipping the handoff check | "The user will tell me" | Handoff docs carry AC numbers and decisions the user may forget to mention |
| Not confirming task scope | "We'll figure it out as we go" | A session without a goal is context-window waste; drift is invisible until too late |
| Not writing the session block | "I'll write it later" | If the session is interrupted, there is no recovery point |
| Skipping knowledge-base.md | "It's probably empty" | Even one active constraint ignored can invalidate the whole session's output |

## Prohibitions
- Starting work without reading progress.md (context will be lost)
- Starting work without confirming the task scope (may drift off course)
- Auto-fixing a broken state.yaml without asking the user (silent corruption)
- Beginning production work before writing the session block (no recovery point)
- Treating "user did not mention handoff" as "no handoff exists" (you must check the directory)

## Relationship with LOOP
This skill runs before LOOP, preparing context for the loop.
session-start → brainstorming/writing-plans → LOOP → ... → session-end
