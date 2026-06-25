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
- FEATURES.md
- loops/specs/*/state.yaml
- docs/handoff/

## Outputs
- memory/progress.md

## Core Rules
Context must be loaded before the session starts; working in an "amnesic" state is not allowed.

## Process

1. **Read the progress log**
   Read `.harness/memory/progress.md` to understand where the last session left off and what remains to be continued.

2. **Read the knowledge base** (if relevant)
   Read `.harness/memory/knowledge-base.md` to find experiment conclusions, growth patterns, and pitfall records relevant to the current task.
   Growth framework specific: avoid repeating already-disproven experiments.

3. **Check in-progress experiments**
   Scan `.harness/loops/specs/*/state.yaml` to find experiments whose status is `running` or `retrying`.
   If any exist, report to the user: "Found in-progress experiment X (current stage: Y), continue?"
   Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep").

4. **Read the experiment board**
   Read `.harness/FEATURES.md` to understand the overall growth progress of the project.

5. **Check handoff documents** (from other harness family members)
   Scan the `docs/handoff/` directory:
   - If a `solo-to-growth.md` file exists (from harness-solo), report to the user: "Found handoff document solo-to-growth.md (from harness-solo), consume it this session?"
   - This document may contain new feature release info, trackable events, API endpoints, etc., and is an important input for growth work.
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
- Starting experiments without reading knowledge-base.md (may repeat already-disproven experiments)

## Relationship with LOOP
This skill runs before LOOP, preparing context for the loop.
session-start → growth skill → LOOP(plan→experiment→measure) → ... → session-end

## Handoff Document Reminder
The outbound handoff document for this framework is `docs/handoff/growth-to-pm.md` (growth data fed back to PM).
If this session has growth data/conclusions that can be fed back to PM, session-end will produce it at session close.
