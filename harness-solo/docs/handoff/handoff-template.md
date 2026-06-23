# Handoff: <source framework> → <target framework>

> Generated at: YYYY-MM-DD HH:MM
> Source framework: <harness-pm / harness-design / harness-solo / ...>
> Target framework: <harness-solo / harness-growth / ...>

## Phase Summary

<One-sentence summary of what was done in this phase>

## Deliverables List

| Deliverable | Path | Type | Notes |
|--------|------|------|------|
| PRD | docs/handoff/<source>-to-<target>.md (copy and rename) | Markdown | Product requirements document, including feature list and acceptance criteria |
| Persona | docs/product/persona.md | Markdown | Target user persona |
| Roadmap | docs/product/roadmap.md | Markdown | Feature priorities and iteration plan |

> Note: harness-pm produces this handoff document (with PRD content), not docs/product/PROJECT.md.
> PROJECT.md is always maintained by harness-solo's brainstorming skill (written after extracting requirements from the handoff document).

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose tech stack X | Team familiarity + ecosystem maturity | Whole project |
| Skip feature Y | Not in MVP scope | Scope boundary |

## Acceptance Criteria (AC)

Testable conditions that downstream frameworks must satisfy when implementing:

- [ ] AC-001: <testable description>
- [ ] AC-002: <testable description>
- [ ] AC-003: <testable description>

## Open Items

Issues for downstream frameworks to handle or confirm with upstream:

- TBD 1: <issue description>
- TBD 2: <issue description>

## Suggested Next Steps

Downstream frameworks should prioritize:

1. <task 1>
2. <task 2>
3. <task 3>

## Risk Notes

| Risk | Level | Mitigation |
|------|------|---------|
| Technical risk X | High/Medium/Low | <action> |
| Dependency risk Y | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

The downstream framework's brainstorming skill will auto-detect this file and read it.
If not auto-detected, you can manually point the Agent to this file path to read it.
