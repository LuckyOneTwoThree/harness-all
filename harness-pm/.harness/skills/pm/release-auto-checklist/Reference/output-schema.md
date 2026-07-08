# release-auto-checklist Output Schema

> This document is split from the release-auto-checklist SKILL.md and contains the complete output data structure definition, final output structure, output field descriptions, and output validation rules.

## Output Schema

```json
{
  "type": "object",
  "required": ["release_checklist"],
  "properties": {
    "release_checklist": {
      "type": "object",
      "description": "Release checklist root object",
      "required": ["version", "items", "gate_result", "blockers", "risk_summary"],
      "properties": {
        "version": {"type": "string", "description": "Release version number"},
        "items": {
          "type": "array",
          "description": "List of checklist items",
          "items": {
            "type": "object",
            "required": ["id", "category", "description", "status", "severity"],
            "properties": {
              "id": {"type": "string", "description": "Checklist item ID"},
              "category": {"type": "string", "description": "Check category, enum: code_quality/testing/security/compliance/infrastructure/monitoring"},
              "description": {"type": "string", "description": "Check description"},
              "status": {"type": "string", "description": "Status, enum: pass/fail/pending/waived"},
              "severity": {"type": "string", "description": "Severity level, enum: blocker/warning/info"},
              "evidence": {"type": "string", "description": "Evidence link"},
              "assignee": {"type": "string", "description": "Owner"}
            }
          }
        },
        "gate_result": {"type": "string", "description": "Gate result, enum: go/no_go/conditional"},
        "blockers": {"type": "array", "description": "List of blocking items"},
        "risk_summary": {"type": "object", "description": "Risk summary"}
      }
    }
  }
}
```

## Final Output Structure

```json
{
  "release_checklist": {
    "version": "v2.1.0",
    "items": [
      {
        "id": "T7_C001",
        "category": "code_quality",
        "description": "Code has passed static analysis",
        "status": "pass",
        "severity": "blocker",
        "evidence": "sonarqube_scan_2024_0125.json",
        "assignee": "ci_system"
      }
    ],
    "gate_result": "conditional",
    "blockers": [
      {
        "id": "T-1_C002",
        "title": "Release notification not sent",
        "owner": "dev_zhang"
      }
    ],
    "risk_summary": {
      "risk_level": "medium",
      "blocking_items_count": 1
    }
  }
}
```

## Output Field Descriptions

| Field | Type | Description |
|------|------|------|
| release_checklist | JSON | Release checklist root object |
| release_checklist.version | string | Release version number |
| release_checklist.items | array | List of checklist items |
| release_checklist.gate_result | string | Gate result |
| release_checklist.blockers | array | List of blocking items |
| release_checklist.risk_summary | object | Risk summary |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| release_checklist | object | Yes | Release checklist root object |
| release_checklist.version | string | Yes | Release version number |
| release_checklist.items | array | Yes | List of checklist items |
| release_checklist.items[].id | string | Yes | Checklist item ID |
| release_checklist.items[].category | string | Yes | Check category, enum: code_quality/testing/security/compliance/infrastructure/monitoring |
| release_checklist.items[].description | string | Yes | Check description |
| release_checklist.items[].status | string | Yes | Status, enum: pass/fail/pending/waived |
| release_checklist.items[].severity | string | Yes | Severity level, enum: blocker/warning/info |
| release_checklist.items[].evidence | string | No | Evidence link |
| release_checklist.items[].assignee | string | No | Owner |
| release_checklist.gate_result | string | Yes | Gate result, enum: go/no_go/conditional |
| release_checklist.blockers | array | Yes | List of blocking items |
| release_checklist.risk_summary | object | Yes | Risk summary |
