# constitution.md — Project Constitution

> **Role note**: This file is the project constitution for **the harness-solo framework repository itself**.
> When installed into a new project via install.sh, it is copied from `.harness/templates/constitution.md.template` to generate the new project's constitution, overwriting this file.
> Therefore, this file constrains "developing the harness-solo framework itself", not "using harness-solo to develop other projects".
>
> Division of labor with AGENTS.md: AGENTS.md contains general work rules (the same for all projects); constitution.md contains project-specific constraints.
> Load timing: after AGENTS.md, read at first interaction.

## Project-Specific Principles

### Principle 1: Zero Runtime Dependencies

harness-solo is a **pure documentation / rules framework** and introduces no runtime dependencies itself.
- All `.harness/scripts/*.sh` and `.harness/hooks/*.sh` are optional fallback scripts only
- The Agent prefers IDE tools to perform equivalent operations, without depending on bash

**Verification**: No `package.json` / `requirements.txt` / `Cargo.toml` or other runtime dependency manifests exist at the repository root.

### Principle 2: Agent Tools First, Not Bound to bash

All framework processes must work in a bash-free environment (e.g., Windows PowerShell).
- Operation steps in SKILL.md must provide an "Agent tool approach" (Read/Write/Glob/Grep/Edit, etc.)
- `.sh` scripts may only be marked as "optional fallback"

**Verification**: No SKILL.md process relies on bash-specific syntax to complete core tasks.

### Principle 3: Core File Modifications Require User Confirmation

The following file changes must be explicitly authorized by the user:
- `AGENTS.md`
- `SOUL.md`
- `constitution.md`
- `.harness/rules/security.md`
- `.harness/rules/prompt-defense.md`

**Verification**: Obtain authorization via `AskUserQuestion` or explicit dialog before modifying.

### Principle 4: Skills Must Have Minimal Frontmatter

All `.harness/skills/*/*/SKILL.md` must include:
- `name:` (consistent with the directory name)
- `description:`

The former `triggers` / `reads` / `writes` / `quality_gates` / `max_iterations` fields are no longer frontmatter fields — they are now body text sections ("When to use" / "Inputs" / "Outputs" / "Quality gates"). See `.harness/templates/SKILL.md.template`.

**Verification**: `skill-maintenance` scans for missing frontmatter.

### Principle 5: Concise Documentation, Prevent Bloat

- `AGENTS.md` no more than 150 lines
- `SKILL.md` no more than 300 lines (when exceeded, extract schemas / examples / decision tables into a `Reference/` subdirectory; Reference/ has no limit)
- `progress.md` must be archived when it exceeds 200 lines

**Verification**: The Agent uses the Read tool to count lines + optional `verify-harness.sh` fallback + optional `entropy-check.sh` fallback.

### Principle 6: Exploration First Cannot Be Bypassed

Workflows with `default_mode: deep` (e.g., new-product-engineering / new-feature / refactor) must complete the requirements exploration phase (brainstorming hard gate) before entering coding.

- In `deep` mode, ⏸ exploration dialog points cannot be skipped; user input must be received before continuing
- In `deep` mode, skill downgrade strategies are disabled; skipping the brainstorming hard gate is not allowed
- Users can only bypass this by explicitly stating "switch to skip mode", and the Agent must record the reason in `state.yaml`
- `skip` mode has a safety fallback: automatically downgrades to `standard` when no requirement documents exist

**Verification**: Before workflow execution, check the `exploration_mode` field in `state.yaml`; in `deep` mode, if brainstorming is not completed, block the PLAN→ACT transition.

## Constitution Checkpoints (must check during PLAN phase)

- [ ] Does the current change introduce runtime dependencies?
- [ ] Can the current process be completed in a bash-free environment?
- [ ] Does it involve core file modifications? Has user authorization been obtained?
- [ ] Do new/modified skills have complete frontmatter?
- [ ] Does the document length exceed the project threshold?
- [ ] Is the current workflow's exploration_mode deep? If so, has the brainstorming hard gate been completed?

## Revision History

| Date | Revision | Reason |
|------|---------|------|
| 2026-06-21 | Initial version | Clarify harness-solo's own constraints |
| 2026-06-23 | Add Principle 6 (Exploration first cannot be bypassed) + AGENTS.md line limit 120→150 | Promote the exploration_mode mechanism to control workflow interaction depth |
