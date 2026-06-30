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
   Read `.harness/memory/knowledge-base.md` to find product decisions, user insights, and pitfalls related to the current task.

3. **Check in-progress tasks**
   Scan `.harness/loops/specs/*/state.yaml` to find tasks with status `running` or `retrying`.
   If found, report to the user: "Found in-progress task X (phase Y, iteration Z). Continue?"
   Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep").

4. **Read the feature board**
   Read `.harness/FEATURES.md` to understand overall product progress.

5. **Check handoff documents** (from other harness family members)
   Scan `docs/handoff/` and apply `.harness/rules/handoff-protocol.md` before consuming any contract:
   - If `solo-to-pm.md` exists (from harness-solo), report to the user: "Found engineering feedback document X. Consume it in this session?"
   - Engineering feedback may include: implemented features, technical constraints, open issues.
   - If `growth-to-pm.md` exists (from harness-growth), report the growth data feedback.
   - If `design-to-pm.md` exists, validate it, report its feedback IDs, and route accepted consumption to prd-orchestrator phase 0.
   - If valid unconsumed handoffs exist, remind the user to prioritize them. Report invalid handoffs precisely and do not consume them partially.

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
- Starting a new task without checking in-progress tasks (may duplicate work)

## Relationship with LOOP
This skill runs before LOOP, preparing context for the loop.
session-start → exploration/design/analysis → LOOP → ... → session-end
