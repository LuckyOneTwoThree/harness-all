---
name: monitoring-attribution
description: Used when attribution analysis is needed for monitoring anomalies. Anomaly attribution analysis tool responsible for root cause localization, impact scope assessment, and remediation suggestions. Keywords: anomaly attribution, root cause analysis, impact assessment, remediation suggestions.
metadata:
  module: "Product Monitoring & Iteration"
  sub-module: "Monitoring & Alerting"
  type: "pipeline"
  version: "2.0"
  domain_tags: ["Internet", "Software", "General"]
  interaction_mode: "ai_auto"
  trigger_examples:
    - "Alert root cause analysis"
    - "Anomaly attribution localization"
    - "Metric drop cause investigation"
    - "Impact scope assessment"
execution_depth:
  default: standard
  quick_description: "Only output root cause summary and immediate remediation actions"
  deep_description: "Full attribution + 5 Why deep chain + impact quantification + long-term fix plan + retrospective suggestions"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/monitoring/monitoring-config.md
  - docs/monitoring/release-notes.md
  - docs/metrics/metrics-system.md
writes:
  - docs/monitoring/monitoring-config.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# Anomaly Attribution Analysis 🤖

## Core Principles

1. **Alert attribution is a reasoning chain, not a guess**: From confirming authenticity to localizing scope to correlating events to generating attribution, every step must be supported by evidence
2. **Correlation analysis is key to attribution**: Looking at alerts in isolation inevitably leads to misjudgment; other events within the time window must be correlated
3. **Root cause localization must be traceable**: Every layer of the 5 Why questioning chain must be supported by evidence and data; no steps can be skipped
4. **Impact assessment must be quantitative, not qualitative**: Affected user count, loss amount, and feature availability must provide measurable values
5. **Remediation suggestions must be actionable**: Every suggestion must include specific operation steps, commands, and rollback plans

## Basic Information

- **Skill type**: pipeline
- **Module**: Product Monitoring & Iteration / Monitoring & Alerting
- **Version**: 2.0
- **Interaction mode**: 🤖 AI auto-execution (analysis type)
- **Upstream Skill**: monitoring-alert-detection (anomaly detection outputs alert events, classification, and correlation analysis)
- **Downstream Skills**: user-feedback-loop-report (feedback loop report consumes attribution results and impact scope), iteration-backlog-grooming (backlog grooming consumes remediation suggestions for priority adjustment)

> **Module Independence Note**: This Skill has cohesive, complete anomaly attribution analysis logic (root cause localization, impact assessment, remediation suggestions) and no longer delegates cross-module to pm-06 analysis-anomaly, eliminating cross-module dependencies.

## Interaction Mode

🤖 AI auto-execution (analysis type)

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Anomaly alert events | JSON | Yes | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Alert event list output by monitoring alert detection, containing alert_id, timestamp, classification |
| Alert classification | object | Yes | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Alert layer, category, and confidence |
| Correlation analysis | object | Yes | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Correlation type, related alerts, and correlation score |
| Release info | object | ○ | docs/monitoring/release-notes.md ("Canary Plan" section) | Recent release records, used for change correlation attribution |
| Config change records | object | ○ | User-provided | Configuration modification history, used for config change attribution |
| Traffic change data | object | ○ | User-provided | Traffic trends and anomaly fluctuations, used for traffic anomaly attribution |
| Root cause knowledge base | object[] | ○ | docs/monitoring/monitoring-config.md ("Alert Rules" section) | Historical problem-root cause mappings, used for case matching |
| Product architecture | JSON/file | ○ | User-provided | System architecture diagram, component relationships, dependency chains, used for dependency topology tracing |
| Metrics system | JSON | ○ | docs/metrics/metrics-system.md | Business metric definitions, used for impact assessment |

## Execution Steps

### Step 1: Root Cause Localization [Core]

**Goal**: Based on alert events and correlation analysis, localize the root cause of the anomaly and output a traceable reasoning chain

#### 1.1 Alert Authenticity Confirmation [Core]

**Confirmation Methods**:
- Verify whether the alert data source is reporting normally (rule out collection failure)
- Verify whether the threshold config is reasonable (rule out misconfiguration)
- Verify whether the metric calculation logic is correct (rule out calculation errors)
- Cross-validate consistency across multiple data sources

**Output**:

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

#### 1.2 Root Cause Pattern Matching [Core]

**Analysis Methods**:
- Common root cause pattern matching based on alert type
- Time-series analysis based on change events (triggered after release/config change)
- Upstream tracing based on dependency topology
- Historical case matching based on knowledge base

**Root Cause Pattern Library**:

| Alert Category | Common Root Cause Patterns | Investigation Priority |
|----------|------------|-----------|
| Resource saturation | Insufficient capacity/Connection pool exhaustion/Memory leak | P0 |
| Response timeout | Slow dependency service/Network jitter/Lock contention | P0 |
| Error rate increase | Code defect/Config error/Dependency failure | P0 |
| Business metric drop | Conversion chain break/Payment channel failure/Feature unavailable | P0 |
| Traffic anomaly | Crawler/Volume manipulation/Marketing campaign/External attack | P1 |

**Knowledge Base Matching Rules**:
- Similarity ≥ 0.85: Directly output historical solution, label confidence
- Similarity 0.6-0.85: Output historical solution, label "applicability needs human confirmation"
- Similarity < 0.6 or no historical cases: Proceed to 5 Why logical reasoning

#### 1.3 5 Why Deep Questioning [Deep]

**Analysis Method**: Ask "why" layer by layer; each layer's answer must be supported by evidence until the root cause is reached

**5 Why Output Format**:

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

#### 1.4 Candidate Root Cause Ranking [Conditional]

**When multiple candidate root causes exist**:

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

### Step 2: Impact Assessment [Core]

**Goal**: Quantify the impact scope of the anomaly on users, features, business, and revenue

#### 2.1 Impact Dimension Assessment [Core]

**Assessment Dimensions**:

| Dimension | Metric | Data Source |
|------|------|----------|
| User impact | Affected user count/percentage | Monitoring metrics + user behavior logs |
| Feature impact | Core feature availability | Service health checks + business metrics |
| Business impact | Conversion rate/Order volume loss | Business metrics vs. baseline |
| Revenue impact | Estimated GMV loss | Business data + historical average |
| Reputation impact | Complaint count/Sentiment | Customer service system + sentiment monitoring |

**Output**:

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

#### 2.2 Impact Scope Dynamic Tracking [Conditional]

**When the impact scope continues to expand**:

```yaml
impact_trend:
  trend: expanding | stable | shrinking
  growth_rate_per_10min: 20%
  auto_escalation_triggered: true | false
  escalation_reason: "Affected user growth ≥ 20%/10 minutes, auto-escalate severity"
```

### Step 3: Remediation Suggestions [Core]

**Goal**: Based on root cause and impact, output actionable immediate fixes and long-term improvement plans

#### 3.1 Immediate Remediation Actions [Core]

**Suggestion Types**:

| Root Cause Type | Suggestion Template | Execution Timing |
|----------|----------|----------|
| Insufficient resources | Scaling/Resource adjustment plan | Immediate |
| Code issue | Rollback/Hotfix plan | Immediate |
| Config error | Config correction steps | Immediate |
| Dependency failure | Switch/Degradation plan | Immediate |
| Traffic anomaly | Rate limiting/Circuit breaker config | Immediate |

**Output**:

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

#### 3.2 Long-term Fix Plan [Deep]

**Output**:

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

#### 3.3 Human Escalation Decision [Conditional]

**Output**:

```yaml
needs_human_escalation: true | false
escalation_reason: "Root cause candidates ≥ 3, need manual investigation to confirm"
escalation_target: "Backend team / DBA / SRE"
escalation_payload:
  - alert_id: ALT-001
  - top_candidates: ["Database connection pool exhausted", "Network jitter", "Slow dependency service"]
  - evidence_summary: "See attribution report for details"
```

### Step 4: Retrospective Suggestions [Deep]

**Goal**: After P0 anomaly recovery, output retrospective process and improvement suggestions

**Output**:

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

## Output

**Output File Path**: `docs/monitoring/monitoring-config.md ("Attribution Model" section)`

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Root cause summary + immediate remediation actions | Core conclusions + minimum viable artifact, only outputs root cause summary and immediate remediation steps |
| standard | Full attribution analysis (current default) | Full artifact, including all Step 1-3 outputs |
| deep | Full attribution + deep reasoning + retrospective suggestions | Full artifact + 5 Why deep chain + long-term fix plan + retrospective process |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["alert_id", "root_cause", "impact_scope", "remediation"],
  "properties": {
    "alert_id": {"type": "string", "description": "Alert ID, linked to monitoring-alert-detection output"},
    "timestamp": {"type": "string", "description": "Attribution analysis time"},
    "alert_validation": {"type": "object", "description": "Alert authenticity confirmation, including is_real/confidence/validation_checks"},
    "root_cause": {"type": "object", "description": "Root cause analysis, including 5 Why chain, summary, category, and confidence"},
    "candidate_root_causes": {"type": "array", "description": "Candidate root cause ranking list, output when root cause is uncertain"},
    "impact_scope": {"type": "object", "description": "Impact scope, including level, affected users, features, and business metrics"},
    "impact_trend": {"type": "object", "description": "Impact trend, including trend direction and growth rate"},
    "remediation": {"type": "object", "description": "Remediation suggestions, including immediate action list and estimated resolution time"},
    "long_term_fixes": {"type": "array", "description": "Long-term fix plan list"},
    "needs_human_escalation": {"type": "boolean", "description": "Whether human escalation is needed"},
    "postmortem_suggestion": {"type": "object", "description": "Retrospective suggestions, including trigger condition, scope, and action items"},
    "report_id": {"type": "string", "description": "Attribution report unique identifier"},
    "generated_at": {"type": "string", "description": "Generation time"}
  }
}
```

```
├── monitoring-attribution.json
├── monitoring-attribution.md
├── anomaly/
│   ├── ALT-001/
│   │   ├── alert_validation.md
│   │   ├── root_cause.md
│   │   ├── impact_assessment.md
│   │   ├── remediation.md
│   │   └── needs_human_escalation.yaml
│   └── attribution_summary.md
└── postmortem/
    └── ALT-001/
        └── postmortem_report.md
```

## Decision Rules

| Scenario | Decision Rule |
|------|----------|
| Alert authenticity in doubt (data source anomaly) | Mark as suspected false positive, pause attribution, notify human for confirmation |
| Root cause uncertain (candidate causes ≥ 3) | Mark for manual investigation, output Top 3 candidate causes and confidence |
| Knowledge base hit (similarity ≥ 0.85) | Output historical solution, label confidence |
| Knowledge base hit (similarity 0.6-0.85) | Output historical solution, label "applicability needs human confirmation" |
| No historical cases | Output 5 Why questioning chain, await feedback |
| Impact scope expanding (affected user growth ≥ 20%/10 minutes) | Auto-escalate severity by 1 level (up to P0), trigger immediate remediation |
| Impact scope expanding (affected user growth 5%-20%/10 minutes) | Auto-escalate severity by 1 level |
| After P0 anomaly recovery | Auto-trigger retrospective process, generate retrospective report within 24 hours |
| Root cause involves code defect | Prioritize rollback suggestion, then hotfix |
| Root cause involves config error | Prioritize config rollback suggestion, label rollback command |
| Root cause involves dependency failure | Suggest degradation/circuit breaker plan, label impact scope |
| Root cause involves traffic anomaly | Suggest rate limiting/scaling plan, label rate limit threshold |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Every alert event has a root cause analysis conclusion
- [ ] Root cause analysis is supported by evidence (not pure speculation)
- [ ] Impact scope is quantified (affected user count, feature availability)

### P1 Checks (must pass for standard/deep)

- [ ] Remediation suggestions are actionable (each suggestion has specific steps and commands)
- [ ] Immediate remediation actions have rollback plans
- [ ] Impact assessment covers 5 dimensions (users/features/business/revenue/reputation)
- [ ] Root cause confidence is labeled

### P2 Checks (only deep must pass)

- [ ] Root cause localization accuracy ≥ 80%
- [ ] 5 Why chain is complete (3-5 layers)
- [ ] MTTR reduction target met
- [ ] Long-term fix plan has priority and effort estimate
- [ ] Retrospective suggestions generated (P0 anomaly scenarios)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Anomaly alert events | Ask user to describe anomaly phenomena (symptoms/time/service/scope), attribute based on description | Attribution based on description, lacks structured alert data |
| Alert classification | AI infers classification based on anomaly phenomena, label "classification pending confirmation" | Classification is inferred, confidence reduced |
| Correlation analysis | Skip correlation analysis, label "cannot exclude correlation factors" in attribution | Isolated attribution, may misjudge |
| Release info | Skip change correlation attribution, label "cannot exclude change factors" | Attribution results excluding change correlation |
| Config change records | Skip config change correlation, label "cannot exclude config change factors" | Attribution results excluding config correlation |
| Traffic change data | Skip traffic analysis dimension, label traffic data missing in impact assessment | Analysis results missing traffic dimension |
| Root cause knowledge base | 5 Why analysis relies entirely on logical reasoning, cannot provide historical reference solutions | Pure reasoning attribution results, no historical case reference |
| Product architecture | Skip dependency topology tracing, label "topology tracing unavailable" | Root cause analysis missing topology dimension |
| Metrics system | Impact assessment uses user-provided key business metrics, label "metrics system pending supplementation" | Impact assessment dimensions incomplete |

### Data Acquisition Notes

When upstream files are missing, obtain necessary data through the following methods:

1. **Anomaly alert events missing**: Ask user to describe anomaly phenomena, including: symptom manifestations, occurrence time, affected services/features, impact scope (user count/feature points); AI will perform attribution analysis based on the description
2. **Context data missing** (release/config change/traffic change): AI will explicitly mark factors that cannot be excluded in attribution analysis, recommending manual investigation of these dimensions
3. **Root cause knowledge base missing**: AI will rely entirely on 5 Why logical reasoning for attribution, label "no historical case reference" in output, and recommend human verification of attribution conclusions
4. **Product architecture missing**: Ask user to provide service component list or dependency relationships; AI will perform topology tracing based on limited information, label tracing results for human confirmation

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| alert_id | string | Yes | Alert ID, must be consistent with monitoring-alert-detection output |
| root_cause | object | Yes | Root cause analysis, must contain 5_whys and conclusion |
| root_cause.5_whys | array | Yes | 5 Why chain, 3-5 layers, each layer must contain question/answer/evidence |
| root_cause.root_cause_summary | string | Yes | Root cause summary |
| root_cause.confidence | number | Yes | Confidence, 0.0-1.0 |
| impact_scope | object | Yes | Impact assessment, must contain affected_users/affected_features |
| impact_scope.level | string | Yes | Impact level, only critical/major/minor/negligible allowed |
| remediation | object | Yes | Remediation suggestions, must contain immediate_actions/estimated_resolution_time |
| remediation.immediate_actions | array | Yes | Immediate action list, each item must contain step/command/rollback_command |
| needs_human_escalation | boolean | Yes | Whether human escalation is needed |
| long_term_fixes | array | No | Long-term fix plan, each item must contain description/priority |
| postmortem_suggestion | object | No | Retrospective suggestions, must contain triggered/action_items |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| monitoring-alert-detection | Alert event update | Root cause analysis input | Re-perform attribution analysis |
| monitoring-alert-detection | Alert classification change | Root cause pattern matching | Update root cause matching patterns |
| release-gradual | Release record update | Change correlation attribution | Update correlation events and attribution |
| Root cause knowledge base | Historical case update | Root cause matching and suggestions | Update reference case library |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| monitoring-orchestrator | Attribution analysis complete | Output file update | Attribution completion status and key conclusions |
| user-feedback-loop-report | Anomaly impact scope confirmed | Write to output file | Anomaly events and user impact scope |
| iteration-backlog-grooming | P0 anomaly triggers remediation | Write to output file | Root cause and remediation suggestions |
