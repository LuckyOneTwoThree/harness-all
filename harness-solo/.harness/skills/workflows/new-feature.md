---
workflow_id: B
name: new-feature
description: "Develop new features through brainstorming, TDD-driven LOOPs, and code review"
default_mode: deep
---

# Workflow A: New Feature Development

> Applicable scenario: Develop new features, add new modules, implement new requirements
> Core mode: brainstorming hard gate → LOOP iterative validation → code-review final review

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm task scope
└────────┬────────┘
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

## Key Checkpoints

- [ ] Did brainstorming pass the hard gate? (Clear requirements, testable AC, constitution-compliant)
- [ ] Was spec.md written? Was state.yaml initialized?
- [ ] Did each LOOP iteration update state.yaml and iterations.log?
- [ ] Did verify show actual output? (Not "should pass")
- [ ] Did code-review pass?
- [ ] Did session-end execute the archive steps? (Per SKILL.md steps 4.1-4.2)

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| brainstorming hard gate not passed | Stop and ask the user; no guessing allowed |
| LOOP iterations exceed 5 | Request human intervention; don't push through |
| verify security scan not passed | Fix and re-verify; no skipping allowed |
| code-review not passed | List issues and go back to tdd to fix |
