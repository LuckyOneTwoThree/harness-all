# data-analysis-report — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

## Executive Summary
- Core metrics overview
- 3 key findings
- Top 1 action recommendation

## 1. Data Overview
### 1.1 Core Metrics Dashboard
### 1.2 Data Quality Statement

## 2. Funnel Analysis
### 2.1 Full-Link Funnel
### 2.2 Key Drop-off Points
### 2.3 Improvement Opportunities

## 3. Retention Analysis
### 3.1 Retention Curve
### 3.2 Lifecycle Stages
### 3.3 Churn Warning

## 4. Anomaly Analysis
### 4.1 Anomaly Event List
### 4.2 Attribution Analysis

## 5. Insights and Action Recommendations
### 5.1 Core Insights
### 5.2 Action Recommendations (by priority)

## Appendix
- Data sources and definitions
- Metric definitions
- Statistical method notes
```

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Data insights and key findings | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full report + multi-dimensional cross-analysis + prediction model + decision recommendation roadmap | Full artifact + extended analysis + deep inference |

## Output

**Storage Path**: `docs/metrics/data-analysis-report.md (consolidated coverage)`

**Output Files**:

| File | Format | Description |
|------|------|------|
| data-analysis-report.md | Markdown | Complete data analysis report |
| data-analysis-report.json | JSON | Structured data (for downstream skill reference) |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["report_metadata", "executive_summary", "insights", "recommendations"],
  "properties": {
    "report_metadata": {"type": "object", "description": "Report metadata, including product name, time range, and data sources"},
    "executive_summary": {"type": "object", "description": "Executive summary, including key metrics, findings, and top recommendation"},
    "funnel_analysis": {"type": "object", "description": "Funnel analysis, including full funnel, biggest drop-off, and opportunity points"},
    "retention_analysis": {"type": "object", "description": "Retention analysis, including key nodes and lifecycle stages"},
    "anomaly_analysis": {"type": "object", "description": "Anomaly analysis, including events and attribution"},
    "insights": {"type": "array", "description": "Insight list, including data facts, business implications, and action directions"},
    "recommendations": {"type": "array", "description": "Recommendation list, including priority, expected lift, and validation method"}
  }
}
```

**data-analysis-report.json Structure**:

```json
{
  "report_metadata": {
    "product": "Product Name", "time_range": "Analysis time range",
    "generated_at": "Timestamp", "data_sources": [], "data_quality": ""
  },
  "executive_summary": {
    "key_metrics": [], "key_findings": [], "top_recommendation": ""
  },
  "funnel_analysis": {
    "full_funnel": [], "biggest_drop": {},
    "biggest_opportunity": {}, "key_findings": []
  },
  "retention_analysis": {
    "d1": 0, "d7": 0, "d30": 0, "curve_shape": "",
    "lifecycle_stages": [], "churn_warnings": []
  },
  "anomaly_analysis": { "events": [], "attributions": [] },
  "insights": [
    { "id": "INS-001", "fact": "Data fact", "implication": "Business implication", "action_direction": "Action direction" }
    // ... Same structure can be extended
  ],
  "recommendations": [
    { "id": "REC-001", "description": "Recommendation description", "target_metric": "Target metric",
      "expected_lift": "Expected lift", "difficulty": "Low/Medium/High",
      "category": "Quick Win/Core Optimization/Long-term Investment/Watchlist", "priority": "P0/P1/P2",
      "validation_method": "Validation method" }
    // ... Same structure can be extended
  ]
}
```
