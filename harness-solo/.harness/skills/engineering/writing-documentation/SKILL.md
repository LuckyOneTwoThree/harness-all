---
name: writing-documentation
description: Documentation — ADR/API doc/CHANGELOG, document the why
triggers:
  - When making architectural decisions
  - When changing public APIs
  - On release
  - When the user asks to write documentation
reads:
  - constitution.md
  - rules/security.md
  - docs/product/PROJECT.md
  - docs/engineering/TECH_STACK.md
writes:
  - docs/decisions/ADR-NNN-*.md
  - docs/
---

# Writing Documentation — Documentation

## Iron Rule
**Document the *why*, not the *what*.** Code says "what was done"; documentation says "why it was done this way, what alternatives were considered, and what the constraints are".

## Document Types and Process

### 1. ADR (Architecture Decision Record) — Highest Value

**When to write**: when making architectural decisions (selection, pattern choice, major tradeoffs)

**Process**:
1. Create `ADR-NNN-<short-title>.md` under `docs/decisions/`
   - Numbering: use Glob to scan `docs/decisions/ADR-*` and take the max number +1
   - If the directory does not exist, create it with a tool (do not use `mkdir -p`)
2. Fill in the template:

```markdown
# ADR-NNN: <decision title>

## Status
PROPOSED | ACCEPTED | SUPERSEDED by ADR-XXX | DEPRECATED

## Date
YYYY-MM-DD

## Context
[Why is this decision needed? What problem are we facing?]

## Decision
[What is the decision?]

## Alternatives Considered
- Option A: [description] — why it was not chosen
- Option B: [description] — why it was not chosen

## Consequences
- Positive: [benefits]
- Negative: [costs]
- Risks: [points to watch]
```

3. **Do not delete old ADRs** — they record history; new decisions get new ADRs and the old ones are marked `SUPERSEDED by ADR-XXX`

### 2. API Documentation

**When to write**: when changing public APIs (adding/modifying/deprecating)

**Process**:
- Typed languages (TS/Go/Rust): type definitions are the docs; ensure types are complete (no `any`)
- Untyped languages (JS/Python): write docstrings including parameters, return values, exceptions
- REST API: maintain OpenAPI/Swagger spec files
- GraphQL: the schema is the doc; ensure there are descriptions

**Minimum required**:
```typescript
/**
 * Sort the Todo list by due date in ascending order
 * @param todos - array of Todos (does not mutate the original array)
 * @returns a new array, with those having a due date in ascending order first, and those without a due date at the end
 */
```

### 3. CHANGELOG

**When to write**: on release

**Format** (Keep a Changelog style):
```markdown
## [Unreleased]

## [1.2.0] - 2026-06-21
### Added
- Sort by due date feature (#12)
### Fixed
- Empty due date sorting exception (#15)
### Changed
- Refactored sorting logic into a standalone module (#16)
```

### 4. README

**Minimum required content**:
- One-sentence project introduction
- Quick Start (how to install, run, test)
- Common command list
- Architecture overview (pointing to docs/)

### 5. Code Comments

**Principles for writing comments**:
- Comment on **why** (why it's done this way), not **what** (the code already says what)
- Comment on non-obvious intent, constraints, pitfalls
- Delete commented-out code (git has history)
- TODOs must have a date and owner: `// TODO(2026-06-21): <description>`

**Anti-example** (forbidden):
```javascript
// Increment counter by 1   ← restates the code, delete it
counter++;
```

**Positive example** (keep):
```javascript
// Use || null to normalize empty strings, preventing localeCompare from sorting '' before normal dates
const normalized = deadline || null;
```

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "Code is self-documenting" | Code does not explain why or what alternatives were considered |
| "Wait until the API is stable to write docs" | Documentation is the first test of design; the longer you wait, the less stable the API |
| "ADR is too much hassle" | A 10-minute ADR avoids 2 hours of repeated arguments |
| "Comments restating code help understanding" | Comments that restate code are noise; comment on intent |
| "Old ADRs are outdated, delete them" | Old ADRs record history; new ADRs supersede the old ones |

## Prohibitions
- Comments that restate code (`// Increment counter by 1`)
- Leaving commented-out code (git has history; delete it)
- Leaving TODOs without a date or owner
- Deleting old ADRs (should be marked SUPERSEDED)
- APIs without types/docstrings (`any` everywhere)
- README without instructions on how to run the project

## Relationship with LOOP
This skill is usually triggered outside LOOP:
- Architectural decisions → the brainstorming phase triggers this skill to write an ADR
- API changes → the verify phase checks that docs are in sync
- Release → session-end or a standalone release flow triggers the CHANGELOG

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| writing-documentation | Documentation (ADR/API/CHANGELOG/README/comments) |
| brainstorming | The thinking process for architectural decisions (write the ADR after the decision is made) |
| verify | Check whether API changes are synced with docs |
| session-end | Trigger CHANGELOG update on release |
