# Security Scan Patterns — Reference

Catalog of every Grep regex and Read-based check used in Step 4 (Security Scan) of the verify skill. Use these verbatim; do not paraphrase the regex.

## How to scope the scan

Run every check below against the **files changed in this change** only (the `git diff` of the current iteration). Do not scan the entire repository — that produces noise and slows the verify step. Scope the Grep `path` parameter to the changed files, or pass the `glob` filter to limit the search.

If you cannot enumerate the changed files, fall back to scanning `src/` and `*.config.*` (most leakage lives there).

## Pattern 1 — Secret Leakage

Detects API keys, tokens, and inline credentials embedded in source files.

**Regex** (Grep, case-insensitive recommended for the keyword prefix):
```
(sk-|api[_-]?key|secret|password|token|AKIA|ghp_)[=:]\s*['"]?[A-Za-z0-9+/=_-]{16,}
```

**What it catches**:
- `sk-...` OpenAI keys
- `AKIA...` AWS access key IDs
- `ghp_...` GitHub personal access tokens
- `api_key=ABC123...`, `api-key: ABC123...` style assignments
- `secret="..."`, `password="..."`, `token=...` assignments with 16+ char values

**Hit policy**: every hit is a leakage candidate. Treat as a fail until you confirm the value is not a real credential.

**Common false positives**:
- `token` as a JWT field name in a TS interface (`token: string`) — the value side has no 16+ char string, so the regex does not match; if a sample value like `token: "abcdef0123456789abcdef"` appears in a fixture, it matches but is benign. Whitelist fixture paths (e.g. `__fixtures__/`, `*.test.ts`) before escalating.
- `password` in a migration column definition (`password: string`) — no value, no match. If a default like `password: "changeme12345678"` is in a seed file, that is a real finding, not a false positive.
- `sk-` inside a Slack channel name in docs — usually shorter than 16 chars and obviously not a credential; verify by length.
- Values that are obviously placeholders (`xxxxxxxxxxxx`, `REPLACE_ME`, `<your-key>`) — confirm via the character class; pure `x` runs match the regex but are placeholders. Document the placeholder in evidence rather than escalating as a leak.
- AWS SDK examples that print `AKIAEXAMPLEKEY` for documentation — these typically appear in `*.md` files; whitelist `docs/` if your project policy permits.

**Escalation rule**: if you cannot prove a hit is a placeholder or fixture, treat it as a real leak and fail the verify step.

## Pattern 2 — Hardcoded Credentials and Connection Strings

Detects private key headers and inline database/cache connection URIs with embedded credentials.

**Regex**:
```
BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY|mongodb://|postgres://|redis://.*:.*@
```

**What it catches**:
- PEM-formatted private key blocks (RSA, EC, OPENSSH, or untyped)
- MongoDB / PostgreSQL connection strings with credentials inline
- Redis URIs with username:password before the host

**Hit policy**: private key blocks are always a fail — no project ships a real private key in source. Connection strings are a fail unless the credentials are clearly environment-injected placeholders.

**Common false positives**:
- A `-----BEGIN OPENSSH PRIVATE KEY-----` line inside a markdown doc explaining key formats — content match only; check the file extension and `docs/` whitelist before escalating.
- `mongodb://localhost:27017` with no `:.*@` segment — does not match the second alternative; safe.
- `postgres://user:pass@localhost` inside an integration test that uses a disposable local DB — the credentials are local-only, but you should still move them to env vars. Treat as WARN, not fail.
- `redis://.*:.*@` matching `redis://:password@host` — that is a real finding (no username, password present); do not dismiss it.

## Pattern 3 — Dangerous Shell Commands

Detects destructive shell pipelines that are common in copy-pasted install scripts.

**Regex**:
```
rm -rf|curl.*\|.*sh|wget.*\|.*sh
```

**What it catches**:
- `rm -rf` invocations (anywhere, including scripts and docs)
- `curl ... | sh` and `curl ... | bash` remote-pipe-to-shell patterns
- `wget ... | sh` variants

**Hit policy**: every hit requires human review. `rm -rf` against well-scoped paths (e.g. `rm -rf node_modules`) is acceptable in scripts; `rm -rf /` or `rm -rf $HOME` is an immediate fail.

**Common false positives**:
- `rm -rf` in a Makefile or package.json `clean` script targeting `dist/` or `node_modules/` — safe, document in evidence.
- `curl ... | sh` quoted in a markdown tutorial as something **not** to do — check whether the doc shows the command as recommended practice or anti-pattern.
- Test fixtures that include the literal string `rm -rf` inside a quoted test case — usually matches but is test data, not execution.
- `curl ... | sh` inside a Dockerfile that pins a version and uses a checksum — review the checksum; if absent, fail.

## Pattern 4 — .gitignore Coverage (Read-based, not regex)

Use Read to read `.gitignore` at the repository root and confirm the following entries are present (directly or via a parent glob):

- `.env` and `.env.*` (but not `.env.example`)
- `node_modules/`
- `dist/` or `build/` (whichever the project emits)
- Any project-specific secret paths (e.g. `*.pem`, `*.key`, `.coverage`)

**Hit policy**: a missing entry is a WARN, not a fail, unless a corresponding file with real content exists in the working tree — then it is a fail.

**Common false positives**:
- A monorepo where the root `.gitignore` delegates to package-level `.gitignore` files — read both before reporting a miss.
- `.env.example` matching `.env*` and being ignored — that is a bug; example files should be committed. Whitelist `.env.example` explicitly with a `!.env.example` line.
- `dist/` not present because the project does not emit one — confirm the build output path before reporting a miss.

## Method B — Optional Bash Script Fallback

If bash is available in the current environment, you may run:
```bash
bash .harness/scripts/security-check.sh
```

The script encodes the same patterns as Method A above. On Windows or in environments without bash, you must use Method A (Agent-driven Grep/Read).

Do not treat Method B as a substitute for understanding the patterns — if the script reports a hit, you still need to read the matched file and apply the false-positive rules above before failing the verify step.

## Reporting Format

For each pattern scanned, record in evidence.md:
- The pattern identifier (e.g. `Pattern 1 — Secret Leakage`)
- The set of files actually scanned (or the scoping rule applied)
- The raw hits, if any, with file path and line number
- Your disposition per hit: `real finding` / `documented false positive` / `whitelisted`

Do not write only "security scan passed". The Iron Rule requires the actual output.
