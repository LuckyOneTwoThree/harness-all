# Stakeholder Analysis - Decision Tables

This file contains the degradation strategy and upstream change response tables referenced by `SKILL.md` for the `stakeholder-analysis` skill.

## Degradation Strategy

When upstream files are missing, this skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| bmc.json | User provides organizational structure and business info → identify stakeholders | Lacks BMC data, key partners and customer relationships may be missed | Request user to provide key business model elements or upload bmc.json file |
| Product/Business Information (user-provided) | If user does not provide product/business info, prompt user to provide or skip steps related to this input | Stakeholder identification lacks business context | Request user to provide product name, core features, and business model description |
| bmc.json + Product/Business Information | User provides organizational structure and business info → identify stakeholders | Overall confidence reduced, stakeholder list may be incomplete | Request user to provide organizational structure, business model, and key partner info |
| All upstream files missing | Prompt user to execute prior phases first, or identify stakeholders based on user-provided organizational structure info | Overall confidence significantly reduced, map is only a general reference | Request user to provide organizational structure, product features, and business goals |
| business-strategy-report.json | User provides strategic key points → generate strategy document and brief | Lacks structured strategy data, strategy-strategy alignment may be insufficient | Request user to provide strategic direction and key strategy points or upload business-strategy-report.json file |
| stakeholder-analysis.json (brief section) | If strategic brief is missing, does not affect core document generation | Brief content needs to be re-extracted from strategy report | Request user to provide stakeholder analysis summary or upload stakeholder-analysis.json file |

### Data Acquisition Notes

This skill requires business model canvas and product/business information. Please provide via one of the following methods:
  1. Directly provide organizational structure, product name, and business model
  2. Upload bmc.json file
  3. Provide data file path
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| bmc.json key partner change | External stakeholder identification | Re-execute Step 1, update external stakeholders |
| bmc.json customer relationship change | Affected party identification | Re-execute Step 1, update affected parties |
| Organizational structure change | Decision makers and resource controllers | Re-execute Step 1, update decision makers and resource controllers |
| business-strategy-report strategy adjustment | Background & current state, opportunities & challenges | Re-execute Step 2, update strategic context and opportunity/challenge analysis |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| Stakeholder list change | business-strategy-report | Output file version number + change summary |
| Strategy adjustment | business-strategy-report | Output file version number + change summary |
| Risk contingency update | business-strategy-report | Output file version number + change summary |
| Brief content change | No specific downstream | Output file version number + change summary |
