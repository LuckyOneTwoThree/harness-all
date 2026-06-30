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
