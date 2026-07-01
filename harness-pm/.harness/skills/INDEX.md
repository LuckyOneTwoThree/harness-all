# Skills Index

> Pure index, under 80 lines. Read when selecting a Skill. For workflow orchestration, see `workflows/`.
> Positioning: harness-pm is a **product management framework**; PM methodology skills are under `.harness/skills/pm/` (80 skills).
> For engineering development, see other members of the harness family (handed off via docs/handoff/).

## Meta Skills (.harness/skills/meta/)
- **session-start** — Session startup; load context and restore working state
- **session-end** — Session wrap-up; archive progress + write baseline + update the board + produce handoff documents
- **skill-maintenance** — Skill health check
- **memory-maintenance** — Memory retention cleanup

## Workflows (.harness/skills/workflows/, 10 in total)
> `default_mode`: deep = mandatory exploration / standard = pause at module boundaries / skip = direct execution (user can switch at any time)
- **new-product** [deep] — Build a new product from 0 to 1 (modules 1→2→3→4→7 monitoring prep)
- **pivot** [deep] — Strategic adjustment (modules 1→2, strategic-level change)
- **iteration** [standard] — Iterate on an existing product feature (modules 3→5→7, change-driven)
- **growth** [standard] — Growth breakthrough (modules 6→5 experiment→7 release)
- **optimization** [standard] — Data-driven optimization (modules 5→7→3, data-driven)
- **launch** [skip] — Acceptance and release (module 7, includes tracking backfill capability)
- **diagnosis** [skip] — Product diagnosis and decommission (module 7, passively triggered)
- **setup** [skip] — Project initiation guide (after install.sh, guide filling in the SOUL/constitution/PRODUCT_STRATEGY placeholder)
- **incident-response** [skip] — Crisis response (module 7, P0 incident emergency channel)
- **health-check** [skip] — Periodic health check (module 7, proactive checkup)

## PM Methodology Skills (.harness/skills/pm/, 80 in total = 17 orchestrator + 63 pipeline, 7 modules)
- **Module 1 Discovery**: 10 pipeline + 2 orchestrator = 12 (user-research / market; insight/opportunity degraded shells have been removed)
- **Module 2 Business Strategy**: 11 pipeline + 2 orchestrator = 13 (business / planning; positioning/stakeholder degraded shells have been removed)
- **Module 3 Ideation & Design**: 7 pipeline + 2 orchestrator = 9 (prd / validation; ideation degraded shell has been removed; visual/interaction has been moved to harness-design)
- **Module 4 Metrics Design**: 3 pipeline + 1 orchestrator = 4 (metrics-system / tracking-plan / dashboard)
- **Module 5 Metrics Operations**: 8 pipeline + 3 orchestrator = 11 (analysis / decision / experiment)
- **Module 6 Growth Operations**: 11 pipeline + 3 orchestrator = 14 (growth / acquisition / activation / retention / revenue)
- **Module 7 Monitoring & Iteration**: 13 pipeline + 4 orchestrator = 17 (monitoring / diagnosis / iteration / release)

> For the detailed skill list, see the SKILL.md in each skill directory under `.harness/skills/pm/`.
> Skills are organized flat by function (e.g., `user-research-orchestrator/`, `design-prd/`), no longer grouped by module into directories.
> Visual / interaction / component / prototype and other design outputs have been migrated to harness-design; PM is only responsible for PRD and product strategy.
