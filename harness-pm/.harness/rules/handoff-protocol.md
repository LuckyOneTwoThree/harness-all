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
- **Forward vs Reverse semantics**: see family-level HANDOFF_PROTOCOL.md (in the harness-all repo root; absent in standalone PM install) "Forward vs Reverse batch semantics" for the distinction between forward delivery (modified_acs = new replacement IDs) and reverse feedback (modified_acs = same AC IDs with changed content)
- Legacy handoffs without a `batch` field: consumers fall back to set-diff detection on `ac_ids`

## Consumer Gate

Run `pwsh -File .harness/scripts/validate-handoff.ps1 -Package <package-path> -ExpectedConsumer <this-framework>` (or Windows PowerShell) and require exit code 0 before semantic review. **Agent-tool fallback** (per constitution Principle 2): when PowerShell is unavailable, the Agent may perform the equivalent checks below using Read/Glob/Grep — manifest SHA-256 verification uses a hash tool if available, otherwise the check is downgraded to structural + path + ID-parity validation only and the consumption receipt records `hash_verification: skipped-no-powershell`.

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
