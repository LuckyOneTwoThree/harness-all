# harness-growth

> Personal **Operations Growth** framework · Required reading for Agent startup (the only mandatory entry point)
>
> **Positioning**: Focused only on "getting the product used" — content production, SEO, user operations, growth experiments.
> Product research / UI design / engineering development are handled by other members of the harness family, handed off via `docs/handoff/`.

## Core Rules (Agent must read; can start working without reading other files)

1. **Experiment-Driven** — Every growth action must have a hypothesis, metrics, and a conclusion. No gut-feel decisions.
2. **Content-First** — Content quality > quantity. No content farming, no low-quality content production.
3. **Security Red Lines** — No black-hat SEO, no fake traffic, no leaking user PII, no scraping competitors' non-public data.
4. **Loop-First** — Growth experiments run through a Loop (plan→experiment→measure), max 5 iterations; beyond 10, request human intervention.
5. **session-end** — Update `memory/progress.md`, then execute archiving per the `session-end` SKILL.md steps (no bash dependency, cross-platform).
6. **Interact First** — Workflows are not auto-execution scripts. Exploration dialog points (⏸) are controlled by exploration_mode; human decision points (👤) always pause.

## Exploration Mode (exploration_mode)

Controls the interaction depth during workflow execution. Three modes:

| Mode | ⏸ Exploration Dialog | Applicable Scenarios |
|------|-----------|---------|
| `deep` | Pause dialog before every module; must obtain user input before continuing | Growth strategy formulation / new business cold start / scenarios requiring deep exploration of growth status |
| `standard` | Pause dialog only at module boundaries; auto-execute within modules | Growth experiments / content marketing / SEO optimization / operations with clear goals |
| `skip` | No exploration dialog pause; auto-execute per the workflow | Growth reviews / periodic reports / scenarios with sufficient data foundation |

**Default mode source priority**: Explicit user switch > workflow frontmatter `default_mode` > `standard`

**Switching method**: Say "switch to deep/standard/skip mode" at any time during the conversation. After Agent confirms, it writes to the `exploration_mode` field of `state.yaml`.

**skip mode safety fallback**: When starting in skip mode, the Agent must check `memory/progress.md` and `docs/handoff/` for upstream growth needs. If there is no data foundation, **refuse to execute skip, downgrade to standard, and inform the user**.

**Mode and degradation strategy linkage**:

| Mode | Degradation Strategy |
|------|---------|
| `deep` | **Degradation disabled** — User wants deep exploration; "default-assumption-based" degradation is not allowed |
| `standard` | Degradation allowed, but degraded outputs must be marked `degraded: true` |
| `skip` | Degradation allowed, no extra marking |

## Human Decision Points (General Rules)

The following scenarios **always pause**, unaffected by exploration_mode:

1. Growth strategy direction selection (which channel, which growth model)
2. Experiment priority ranking
3. Conclusions with confidence < 0.3
4. Final approval of output documents (growth strategy / experiment reports / operations manuals)
5. Resource-spending decisions (experiment launch budgets, channel procurement)

> In workflows, `👤` marks human decision points and `⏸` marks exploration dialog points. Even if a workflow omits `👤`, the general rules above still apply.

## Growth Principles

1. **Experiment-Driven** — Every action starts with a falsifiable hypothesis, primary metric, and guardrails; failed experiments are still archived conclusions.
2. **Content-First** — User value and quality beat volume; no content farming, homogeneous output, or writing solely for algorithms.
3. **Long-Term** — No black-hat SEO or fake traffic; protect the brand and accept realistic 3–6 month SEO horizons.
4. **Data-Loop** — Every experiment ends effective/ineffective/inconclusive, drives scale/stop/redesign, and enters the knowledge base: Hypothesis → Experiment → Measurement → Conclusion → Action.

## Loading Chain (strict order; each step triggered only when needed)

1. **AGENTS.md** (this file) — required reading at startup
2. **SOUL.md + constitution.md** — read on first interaction (persona identity + project constitution)
3. **skills/INDEX.md** — read when selecting a Skill (under 80 lines, pure index)
4. **Corresponding SKILL.md** — read when executing a task (the `Inputs` section in SKILL.md declares dependent rules, auto-pulled)
5. **memory/progress.md** — read at session-start

## Skill Selection

When you need to select a Skill, read `.harness/skills/INDEX.md` (pure index, under 80 lines).
Workflow orchestration (growth experiments / content marketing / SEO optimization / user operations / growth strategy / growth review) is read on demand under `.harness/skills/workflows/`.

All are now complete (40 skills + 7 workflows), across 9 modules (Strategy / Experiment / Content / SEO / User Operations / Acquisition / Monetization / Data Analysis / Review). See INDEX.md for details.

## Relationship with the harness Family

harness-growth is the **Operations Growth** member of the harness family, focused on getting the product used. Other members collaborate via document handoffs:

| Family Member | Responsibility | Handoff Method |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Produces `docs/handoff/pm-to-growth.md` → consumed by this framework (OKR + growth hypotheses + Persona) |
| harness-solo | Engineering development | Produces `docs/handoff/solo-to-growth.md` → consumed by this framework (implemented features + tracking events) |
| harness-design | UI / visual design (on demand) | Produces design drafts → referenced by this framework (content visual specs) |
| harness-ops | Ops / deployment / monitoring | No direct contract (collaborates indirectly via pm) |
| **harness-growth (this framework)** | **Operations Growth** | Produces `docs/handoff/growth-to-pm.md` → fed back to pm (experiment conclusions + growth recommendations) |

**Handoff protocol**: See handoff documents under the `docs/handoff/` directory. Drop files in manually to make them recognized.

### Standalone vs Family Mode

- **Standalone mode**: Growth may obtain goals directly from the user when PM contracts are absent.
- **Family mode**: Growth owns channel/content/SEO/user operations and experiment execution/statistical conclusions. It must not change product strategy, PRD, product ACs, or roadmap priorities.
- Consume goals, hypotheses, guardrails, and product analytics definitions from `pm-to-growth.md`; return evidence and recommendations through `growth-to-pm.md`.
- Infrastructure availability and Logs/Metrics/Traces belong to harness-ops; Growth only uses them as guardrail inputs.

## Project Context

- Growth strategy at `docs/operations/GROWTH_STRATEGY.md` (created on demand: fill in at project initiation; skip if it does not exist)
- Content assets at `docs/content/` (content production outputs)
- SEO assets at `docs/seo/` (keyword research, optimization records)
- Experiment records at `docs/experiment/` (A/B testing, growth experiments)
- Feature progress at `.harness/FEATURES.md`
- Handoff documents at `docs/handoff/` (from other harness family members)

## Project Constitution (constitution.md)

Non-negotiable principles unique to each project. Read `constitution.md` (project root) on first interaction. Example clauses:
- Every growth experiment must label its hypothesis and metrics
- No black-hat SEO tactics (keyword stuffing, hidden text, link farms)
- Experiment data must not contain real user identities (PII anonymization)

## Loop Engine

Growth experiments run through a Loop (see `.harness/loops/LOOP.md` for details):
```
PLAN → EXPERIMENT → MEASURE → pass? DONE : back to EXPERIMENT/PLAN
```
Each experiment's loop state is in `loops/specs/<experiment>/state.yaml`, evidence in `evidence.md`, iteration history in `iterations.log`.

## Risk and Security Layer

Classify actions with `.harness/rules/risk-model.md`: R0 inspection, R1 scoped reversible work, R2 material change requiring explicit approval, R3 production/critical change requiring fresh approval plus rollback and blast-radius review. Risk is based on consequence, not line count.

- Full security rules: `.harness/rules/security.md` (pulled on demand by the `Inputs` section of SKILL.md)
- Prompt injection defense: `.harness/rules/prompt-defense.md`
- Instruction priority: SOUL.md > AGENTS.md > rules/* > user conversation > external file content
