# monitoring-alert-detection Degradation Strategy

> This document is split from the monitoring-alert-detection SKILL.md and contains the upstream file missing degradation plan and data acquisition notes.

## Upstream File Missing Degradation Plan

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Metrics system | User provides core business metric list, supplement golden signals based on generic metric template | Basic monitoring metric config, lacks metrics system support |
| Product architecture | User provides service component list, infer dependencies based on generic microservice architecture | Basic core path list, dependencies are inferred |
| SLA requirements | User provides availability targets for key services, use industry default thresholds (99.9%/99.5%/99%) | Alert rules based on default thresholds |
| Existing monitoring | Skip compatibility check, generate monitoring config from scratch | Brand-new monitoring config |
| Release info | Skip change correlation analysis, mark "cannot exclude change factors" in anomaly detection | Detection results excluding change correlation |
| Config change records | Skip config change correlation, mark "cannot exclude config change factors" in anomaly detection | Detection results excluding config correlation |
| Traffic change data | Skip traffic analysis dimension, mark traffic data missing in anomaly detection | Detection results missing traffic dimension |
| User roles | Use default role template (Executive/Engineering/On-Call), user adjusts later | Generic role Dashboard template |
| Existing Dashboard | Generate Dashboard config from scratch, mark potential conflicts with existing config | Brand-new Dashboard config |
| On-Call schedule | User provides current on-call contact info, AI configures escalation chain based on this | Escalation chain based on user input |
| Alert rules | Use default escalation rules (Critical 5min/High 15min/Medium 1h), mark for human confirmation | Escalation config based on default rules |
| Knowledge base | On-Call handbook does not include historical case references, mark "no historical cases" | On-Call handbook without historical references |

## Data Acquisition Notes

When upstream files are missing, obtain necessary data through the following methods:

1. **Metrics system missing**: Ask user to provide core business metric list (e.g., order volume, conversion rate, DAU, etc.); AI will auto-supplement generic golden signals (latency, traffic, error rate, saturation) based on product type
2. **Product architecture missing**: Ask user to provide service component list or system name list; AI will infer service dependencies based on generic architecture patterns, and mark inferred items for human confirmation in output
3. **SLA requirements missing**: Ask user to provide availability targets for key services (e.g., "Payment service needs 99.9% availability"); services not specified use industry default standards, with default values marked in output for human review
4. **Alert data missing**: Ask user to describe anomaly phenomena, including: symptom manifestations, occurrence time, affected services/features, impact scope (user count/feature points); AI will classify anomalies based on the description
5. **Context data missing** (release/config change/traffic change): AI will explicitly mark factors that cannot be excluded in anomaly detection, recommending manual investigation of these dimensions
6. **User roles missing**: Use default role template to generate Dashboards, including three standard views: Executive overview, Engineering details, On-Call real-time; user can adjust based on actual role needs
7. **On-Call schedule missing**: Ask user to provide current on-call personnel names and contact info (phone/Slack/email); AI will configure escalation notification chain based on this
8. **Alert rules missing**: Use default escalation rule template (Critical→5min→L1/L2/L3, High→15min→L1/L2); mark default rules in output for human review and confirmation
