# constitution.md — Project Constitution

> **Role note**: Project constitution for **the harness-engineering framework repository itself**.
> When installed into a new project via install.sh, copied from `.harness/templates/constitution.md.template`, overwriting this file.
> Therefore, this file constrains "developing the harness-engineering framework itself", not "using harness-engineering to develop other projects".
>
> Division of labor with AGENTS.md: AGENTS.md = general work rules; constitution.md = project-specific constraints.
> Load timing: after AGENTS.md, read at first interaction.

## Project-Specific Principles

### Principle 1: Zero Runtime Dependencies

harness-engineering is a **pure documentation / rules framework** and introduces no runtime dependencies itself.
- All `.harness/scripts/*.sh` and `.harness/hooks/*.sh` are optional fallback scripts only
- The Agent prefers IDE tools (Read/Write/Glob/Grep/Edit) to perform equivalent operations, without depending on bash
- A **target project** may approve specific runtime dependencies (e.g., Playwright for DOM-level WCAG E2E) by registering them in the whitelist below; otherwise DOM-level checks requiring a running DOM are skipped with an auditable evidence record

**Approved Dependency Whitelist** (user-governed; each entry: tool, approver, date, scope, review point):

| Tool | Approver | Date | Scope | Review Point |
|------|----------|------|-------|---------------|
| _(empty — add user-approved exceptions here)_ | | | | |

**Verification**: No `package.json` / `requirements.txt` / `Cargo.toml` exists at the framework repository root; no SKILL.md process relies on bash-specific syntax to complete core tasks.

### Principle 2: Agent Tools First, Not Bound to bash

All framework processes must work in a bash-free environment (e.g., Windows PowerShell).
- Operation steps in SKILL.md must provide an "Agent tool approach" (Read/Write/Glob/Grep/Edit, etc.)
- `.sh` scripts may only be marked as "optional fallback"

### Principle 3: 4-Phase Checkpoint Mechanism

Each of the 4 phases (design-intake → frontend → backend → integration) requires explicit user confirmation (`👤`) before advancing to the next. No silent phase transitions.

- Phase 0 → 1: confirm `contract.json` + `tokens.json` accepted by the user
- Phase 1 → 2: confirm frontend builds green against mocks; TDD evidence recorded
- Phase 2 → 3: confirm backend APIs pass contract tests
- Phase 3 → DONE: confirm e2e verification passes; `engineering-to-pm.md` approved

**`skip` mode exception**: skip mode enters directly at Phase 3 and does not re-run Phase 0–2 checkpoints, but the integration checkpoint still applies.

**Verification**: `memory/progress.md` records the checkpoint timestamp and user approver for each phase transition.

### Principle 4: Directory Boundary Rules

Target projects using harness-engineering must respect directory boundaries per mode:

- **Full-stack mode** (Next.js / Remix, single repo): `app/` (frontend: pages, components, hooks, styles) + `api/` (backend: route handlers, services) + `lib/` (shared: types, schemas, utils); `contract.json` and `tokens.css` live at repo root
- **Separated mode** (React + Express, two roots): each root keeps its own structure; `contract.json` is the single source of truth shared via a path both roots reference
- Frontend must not import from `api/` internals; backend must not import from `app/` UI components; cross-root communication is via the contract only

**Verification**: Grep for cross-boundary imports; any hit must be removed or explicitly whitelisted in this constitution.

### Principle 5: Design Contract Constraint

Frontend code must consume design tokens via `tokens.css` CSS custom properties (`var(--token-*)`). Hardcoded color / spacing / typography values are prohibited.

- `tokens.json` (Phase 0 output) is the source of truth; `tokens.css` is generated from it
- Components reference tokens by name: `color: var(--token-color-primary)`, never `color: #3b82f6`
- Backend code is not bound by token rules but must conform to the API contract in `contract.json`

**Verification**: Grep frontend files for hex / rgb / hsl literals; any hit must be replaced with a token reference or explicitly whitelisted in this constitution.

### Principle 6: Core File Modifications Require User Confirmation

The following file changes must be explicitly authorized by the user before editing:
- `AGENTS.md`, `SOUL.md`, `constitution.md`
- `contract.json` / `tokens.json` (Phase 0 artifacts)
- `.harness/rules/security.md`, `.harness/rules/prompt-defense.md`

**Verification**: Obtain authorization via `AskUserQuestion` or explicit dialog before modifying.

### Principle 7: Skills Must Have Minimal Frontmatter

All `.harness/skills/*/*/SKILL.md` must include `name:` (matching the directory name) and `description:`. Other fields (`triggers` / `reads` / `writes` / `quality_gates` / `max_iterations`) are body text sections ("When to use" / "Inputs" / "Outputs" / "Quality gates"). See `.harness/templates/SKILL.md.template`. **Verification**: `skill-maintenance` scans for missing frontmatter.

### Principle 8: Concise Documentation, Prevent Bloat

- `AGENTS.md` ≤ 150 lines · `SOUL.md` ≤ 80 lines · `constitution.md` ≤ 100 lines
- `SKILL.md` ≤ 300 lines (when exceeded, extract schemas / examples / decision tables into a `Reference/` subdirectory; Reference/ has no limit)
- `progress.md` archived when it exceeds 200 lines

**Verification**: The Agent uses the Read tool to count lines + optional `verify-harness.sh` / `entropy-check.sh` fallbacks.

## Constitution Checkpoints (must check during PLAN phase)

- [ ] Runtime dependencies / bash-free / directory boundaries / design tokens — all respected?
- [ ] Core file modifications authorized by user?
- [ ] Skills frontmatter complete / document length within threshold?
- [ ] Current phase checkpoint confirmed by user?

## Revision History

| Date | Revision | Reason |
|------|---------|------|
| 2026-06-21 | Initial version | Clarify the engineering framework's own constraints |
| 2026-06-23 → 2026-06-30 | v2.x iterations | Add 3-tier workflow mode (quick-fix/standard/deep), risk gate, deep-mode flow compaction |
| 2026-07-06 | v3.0.0 — rename to harness-engineering; add 4-phase checkpoint (P3), directory boundary (P4), design contract (P5); add SOUL.md line limit | Move from pure-coding framework to 4-stage engineering framework (design-intake → frontend → backend → integration) |
