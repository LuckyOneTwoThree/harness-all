---
name: skill-maintenance
description: Framework skill health check, detect empty directories, unregistered skills, missing frontmatter
---
# Skill Maintenance

## When to use
- When the user says "check framework health" / "troubleshoot skill" / "skill index inconsistent"
- session-start optional invocation (report when anomalies are found)
- Validate consistency after adding/removing a skill

## Inputs
- .harness/skills/INDEX.md
- .harness/templates/SKILL.md.template

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
- Reasonable Inputs/Outputs declarations

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
   - Use Glob to scan all SKILL.md under `.harness/skills/design-intake/*/`
   - Use Glob to scan all SKILL.md under `.harness/skills/frontend/*/`
   - Use Glob to scan all SKILL.md under `.harness/skills/backend/*/`
   - Use Glob to scan all SKILL.md under `.harness/skills/integration/*/`
   - Use Glob to scan all SKILL.md under `.harness/skills/engineering/*/`
   - Use Glob to scan all SKILL.md under `.harness/skills/meta/*/`
   - Use Glob to scan `.harness/skills/workflows/*.md`
   - Collect all actually existing skill/workflow names

2. **Parse INDEX.md**
   - Read INDEX.md and extract registered skill names
   - Extract workflow names

3. **Consistency comparison**

   | Check item | Pass criteria | Failure handling |
   |------------|---------------|------------------|
   | Registered vs actual | Every skill listed in INDEX.md must have a corresponding SKILL.md | Mark "registered but not found" |
   | Actual vs registered | Every directory with a SKILL.md must be registered in INDEX.md | Mark "unregistered" |
   | Empty directory | Every subdirectory under design-intake/frontend/backend/integration/engineering/meta must contain a SKILL.md or files | Mark "empty directory" |
   | Duplicate skill | The same skill name must not appear in more than one category | Mark "duplicate" |

4. **Check SKILL.md frontmatter**
   For each SKILL.md, check whether it contains:
   - `name:` and matches the directory name
   - `description:`
   - Missing any item → mark "incomplete frontmatter"

   For each workflow .md, check whether it contains:
   - `workflow_id:` and matches the filename
   - `name:` and matches the filename
   - `default_mode:` and is one of deep/standard/skip
   - Missing any item → mark "incomplete workflow frontmatter"

5. **Check Inputs/Outputs reasonableness**
   - If it involves state.yaml → must read `loops/LOOP.md`
   - If it involves security → must read `rules/security.md`
   - If it involves docs/handoff/ → must be declared in Inputs or Outputs
   - Not met → mark "missing dependency declaration"

6. **Output health report**
   Write the results to `memory/progress.md` or this session's report:
   ```markdown
   ## Skill Health Check

   | Check item | Status | Details |
   |------------|--------|---------|
   | INDEX consistency | ✓ / ✗ | X registered, Y actual |
   | Empty directories | ✓ / ✗ | [list or "none"] |
   | frontmatter | ✓ / ✗ | [issue list or "none"] |
   | Workflow frontmatter | ✓ / ✗ | 9/9 have workflow_id+name+default_mode |
   | Inputs/Outputs | ✓ / ✗ | [issue list or "none"] |
   ```

7. **Repair (only after user authorization)**
   - Empty directory → ask the user, then delete
   - Unregistered skill → append a line to the corresponding category in INDEX.md
   - Missing frontmatter → fill in per SKILL.md.template
   - After repair, re-run the check to confirm it passes

## Evidence Requirements

After running this skill, you must show:
- The list of actually scanned skills
- The list of skills registered in INDEX.md
- The differences between the two (if any)
- The list of empty directories (if any)
- The list of frontmatter issues (if any)

You cannot just write "check passed".

## Prohibited
- Claiming "consistent" without showing scan results
- Deleting non-empty skill directories without user authorization
- Modifying skill body content (only fix structure/registration)
- Ignoring empty directories (an empty directory is a problem)

## Division of Labor with writing-skills

For skill location see INDEX.md; for skill-specific collaboration see the Process section above.

## Relationship with session-start
session-start may lightly invoke this skill's check logic:
- Anomaly found → report to the user, recommend running skill-maintenance
- No anomaly → does not block session start

## Relationship with LOOP

- Phase: N/A (meta skill — maintains the skill registry, not inside any phase's LOOP)
- Role: skill-maintenance is a **framework hygiene skill**, not a LOOP ACT. It does not own an iteration or an attempt outcome. It is invoked on-demand (by the user or by session-start's light check) to detect drift between the skill registry (INDEX.md / AGENTS.md) and actual SKILL.md files.
- Does NOT invoke `test-driven-development` or run `verify-fast`/`verify-full`.
