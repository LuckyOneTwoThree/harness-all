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
- docs/handoff/templates/pm-to-engineering-template.md
- docs/discovery/user-research.md
- docs/discovery/market-analysis.md

## Outputs
- memory/progress.md
- memory/baseline.json
- memory/archives/
- FEATURES.md
- docs/handoff/pm-to-engineering.md

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
   Scan `loops/specs/*/state.yaml`:
   - Tasks with status `done` → change the corresponding feature status in FEATURES.md to `approved` or `review`
   - Tasks with status `running` → keep status as `in_progress`
   - Record the last updated date
   - **Engineering-feedback-driven advancement**: if a consumed `engineering-to-pm.md` reports a feature as `done` in its "Implemented Features" section (per FEATURES.md Cross-Framework Reconciliation, see the family-level DOMAIN_BOUNDARIES.md in the harness-all repo root; absent in standalone PM install):
     - Advance FEATURES.md status from `approved` → `developing` (engineering has started/finished work)
     - If PM has also made a launch decision, advance to `launched`
     - PM never marks `launched` without its own launch decision

3. **Write baseline.json** (for cross-session metric comparison)
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

4. **Delegate archiving to memory-maintenance** (when thresholds are exceeded)
   Check retention thresholds, then invoke `memory-maintenance` as the sole owner of progress/knowledge/iteration/archive rotation. Session-end does not implement a second archive algorithm. Progress recording is mandatory; archival is conditional on retention thresholds.

   - Use Read to read `.harness/memory/progress.md` and count lines
   - If ≤200 lines → skip archiving, go directly to step 5
   - If >200 lines → invoke `memory-maintenance` skill to execute archive rotation (progress.md splitting, knowledge-base.md trimming, iterations.log archival, old archive cleanup, and index.json rebuild)

5. **Extract important findings** (if any)
   If this session produced knowledge worth long-term retention (product decisions, user insights, market findings), write it to `memory/knowledge-base.md`.

6. **Produce handoff document** (optional, executed when conditions are met)

   **Write Access Unidirectional Isolation (Non-negotiable)**: Only the producer can write to a handoff document. `pm-to-engineering.md` can only be written by PM. Consumers (harness-engineering) can only read; modifying upstream handoff documents is prohibited. To provide feedback, use `AskUserQuestion` to relay through the user, or write to your own outbound handoff document (`engineering-to-pm.md`).

   Based on this session's output type, generate the corresponding handoff document:

   **6a. Produce pm-to-engineering.md** (Product → Engineering)
   If this session completed a product design **handable to engineering** (e.g., PRD, API contract, design asset paths, instrumentation plan), produce `docs/handoff/pm-to-engineering.md` using the `docs/handoff/templates/pm-to-engineering-template.md` template:

   **Draft PRD check**: Before producing handoff, read `docs/product/PRD.md` and check if it contains `> **Status**: DRAFT`. If yes:
   - pm-to-engineering.md header must include `⚠️ DRAFT PRD — not yet validated through full discovery`
   - progress.md must record `prd_status: draft`
   - Prompt user: "Your PRD is in draft status. It's usable for coding but not production-ready. Upgrade to full PRD via new-product or iteration workflow before production launch."
   - Do NOT block handoff production — draft PRD is intentionally handable to engineering for prototyping/coding

   **Trigger conditions** (any one met):
   - A feature status changed from `in_progress` to `approved` this session
   - The user explicitly requested "prepare handoff to engineering"
   - Completed tasks involve PRD, API contract, design asset collection, instrumentation plan, or other engineering-required outputs

   **Output content** (fill in per pm-to-engineering-template.md):
   - Project Mode & Routing (project_mode / exploration_mode / task_type / scope) — see 6a.0
   - Product basic info (product type / tech stack / platform / current phase)
   - PRD path + AC-xxx list
   - API contract (PRD Section 3.2.6 by default; OpenAPI in deep mode)
   - Design asset paths (user-provided Figma/v0/md/image paths)
   - Business Context Digest (see 6a.1)
   - Feature priority (P0/P1/P2)
   - Instrumentation plan path (if any)

   **6a.0 Project Mode & Routing fields** (6a sub-step):
   Determine the four routing fields and write to the "Project Mode & Routing" section of pm-to-engineering.md:
   - `project_mode`: `fullstack` (default; one repo with app/+api/+lib/) OR `separate` (two roots: React+Express style). Source priority: user explicit choice > PRD frontmatter `project_mode` > `fullstack`.
   - `exploration_mode`: `skip` (only Phase 3 integration) / `standard` (Phase 0→1→2→3) / `deep` (+OpenAPI contract). Source priority: user explicit choice > PRD frontmatter `exploration_mode` > `standard`.
   - `task_type`: `new-feature` (default) / `bugfix` / `refactor` / `migration` / `optimize` / `release`. Source: this session's primary work type.
   - `scope`: `full` (default) / `frontend` / `backend`. Source: PRD scope declaration or user explicit choice.
   These four fields are advisory routing hints, not hard constraints — engineering may extend scope with user confirmation.

   **6a.1 Business Context Digest extraction** (6a sub-step):
   - Read `docs/discovery/user-research.md` and `docs/discovery/market-analysis.md` (skip if absent; record "No additional business context; use the stated ACs")
   - **Extract only constraints that affect engineering decisions**; do not extract personas/mental models/aesthetic preferences (aesthetic preferences belong in design assets, not engineering constraints)
   - Extraction scope: constraints affecting architecture/tech selection/performance requirements/capacity planning/data scale
   - For each constraint fill in: constraint item + engineering impact + source (filename#section)
   - Write to the "Business Context Digest" section of pm-to-engineering.md

   **6a.2 Design asset path collection** (6a sub-step):
   - If the user provided design assets (Figma links / v0 exports / markdown designs / image files) during PRD design, list their paths in the "Design Assets" section
   - Copy or reference the asset paths into the handoff package `artifacts/design-assets/` directory
   - If no design assets were provided, write "No design assets provided; engineering proceeds with PRD-only mode (degraded visual fidelity)" — engineering Phase 0 will produce contract.json + tokens.json based on PRD alone

   **6b. AC format validation** (handoff documents must pass)
   Run acceptance criteria format validation on the handoff document produced in step 6a:
   - Validate product IDs as `AC-<feature>-<sequence>` (for example `AC-F01-001`) using `.harness/rules/acceptance-id-protocol.md`
   - Allow gaps; reject renumbering, reuse, duplicate IDs, changed text under the same ID, or envelope/body mismatch
   - Check that each AC contains description, validation method, source handoff/revision, scope, and lifecycle status
   - Block publication on any anomaly; never "repair" an ID by resequencing existing criteria
   - Note: BAC-xxx (backend acceptance) and IAC-xxx (integration acceptance) are produced by harness-engineering, not PM — do not include them in pm-to-engineering.md

   **6c. Batch field filling** (applies to 6a handoff envelope)

   When producing pm-to-engineering.md, fill the `batch` block in the envelope per handoff-template.md:
   - `id`: integer starting at 1; increment for each successive delivery on the same channel (pm-to-engineering maintains an independent counter)
   - `type`: `full` for the first delivery on the channel OR when re-broadcasting the complete AC set; `incremental` for subsequent deliveries that diff against the previous consumed handoff
   - `added_acs`: AC IDs newly introduced in this delivery (not present in the previous consumed handoff's ac_ids)
   - `modified_acs`: AC IDs whose criterion text/scope changed under the same ID (reverse feedback channel only; forward delivery should use supersede + new ID per the stable AC principle)
   - `superseded_acs`: AC IDs explicitly retired and replaced by new IDs (these do NOT appear in ac_ids; only their replacements appear in added_acs)
   - `unchanged_acs`: AC IDs carried over with no change

   When `type: full`, `modified_acs`/`superseded_acs`/`unchanged_acs` are typically empty (all ACs are `added_acs`). When `type: incremental`, partition the current `ac_ids` into added/modified/unchanged by comparing against the previous consumed handoff's ac_ids.

   Read `state.yaml.ac_change` (written by session-start step 5a or prd-orchestrator phase 0 when consuming inbound feedback) as the primary signal for added/superseded ACs when this session consumed engineering-to-pm feedback.

   **Notes**:
   - If this session has no externally deliverable output (pure research, pure analysis), skip step 6 entirely
   - Each fixed file is a current pointer containing one latest contract; never append a second delivery body
   - If a current pointer exists, archive its unchanged content to `docs/handoff/archive/<handoff_id>.md`, then write the new contract with `supersedes: <previous-id>` and `status: ready`
   - Consumers read the fixed current pointer by default; archives are only for audit/history

## Handoff Publication Gate

For every outbound contract, apply `.harness/rules/handoff-protocol.md` and `.harness/rules/acceptance-id-protocol.md`. Build `docs/handoff/packages/<handoff_id>/{manifest.json,contract.md,artifacts/...}`, use package-relative paths, record SHA-256/size for every artifact, validate envelope/body ID parity, then archive and replace the current pointer. Do not publish `ready` until the self-contained package validates.

## Prohibited
- Ending without updating progress.md (next session loses context)
- Skipping threshold check in step 4 (progress.md grows unbounded)
- Duplicating memory-maintenance archiving logic (session-end delegates, does not implement a second archive algorithm)
- Not writing baseline.json (next session-start cannot compute cross-session metric deltas)
- Forcing .sh script execution in a bash-less environment (will hang)
- Producing pm-to-design.md or pm-to-solo.md (obsolete; only pm-to-engineering.md is valid under the two-framework architecture)
- Producing design outputs directly (PM only collects design asset paths; visual design is owned by the user)

## Relationship with LOOP
This skill runs after LOOP, as the session wrap-up.
session-start → ... → LOOP → ... → session-end

## Evidence Requirements
After session-end completes, progress.md must contain:
- What this session did
- What the next session needs to continue
- The threshold check result (e.g., "progress.md at 145 lines — below threshold, no archiving needed" or "progress.md at 250 lines — invoked memory-maintenance, which archived to archives/progress-2026-06-20-1900.md and rebuilt index.json")
- If step 6a was executed, record "produced pm-to-engineering.md, containing X delivery items + Business Context Digest with X constraints + project_mode/exploration_mode/task_type/scope"
