<!-- Reference material extracted from SKILL.md, consult as needed -->

# Upstream Change Response

## Upstream Input Change Response Strategy

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| OKR data change | Define phase goal definition | Redefine goals, update KR baselines and target values |
| KR progress change | Analyze phase data analysis | Update deviation analysis, re-evaluate Conclude options |
| Experiment results change | Analyze and Conclude phases | Update experiment data, re-evaluate decision options |
| Analysis results update | Insight narrative and decision options | Update insight narrative, re-evaluate decision options |
| Business context change | Action recommendations and priority | Re-evaluate action recommendations, update priority |
| Historical insight library update | Duplicate insight detection | Perform deduplication check, merge similar insights |

## Downstream Notification Mechanism

When DACE status/insights themselves change, the notification mechanism for downstream:

| Status/Insight Change Type | Notification Scope | Notification Method |
|-------------------|----------|----------|
| Conclude phase decision completed | decision-culture | Mark decision complete, trigger report update |
| Execute phase execution effectiveness | decision-culture | Mark execution effectiveness, trigger culture report update |
| KR progress behind >20% | decision-culture | Mark progress risk, trigger weekly report risk annotation |
| data_decision type insight | decision-culture | Mark as auto-executable, trigger report update |
| data_reference type insight | decision-culture | Mark as requiring human confirmation, trigger report update |
| Insight merge/confidence increase | decision-culture | Mark insight update, trigger report update |
