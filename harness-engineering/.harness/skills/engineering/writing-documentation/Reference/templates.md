# Writing Documentation — Templates & Examples

## 1. ADR (Architecture Decision Record) Template

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

## 2. API Documentation Example

**Minimum required** docstring:
```typescript
/**
 * Sort the Todo list by due date in ascending order
 * @param todos - array of Todos (does not mutate the original array)
 * @returns a new array, with those having a due date in ascending order first, and those without a due date at the end
 */
```

## 3. CHANGELOG Template

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

## 4. README Template

**Minimum required content**:
- One-sentence project introduction
- Quick Start (how to install, run, test)
- Common command list
- Architecture overview (pointing to docs/)

## 5. Code Comments Examples

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
