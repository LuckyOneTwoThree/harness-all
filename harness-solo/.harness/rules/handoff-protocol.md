# Handoff Consumption Protocol

This installed rule is the executable companion to the family-level `HANDOFF_PROTOCOL.md`.

## Producer

1. Allocate immutable `<SOURCE>-<TARGET>-<YYYYMMDD>-<NNN>` ID.
2. Write one contract with `status: draft`.
3. Build `docs/handoff/packages/<handoff_id>/` containing:
   - `manifest.json`
   - `contract.md`
   - every referenced file under `artifacts/`
4. Use only package-relative paths. Record SHA-256 and byte size for every artifact.
5. Validate the manifest, contract envelope, body IDs, and hashes.
6. Archive the old current pointer unchanged; publish the new contract/package as `ready`.
7. Never delete or overwrite history.

## Batch Field (incremental handoffs)

When a subsequent handoff supersedes a previously produced one, the envelope MUST carry a `batch` field:

- `batch.type`: `full` (first-time delivery) or `incremental` (subsequent deliveries)
- `batch.id`: increment from previous delivery (1 for first-time, N+1 for subsequent)
- `batch.added_acs` / `batch.modified_acs` / `batch.superseded_acs` / `batch.unchanged_acs`: AC ID lists partitioning the change scope
- `ac_ids` MUST be the FULL SET of valid AC IDs (= `added_acs` + `modified_acs` + `unchanged_acs`); superseded AC IDs do NOT appear in `ac_ids`
- Body uses a `Change` column with `[added]`/`[unchanged]`/`[modified]`/`[superseded]` tags
- **Forward vs Reverse semantics**: see family-level HANDOFF_PROTOCOL.md "Forward vs Reverse batch semantics" for the distinction between forward delivery (modified_acs = new replacement IDs) and reverse feedback (modified_acs = same AC IDs with changed content)
- Legacy handoffs without a `batch` field: consumers fall back to set-diff detection on `ac_ids`

## Consumer Gate

Run `pwsh -File .harness/scripts/validate-handoff.ps1 -Package <package-path> -ExpectedConsumer <this-framework>` (or Windows PowerShell) and require exit code 0 before semantic review.

Before using a handoff, verify all of the following:

- exactly one YAML envelope;
- supported `schema_version`;
- `status: ready`;
- `consumer` equals this framework;
- `handoff_id`, producer, consumer, source revision, and artifact list match the manifest;
- all paths stay inside the package (no absolute path or `..`);
- every artifact exists and its SHA-256/size match;
- envelope `ac_ids` exactly equals unique AC/DAC IDs in the body;
- if `supersedes` is present, this ID is newer than the last consumed ID;
- any domain-specific routing gate passes.

On failure, do not consume partially. Report the exact failed check and keep the last valid handoff active.

After successful consumption, write `docs/handoff/receipts/<handoff_id>-receipt.json` with consumer, consumed_at, manifest_sha256, status (`accepted` or `rejected`), and reasons. Never edit the producer contract.

## Standalone Mode (no upstream handoff)

When harness-solo operates without an upstream PM/Design handoff (single-framework use, independent developer), the envelope/batch/manifest/receipt pipeline is **not exercised**. session-start detects this condition and short-circuits the handoff validation path:

**Detection criteria** (all must be true):
1. No `docs/handoff/packages/pm-to-solo-*` current pointer exists, AND
2. No `docs/handoff/packages/design-to-solo-*` current pointer exists, AND
3. No prior receipt records exist in `docs/handoff/receipts/` for inbound PM/Design handoffs.

**Behavior when standalone**:
- Skip envelope/batch/manifest schema validation (validate-handoff.ps1 not invoked)
- Skip receipt writing (no inbound handoff to acknowledge)
- Skip Cross-package AC traceability check (no design handoff to compare)
- Skip AC Change Impact Analysis (1a — no `batch` field, no superseded handoff)
- Proceed directly to Plan stage; `ac_change` field is NOT written to state.yaml

**Transition to family mode**: if a `pm-to-solo.md` or `design-to-solo.md` pointer is later published (PM or Design joins the workflow), the next session-start detects the pointer, exits standalone mode, and runs the full Consumer Gate from that point forward. Already-completed standalone tasks retain their state.yaml without `ac_change`.

This mode exists because forcing single-framework users through cross-framework envelope/batch/manifest validation is pure overhead — those fields are never populated and the validation paths always short-circuit at runtime, but the cognitive load of "did I configure handoff correctly?" remains. Standalone mode makes the skip explicit and documented.
