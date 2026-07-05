---
schema_version: "1.0"
handoff_id: "DESIGN-PM-YYYYMMDD-NNN"
producer: "harness-design"
consumer: "harness-pm"
created_at: "<ISO-8601>"
source_revision: "<design revision or commit>"
supersedes: null
status: "draft"
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
# Design Feedback to Product

## Phase Summary

<What design activity produced this feedback and why PM action is needed.>

## Feedback Items

| Feedback ID | Affected AC IDs | Observation | Evidence artifact | Recommendation | Product impact | Requested PM decision | Change |
|---|---|---|---|---|---|---|---|
| DFB-001 | AC-F01-001 | <finding> | artifacts/evidence/<file> | <change/clarify/retain> | <scope/metric/user impact> | <accept/reject/defer> | [added] |

> **Batch delivery rule** (when `batch.type: incremental`):
> - `ac_ids` envelope field MUST contain ALL valid AC IDs referenced by feedback items (unchanged + added + modified), never just the new feedback subset — this prevents feedback loss if a previous design-to-pm was never consumed.
> - The `Change` column marks each feedback item: `[added]` (new in this batch), `[unchanged]` (carried forward, prior decision still pending), `[modified]` (finding refined), `[superseded]` (finding withdrawn or replaced).
> - PM's batch-aware detection uses `batch.added_acs` as primary signal for new feedback; `batch.superseded_acs` marks feedback already decided (PM should NOT re-triage it).

## Constraints Preserved

<Business intent or acceptance behavior that must remain true regardless of the PM decision.>

## Open Questions

- <Question with owner and needed-by date, or None>

## Consumer Actions

Harness-pm validates this package, records an accept/reject/defer decision for every feedback ID, and publishes any approved PRD change as a new PRD revision and downstream handoff. Design feedback never edits PRD directly.

## Suggested Next Steps

harness-pm should prioritize:
1. Triage each Feedback ID (accept/reject/defer) in prd-orchestrator phase 0 Branch A (design feedback triage)
2. For accepted items, update the authoritative PRD only through a new approved revision and stable-ID rules
3. For design-scope implications (e.g., component contract changes needed), route to harness-design via `pm-to-design.md` (published by PM session-end)
4. Re-sync updated PRD back to harness-design via `pm-to-design.md` if scope changes affect design contracts

## Risks if Deferred

| Risk | Likelihood | Impact | Review point |
|---|---|---|---|
| <risk> | <L/M/H> | <impact> | <date/milestone> |

---

## Downstream Framework Usage Notes

harness-pm's session-start skill will auto-detect this file and route accepted consumption to prd-orchestrator phase 0 Branch A (design feedback triage). When the envelope contains a `batch` field, PM applies batch-aware detection to identify new vs superseded feedback items.
If not auto-detected, you can manually point the Agent to this file path to read it.
