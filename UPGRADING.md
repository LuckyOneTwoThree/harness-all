# Safe Framework Upgrades

The upgrade tool updates framework-managed rules and skills while preserving project-owned state and documents.

```powershell
./scripts/upgrade.ps1 -Framework harness-solo -TargetProject D:/path/to/project -Mode Check
./scripts/upgrade.ps1 -Framework harness-solo -TargetProject D:/path/to/project -Mode DryRun
./scripts/upgrade.ps1 -Framework harness-solo -TargetProject D:/path/to/project -Mode Apply
```

Safety properties:

- Never deletes target files.
- Never overwrites `SOUL.md`, `constitution.md`, `docs/**`, runtime memory, FEATURES, or LOOP task state.
- Never overwrites a managed file changed since the recorded baseline.
- Blocks legacy conflicts when no trusted lock baseline exists.
- Backs up every updated managed file under `.harness/upgrade-backups/<timestamp>/`.
- Writes `.harness/harness.lock.json` only after a conflict-free apply.

For a freshly installed project, run `Apply` once to create the initial lock; files already identical to the source remain untouched.
