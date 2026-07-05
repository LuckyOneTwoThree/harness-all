---
name: memory-maintenance
description: Maintain the memory directory, execute retention policy, prevent progress/knowledge-base/archives from growing unbounded
---
# Memory Maintenance

## When to use
- session-end invocation when a retention threshold is exceeded
- When the user says "clean up history" / "archive" / "memory too large"
- When memory files exceed thresholds

## Inputs
- .harness/skills/meta/session-end/SKILL.md
- .harness/rules/memory.schema.json

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- memory/archives/
- memory/index.json
- loops/specs/*/iterations.log

## Core Principle
**Memory is not a dumpster. If you can't afford to read it, don't keep it.**

The Agent's context is limited. Unbounded growth of progress.md / knowledge-base.md / iterations.log pollutes context and reduces efficiency. This skill handles periodic cleanup and archiving.

## What Memory Maintenance Is

**Maintains:**
- The length of `memory/progress.md`
- The length of `memory/knowledge-base.md`
- The retention period of `memory/archives/`
- The length of `loops/specs/<feature>/iterations.log`
- `memory/index.json` (machine-readable archive index for session-start discovery)

**Does not:**
- Delete state.yaml / spec.md / evidence.md of currently active features
- Delete `.git` history
- Compress or encrypt files

## Retention Policy

| File | Threshold | Over-limit handling |
|------|-----------|----------------------|
| `progress.md` | 200 lines | Archive the oldest session block to `archives/` |
| `knowledge-base.md` | 150 lines | Keep most recent N entries per section, archive older |
| `iterations.log` (per feature) | 100 lines | Archive to `archives/iterations-<feature>-<date>.log` |
| Files in `archives/` | 90 days | Delete after asking the user |

## Process

1. **Scan file sizes**
   - Use Read to read `memory/progress.md` and count lines
   - Use Read to read `memory/knowledge-base.md` and count lines
   - Use Glob to scan `loops/specs/*/iterations.log`
   - Use Glob to scan `memory/archives/*` and record file dates

2. **Determine whether cleanup is needed**

   | File | Condition | Action |
   |------|-----------|--------|
   | progress.md | lines > 200 | Execute step 3 |
   | knowledge-base.md | lines > 150 | Execute step 4 |
   | iterations.log (size) | lines > 100 | Execute step 5 |
   | iterations.log (task done) | task status: done or failed | Execute step 5b |
   | archives/ files | modified time > 90 days | Execute step 6 |

3. **Archive progress.md**
   - Find the last complete session block (separated by `## Session` or similar headings)
   - Keep the last session block in progress.md (for resuming from a checkpoint)
   - Append the rest to `memory/archives/progress-<YYYY-MM-DD-HHMM>.md`
   - Keep a link to the archive file at the top of progress.md

4. **Trim knowledge-base.md**
   - For each section (`##` heading, e.g., "## Technical decisions", "## Pitfalls"), keep the most recent N entries (default: 20 per section)
   - Append trimmed entries to `memory/archives/knowledge-<section-slug>-<date>.md`
   - Do NOT split sections into separate files — keep the same structure in knowledge-base.md, just shorter
   - Rationale: sections (decisions / pitfalls) have different lifecycles; splitting them into separate files breaks the "one knowledge base" mental model and reduces session-start load value

5. **Archive iterations.log (size-driven)**
   - Keep the most recent 20 lines in place
   - Append the rest to `memory/archives/iterations-<feature>-<date>.log`
   - Do not delete the original file (LOOP needs it for active tasks)

5b. **Archive iterations.log (task-completion-driven)** — per STATE_PROTOCOL.md "Task completion archival"
   - Scan `loops/specs/*/state.yaml` for tasks with `status: done` or `status: failed`
   - For each such task, if `loops/specs/<task>/iterations.log` still exists:
     - Move the entire file to `loops/archives/iterations-<task>-<YYYYMMDD>.log`
     - Remove the original from `loops/specs/<task>/`
   - This is state-driven (not size-driven): the whole log is archived because the task is terminal and session-start no longer needs to load it
   - Differs from step 5: step 5 keeps recent 20 lines for active tasks; step 5b removes the entire file for terminal tasks

6. **Clean up old archives**
   - List archive files older than 90 days
   - **Must ask the user before deleting**
   - User confirms → delete
   - User declines → keep and record

7. **Output maintenance report**
   Record to progress.md or this session's report:
   ```markdown
   ## Memory Maintenance

   | File | Before | After | Action |
   |------|--------|-------|--------|
   | progress.md | 250 lines | 45 lines | Archived to archives/progress-2026-06-20-2000.md |
   | knowledge-base.md | 180 lines | 60 lines | Split and archived 2 topics |
   | iterations.log | 120 lines | 20 lines | Archived to archives/iterations-xxx-2026-06-20.log |
   | archives/ | 5 old files | Deleted 3 | User confirmed |
   | index.json | absent | rebuilt | 4 archive entries indexed |
   ```

8. **Rebuild memory/index.json**
   After all archiving and cleanup is complete, rebuild the machine-readable archive index so session-start can discover archived sessions without Globbing:

   - Use Glob to scan `memory/archives/*` and `loops/archives/*`
   - For each archive file, extract metadata from the filename and content header:
     - `filename`: basename of the archive file
     - `type`: `progress` / `knowledge` / `iterations` (derived from filename prefix)
     - `archived_at`: ISO-8601 timestamp (from filename date or file content)
     - `section`: knowledge section slug (type=knowledge only)
     - `task`: task/feature ID (type=iterations only)
     - `reason`: `size-threshold` or `task-completion` (type=iterations only)
     - `session_range` / `summary`: extracted from the archive file's first line/header (type=progress only)
     - `entry_count`: number of entries in the archive (type=knowledge only)
   - Read current `memory/progress.md` to compute `current_progress` (session_count, line_count, date_range)
   - Read current `memory/knowledge-base.md` to compute `knowledge_base` (sections, total_entries, line_count)
   - Write the complete index to `.harness/memory/index.json` with `schema_version: "1.0"`, `last_updated: <current ISO-8601>`, `framework: "harness-engineering"`
   - Validate the output against `.harness/rules/memory.schema.json`

## Evidence Requirements

After running this skill, you must show:
- The pre-operation line count/size of each file
- The post-operation line count/size of each file
- The specific path of each archive file
- The user confirmation record for each deleted file
- index.json rebuilt with N archive entries (or "index.json unchanged — no archives modified this run")

You cannot just write "cleaned up".

## Prohibited
- Deleting state.yaml / spec.md / evidence.md of currently active features
- Clearing progress.md without leaving any session block (breaks checkpoint resumption)
- Deleting files in archives/ without asking the user
- Not keeping the most recent content when archiving

## Relationship with session-end

session-end handles daily wrap-up, memory-maintenance handles deep cleanup:

| Skill | Frequency | Responsibility |
|-------|-----------|----------------|
| session-end | Every session end | Record recovery state, refresh baseline when source files changed, update board, invoke this skill on threshold |
| memory-maintenance | On-demand/periodic | Split large files, clean old archives, execute retention |

**Recommendation**: session-end should check the progress.md length each time and invoke memory-maintenance when it exceeds 200 lines.

## Relationship with LOOP

Does not affect LOOP state (state.yaml/spec.md/evidence.md are not cleaned); only log-type and archive-type files are cleaned. See `.harness/loops/LOOP.md`.
