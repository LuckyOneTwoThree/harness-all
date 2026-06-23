---
name: writing-skills
description: Create new skills following the standard, supporting framework extension
triggers:
  - When the user asks to add a new skill
  - When existing skills cannot cover a new scenario
  - When extending the framework
reads:
  - .harness/templates/SKILL.md.template
  - .harness/skills/INDEX.md
  - .harness/loops/LOOP.md
writes:
  - .harness/skills/<category>/<new-skill-name>/SKILL.md
  - .harness/skills/INDEX.md
---

# Writing Skills — Creating New Skills

## Iron Rule
**New skills must be created from the template, must be registered in INDEX.md, and must declare reads/writes.** No skill goes rogue.

## When to Create a New Skill

Criteria for creating a new skill:
- **Should create**: a working pattern will be reused (not a one-time operation)
- **Should create**: existing skills cannot cover it, and the new scenario has a clear process
- **Should not create**: a one-time operation (just do it in the conversation)
- **Should not create**: an existing skill can cover it with a few extra lines (enhance the existing skill)

## Process

1. **Confirm the skill's positioning**
   - Name: lowercase-kebab-case, e.g. `refactoring-database`
   - One-sentence description: what it does + when to use it
   - Category: `engineering` / `meta` (engineering or meta)
   - Is it inside LOOP? Which phase does it correspond to (PLAN/ACT/VERIFY)?

2. **Create the directory and file**
   - Directory: `.harness/skills/<category>/<skill-name>/SKILL.md`
   - Copy the base structure from `.harness/templates/SKILL.md.template`
   - Do not create .gitkeep (SKILL.md itself is a file)

3. **Fill in the frontmatter** (required fields)

   ```yaml
   ---
   name: <skill-name>                    # required, matches the directory name
   description: one-sentence description, used for INDEX.md reference  # required
   triggers:                             # required, when to use
     - scenario 1
     - scenario 2
   reads:                                # required, files it depends on
     - loops/LOOP.md
     - rules/security.md
   writes:                               # required, files it produces
     - loops/specs/<feature>/state.yaml
   ---
   ```

   **reads/writes declaration rules**:
   - `reads`: files this skill needs to read when executing (rules/loops/docs/specs)
   - `writes`: files this skill modifies when executing (state.yaml/evidence.md/iterations.log/docs)
   - If state.yaml is involved, you must read `loops/LOOP.md` (reference the schema)
   - If security is involved, you must read `rules/security.md`

4. **Write the body** (following the template structure)

   - **Iron Rule**: inviolable rules, placed at the very top (to avoid lost-in-the-middle)
   - **Process**: numbered steps, each executable
   - **Prohibitions**: explicitly state what not to do
   - **Relationship with LOOP**: which phase it corresponds to, how it interacts with other skills
   - **Evidence requirements** (if applicable): what evidence is needed to claim completion

5. **Register in INDEX.md**
   - Append a line under the corresponding category: `- **<skill-name>** — <one-sentence description>`
   - Keep INDEX.md within 30 lines (pure index principle)

6. **Linkage check**
   - If the new skill writes state.yaml → confirm it references the schema in LOOP.md
   - If the new skill is inside LOOP → confirm related workflow files have been updated
   - If the new skill involves handoff → confirm reads/writes declare docs/handoff/

7. **Verify**
   - Use Read to confirm SKILL.md was created successfully
   - Use Read to confirm INDEX.md has been updated
   - If a workflow was modified, use Read to confirm consistency

## Design Principles

- **Single Responsibility**: one skill handles one thing
- **Cross-platform**: do not depend on bash; prefer Agent tools
- **Reference, don't repeat**: state.yaml schema references LOOP.md; do not redefine
- **Minimal necessary**: fill in only the required fields in frontmatter; do not fill in for the sake of completeness
- **Composable**: skills declare dependencies via reads/writes; do not hardcode invocations

## Naming Conventions

- lowercase-kebab-case: `test-driven-development`, not `TestDrivenDevelopment`
- Start with a verb or gerund: `writing-plans` / `executing-plans` / `verify`
- Avoid abbreviations: `systematic-debugging`, not `sys-debug`
- Exactly match the directory name

## Prohibitions
- Not creating from the template (inconsistent structure; hard for the Agent to parse)
- Not registering in INDEX.md (the skill won't be discovered)
- Doing multiple things in one skill (violates single responsibility)
- Hardcoding invocations of other skills (declare dependencies via reads/writes)
- Not verifying after creation (the file may not have been written successfully)

## Relationship with LOOP
This skill is a **meta skill**, not inside LOOP, used for the framework's own extension.
- The user asks to extend the framework → writing-skills → create a new SKILL.md + update INDEX.md
- After a new skill is created, it can be invoked in subsequent LOOPs
