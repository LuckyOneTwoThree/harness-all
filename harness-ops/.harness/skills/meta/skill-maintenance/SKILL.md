---
name: skill-maintenance
description: Framework skill health check, detect empty directories, unregistered skills, missing frontmatter
---
# Skill Maintenance

## When to use
- When the user says "check framework health" / "troubleshoot skill" / "skill index inconsistent
- session-start optional invocation (report when anomalies are found)
- Validate consistency after adding/removing a skill

## Inputs
- .harness/skills/INDEX.md
- .harness/templates/SKILL.md.template
- .harness/skills/ops/

## Outputs
- .harness/skills/INDEX.md
- memory/knowledge-base.md
- memory/progress.md

## Core Principle
**If you can't find a skill, it doesn't exist. If it's registered but has no SKILL.md, it's broken.**

Skills are the organs of the framework. This skill ensures that all organs are in the right place, have the correct structure, and can be discovered by the index.

## What Skill Maintenance Is

**Maintains:**
- INDEX.md consistency with the actual directory
- Every skill has a SKILL.md
- Every SKILL.md has complete frontmatter
- No empty directory placeholders
- Complete `.harness/skills/ops/` directory structure

**Does not:**
- Modify a skill's business logic (that is the skill's own concern)
- Create new skills (use `writing-skills`)
- Delete skills currently in use (requires manual confirmation)

## When to Run

| Scenario | Action |
|----------|--------|
| After adding a new skill | Run immediately to confirm successful registration |
| After deleting a skill | Run immediately to confirm no residual references |
| When a skill cannot be found | Run to locate the problem |
| During session-start | Optional lightweight check, report on anomalies |

## Process

1. **Scan the actual skill directory**
   - Use Glob to scan all SKILL.md under `.harness/skills/meta/*/`
   - Use Glob to scan `.harness/skills/workflows/*.md`
   - Use Glob to scan `.harness/skills/ops/*/SKILL.md` (28 ops skills, flat organization)
   - Collect all actually existing skill/workflow names

2. **Parse INDEX.md**
   - Read INDEX.md and extract registered skill names and modules

3. **Consistency comparison**

   | Check item | Pass criteria | Failure handling |
   |------------|---------------|------------------|
   | Meta skill completeness | All 4 skills under meta/ have SKILL.md | Mark "missing" |
   | Workflow completeness | All 7 .md files under workflows/ exist | Mark "missing" |
   | Ops skill completeness | All 28 skill directories under ops/ have SKILL.md | Mark "skill missing" |

4. **Check SKILL.md frontmatter**
   For each SKILL.md, check whether it contains:
   - `name:` and matches the directory name
   - `description:`
   - `operation_tier:` (inspect / propose / mutate-staging / mutate-prod)
   - `requires_approval:` (true / false)
   - Missing any item → mark "incomplete frontmatter"

   For each workflow .md, check whether it contains:
   - `workflow_id:` and matches the filename
   - `name:` and matches the filename
   - `default_mode:` and is one of deep/standard/skip
   - Missing any item → mark "incomplete workflow frontmatter"

5. **Check ops skill directory structure**
   - Each skill directory has a SKILL.md
   - The directory name matches the `name` field in SKILL.md
   - Skills are organized flatly under `.harness/skills/ops/` (no longer split by module into subdirectories)

6. **Output health report**
   Write the results to `memory/progress.md` or this session's report:
   ```markdown
   ## Skill Health Check

   | Check item | Status | Details |
   |------------|--------|---------|
   | Meta skills | ✓ / ✗ | 4/4 exist |
   | Workflows | ✓ / ✗ | 7/7 exist |
   | Workflow frontmatter | ✓ / ✗ | 7/7 have workflow_id+name+default_mode |
   | Ops skills | ✓ / ✗ | 28/28 skills exist |
   | frontmatter | ✓ / ✗ | [issue list or "none"] |
   ```

7. **Repair (only after user authorization)**
   - Empty directory → ask the user, then delete
   - Unregistered skill → append a line to the corresponding category in INDEX.md
   - Missing frontmatter → fill in per SKILL.md.template
   - After repair, re-run the check to confirm it passes

## Evidence Requirements

After running this skill, you must show:
- The list of actually scanned skills (grouped by module)
- The list of skills registered in INDEX.md
- The differences between the two (if any)
- The list of empty directories (if any)
- The list of frontmatter issues (if any)

You cannot just write "check passed".

## Prohibitions
- Claiming "consistent" without showing scan results
- Deleting non-empty skill directories without user authorization
- Modifying skill body content (only fix structure/registration)
- Ignoring empty directories (an empty directory is a problem)

## Relationship with session-start
session-start may lightly invoke this skill's check logic:
- Anomaly found → report to the user, recommend running skill-maintenance
- No anomaly → does not block session start

## Relationship with LOOP
This skill runs outside LOOP and is a maintenance operation.
