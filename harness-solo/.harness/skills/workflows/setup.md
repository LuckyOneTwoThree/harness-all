---
workflow_id: A
name: setup
description: "Initialize a new harness-solo project by guiding users through filling in core configuration files"
default_mode: skip
---

# Workflow G: Project Onboarding

> Applicable scenario: A new project using harness-solo for the first time, needs to initialize config files
> Core mode: Guide the user in filling out constitution.md / SOUL.md / PROJECT.md / TECH_STACK.md

## Differences from Other Workflows

| Dimension | new-feature | **setup** |
|------|-------------|----------|
| Goal | Implement features | Initialize project config |
| Prerequisite | None | **install.sh has been executed** |
| LOOP | tdd→verify | **No LOOP (config-focused)** |
| Output | Code | **Config files fully filled out** |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm first-time use
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Check whether install.sh has been run   │
│                                         │
│  - .harness/ directory exists?          │
│  - AGENTS.md / SOUL.md / constitution.md│
│    created from templates?              │
│  - docs/product/PROJECT.md created?     │
│                                         │
│  ★ If not run → prompt user to run install.sh first │
└────────┬────────────────────────────────┘
         │ Already run
         ▼
┌─────────────────┐
│ Fill out        │  Persona + tech preferences
│ SOUL.md         │  - [username] replacement
│                 │  - Tech stack preferences (frontend/backend/deploy/test)
│                 │  - Coding style
└────────┬────────┘
         ▼
┌─────────────────┐
│ Fill out        │  Project constitution
│ constitution.md │  - Derived from codebase analysis (not copying generic rules)
│                 │  - Each clause is verifiable
│                 │  - Examples: zero new dependencies / APIs have tests / schemas have migrations
└────────┬────────┘
         ▼
┌─────────────────┐
│ Fill out        │  Product requirements
│ PROJECT.md      │  - Project overview / background & motivation / target users
│                 │  - Functional requirements + acceptance criteria (testable)
│                 │  - Out of scope / technical constraints / non-functional requirements
│                 │  - Success metrics / milestones / dependencies & risks
└────────┬────────┘
         ▼
┌─────────────────┐
│ Fill out        │  Tech stack
│ TECH_STACK.md   │  - Language / framework / database
│                 │  - Test command / build command / lint command
│                 │  - Deployment method
└────────┬────────┘
         ▼
┌─────────────────┐
│ Validate config │
│ completeness    │  - All 4 files filled out?
│                 │  - Constitution clauses verifiable?
│                 │  - PROJECT.md ACs testable?
│                 │  - TECH_STACK.md commands executable?
└────────┬────────┘
         │ Passed
         ▼
┌─────────────────┐
│ session-end     │  Record onboarding info to progress.md
│                 │  - Project name / tech stack / key constitution points
│                 │  - Next step: enter the new-feature workflow
└─────────────────┘
```

## Key Checkpoints

- [ ] SOUL.md's [username] replaced? Tech preferences filled in?
- [ ] Are constitution.md clauses verifiable? (Not "code should be good", but "package.json dependencies diff review")
- [ ] Are PROJECT.md's acceptance criteria testable? (Not "easy to use", but "input X returns Y")
- [ ] Can TECH_STACK.md's test/build/lint commands run successfully?
- [ ] Are all 4 files saved?

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| install.sh not executed | Prompt user to run install.sh first |
| Constitution clause not verifiable | Help the user rewrite it as a verifiable description |
| PROJECT.md AC not testable | Help the user rewrite it as a testable description |
| TECH_STACK.md commands don't run | Verify command correctness and fix |

## Division of Labor with install.sh

| Stage | Responsibility |
|------|------|
| install.sh | Copy template files to the project directory (mechanical operation) |
| **setup workflow** | Guide the user to fill in the template content (intelligent guidance) |

install.sh only ensures "files are in place"; the setup workflow ensures "content is filled in correctly".
