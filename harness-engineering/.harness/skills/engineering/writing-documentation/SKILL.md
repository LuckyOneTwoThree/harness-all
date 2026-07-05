---
name: writing-documentation
description: Documentation — ADR/API doc/CHANGELOG, document the why
---
# Writing Documentation — Documentation

## When to use
- When making architectural decisions
- When changing public APIs
- On release
- When the user asks to write documentation

## Inputs
- constitution.md
- rules/security.md
- docs/product/PROJECT.md
- docs/engineering/TECH_STACK.md

## Outputs
- docs/decisions/ADR-NNN-*.md
- docs/

## Iron Rule
**Document the *why*, not the *what*.** Code says "what was done"; documentation says "why it was done this way, what alternatives were considered, and what the constraints are".

## Document Types and Process

### 1. ADR (Architecture Decision Record) — Highest Value
**When to write**: when making architectural decisions (selection, pattern choice, major tradeoffs)

**Process**:
1. Create `ADR-NNN-<short-title>.md` under `docs/decisions/`
   - Numbering: use Glob to scan `docs/decisions/ADR-*` and take the max number +1
   - If the directory does not exist, create it with a tool (do not use `mkdir -p`)
2. Fill in the template — For complete templates and examples, see `Reference/templates.md`
3. **Do not delete old ADRs** — they record history; new decisions get new ADRs and the old ones are marked `SUPERSEDED by ADR-XXX`

### 2. API Documentation
**When to write**: when changing public APIs (adding/modifying/deprecating)

**Process**:
- Typed languages (TS/Go/Rust): type definitions are the docs; ensure types are complete (no `any`)
- Untyped languages (JS/Python): write docstrings including parameters, return values, exceptions
- REST API: maintain OpenAPI/Swagger spec files
- GraphQL: the schema is the doc; ensure there are descriptions

For complete templates and examples, see `Reference/templates.md`

### 3. CHANGELOG
**When to write**: on release

For complete templates and examples, see `Reference/templates.md`

### 4. README
For complete templates and examples, see `Reference/templates.md`

### 5. Code Comments
**Principles for writing comments**:
- Comment on **why** (why it's done this way), not **what** (the code already says what)
- Comment on non-obvious intent, constraints, pitfalls
- Delete commented-out code (git has history)
- TODOs must have a date and owner: `// TODO(2026-06-21): <description>`

For complete templates and examples, see `Reference/templates.md`

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "Code is self-documenting" | Code does not explain why or what alternatives were considered |
| "Wait until the API is stable to write docs" | Documentation is the first test of design; the longer you wait, the less stable the API |
| "ADR is too much hassle" | A 10-minute ADR avoids 2 hours of repeated arguments |
| "Comments restating code help understanding" | Comments that restate code are noise; comment on intent |
| "Old ADRs are outdated, delete them" | Old ADRs record history; new ADRs supersede the old ones |

## Prohibited
- Comments that restate code (`// Increment counter by 1`)
- Leaving commented-out code (git has history; delete it)
- Leaving TODOs without a date or owner
- Deleting old ADRs (should be marked SUPERSEDED)
- APIs without types/docstrings (`any` everywhere)
- README without instructions on how to run the project

## Relationship with LOOP

Usually triggered outside LOOP: brainstorming triggers ADR writing, verify checks API doc sync, session-end triggers CHANGELOG. See `.harness/loops/LOOP.md`.

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| session-end | Trigger CHANGELOG update on release |
