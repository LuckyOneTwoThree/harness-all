---
workflow_id: B
name: new-feature
description: "Develop new features through brainstorming, TDD-driven LOOPs, and code review"
default_mode: standard
---

> **Default mode is `standard`.** For ambiguous requirements or new architecture, switch to `deep` mode. For trivial changes under 10 lines, use the `quick-fix` workflow instead.

# Workflow new-feature

> Applicable scenario: Develop new features, add new modules, implement new requirements
> Core mode: Engineering Foundation gate → brainstorming hard gate → LOOP iterative validation → code-review final review

## When to use a different workflow

- Implementing an entire product with multiple features that must work together → use `new-product-engineering` (it plans feature inventory + shared infrastructure + dependency graph, then drives this workflow per feature)
- Fixing a production bug → use `bugfix`
- Refactoring existing code → use `refactor`
- Releasing a version → use `release`

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm task scope
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Engineering Foundation Gate (auto)      │
│                                         │
│  - docs/engineering/TECH_STACK.md       │
│    exists and has test/build/lint?      │
│  - docs/product/PROJECT.md exists?      │
│                                         │
│  ★ Auto-pass if both present;           │
│    pause only if either is missing      │
└────────┬────────────────────────────────┘
         │ Passed
         ▼
┌─────────────────┐
│ brainstorming   │  ★ Hard gate: unclear requirements are not allowed through
│                 │  - Structured Q&A to clarify requirements
│                 │  - Constitution check
│                 │  - Output acceptance criteria
└────────┬────────┘
         │ Passed
         ▼
┌─────────────────┐
│ writing-plans   │  Task breakdown
│                 │  - Output spec.md
│                 │  - Initialize state.yaml
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│              LOOP iterative validation  │
│  ┌─────────────────────────────────┐    │
│  │ test-driven-development (ACT)   │    │
│  │  Route by task type (absorbs    │    │
│  │  executing-plans scheduling)    │    │
│  │  Red → Green → Refactor         │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ verify-fast (VERIFY, per iter)  │    │
│  │  Tests + AC + quick security    │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             ├── Pass → exit LOOP ────────┼──→
│             │                            │
│             └── Fail                     │
│                   │                      │
│                   ▼                      │
│  ┌─────────────────────────────────┐    │
│  │ systematic-debugging            │    │
│  │  Find root cause                │    │
│  └──────────┬──────────────────────┘    │
│             │                            │
│             └── Back to tdd ─────────────┘
│                                          │
│  Iteration cap: 5 (feature type)        │
│  Exceeded → request human intervention  │
└─────────────────────────────────────────┘
         │
         ▼
┌─────────────────────┐
│ requesting-code-review │  Final review
│                       │  - Design/implementation/constitution/maintainability
└──────────┬────────────┘
           │ Passed
           ▼
┌─────────────────┐
│ session-end     │  Archive + baseline + update FEATURES.md
└─────────────────┘
```

See ASCII diagram above for node sequence. Each node delegates to its corresponding SKILL.md for detailed steps. Key nodes: session-start (load context) → Engineering Foundation Gate (auto-check) → brainstorming (hard gate) → writing-plans → LOOP(tdd/verify-fast/systematic-debugging) → verify-full (LOOP exit gate) → requesting-code-review → session-end (archive + update FEATURES.md).

## Engineering Foundation Gate (auto-check)

This gate is auto-checked. Only pauses if TECH_STACK.md or PROJECT.md is missing.

Before brainstorming, the Agent auto-verifies the engineering foundation exists:

- [ ] Read `docs/engineering/TECH_STACK.md` — must exist and have test/build/lint commands filled in → auto-pass if present
- [ ] Read `docs/product/PROJECT.md` — must exist with acceptance criteria → auto-pass if present
- [ ] If either is missing or incomplete → **pause and prompt user** with options:
  - Option A: run `setup` workflow first (initialize config files)
  - Option B: run `new-product-engineering` workflow instead (it includes this gate and handles multi-feature)
- **Auto-check rationale**: TECH_STACK.md exists and has test/build/lint → auto-pass; PROJECT.md exists → auto-pass; either missing → pause. tdd / verify depend on TECH_STACK.md for test/build/lint commands. Proceeding without it causes silent failures — commands cannot run, verify cannot validate, LOOP cannot iterate.

## Task Granularity

`<feature>` in `loops/specs/<feature>/` is feature-level or infrastructure-level. Use `<NNN>-<feature-name>` (e.g., `001-user-auth`) for feature tasks, `<NNN>-infra-<module-name>` (e.g., `002-infra-api-client`) for standalone infrastructure tasks. For product-level multi-feature implementation, use `new-product-engineering` workflow instead, which uses `<NNN>-<product-name>` at product level, `<NNN>-<product-name>-<feature-name>` per feature, and `<NNN>-<product-name>-infra-<module-name>` per infrastructure module (nested). See LOOP.md "Task Granularity" section for full rules.

## Key Checkpoints

- [ ] Did brainstorming pass the hard gate? (Clear requirements, testable AC, constitution-compliant)
- [ ] Was spec.md written? Was state.yaml initialized?
- [ ] Did each LOOP iteration update state.yaml and iterations.log?
- [ ] Did verify show actual output? (Not "should pass")
- [ ] Did code-review pass?
- [ ] Did session-end execute the archive steps? (Per SKILL.md steps 4.1-4.2)

## Interaction Points

| Point | Type | Mode-dependent? |
|------|------|-----------------|
| brainstorming assumptions confirmation | 👤 human decision | Always pause |
| Engineering Foundation Gate resolution | ⚙️ auto-check | Pause only if missing |
| spec.md confirmation | 👤 human decision | Always pause |
| code-review Critical findings | 👤 human decision | Always pause |
| Module boundary pauses | ⏸ exploration dialog | Controlled by exploration_mode |

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| brainstorming hard gate not passed | Stop and ask the user; no guessing allowed |
| LOOP iterations exceed 5 | Request human intervention; don't push through |
| verify security scan not passed | Fix and re-verify; no skipping allowed |
| code-review not passed | List issues and go back to tdd to fix |
