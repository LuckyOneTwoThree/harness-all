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
- **brainstorming** — Requirements exploration, hard gate (mode-adaptive: 5-step deep / 3-step standard)
- **writing-plans** — Task decomposition, output spec.md (mode-adaptive: 5-step deep / 3-step standard)
- **executing-plans** — [MERGED into test-driven-development] Routing logic absorbed into tdd Step 1; retained for reference only
- **test-driven-development** — TDD red→green→refactor (3 steps, absorbs executing-plans routing in Step 1)
- **test-coverage** — Add tests for existing code, coverage gap analysis
- **systematic-debugging** — Systematic debugging, root cause analysis
- **performance-optimization** — Performance optimization, measure→fix→verify closed loop
- **migration** — Code migration, framework upgrade / API migration, guard against regression
- **dependency-management** — Dependency management, add / upgrade / audit, integrates with the constitution approval gate
- **frontend-implementation** — Frontend engineering implementation, components / state / styling (not visual design)
- **verify** — Two-layer verification: verify-fast (3-step per iteration) + verify-full (8-step LOOP exit gate)
- **product-engineering-review** — Product-level cross-feature consistency review (after all features implemented, before handoff)
- **webapp-testing** — Frontend verification, pure Agent tool approach (build / type / lint / accessibility)
- **requesting-code-review** — Code review, quality gatekeeping
- **receiving-code-review** — Review feedback handling, classify + fix + reply
- **writing-skills** — Create new skills per the standard, supports framework extension
- **writing-documentation** — Documentation writing, ADR / API doc / CHANGELOG, document the why

## Workflows

> 3-tier speed: quick-fix (~5 steps, <10 lines) / standard (~18 steps, normal features) / deep (~35 steps, complex/ambiguous)
> Auto-detection based on change size and complexity; user can override anytime.

- **setup** [skip] — Project kickoff guidance (after install.sh, guide filling in SOUL/constitution/PROJECT/TECH_STACK)
- **quick-fix** [skip] — Fast path for small changes under 10 lines (understand → fix → test → commit → log)
- **new-product-engineering** [deep] — Product-level engineering (plan all features → shared infrastructure → per-feature new-feature LOOPs → product-review → handoff)
- **new-feature** [standard] — New feature development (brainstorming → LOOP → code-review)
- **bugfix** [standard] — Bug fix (systematic-debugging → LOOP → code-review)
- **refactor** [standard] — Refactoring (brainstorming to confirm boundaries → LOOP guarding against regression → code-review)
- **optimize** [standard] — Performance optimization (performance-optimization measure→fix→verify → code-review)
- **migration** [standard] — Code migration (migration decision → LOOP incremental migration → verify zero usage → remove old system)
- **release** [skip] — Release (verify full → CHANGELOG → tag → release artifact verification)
