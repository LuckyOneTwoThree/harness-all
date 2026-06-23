---
name: dependency-management
description: Dependency Management — add/upgrade/audit, integrated with the constitution's dependency approval gate
triggers:
  - Before adding a new dependency (mandatory)
  - When upgrading dependencies
  - During security audits
  - When the verify stage checks dependency compliance
reads:
  - rules/security.md
  - constitution.md
  - docs/engineering/TECH_STACK.md
writes:
  - loops/specs/<feature>/iterations.log
  - memory/knowledge-base.md
---

# Dependency Management — Dependency Management

## Iron Rule
**Code is a liability.** Every dependency added expands the attack surface and maintenance cost. If it can be solved with under 50 lines of code, do not introduce a dependency.

## Adding a Dependency

### 1. Necessity Assessment (hard gate)
Answer the following questions. If any item is not satisfied → do not introduce:

- [ ] **Is it really needed?** Can it be replaced with under 50 lines of code or existing primitives?
- [ ] **Is it actively maintained?** Most recent commit < 6 months, with ongoing maintenance
- [ ] **Download volume?** Enough users to validate it (avoid tyquat / abandoned-package risk)
- [ ] **Known CVEs?** `npm audit` / `pip-audit` shows no critical/high vulnerabilities
- [ ] **Constitution compliance?** Check the dependency principles in `constitution.md` (e.g. for zero-runtime-dependency projects, reject outright)

### 2. Security Review
- **postinstall scripts**: Check whether the package has `postinstall` / `preinstall` (arbitrary code execution risk)
- **typosquat check**: Is the package name highly similar to a well-known package (`cross-env` vs `crossenv`)
- **Dependency tree depth**: Are there too many transitive dependencies (attack surface bloat)
- **License compatibility**: Check whether the license is compatible with the project (GPL / AGPL need special attention)

### 3. User Confirmation (mandatory)
- Explain to the user: package name, purpose, alternative considerations, security review results
- **Wait for explicit user authorization**; do not install on your own
- If the user rejects → return to step 1 to find alternatives

### 4. Integration Verification
- Install the dependency
- **Write a test case that uses the dependency** and confirm it passes
- Run the full test suite to confirm no regressions
- Record it in the dependency list of `docs/engineering/TECH_STACK.md`

## Upgrading Dependencies

### 1. Before Upgrade
- Run the full test suite and confirm everything is green (establish a baseline)
- Read the CHANGELOG / Migration Guide and identify breaking changes
- Major version upgrades (e.g. v3→v4) go through the migration skill separately

### 2. Upgrade
- Upgrade only one dependency at a time (multiple upgrades make issue attribution impossible)
- Lock files must be committed (`package-lock.json` / `yarn.lock` / `pnpm-lock.yaml`)
- CI uses `npm ci` instead of `npm install` (reproducible builds, prevents version drift)

### 3. After Upgrade
- Run the full test suite and compare against the baseline
- On failure → roll back or fix (go through systematic-debugging)
- All green → record in iterations.log

## Security Audit

### 1. Run the Audit
```bash
# Node
npm audit
# Python
pip-audit
```
Show the full output; do not just write "audit passed".

### 2. Triage (do not fix every red, do not ignore every red)
Triage by "reachability + severity":

| Severity | Production-reachable | dev-only |
|--------|---------|----------|
| critical/high | Fix immediately | Fix ASAP, non-blocking |
| moderate | Fix in next release | Fix with regular updates |
| low | Fix with regular updates | Can be ignored |

### 3. Deferred Fix Record
For vulnerabilities that cannot be fixed immediately, record them in `memory/knowledge-base.md`:
```
## Technical Decisions
| Date | Decision/Root Cause | Reason | Alternative |
|------|------|------|---------|
| YYYY-MM-DD | Deferred fix for CVE-XXXX (<package name>) | dev-only and unreachable, review date: YYYY-MM-DD | Upgrade to vX.Y |
```

## Anti-Rationalization Table

| Excuse | Rebuttal |
|------|------|
| "As long as it works" | Working ≠ secure; dependencies are an attack surface |
| "It's just a small package" | Small packages can also have malicious postinstall |
| "Committing the lockfile is too much hassle" | Not committing = non-reproducible builds = hidden risk |
| "Just `--force` past the audit red" | Ignoring ≠ resolving; follow the triage strategy |
| "Upgrade later" | The longer you wait, the more breaking changes accumulate |

## Prohibitions
- Adding a dependency without review (violates security.md dependency review)
- Not committing the lockfile (non-reproducible builds)
- Using `npm install` instead of `npm ci` in CI (version drift)
- Using `--force` to ignore audit red (masks the problem)
- Upgrading multiple dependencies at once (cannot attribute issues)
- Installing dependencies via `curl | sh` (violates the security red line)

## Relationship with LOOP
This skill is usually triggered outside LOOP (adding/upgrading/auditing are independent operations):
- New feature development needs a new dependency → brainstorming triggers this skill → continue LOOP after approval
- The verify stage checks dependency compliance → as a sub-item of verify

## Division of Labor with Other Skills
| Skill | Responsibility |
|-------|------|
| dependency-management | Gatekeeping the add/upgrade/audit process for dependencies |
| brainstorming | Evaluating whether a new dependency is really needed (first gate of necessity) |
| verify | Dependency compliance check as a verification sub-item |
| migration | Major version upgrades (v3→v4) go through the migration flow |
