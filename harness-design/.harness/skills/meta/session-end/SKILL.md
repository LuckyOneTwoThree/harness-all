---
name: session-end
description: Wraps the design session, records evidence, archives progress, and publishes validated handoffs when needed.
---
# Session End

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

Prefer `design-handoff-spec`; session-end may publish only when that skill was not run and approved engineering-consumable design exists. Use `docs/handoff/design-to-solo-template.md` and include the framework-neutral component contract.

Hard checks:

- review evidence passed;
- all stable AC/DAC IDs are unique and preserve upstream IDs;
- envelope `ac_ids` exactly equals IDs in the body;
- component-contract.json validates and contains no engineering binding;
- package contains every referenced design artifact and token with hashes;
- family-mode frontend status becomes ready only after these checks pass.

### Design to PM

Publish `design-to-pm.md` using `docs/handoff/design-to-pm-template.md` when design discovers a product-scope conflict, ambiguous business rule, infeasible requirement, user-flow gap, or evidence that should change the PRD.

Each feedback item has a stable `feedback_id`, affected AC IDs, evidence, recommendation, impact, and requested PM decision. This is feedback, not authority to rewrite the PRD.

### Publication

For either route:

1. Allocate a handoff ID and create draft contract.
2. Build `docs/handoff/packages/<handoff_id>/{manifest.json,contract.md,artifacts/...}` with package-relative paths.
3. Validate envelope, manifest, hashes, consumer, stable IDs, and body/envelope parity.
4. Archive the previous current pointer unchanged.
5. Publish the current pointer and package with `status: ready`.
6. Record ID, package path, and superseded ID in progress.md.

Never append a second delivery body and never ask consumers to resolve producer-local paths.

## Prohibitions

- Publishing unreviewed design as ready.
- Renumbering AC/DAC IDs or requiring continuous sequences.
- Prescribing framework-specific component types/names.
- Deleting feedback or handoff history after consumption.
- Ending without progress and baseline updates.

## Evidence Requirements

Record the archive result and, for each handoff, its ID, consumer, artifact count, manifest hash, validation result, and current-pointer/archive actions.
