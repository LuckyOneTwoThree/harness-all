---
name: session-end
description: Session wrap-up, archive progress + write baseline + update board + optionally produce handoff documents
---
# Session End

## When to use
- Before claiming a task is complete
- When the user ends the session
- When the session context is near its limit

## Inputs
- memory/progress.md
- loops/specs/*/state.yaml
- .harness/FEATURES.md
- docs/handoff/handoff-template.md
- docs/handoff/solo-to-growth-template.md
- docs/handoff/solo-to-ops-template.md
- docs/handoff/solo-to-pm-template.md

## Outputs
- memory/progress.md
- memory/baseline.json
- memory/archives/
- FEATURES.md
- docs/handoff/solo-to-growth.md
- docs/handoff/solo-to-ops.md
- docs/handoff/solo-to-pm.md

## Core Rules
Archiving must be performed before the session ends; "bare exit" is not allowed — the next session would lose context.

## Process

1. **Update progress.md + extract findings**
   Complete the current session block with:
   - Completed items (with evidence summary)
   - Pending items (context the next session needs to know)
   - Key decisions (important decisions made this session)
   - Exploration mode (if a workflow was used this session, record the current exploration_mode and switch history)

   **Conditional: batch update FEATURES.md** (only executed when feature status changed this session)
   Scan `.harness/loops/specs/*/state.yaml`:
   - Features with status `done` → change the corresponding feature status in FEATURES.md to `done`
   - Features with status `running` → keep status as `in_progress`
   - Record the last updated date

   **Conditional: extract important findings** (only executed when this session produced knowledge worth long-term retention)
   If this session produced knowledge worth long-term retention (technical decisions, pitfalls, patterns), write it to `memory/knowledge-base.md`.

   **Exit condition**: progress.md has been updated; FEATURES.md has been synced if there were status changes; knowledge-base has been recorded if there were valuable findings.

2. **Write baseline.json** (for entropy-check, simplified)
   Compute current project metrics and write them to `.harness/memory/baseline.json`:
   ```json
   {
     "version": 1,
     "captured_at": "YYYY-MM-DD HH:MM",
     "files": <file count>,
     "loc": <approximate lines of code>,
     "deps": <dependency count>,
     "todos": <TODO count>
   }
   ```
   Computation method (Agent uses tools, no bash dependency; simplified to reduce compute cost, no per-line LOC counting):
   - files: use Glob to scan source files (exclude node_modules/.git/dist)
   - loc: estimate from Glob results rather than reading each source file line by line (approximate value, lower compute cost)
   - deps: read package.json/Cargo.toml/go.mod and other dependency manifests, count dependencies
   - todos: use Grep to search for `TODO|FIXME|XXX` comments, count matches

3. **Conditional: archive + handoff** (all sub-conditions are conditional; only execute when the corresponding condition is met; if no condition is met, end directly)

   **Write Access Unidirectional Isolation (Non-negotiable)**: Only the producing party may write handoff documents. `solo-to-growth.md` can only be written by Solo, and `solo-to-ops.md` can only be written by Solo. Consumers may only read; modifying upstream handoff documents is prohibited. To provide feedback, use `AskUserQuestion` to have the user relay it, or write it to your own outbound handoff document.

   **Condition 1: progress.md line count > 200 → perform archiving** (cross-platform, no bash script dependency)

   - **Step 3.1: Detect progress.md line count**
     - Use Read to read `.harness/memory/progress.md`
     - Count lines (≤200 lines → skip archiving, this condition is not triggered)

   - **Step 3.2: Split archive (when line count > 200)**
     - Use Read to read the full progress.md content
     - Find the position of the last `## Session:` marker (keep the last complete session block)
     - Cut the content before the marker and archive it to `.harness/memory/archives/YYYY-MM-DD-HHMM-progress.md`
     - Use Write to write back progress.md: keep only the last session block + top explanatory line
     - Use Write to write the archive file: the cut historical content

   - **Step 3.3: Optional script fallback**
     If bash is available in the current environment (e.g., macOS/Linux/Git Bash), you may run:
     ```bash
     bash .harness/scripts/archive-progress.sh
     ```
     The script logic is identical to the steps above and serves as an optional fallback. **On Windows or in environments without bash, you must use the tool operations in steps 3.1-3.2.**

   **Condition 2: solo-to-growth trigger met → produce solo-to-growth.md**
   If this session completed a **publishable/deliverable-to-downstream** feature (e.g., a new API or new page needed by harness-growth), produce `docs/handoff/solo-to-growth.md` using the `docs/handoff/solo-to-growth-template.md` template:

   **Trigger conditions** (any one met):
   - A feature's status changed from `in_progress` to `done` this session
   - The user explicitly requests "prepare handoff to growth/ops"
   - The completed feature involves external APIs, user-visible pages, or trackable events

   **Produced content** (fill in per solo-to-growth-template.md):
   - List of implemented features (API endpoints / page paths / event names)
   - Acceptance Criteria (AC-xxx + DAC-xxx, passed)
   - Performance metrics (LCP / INP / API response / test coverage)
   - List of tracking events (event name / trigger timing / parameters / associated AC)
   - Known issues and limitations

   **Notes**:
   - If this session has no externally deliverable output (pure refactor, pure bug fix), skip this condition
   - If `solo-to-growth.md` already exists, append this delivery's content; do not overwrite history
   - The filename is fixed as `solo-to-growth.md`; do not split by date (downstream only reads the latest state)

   **Condition 3: solo-to-ops trigger met → produce solo-to-ops.md**
   If this session completed a feature that is **merged into the main branch and needs to be released online**, produce `docs/handoff/solo-to-ops.md` using the `docs/handoff/solo-to-ops-template.md` template:

   **Trigger conditions** (any one met):
   - A feature was merged into the main branch (main/master) this session and is planned for release
   - The user explicitly requests "prepare release" or "prepare handoff to ops"
   - This change involves environment variables, database migrations, or deployment configuration changes

   **Produced content** (fill in per solo-to-ops-template.md):
   - Artifact version (image tag or code commit hash)
   - Environment variable list (config items to add/remove/modify for this deployment)
   - Database scripts (whether migrations are included and their execution order)
   - Smoke tests (checkpoints to verify deployment success)
   - Rollback plan (degradation or code rollback measures in case of errors)

   **Notes**:
   - If this session has no release plan (pure local development, not merged into main), skip this condition
   - If `solo-to-ops.md` already exists, append this delivery's content; do not overwrite history
   - The filename is fixed as `solo-to-ops.md`; do not split by date (downstream only reads the latest state)

   **Condition 4: solo-to-pm trigger met → produce solo-to-pm.md**
   If this session surfaced **engineering feedback that should reach harness-pm** (e.g., technical constraints that affect product scope, user-feedback themes observed during implementation, suggested product adjustments), produce `docs/handoff/solo-to-pm.md` using the `docs/handoff/solo-to-pm-template.md` template:

   **Trigger conditions** (any one met):
   - The user explicitly requests "prepare engineering feedback to PM" or "handoff to PM"
   - Implementation surfaced technical constraints that require PRD / scope adjustments
   - Dev-side observations or early user signals warrant PM triage

   **Produced content** (fill in per solo-to-pm-template.md):
   - Engineering metrics & issues (LCP / INP / API response / test coverage / known bugs / tech debt)
   - User feedback from implementation (themes + source + severity + suggested action)
   - Technical constraints discovered (constraint + rationale + impact + suggested adjustment)
   - Suggested product adjustments (suggestion + reason + priority + affected AC)

   **Notes**:
   - If this session has no engineering feedback for PM (pure deliverable, no constraints or feedback), skip this condition
   - If `solo-to-pm.md` already exists, append this session's feedback; do not overwrite history
   - The filename is fixed as `solo-to-pm.md`; do not split by date (downstream only reads the latest state)

   **Condition 5: any handoff document generated in conditions 2/3/4 → run AC format validation**
   Run Acceptance Criteria format validation on the handoff documents produced in conditions 2/3/4:
   - Scan the Acceptance Criteria in the handoff document and check that the numbering format is `AC-NNN` (e.g., AC-001, AC-002)
   - Check that numbers are consecutive (AC-001 must not jump directly to AC-003)
   - Check that each AC contains: description + validation method
   - If a format anomaly is found (e.g., "Acceptance Criteria One", non-consecutive numbering, missing validation method), **block the handoff** and require correction before re-producing

   **Exit condition**: all conditions have been checked; the ones requiring execution have been executed; no conditions met → end directly.

## Prohibitions
- Ending the session without updating progress.md (next session loses context)
- Skipping archiving when progress.md exceeds 200 lines (progress.md grows unbounded)
- Not writing baseline.json (entropy-check cannot compute growth rate)
- Forcing a .sh script to run in an environment without bash (will hang)

## Relationship with LOOP
This skill runs after LOOP and is the wrap-up of the session.
session-start → ... → LOOP → ... → session-end

## Evidence Requirements
After session-end completes, progress.md must contain:
- What was done this session
- What needs to be continued next session
- The actual result of the archiving operation (e.g., "progress.md cut from 250 lines to 45 lines, archived to archives/2026-06-20-1900-progress.md"; cannot just write "archived")
- If solo-to-growth.md was produced (step 3 condition 2), record "produced solo-to-growth.md, containing X delivery items"
- If solo-to-ops.md was produced (step 3 condition 3), record "produced solo-to-ops.md, containing artifact version / environment variables / database scripts / smoke tests / rollback plan"
- If solo-to-pm.md was produced (step 3 condition 4), record "produced solo-to-pm.md, containing engineering metrics / user feedback / technical constraints / suggested product adjustments"
