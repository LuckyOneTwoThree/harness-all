# Iteration Retrospective - 决策表

本文档收录 Iteration Retrospective Skill 的降级策略、上游变更响应与下游通知机制表。

## Degradation Strategy - Upstream File Missing

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Current iteration plan | User describes reasons and expectations for adjustment, AI generates adjustment plan based on description | Adjustment plan based on user description, lacks plan data validation |
| Iteration completion | User provides iteration completion (completed/incomplete items, story points), AI generates retrospective based on provided data | Retrospective report based on user input, lacks system data |
| Resource constraints | Skip capacity validation, mark "manual capacity confirmation required" in plan | Adjustment plan without capacity validation |
| Trigger event | User provides adjustment trigger reason (anomaly/feedback/strategic change), AI assesses accordingly | Impact assessment based on user input |
| Change requirements | User dictates items to add/remove/modify, AI organizes into structured change requirements | User dictation converted to structured change list |
| Quality metrics | User provides defect count and rework data, AI performs quality analysis directly | Quality analysis based on user input |
| Team feedback | Skip collaboration analysis dimension, mark "team feedback data missing" | Retrospective without collaboration dimension |
| Monitoring data | Skip monitoring data analysis, mark "stability data missing" in retrospective | Retrospective without stability dimension |
| Monitoring alerts | Skip alert correlation analysis, urgent priority strategy unavailable | Adjustment plan without alert correlation |

## Data Acquisition Instructions

When upstream files are missing, obtain necessary data through the following methods:

1. **Current iteration plan missing**: Please describe the reason for adjustment (e.g., "payment feature has online issue requiring insertion"), AI will generate adjustment plan based on description, including insert/replace/postpone options
2. **Iteration completion missing**: Please provide iteration completion, including: planned story points/actual completed story points, incomplete items and reasons, requirement changes; AI will generate retrospective report based on provided data
3. **Resource constraints missing**: Skip capacity matching validation during plan generation, all plans marked "manual team capacity confirmation required"; recommend supplementing resource data later
4. **Trigger event missing**: Please explain the adjustment trigger reason and urgency, AI will perform impact assessment and plan generation accordingly
5. **Change requirements missing**: Please dictate items to add/remove/modify, AI will organize into structured change list
6. **Quality metrics missing**: Please provide key quality data (Bug count, severity distribution, rework count); AI will perform quality dimension analysis accordingly
7. **Team feedback missing**: Skip collaboration analysis dimension, mark this dimension as data missing in retrospective; recommend supplementing through Retro meeting later
8. **Monitoring data missing**: Skip stability analysis, mark stability data missing in retrospective; recommend exporting from monitoring system to supplement
9. **Monitoring alerts missing**: Skip alert correlation analysis, cannot auto-promote urgent item priority; recommend user manually flag urgent items

## Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| Project management system | Iteration plan change | Change impact assessment baseline | Reassess change impact |
| Project management system | Resource constraint change | Plan capacity validation | Re-validate plan feasibility |
| Project management system | Iteration completion data update | Delivery dimension analysis | Update completion rate and story point statistics |
| Test platform/CI/CD | Quality metrics change | Quality dimension analysis | Update defect statistics and coverage |
| monitoring-alert-detection | Alert data update | Urgent priority strategy | Update alert correlation and priority promotion |

## Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| iteration-orchestrator | Iteration retrospective full process complete | Output file update | Retrospective completion status and key conclusions |
| iteration-backlog-grooming | Improvement suggestions generation complete | Output file update | Improvement items flow back to Backlog for next grooming round |
