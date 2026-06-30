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

### Principle 6: Material Ambiguity Cannot Enter ACT

All standard/deep work must pass a clarification gate before coding. `brainstorming` owns ambiguous/new product requirements; a validated upstream spec or a workflow-specific evidence gate (bug reproduction, performance baseline, migration decision, refactor behavior boundary) can satisfy clarification without rerunning generic brainstorming.

- `deep` mode: analyze material alternatives, contracts, rollback, and cross-feature impact
  - ⏸ exploration dialog points cannot be skipped; user input must be received before continuing
  - Skill downgrade is disabled; the workflow-specific clarification/evidence gate cannot be skipped
- `standard` mode: confirm scope, stable criteria/equivalence target, verification path, and boundaries
- `skip` mode (`quick-fix` workflow): exempt — only allowed after the quick-fix risk gate confirms there is no API/schema/dependency/auth/security/payment/deployment/cross-module/design-contract impact
  - Line count is only a secondary signal and never overrides a risk signal
  - Quick-fix does not create `state.yaml`; record `mode=skip` and the reason in `memory/progress.md`
  - Behavior changes and bug fixes still require a failing regression test; only pure text/comment/format changes may skip creating a new test
  - Safety fallback: any failed risk-gate item automatically upgrades the workflow to `standard`

**Verification**: Before PLAN→ACT, spec.md must cite the clarification source. If requirements remain materially ambiguous, block and invoke brainstorming; do not require ceremonial brainstorming when domain evidence already makes the task executable.

## Constitution Checkpoints (must check during PLAN phase)

- [ ] Does the current change introduce runtime dependencies?
- [ ] Can the current process be completed in a bash-free environment?
- [ ] Does it involve core file modifications? Has user authorization been obtained?
- [ ] Do new/modified skills have complete frontmatter?
- [ ] Does the document length exceed the project threshold?
- [ ] Does spec.md cite a valid clarification source, with no material ambiguity entering ACT?

## Revision History

| Date | Revision | Reason |
|------|---------|------|
| 2026-06-21 | Initial version | Clarify harness-solo's own constraints |
| 2026-06-23 | Add Principle 6 (Exploration first cannot be bypassed) + AGENTS.md line limit 120→150 | Promote the exploration_mode mechanism to control workflow interaction depth |
| 2026-06-29 | Principle 6 expanded to cover deep+standard modes; add 3-tier workflow mode (quick-fix/standard/deep) | Reduce process overhead for small tasks while preserving hard gate for non-trivial changes |
| 2026-06-29 | Replace the quick-fix line-count gate with a risk gate; align TDD and state recording exceptions | Prevent small but high-risk changes from bypassing engineering controls |
| 2026-06-30 | Deep mode flow compaction: merge brainstorming+writing-plans into one Plan stage; inline verify-fast into ACT (4 duties preserved); merge verify-full 8→4 sub-checks and code-review 5→3 steps; session-start/end on-demand + sub-step merge; nested features skip per-feature session ceremony; integration checkpoints inlined into verify-full; product-engineering-review 4→2 checks. Standard 18→11, deep 35→20. | Reduce process overhead while preserving evidence-driven, AC/DAC dual-source, LOOP hard cap, handoff contracts, and deep-mode alternatives/rollback analysis |
