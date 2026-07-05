# quality-acceptance — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Output

**Storage path**: `docs/monitoring/release-notes.md ("Acceptance Report" section)`

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | P0 acceptance results | Core conclusion + minimum viable artifact, only outputs P0 case pass/fail results and gate decision |
| standard | Full acceptance report (current default) | Full artifact, includes all Step 1-2 outputs |
| deep | Full report + extended analysis | Full artifact + regression test matrix + performance baseline comparison + security audit checklist + decision record + risk assessment |

**Output files**:

| File | Format | Description |
|------|------|------|
| acceptance-report.md | Markdown | Complete acceptance test report (includes acceptance execution plan and sign-off confirmation) |
| acceptance-report.json | JSON | Structured data |

## Output Schema

Full schema and validation rules are inline in the parent SKILL.md's "Output Schema" section (acceptance report structure with verdict, per-AC results, evidence pointers, and reviewer sign-off).

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Acceptance criteria change | Check items and methods | Regenerate affected check items, retain passed historical records |
| Test case change | Automated acceptance check items | Update related acceptance check items, mark for human confirmation |
| PRD requirement change | Acceptance coverage | Re-assess acceptance coverage, mark for human confirmation |
| Code change | Acceptance execution plan | Regenerate affected acceptance execution plan |
| Security requirement change | Security acceptance items | Update security acceptance items, re-assess security risk |

When acceptance results themselves change, the downstream notification mechanism:

| Acceptance Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Gate result change | release-orchestrator | Mark gate change, trigger release decision update |
| P0/P1 check failure | change-impact-analysis | Mark failed items, trigger impact assessment |
| Manual verification items needed | release-orchestrator | Mark pending verification items, trigger manual acceptance flow |
| P0/P1 failure | release-orchestrator | Mark blocking items, block release flow |
| Sign-off status change | release-orchestrator | Mark sign-off status, trigger release decision |

---
