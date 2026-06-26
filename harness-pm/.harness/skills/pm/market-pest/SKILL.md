---
name: market-pest
description: Used when scanning the target market's policies and regulations, economic indicators, social trends, and technology dynamics. PEST auto-scan, outputs four-dimension trend summaries and impact assessments, tiered signal alerts, real-time alerts for major changes. Keywords: PEST analysis, policies and regulations, economic indicators, social trends, technology dynamics, environmental scanning, tiered signal alerts, external environment, policy impact, market trends.
---
# PEST Auto-Scan

## When to use
- What's changed in the market environment
- How do policies affect us
- Help me scan the external environment

## Outputs
- docs/discovery/market-analysis.md
- memory/progress.md

## Core Principles

1. **All four dimensions required** — All four PEST dimensions must be scanned; analysis missing any dimension is incomplete. When data is insufficient, fill with industry benchmark values and mark as "inferred value".
2. **Tiered signals, not flat listing** — Not all trends are equally important. Signals with impact degree ≥ 4 trigger alerts; signals < 3 are routed to routine monitoring. Resources focus on high-impact signals.
3. **Timeliness annotation** — Each signal is annotated as "occurred / occurring / expected to occur". Signals of different timeliness require completely different response strategies: occurred signals need immediate response, expected signals need advance preparation.
4. **Impact path traceability** — Each trend must be linked to a category impact path (e.g., "rising compliance costs → higher entry barriers for SMBs"). Trends not linked to an impact path are noise.

## Interaction Mode

🤖 AI auto-execution

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| category_keywords | string | Yes | User-provided | Category keywords, e.g., "online education", "SaaS CRM" |
| target_market | string | Yes | User-provided | Target market, e.g., "Mainland China", "Southeast Asia" |

## Execution Steps

### Step 1: Scheduled Scan [Core]

Collect information and monitor across four dimensions:

| Dimension | Scan Scope | Data Sources |
|------|---------|--------|
| Political | Industry regulatory policies, entry licenses, compliance requirements, data privacy laws, tax policies, subsidy policies | Government websites, regulatory databases, industry association announcements, policy interpretation media |
| Economic | GDP growth, industry growth rate, consumer spending, financing environment, exchange rate fluctuations, inflation rate | Statistics bureau data, central bank reports, third-party economic databases |
| Social | Demographic changes, consumption habit shifts, cultural trends, user preference evolution, lifestyle changes | Social media trends, user research reports, census data, lifestyle research |
| Technological | New technology maturity, technology adoption curves, infrastructure evolution, technology standard changes, patent trends | Tech media, patent databases, Gartner/IDC technology reports, open source community dynamics |

### Step 2: Trend Summary [Core]

Produce a structured summary of information collected for each dimension:

- Extract core trends (3-5 per dimension)
- Annotate trend direction (rising / declining / stable / emerging)
- Annotate trend strength (strong / medium / weak)
- Link to category impact path

### Step 3: Key Change Signals [Core]

Identify key change signals from the trend summary:

- Signal type: new policy release / indicator mutation / trend inflection / technology breakthrough
- Signal timeliness: occurred / occurring / expected to occur
- Signal source and verifiability

### Step 4: Impact Assessment [Core]

Assess the impact of each key change signal:

| Assessment Dimension | Description |
|---------|------|
| Impact direction | Positive (opportunity) / Negative (threat) / Neutral |
| Impact degree | 1-5 scale (1 = minimal impact, 5 = disruptive impact) |
| Impact time window | Short-term (<6 months) / Medium-term (6-18 months) / Long-term (>18 months) |
| Impact scope | Category only / Whole industry / Cross-industry |
| Response recommendation | Leverage strategy / Avoidance strategy / Monitoring strategy |

### Step 5: Major Change Alerts [Core]

Trigger alerts for high-impact signals:

- Filter signals with impact degree ≥ 4
- Generate alert summary: signal description + impact assessment + response recommendation
- Push to human PM in real time

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | PEST analysis conclusions | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full analysis + policy impact projection + trend forecasting + strategic response recommendations | Full artifact + extended analysis + deep projection |

## Output

Output file: `docs/discovery/market-analysis.md ("PEST Analysis" section)`

**Output Schema**, validation rules, and JSON example:

> See [Reference/output-schema-validation-example.md](./Reference/output-schema-validation-example.md) for the output JSON schema (political/economic/social/technological dimensions + alerts), the full field validation rules table (per-dimension trends and key_signals with impact assessment), and a complete PEST analysis JSON example.

## Decision Rules

| Rule | Trigger Condition | Action |
|------|---------|------|
| Real-time alert | Impact degree ≥ 4 | Real-time alert to human PM, push signal description + impact assessment + response recommendation |
| Routine monitoring | Impact degree < 3 | Route to routine monitoring list, no alert triggered |
| Signal escalation | Signal source unverifiable or contradictory | Mark as needing human confirmation, lower confidence |
| Data source reliability < 0.5 | Mark as "unreliable data source", suggest human verification or alternative data source |
| PEST dimension data missing | Mark as "dimension data incomplete", fill with industry benchmark values and mark as "inferred value" |

## Quality Checks

- [ ] Political dimension scanned
- [ ] Economic dimension scanned
- [ ] Social dimension scanned
- [ ] Technological dimension scanned
- [ ] At least 3 trend summaries per dimension
- [ ] Key change signals identified
- [ ] Impact assessment completed (direction + degree + time window)
- [ ] Major changes (impact degree ≥ 4) alerted
- [ ] Data source annotated | Each PEST dimension annotates data source and reliability | Dimensions without source annotation marked as "unknown source"

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| No strong dependencies | This Skill can run independently; user provides category and target market to execute | Output complete, no impact | Require user to provide category keywords and target market |
| All upstream files missing | User provides category keywords and target market → scan PEST four-dimension trends based on AI knowledge base | Trend data inferred from AI knowledge base, confidence marked as "inferred value", timeliness may lag | Require user to provide category keywords (e.g., "online education") and target market (e.g., "Mainland China") |
| If user does not provide category_keywords | Prompt user to provide category keywords, otherwise scan scope cannot be determined | Cannot generate output, flow interrupted | Require user to provide category keywords (e.g., "online education", "SaaS CRM") |
| If user does not provide target_market | Prompt user to provide target market, otherwise default to "Mainland China" | Target market defaults to "Mainland China", trends for other markets may be missed | Require user to provide target market name (e.g., "North America", "Southeast Asia") |

## Data Acquisition Notes

This Skill requires category keywords and target market information. Please provide via one of the following:
  1. Directly input category keywords (e.g., "online education", "SaaS CRM") and target market (e.g., "Mainland China")
  2. Upload industry analysis data files
  3. Provide data file paths
- AI is not responsible for external data collection, only analysis

## Upstream Change Response

### Upstream Change Impact Table

| Upstream File | Change Type | Affected PEST Dimension | Impact Description |
|---------|---------|-------------|---------|
| tam-som.json | Market size data change | Economic | TAM/SAM/SOM size adjustments directly affect industry growth rate and market capacity trend judgments in economic indicators |
| competitor-analysis.json | Competitor technology dynamics change | Technological | Competitor new technology adoption, patent portfolio and other dynamics affect technology maturity and adoption curve judgments in the technology dimension |
| competitor-analysis.json | Competitor compliance strategy change | Political | Competitor regulatory response strategy changes can reverse-infer policy enforcement intensity and trend direction |
| tam-som.json | Regional market data change | Social | Regional market user size and penetration rate changes affect consumption habits and user preference judgments in social trends |

### Downstream Notification Mechanism Table

| PEST Change Type | Trigger Condition | Notify Downstream | Notification Content |
|-------------|---------|---------|---------|
| Major political change | Political dimension signal with impact degree ≥ 4 | market-competitor-analysis | Policy change summary, impact assessment, competitor response recommendations |
| Major political change | Political dimension signal with impact degree ≥ 4 | market-tam-som | Policy change impact assessment on market access and size, recommend re-estimating TAM/SAM/SOM |
| Major economic change | Economic dimension signal with impact degree ≥ 4 | market-tam-som | Economic indicator change summary, recommend re-evaluating market size and growth rate |
| Major technological change | Technological dimension signal with impact degree ≥ 4 | market-competitor-analysis | Technology breakthrough summary, impact assessment, recommend updating technology dimension in competitor Feature Matrix |
| Major social change | Social dimension signal with impact degree ≥ 4 | market-tam-som | Social trend change summary, recommend re-evaluating target user size and penetration rate |
