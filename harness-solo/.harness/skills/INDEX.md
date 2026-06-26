# Skills Index

> Pure index, under 80 lines. Read when selecting a Skill. For workflow orchestration, see `workflows/`.
> Adding a new Skill: create a SKILL.md under a category directory, then append a line to this file.
> Positioning: harness-solo is an **engineering development framework** and contains only code-writing-related skills.
> Product / design / growth are handled by other members of the harness family (handed off via docs/handoff/).

## Meta
- **session-start** — Session startup, load context and restore working state
- **session-end** — Session wrap-up, archive progress + write baseline + update board
- **skill-maintenance** — Skill health check
- **memory-maintenance** — Memory retention cleanup

## Engineering
- **brainstorming** — Requirements exploration, hard gate (cannot proceed to coding until passed)
- **writing-plans** — Task decomposition, output spec.md
- **executing-plans** — Plan execution, advance through the task sequence with checkpoints
- **test-driven-development** — TDD, red→green→refactor
- **test-coverage** — Add tests for existing code, coverage gap analysis
- **systematic-debugging** — Systematic debugging, root cause analysis
- **performance-optimization** — Performance optimization, measure→fix→verify closed loop
- **migration** — Code migration, framework upgrade / API migration, guard against regression
- **dependency-management** — Dependency management, add / upgrade / audit, integrates with the constitution approval gate
- **frontend-implementation** — Frontend engineering implementation, components / state / styling (not visual design)
- **verify** — Delivery verification, mandatory comprehensive check before claiming completion
- **product-engineering-review** — Product-level cross-feature consistency review (after all features implemented, before handoff)
- **webapp-testing** — Frontend verification, pure Agent tool approach (build / type / lint / accessibility)
- **requesting-code-review** — Code review, quality gatekeeping
- **receiving-code-review** — Review feedback handling, classify + fix + reply
- **writing-skills** — Create new skills per the standard, supports framework extension
- **writing-documentation** — Documentation writing, ADR / API doc / CHANGELOG, document the why

## Workflows

> `default_mode`: deep=forced exploration / standard=pause at module boundaries / skip=execute directly (user can switch at any time)

- **setup** [skip] — Project kickoff guidance (after install.sh, guide filling in SOUL/constitution/PROJECT/TECH_STACK)
- **new-product-engineering** [deep] — Product-level engineering (plan all features → shared infrastructure → per-feature new-feature LOOPs → product-review → handoff)
- **new-feature** [deep] — New feature development (brainstorming → LOOP → code-review)
- **bugfix** [standard] — Bug fix (systematic-debugging → LOOP → code-review)
- **refactor** [deep] — Refactoring (brainstorming to confirm boundaries → LOOP guarding against regression → code-review)
- **optimize** [standard] — Performance optimization (performance-optimization measure→fix→verify → code-review)
- **migration** [standard] — Code migration (migration decision → LOOP incremental migration → verify zero usage → remove old system)
- **release** [skip] — Release (verify full → CHANGELOG → tag → release artifact verification)
