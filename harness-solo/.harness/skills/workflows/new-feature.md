---
workflow_id: B
name: new-feature
description: "Develop new features through brainstorming, TDD-driven LOOPs, and code review"
default_mode: deep
---

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
│ Engineering Foundation Gate (hard gate) │
│                                         │
│  - docs/engineering/TECH_STACK.md       │
│    exists and has test/build/lint?      │
│  - docs/product/PROJECT.md exists?      │
│                                         │
│  ★ If missing → prompt to run setup     │
│    workflow first; do not proceed       │
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
│  │ executing-plans (scheduler)     │    │
│  │  Advance per task sequence,     │    │
│  │  checkpoint per task            │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ test-driven-development (ACT)   │    │
│  │  Red → Green → Refactor         │    │
│  └──────────┬──────────────────────┘    │
│             ▼                            │
│  ┌─────────────────────────────────┐    │
│  │ verify (VERIFY)                 │    │
│  │  Tests + AC + constitution +    │    │
│  │  security + entropy             │    │
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

See ASCII diagram above for node sequence. Each node delegates to its corresponding SKILL.md for detailed steps. Key nodes: session-start (load context) → Engineering Foundation Gate → brainstorming (hard gate) → writing-plans → LOOP(executing-plans/tdd/verify/systematic-debugging) → requesting-code-review → session-end (archive + update FEATURES.md).

## Engineering Foundation Gate (hard gate)

Before brainstorming, verify the engineering foundation exists:

- [ ] Read `docs/engineering/TECH_STACK.md` — must exist and have test/build/lint commands filled in
- [ ] Read `docs/product/PROJECT.md` — must exist with acceptance criteria
- [ ] If either is missing or incomplete → **refuse to proceed**, prompt user with options:
  - Option A: run `setup` workflow first (initialize config files)
  - Option B: run `new-product-engineering` workflow instead (it includes this gate and handles multi-feature)
- **Hard gate rationale**: executing-plans / verify depend on TECH_STACK.md for test/build/lint commands. Proceeding without it causes silent failures — commands cannot run, verify cannot validate, LOOP cannot iterate.

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
| Engineering Foundation Gate resolution | 👤 human decision | Always pause |
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
