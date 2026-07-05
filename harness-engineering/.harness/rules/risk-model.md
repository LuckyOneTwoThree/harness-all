# Risk Model — Family-Wide Approval Contract

> Risk is determined by consequence and reversibility, not by line count or file count. This model does not grant authority beyond the user's task.

## Tiers

| Tier | Meaning | Default handling |
|---|---|---|
| R0 Inspect | Read-only inspection, analysis, local verification | Execute without additional approval |
| R1 Scoped Reversible | In-scope project edit or reversible staging action with clear verification | Execute when authorized by the task; report evidence |
| R2 Material Change | Dependency, public contract, schema, paid resource, external publication, or difficult rollback | Present impact/options and obtain explicit approval before mutation |
| R3 Critical/Production | Production mutation, destructive data action, secrets/auth/security control, irreversible migration | Explicit approval immediately before execution; rollback and blast radius required |
| Forbidden | Credential exfiltration, bypassing gates, destructive unscoped commands, unauthorized production access | Refuse regardless of tier |

## Escalation Signals

Escalate to at least R2 for:

- Public API or cross-framework contract changes
- Database/schema migrations
- New or upgraded runtime dependencies
- Spending money or provisioning paid resources
- Publishing externally or contacting third parties
- Authentication, authorization, privacy, payment, or compliance behavior

Escalate to R3 for:

- Any production mutation
- Destructive or irreversible data operation
- Secret rotation/access or security-control modification
- Emergency mitigation that bypasses the normal GitOps path

When uncertain, choose the higher tier and state why.

## Approval Record

For R2/R3, record:

- proposed action and tier
- affected environment/artifacts
- worst-case blast radius
- rollback or recovery plan
- verification evidence required
- approver and timestamp

R3 approval must be fresh for the concrete command/change; broad earlier approval is not sufficient if scope changed.

## Domain Examples

- PM: research is R0; approving experiment spend is R2.
- Design: local draft is R1; purchasing assets/tools is R2.
- Engineering: ordinary code edit is R1; dependency/API/schema/security change is R2 or R3.

