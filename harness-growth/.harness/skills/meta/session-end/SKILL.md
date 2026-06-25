---
name: session-end
description: Session wrap-up, archive progress + write baseline + update board + optionally produce handoff document growth-to-pm.md
---
# Session End

## When to use
- Before claiming a task is complete
- When the user ends the session
- When the session context is near its limit

## Inputs
- memory/progress.md
- loops/specs/*/state.yaml
- FEATURES.md
- docs/handoff/growth-to-pm-template.md

## Outputs
- memory/progress.md
- memory/baseline.json
- memory/archives/
- FEATURES.md
- docs/handoff/growth-to-pm.md

## Core Rules
Archiving must be performed before the session ends; "bare exit" is not allowed — the next session would lose context.

## Process

1. **Update progress.md**
   Complete the current session block with:
   - Completed items (with evidence summary)
   - Pending items (context the next session needs to know)
   - Key decisions (important decisions made this session)
   - Experiment conclusions (growth conclusions reached this session)
   - Exploration mode (if a workflow was used this session, record the current exploration_mode and switch history)

2. **Batch update FEATURES.md**
   Scan `.harness/loops/specs/*/state.yaml`:
   - Experiments with status `done` → change the corresponding experiment status in FEATURES.md to `done`
   - Experiments with status `running` → keep status as `in_progress`
   - Record the last updated date

3. **Write baseline.json** (for entropy-check)
   Compute current project metrics and write them to `.harness/memory/baseline.json`:
   ```json
   {
     "timestamp": "YYYY-MM-DDTHH:MM:SSZ",
     "files": <file count>,
     "loc": <document line count>,
     "experiments": <experiment count>,
     "todos": <TODO count>
   }
   ```
   Computation method (Agent uses tools, no bash dependency):
   - files: use Glob to scan document files (exclude .git/dist)
   - loc: use Read to read each document file and accumulate line counts
   - experiments: count the number of `loops/specs/*/state.yaml`
   - todos: use Grep to search for `TODO|FIXME|XXX` comments

4. **Perform archiving** (mandatory, cross-platform)
   Follow these steps (no bash script dependency):

   **Step 4.1: Detect progress.md line count**
   - Use Read to read `.harness/memory/progress.md`
   - Count lines (≤200 lines → skip archiving, go directly to step 5)

   **Step 4.2: Split archive (when line count > 200)**
   - Use Read to read the full progress.md content
   - Find the position of the last `## Session:` marker (keep the last complete session block)
   - Cut the content before the marker and archive it to `.harness/memory/archives/YYYY-MM-DD-HHMM-progress.md`
   - Use Write to write back progress.md: keep only the last session block + top explanatory line
   - Use Write to write the archive file: the cut historical content

5. **Extract important findings** (if any)
   If this session produced knowledge worth long-term retention (experiment conclusions, growth patterns, pitfalls), write it to `memory/knowledge-base.md`.
   Growth framework specific: experiment conclusions must be written to the knowledge base to avoid repeating experiments.

6. **Produce handoff document** (optional, executed when conditions are met)

   **Write Access Unidirectional Isolation (Non-negotiable)**: Only the producing party may write handoff documents. `growth-to-pm.md` can only be written by Growth. Consumers may only read; modifying upstream handoff documents is prohibited. To provide feedback, use `AskUserQuestion` to have the user relay it, or write it to your own outbound handoff document.

   If this session completed growth work **that can be fed back to harness-pm** (experiment conclusions, growth data, user insights), produce `docs/handoff/growth-to-pm.md` using the `docs/handoff/growth-to-pm-template.md` template:

   **Trigger conditions** (any one met):
   - An experiment's status changed from `in_progress` to `done` this session, and the conclusion is clearly valid/invalid
   - The user explicitly requests "prepare handoff to PM/product"
   - Significant user behavior insights, growth bottlenecks, or market signals are discovered

   **Produced content** (fill in per template):
   - Stage summary: what growth work was completed this time
   - Deliverables list: experiment conclusions, growth data, user insights, etc. (what PM needs to know for decisions)
   - Acceptance Criteria: copy verified hypotheses from spec.md
   - Suggested next steps: what PM can do (e.g., "Experiment proves users prefer X, recommend adjusting product direction")

   **Notes**:
   - If this session has no feedbackable output (pure content production, pure SEO optimization without conclusions), skip this step
   - If `growth-to-pm.md` already exists, append this conclusion; do not overwrite history
   - The filename is fixed as `growth-to-pm.md`; do not split by date (PM only reads the latest state)

   **AC Format Validation** (handoff documents must pass)
   Run Acceptance Criteria format validation on the produced handoff document:
   - Scan the Acceptance Criteria in the handoff document and check that the numbering format is `AC-NNN` (e.g., AC-001, AC-002)
   - Check that numbers are consecutive (AC-001 must not jump directly to AC-003)
   - Check that each AC contains: description + validation method
   - If a format anomaly is found (e.g., "Acceptance Criteria One", non-consecutive numbering, missing validation method), **block the handoff** and require correction before re-producing

## Prohibitions
- Ending the session without updating progress.md (next session loses context)
- Skipping archiving step 4 (progress.md grows unbounded)
- Not writing baseline.json (entropy-check cannot compute growth rate)
- Forcing a .sh script to run in an environment without bash (will hang)
- Not writing experiment conclusions to knowledge-base.md (leads to repeated experiments)

## Relationship with LOOP
This skill runs after LOOP and is the wrap-up of the session.
session-start → ... → LOOP → ... → session-end

## Evidence Requirements
After session-end completes, progress.md must contain:
- What was done this session
- What needs to be continued next session
- The actual result of the archiving operation (e.g., "progress.md cut from 250 lines to 45 lines, archived to archives/2026-06-20-1900-progress.md"; cannot just write "archived")
- If step 6 was executed, record "produced growth-to-pm.md, containing X feedback items"
- If there are experiment conclusions, record "conclusions written to knowledge-base.md"
