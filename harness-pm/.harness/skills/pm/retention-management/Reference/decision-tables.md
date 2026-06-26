# Retention Management - Decision Tables

This file contains the degradation strategy, upstream change response, and downstream notification tables referenced by `SKILL.md` for the `retention-management` skill.

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| User behavior data missing | User provides user activity data → analyze churn characteristics | Churn attribution inferred from activity data, behavioral characteristic analysis limited | Require user to provide user activity data (active user count per period, churned user count) |
| No behavior data | Infer based on user interviews, mark confidence ≤0.3 | Churn characteristics inferred from interviews, low confidence, requires manual verification | Require user to provide user interview records and churned user descriptions |
| Churn history missing | Skip churn trend comparison, analyze only based on current data | Cannot assess churn trend changes | Require user to provide historical churn rate and churned user count trend data |
| User behavior data + churn history both missing | User provides user activity data → analyze churn characteristics | Output basic churn analysis, intervention strategies marked "pending validation" | Require user to provide user activity data and churn definition criteria |
| Lifecycle stage missing | Use generic lifecycle model (new/active/dormant/churned), marked "pending confirmation" | Segmentation criteria based on generic assumptions | Require user to provide user lifecycle stage definition and segmentation criteria |
| User behavior data + lifecycle stage both missing | User describes user groups → generate segmentation strategy | Output segmentation strategy based on description, marked "pending data validation" | Require user to provide user group description and core behavioral characteristics |
| User account data missing | Skip account-level churn analysis, analyze only based on aggregated data | Cannot identify high churn risk accounts | Require user to provide user account list, payment status, and activity data |

### Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degraded generation:
- **User activity data**: Active user count and churned user count per period
- **Churn definition** (optional): The product's definition criteria for churned users
- **High-value user proportion** (optional): Proportion of high-value users among active users
- **User group description**: Main types and characteristics of product users
- **Activity distribution** (optional): Proportion of high/medium/low activity users
- **Operation resources** (optional): Resources and channels available for user operations

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Source | Change Type | Impact Scope | Response Action |
|----------|----------|----------|----------|
| Data analytics platform - active logs | Behavioral event definition change | Churn signal features and model training | Update feature engineering, retrain model |
| Data analytics platform - churn records | Churn definition change | Churn labels and risk thresholds | Re-label per new definition, adjust thresholds |
| User system - account info | User attribute change | Risk tiering and intervention strategy | Update user characteristics, adjust intervention matching |
| User-provided - lifecycle | Milestone definition change | Segmentation criteria and strategy triggers | Adjust segmentation conditions and trigger rules |

### Downstream Notification Mechanism Table

| Downstream Consumer | Notification Condition | Notification Method | Notification Content |
|------------|----------|----------|----------|
| revenue-upsell | High-value user segmentation change | Write to output file | High-value user list and upgrade signals |
| retention-orchestrator | Churn prediction and tiered operations complete | Output file updated | Retention management completion status and key conclusions |
