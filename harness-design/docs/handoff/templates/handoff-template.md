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
> Source framework: <harness-pm / harness-design / harness-solo / ...>
> Target framework: <harness-design / harness-solo / ...>

## Phase Summary

<One-sentence summary of what was done in this phase>

## Deliverables List

| Deliverable | Path | Type | Notes |
|--------|------|------|------|
| Design system | docs/design-system/DESIGN.md | Markdown | Color / typography / spacing / shadow / radius / breakpoints |
| Component contract | docs/handoff/component-contract.json | JSON | Semantic component contract (design-owned, framework-neutral) |
| UI specs | docs/ui/<page>.md | Markdown | Page-level UI design specs (A1: visual+interaction merged into ui) |

> Note: harness-pm produces this handoff document (with design requirements content), not docs/visual/DESIGN_BRIEF.md.
> DESIGN_BRIEF.md is always maintained by harness-design's design-brief skill (written after extracting requirements from the handoff document).

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Choose design style X | Brand positioning + user preference | Whole project |
| Skip feature Y | Not in MVP scope | Scope boundary |

## Acceptance Criteria (AC)

Verifiable conditions that downstream frameworks must satisfy when implementing:

- [ ] AC-F01-001: <stable verifiable description>
- [ ] AC-F01-002: <stable verifiable description>
- [ ] AC-F02-001: <stable verifiable description>

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
| Design risk X | High/Medium/Low | <action> |
| Dependency risk Y | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

The downstream framework's session-start skill will auto-detect this file and read it.
If not auto-detected, you can manually point the Agent to this file path to read it.
