---
name: activation-onboarding
description: Use when optimizing the user Onboarding flow. Onboarding Auto-Optimization Pipeline analyzes Onboarding data and user segments, automatically generates personalized guidance strategies, and designs A/B test plans. Keywords: Onboarding, new user guidance, guidance optimization, personalized guidance, user activation, onboarding tutorial, fast onboarding, guidance too long.
---
# Onboarding Auto-Optimization

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/growth/growth-strategy.md
- onboarding_plan.json

## Core Principles

1. **Onboarding is value delivery, not feature tour**: Every guidance step must let users feel value, not just know where features are
2. **Segmentation means separate paths**: Different user segments need different Onboarding paths; one path cannot fit all
3. **Aha Moment is the destination**: The sole goal of Onboarding is to get users to the Aha Moment; everything else is a means

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| Onboarding data | object | Yes | User-provided | Completion rate, drop-off rate, user feedback |
| Aha Moment data | object | Yes | docs/growth/growth-strategy.md ("Aha Moment" section) | Aha Moment data |
| User segment data | object | ○ | User-provided | User characteristics, behavioral traits |

## Onboarding Stage Definition

The standard Onboarding flow includes the following stages:

```
Welcome Page → Value Demonstration → Account Setup → Feature Guidance → Aha Moment → Activation Complete
```

### Stage 1: Welcome Page
- Brand presentation
- Value proposition delivery
- Onboarding kickoff

### Stage 2: Value Demonstration
- Core feature demo
- User case showcase
- Value promise

### Stage 3: Account Setup
- Basic info collection
- Preference settings
- Personalization configuration

### Stage 4: Feature Guidance
- Core feature introduction
- Operation demo
- Hands-on practice

### Stage 5: Aha Moment
- Guide users to complete the core value action
- Ensure users feel the product's value

### Stage 6: Activation Complete
- Celebrate activation success
- Show the path to ongoing value
- Provide help resources

## Execution Steps

### Step 1: Current Onboarding Effectiveness Analysis [Core]

#### Overall Effectiveness Assessment
- Onboarding completion rate
- Conversion rate per stage
- Completion time distribution
- User satisfaction

#### Drop-off Analysis
- Identify the biggest drop-off points
- Infer drop-off reasons
- Analyze dropped-off user characteristics

#### Effectiveness Comparison
- Onboarding differences across channels
- Onboarding differences across user segments
- Comparison with industry benchmarks

### Step 2: Segment-based Onboarding Strategy Generation [Core]

Based on user segments, design differentiated Onboarding strategies:

#### Segmentation Dimensions
- Technical background (technical/non-technical)
- Use case (B2B/B2C)
- Industry type
- Registration source
- User scale

#### Strategy Design Principles
| User Type | Guidance Style | Guidance Content |
|---------|---------|---------|
| Technical | Concise & direct | Quick start, advanced features provided |
| Business | Detailed & friendly | Step-by-step guidance, emphasize value |
| Enterprise | Professional & comprehensive | Full training, emphasize collaboration |
| Individual | Lightweight & fast | Minimal steps, immediate experience |

### Step 3: Personalized Guidance Content Generation [Core]

Based on segment strategies, generate personalized guidance content:

#### Content Types
1. **Progressive guidance** - Step-by-step guidance for key operations
2. **Contextual tooltips** - Show help when users need it
3. **Video demos** - Demonstrate core feature operations
4. **Interactive tutorials** - Guide users to learn by doing
5. **Reward incentives** - Earn rewards for completing guidance

#### Content Generation Principles
- Concise and clear, understandable at a glance
- Action-oriented, emphasize the next step
- Value-oriented, emphasize benefits
- Progress-aware, let users know how much is left

### Step 4: A/B Test Design [Core]

Design A/B tests for Onboarding optimization:

#### Test Types
1. **Overall Onboarding redesign** - Compare new vs. old Onboarding schemes
2. **Single-point optimization test** - Optimize a specific guidance step
3. **Segment differentiation test** - Different guidance schemes for different user groups

#### Core Metrics
- **Primary metrics**: Onboarding completion rate, activation rate
- **Secondary metrics**: Onboarding duration, user satisfaction
- **Guardrail metrics**: Subsequent retention rate, paid conversion rate

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Onboarding flow and activation strategy | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full strategy + activation funnel deep analysis + personalized Onboarding design + A/B test plan | Full artifact + extended analysis + deep reasoning |

## Output

**Storage path**: `docs/growth/growth-strategy.md ("Onboarding" section)`

**Output file**: onboarding_plan.json

**Output Schema**:

```json
{
  "type": "object",
  "required": ["current_effectiveness", "segment_strategies"],
  "properties": {
    "current_effectiveness": {"type": "object", "description": "Current Onboarding effectiveness assessment, including completion rate, drop-off points, and average completion time"},
    "segment_strategies": {"type": "array", "description": "List of segment Onboarding strategies, including segment characteristics and expected lift"},
    "personalized_content": {"type": "array", "description": "List of personalized guidance content, including content type and trigger conditions"},
    "ab_tests": {"type": "array", "description": "List of A/B test design plans"}
  }
}
```

`onboarding_optimization`
```json
{
  "current_effectiveness": {
    "overall_completion_rate": 0.45,
    "stage_completion_rates": {
      "welcome": 0.85,
      "profile_setup": 0.65,
      "first_action": 0.55,
      "aha_moment": 0.35
    },
    "drop_off_points": [
      {"stage": "profile_setup", "drop_off_rate": 0.24}
    ],
    "avg_time_to_complete": 12.5
  },
  "segment_strategies": [
    {
      "segment": "New user - technical background",
      "size": 5000,
      "characteristics": ["Has technical background", "Prefers self-service exploration"],
      "strategy": "Simplify guidance, provide advanced feature entry",
      "expected_improvement": "+20% activation rate"
    }
  ],
  "personalized_content": [
    {
      "segment": "New user - non-technical background",
      "content_type": "step_by_step_guide",
      "content": "Interactive tutorial guiding teachers step by step through course creation, content editing, and student invitation",
      "trigger": "Show immediately after registration"
    }
  ],
  "ab_tests": [
    {
      "test_id": "ONB_TEST_001",
      "hypothesis": "Step-by-step guidance vs. free exploration",
      "target_segment": "Non-technical users",
      "expected_lift": "15%"
    }
  ]
}
```

## A/B Test Design Template

```yaml
test_id: "ONB_TEST_{sequence}"
name: "Test name"
hypothesis: "Optimization hypothesis description"
target_segment: "Target user group"
variants:
  control:
    name: "Control group"
    description: "Current scheme description"
  treatment:
    name: "Treatment group"
    description: "Optimization scheme description"
metrics:
  primary: "Primary metric definition"
  secondary: ["Secondary metric list"]
  guardrail: ["Guardrail metric list"]
design:
  min_sample_per_variant: 2000
  runtime_days: 14
  mde: 0.05
success_criteria:
  - primary_metric_lift: ">=10%"
  - guardrail_metrics: "No significant decline"
  - statistical_significance: 0.95
```

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| current_effectiveness | object | Yes | Current effectiveness assessment, must include overall_completion_rate/drop_off_points |
| current_effectiveness.overall_completion_rate | number | Yes | Overall completion rate, range 0-1 |
| current_effectiveness.stage_completion_rates | object | No | Completion rate per stage |
| current_effectiveness.drop_off_points | array | Yes | Drop-off point list, each item must include stage/drop_off_rate |
| current_effectiveness.drop_off_points[].stage | string | Yes | Drop-off stage name |
| current_effectiveness.drop_off_points[].drop_off_rate | number | Yes | Drop-off rate, range 0-1 |
| segment_strategies | array | Yes | Segment strategy list, at least 1 segment strategy |
| segment_strategies[].segment | string | Yes | Segment name |
| segment_strategies[].size | number | No | Segment user percentage |
| segment_strategies[].characteristics | string[] | No | Segment characteristic description |
| segment_strategies[].strategy | string | Yes | Strategy description |
| segment_strategies[].expected_improvement | string | No | Expected improvement effect |
| personalized_content | array | No | Personalized content list, each item must include segment/content_type/content/trigger |
| personalized_content[].segment | string | Yes | Target segment |
| personalized_content[].content_type | string | Yes | Content type, enum: step_by_step_guide/video/tooltip/checklist |
| personalized_content[].content | string | Yes | Content description, cannot be empty |
| personalized_content[].trigger | string | Yes | Trigger condition, cannot be empty |
| ab_tests | array | No | A/B test list, each item must include test_id/hypothesis |
| ab_tests[].test_id | string | Yes | Test ID, cannot be empty |
| ab_tests[].hypothesis | string | Yes | Test hypothesis, cannot be empty |
| ab_tests[].target_segment | string | No | Target segment |
| ab_tests[].expected_lift | string | No | Expected lift |

## Decision Rules

| Situation | Action |
|------|----------|
| Onboarding completion rate <40% | Redesign the guidance flow |
| Drop-off rate at a stage >30% | Optimize the guidance content for that stage |
| Technical user completion rate significantly lower than non-technical | Provide a self-service exploration path |
| A/B test primary metric lift <5% | Adjust test hypothesis or expand sample size |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Onboarding stage definition complete (Welcome → Activation Complete)
- [ ] Drop-off analysis covers all stages and user segments

### P1 Checks (must pass for standard/deep)

- [ ] Personalized guidance matches user segments
- [ ] A/B tests include guardrail metrics (subsequent retention, paid conversion)

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| Onboarding data missing | User describes current Onboarding flow → generate optimization suggestions | Optimization suggestions based on qualitative description rather than data-driven | Require user to provide current Onboarding flow steps and completion rate per step |
| Aha Moment missing | Skip Aha Moment guidance optimization, based on general best practices | Onboarding optimization lacks Aha Moment anchor | Require user to provide Aha Moment definition or upload activation-aha output file |
| Onboarding data + Aha Moment both missing | User describes current Onboarding flow → generate optimization suggestions | Output optimization suggestions based on best practices, marked "pending data validation" | Require user to provide current Onboarding flow description and core user behaviors |
| User segment data missing | Skip segment Onboarding optimization, only output general guidance plan | Cannot customize differentiated Onboarding for different user groups | Require user to provide user segment tags and characteristics per group |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **Current Onboarding flow**: Steps and content of new user guidance
- **Completion rate data** (optional): Completion rate per guidance step
- **User feedback** (optional): New user feedback on the guidance flow

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| activation-aha | Primary Aha Moment change | Onboarding endpoint and guidance path | Redesign guidance path to point to new Aha |
| activation-aha | Reach rate data update | Expected lift of segment strategies | Adjust expected lift and priority |
| User-provided - Onboarding data | Data definition change | Effectiveness assessment and drop-off analysis | Re-evaluate effectiveness per new definition |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| retention-management | Activation rate change | Write to output file | New user activation rate and Onboarding completion rate |
| activation-orchestrator | Onboarding strategy output complete | Output file updated | Onboarding optimization completion status and key conclusions |

## Key Success Metrics

| Metric | Current Value | Target Value |
|------|--------|--------|
| Onboarding completion rate | 45% | ≥60% |
| Activation rate | 35% | ≥50% |
| Average completion time | 12.5 minutes | ≤10 minutes |
| Guidance satisfaction | 3.2 | ≥4.0 |
