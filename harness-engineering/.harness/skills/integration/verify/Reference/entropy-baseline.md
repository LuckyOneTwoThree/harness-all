# Entropy Baseline — Reference

Schema for `.harness/memory/baseline.json` and the threshold logic used in Step 5 (Entropy Check) of the verify skill. Two execution paths are supported: an Agent-driven path using Glob/Read/Grep tools, and an optional bash script fallback.

## baseline.json Schema

The file is written by the session-end routine and read by the verify skill. It records the project's size and dependency footprint at the last known-good session boundary.

```json
{
  "version": 1,
  "captured_at": "YYYY-MM-DD HH:MM",
  "files": 142,
  "loc": 8200,
  "deps": 18,
  "todos": 4,
  "todos_breakdown": {
    "TODO": 3,
    "FIXME": 1
  },
  "notes": "optional free-form context"
}
```

### Field definitions

| Field | Type | Source | Description |
|-------|------|--------|-------------|
| `version` | number | fixed | Schema version. Current: `1`. Bump when the shape changes. |
| `captured_at` | string | session-end | Wall-clock time the baseline was written. Format `YYYY-MM-DD HH:MM`. |
| `files` | number | Glob | Count of source files in scope. Exclude `node_modules/`, `dist/`, `build/`, `.git/`. Include `*.ts` / `*.tsx` / `*.js` / `*.jsx` / `*.vue` / `*.svelte` / `*.py` / `*.go` / `*.rs` as relevant to the project. |
| `loc` | number | Read | Sum of non-blank lines across the files counted above. |
| `deps` | number | Read | Count of production dependencies declared in `package.json` (or the equivalent manifest). Exclude devDependencies. |
| `todos` | number | Grep | Count of `TODO` and `FIXME` occurrences across the source tree. |
| `todos_breakdown` | object | Grep | Optional split of `todos` by marker. |
| `notes` | string | session-end | Optional free-form context (e.g. `baseline taken after Q1 cleanup`). |

## Threshold Logic

For each metric, compute `growth = (current - baseline) / baseline`. Apply the rule below.

| Metric | WARN condition | FAIL condition |
|--------|----------------|----------------|
| `files` | growth > 20% AND absolute delta > 50 | (never auto-fail; surface for review) |
| `loc` | growth > 50% | (never auto-fail) |
| `deps` | more than 3 new | more than 6 new |
| `todos` | count > 20 OR growth > 50% over baseline | count > 50 |

**Notes on the thresholds**:
- `files` uses both a relative and an absolute gate — a 50% growth on a 4-file project is just 2 files and is not a real explosion; the `absolute > 50` clause prevents false alarms on small projects.
- `loc` growth > 50% usually signals over-implementation or generated code; investigate before delivery.
- `deps` is a hard FAIL above 6 new — dependency bloat compounds and is hard to reverse.
- `todos` is FAIL above 50 — at that density, the project is accumulating debt faster than it ships.

When WARN is triggered, evaluate whether to refactor before delivery. When FAIL is triggered, you must refactor or justify the exception in evidence.md before claiming completion.

## Method A — Agent-Driven Path (recommended, cross-platform)

This path uses only Agent tools and works on Windows, macOS, and Linux without any shell dependency.

1. **Read the baseline**: use Read to load `.harness/memory/baseline.json`. If the file is missing, write `skipped — no baseline.json present` in evidence and skip the rest of Method A.
2. **Count current files**: use Glob with the project's source glob (e.g. `src/**/*.ts`). Subtract `node_modules/`, `dist/`, `build/` via Glob's path filter. Compare to `baseline.files`.
3. **Sum current loc**: count non-blank lines across every file in the declared source scope using available read/shell tooling. If exact counting is unavailable, mark the entropy dimension unavailable and keep the prior baseline; extrapolation is not comparable evidence.
4. **Read current deps**: use Read to open `package.json` (or equivalent). Count entries under `dependencies`. Compare to `baseline.deps`.
5. **Count current TODO/FIXME**: use Grep with pattern `TODO|FIXME` against the source tree. Compare the count to `baseline.todos`.

Apply the threshold table above and record the dispositions in evidence.

## Method B — Optional Bash Script Fallback

If bash is available in the current environment, you may run:
```bash
bash .harness/scripts/entropy-check.sh
```

The script reads `baseline.json` and prints current-vs-baseline numbers plus WARN/FAIL dispositions. Its threshold logic must match the table above; if the script drifts, fix the script, not this document.

**On Windows or in environments without bash, you must use Method A.** Do not skip the entropy check just because bash is unavailable.

## When to skip the entropy check entirely

Skip only when **all** of the following hold:
- `baseline.json` does not exist (first session, or the session-end routine has not yet run).
- The change is a single-file edit with no new dependencies.
- The change adds fewer than 50 lines.

Record `skipped — <reason>` in evidence. Any other path requires a real entropy check, even on small projects — early checks are cheap; late discoveries are not.

## Updating the baseline

The verify skill does **not** update `baseline.json`. Updates are the responsibility of the session-end routine. If you detect that the baseline is stale (e.g. `captured_at` is more than 2 weeks old), note it in evidence and continue with the check — staleness does not invalidate the comparison, it just means a refresh is overdue.
