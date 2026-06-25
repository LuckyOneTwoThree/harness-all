---
name: incident-mitigation
description: Incident mitigation and stop-the-bleeding, executing whitelisted operations to quickly recover services (rollback / scale-out / restart / degrade)
operation_tier: mutate-staging
requires_approval: true
---
# Incident Mitigation — Incident Stop-the-Bleeding and Mitigation

## When to use
- When a P0/P1 incident requires emergency stop-the-bleeding
- After incident-detection completes severity classification
- When the user requests "emergency service recovery
- When monitoring alerts indicate service unavailable

## Inputs
- loops/specs/<incident-id>/spec.md
- loops/specs/<incident-id>/state.yaml
- docs/handoff/solo-to-ops.md
- memory/knowledge-base.md
- rules/security.md
- loops/LOOP.md

## Outputs
- loops/specs/<incident-id>/state.yaml
- loops/specs/<incident-id>/evidence.md
- loops/specs/<incident-id>/iterations.log
- memory/knowledge-base.md

## Ground Rules

1. **Stop the bleeding before root cause** — recover the service first, then analyze the cause
2. **Whitelisted operations only** — only execute safe operations (rollback / scale-out / restart / degrade), no destructive operations
3. **Production requires human confirmation** — P0 stop-the-bleeding measures must be verbally confirmed by humans before execution
4. **Must verify after stop-the-bleeding** — confirm service recovery, not just "executed"
5. **Record all operations** — the entire stop-the-bleeding process is recorded for post-mortem

## Process

### 1. Assess Stop-the-Bleeding Options

Read `spec.md` to understand the incident phenomenon, combine with `knowledge-base.md` historical experience, and assess available stop-the-bleeding options:

| Method | Applicable Scenario | Time | Risk |
|---------|---------|------|------|
| **Rollback** | Incident caused by new version | 1-5 minutes | Low (back to known-good version) |
| **Scale out** | Traffic spike / insufficient resources | 2-10 minutes | Low (cost increase) |
| **Restart** | Memory leak / deadlock | 1-3 minutes | Medium (brief interruption) |
| **Degrade** | Dependency service failure | Instant | Medium (limited functionality) |
| **Circuit break** | Prevent cascading failure | Instant | Medium (affects downstream) |
| **Rate limit** | Protect backend | Instant | Medium (rejects some requests) |

### 2. Select Stop-the-Bleeding Strategy

**Priority**: Rollback > Scale out > Restart > Degrade > Circuit break > Rate limit

**Decision tree**:
```
Is the incident caused by a recent deployment?
  → Yes: Roll back to the previous version
  → No: Continue

Are resources insufficient (CPU / memory / connections)?
  → Yes: Scale out
  → No: Continue

Is it a single-instance anomaly (others normal)?
  → Yes: Restart the abnormal instance
  → No: Continue

Is a dependency service failing?
  → Yes: Degrade (return cache / default values)
  → No: Rate limit protection + wait for root cause analysis
```

### 3. Execute Stop-the-Bleeding (by environment tier)

#### Rollback (invoke the rollback skill)
- staging: Agent executes directly
- production: Agent generates a GitOps revert PR + human confirmation
- Emergency: Agent recommends, after human verbal confirmation execute `kubectl rollout undo`

#### Scale out
```bash
# HPA manual scale-out
kubectl autoscale deployment <app> --min=5 --max=20 --cpu-percent=70

# Or directly modify replica count
kubectl scale deployment <app> --replicas=10
```
- staging: Agent executes directly
- production: Agent recommends, after human confirmation execute

#### Restart
```bash
# Restart abnormal Pod
kubectl delete pod <pod-name> -n <namespace>

# Or rolling restart the entire Deployment
kubectl rollout restart deployment <app> -n <namespace>
```
- staging: Agent executes directly
- production: Agent recommends, after human confirmation execute

#### Degrade
Modify config to enable degradation mode:
```yaml
# ConfigMap modification
degradation:
  enabled: true
  fallback: cache  # return cached data
  features_disabled: [recommendation, search]  # disable non-core features
```
- Modify via GitOps PR
- Emergency: Agent directly patches ConfigMap + restart

### 4. Verify Stop-the-Bleeding Effect

Invoke the `deployment-verify` skill:
- Error rate dropped to normal levels ✓
- Latency returned to normal ✓
- Business metrics recovered ✓
- Alerts cleared ✓

### 5. Record the Stop-the-Bleeding Process

```
## Stop-the-Bleeding Record
- Incident ID: [INC-xxx]
- Method: [rollback / scale out / restart / degrade]
- Execution time: [ISO 8601]
- Environment: [staging/production]
- Approval method: [Agent auto / human confirmation]
- Verification result: [recovered / partially recovered / not recovered]
- Recovery duration: [from stop-the-bleeding decision to service recovery]
- Next action: [root cause analysis / observe / fix]
```

Append to `iterations.log`.

### 6. Decide Next Step

- **Stop-the-bleeding succeeded**: enter `root-cause-analysis` to dig into the root cause
- **Partially recovered**: continue stop-the-bleeding (try other options) or escalate
- **Stop-the-bleeding failed**: escalate to P0, request emergency human intervention

## Prohibitions

- Do not execute destructive operations (delete namespace / drop table / rm -rf)
- Do not run kubectl delete directly in production (unless emergency and human confirmed)
- Do not claim "recovered" without verification
- Do not fix bugs while stop-the-bleeding (recover first, fix later)
- Do not conceal stop-the-bleeding failure (must escalate and notify)

## Relationship to LOOP

**LOOP type**: incident (PROVISION stage)

```
LOOP(incident):
  PLAN(detect) → PROVISION(mitigate) → VERIFY
    ↓ not recovered
  DEBUG(root-cause) → back to PROVISION (new stop-the-bleeding plan)
```

**stage field value**: provision

## Operation Whitelist

Safe operations the Agent can execute (auto on staging, requires confirmation on production):

| Operation | Command | Risk |
|------|------|------|
| Rollback | `kubectl rollout undo` | Low |
| Scale out | `kubectl scale` / `kubectl autoscale` | Low |
| Restart Pod | `kubectl delete pod` / `kubectl rollout restart` | Medium |
| Degrade | Modify ConfigMap (GitOps PR) | Medium |
| Rate limit | Modify Envoy/Istio rules | Medium |

**Prohibited operations** (require human approval in any environment):
- `kubectl delete namespace`
- `kubectl delete deployment` (non-rolling update)
- `terraform destroy`
- `DROP TABLE` / `DELETE FROM` (without WHERE)
- Modify RBAC / NetworkPolicy
