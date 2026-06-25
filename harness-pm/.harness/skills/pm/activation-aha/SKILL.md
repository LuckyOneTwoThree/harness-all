---
name: activation-aha
description: Use when you need to identify and engineer Aha Moments. Aha Moment Auto-Engineering Pipeline analyzes retention data and behavior data to automatically identify Aha Moment candidates, measure reach rates, identify the shortest path, and output Onboarding optimization recommendations. Keywords: Aha Moment, activation moment, user activation, reach rate, Onboarding optimization, when users feel the product is good, experience core value, where is the delight.
---
# Aha Moment Auto-Engineering

## When to use
- When do users feel the product is good to use
- How to find the aha moment
- How long for new users to experience core value

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/metrics/data-analysis-report.md

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md
- output/metrics/aha-moment.json
- aha_moment.json

## Core Principles

1. **Aha is causation, not correlation**: Aha Moment must be a causal relationship between behavior and retention, not just correlation
2. **Reach rate determines the ceiling**: No matter how strong an Aha Moment is, if the reach rate is low it cannot scale; the reach path must be optimized simultaneously
3. **Shortest path first**: The shorter the path from registration to Aha Moment, the higher the activation rate

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Retention data | object | Yes | docs/metrics/data-analysis-report.md ("Retention Analysis" section) | D1/D7/D30 retention rates |
| User behavior data | object | Yes | User-provided | Event logs, behavior sequences |
| User segment data | object | ○ | User-provided | User segmentation data |

## Aha Moment Definition

Aha Moment is the critical moment when a user first experiences the product's core value. When a user completes this behavior, they are more likely to retain long-term and become active users.

**Aha Moment = specific behavior + specific time window + retention lift effect**

## Execution Steps

### Step 1: Aha Moment Candidate Search [Core]

#### Candidate Behavior Enumeration
Scan all user behaviors to find those highly correlated with retention:

1. **Behavior type classification**:
   - Core feature usage
   - Key path completion
   - Social interaction behaviors
   - Content creation behaviors
   - Setup and configuration behaviors

2. **Time window analysis**:
   - Within 1 hour of registration
   - Within 24 hours of registration
   - Within 7 days of registration

3. **Correlation calculation**:
   ```
   Correlation = degree of correlation between user executing behavior and retention
   Lift = retention rate of users who executed the behavior - retention rate of users who did not
   ```

#### Candidate Screening Criteria
- Correlation ≥ 0.5
- Reach rate ≥ 10%
- Retention lift ≥ 15%

### Step 2: Reach Rate Measurement [Core]

Analyze the actual reach of each candidate Aha Moment:

| Metric | Description |
|------|------|
| Overall reach rate | Proportion of registered users who reached this behavior |
| Time distribution | Time distribution of users reaching this behavior |
| Path analysis | Path from registration to this behavior |
| Drop-off nodes | Drop-off points before users reach this behavior |

### Step 3: Shortest Path Identification [Core]

Analyze how to get users to the Aha Moment fastest:

1. **Path analysis**: Identify typical paths from registration to Aha Moment
2. **Friction identification**: Find friction points and drop-off points in the path
3. **Optimization recommendations**: Design shorter reach paths

### Step 4: Onboarding Optimization Recommendations [Deep]

Based on Aha Moment analysis, generate Onboarding optimization recommendations:

#### Direct guidance strategy
- Directly guide users to complete the Aha Moment behavior in the Onboarding flow
- Design a "one-click experience core feature" shortcut path

#### Incentive strategy
- Provide rewards for users who complete the Aha Moment behavior
- Lower the threshold for completing the Aha Moment

#### Education strategy
- Strengthen the value display of the Aha Moment
- Provide value preview before reaching the Aha Moment

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Aha moment and activation path | Core conclusions + minimum viable artifact |
| standard | Complete artifact (current default) | Complete artifact, including all Step outputs |
| deep | Complete strategy + Aha moment quantitative validation + activation path optimization + activation funnel deep analysis | Complete artifact + extended analysis + deep inference |

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Aha Moment" section)`

**Output file**: aha_moment.json → `output/metrics/aha-moment.json`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["candidates", "primary_aha"],
  "properties": {
    "candidates": {"type": "array", "description": "Aha Moment candidate list, including behavior, correlation, reach rate, and retention lift"},
    "primary_aha": {"type": "object", "description": "Primary Aha Moment, including behavior, reach rate, retention lift, and confidence"},
    "secondary_ahas": {"type": "array", "description": "Secondary Aha Moment list"},
    "onboarding_optimization": {"type": "object", "description": "Onboarding optimization recommendations, including target behaviors and optimization funnel"}
  }
}
```

`aha_moment`
```json
{
  "candidates": [
    {
      "behavior": "First create and publish an online course",
      "behavior_type": "action|feature_engagement",
      "retention_lift": 0.35,
      "correlation": 0.78,
      "reach_rate": 0.45,
      "time_to_aha": "Within 24 hours of registration",
      "recommendation": "Guide users in Onboarding to use course templates to quickly create their first course"
    }
  ],
  "primary_aha": {
    "behavior": "First create and publish an online course",
    "reach_rate": 0.45,
    "retention_lift": 0.35,
    "confidence": 0.92
  },
  "secondary_ahas": [
    {
      "behavior": "First invite students to join a course",
      "reach_rate": 0.25,
      "retention_lift": 0.28
    }
  ],
  "onboarding_optimization": {
    "target_behaviors": ["Create online course" // ... same structure extensible],
    "current_funnel": {...},
    "optimized_funnel": {...},
    "expected_activation_lift": "15%"
  }
}
```

## Aha Moment Analysis Example

```
Candidate Aha Moment analysis:

1. "First create first project"
   - Correlation: 0.82
   - Reach rate: 35%
   - Retention lift: +42%
   - Recommendation: Optimize project creation flow, lower creation threshold

2. "First share content with friends"
   - Correlation: 0.65
   - Reach rate: 18%
   - Retention lift: +28%
   - Recommendation: Guide users to share, increase sharing incentives

3. "First use core analysis feature"
   - Correlation: 0.75
   - Reach rate: 25%
   - Retention lift: +35%
   - Recommendation: Demonstrate core feature value in Onboarding
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| candidates | array | Yes | Aha Moment candidate list, at least 1 candidate |
| candidates[].behavior | string | Yes | Behavior description, cannot be empty |
| candidates[].behavior_type | string | No | Behavior type, enum: action/completion/social/discovery |
| candidates[].correlation | number | Yes | Correlation coefficient, range 0-1 |
| candidates[].reach_rate | number | Yes | Reach rate, range 0-1 |
| candidates[].time_to_aha | string | No | Time to reach Aha |
| candidates[].retention_lift | number | Yes | Retention lift, must be >0 |
| candidates[].recommendation | string | No | Recommended action |
| primary_aha | object | Yes | Primary Aha Moment, must contain behavior/reach_rate/retention_lift/confidence |
| primary_aha.behavior | string | Yes | Aha behavior description, cannot be empty |
| primary_aha.reach_rate | number | Yes | Reach rate, range 0-1 |
| primary_aha.retention_lift | number | Yes | Retention lift, must be >0 |
| primary_aha.confidence | number | Yes | Confidence, range 0-1 |
| secondary_ahas | array | No | Secondary Aha Moment list |
| secondary_ahas[].behavior | string | Yes | Aha behavior description, cannot be empty |
| secondary_ahas[].reach_rate | number | Yes | Reach rate, range 0-1 |
| secondary_ahas[].retention_lift | number | No | Retention lift |
| onboarding_optimization | object | No | Onboarding optimization recommendations, must contain target_behaviors |
| onboarding_optimization.target_behaviors | array | Yes | Target behavior list |
| onboarding_optimization.target_behaviors[].behavior | string | Yes | Behavior description |
| onboarding_optimization.expected_activation_lift | string | No | Expected activation lift |

## Decision Rules

| Situation | Handling |
|------|----------|
| Aha candidate correlation ≥0.5 and reach rate ≥10% | Add to priority validation list |
| Primary Aha reach rate <20% | Optimize Onboarding guidance path |
| Multiple Aha candidates point to different segments | Design differentiated guidance by segment |
| Aha behavior has no causal relationship with retention | Exclude this candidate, continue searching |

## Quality Checks

### P0 Checks (quick/standard/deep must all pass)

- [ ] Aha candidates pass correlation screening (≥0.5) and significance test
- [ ] Reach rate analysis includes time distribution and path analysis

### P1 Checks (standard/deep must pass)

- [ ] Shortest path identification includes friction point analysis
- [ ] Onboarding optimization recommendations are directly executable

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| Retention data missing | User provides user behavior list → infer Aha Moment candidates | Aha Moment based on inference rather than data validation | Require user to provide retention rate difference data for users with different behaviors |
| Behavior data missing | User provides user behavior list → infer Aha Moment candidates | Cannot perform behavior-retention correlation analysis | Require user to provide user behavior event logs (including event name, timestamp, user ID) |
| Both retention data and behavior data missing | User provides user behavior list → infer Aha Moment candidates | Output Aha Moment candidate list, marked "pending data validation" | Require user to provide user behavior list and retention rate data |
| User segment data missing | Skip segment comparison analysis, output overall Aha Moment only | Cannot identify differentiated Aha Moments for different user segments | Require user to provide user segment tags and behavioral characteristics of each segment |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **User behavior list**: Core behaviors users can perform in the product
- **Retention rate data** (optional): Retention rate differences for users with different behaviors
- **New user typical path** (optional): Most common operation sequence for new users

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| analysis-retention | Retention metric caliber change | Correlation calculation and retention lift assessment | Recalculate correlation and retention lift at new caliber |
| User-provided - Behavior data | Event definition change | Candidate behavior enumeration and path analysis | Update behavior classification, re-search candidates |
| User-provided - Segment data | Segment dimension change | Segment-level Aha Moment identification | Re-identify segment Aha at new dimensions |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| activation-onboarding | Primary Aha Moment change | Write to output file | New Aha behavior, reach rate, and guidance path |
| activation-orchestrator | Aha Moment identification completed | Output file update | Aha identification completion status and key conclusions |

## Notes

- Aha Moment may change with product iteration and should be re-evaluated periodically
- Different user segments may have different Aha Moments
- Aha Moment optimization needs to balance reach rate and retention lift
