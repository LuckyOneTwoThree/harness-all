---
name: session-end
description: Session wrap-up, archive progress + write baseline + update board + optionally produce handoff documents
---
# Session End — Session Wrap-up

## When to use
- Before claiming task completion
- When the user ends the session
- When session context is near the limit

## Inputs
- memory/progress.md
- loops/specs/*/state.yaml
- FEATURES.md
- docs/handoff/templates/handoff-template.md
- docs/handoff/templates/pm-to-design-template.md
- docs/handoff/templates/pm-to-solo-template.md
- docs/discovery/user-research.md
- docs/discovery/market-analysis.md

## Outputs
- memory/progress.md
- memory/baseline.json
- memory/archives/
- FEATURES.md
- docs/handoff/pm-to-solo.md
- docs/handoff/pm-to-design.md

## Core Rules
Archiving is required before the session ends; "bare exit" is not allowed — the next session will lose context.

## Process

1. **Update progress.md**
   Complete the current session block with:
   - Completed items (with evidence summary)
   - Pending items (context the next session needs to know)
   - Key decisions (important decisions made in this session)
   - Exploration mode (if this session used a workflow, record the current exploration_mode and switching history)

2. **Batch update FEATURES.md**
   Scan `.harness/loops/specs/*/state.yaml`:
   - Tasks with status `done` → change the corresponding feature status in FEATURES.md to `approved` or `review`
   - Tasks with status `running` → keep status as `in_progress`
   - Record the last updated date
   - **Solo-feedback-driven advancement**: if a consumed `solo-to-pm.md` reports a feature as `done` in its "Implemented Features" section (per FEATURES.md Cross-Framework Reconciliation, see DOMAIN_BOUNDARIES.md):
     - Advance FEATURES.md status from `approved` → `developing` (Solo has started/finished work)
     - If PM has also made a launch decision, advance to `launched`
     - PM never marks `launched` without its own launch decision

3. **Write baseline.json** (for entropy-check)
   Compute current project metrics and write to `.harness/memory/baseline.json`:
   ```json
   {
     "timestamp": "YYYY-MM-DDTHH:MM:SSZ",
     "docs": <document count>,
     "skills_used": <number of skills used>,
     "outputs": <output file count>,
     "pending_decisions": <pending decision count>
   }
   ```
   Computation method (Agent uses tools, no bash dependency):
   - docs: use Glob to scan .md files under docs/
   - skills_used: count skills invoked this session from progress.md
   - outputs: use Glob to scan .md files under docs/
   - pending_decisions: count features with pending/review status in FEATURES.md

4. **Execute archiving** (mandatory, cross-platform)
   Follow these steps (no bash script dependency):

   **Step 4.1: Detect progress.md line count**
   - Use Read to read `.harness/memory/progress.md`
   - Count lines (≤200 lines → skip archiving, go directly to step 5)

   **Step 4.2: Rotate (line count > 200)**
   - Use Read to read the full progress.md content
   - Find the position of the last `## Session:` marker (keep the last complete session block)
   - Cut the content before the marker and archive it to `.harness/memory/archives/YYYY-MM-DD-HHMM-progress.md`
   - Use Write to write back progress.md: keep only the last session block + top explanatory line
   - Use Write to write the archive file: the cut historical content

5. **Extract important findings** (if any)
   If this session produced knowledge worth long-term retention (product decisions, user insights, market findings), write it to `memory/knowledge-base.md`.

6. **Produce handoff documents** (optional, executed when conditions are met)

   **Write Access Unidirectional Isolation (Non-negotiable)**: Only the producer can write to a handoff document. `pm-to-solo.md` can only be written by PM, `pm-to-design.md` can only be written by PM, and so on. Consumers can only read; modifying upstream handoff documents is prohibited. To provide feedback, use `AskUserQuestion` to relay through the user, or write to your own outbound handoff document.

   Based on this session's output type, generate the corresponding handoff document:

   **6a. Produce pm-to-solo.md** (Product → Engineering)
   If this session completed a product design **handable to engineering** (e.g., PRD, design specs, instrumentation plan), produce `docs/handoff/pm-to-solo.md` using the `docs/handoff/templates/pm-to-solo-template.md` template:

   **Trigger conditions** (any one met):
   - A feature status changed from `in_progress` to `approved` this session
   - The user explicitly requested "prepare handoff to engineering"
   - Completed tasks involve PRD, design specs, instrumentation plan, or other engineering-required outputs

   **Output content** (fill in per pm-to-solo-template.md):
   - Product basic info (product type / tech stack / platform / current phase)
   - PRD path + AC-xxx list
   - **Business Context Digest** (see 6a.1)
   - Feature priority (P0/P1/P2)
   - Instrumentation plan path (if any)
   - Design asset status (pending harness-design output / ready)

   **6a.1 Business Context Digest extraction** (6a sub-step):
   - Read `docs/discovery/user-research.md` and `docs/discovery/market-analysis.md` (skip if absent; record "No additional business context; use the stated ACs")
   - **Extract only constraints that affect engineering decisions**; do not extract personas/mental models/aesthetic preferences (those go to design, not engineering)
   - Extraction scope: constraints affecting architecture/tech selection/performance requirements/capacity planning/data scale
   - For each constraint fill in: constraint item + engineering impact + source (filename#section)
   - Write to the "Business Context Digest" section of pm-to-solo.md

   **6b. Produce pm-to-design.md** (Product → Design)
   If this session completed product requirements **handable to design** (e.g., PRD, positioning statement, Persona, user profile), produce `docs/handoff/pm-to-design.md` using the `docs/handoff/templates/pm-to-design-template.md` template:

   **Trigger conditions** (any one met):
   - This session produced a PRD or updated core PRD fields (product type / target audience / Persona / AC)
   - The user explicitly requested "prepare handoff to design"
   - Completed tasks involve positioning statement, user profile, feature requirements, or other design-consumed content

   **Output content** (fill in per pm-to-design-template.md):
   - Product type / target audience / tech stack
   - Persona path / positioning statement
   - PRD path (with AC-xxx numbered list)
   - Style keywords / out-of-scope list
   - Existing design system asset paths (if any)

   **Notes**:
   - If this session has no externally deliverable output (pure research, pure analysis), skip this step
   - Each fixed file is a current pointer containing one latest contract; never append a second delivery body
   - If a current pointer exists, archive its unchanged content to `docs/handoff/archive/<handoff_id>.md`, then write the new contract with `supersedes: <previous-id>` and `status: ready`
   - Consumers read the fixed current pointer by default; archives are only for audit/history
   - Multiple files can be produced simultaneously (e.g., this session completed both PRD and positioning statement; PRD goes to engineering, positioning goes to design)

   **6c. AC format validation** (handoff documents must pass)
   Run acceptance criteria format validation on the handoff documents produced in steps 6a/6b:
   - Validate product IDs as `AC-<feature>-<sequence>` (for example `AC-F01-001`) using `.harness/rules/acceptance-id-protocol.md`
   - Allow gaps; reject renumbering, reuse, duplicate IDs, changed text under the same ID, or envelope/body mismatch
   - Check that each AC contains description, validation method, source handoff/revision, scope, and lifecycle status
   - Block publication on any anomaly; never "repair" an ID by resequencing existing criteria

   **6d. Batch field filling** (applies to 6a/6b handoff envelopes)

   When producing pm-to-solo.md or pm-to-design.md, fill the `batch` block in the envelope per handoff-template.md:
   - `id`: integer starting at 1; increment for each successive delivery on the same channel (pm-to-solo and pm-to-design each maintain an independent counter)
   - `type`: `full` for the first delivery on a channel OR when re-broadcasting the complete AC set; `incremental` for subsequent deliveries that diff against the previous consumed handoff
   - `added_acs`: AC IDs newly introduced in this delivery (not present in the previous consumed handoff's ac_ids)
   - `modified_acs`: AC IDs whose criterion text/scope changed (same ID, new content)
   - `superseded_acs`: AC IDs explicitly retired and replaced by new IDs (these do NOT appear in ac_ids; only their replacements appear in added_acs)
   - `unchanged_acs`: AC IDs carried over with no change

   When `type: full`, `modified_acs`/`superseded_acs`/`unchanged_acs` are typically empty (all ACs are `added_acs`). When `type: incremental`, partition the current `ac_ids` into added/modified/unchanged by comparing against the previous consumed handoff's ac_ids.

   Read `state.yaml.ac_change` (written by session-start step 5a or prd-orchestrator phase 0 when consuming inbound feedback) as the primary signal for added/superseded ACs when this session consumed solo-to-pm or design-to-pm feedback.

## Handoff Publication Gate

For every outbound contract, apply `.harness/rules/handoff-protocol.md` and `.harness/rules/acceptance-id-protocol.md`. Build `docs/handoff/packages/<handoff_id>/{manifest.json,contract.md,artifacts/...}`, use package-relative paths, record SHA-256/size for every artifact, validate envelope/body ID parity, then archive and replace the current pointer. Do not publish `ready` until the self-contained package validates.

## Prohibited
- Ending without updating progress.md (next session loses context)
- Skipping archiving step 4 (progress.md grows unbounded)
- Not writing baseline.json (entropy-check cannot compute growth rate)
- Forcing .sh script execution in a bash-less environment (will hang)

## Relationship with LOOP
This skill runs after LOOP, as the session wrap-up.
session-start → ... → LOOP → ... → session-end

## Evidence Requirements
After session-end completes, progress.md must contain:
- What this session did
- What the next session needs to continue
- The actual result of the archiving operation (e.g., "progress.md cut from 250 lines to 45 lines, archived to archives/2026-06-20-1900-progress.md")
- If step 6a was executed, record "produced pm-to-solo.md, containing X delivery items + Business Context Digest with X constraints"
- If step 6b was executed, record "produced pm-to-design.md, containing PRD path + X ACs + Persona path"
