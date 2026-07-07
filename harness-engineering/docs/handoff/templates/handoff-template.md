---
schema_version: "1.0"
handoff_id: "<SOURCE-TARGET-YYYYMMDD-NNN>"
producer: "<source-framework>"
consumer: "<target-framework>"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
mode: family
ac_ids: []
batch:
  id: 1
  type: full
  added_acs: []
  modified_acs: []
  superseded_acs: []
  unchanged_acs: []
artifacts: []
---

# Handoff: <source framework> → <target framework>

> Generated at: YYYY-MM-DD HH:MM
> Source framework: <harness-pm / harness-engineering / ...>
> Target framework: <harness-pm / harness-engineering / ...>
>
> **Template selection**: this is the generic handoff template. For `engineering → pm` handoffs (produced by `session-end`), use `engineering-to-pm-template.md` instead — it includes the `Contract Deviations from PRD` section populated from `contract.json.deviations[]`, which this generic template does not.

## Phase Summary

<One-sentence summary of what was done in this phase>

## Deliverables List

| Deliverable | Path | Type | Notes |
|--------|------|------|------|
| PRD | docs/handoff/<source>-to-<target>.md (copy and rename) | Markdown | Product requirements document, including feature list and acceptance criteria |
| Persona | docs/product/persona.md | Markdown | Target user persona |
| Roadmap | docs/product/roadmap.md | Markdown | Feature priorities and iteration plan |

> Note: harness-pm produces this handoff document (with PRD content), not docs/product/PROJECT.md.
> The inbound handoff remains immutable. When it introduces new or conflicting product requirements, harness-engineering's brainstorming skill records only the resolved requirement boundaries in PROJECT.md; an already executable contract does not require a ceremonial rewrite.

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose tech stack X | Team familiarity + ecosystem maturity | Whole project |
| Skip feature Y | Not in MVP scope | Scope boundary |

## Acceptance Criteria (AC)

Testable conditions that downstream frameworks must satisfy when implementing:

- [ ] AC-F01-001: <stable testable description>
- [ ] AC-F01-002: <stable testable description>
- [ ] AC-F02-001: <stable testable description>

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

The downstream framework's session-start skill will auto-detect this file and read it.
If not auto-detected, you can manually point the Agent to this file path to read it.
