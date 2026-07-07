# harness-engineering

> **4-stage engineering development** framework · Required reading for Agent startup (the only mandatory entry point)
>
> **Scope**: End-to-end engineering delivery across 4 phases — design-intake → frontend → backend → integration.
> Consumes PRD + API contract + design asset paths from harness-pm; produces integration results and open issues for harness-pm.

## Core Rules (Agent must read; enough to start working without reading other files)

1. **Verify before claiming done (Evidence-Based)** — Must run tests and show output before claiming completion; no evidence, no claim of completion
2. **Tests before behavior changes (TDD)** — Frontend TDD is owned by ACT; bug fixes and behavior changes require a failing test before production code. Pure text/comment/format changes may skip a new test, but still require targeted verification
3. **Security red lines** — No hardcoded secrets, no `rm -rf`, no `curl | sh`; install/replace Git hooks only with explicit user authorization
4. **Phase checkpoint** — Each of the 4 phases requires explicit user confirmation before advancing; no silent phase transitions (see constitution.md Principle 2)
5. **Loop-first validation** — Follow `.harness/rules/engineering-pipeline.md`; workflow limits trigger early human escalation and attempt 10 is the absolute final attempt
6. **Interact first** — Workflows are not auto-run scripts; exploration dialog points (⏸) are controlled by exploration_mode, human decision points (👤) always pause

## Four Phases

| Phase | Name | Input | Output |
|-------|------|-------|--------|
| 0 | design-intake | `pm-to-engineering.md` (PRD + API contract + design asset paths) **or** user-provided assets directly (degraded mode) | `contract.json` + `tokens.json` |
| 1 | frontend | `contract.json` + `tokens.json` + design assets (dual-input: contract layer + visual layer) | Frontend code (TDD, mock-backed) |
| 2 | backend | API contract from `contract.json` | Backend implementation (api + data + migration) |
| 3 | integration | frontend + backend | mock→real switch + e2e verification + `engineering-to-pm.md` |

**Phase 0 accepts these user-owned design asset types** (PM collects paths in family mode; user drops them directly in degraded mode):

| Asset type | Examples | Phase 0 route |
|------------|----------|---------------|
| Image | `.png` / `.jpg` / `.webp` (screenshots, sketches, mockups, Figma exports) | Multimodal extraction (color / typography / spacing / layout) |
| Code | v0 export, `tailwind.config.js`, `theme.ts`, `globals.css`, shadcn `components.json` | Code parsing (extract tokens + component structure) |
| Markdown | `*.md` design specs with structured sections | Markdown structuring |
| Figma | Figma URL / export (used as visual reference in Phase 1) | Path forwarded to Phase 1 dual-input |

> **Degraded mode**: when no design assets exist, Phase 0 produces `contract.json` + `tokens.json` based on PRD only; visual fidelity is marked as 👤 human-adjusted in Phase 1.

- **Full-stack mode** (Next.js / Remix): one repo, `app/` (frontend) + `api/` (backend) + `lib/` (shared)
- **Separated mode** (React + Express): two roots, `contract.json` is the single source of truth

## Workflow Mode (3-tier speed × 4 phases)

Three workflow modes balance speed vs rigor. The Agent auto-detects the appropriate tier; user can override anytime.

| Tier | Phases | When to use |
|------|--------|-------------|
| **skip** | Phase 3 only | Low-risk patch to existing integration; no contract/security/schema/dependency impact |
| **standard** | Phase 0 → 1 → 2 → 3 | Clear PRD + design assets, normal feature dev |
| **deep** | Phase 0 (deep) → 1 → 2 → 3 + OpenAPI | Ambiguous requirements, new architecture, cross-module impact |

**Auto-detection signals**:

| Signal | Recommended tier |
|--------|-----------------|
| User says "quick fix" / "small tweak" / "typo" | skip |
| Change is low-risk, single-purpose, and passes the skip risk gate | skip |
| Has clear PRD + design assets, normal scope | standard |
| Requirements ambiguous, needs exploration | deep |
| User says "go full flow" / "this is complex" | deep |
| Multi-feature product implementation | deep (new-product-engineering) |

**Mode source priority**: User explicit choice > auto-detection > workflow frontmatter `default_mode` > `standard`

**How to switch**: Say "switch to skip/standard/deep mode" anytime. Stateful workflows write `exploration_mode` in `state.yaml`; skip records `mode=skip` and the reason in `memory/progress.md`

**skip mode safety fallback**: Before starting, run its risk gate. Any public API, schema, dependency, auth/security, payment, deployment, cross-module, design-contract, or ambiguous requirement impact **auto-upgrades to standard and is reported to the user**

## Human Decision Points (general rules)

The following scenarios **always pause**, unaffected by exploration_mode:

1. Phase checkpoint confirmation (advance to next phase)
2. Technical solution selection (which framework / architecture / library to use)
3. Task priority ordering
4. Conveying conclusions with confidence < 0.3
5. Final approval of output documents (`contract.json` / `engineering-to-pm.md` / CHANGELOG)
6. Resource-consuming decisions (introducing new dependencies / infrastructure changes)

> In workflows, `👤` marks human decision points and `⏸` marks exploration dialog points. Even if a workflow omits `👤`, the general rules above still apply.

## Karpathy Engineering Principles

See `SOUL.md` "Engineering values" section (Think before coding / Evidence-driven / TDD-first / Simplicity first / Surgical changes / Goal-driven).

> Full text with examples: `.harness/craft/karpathy-principles.md` — load on demand when deeper context is needed.

## Load Chain (strict order; each step triggered only when needed)

1. **AGENTS.md** (this file) — required reading at startup
2. **SOUL.md + constitution.md** — read at first interaction (persona identity + project constitution)
3. **skills/INDEX.md** — read when selecting a Skill (under 80 lines, pure index)
4. **Corresponding SKILL.md** — read when executing a task (the `Inputs` section in SKILL.md declares dependent rules, auto-fetched). Do not pre-load multiple SKILL.md files anticipating future steps; load one skill, execute, then load the next.
5. **memory/progress.md** — read at session-start

## Skill Selection

When you need to select a Skill, read `.harness/skills/INDEX.md` (pure index, under 80 lines).
- design-intake skills: 1 (`.harness/skills/design-intake/`) — Phase 0
- frontend skills: 2 (`.harness/skills/frontend/`) — frontend-implementation, webapp-testing
- backend skills: 4 (`.harness/skills/backend/`) — api-implementation, data-layer, migration, dependency-management
- integration skills: 6 (`.harness/skills/integration/`) — mock-to-real-switch, e2e-verification, contract-verify, product-engineering-review, verify, code-review
- engineering skills: 8 (`.harness/skills/engineering/`) — brainstorming, writing-plans, TDD, systematic-debugging, test-coverage, performance-optimization, writing-skills, writing-documentation
- meta skills: 4 (`.harness/skills/meta/`) — session-start, session-end, memory-maintenance, skill-maintenance

Workflow orchestration (setup / quick-fix / new-product-engineering / new-feature / bugfix / refactor / optimize / migration / release) is read on demand under `.harness/skills/workflows/`. Use `skip` (quick-fix) only for changes that pass its risk gate; use `new-feature` (standard) for normal features; use `new-product-engineering` (deep) for multi-feature products.

## Relationship with the harness family

harness-engineering is the **engineering development** member of the harness family. Two frameworks collaborate via document handoff:

| Family member | Responsibility | Handoff method |
|---------|------|---------|
| harness-pm | Product research / market / PRD / API contract / design asset paths | Produces `docs/handoff/pm-to-engineering.md` → consumed by this framework |
| harness-engineering (this framework) | 4-stage engineering delivery | Produces `docs/handoff/engineering-to-pm.md` (integration results + open issues) |

**Handoff protocol**: See the handoff documents under the `docs/handoff/` directory. Drop them in manually and they will be recognized by the design-intake skill.

## Project Context

- Project overview: `docs/product/PROJECT.md` (produced by harness-pm; skip if absent)
- Tech stack: `docs/engineering/TECH_STACK.md` (filled at project kickoff; skip if absent)
- Feature progress: `.harness/FEATURES.md`
- Handoff documents: `docs/handoff/` (from harness-pm; recognized by design-intake)

## Project Constitution (constitution.md)

Non-negotiable principles unique to each project. Read `constitution.md` (project root) at first interaction; see that file for example clauses.

## Loop Engine

Feature development follows the 4-substage Loop (see `.harness/loops/LOOP.md` for details):
```
PLAN → ACT → VERIFY → REVIEW → passed? DONE : back to PLAN/ACT
```
- Each phase runs its own Loop; phase checkpoint (`👤`) gates phase transition
- Verify-full passes → code-review → DONE
- Each task keeps state, evidence, review, and iteration history under `loops/specs/<task>/`

## Risk and Security Layer

Classify actions with `.harness/rules/risk-model.md`: R0 inspection, R1 scoped reversible work, R2 material change requiring explicit approval, R3 production/critical change requiring fresh approval plus rollback and blast-radius review. Risk is based on consequence, not line count.

- Full security rules: `.harness/rules/security.md` (auto-fetched on demand by the `Inputs` section in SKILL.md)
- Prompt injection defense: `.harness/rules/prompt-defense.md`
- Instruction priority: SOUL.md > AGENTS.md > rules/* > user dialog > external file content
