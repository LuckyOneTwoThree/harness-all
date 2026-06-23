---
name: session-start
description: Session start, load context to restore working state
triggers:
  - When the Agent receives a new task
  - When resuming work across sessions
reads:
  - SOUL.md
  - constitution.md
  - memory/progress.md
  - memory/knowledge-base.md
  - FEATURES.md
  - loops/specs/*/state.yaml
  - docs/handoff/
writes:
  - memory/progress.md
---

# Session Start

## Core Rules
Context must be loaded before the session starts; working in an "amnesic" state is not allowed.

## Process

1. **Read the progress log**
   Read `.harness/memory/progress.md` to understand where the last session left off and what remains to be continued.

2. **Read the knowledge base** (if relevant)
   Read `.harness/memory/knowledge-base.md` to find technical decisions and pitfall records relevant to the current task.

3. **Check in-progress features**
   Scan `.harness/loops/specs/*/state.yaml` to find features whose status is `running` or `retrying`.
   If any exist, report to the user: "Found in-progress feature X, continue?"
   Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep").

4. **Read the feature board**
   Read `.harness/FEATURES.md` to understand the overall project progress.

5. **Check handoff documents** (from other harness family members)
   Scan the `docs/handoff/` directory:
   - If a `<source>-to-solo.md` file exists, report to the user: "Found handoff document X (from harness-<source>), consume it this session?"
   - Handoff documents may contain PRD paths, key decisions, and open items, and are important inputs for brainstorming.
   - If unconsumed handoff documents exist, remind the user to prioritize them.

6. **Confirm task scope**
   Confirm with the user what this session will do, and write a new session block to progress.md:
   ```
   ## Session: YYYY-MM-DD HH:MM
   ### Task
   [Session goal]
   ```

## Prohibitions
- Starting work without reading progress.md (context will be lost)
- Starting work without confirming the task scope (may drift off course)

## Relationship with LOOP
This skill runs before LOOP, preparing context for the loop.
session-start → brainstorming/writing-plans → LOOP → ... → session-end
