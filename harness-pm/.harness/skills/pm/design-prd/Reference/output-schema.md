# PRD Generator Output Schema Reference

> This document is split from design-prd SKILL.md, containing the complete output data structure definition, quality report format, and human review checklist template for the PRD generator.

### 8.1 PRD Document Output

**Format**: Markdown
**File naming**: `PRD-{product_name}-{requirement_id}-{version}.md`
**Storage path**: `docs/product/PRD.md`
**Output file**: prd.md

**Output template**:
```markdown
# {PRD Title}

| Field | Value |
|------|-----|
| Document ID | PRDS-{YYYYMM}-{sequence} |
| Version | v{major_version}.{minor_version} |
| Status | {status} |
| Author | {author} |
| Created At | {timestamp} |

## Table of Contents
1. [Meta Information](#1-meta-information)
2. [Background & Objectives](#2-background-objectives)
3. [Solution Design](#3-solution-design)
...
```

### 8.2 Quality Gate Check Report

**Format**: JSON
**File naming**: `{PRD-ID}_quality_report_{timestamp}.json`

**Output validation rules**:

| Field Path | Type | Required | Description |
|----------|------|------|------|
| prd_id | string | Yes | PRD unique identifier |
| metadata | object | Yes | Meta information |
| metadata.product_name | string | Yes | Product name |
| metadata.version | string | Yes | Version number |
| metadata.created_at | string | Yes | Creation time (ISO8601) |
| sections | array | Yes | PRD section list |
| sections[].section_id | string | Yes | Section identifier |
| sections[].title | string | Yes | Section title |
| sections[].content | string | Yes | Section content |
| sections[].confidence | number | Yes | Section confidence (0-1.0) |
| functional_requirements | array | Yes | Functional requirements list |
| functional_requirements[].req_id | string | Yes | Requirement identifier |
| functional_requirements[].title | string | Yes | Requirement title |
| functional_requirements[].priority | enum(P0,P1,P2) | Yes | Priority |
| quality_gates | array | Yes | Quality gates |

**Report structure**:
```json
{
  "prd_id": "string",
  "check_timestamp": "ISO8601",
  "gate_results": {
    "gate1_completeness": {
      "status": "passed|failed|warning",
      "score": "number",
      "issues": [
        {
          "section": "string",
          "field": "string",
          "severity": "blocking|warning",
          "message": "string"
        }
      ]
    },
    "gate2_consistency": {
      "status": "passed|failed|warning",
      "score": "number",
      "traceability_chain": "intact|broken",
      "issues": []
    },
    "gate3_ambiguity": {
      "status": "passed|failed|warning",
      "auto_fixed": ["string"],
      "human_review_required": [
        {
          "location": "string",
          "question": "string",
          "options": ["string"]
        }
      ]
    },
    "gate4_traceability": {
      "status": "passed|failed|warning",
      "trace_coverage": "number%",
      "missing_traces": []
    }
  },
  "overall_status": "passed|failed|pending_human_review",
  "next_action": "string"
}
```

### 8.3 Human Review Required Checklist

**Format**: Markdown
**File naming**: `{PRD-ID}_human_review_required.md`

**Output content**:
```markdown
# Human Review Required Checklist

Generated at: {timestamp}
PRD version: v{version}

## Ambiguity Clarification Questions

| # | Location | Question | Options |
|---|------|------|------|
| 1 | Section.X.X | Question description | A/B/C |

## Priority Arbitration Requests

| # | Conflict Description | Parties Involved | Recommendation |
|---|----------|--------|------|
| 1 | | | |

## Upstream Data Supplement Requests

| # | Field | Importance | Supplement Guidance |
|---|------|--------|----------|
| 1 | | | |
```

### 8.4 prd.json Complete Schema

prd.json is the machine-consumable version of the PRD, provided for programmatic consumption by downstream Backend/UI Skills, ensuring that core information such as features, pages, entities, and user flows can be automatically parsed and aligned. It contains 7 top-level arrays: features, pages, entities, user_flows, non_functional_requirements, tracking_plan, traceability. All projects use the same complete schema — no tiering.

```json
{
  "prd_id": "string",
  "version": "string",
  "status": "draft | in_review | approved | released",
  "meta": {
    "title": "string",
    "owner": "string",
    "created_at": "ISO8601",
    "updated_at": "ISO8601"
  },
  "goals": [
    {
      "goal_id": "string",
      "description": "string",
      "okr_alignment": "string",
      "success_metrics": [
        {
          "metric_name": "string",
          "target_value": "string",
          "current_value": "string | null",
          "unit": "string"
        }
      ]
    }
  ],
  "features": [
    {
      "feature_id": "string",
      "name": "string",
      "description": "string",
      "priority": "must | should | could | wont",
      "status": "planned | in_progress | completed | cancelled",
      "goal_id": "string",
      "driven_by": {
        "north_star_metric": "string | null",
        "okr_objective": "string | null",
        "kr_id": "string | null",
        "expected_lift": "string"
      },
      "acceptance_criteria": [
        {
          "ac_id": "string",
          "given": "string",
          "when": "string",
          "then": "string"
        }
      ],
      "dependencies": ["feature_id"],
      "related_pages": ["page_id"],
      "related_entities": ["entity_id"]
    }
  ],
  "pages": [
    {
      "page_id": "string",
      "name": "string",
      "route": "string",
      "description": "string",
      "data_requirements": [
        {
          "data_name": "string",
          "source": "api | local | cache",
          "data_operations": ["read | create | update | delete"],
          "related_entity": "entity_id | null",
          "fields": ["string"],
          "description": "string"
        }
      ],
      "functional_areas": ["string"],
      "user_flows": ["flow_id"],
      "states": [
        {
          "state_name": "string",
          "description": "string",
          "triggers": ["string"]
        }
      ]
    }
  ],
  "entities": [
    {
      "entity_id": "string",
      "name": "string",
      "description": "string",
      "fields": [
        {
          "field_name": "string",
          "type": "string",
          "required": "boolean",
          "description": "string",
          "constraints": "string | null"
        }
      ],
      "relationships": [
        {
          "target_entity_id": "string",
          "type": "one_to_one | one_to_many | many_to_many",
          "description": "string"
        }
      ],
      "api_endpoints": [
        {
          "method": "GET | POST | PUT | PATCH | DELETE",
          "path": "string",
          "description": "string"
        }
      ],
      "migration": {
        "from_version": "string | null",
        "to_version": "string",
        "strategy": "expand_and_contract | dual_write | big_bang",
        "rollback": "string",
        "required": "boolean"
      }
    }
  ],
  "user_flows": [
    {
      "flow_id": "string",
      "name": "string",
      "description": "string",
      "entry_page": "page_id",
      "steps": [
        {
          "step_id": "string",
          "action": "string",
          "page_id": "string",
          "expected_outcome": "string",
          "error_handling": "string | null"
        }
      ],
      "alternative_paths": [
        {
          "condition": "string",
          "steps": ["step_id"]
        }
      ]
    }
  ],
  "non_functional_requirements": {
    "performance": [
      {
        "requirement": "string",
        "metric": "string",
        "target": "string"
      }
    ],
    "capacity_forecast": [
      {
        "time_horizon": "T0 | +3m | +6m | +12m",
        "expected_dau_mau": "string",
        "peak_qps": "string",
        "storage_growth": "string",
        "bandwidth": "string",
        "resource_action": "string"
      }
    ],
    "availability": [
      {
        "requirement": "string",
        "metric": "string",
        "target": "string",
        "measurement": "string"
      }
    ],
    "slo_targets": [
      {
        "slo": "availability | latency_p99 | error_rate",
        "target": "string",
        "measurement_window": "string",
        "error_budget_policy": "string",
        "owner": "PM | Ops"
      }
    ],
    "dr_targets": [
      {
        "scenario": "single_az_failure | region_failure | data_corruption",
        "rpo": "string",
        "rto": "string",
        "backup_strategy": "string",
        "failover_mechanism": "string",
        "dr_drill_frequency": "string"
      }
    ],
    "security": [
      {
        "category": "authentication | authorization | encryption | audit | compliance",
        "requirement": "string",
        "implementation": "string"
      }
    ],
    "observability": [
      {
        "dimension": "metrics | logs | traces",
        "indicator": "string",
        "alert_threshold": "string"
      }
    ]
  },
  "tracking_plan": {
    "events": [
      {
        "event_id": "string",
        "event_name": "string",
        "trigger": "string",
        "properties": [
          {
            "property_name": "string",
            "type": "string",
            "required": "boolean"
          }
        ],
        "related_metric": "string"
      }
    ],
    "validation": {
      "coverage_target": "number",
      "data_delay_threshold": "string"
    },
    "experiment_hypothesis_ref": [
      {
        "feature_id": "string",
        "hypothesis": "string",
        "primary_metric": "string",
        "expected_lift": "string",
        "guardrail_metric": "string",
        "min_sample_size": "string",
        "min_run_duration": "string",
        "required": "boolean"
      }
    ]
  },
  "dependencies_to_introduce": [
    {
      "name": "string",
      "version": "string",
      "license": "MIT | Apache-2.0 | BSD | other",
      "purpose": "string",
      "justification": "string",
      "maintainer_health": "active | archived | unknown"
    }
  ],
  "environment_diffs": [
    {
      "config_key": "string",
      "dev": "string",
      "staging": "string",
      "prod": "string",
      "notes": "string"
    }
  ],
  "error_code_table": [
    {
      "http_status": "number",
      "error_code": "string",
      "error_message": "string",
      "trigger_condition": "string",
      "recovery_guidance": "string"
    }
  ],
  "traceability": [
    {
      "feature_id": "string",
      "goal_id": "string",
      "upstream_source": "string",
      "upstream_artifact_id": "string"
    }
  ]
}
```
