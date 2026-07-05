---
name: session-end
description: Wraps the design session, records evidence, archives progress, and publishes validated handoffs when needed.
---
# Session End

## When to use

- Design session wrapping up (archive progress, sync FEATURES.md, publish design-to-solo / design-to-pm handoffs when downstream delivery is ready).
- Run only after verify + design-review have passed for the active task(s).

## Inputs

- `.harness/memory/progress.md`
- `.harness/loops/specs/*/state.yaml`
- `.harness/FEATURES.md`
- approved design outputs and review evidence

## Outputs

- updated progress, baseline, archive, and task board
- optional ready design-to-solo package
- optional ready design-to-pm feedback package

## Process

1. Complete the current progress block with outcomes, evidence, pending work, decisions, and exploration-mode history.
2. Update FEATURES.md from state files; do not infer done without pass evidence.
3. Write `.harness/memory/baseline.json` with timestamp, file count, document LOC, task count, and TODO count.
4. If progress.md exceeds 200 lines, preserve the latest complete session and archive older complete sessions unchanged.
5. Promote durable design decisions or pitfalls to knowledge-base.md.

## Outbound Handoffs

Only harness-design writes its outbound contracts. Apply `.harness/rules/handoff-protocol.md` and `.harness/rules/acceptance-id-protocol.md` to every publication.

### Design to Solo

Prefer `design-handoff-spec`; session-end may publish only when that skill was not run and approved engineering-consumable design exists. Use `docs/handoff/templates/design-to-solo-template.md` and include the framework-neutral component contract.

Hard checks:

- review evidence passed;
- all stable AC/DAC IDs are unique and preserve upstream IDs;
- envelope `ac_ids` exactly equals IDs in the body;
- component-contract.json validates and contains no engineering binding;
- package contains every referenced design artifact and token with hashes;
- family-mode frontend status becomes ready only after these checks pass.

**Batch field population** (when supersedes a previous design-to-solo):

- `batch.type: full` for first-time design delivery; `batch.type: incremental` for any subsequent delivery (design-iteration, design-handoff re-run, etc.)
- `batch.id`: incrementing counter — previous design-to-solo batch.id + 1 (first delivery = 1)
- `batch.added_acs`: new DAC-xxx IDs introduced in this delivery
- `batch.modified_acs`: new DAC-xxx IDs that replace old ones (old IDs go to `superseded_acs`)
- `batch.superseded_acs`: old DAC-xxx IDs replaced or withdrawn (NOT in `ac_ids`)
- `batch.unchanged_acs`: all valid AC-xxx + DAC-xxx IDs carried forward from previous delivery
- `ac_ids` MUST be the full set = `added_acs` + `modified_acs` (new IDs) + `unchanged_acs`
- Body AC/DAC tables use a `Change` column with `[added]`/`[unchanged]`/`[modified]`/`[superseded]` tags

### Design to PM

Publish `design-to-pm.md` using `docs/handoff/templates/design-to-pm-template.md` when design discovers a product-scope conflict, ambiguous business rule, infeasible requirement, user-flow gap, or evidence that should change the PRD.

Each feedback item has a stable `feedback_id`, affected AC IDs, evidence, recommendation, impact, and requested PM decision. This is feedback, not authority to rewrite the PRD.

**Batch field population** (when supersedes a previous design-to-pm):

> **Reverse feedback semantics**: Design→PM is a reverse feedback channel — design does NOT own ACs (PM does). Therefore `modified_acs` means "same AC ID, feedback content changed" (NOT "new replacement AC ID"). This differs from forward delivery channels (PM→Solo, Design→Solo) where `modified_acs` contains new replacement IDs. See HANDOFF_PROTOCOL.md "Forward vs Reverse batch semantics".

- `batch.type: full` for first-time design-to-pm feedback; `batch.type: incremental` for any subsequent feedback delivery
- `batch.id`: incrementing counter — previous design-to-pm batch.id + 1 (first feedback = 1)
- `batch.added_acs`: AC IDs newly referenced by feedback items introduced in this delivery (PM-owned ACs that design is newly commenting on)
- `batch.modified_acs`: AC IDs whose feedback content has changed (same AC ID; the finding itself was refined — re-triage needed)
- `batch.superseded_acs`: AC IDs whose feedback has been withdrawn or replaced (PM should skip re-triage; these AC IDs do NOT appear in `ac_ids`)
- `batch.unchanged_acs`: AC IDs whose prior feedback is carried forward unchanged
- `ac_ids` MUST be the full set = `added_acs` + `modified_acs` + `unchanged_acs`. Superseded AC IDs do NOT appear in `ac_ids` — they are no longer active feedback. (The AC itself may still be valid in PM's PRD; superseded here means "design's feedback about this AC is withdrawn", not "the AC is retired".)
- Body Feedback Items table uses a `Change` column with `[added]`/`[unchanged]`/`[modified]`/`[superseded]` tags

> **Routing visibility**: PM session-start 5a applies batch-aware detection (first-consumption guard / incremental / full fallback / body cross-check) to identify new vs superseded feedback, then routes accepted consumption to prd-orchestrator phase 0 Branch A (design feedback triage). This closes the loop so design-side feedback is never silently dropped.

### Publication

For either route:

1. Allocate a handoff ID and create draft contract.
2. Build `docs/handoff/packages/<handoff_id>/{manifest.json,contract.md,artifacts/...}` with package-relative paths.
3. Validate envelope, manifest, hashes, consumer, stable IDs, and body/envelope parity.
4. Archive the previous current pointer unchanged.
5. Publish the current pointer and package with `status: ready`.
6. Record ID, package path, and superseded ID in progress.md.

Never append a second delivery body and never ask consumers to resolve producer-local paths.

## Prohibited

- Publishing unreviewed design as ready.
- Renumbering AC/DAC IDs or requiring continuous sequences.
- Prescribing framework-specific component types/names.
- Deleting feedback or handoff history after consumption.
- Ending without progress and baseline updates.

## Evidence Requirements

Record the archive result and, for each handoff, its ID, consumer, artifact count, manifest hash, validation result, and current-pointer/archive actions.
