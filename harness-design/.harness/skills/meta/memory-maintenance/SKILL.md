---
name: memory-maintenance
description: Maintain the memory directory, execute retention strategy, prevent progress/knowledge-base/archives from growing unbounded
triggers:
  - session-end optional invocation
  - When the user says "clean up history" / "archive" / "memory too large"
  - When memory files exceed the threshold
reads:
  - .harness/loops/LOOP.md
  - .harness/skills/meta/session-end/SKILL.md
writes:
  - memory/progress.md
  - memory/knowledge-base.md
  - memory/archives/
  - loops/specs/*/iterations.log
---

# Memory Maintenance — Memory Maintenance

## Core Principle
**Memory is not a dumpster. If you can't afford to read it, don't keep it.**

The Agent's context is limited. Unbounded growth of progress.md / knowledge-base.md / iterations.log pollutes context and reduces efficiency. This skill handles periodic cleanup and archiving.

## What memory maintenance is

**What is maintained:**
- Length of `memory/progress.md`
- Length of `memory/knowledge-base.md`
- Retention period of `memory/archives/`
- Length of `loops/specs/<task>/iterations.log`

**What it is not:**
- Deleting state.yaml / spec.md / evidence.md of the current active task
- Deleting `.git` history
- Compressing or encrypting files

## Retention strategy

| File | Threshold | Over-limit handling |
|------|-----------|---------------------|
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
   | progress.md | line count > 200 | Execute step 3 |
   | knowledge-base.md | line count > 150 | Execute step 4 |
   | iterations.log | line count > 100 | Execute step 5 |
   | archives/ files | modified time > 90 days | Execute step 6 |

3. **Archive progress.md**
   - Find the last complete session block (separated by `## Session` or similar headings)
   - Keep the last session block in progress.md (for resume from breakpoint)
   - Append the rest to `memory/archives/progress-<YYYY-MM-DD-HHMM>.md`
   - Keep a link to the archive file at the top of progress.md

4. **Split knowledge-base.md**
   - Split by topic (`##` headings)
   - Archive the oldest topics to `memory/archives/knowledge-<topic>-<date>.md`
   - Keep the most recent 3 topics in knowledge-base.md

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
- Pre-operation line count/size of each file
- Post-operation line count/size of each file
- Specific paths of archived files
- User confirmation records for deleted files

You cannot just write "cleaned up".

## Prohibitions
- Deleting state.yaml / spec.md / evidence.md of the current active task
- Clearing progress.md without leaving any session block (breaks resume from breakpoint)
- Deleting files in archives/ without asking the user
- Not keeping the most recent content when archiving

## Relationship with session-end

session-end handles daily wrap-up; memory-maintenance handles deep cleanup:

| Skill | Frequency | Responsibility |
|-------|-----------|----------------|
| session-end | Every session end | Archive this session, write baseline, update board |
| memory-maintenance | On-demand/periodic | Split large files, clean old archives, execute retention |

**Suggestion**: session-end checks progress.md length each time and invokes memory-maintenance when it exceeds 200 lines.

## Relationship with LOOP

This skill does not affect LOOP state:
- state.yaml is not cleaned
- spec.md is not cleaned
- evidence.md is not cleaned
- Only log-type and archive-type files are cleaned
