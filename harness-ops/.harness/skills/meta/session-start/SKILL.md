---
name: session-start
description: Session start, load context to restore working state
---
# Session Start

## When to use
- When the Agent receives a new deployment/troubleshooting task
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
   Read `.harness/memory/knowledge-base.md` to find incident conclusions, ops patterns, and pitfall records relevant to the current task.

3. **Check in-progress tasks**
   Scan `.harness/loops/specs/*/state.yaml` to find tasks whose status is `running` or `retrying`.
   If any exist, report to the user: "Found in-progress task X, continue?"
   Also read the `exploration_mode` field and report the current mode (e.g., "Current exploration mode: deep").

4. **Read the feature board**
   Read `.harness/FEATURES.md` to understand the overall progress of ops tasks.

5. **Check handoff documents** (from other harness family members)
   Scan `docs/handoff/` and validate inbound packages with `.harness/rules/handoff-protocol.md` before consumption:
   - If a `solo-to-ops.md` file exists, report to the user: "Found engineering delivery document (from harness-solo), consume it this session to execute deployment?"
   - The handoff document contains image tags, environment variable lists, database migration scripts, and rollback plans, and is an important input for deployment.
   - If valid unconsumed handoffs exist, prioritize them. Never deploy from a draft, wrong-consumer, stale, incomplete, or hash-invalid package.
   - After successful consumption of `solo-to-ops.md`, write `docs/handoff/receipts/<handoff_id>-receipt.json` with `consumer: harness-ops`, `consumed_at`, `manifest_sha256`, `status` (`accepted`/`rejected`), and `reasons`. Never edit the producer contract.

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
session-start → deployment/troubleshooting skill → LOOP → ... → session-end
