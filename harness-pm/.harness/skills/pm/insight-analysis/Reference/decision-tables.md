# Insight Analysis - 决策表

本文档收录 Insight Analysis Skill 的情感/社交映射规则、行业阈值适配、降级策略与上下游变更响应表。

## Step 1a-2: Emotional Mapping Rule Library

| Negative expression pattern | Emotional need direction | Confidence baseline |
|-------------|-------------|-----------|
| "Too cumbersome" / "Too complex" / "Too many steps" | Desire for ease/effortlessness | 0.8 |
| "Worried" / "Concerned" / "Afraid of errors" | Desire for security/certainty | 0.75 |
| "Anxious" / "Rushed" / "No time" | Desire for control/efficiency | 0.75 |
| "Ignored" / "No one responds to me" / "No response to feedback" | Desire for recognition/attention | 0.7 |
| "Too slow" / "Waited too long" / "Slow response" | Desire for instant feedback/fluency | 0.8 |
| "Can't understand" / "Don't know how to use" | Desire for clarity/simplicity/understandability | 0.75 |

Confidence adjustment: single evidence ×0.7, 2-3 pieces ×0.85, 4+ pieces ×1.0

## Step 1a-3: Social Mapping Rule Library

| Social expression pattern | Social need direction | Confidence baseline |
|-------------|-------------|-----------|
| "Colleagues are all using it" / "Others are using it too" | Social approval/belonging | 0.7 |
| "Boss requires it" / "Company policy" | Compliance/obedience to authority | 0.8 |
| "Industry standard" / "Competitors all have it" | Industry recognition/competitiveness | 0.7 |
| "Recommend to friends" / "Share with colleagues" | Social currency/desire to share | 0.7 |

Confidence adjustment rules same as Emotional Job.

## Step 3-2: Industry Threshold Adaptation Rules

| Industry/Stage | Adaptation rule | Adjustment description |
|---|---|---|
| B2B SaaS | Must-be threshold lowered: negative mention rate > 50% qualifies as Must-be | B2B users have lower tolerance for missing basic features |
| B2C Consumer | Attractive threshold raised: positive mention rate > 70% qualifies as Attractive | B2C users are more likely to give positive feedback |
| Early-stage product | Overall threshold relaxed: lower judgment threshold when data volume is insufficient (confidence 0.5 is sufficient for classification) | Early data is limited |
| Mature product | Strict threshold: use standard thresholds when data is sufficient, confidence <0.7 must escalate | Mature products have sufficient data |

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|----------|------------|
| voice-analysis.json | Extract JTBD and KANO classification based on feedback text directly pasted by user | Emotional/Social Job inference basis reduced, KANO classification confidence lowered | Ask user to provide user feedback text or upload voice-analysis.json file |
| behavior-analysis.json | Infer behavioral intent based on user feedback text | Functional Job lacks behavior data corroboration, frequency statistics imprecise | Ask user to provide behavior event logs or upload behavior-analysis.json file |
| voice-analysis.json + behavior-analysis.json | User provides feedback text → directly extract JTBD | Overall confidence reduced, frequency is an estimated value | Ask user to provide user feedback text and behavior event logs |
| Raw requirement list | User dictates requirements → directly decompose three layers | inference_basis lacks data corroboration, behavioral requirement confidence capped at 0.7 | Ask user to provide requirement list text or product requirements document |
| All upstream files missing | Prompt user to execute preceding stages first, or execute lightweight analysis based on user's verbal description | Output is lightweight version; JTBD contains only Functional Job; KANO all classifications are inferred; priority_scoring uses default values for multiple dimensions | Ask user to provide user feedback text, behavior data, and requirement list |

## Upstream Change Impact Table

| Upstream data source | Change type | Impact dimension | Impact description | Response strategy |
|-----------|----------|----------|----------|----------|
| voice-analysis.json | New feedback entries added | jtbd.jobs / kano.kano_classification | Job frequency and evidence change, KANO classification metrics change | Annotate affected Jobs and KANO classifications, recommend human confirmation on whether re-extraction is needed |
| voice-analysis.json | Sentiment classification correction | jtbd.emotional_jobs | Emotional Job inference basis changes | Annotate affected Emotional Jobs, recommend re-evaluating confidence |
| behavior-analysis.json | Behavior pattern update | jtbd.functional_jobs / requirement_layers.behavioral | Functional Job frequency and behavior goals change | Annotate affected Functional Jobs, update frequency |
| Raw requirement list | Requirement additions/deletions | requirement_layers / kano / priority_scoring | Requirement decomposition, classification, and scoring all affected | Annotate added/deleted requirements, recalculate ranking |

## Downstream Notification Mechanism Table

| Downstream consumer | Notification field | Notification timing | Notification content |
|-----------|----------|----------|----------|
| opportunity-definition | `jtbd.jobs` / `requirement_layers` | After JTBD or requirement layer changes | Notify Job additions/deletions and requirement decomposition changes |
| prd-orchestrator | `priority_scoring.priority_list` | After priority ranking changes | Notify requirements with ranking changes, recommend re-evaluating development scheduling |
