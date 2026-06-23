---
name: memory-maintenance
description: Maintain the memory directory, execute retention policy, prevent progress/knowledge-base/archives from growing unbounded
triggers:
  - session-end optional invocation
  - When the user says "clean up history" / "archive" / "memory too large"
  - When memory files exceed thresholds
reads:
  - .harness/loops/LOOP.md
  - .harness/skills/meta/session-end/SKILL.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - memory/archives/
  - loops/specs/*/iterations.log
---

# Memory Maintenance

## Core Principle
**Memory is not a dumpster. If you can't afford to read it, don't keep it.**

The Agent's context is limited. Unbounded growth of progress.md / knowledge-base.md / iterations.log pollutes context and reduces efficiency. This skill handles periodic cleanup and archiving.

## What Memory Maintenance Is

**Maintains:**
- The length of `memory/progress.md`
- The length of `memory/knowledge-base.md`
- The retention period of `memory/archives/`
- The length of `loops/specs/<task>/iterations.log`

**Does not:**
- Delete state.yaml / spec.md / evidence.md of currently active tasks
- Delete `.git` history
- Compress or encrypt files

## Retention Policy

| File | Threshold | Over-limit handling |
|------|-----------|----------------------|
| `progress.md` | 200 lines | Archive the oldest session block to `archives/` |
| `knowledge-base.md` | 150 lines | Split into topic archives |
| `iterations.log` (per task) | 100 lines | Archive to `archives/iterations-<task>-<date>.log` |
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
   | iterations.log | lines > 100 | Execute step 5 |
   | archives/ files | modified time > 90 days | Execute step 6 |

3. **Archive progress.md**
   - Find the last complete session block (separated by `## Session` or similar headings)
   - Keep the last session block in progress.md (for resuming from a checkpoint)
   - Append the rest to `memory/archives/progress-<YYYY-MM-DD-HHMM>.md`
   - Keep a link to the archive file at the top of progress.md

4. **Split knowledge-base.md**
   - Split by topic (`##` headings)
   - Archive the oldest topics to `memory/archives/knowledge-<topic>-<date>.md`
   - Keep the 3 most recent topics in knowledge-base.md
   - **Ops domain specific**: incident postmortem conclusions, change records, and pitfall records are prioritized for retention

5. **Archive iterations.log**
   - Keep the most recent 20 lines in place
   - Append the rest to `memory/archives/iterations-<task>-<date>.log`
   - Do not delete the original file (LOOP needs it)

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
   ```

## Evidence Requirements

After running this skill, you must show:
- The pre-operation line count/size of each file
- The post-operation line count/size of each file
- The specific path of each archive file
- The user confirmation record for each deleted file

You cannot just write "cleaned up".

## Prohibitions
- Deleting state.yaml / spec.md / evidence.md of currently active tasks
- Clearing progress.md without leaving any session block (breaks checkpoint resumption)
- Deleting files in archives/ without asking the user
- Not keeping the most recent content when archiving

## Relationship with session-end

session-end handles daily wrap-up, memory-maintenance handles deep cleanup:

| Skill | Frequency | Responsibility |
|-------|-----------|----------------|
| session-end | Every session end | Archive this session, write baseline, update board |
| memory-maintenance | On-demand/periodic | Split large files, clean old archives, execute retention |

**Recommendation**: session-end should check the progress.md length each time and invoke memory-maintenance when it exceeds 200 lines.

## Relationship with LOOP

This skill does not affect LOOP state:
- state.yaml is not cleaned
- spec.md is not cleaned
- evidence.md is not cleaned
- Only log-type and archive-type files are cleaned
