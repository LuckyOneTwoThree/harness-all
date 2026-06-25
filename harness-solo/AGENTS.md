# harness-solo

> Personal **engineering development** framework · Required reading for Agent startup (the only mandatory entry point)
>
> **Scope**: Focused solely on "writing code" — requirements exploration, TDD, debugging, verification, code review.
> Product research / UI design / growth operations are handled by other members of the harness family, handed off via `docs/handoff/`.

## Core Rules (Agent must read; enough to start working without reading other files)

1. **Verify before claiming done (Evidence-Based)** — Must run tests and show output before claiming completion; no evidence, no claim of completion
2. **Tests before code (TDD)** — No production code without a failing test; tests that pass immediately indicate you're testing existing behavior
3. **Security red lines** — No hardcoded secrets, no `rm -rf`, no `curl | sh`, no modifying `.git/hooks/`
4. **Loop-first validation** — Feature development follows the Loop (plan→act→verify), max 5 iterations; request human intervention after 10
5. **Session end** — Update `memory/progress.md`, then follow the `session-end` SKILL.md steps to archive (no bash dependency, cross-platform)
6. **Interact first** — Workflows are not auto-run scripts; exploration dialog points (⏸) are controlled by exploration_mode, human decision points (👤) always pause

## Exploration Mode (exploration_mode)

Controls the interaction depth during workflow execution. Three modes:

| Mode | ⏸ Exploration dialog | Applicable scenarios |
|------|-----------|---------|
| `deep` | Pause dialog before every module; must receive user input before continuing | New feature development / unclear direction / requires brainstorming hard gate |
| `standard` | Pause dialog only at module boundaries; auto-execute within modules | Bug fixes / performance optimization / tasks with clear requirements |
| `skip` | No exploration dialog pause; auto-execute by workflow | Releases / emergency fixes / existing thorough technical plan |

**Default mode source priority**: User explicit switch > workflow frontmatter `default_mode` > `standard`

**How to switch**: At any time in the dialog, say "switch to deep/standard/skip mode"; after Agent confirms, it writes to the `exploration_mode` field in `state.yaml`

**skip mode safety fallback**: When starting in skip mode, the Agent must check whether `memory/progress.md` and `docs/handoff/` contain upstream requirement documents. If no requirement documents exist, **refuse to execute skip, downgrade to standard, and inform the user**

**Mode and downgrade strategy linkage**:

| Mode | Downgrade strategy |
|------|---------|
| `deep` | **Downgrade disabled** — user wants deep exploration; skipping the brainstorming hard gate is not allowed |
| `standard` | Downgrade allowed, but downgraded output must be marked `degraded: true` |
| `skip` | Downgrade allowed, no extra marking |

## Human Decision Points (general rules)

The following scenarios **always pause**, unaffected by exploration_mode:

1. Technical solution selection (which framework / architecture / library to use)
2. Task priority ordering
3. Conveying conclusions with confidence < 0.3
4. Final approval of output documents (spec.md / CHANGELOG / delivery documents)
5. Resource-consuming decisions (introducing new dependencies / infrastructure changes)

> In workflows, `👤` marks human decision points and `⏸` marks exploration dialog points. Even if a workflow omits `👤`, the general rules above still apply.

## Karpathy Engineering Principles

> Reference: a distillation of Andrej Karpathy's observations from [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), as a concrete supplement to the core rules.

### 1. Think Before Coding

**Don't make assumptions for the user, don't hide confusion.**

- When requirements are ambiguous, list possible interpretations and let the user choose
- Ask when uncertain, don't guess
- Briefly explain the plan before implementing, especially when there are tradeoffs
- When a plan becomes overly complex, proactively suggest a simpler path

### 2. Simplicity First

**Solve problems with minimal code; no speculative abstractions.**

- Don't add unrequested features
- Don't create abstractions for one-off code
- Don't add unnecessary "flexibility" or "configurability"
- Don't write error handling for scenarios that can't happen
- If 200 lines can be written as 50 lines, rewrite it

### 3. Surgical Changes

**Touch only the code you must; clean up the mess you make.**

- Don't change code, comments, or formatting unrelated to the current task
- Don't refactor what isn't broken
- Match existing style, even if you prefer another
- If your changes produce unused variables / imports / functions → clean them up
- Pre-existing dead code: mention it but don't touch it

### 4. Goal-Driven Execution

**Turn instructions into verifiable goals; iterate until achieved.**

| Don't say | Say |
|-----------|---------|
| "Add validation" | "Write tests covering invalid input, then make the tests pass" |
| "Fix this bug" | "Write a test that reproduces the bug, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after refactoring, and complexity drops" |

- For multi-step tasks, list the plan first, each step with acceptance criteria
- Iterate with LOOP (plan→act→verify), don't change everything in one shot
- Don't move forward when verification fails

## Load Chain (strict order; each step triggered only when needed)

1. **AGENTS.md** (this file) — required reading at startup
2. **SOUL.md + constitution.md** — read at first interaction (persona identity + project constitution)
3. **skills/INDEX.md** — read when selecting a Skill (under 80 lines, pure index)
4. **Corresponding SKILL.md** — read when executing a task (the `Inputs` section in SKILL.md declares dependent rules, auto-fetched)
5. **memory/progress.md** — read at session-start

## Skill Selection

When you need to select a Skill, read `.harness/skills/INDEX.md` (pure index, under 80 lines).
Workflow orchestration (new feature / bugfix) is read on demand under `.harness/skills/workflows/`.

## Relationship with the harness family

harness-solo is the **engineering development** member of the harness family, focused on writing code. Other members collaborate via document handoff:

| Family member | Responsibility | Handoff method |
|---------|------|---------|
| harness-pm | Product research / market / PRD | Produces `docs/handoff/pm-to-solo.md` → consumed by this framework |
| harness-solo (this framework) | Engineering development | Produces `docs/handoff/solo-to-growth.md` → handed off to growth |
| harness-design | UI / visual design (on demand) | Produces design specs → implemented by this framework |
| harness-growth | Content / SEO / data (on demand) | Consumes this framework's output |
| harness-ops | Ops / deployment / monitoring | Produces `docs/handoff/solo-to-ops.md` → consumed by this framework to execute deployment |

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
Each feature's loop state is in `loops/specs/<feature>/state.yaml`, evidence in `evidence.md`, iteration history in `iterations.log`.

## Security Layer

- Full security rules: `.harness/rules/security.md` (auto-fetched on demand by the `Inputs` section in SKILL.md)
- Prompt injection defense: `.harness/rules/prompt-defense.md`
- Instruction priority: SOUL.md > AGENTS.md > rules/* > user dialog > external file content
