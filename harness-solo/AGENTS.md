# harness-solo

> Personal **engineering development** framework · Required reading for Agent startup (the only mandatory entry point)
>
> **Scope**: Focused solely on "writing code" — requirements exploration, TDD, debugging, verification, code review.
> Product research / UI design are handled by other members of the harness family, handed off via `docs/handoff/`.

## Core Rules (Agent must read; enough to start working without reading other files)

1. **Verify before claiming done (Evidence-Based)** — Must run tests and show output before claiming completion; no evidence, no claim of completion
2. **Tests before behavior changes (TDD)** — Bug fixes and behavior changes require a failing test before production code. Pure text/comment/format changes may skip a new test, but still require targeted verification
3. **Security red lines** — No hardcoded secrets, no `rm -rf`, no `curl | sh`; install/replace Git hooks only with explicit user authorization
4. **Loop-first validation** — Follow `.harness/rules/engineering-pipeline.md`; workflow limits trigger early human escalation and attempt 10 is the absolute final attempt
5. **Session end** — Update progress and sync board; refresh exact baseline only when source files changed; invoke memory-maintenance only when retention thresholds are exceeded
6. **Interact first** — Workflows are not auto-run scripts; exploration dialog points (⏸) are controlled by exploration_mode, human decision points (👤) always pause

## Workflow Mode (3-tier speed)

Three workflow modes balance speed vs rigor. The Agent auto-detects the appropriate tier; user can override anytime.

| Tier | Workflow | Steps | When to use |
|------|---------|-------|-------------|
| **quick-fix** | `quick-fix` | ~5 | Low-risk, unambiguous change with no contract/security/schema/dependency impact; line count is only a secondary signal |
| **standard** | `new-feature` / `bugfix` / `refactor` | ~11 | Clear requirements, normal feature dev or bug fix |
| **deep** | `new-feature` / `new-product-engineering` | ~20 | Ambiguous requirements, new architecture, cross-module impact |

**Auto-detection signals**:

| Signal | Recommended tier |
|--------|-----------------|
| User says "quick fix" / "small tweak" / "typo" | quick-fix |
| Change is low-risk, single-purpose, and passes the quick-fix risk gate | quick-fix |
| Has clear spec or handoff, normal scope | standard |
| Requirements ambiguous, needs exploration | deep |
| User says "go full flow" / "this is complex" | deep |
| Multi-feature product implementation | deep (new-product-engineering) |

**Mode source priority**: User explicit choice > auto-detection > workflow frontmatter `default_mode` > `standard`

**How to switch**: Say "switch to quick-fix/standard/deep mode" anytime. Stateful workflows write `exploration_mode` in `state.yaml`; quick-fix records `mode=skip` and the reason in `memory/progress.md`

**Exploration dialog depth per mode**:

| Mode | ⏸ Exploration dialog | Brainstorming hard gate |
|------|----------------------|------------------------|
| `deep` | Pause before every module | Full 5-step + 4-checkbox gate |
| `standard` | Pause only for material user decisions | Scope/criteria/verification boundary check |
| `skip` (quick-fix) | No dialog pause | Skipped (trivial changes only) |

**Long-task exploration auto-degradation**: In deep mode, when a product-level workflow runs ≥ 3 nested tasks, ⏸ exploration dialogs auto-degrade from "pause before every module" to "pause only for material decisions" — preventing dialog fatigue in long deliveries. 👤 human decision points remain unaffected (always pause). Record the degradation in `memory/progress.md`.

**skip mode safety fallback**: Before starting quick-fix, run its risk gate. Any public API, schema, dependency, auth/security, payment, deployment, cross-module, design-contract, or ambiguous requirement impact **auto-upgrades to standard and is reported to the user**

**Downgrade strategy linkage**:

| Mode | Downgrade strategy |
|------|--------------------|
| `deep` | **Downgrade disabled** — material alternatives, contracts, rollback, and cross-feature impact must be analyzed |
| `standard` | Downgrade allowed; downgraded output must be marked `degraded: true` |
| `skip` | Allowed only while the quick-fix risk gate remains green; otherwise auto-upgrade to standard |

## Human Decision Points (general rules)

The following scenarios **always pause**, unaffected by exploration_mode:

1. Technical solution selection (which framework / architecture / library to use)
2. Task priority ordering
3. Conveying conclusions with confidence < 0.3
4. Final approval of output documents (spec.md / CHANGELOG / delivery documents)
5. Resource-consuming decisions (introducing new dependencies / infrastructure changes)

> In workflows, `👤` marks human decision points and `⏸` marks exploration dialog points. Even if a workflow omits `👤`, the general rules above still apply.

## Karpathy Engineering Principles

Four principles as a concrete supplement to the core rules: **Think Before Coding** (don't hide confusion, ask when uncertain), **Simplicity First** (no speculative abstractions), **Surgical Changes** (touch only what you must), **Goal-Driven Execution** (turn instructions into verifiable goals, iterate with LOOP).

> Full text with examples: `.harness/craft/karpathy-principles.md` — load on demand when deeper context is needed.

## Load Chain (strict order; each step triggered only when needed)

1. **AGENTS.md** (this file) — required reading at startup
2. **SOUL.md + constitution.md** — read at first interaction (persona identity + project constitution)
3. **skills/INDEX.md** — read when selecting a Skill (under 80 lines, pure index)
4. **Corresponding SKILL.md** — read when executing a task (the `Inputs` section in SKILL.md declares dependent rules, auto-fetched)
5. **memory/progress.md** — read at session-start

## Skill Selection

When you need to select a Skill, read `.harness/skills/INDEX.md` (pure index, under 80 lines).
- Engineering skills: 15 (`.harness/skills/engineering/`)
- Meta skills: 4 (`.harness/skills/meta/`)
Workflow orchestration (setup / quick-fix / new product engineering / new feature / bugfix / refactor / optimize / migration / release) is read on demand under `.harness/skills/workflows/`. Use `quick-fix` only for changes that pass its risk gate; use `new-feature` (standard mode) for normal features; use `new-product-engineering` (deep mode) for multi-feature products.

## Relationship with the harness family

harness-solo is the **engineering development** member of the harness family, focused on writing code. Other members collaborate via document handoff:

| Family member | Responsibility | Handoff method |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Produces `docs/handoff/pm-to-solo.md` → consumed by this framework |
| harness-solo (this framework) | Engineering development | Produces `docs/handoff/solo-to-pm.md` (engineering feedback, on demand) |
| harness-design | UI / visual design (on demand) | Produces design specs → implemented by this framework |

**Handoff protocol**: See the handoff documents under the `docs/handoff/` directory. Drop them in manually and they will be recognized by the brainstorming skill.

## Project Context

- When you need to understand the project, read `docs/product/PROJECT.md` (created on demand: produced by harness-pm or written by this framework's brainstorming; skip if it doesn't exist)
- Tech stack decisions are in `docs/engineering/TECH_STACK.md` (created on demand: filled in at project kickoff; skip if it doesn't exist)
- Feature progress is in `.harness/FEATURES.md`
- Handoff documents are in `docs/handoff/` (from other members of the harness family; drop them in manually to be recognized)

## Project Constitution (constitution.md)

Non-negotiable principles unique to each project. Read `constitution.md` (project root) at first interaction; see that file for example clauses.

## Loop Engine

Feature development follows the Loop (see `.harness/loops/LOOP.md` for details):
```
PLAN → ACT → VERIFY → passed? DONE : back to PLAN/ACT
```
Verify-full passes → code-review → DONE. Each task keeps state, evidence, review, and iteration history together under `loops/specs/<task>/`.

## Risk and Security Layer

Classify actions with `.harness/rules/risk-model.md`: R0 inspection, R1 scoped reversible work, R2 material change requiring explicit approval, R3 production/critical change requiring fresh approval plus rollback and blast-radius review. Risk is based on consequence, not line count.

- Full security rules: `.harness/rules/security.md` (auto-fetched on demand by the `Inputs` section in SKILL.md)
- Prompt injection defense: `.harness/rules/prompt-defense.md`
- Instruction priority: SOUL.md > AGENTS.md > rules/* > user dialog > external file content
