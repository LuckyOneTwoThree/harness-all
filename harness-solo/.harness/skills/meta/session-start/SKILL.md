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

1. **Read the progress log**
   Read `.harness/memory/progress.md` to restore the previous working state.
   - Extract the **last session summary** (what was done, what was the final state)
   - Extract **open tasks** (started but not marked done)
   - Extract **blocked items** (anything tagged `blocked` / `waiting`)
   - Verify: you can state in one sentence "Last session ended with X done, Y open, Z blocked"

2. **Read the knowledge base**
   Read `.harness/memory/knowledge-base.md` to load accumulated decisions and constraints.
   - Extract **active decisions** (still in force, not superseded)
   - Extract **technical constraints** (e.g., "must support Node 18", "no new dependencies")
   - Verify: you can name at least one active decision and one constraint before proceeding

3. **Check in-progress features**
   Glob `.harness/loops/specs/*/state.yaml` and read each file.
   - List every feature whose `stage` is not `done` (e.g., `plan`, `act`, `verify`, `retrying`)
   - Read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep")
   - If any in-progress feature exists, report to the user: "Found in-progress feature X (stage=act), continue?"
   - Verify: you have an explicit list of open features; do not rely on memory of "what we were doing"

4. **Read the feature board**
   Read `.harness/FEATURES.md` to understand the iteration scope and priorities.
   - Confirm the **current iteration range** (which features are in scope)
   - Confirm **priority order** (what should be picked next)
   - Verify: you can name the top-priority feature for this iteration

5. **Check handoff documents**
   Scan the `docs/handoff/` directory for documents from other harness family members.
   - If a `<source>-to-solo.md` file exists, report: "Found handoff document X (from harness-<source>), consume it this session?"
   - Handoff documents may contain PRD paths, AC numbers, key decisions, and open items — these are inputs brainstorming cannot skip
   - If handoff references `docs/product/PRD.md` or `docs/product/prd.json`, verify these files exist and report their presence (these are the primary requirements source from harness-pm)
   - If unconsumed handoff documents exist, remind the user to prioritize them
   - Verify: you have explicitly checked the directory, not assumed "user will tell me"

6. **Confirm task scope and write the session block**
   Confirm with the user what this session will accomplish, then append a new session block to `progress.md`:
   ```
   ## Session: YYYY-MM-DD HH:MM
   ### Task
   [Session goal, agreed with the user]
   ### Context Loaded
   - Open features: [list]
   - Handoff consumed: [yes/no/which]
   ```
   - Verify: the block is written before any production work begins; if the session is interrupted, this block is the recovery point

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
