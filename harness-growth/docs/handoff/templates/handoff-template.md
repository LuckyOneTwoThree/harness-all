---
schema_version: "1.0"
handoff_id: "<SOURCE-TARGET-YYYYMMDD-NNN>"
producer: "<source-framework>"
consumer: "<target-framework>"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
ac_ids: []
artifacts: []
---

# Handoff: <source framework> → <target framework>

> Generated at: YYYY-MM-DD HH:MM
> Source framework: <harness-pm / harness-design / harness-solo / harness-growth / ...>
> Target framework: <harness-pm / harness-solo / harness-growth / ...>

## Phase Summary

<One-sentence summary of what was done in this phase>

## Deliverables List

| Deliverable | Path | Type | Notes |
|--------|------|------|------|
| Growth report | docs/handoff/<source>-to-<target>.md (copy and rename) | Markdown | Growth data feedback, including experiment conclusions and user insights |
| Experiment records | docs/experiment/G-001-xxx.md | Markdown | Experiment design and results |
| Content assets | docs/content/xxx.md | Markdown | Published content |

## Key Decisions

| Decision | Rationale | Impact scope |
|------|------|---------|
| Scale up experiment X | Conversion rate increased 15%, statistically significant | Roll out site-wide |
| Stop channel Y | ROI < 1, no improvement for 3 consecutive months | Reallocate resources |

## Acceptance Criteria (AC)

Conditions to confirm when downstream frameworks use this handoff document:

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
| Growth risk X | High/Medium/Low | <action> |
| Dependency risk Y | High/Medium/Low | <action> |

---

## Downstream Framework Usage Notes

The downstream framework's session-start skill will auto-detect this file and read it.
If not auto-detected, you can manually point the Agent to this file path to read it.
