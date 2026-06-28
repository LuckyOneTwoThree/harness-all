---
name: writing-skills
description: Create new skills following the standard, supporting framework extension
---
# Writing Skills — Creating New Skills

## When to use
- When the user asks to add a new skill
- When existing skills cannot cover a new scenario
- When extending the framework

## Inputs
- .harness/templates/SKILL.md.template (read-only, structural reference)
- .harness/skills/INDEX.md (read-write)
- .harness/loops/LOOP.md (read-only, schema reference)

## Outputs
- .harness/skills/<category>/<new-skill-name>/SKILL.md
- .harness/skills/INDEX.md

## Iron Rule
**New skills must be created from the template, must be registered in INDEX.md, and must declare Inputs/Outputs.** No skill goes rogue.

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
   ---
   ```

   Then add body text sections for dependencies and outputs:
   - **When to use**: list the scenarios that trigger this skill (replaces the former `triggers` field)
   - **Inputs**: list files this skill needs to read when executing (rules/loops/docs/specs) — replaces the former `reads` field
   - **Outputs**: list files this skill modifies when executing (state.yaml/evidence.md/iterations.log/docs) — replaces the former `writes` field
   - If state.yaml is involved, you must include `loops/LOOP.md` in Inputs (reference the schema)
   - If security is involved, you must include `rules/security.md` in Inputs

4. **Write the body** (following the template structure)

   - **Iron Rule**: inviolable rules, placed at the very top (to avoid lost-in-the-middle)
   - **Process**: numbered steps, each executable
   - **Prohibitions**: explicitly state what not to do
   - **Relationship with LOOP**: which phase it corresponds to, how it interacts with other skills
   - **Evidence requirements** (if applicable): what evidence is needed to claim completion

5. **Register in INDEX.md**
   - Append a line under the corresponding category: `- **<skill-name>** — <one-sentence description>`
   - Keep INDEX.md under 80 lines (pure index principle)

6. **Linkage check**
   - If the new skill outputs state.yaml → confirm it references the schema in LOOP.md
   - If the new skill is inside LOOP → confirm related workflow files have been updated
   - If the new skill involves handoff → confirm Inputs/Outputs declare docs/handoff/

7. **Verify**
   - Use Read to confirm SKILL.md was created successfully
   - Use Read to confirm INDEX.md has been updated
   - If a workflow was modified, use Read to confirm consistency

## Design Principles

- **Single Responsibility**: one skill handles one thing
- **Cross-platform**: do not depend on bash; prefer Agent tools
- **Reference, don't repeat**: state.yaml schema references LOOP.md; do not redefine
- **Minimal necessary**: fill in only the required fields in frontmatter (name+description); do not fill in for the sake of completeness
- **Composable**: skills declare dependencies via Inputs/Outputs sections; do not hardcode invocations

## Good vs Bad Skill Example

A good skill states an inviolable rule with a **verifiable exit condition**. A bad skill states a value with no way to check compliance.

<Good>
```markdown
## Iron Rule
**No production code without a failing test.** A test that passes immediately
= you are testing existing behavior, not new behavior.
## Process
1. Write a failing test → run it → confirm FAIL is visible
2. Write minimal code → run it → confirm PASS is visible
```
Exit condition: the test runner's actual output (FAIL then PASS) is observable evidence.
</Good>

<Bad>
```markdown
## Principles
Tests are important. Please write tests for your code and try to keep
coverage high. Quality matters.
```
Exit condition: none. "Important" and "high" are not measurable.
</Bad>

The difference: the Good example gives the Agent a binary check on its own output. The Bad example is an abstract slogan every implementation can claim to satisfy.

## Read-Only Inputs Annotation

In the **Inputs** section, annotate each entry with its access mode so the Agent (and reviewers) can see at a glance which files are referenced vs modified:

```
## Inputs
- loops/LOOP.md (read-only, schema reference)
- loops/specs/<feature>/state.yaml (read-write)
- rules/security.md (read-only, constraint reference)
- docs/handoff/<source>-to-solo.md (read-only, then consumed)
```

Convention:
- `(read-only[, ...])` — read for reference, must not be modified (default when no annotation)
- `(read-only, then consumed)` — read-only, but the skill acts on its contents this session
- `(read-write)` — the skill writes back; must also appear in **Outputs**

## Naming Conventions

- lowercase-kebab-case: `test-driven-development`, not `TestDrivenDevelopment`
- Start with a verb or gerund: `writing-plans` / `requesting-code-review` / `verify`
- Avoid abbreviations: `systematic-debugging`, not `sys-debug`
- Exactly match the directory name

## Prohibitions
- Not creating from the template (inconsistent structure; hard for the Agent to parse)
- Not registering in INDEX.md (the skill won't be discovered)
- Doing multiple things in one skill (violates single responsibility)
- Hardcoding invocations of other skills (declare dependencies via Inputs/Outputs)
- Not verifying after creation (the file may not have been written successfully)

## Anti-Rationalization Table

| Anti-pattern | Common excuse | Why it doesn't hold |
|---|---|---|
| Not updating INDEX.md | "I'll update it later" | INDEX.md is the routing entry; an unregistered skill is invisible to the Agent and cannot be discovered |
| Letting a skill exceed 300 lines | "All of it is important" | Over 300 lines violates the constitution and fills the Agent's context window, pushing the Iron Rule out of focus |
| Decorating with emoji | "It looks better" | Emoji adds visual noise without adding information; the framework is plain-text by convention |
| Not testing a new skill | "I wrote it correctly" | Without a test run you do not know whether the Agent can actually follow the Process you wrote |
| Skipping the read-only annotation | "It's obvious from context" | Without annotation, reviewers and the Agent cannot tell which inputs are safe to share vs which will be mutated |

## Relationship with LOOP
This skill is a **meta skill**, not inside LOOP, used for the framework's own extension.
- The user asks to extend the framework → writing-skills → create a new SKILL.md + update INDEX.md
- After a new skill is created, it can be invoked in subsequent LOOPs
