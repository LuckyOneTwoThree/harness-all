# quality-acceptance Output Schema

> This document is split from the quality-acceptance SKILL.md and contains the complete output data structure definition, final output structure, and output validation rules.

## Output Schema

```json
{
  "type": "object",
  "required": ["auto_acceptance", "acceptance_report"],
  "properties": {
    "auto_acceptance": {
      "type": "object",
      "description": "Automated acceptance root object",
      "required": ["execution_summary", "checks", "gate_result"],
      "properties": {
        "execution_summary": {
          "type": "object",
          "description": "Execution summary",
          "required": ["total_checks", "auto_passed", "auto_failed", "manual_required"],
          "properties": {
            "total_checks": {"type": "number", "description": "Total number of checks"},
            "auto_passed": {"type": "number", "description": "Number of automated passes"},
            "auto_failed": {"type": "number", "description": "Number of automated failures"},
            "manual_required": {"type": "number", "description": "Number of checks requiring manual verification"}
          }
        },
        "checks": {
          "type": "array",
          "description": "List of checks",
          "items": {
            "type": "object",
            "required": ["id", "type", "method", "result", "confidence"],
            "properties": {
              "id": {"type": "string", "description": "Check ID"},
              "type": {"type": "string", "description": "Check type, enum: functional/performance/security/compatibility"},
              "method": {"type": "string", "description": "Acceptance method, enum: automated/semi_auto/manual"},
              "result": {"type": "string", "description": "Result, enum: pass/fail/pending"},
              "evidence": {"type": "object", "description": "Acceptance evidence"},
              "confidence": {"type": "number", "description": "Confidence, 0-1"}
            }
          }
        },
        "gate_result": {"type": "string", "description": "Gate result, enum: pass/fail/conditional_pass"}
      }
    },
    "acceptance_report": {
      "type": "object",
      "description": "Acceptance report root object",
      "required": ["summary", "items", "risk_assessment", "sign_off"],
      "properties": {
        "summary": {
          "type": "object",
          "description": "Acceptance summary",
          "required": ["total_items", "passed", "failed", "blocked"],
          "properties": {
            "total_items": {"type": "number", "description": "Total number of acceptance items"},
            "passed": {"type": "number", "description": "Number of passed items"},
            "failed": {"type": "number", "description": "Number of failed items"},
            "blocked": {"type": "number", "description": "Number of blocked items"}
          }
        },
        "items": {
          "type": "array",
          "description": "List of acceptance items",
          "items": {
            "type": "object",
            "required": ["id", "category", "description", "result", "severity"],
            "properties": {
              "id": {"type": "string", "description": "Acceptance item ID"},
              "category": {"type": "string", "description": "Acceptance category"},
              "description": {"type": "string", "description": "Acceptance description"},
              "result": {"type": "string", "description": "Result, enum: pass/fail/blocked/waived"},
              "evidence": {"type": "string", "description": "Evidence link"},
              "severity": {"type": "string", "description": "Severity level, enum: P0/P1/P2/P3"}
            }
          }
        },
        "risk_assessment": {"type": "object", "description": "Risk assessment"},
        "sign_off": {
          "type": "object",
          "description": "Sign-off record",
          "required": ["status"],
          "properties": {
            "status": {"type": "string", "description": "Sign-off status, enum: pending/signed/rejected"}
          }
        }
      }
    }
  }
}
```

## Final Output Structure

```json
{
  "auto_acceptance": {
    "execution_summary": { /* see Output Validation Rules */ },
    "checks": [ { /* see Step 1.5 Execution Instruction Generation */ } ],
    "gate_result": "pass | fail | conditional_pass"
  },
  "acceptance_report": {
    "summary": { /* see Output Validation Rules */ },
    "items": [ { /* see Step 2.2 Test Result Integration */ } ],
    "risk_assessment": { /* see Step 2.4 Residual Issue Assessment */ },
    "sign_off": { /* see Step 2.5 Acceptance Conclusion */ }
  }
}
```

## Output Field Descriptions

See Output Schema and Output Validation Rules.

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| auto_acceptance | object | Yes | Automated acceptance root object |
| auto_acceptance.execution_summary | object | Yes | Execution summary |
| auto_acceptance.execution_summary.total_checks | number | Yes | Total number of checks |
| auto_acceptance.execution_summary.auto_passed | number | Yes | Number of automated passes |
| auto_acceptance.execution_summary.auto_failed | number | Yes | Number of automated failures |
| auto_acceptance.execution_summary.manual_required | number | Yes | Number of checks requiring manual verification |
| auto_acceptance.checks | array | Yes | List of checks |
| auto_acceptance.checks[].id | string | Yes | Check ID |
| auto_acceptance.checks[].type | string | Yes | Check type, enum: functional/performance/security/compatibility |
| auto_acceptance.checks[].method | string | Yes | Acceptance method, enum: automated/semi_auto/manual |
| auto_acceptance.checks[].result | string | Yes | Result, enum: pass/fail/pending |
| auto_acceptance.checks[].evidence | object | No | Acceptance evidence |
| auto_acceptance.checks[].confidence | number | Yes | Confidence, 0-1 |
| auto_acceptance.gate_result | string | Yes | Gate result, enum: pass/fail/conditional_pass |
| acceptance_report | object | Yes | Acceptance report root object |
| acceptance_report.summary | object | Yes | Acceptance summary |
| acceptance_report.summary.total_items | number | Yes | Total number of acceptance items |
| acceptance_report.summary.passed | number | Yes | Number of passed items |
| acceptance_report.summary.failed | number | Yes | Number of failed items |
| acceptance_report.summary.blocked | number | Yes | Number of blocked items |
| acceptance_report.items | array | Yes | List of acceptance items |
| acceptance_report.items[].id | string | Yes | Acceptance item ID |
| acceptance_report.items[].category | string | Yes | Acceptance category |
| acceptance_report.items[].description | string | Yes | Acceptance description |
| acceptance_report.items[].result | string | Yes | Result, enum: pass/fail/blocked/waived |
| acceptance_report.items[].evidence | string | No | Evidence link |
| acceptance_report.items[].severity | string | Yes | Severity level, enum: P0/P1/P2/P3 |
| acceptance_report.risk_assessment | object | Yes | Risk assessment |
| acceptance_report.sign_off | object | Yes | Sign-off record |
| acceptance_report.sign_off.status | string | Yes | Sign-off status, enum: pending/signed/rejected |
