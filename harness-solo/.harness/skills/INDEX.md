# Skills Index

> Pure index, under 80 lines. Read when selecting a Skill. For workflow orchestration, see `workflows/`.
> Adding a new Skill: create a SKILL.md under a category directory, then append a line to this file.
> Positioning: harness-solo is an **engineering development framework** and contains only code-writing-related skills.
> Product / design / growth are handled by other members of the harness family (handed off via docs/handoff/).

## Meta
- **session-start** — Session startup, load context and restore working state
- **session-end** — Recovery record + canonical board sync + on-demand baseline + requested handoffs
- **skill-maintenance** — Skill health check
- **memory-maintenance** — Memory retention cleanup

## Engineering
- **brainstorming** [conditional] — Resolve material requirement ambiguity; not ceremonial for already executable specs
- **writing-plans** — One canonical spec/state process with depth-adjusted impact analysis
- **test-driven-development** — Default ACT owner; increments once before mutation and returns results to verify
- **test-coverage** — Add tests for existing code, coverage gap analysis
- **systematic-debugging** — Systematic debugging, root cause analysis
- **performance-optimization** — Performance optimization, measure→fix→verify closed loop
- **migration** — Code migration, framework upgrade / API migration, guard against regression
- **dependency-management** — Dependency management, add / upgrade / audit, integrates with the constitution approval gate
- **frontend-implementation** — Frontend engineering implementation, components / state / styling (not visual design)
- **verify** — Owns verify-full (final delivery evidence gate); verify-fast is inlined into ACT skills
- **product-engineering-review** — Product-level cross-feature consistency review (after all features implemented, before handoff)
- **webapp-testing** — Frontend verification, pure Agent tool approach (build / type / lint / accessibility)
- **code-review** — Maintainability review + feedback response + final done transition
- **writing-skills** — Create new skills per the standard, supports framework extension
- **writing-documentation** — Documentation writing, ADR / API doc / CHANGELOG, document the why

## Workflows

> 3-tier speed: risk-gated quick-fix / standard / deep. Size is a signal; consequence and ambiguity decide the route.

- **setup** [skip] — Project kickoff guidance (after install.sh, guide filling in SOUL/constitution/PROJECT/TECH_STACK)
- **quick-fix** [skip] — Risk-gated fast path for one low-risk outcome with scoped verification
- **new-product-engineering** [deep] — Product plan → nested canonical tasks → integration checkpoints → product review
- **new-feature** [standard] — New feature development (brainstorming → LOOP → code-review)
- **bugfix** [standard] — Bug fix (systematic-debugging → LOOP → code-review)
- **refactor** [standard] — Refactoring (brainstorming to confirm boundaries → LOOP guarding against regression → code-review)
- **optimize** [standard] — Performance optimization (performance-optimization measure→fix→verify → code-review)
- **migration** [standard] — Code migration (migration decision → LOOP incremental migration → verify zero usage → remove old system)
- **release** [skip] — Scoped release verification → artifact/metadata review → user-authorized version/tag
