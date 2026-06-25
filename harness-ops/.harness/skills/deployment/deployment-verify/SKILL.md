---
name: deployment-verify
description: Deployment verification and health checks, running the four-part suite of health check, smoke test, metrics verification, and log inspection
operation_tier: inspect
requires_approval: false
---
# Deployment Verify — Deployment Verification and Health Check

## When to use
- When verifying after a deployment
- During health gate checks at each canary stage
- When verifying recovery after a rollback
- When the user requests "check if the deployment succeeded
- During the VERIFY stage of a LOOP

## Inputs
- loops/specs/<task-name>/spec.md
- docs/handoff/solo-to-ops.md
- docs/infrastructure/OPS_STRATEGY.md
- rules/security.md
- loops/LOOP.md

## Outputs
- loops/specs/<task-name>/evidence.md
- loops/specs/<task-name>/state.yaml
- loops/specs/<task-name>/iterations.log

## Ground Rules

1. **No claim of completion without evidence** — must show actual verification data, not "should be fine"
2. **All four parts are mandatory** — health check + smoke test + metrics verification + log inspection
3. **Guardrail metrics must be checked** — not only the main metrics, but also confirm no side effects
4. **Roll back immediately on verification failure** — do not gamble on "wait and see"

## Process

### 1. Health Check

Verify that Pods/services are running normally:

```bash
# K8s Pod status
kubectl get pods -n <namespace> -l app=<app-name>
# Expected: all Pods Running + Ready 1/1

# Readiness Probe
kubectl describe pod <pod-name> | grep -A 5 Readiness
# Expected: Ready state

# HTTP health endpoint
curl -f http://<service>:<port>/health
# Expected: HTTP 200 + normal response body

# Startup time check
kubectl get pods -o custom-columns=NAME:.metadata.name,AGE:.metadata.creationTimestamp
# Expected: new Pods started and stable for > 30 seconds
```

**Failure criteria**:
- Pod status not Running/Ready
- CrashLoopBackOff / ImagePullBackOff / OOMKilled
- HTTP health endpoint not 200
- Startup time < 30 seconds (may still be initializing)

### 2. Smoke Test

Read the smoke test checkpoints from `solo-to-ops.md` and execute each:

```
## Smoke Test Checklist (from solo-to-ops.md)
- [ ] /health endpoint returns 200
- [ ] /ready endpoint returns 200
- [ ] Core API [POST /api/orders] returns 200
- [ ] DB connection normal (query users table limit 1)
- [ ] Cache connection normal (Redis PING)
- [ ] Message queue connection normal (RabbitMQ queue.list)
```

**Execution method**:
- Agent executes via kubectl exec or curl
- Record the actual response for each item, mark ✓/✗
- Any failure means overall failure

### 3. Metrics Verification

Check whether monitoring metrics are stable after deployment:

```
## Monitoring Metrics Check (5-10 minutes after deployment)
### Error Rate
- 5 min before deployment: [X%]
- 5 min after deployment: [Y%]
- Verdict: Y ≤ X + 0.5% ✓ / Y > X + 1% ✗

### Latency
- p50 before: [Xms] / after: [Yms]
- p95 before: [Xms] / after: [Yms]
- p99 before: [Xms] / after: [Yms]
- Verdict: Y ≤ X * 1.2 ✓ / Y > X * 1.5 ✗

### Throughput
- Before: [X req/s]
- After: [Y req/s]
- Verdict: Y ≥ X * 0.9 ✓ / Y < X * 0.7 ✗

### Resource Usage
- CPU: [X%] (threshold 80%)
- Memory: [X%] (threshold 85%)
- Verdict: below threshold ✓
```

**Data source**: Prometheus queries (PromQL) / Grafana Dashboard / cloud provider monitoring

### 4. Log Inspection

Check whether logs show anomalies after deployment:

```
## Log Inspection
### Error Logs
kubectl logs -n <ns> -l app=<app> --since=10m | grep -E "ERROR|FATAL|Exception"
# Expected: no new ERRORs, or ERROR count no higher than before deployment

### Warning Logs
kubectl logs -n <ns> -l app=<app> --since=10m | grep -E "WARN"
# Expected: no abnormal growth

### Startup Logs
kubectl logs -n <ns> -l app=<app> --since=10m | grep -E "Started|Ready|Listening"
# Expected: see normal startup logs
```

### 5. Guardrail Metrics Check

Confirm the deployment did not affect other services:
- Downstream services depending on this service show no abnormal alerts
- Upstream services this service depends on show no connection anomalies
- No database connection pool leaks
- No message queue backlog

### 6. Generate Verification Report

```
## Deployment Verification Report
- Task: [task-name]
- Version: [v1.2.3]
- Environment: [staging/production]
- Verification time: [ISO 8601]

### Verification Results
| Check Item | Result | Details |
|--------|------|------|
| Health check | ✓/✗ | [details] |
| Smoke test | ✓/✗ | [passed/total] |
| Metrics verification | ✓/✗ | [metrics summary] |
| Log inspection | ✓/✗ | [error count] |
| Guardrail metrics | ✓/✗ | [details] |

### Conclusion
- Overall result: [pass/fail]
- Next step: [DONE / trigger rollback / continue observing]
```

Write to `loops/specs/<task>/evidence.md`.

### 7. Update Status

- Verification passed: `state.yaml` status=done, stage=verify
- Verification failed: `state.yaml` status=retrying, stage=verify, last_error=[details]
- Append to `iterations.log`: record this verification result

## Prohibitions

- Do not skip any check item (all four parts are mandatory)
- Do not use "looks fine" as a substitute for actual data
- Do not ignore guardrail metric anomalies
- Do not continue canary rollout after verification failure
- Do not tamper with verification results

## Relationship to LOOP

**LOOP type**: provision (VERIFY stage), incident (VERIFY stage)

This skill is the core executor of the LOOP VERIFY stage.
- provision LOOP: post-deployment verification; failure triggers rollback
- incident LOOP: post-recovery verification; failure continues troubleshooting

**stage field value**: verify

## Preconditions for Claiming "Done"

- [ ] Health check passed (Pod Running/Ready, HTTP 200)
- [ ] All smoke tests passed
- [ ] Monitoring metrics stable (error rate / latency / throughput)
- [ ] Logs show no abnormal ERRORs
- [ ] Guardrail metrics show no anomalies
- [ ] Verification report written to evidence.md
- [ ] state.yaml updated
