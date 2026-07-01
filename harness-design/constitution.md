# constitution.md — Project Constitution

> **Role description**: This file is the project constitution for **the harness-design framework repository itself**.
> When installed to a new project via install.sh, it will be copied from `.harness/templates/constitution.md.template` to generate the new project's constitution, overriding this file.
> Therefore, this file constrains "developing the harness-design framework itself", not "using harness-design to design other projects".
>
> Division of labor with AGENTS.md: AGENTS.md contains general work rules (the same for all projects); constitution.md contains project-specific constraints.
> Load timing: after AGENTS.md, read on first interaction.

## Project-Specific Principles

### Principle 1: Zero Runtime Dependencies

harness-design is a **pure documentation / rules framework** and introduces no runtime dependencies itself.
- All workflows are completed via Agent tools, with no bash script dependency
- Design output is documentation / specs, not runnable code

**Verification**: No `package.json` / `requirements.txt` / `Cargo.toml` or other runtime dependency manifests at the repository root.

### Principle 2: Agent Tools First, Not Bound to bash

All framework workflows must work in a bash-free environment (e.g., Windows PowerShell).
- Operation steps in SKILL.md must provide an "Agent tool approach" (Read/Write/Glob/Grep/Edit, etc.)
- `.sh` scripts may only be marked as "optional fallback"

**Verification**: No SKILL.md workflow relies on bash-specific syntax to complete core tasks.

### Principle 3: Core File Modifications Require User Confirmation

Changes to the following files must be explicitly authorized by the user:
- `AGENTS.md`
- `SOUL.md`
- `constitution.md`
- `.harness/rules/security.md`
- `.harness/rules/prompt-defense.md`

**Verification**: Obtain authorization via `AskUserQuestion` or explicit conversation before modifying.

### Principle 4: Skills Must Have Minimal Frontmatter

All `.harness/skills/*/*/SKILL.md` must include:
- `name:` (consistent with the directory name)
- `description:`

The former `triggers` / `reads` / `writes` / `quality_gates` / `max_iterations` fields are no longer frontmatter fields — they are now body text sections ("When to use" / "Inputs" / "Outputs" / "Quality gates"). See `.harness/templates/SKILL.md.template`.

**Verification**: `skill-maintenance` scans for missing frontmatter.

### Principle 5: Concise Documentation, Prevent Bloat

- `AGENTS.md` must not exceed 150 lines
- `SKILL.md` must not exceed 300 lines (when exceeded, extract schema/examples/decision tables to a `Reference/` subdirectory; Reference/ has no limit)
- `progress.md` must be archived when it exceeds 200 lines

**Verification**: `skill-maintenance` line count check + Agent self-check.

### Principle 6: Design Output Must Mark Accessibility Compliance Level

All design drafts (visual / interaction / prototype) must mark their WCAG compliance level:
- WCAG 2.1 A / AA / AAA
- Non-compliant items must list the reason and remediation plan

**Verification**: `design-review` skill Axis 5 WCAG audit + `verify` skill comprehensive validation.

### Principle 7: Exploration-First Cannot Be Bypassed

Workflows with `default_mode: deep` (e.g., new-design / redesign) must complete the requirements exploration phase (design-brief / user aesthetics research) before entering design output.

- In `deep` mode, ⏸ exploration dialog points cannot be skipped; user input must be obtained before continuing
- In `deep` mode, skill degradation strategy is disabled; "based on default aesthetics" degradation is not allowed
- Users can only bypass by explicitly declaring "switch to skip mode", and the Agent must record the reason in `state.yaml`
- `skip` mode has a safety fallback: automatically downgrades to `standard` when no requirement documents exist

**Verification**: Before workflow execution, check the `exploration_mode` field of `state.yaml`; in `deep` mode, block the PLAN→DESIGN transition if the exploration phase is not complete.

## Constitution Checkpoints (required at PLAN stage)

- [ ] Does the current change introduce runtime dependencies?
- [ ] Can the current workflow be completed in a bash-free environment?
- [ ] Does it involve core file modifications? Has user authorization been obtained?
- [ ] Do new/modified skills have complete frontmatter?
- [ ] Does the document length exceed the project threshold?
- [ ] Does the design output mark the accessibility compliance level?
- [ ] Is the current workflow's exploration_mode deep? If so, has the requirements exploration phase been completed?

## Revision History

| Date | Revision | Reason |
|------|----------|--------|
| 2026-06-21 | Initial version | Clarify harness-design's own constraints |
| 2026-06-23 | Add Principle 7: Exploration-first cannot be bypassed; Principle 5 AGENTS.md line limit 120→150 | exploration_mode mechanism needs constitutional basis |
