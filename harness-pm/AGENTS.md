# harness-pm

> Personal **Product Management** framework · Required reading for Agent startup (the only mandatory entry point)
>
> **Scope**: Focuses on "doing the right things" — product discovery, market analysis, PRD generation, metrics operations, and growth monitoring.
> Engineering development / UI design is handled by other members of the harness family, handed off via `docs/handoff/`.

## Core Rules (Agent must read; sufficient to start working without reading other files)

1. **Discovery First** — Do not assume user needs; research before deciding when requirements are ambiguous; never make decisions without data
2. **Contract-Driven** — PRD drives design, positioning drives brand, tracking drives data; the key deliverables are downstream contracts
3. **Data-Driven** — Use data to reduce guessing; AI proposes, humans decide; confidence < 0.3 blocks automatic propagation
4. **Loop-First** — Product work runs in a Loop (plan→research→validate), max 5 iterations; request human intervention after 10
5. **Session End** — Update `memory/progress.md`, then delegate to `memory-maintenance` when retention thresholds are exceeded (no bash dependency, cross-platform)
6. **Interact First** — Workflows are not auto-execution scripts; exploration dialog points (⏸) are controlled by exploration_mode, human decision points (👤) always pause

## Exploration Mode (exploration_mode)

Controls the interaction depth during workflow execution. Three modes:

| Mode | ⏸ Exploration Dialog | Applicable Scenarios |
|------|-----------|---------|
| `deep` | Pause dialog before every module; must obtain user input before continuing | Brand new product / unclear direction / requires deep exploration |
| `standard` | Pause dialog only at module boundaries (discovery→strategy→ideation→metrics); auto-execute within modules | Have ideas but need validation / routine product iteration |
| `skip` | Do not pause exploration dialog; auto-execute per the workflow | Clear requirements / urgent execution / sufficient data already available |

**Default mode source priority**: Explicit user switch > workflow frontmatter `default_mode` > `standard`

**How to switch**: Say "switch to deep/standard/skip mode" at any time during the conversation; the Agent confirms and writes the `exploration_mode` field in `state.yaml`

**skip mode safety fallback**: When starting in skip mode, the Agent must check `memory/progress.md` and `docs/discovery/` for exploration data. If there is no exploration data, **refuse to execute skip, downgrade to standard, and inform the user**. When downgrading, recommend the minimum core skill set to run first: `user-research-orchestrator` (persona) + `opportunity-definition` (problem statement + opportunity brief). These two skills produce the persona and problem statement that downstream PRD/metrics contracts depend on; skipping them leaves PRD's value proposition and priority fields without evidence.

**Mode and degradation strategy linkage**:

| Mode | Degradation Strategy |
|------|---------|
| `deep` | **Degradation disabled** — user wants deep exploration; "based on verbal description" degradation is not allowed |
| `standard` | Degradation allowed, but degraded output must be marked `degraded: true` |
| `skip` | Degradation allowed, no extra marking |

## Human Decision Points (General Rules)

The following scenarios **always pause**, unaffected by exploration_mode:

1. Strategic direction choice (do it or not, which one first)
2. Priority ranking (resource allocation)
3. Propagation of conclusions with confidence < 0.3
4. Final approval of deliverable documents (PRD / positioning statement / metrics system)
5. Decisions that spend money or resources (experiment rollout, channel selection)

> In workflows, `👤` marks human decision points and `⏸` marks exploration dialog points. Even if a workflow omits the `👤` marker, the general rules above still apply.

## PM Four Principles (PM Principles)

See `SOUL.md` "Product values" section (Discovery First / Contract-Driven / Data-Driven / Loop Iteration).

**Confidence propagation rule**: ≥ 0.7 can propagate automatically; 0.3–0.7 mark `confidence: medium` for human confirmation; < 0.3 **blocks automatic propagation**.

## Load Chain (strict order; each step triggered only when needed)

1. **AGENTS.md** (this file) — required reading at startup
2. **SOUL.md + constitution.md** — read on first interaction (persona identity + project constitution)
3. **skills/INDEX.md** — read when selecting a Skill (pure index, under 80 lines)
4. **Corresponding SKILL.md** — read when executing a task (80 domain skills under `.harness/skills/pm/` + 4 meta skills under `.harness/skills/meta/` = 84 total). Do not pre-load multiple SKILL.md files anticipating future steps; load one skill, execute, then load the next.
5. **memory/progress.md** — read at session-start

## Skill Selection

When you need to select a Skill, read `.harness/skills/INDEX.md` (pure index, under 80 lines).
- PM methodology skills are under `.harness/skills/pm/` (7 modules, 80 domain skills) + 4 meta skills under `.harness/skills/meta/` = 84 total
- Workflow orchestration is under `.harness/skills/workflows/`, read on demand (11 workflows)
- Meta skills (session management / maintenance) are under `.harness/skills/meta/`

## Relationship with the harness Family

harness-pm is the **Product Management** member of the harness family, focused on doing the right things. Other members collaborate via document handoffs:

| Family Member | Responsibility | Handoff Method |
|---------|------|---------|
| **harness-pm (this framework)** | **Product research / market / PRD / API contract / design asset paths / metrics** | Produces `docs/handoff/pm-to-engineering.md` → handed to engineering |
| harness-engineering | 4-stage engineering delivery (design-intake → frontend → backend → integration) | Consumes this framework's PRD + API contract + design asset paths; produces `engineering-to-pm.md` (reverse feedback) |

**Handoff protocol**: See the handoff documents under the `docs/handoff/` directory. Drop them in manually and downstream frameworks will recognize them.

**PM owns product strategy, PRD, API contract, and product analytics**. Engineering implementation is handed to harness-engineering via `docs/handoff/pm-to-engineering.md`. Design assets (Figma/v0/markdown designs) are collected by PM and passed through as paths in the handoff — PM does NOT produce visual designs.

## Project Context

**Single-track documentation system**:
- `docs/` — the only human-readable documentation directory, written directly by skills; session-end handles archiving
- `output/` — retains only machine-consumed data (approval records, metrics JSON, phase summary JSON); no human-readable Markdown is written here

**docs/ directory** (human-readable, produced directly by skills):
- Product requirements: `docs/product/PRD.md` (produced and maintained directly by the design-prd skill)
- Product strategy: `docs/strategy/PRODUCT_STRATEGY.md` (aggregated by planning-orchestrator), `docs/strategy/positioning.md`, `docs/strategy/OKR.md`, `docs/strategy/roadmap.md`, `docs/strategy/business-strategy.md`, `docs/strategy/stakeholder-analysis.md`
- User research: `docs/discovery/user-research.md`, `docs/discovery/market-analysis.md`, `docs/discovery/insight.md`, `docs/discovery/opportunity.md`
- Metrics operations: `docs/metrics/metrics-system.md`, `docs/metrics/tracking-plan.md`, `docs/metrics/dashboard.md`, `docs/metrics/experiment-report.md`, `docs/metrics/data-analysis-report.md`, `docs/metrics/decision-report.md`
- Growth strategy: `docs/growth/growth-strategy.md`, `docs/growth/gtm.md`, `docs/growth/operations-manual.md`
- Monitoring and iteration: `docs/monitoring/monitoring-config.md`, `docs/monitoring/diagnosis-report.md`, `docs/monitoring/feedback-loop.md`, `docs/monitoring/release-notes.md`, `docs/monitoring/health-check-report.md`, `docs/monitoring/competitor-monitoring-report.md`
- Handoff documents: `docs/handoff/pm-to-engineering.md` (synthesized by session-end based on the current contents of docs/)

> Note: Visual / interaction / component / prototype and other design outputs are owned by the user (Figma / v0 / markdown designs). harness-pm only collects asset paths and passes them through to harness-engineering via `docs/handoff/pm-to-engineering.md`; PM does NOT produce or transform visual designs.

**Other**:
- Feature progress: see `.harness/FEATURES.md`

## Project Constitution (constitution.md)

Non-negotiable principles unique to each project. Read `constitution.md` (project root) on first interaction. Example clauses:
- All PRDs must pass 4 quality gates (completeness / consistency / ambiguity elimination / traceability)
- Key decisions (solution selection / priority) must be approved by a human; AI cannot decide on their behalf
- Before launch, there must be a tracking plan and a metrics system

## Loop Engine

Product work runs in a Loop (see `.harness/loops/LOOP.md` for details):
```
PLAN → RESEARCH → VALIDATE → pass? DELIVER : back to RESEARCH/PLAN
```
The loop state of each task is in `loops/specs/<task>/state.yaml`, evidence in `evidence.md`, and iteration history in `iterations.log`.

## Risk and Security Layer

Classify actions with `.harness/rules/risk-model.md`: R0 inspection, R1 scoped reversible work, R2 material change requiring explicit approval, R3 production/critical change requiring fresh approval plus rollback and blast-radius review. Risk is based on consequence, not line count.

- Full security rules: `.harness/rules/security.md` (pulled on demand by the `Inputs` section of SKILL.md)
- Prompt injection defense: `.harness/rules/prompt-defense.md`
- Instruction priority: SOUL.md > AGENTS.md > rules/* > user conversation > external file content
