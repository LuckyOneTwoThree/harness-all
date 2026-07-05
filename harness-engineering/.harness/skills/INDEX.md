# Skills Index

> Pure index, under 80 lines. Read when selecting a Skill. For workflow orchestration, see `workflows/`.
> Adding a new Skill: create a SKILL.md under a category directory, then append a line to this file.
> Positioning: harness-engineering is an **engineering development framework** and contains only code-writing-related skills.
> Product / design are handled by other members of the harness family (handed off via docs/handoff/).

## design-intake (Phase 0)
- **design-intake** — Ingest design assets (image / v0 code / md spec) → contract.json + tokens.json + phase-0-design-intake-report.md

## frontend (Phase 1)
- **frontend-implementation** — Phase 1 ACT; components / state / styling / mock API config (not visual design)
- **webapp-testing** — Frontend verification, pure Agent tool approach (build / type / lint / accessibility)

## backend (Phase 2)
- **api-implementation** — Phase 2 ACT; implements API endpoints from the PRD contract + the 7 standard error codes + auth
- **data-layer** — Phase 2 ACT; schema design + ORM models + reversible migrations from PRD entities
- **migration** — Code migration, framework upgrade / API migration, guard against regression
- **dependency-management** — Dependency management, add / upgrade / audit, integrates with the constitution approval gate

## integration (Phase 3)
- **mock-to-real-switch** — Phase 3 ACT; flips frontend connection config from mock to real backend (no business-code edits)
- **e2e-verification** — Phase 3 ACT; AC-driven end-to-end user-flow verification; visual checks route to 👤 human (no Playwright)
- **contract-verify** — Phase 3 ACT; frontend ↔ backend ↔ PRD contract consistency (deep=OpenAPI, standard=static analysis)
- **verify** — Owns verify-full (final delivery evidence gate); verify-fast is inlined into ACT skills
- **code-review** — Maintainability review + feedback response + final done transition
- **product-engineering-review** — Product-level cross-feature consistency review (after all features implemented, before handoff)

## engineering (cross-phase)
- **brainstorming** [conditional] — Resolve material requirement ambiguity; not ceremonial for already executable specs
- **writing-plans** — One canonical spec/state process with depth-adjusted impact analysis
- **test-driven-development** — Default ACT owner; increments once before mutation and returns results to verify
- **test-coverage** — Add tests for existing code, coverage gap analysis
- **systematic-debugging** — Systematic debugging, root cause analysis
- **performance-optimization** — Performance optimization, measure→fix→verify closed loop
- **writing-skills** — Create new skills per the standard, supports framework extension
- **writing-documentation** — Documentation writing, ADR / API doc / CHANGELOG, document the why

## meta
- **session-start** — Session startup, load context and restore working state
- **session-end** — Recovery record + canonical board sync + on-demand baseline + requested handoffs
- **skill-maintenance** — Skill health check
- **memory-maintenance** — Memory retention cleanup

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
- **release** [skip] — Scoped release verifying → artifact/metadata review → user-authorized version/tag
