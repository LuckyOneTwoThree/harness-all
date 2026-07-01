---
schema_version: "1.0"
handoff_id: "<OPS-PM-YYYYMMDD-NNN>"
producer: "harness-ops"
consumer: "harness-pm"
created_at: "<ISO-8601>"
source_revision: "<commit-or-artifact-revision>"
supersedes: null
status: draft
ac_ids: []
artifacts: []
---

# Handoff: Ops Feedback to PM (Ops to PM)

> **From**: harness-ops (Operations)
> **To**: harness-pm (Product / Project team)
> **Purpose**: Report online service stability, cost status, or notify of incidents

## 1. SLA Summary

- **Reporting period**: `[YYYY-MM-DD to YYYY-MM-DD]`
- **Core path availability**: `[e.g., 99.99%]`

## 2. Incidents (Incidents)

_If no P0/P1 incidents occurred, fill in "None"_

- **Incident description**: `[what happened, e.g., payment API was down for 15 minutes on Friday night]`
- **Root Cause**: `[why it happened, e.g., upstream API change caused deserialization failure]`
- **Remediation and improvement plan**: `[how it was resolved, how to prevent it in the future]`

## 3. Cost Optimization

- **Resource utilization trends**: `[e.g., CPU utilization 40%, memory 55%, estimated cloud bill this month $500]`
- **Cost reduction recommendations**: `[e.g., idle reserved instances can be released; low-traffic environments can be downgraded]`
- **Budget variance**: `[e.g., actual spend vs. budget this month, variance % and key drivers]`

## 4. Ops Recommendations to Business (Ops Recommendations)

- `[e.g., historical order table queries are extremely slow causing database CPU spikes; recommend PM plan a "hot-cold data separation" requirement in the next version]`
- `[e.g., the current system has a single-point-of-failure risk; request a project to be initiated for multi-AZ disaster recovery refactoring]`
