# Positioning Strategy - Decision Tables & Quality Checks

This file contains the decision rules, quality checks, degradation strategy, and upstream change response tables referenced by `SKILL.md` for the `positioning-strategy` skill.

## Decision Rules

| Condition | Decision |
|------|------|
| Quality gate all 5 pass | Positioning statement can be output |
| Quality gate not passed | Auto-retry up to 3 times; if still fails, escalate to human |
| Differentiation strength <0.5 | Trigger warning, recommend strategy adjustment |
| Blue ocean actions | Requires human approval |
| Competitive factors | Requires human calibration |
| Each dimension score | Requires human calibration of subjective dimensions |
| Composite recommendation | Requires human final judgment |
| Disputed points | Escalate to human decision |
| Excluded user group overlap with core users ≥30% | Reject exclusion recommendation, mark "Exclusion scope conflicts with core users" |
| Excluded user group overlap with core users <30% | Generate exclusion recommendation, mark as "AI suggestion, requires human approval" |
| Potential market reduction ≥50% after exclusion | Mark high risk, mandatory human approval |
| Potential market reduction <50% after exclusion | Normal process, human approval |
| Competitor already covers this excluded user group | Mark "Competitor already covers, exclusion needs differentiation rationale" |
| Exclusion rationale lacks data support (0 data points) | Return for data supplementation, cannot submit for approval |
| Exclusion rationale has ≥2 data points | Can submit for human approval |
| Disputed decision (2+ stakeholders object) | Escalate to multi-party review |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] 3-5 positioning statements generated
- [ ] Each statement uses positioning formula

### P1 Checks (must pass for standard/deep)

- [ ] 5 quality checks completed
- [ ] Recommendation ranking is reasonable
- [ ] Differentiation sources are diverse
- [ ] 5-8 competitive factors extracted
- [ ] Our and competitor scoring completed
- [ ] Blue ocean four actions identified
- [ ] Differentiation strength calculated
- [ ] Scoring basis annotated
- [ ] All 5 dimensions assessed, no omissions
- [ ] Scores have data support, avoid subjective bias
- [ ] Recommendation rationale consistent with scoring logic
- [ ] Action recommendations can be converted to product strategy
- [ ] Exclusion decisions consistent with product vision
- [ ] Clear exclusion rationale
- [ ] Exclusion statement can be clearly communicated to team
- [ ] Alternative recommendations provided for excluded users

### P2 Checks (must pass for deep only)

- [ ] Extended analysis complete (deep simulation and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

When upstream files are missing, this skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| evaluation_report.json (value proposition match) | User provides product value description → generate positioning statement | Lacks value match data, core value may not be precise enough | Request user to provide product core value description or upload evaluation_report.json file |
| competitor-analysis.json (competitor analysis) | User provides product value description → generate positioning statement | Lacks competitor data, differentiation point and competitor reference lack basis | Request user to provide competitor name, positioning, and differentiation description or upload competitor-analysis.json file |
| evaluation_report.json + competitor-analysis.json | User provides product value description → generate positioning statement | Overall confidence reduced, positioning statement lacks data anchoring | Request user to provide product value description and competitor differentiation info |
| All upstream files missing | Prompt user to execute prior phases first, or generate positioning statement based on user-provided product value description | Overall confidence significantly reduced, positioning statement is only hypothetical inference | Request user to provide product value, target user, and competitor difference description |
| User insights data | If user insights data is missing, prompt user to provide or skip steps related to this input | Target user definition may not be precise enough | Request user to provide target user persona and core need description |
| bmc.json | User provides competitor info → draw value curve | Lacks BMC data, our score lacks value proposition anchoring | Request user to provide business model and value proposition description or upload bmc.json file |
| Self-capability assessment (user-provided) | If user does not provide self-capability assessment, prompt user to provide or skip steps related to this input | Feature and scenario differentiation assessment lacks internal data support | Request user to provide product feature completeness and technical capability self-assessment |

### Data Acquisition Notes

This skill requires value proposition match and competitor analysis data. Please provide via one of the following methods:
  1. Directly describe product value, target user, and competitor differences
  2. Upload evaluation_report.json / competitor-analysis.json files
  3. Provide data file path
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| evaluation_report value proposition match change | Core value extraction | Re-execute Step 1, update positioning statement |
| competitor-analysis competitor analysis update | Differentiation point and competitor reference | Re-execute Step 1-2, update differentiation factors |
| persona user persona update | Target user definition | Re-execute Step 1, update target user |
| competitor-analysis competitor data update | Competitor scores and blue ocean actions | Re-execute Step 2, update competitor scores |
| persona/voice-analysis user insights update | Competitive factor extraction | Re-execute Step 2, update competitive factors |
| bmc.json value proposition change | Our scores and blue ocean actions | Re-execute Step 2, update our scores |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Positioning statement change | business-strategy-report, planning-roadmap | Output file version number + change summary |
| Differentiation score change | business-strategy-report | Output file version number + change summary |
| Exclusion decision change | business-strategy-report, business-pricing | Output file version number + change summary |
| Market reduction assessment change | business-pricing | Output file version number + change summary |
