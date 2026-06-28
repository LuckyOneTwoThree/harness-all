---
workflow_id: I
name: quick-fix
description: "Fast path for small changes: typo fixes, small bug fixes, minor tweaks"
default_mode: skip
---

# Workflow quick-fix

> Applicable scenario: Changes under ~10 lines, no new dependencies, no new APIs, no schema changes, no frontend component contracts
> Core mode: Understand → Fix → Test → Commit → Log

## When to use this workflow

Use quick-fix when **all** of the following are true:

- Estimated change is under 10 lines of code
- No new dependencies introduced
- No new API endpoints or API signature changes
- No database schema changes or migrations
- No frontend component contract (`Contract: component-map.json#...`) involved
- No core file modifications (AGENTS.md / SOUL.md / constitution.md / security.md / prompt-defense.md)

## When to use a different workflow

- Change grows beyond 10 lines or scope expands → upgrade to `new-feature` (standard mode)
- Fixing a production bug that needs root cause analysis → use `bugfix`
- Change involves new dependencies or schema → use `new-feature`
- Implementing multiple features that must work together → use `new-product-engineering`

## Auto-detection signals

| Signal | Recommended workflow |
|--------|---------------------|
| User says "quick fix" / "small tweak" / "typo" | quick-fix |
| User says "go full flow" / "this is complex" | new-feature (deep mode) |
| Change is a single-file edit under 10 lines | quick-fix |
| Change touches multiple files or modules | new-feature (standard mode) |
| Requirements are ambiguous | new-feature (deep mode) |

## Process

```
┌─────────────────┐
│ 1. Understand   │  Confirm what needs changing and why
│                 │  - User describes the issue
│                 │  - Agent confirms scope in one sentence
└────────┬────────┘
         ▼
┌─────────────────┐
│ 2. Fix          │  Make the change directly
│                 │  - Use Edit tool to modify code
│                 │  - No spec.md, no state.yaml needed
└────────┬────────┘
         ▼
┌─────────────────┐
│ 3. Test         │  Run tests and show actual output
│                 │  - Run project test command from TECH_STACK.md
│                 │  - Show full output (not "tests passed")
│                 │  - Quick security scan: Grep changed files
│                 │    for secrets/passwords patterns
└────────┬────────┘
         │ Tests pass + no security hits
         ▼
┌─────────────────┐
│ 4. Commit       │  Git commit the change
│                 │  - Stage only the changed files
│                 │  - Commit with descriptive message
└────────┬────────┘
         ▼
┌─────────────────┐
│ 5. Log          │  Append a one-line session record
│                 │  to memory/progress.md
└─────────────────┘
```

## Rules

1. **Evidence required**: Must run tests and show actual output before claiming done (same Iron Rule as full workflow)
2. **Security scan**: Must Grep changed files for `password|secret|api_key|token` patterns — even quick fixes can leak secrets
3. **Auto-upgrade trigger**: If during execution the change exceeds 10 lines or requires new dependencies, STOP and tell the user: "This change is larger than expected. Recommend switching to new-feature workflow."
4. **No skipping tests**: If the project has no test command configured in TECH_STACK.md, warn the user and ask whether to proceed without tests
5. **Progress logging**: Append a single line to progress.md: `[YYYY-MM-DD HH:MM] quick-fix: <one-sentence description> (<files changed>)`

## What quick-fix skips (and why)

| Skipped step | Why it's safe to skip for small fixes |
|-------------|--------------------------------------|
| session-start full flow | No context restoration needed for a 5-minute fix |
| Engineering Foundation Gate | TECH_STACK.md only needed for test command; if missing, step 3 handles it |
| brainstorming hard gate | Scope is trivially clear (typo/one-line fix) |
| writing-plans / spec.md | No multi-task breakdown needed for a single edit |
| executing-plans / state.yaml | No iteration tracking needed |
| tdd Red-Green-Refactor | Small fixes can write test directly if needed; not mandatory for typo-level changes |
| verify 8-step full | Replaced by step 3 (test + security scan) |
| code-review | Trivial changes don't need design review; security scan in step 3 covers safety |
| session-end full flow | One-line progress log is sufficient |

## Failure Handling

| Failure Point | Handling |
|---------------|---------|
| Tests fail after fix | Re-examine the change; if can't fix quickly, upgrade to `bugfix` workflow |
| Security scan finds a hit | Resolve or document disposition before committing |
| Change exceeds 10 lines | Stop and recommend upgrading to `new-feature` |
| No test command configured | Warn user; ask whether to proceed without tests or configure TECH_STACK.md first |
