---
name: session-end
description: Session wrap-up, archive progress + write baseline + update board + optionally produce handoff document
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
- docs/handoff/handoff-template.md
- docs/handoff/ops-to-pm-template.md

## Outputs
- memory/progress.md
- memory/baseline.json
- memory/archives/
- FEATURES.md
- docs/handoff/ops-to-pm.md

## Core Rules
Archiving must be performed before the session ends; "bare exit" is not allowed — the next session would lose context.

## Process

1. **Update progress.md**
   Complete the current session block with:
   - Completed items (with evidence summary)
   - Pending items (context the next session needs to know)
   - Key decisions (important decisions made this session)
   - Exploration mode (if a workflow was used this session, record the current exploration_mode and switch history)

2. **Batch update FEATURES.md**
   Scan `.harness/loops/specs/*/state.yaml`:
   - Tasks with status `done` → change the corresponding task status in FEATURES.md to `done`
   - Tasks with status `running` → keep status as `in_progress`
   - Record the last updated date

3. **Write baseline.json** (for entropy-check)
   Compute current project metrics and write them to `.harness/memory/baseline.json`:
   ```json
   {
     "timestamp": "YYYY-MM-DDTHH:MM:SSZ",
     "files": <file count>,
     "loc": <lines of code>,
     "deps": <dependency count>,
     "todos": <TODO count>
   }
   ```
   Computation method (Agent uses tools, no bash dependency):
   - files: use Glob to scan IaC files (.tf/.yml/.yaml) + script files
   - loc: use Read to read each file and accumulate line counts
   - deps: read Terraform/K8s dependency manifests
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
   If this session produced knowledge worth long-term retention (incident conclusions, ops patterns, pitfalls), write it to `memory/knowledge-base.md`.

6. **Produce handoff document** (optional, executed when conditions are met)

   **Write Access Unidirectional Isolation (Non-negotiable)**: Only the producing party may write handoff documents. `ops-to-pm.md` can only be written by Ops. Consumers may only read; modifying upstream handoff documents is prohibited. To provide feedback, use `AskUserQuestion` to have the user relay it, or write it to your own outbound handoff document.

   If this session completed **ops tasks that can be fed back to PM** (e.g., successful deployment, SLA report, incident postmortem), produce `docs/handoff/ops-to-pm.md` using the `docs/handoff/ops-to-pm-template.md` template:

   **Trigger conditions** (any one met):
   - A task's status changed from `running` to `done` this session (successful deployment)
   - This session handled a production incident (needs to be reported to PM)
   - The user explicitly requests "prepare SLA report for PM"
   - This session discovered production environment risks (PM needs to plan remediation)

   **Produced content** (fill in per ops-to-pm-template.md):
   - Availability summary (SLA, resource utilization and cost)
   - Incident and outage reports (if any)
   - Ops recommendations for the business (e.g., need to plan hot/cold data separation, need disaster recovery refactoring)

   **Notes**:
   - If this session has no externally deliverable output (pure monitoring config, pure IaC maintenance), skip this step
   - If `ops-to-pm.md` already exists, append this content; do not overwrite history
   - The filename is fixed as `ops-to-pm.md`; do not split by date (downstream only reads the latest state)

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

## Relationship with LOOP
This skill runs after LOOP and is the wrap-up of the session.
session-start → ... → LOOP → ... → session-end

## Evidence Requirements
After session-end completes, progress.md must contain:
- What was done this session
- What needs to be continued next session
- The actual result of the archiving operation (e.g., "progress.md cut from 250 lines to 45 lines, archived to archives/2026-06-20-1900-progress.md")
- If step 6 was executed, record "produced ops-to-pm.md, containing X feedback items"
