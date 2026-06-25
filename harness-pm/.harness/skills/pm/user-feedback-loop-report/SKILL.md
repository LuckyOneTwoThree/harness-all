---
name: user-feedback-loop-report
description: Used when summarizing user feedback handling into a complete, deliverable closed-loop report. Auto-generates user feedback loop reports including feedback source analysis, processing progress tracking, closure rate statistics, unresolved issues, and improvement suggestions. Keywords: user feedback loop, feedback report, feedback tracking, closure rate, VOC loop, feedback handling, is feedback handled, user opinions.
---
# User Feedback Loop Report Generation

## When to use
- How is user feedback handling going
- Help me generate a feedback loop report
- How is the feedback closure rate

## Inputs
- rules/security.md
- loops/LOOP.md

## Outputs
- docs/monitoring/feedback-loop.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principle

**Every piece of user feedback deserves a response**

The core value of user feedback loop reports lies in ensuring every piece of user feedback has a beginning and an end. Closure is not a formal "read", but a substantive "handled" or "decided". Unclosed feedback is a loss of user trust.

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Voice of Customer analysis | markdown | No | user-research-voice-analysis | Sentiment analysis, topic extraction, pain point list |
| Anomaly monitoring data | markdown | No | monitoring-attribution | Anomaly events, user impact scope |
| Feedback data | text | Yes | User input | Raw user feedback data from various channels |
| Handling records | text | No | User input | Records and results of handled feedback |

### Degradation Strategy

| Missing Input | Degradation Plan |
|----------|----------|
| No Voice of Customer analysis | Analyze and classify based on raw feedback data, label "pending VOC deep analysis" |
| No anomaly monitoring data | Skip anomaly correlation analysis, label "pending monitoring data supplementation" |
| No handling records | Only count feedback sources and classifications, closure rate labeled "pending handling records supplementation" |
| No feedback data | If user does not provide feedback data, prompt user to provide or skip steps related to this input |

## Execution Steps

### Step 1: Feedback Source Analysis [Core]

Count and analyze the source distribution of feedback:

1. **Channel distribution**: In-app feedback / Customer service tickets / Social media / App stores / Community / Email
2. **Sentiment distribution**: Positive / Neutral / Negative and proportions
3. **Topic distribution**: Feedback distribution classified by functional module
4. **Time trend**: Time variation trend of feedback volume

### Step 2: Processing Progress Tracking [Conditional]

Track the processing status of each piece of feedback:

1. **Status classification**:
   - 🆕 New (unprocessed)
   - 👀 Under evaluation (validity confirmed)
   - 📋 Scheduled (included in iteration plan)
   - 🔨 In progress (development/fix in progress)
   - ✅ Closed-loop (issue resolved and verified)
   - ❌ Closed (not handled, with reason)
2. **Processing timeliness**: Average dwell time per status
3. **Bottleneck identification**: Blockages in the processing flow

### Step 3: Closure Rate Statistics [Core]

Calculate and track feedback closure rate:

1. **Overall closure rate**: Closed-loop + Closed / Total feedback count
2. **Closure rate by channel**: Closure rate comparison across channels
3. **Closure rate by severity**: P0/P1/P2/P3 closure rates
4. **Closure timeliness**: Average time from feedback to closure
5. **Trend comparison**: Closure rate comparison with previous period

### Step 4: Unresolved Issue Analysis [Conditional]

Analyze feedback that has not been closed-loop:

1. **P0/P1 unresolved list**: High-priority unresolved issues
2. **Long-standing unresolved**: Feedback not closed-loop for over 30 days
3. **Repeated feedback**: Same type of issue reported multiple times
4. **Root cause analysis**: Main reason classification for non-closure

### Step 5: Improvement Suggestions [Deep]

Propose improvement suggestions based on closure analysis:

1. **Process improvement**: Process optimization to shorten handling time
2. **Product improvement**: Product optimization directions corresponding to high-frequency feedback
3. **Communication improvement**: Communication strategies for responding to user feedback
4. **Preventive measures**: Prevention plans to reduce similar feedback

### Step 6: Report Assembly [Core]

Assemble the above content into a complete loop report.

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Closure rate and P0 unresolved list | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full report + feedback trend forecast + root cause deep analysis + improvement roadmap | Full artifact + extended analysis + deep reasoning |

## Output

### Output Files

| File | Path | Description |
|------|------|------|
| Feedback loop report | `docs/monitoring/feedback-loop.md` | Human-readable complete report |
| Structured data | `docs/monitoring/feedback-loop.md` | Machine-consumable structured data |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["report_period", "summary", "closure_metrics"],
  "properties": {
    "report_period": {"type": "object", "description": "Report period, including start and end dates"},
    "report_date": {"type": "string", "description": "Report date"},
    "summary": {"type": "object", "description": "Executive summary, including total feedback count, closure rate, and P0 unresolved count"},
    "source_analysis": {"type": "object", "description": "Feedback source analysis, including channel/sentiment/topic distribution"},
    "processing_status": {"type": "object", "description": "Processing progress, including status distribution and bottlenecks"},
    "closure_metrics": {"type": "object", "description": "Closure rate statistics, including overall and by-channel/by-severity closure rates"},
    "unresolved": {"type": "object", "description": "Unresolved issues, including P0/P1 list and root cause analysis"},
    "improvement_suggestions": {"type": "array", "description": "Improvement suggestions list"}
  }
}
```

### Markdown Report Structure

```markdown
# User Feedback Loop Report: 2026-06-W2

## 1. Executive Summary
- Total feedback count / Closure rate / Average closure time / P0 unresolved count

## 2. Feedback Source Analysis
- Channel distribution
- Sentiment distribution
- Topic distribution
- Time trend

## 3. Processing Progress Tracking
- Status distribution
- Processing timeliness
- Bottleneck identification

## 4. Closure Rate Statistics
- Overall closure rate
- By-channel/by-severity closure rate
- Closure timeliness
- Trend comparison

## 5. Unresolved Issues
- P0/P1 unresolved list
- Long-standing unresolved
- Repeated feedback
- Root cause analysis

## 6. Improvement Suggestions
- Process improvement
- Product improvement
- Communication improvement
- Preventive measures
```

### JSON Structure

```json
{
  "report_period": { "start": "", "end": "" },
  "report_date": "",
  "summary": {
    "total_feedback": 0,
    "closure_rate": 0,
    "avg_closure_time_days": 0,
    "p0_unresolved": 0
  },
  "source_analysis": {
    "channel_distribution": {},
    "sentiment_distribution": {},
    "topic_distribution": {},
    "time_trend": []
  },
  "processing_status": {
    "status_distribution": {},
    "avg_time_by_status": {},
    "bottlenecks": []
  },
  "closure_metrics": {
    "overall_rate": 0,
    "by_channel": {},
    "by_severity": {},
    "trend_comparison": {}
  },
  "unresolved": {
    "p0_p1_list": [],
    "long_standing": [],
    "repeated": [],
    "root_causes": []
  },
  "improvement_suggestions": []
}
```

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Closure rate calculable (clear closure definition and calculation formula)
- [ ] P0 unresolved listed (all P0 unclosed feedback has a list)

### P1 Checks (must pass for standard/deep)

- [ ] Timeliness data complete (average processing time per status calculable)
- [ ] Improvement suggestions executable (each suggestion has owner and timeline)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Decision Rules

- When P0 feedback unresolved count > 0, report must include a dedicated follow-up plan
- When closure rate < 80%, automatically generate process improvement suggestions
- When same-type feedback appears ≥ 3 times, escalate to product improvement suggestion rather than case-by-case handling
- Decision points requiring human confirmation: feedback priority determination, closure standard definition, closure reason for not-handled feedback

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact |
|----------|----------|----------|
| No Voice of Customer analysis | Analyze directly based on user-provided feedback data, label "VOC analysis pending supplementation" | Feedback analysis lacks sentiment and topic dimensions |
| No anomaly monitoring data | Skip anomaly correlation analysis, label "monitoring data pending supplementation" | Correlation between feedback and anomaly events missing |
| No handling records | Only count feedback quantity and classification, closure rate labeled "cannot calculate" | Closure rate not calculable |

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| summary | object | Yes | Executive summary, must contain total_feedback/closed_rate |
| source_analysis | object | Yes | Feedback source analysis |
| progress_tracking | object | No | Processing progress tracking |
| closed_rate | object | No | Closure rate statistics, must contain overall/by_category |
| unresolved_p0 | array | No | P0 unresolved list |
| improvement_suggestions | array | No | Improvement suggestions list |

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| user-research-voice-analysis | VOC analysis results updated | Feedback source analysis and sentiment dimensions | Update sentiment distribution and topic classification |
| monitoring-attribution | Anomaly events updated | Feedback and anomaly correlation analysis | Update correlated events and impact scope |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| monitoring-orchestrator | Feedback loop report completed | Output file updated | Report completion status and key conclusions |
| iteration-retrospective | P0 unresolved feedback | Write to output file | P0 feedback list and improvement suggestions |
