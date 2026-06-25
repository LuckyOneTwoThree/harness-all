---
name: session-start
description: Session start, load context to restore working state
---
# Session Start — Session Start

## When to use
- When the Agent receives a new task
- When resuming work across sessions

## Inputs
- SOUL.md
- constitution.md
- memory/progress.md
- memory/knowledge-base.md
- FEATURES.md
- loops/specs/*/state.yaml
- docs/handoff/

## Outputs
- memory/progress.md

## Core Rules
Context must be loaded before the session begins; working with "amnesia" is not allowed.

## Process

1. **Read the progress log**
   Read `.harness/memory/progress.md` to understand where the last session left off and what is pending.

2. **Read the knowledge base** (if relevant)
   Read `.harness/memory/knowledge-base.md` to find design decisions and pitfalls related to the current task.

3. **Check in-progress tasks**
   Scan `.harness/loops/specs/*/state.yaml` to find tasks with status `running` or `retrying`.
   If found, report to the user: "Found in-progress design task X. Continue?"
   Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep").

4. **Read the task board**
   Read `.harness/FEATURES.md` to understand overall project design progress.

5. **Check handoff documents** (from other harness family members)
   Scan the `docs/handoff/` directory:
   - If `pm-to-design.md` exists, report to the user: "Found handoff document (from harness-pm). Consume it in this session?"
   - Handoff documents may include PRD paths, key decisions, and open items; they are important input for design-brief
   - If unconsumed handoff documents exist, remind the user to prioritize them

6. **Confirm task scope**
   Confirm with the user what this session will accomplish, and write a new session block to progress.md:
   ```
   ## Session: YYYY-MM-DD HH:MM
   ### Task
   [Session goal]
   ```

## Prohibitions
- Starting work without reading progress.md (context will be lost)
- Starting work without confirming task scope (may drift off course)

## Relationship with LOOP
This skill runs before LOOP, preparing context for the loop.
session-start → design-brief → new-design/iteration/redesign workflow (with LOOP) → ... → session-end
