---
schema_version: "1.0"
handoff_id: "DESIGN-PM-YYYYMMDD-NNN"
producer: "harness-design"
consumer: "harness-pm"
created_at: "YYYY-MM-DDTHH:MM:SSZ"
source_revision: "<design revision or commit>"
supersedes: null
status: "draft"
ac_ids: []
artifacts: []
---
# Design Feedback to Product

## Phase Summary

<What design activity produced this feedback and why PM action is needed.>

## Feedback Items

| Feedback ID | Affected AC IDs | Observation | Evidence artifact | Recommendation | Product impact | Requested PM decision |
|---|---|---|---|---|---|---|
| DFB-001 | AC-F01-001 | <finding> | artifacts/evidence/<file> | <change/clarify/retain> | <scope/metric/user impact> | <accept/reject/defer> |

## Constraints Preserved

<Business intent or acceptance behavior that must remain true regardless of the PM decision.>

## Open Questions

- <Question with owner and needed-by date, or None>

## Consumer Actions

Harness-pm validates this package, records an accept/reject/defer decision for every feedback ID, and publishes any approved PRD change as a new PRD revision and downstream handoff. Design feedback never edits PRD directly.

## Risks if Deferred

| Risk | Likelihood | Impact | Review point |
|---|---|---|---|
| <risk> | <L/M/H> | <impact> | <date/milestone> |
