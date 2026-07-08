# Execution Step Output Examples

> Extracted from SKILL.md. YAML output examples for each execution step of anomaly attribution analysis.

## Step 1.1: Alert Authenticity Confirmation - Output

```yaml
alert_validation:
  alert_id: ALT-001
  is_real: true | false
  confidence: 0.0-1.0
  validation_checks:
    - check: data_source_health
      passed: true | false
      detail: "Data source reporting normally, latest data point 2026-06-15T10:04:00Z"
    - check: threshold_config
      passed: true | false
      detail: "Threshold config meets SLA requirements"
  false_positive_reason: null | "Collection agent offline caused data gap triggering false alert"
```

## Step 1.3: 5 Why Deep Questioning - Output Format

```yaml
root_cause:
  why_chain:
    - question: "Why did the order service response time out?"
      answer: "Database connection pool exhausted"
      evidence: "Connection pool utilization 100%, active connections 50/50"
    - question: "Why was the database connection pool exhausted?"
      answer: "Slow queries held connections for too long"
      evidence: "Slow query log shows 3 SQL statements with execution time >5s, average connection hold 120s"
    - question: "Why did slow queries increase?"
      answer: "The new order query interface was not indexed"
      evidence: "EXPLAIN shows full table scan; the corresponding interface went live on 2026-06-14"
    # ... same structure extensible to 3-5 layers
  root_cause_summary: "The new order query interface lacked indexes, causing slow queries that exhausted the database connection pool and led to service timeout"
  root_cause_category: code_defect | resource_exhaustion | config_error | dependency_failure | traffic_anomaly
  confidence: 0.0-1.0
  evidence_list:
    - type: metric | log | trace | change_record
      content: "Connection pool utilization monitoring data"
      source: "APM system"
```

## Step 1.4: Candidate Root Cause Ranking - Output

```yaml
candidate_root_causes:
  - rank: 1
    summary: "Database connection pool exhausted"
    confidence: 0.85
    evidence_count: 5
    supporting_factors: ["Connection pool monitoring", "Slow query log"]
  - rank: 2
    summary: "Network jitter"
    confidence: 0.45
    evidence_count: 2
    supporting_factors: ["Network latency fluctuation"]
  needs_human_investigation: true | false
  investigation_hint: "Top 2 candidate confidence is close; recommend investigating the network layer"
```

## Step 2.1: Impact Dimension Assessment - Output

```yaml
impact_scope:
  level: critical | major | minor | negligible
  affected_users:
    count: 5000
    percentage: 15%
  affected_features:
    - feature_name: Order Creation
      availability: 95%
      impact_duration: 30m
  business_metrics:
    - metric: order_conversion_rate
      impact: -20%
      baseline: 5.2%
      current: 4.16%
      duration: 30m
  revenue_impact:
    estimated_loss: 50000
    currency: CNY
    confidence: 80%
    calculation_basis: "Historical average order volume × impact duration × average order value"
  reputation_impact:
    complaints: 12
    sentiment: negative
```

## Step 2.2: Impact Scope Dynamic Tracking - Output

```yaml
impact_trend:
  trend: expanding | stable | shrinking
  growth_rate_per_10min: 20%
  auto_escalation_triggered: true | false
  escalation_reason: "Affected user growth ≥ 20%/10 minutes, auto-escalate severity"
```

## Step 3.1: Immediate Remediation Actions - Output

```yaml
remediation:
  immediate_actions:
    - step: Scale database connection pool to 100
      command: kubectl scale deploy order-db --replicas=3 | Adjust connection pool config
      automated: true | false
      rollback_command: kubectl scale deploy order-db --replicas=1
      expected_effect: "Connection pool utilization drops below 60%"
      risk_level: low | medium | high
    - step: Add index for order query interface
      command: "CREATE INDEX idx_order_query ON orders(user_id, created_at)"
      automated: false
      rollback_command: "DROP INDEX idx_order_query ON orders"
      expected_effect: "Query execution time drops from 5s to 100ms"
      risk_level: low
  estimated_resolution_time: 30
```

## Step 3.2: Long-term Fix Plan - Output

```yaml
long_term_fixes:
  - description: Optimize connection pool config and slow query monitoring
    priority: P0 | P1 | P2 | P3
    effort: 8
    effort_unit: hours
    owner: To be assigned
    preventive: true | false
    action_items:
      - "Establish slow query auto-alert mechanism; auto-notify when execution time > 1s"
      - "Add SQL index check item to code review"
      - "Include connection pool config in capacity planning"
```

## Step 3.3: Human Escalation Decision - Output

```yaml
needs_human_escalation: true | false
escalation_reason: "Root cause candidates ≥ 3, need manual investigation to confirm"
escalation_target: "Backend team / DBA / SRE"
escalation_payload:
  - alert_id: ALT-001
  - top_candidates: ["Database connection pool exhausted", "Network jitter", "Slow dependency service"]
  - evidence_summary: "See attribution report for details"
```

## Step 4: Retrospective Suggestions - Output

```yaml
postmortem_suggestion:
  triggered: true | false
  trigger_condition: "Auto-triggered after P0 anomaly recovery"
  deadline: "Generate retrospective report within 24 hours"
  review_scope:
    - timeline_reconstruction: "Complete timeline of anomaly occurrence → detection → response → recovery"
    - root_cause_analysis: "5 Why chain and evidence review"
    - response_assessment: "Response timeliness, decision quality, communication efficiency"
    - prevention_measures: "Prevention plan for similar issues"
  action_items:
    - description: "Establish SQL change automated check pipeline"
      priority: P1
      deadline: 2026-07-01
```
