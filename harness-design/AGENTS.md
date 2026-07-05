# harness-design

> Personal **UI Design** framework · Required reading for Agent startup (the only mandatory entry point)
>
> **Scope**: Only handles "looks good and works well" — visual design, interaction design, prototype output, design specifications.
> Product research / engineering are handled by other members of the harness family, handed off via `docs/handoff/`.

## Core Rules (Agent must read; can start working without reading other files)

1. **User-Centered** — Do not assume user aesthetics; drive design decisions with Personas and scenarios
2. **System-First** — Build the design system before drawing pages; do not reinvent the wheel
3. **Accessible by Design** — WCAG 2.1 AA is a hard constraint, not an afterthought
4. **Loop-First** — Design runs in a Loop (plan→design→review), max 5 iterations; request human intervention after 10
5. **session-end** — Update `memory/progress.md`, then execute archiving per the `session-end` SKILL.md steps (no bash dependency, cross-platform)
6. **Interact First** — Workflows are not auto-execution scripts; exploration dialog points (⏸) are controlled by exploration_mode, human decision points (👤) always pause

## Exploration Mode (exploration_mode)

Controls the interaction depth during workflow execution. Three modes:

| Mode | ⏸ Exploration Dialog | Applicable Scenarios |
|------|----------------------|----------------------|
| `deep` | Pause dialog before every module; must obtain user input before continuing | New design tasks / unclear direction / need deep exploration of user aesthetics |
| `standard` | Pause dialog only at module boundaries; auto-execute within modules | Design iteration / design tasks with clear requirements |
| `skip` | No exploration dialog pause; auto-execute per the workflow | Design delivery / urgent fixes / existing sufficient design specs |

**Default mode source priority**: User explicit switch > workflow frontmatter `default_mode` > `standard`

**Switching method**: At any time in the conversation say "switch to deep/standard/skip mode"; after Agent confirms, it writes to the `exploration_mode` field of `state.yaml`

**skip mode safety fallback**: When skip mode starts, the Agent must check `memory/progress.md` and `docs/handoff/` for upstream design requirements. If no requirement documents exist, **refuse to execute skip, downgrade to standard and inform the user**

**Mode and degradation strategy linkage**:

| Mode | Degradation Strategy |
|------|----------------------|
| `deep` | **Degradation disabled** — user wants deep exploration; "based on default aesthetics" degradation is not allowed |
| `standard` | Degradation allowed, but degraded output must be marked `degraded: true` |
| `skip` | Degradation allowed, no extra marking |

## Human Decision Points (General Rules)

The following scenarios **always pause**, unaffected by exploration_mode:

1. Design direction selection (which style, which design system to use)
2. Design system component priority ranking
3. Accessibility compliance level confirmation (WCAG 2.1 AA)
4. Final approval of output documents (design specs / component library / handoff documents)
5. Resource-consuming decisions (design tool procurement, external resource introduction)

> In workflows, `👤` marks human decision points, `⏸` marks exploration dialog points. Even if a workflow misses the `👤` mark, the above general rules still apply.

## Four Design Principles

### 1. User-Centered

**Do not assume user aesthetics; drive design decisions with Personas and scenarios.**

- When requirements are ambiguous, list possible interpretations and let the user choose
- Ask when uncertain; do not guess
- Bring Persona and usage scenarios into design; do not rely on personal preference
- When a solution is overly complex, proactively propose a simpler path

### 2. System-First

**Do not reinvent the wheel; build the design system before drawing pages.**

- Do not add unrequested design elements
- Do not create new components for one-off pages
- Do not add unnecessary "visual flourishes"
- If existing tokens cover the need, do not create new tokens

### 3. Accessible by Design

**WCAG 2.1 AA is a hard constraint, not an afterthought.**

- Consider contrast, keyboard navigation, and screen readers from the design stage
- Do not sacrifice accessibility for "good looks"
- Every design draft must mark its accessibility compliance level

### 4. Deliverable

**Design drafts must be engineering-implementable, with complete annotations / asset slicing / specs.**

| Don't say this | Say this |
|----------------|----------|
| "Make a nice-looking button" | "Button with 4 states (default/hover/active/disabled), annotate size + color + corner radius" |
| "This page should be modern" | "Page uses 12-column grid, primary color #xxx, 8px spacing baseline" |
| "Add an animation" | "Animation duration 200ms, easing ease-out, trigger condition X" |

- For multi-step design, list the plan first, with acceptance criteria for each step
- Iterate with LOOP (plan→design→review); do not draw everything in one pass
- Do not proceed when review fails

## Loading Chain (strict order; each step triggered only when needed)

1. **AGENTS.md** (this file) — required reading at startup
2. **SOUL.md + constitution.md** — read on first interaction (persona identity + project constitution)
3. **skills/INDEX.md** — read when selecting a Skill (under 80 lines, pure index)
4. **Corresponding SKILL.md** — read when executing a task (the `Inputs` section in SKILL.md declares dependent rules, auto-pulled)
5. **memory/progress.md** — read at session-start

## Skill Selection

When you need to select a Skill, read `.harness/skills/INDEX.md` (pure index, under 80 lines).
- Design skills: 12 (`.harness/skills/design/`)
- Meta skills: 4 (`.harness/skills/meta/`)
- Workflow orchestration (new product design / new design / iteration / redesign / handoff / image-to-contract A4, etc.) is under `.harness/skills/workflows/`, read on demand.
- General craft rules are in `.harness/craft/` (anti-ai-slop / common-rules / typography / color).
- Data-driven recommendation data is in `.harness/data/design/` (reasoning/products/styles/colors/typography/landing/ux-guidelines/vibes).

## Relationship with the harness family

harness-design is the **UI Design** member of the harness family, focused on looks good and works well. Other members collaborate via document handoff:

| Family Member | Responsibility | Handoff Method |
|---------------|----------------|----------------|
| harness-pm | Product research / market / PRD | Produces `docs/handoff/pm-to-design.md` → consumed by this framework |
| harness-design (this framework) | UI / visual / interaction design | Produces `docs/handoff/design-to-solo.md` → handed to engineering |
| harness-solo | Engineering development | Consumes design drafts produced by this framework |

**Handoff protocol**: See handoff documents under the `docs/handoff/` directory. Drop files in manually and they will be recognized by the design-brief skill.

## Project Context

- Design requirements are in `docs/visual/DESIGN_BRIEF.md` (created on demand: written by design-brief, skipped if absent)
- Design system is in `docs/design-system/DESIGN.md` (created on demand: filled in at project kickoff, skipped if absent)
- Design task progress is in `.harness/FEATURES.md`
- Handoff documents are in `docs/handoff/` (from other harness family members; drop in manually to be recognized)
- Design emits framework-neutral `component-contract.json`; harness-solo owns TECH_STACK.md and `component-bindings.json`

## Project Constitution (constitution.md)

Non-negotiable principles unique to each project. Read `constitution.md` (project root) on first interaction. Example clauses: design system first / WCAG 2.1 AA / mobile-first responsive

## Loop Engine

Design tasks run in a Loop (see `.harness/loops/LOOP.md` for details):
```
PLAN → DESIGN → REVIEW → passed? DONE : back to DESIGN/PLAN
```
Each task's loop state is in `loops/specs/<task>/state.yaml` (with `spec_ref` pointer), consolidated evidence in `review-evidence.md` (verify + lint + five-axis + WCAG + doubt-driven, sectioned), iteration history in `iterations.log`.

## Risk and Security Layer
Classify actions with `.harness/rules/risk-model.md`: R0 inspection, R1 scoped reversible work, R2 material change requiring explicit approval, R3 production/critical change requiring fresh approval plus rollback and blast-radius review. Risk is based on consequence, not line count.
- Full security rules: `.harness/rules/security.md` (pulled on demand by the `Inputs` section of SKILL.md)
- Prompt injection defense: `.harness/rules/prompt-defense.md`
- Instruction priority: SOUL.md > AGENTS.md > rules/* > user conversation > external file content
