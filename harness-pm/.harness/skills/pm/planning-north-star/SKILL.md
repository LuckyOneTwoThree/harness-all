---
name: planning-north-star
description: Use when you need to determine product core metrics, OKR North Star Metric, or design a metric system. North Star Metric selection. AI assists in selecting the metric that best measures product success and user value. This is a human decision point — AI provides data support, humans make the final choice. Keywords: North Star Metric, core metric, metric selection, product success metric, NSM, key metric, what data to look at.
---
# North Star Metric Selection

## When to use
- What should our core metric be
- How do we measure product success

## Outputs
- memory/progress.md
- memory/knowledge-base.md
- docs/strategy/PRODUCT_STRATEGY.md
- output/metrics/north-star.json

## Core Principles

1. **Multi-candidate comparison** — Generate 3-5 candidate metrics, score them across four dimensions, and recommend; humans make the final choice
2. **Value-Business dual anchor** — The North Star must link to both user value and business success; neither can be missing

## Ownership Boundary (division of labor with metrics-system)

This skill owns **North Star SELECTION** only:
- Candidate generation (3-5 candidates with four-dimension scoring)
- Human decision (final selection by product owner)
- Output: `north-star.json` + PRODUCT_STRATEGY.md "North Star" section

`metrics-system` owns **North Star VALIDATION + breakdown**:
- Validates the selected North Star (vanity-metric detection, product-type-fit scoring)
- Breaks it down into L1/L2 metric hierarchy
- Builds the full metrics system (tracking-plan, dashboard)
- If metrics-system's validation score < 0.6, it suggests re-selecting — in that case, return to this skill for re-selection.

**Routing rule**: planning-north-star runs first (selection) → metrics-system runs second (validation + breakdown). Do NOT invoke metrics-system's "North Star Not Defined" auto-recommendation branch when planning-north-star has already produced candidates.
3. **Input variables must be actionable** — The recommended metric must be decomposed into 3 quantifiable, trackable, and influenceable input variables
4. **Gaming-resistant design** — Assess the risks of the metric being gamed, becoming invalid, or misleading, and provide warnings

## Interaction Mode
👤→🤖 Human executes, AI assists

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| User value data | JSON | Yes | user-research-user-modeling / user-research-voice-analysis | User value data from the exploration phase |
| BMC business model canvas | JSON | Yes | docs/strategy/business-strategy.md ("Business Model Canvas" section) | Value proposition, revenue streams |
| Business status data | JSON | ○ | Provided by user | Current business metrics, user scale |

## Execution Steps

### Step 1: Candidate Metric Generation [Core]

Generate 3-5 North Star Metric candidates based on input data:

- Extract value proposition keywords from BMC and map them to quantifiable metrics
- Extract core user behaviors from user value data and convert them into behavioral metrics
- Extract existing metrics from business status data and evaluate whether they are suitable as the North Star
- Each candidate metric must include: metric name, calculation formula, data source, update frequency

### Step 2: Four-Dimension Scoring [Core]

Score each candidate metric on a 1-5 scale across 4 dimensions:

| Dimension | Scoring Criteria |
|------|----------|
| Relationship to core value | 5 = directly measures user value realization; 3 = indirectly related; 1 = unrelated |
| Correlation with business success | 5 = strongly correlated with revenue/growth; 3 = weakly correlated; 1 = unrelated |
| Actionability | 5 = team can directly influence; 3 = partially influenceable; 1 = cannot influence |
| Measurability | 5 = clear data definition + automated collection; 3 = requires manual collection; 1 = cannot be collected |

**Composite score = 0.3 × value relationship + 0.3 × business correlation + 0.2 × actionability + 0.2 × measurability**

### Step 3: Recommendation and Alternatives [Core]

- Metrics with composite score ≥ 4.0 are recommended as the North Star Metric
- Metrics with composite score 3.0-4.0 are alternative metrics
- Metrics with composite score < 3.0 are marked with the reason for elimination
- The recommended metric must be validated for alignment with the BMC value proposition and OKR

### Step 4: Input Variable Definition [Core]

Define 3 key input variables (drivers) for the recommended metric:

- Each input variable must be quantifiable, trackable, and influenceable
- The causal relationship between input variables and the North Star Metric must be explicit
- Annotate the data source and collection method for each input variable

### Step 5: Driving Feature Mapping [Core]

Define 2-4 feature candidates that can directly influence the recommended metric:

- Each feature must be tagged with priority (P0/P1/P2) and expected lift
- Features must be derived from user research and strategic analysis, not invented
- Feature descriptions are placeholders, awaiting design-prd to generate specific feature_id

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Recommended North Star Metric and input variables | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Complete artifact, including all Step outputs |
| deep | Full analysis + metric correlation matrix + gaming risk assessment + metric evolution roadmap | Full artifact + extended analysis + deep reasoning |

## Output

**Storage path**: `docs/strategy/PRODUCT_STRATEGY.md ("North Star" section)`

**Output file**: north_star.json → `output/metrics/north-star.json`

### Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| north_star_metric.recommended.metric_name | string | Yes | Recommended North Star Metric name |
| north_star_metric.recommended.definition | string | Yes | Metric definition and calculation formula |
| north_star_metric.recommended.relationship_to_value | string | Yes | Description of relationship to user value |
| north_star_metric.recommended.relationship_to_business | string | Yes | Description of relationship to business success |
| north_star_metric.recommended.measurement.data_source | string | Yes | Data source |
| north_star_metric.recommended.measurement.calculation | string | Yes | Calculation formula |
| north_star_metric.recommended.measurement.frequency | string | Yes | Update frequency |
| north_star_metric.recommended.drives_features | array | Yes | List of driven features |
| north_star_metric.recommended.drives_features[].feature_priority | string | Yes | Priority of the corresponding feature (P0/P1/P2) |
| north_star_metric.recommended.drives_features[].feature_description | string | Yes | Feature description (placeholder, awaiting design-prd to generate specific ID) |
| north_star_metric.recommended.drives_features[].expected_lift | string | Yes | Expected lift of the feature on the metric |
| north_star_metric.alternatives | array | Yes | At least 2 alternative metrics |
| north_star_metric.alternatives[].fit_score | number | Yes | Alternative metric fit score 0-1 |
| north_star_metric.analysis_summary.recommendation_rationale | string | Yes | Recommendation rationale |

```yaml
north_star_metric:
  recommended:
    metric_name: "Weekly Active Users (WAU)"
    definition: "Number of unique users who visited at least once in the past 7 days"
    relationship_to_value: "Measures the frequency of users' continued product usage, reflecting the sustained value the product provides to users"
    relationship_to_business: "Highly correlated with ad revenue and paid conversion, a key metric for the growth engine"
    actionability: "High — can be improved through product optimization, content operations, and push strategies"
    measurement:
      data_source: "User behavior logs"
      calculation: "COUNT(DISTINCT user_id WHERE last_active <= 7 days)"
      frequency: "Daily update"
      owner: "Growth team"
    drives_features:
      - feature_priority: "P0"
        feature_description: "Personalized recommendation homepage"
        expected_lift: "15% WAU lift"
      - feature_priority: "P0"
        feature_description: "Daily check-in system"
        expected_lift: "8% WAU lift"
      - feature_priority: "P1"
        feature_description: "Content sharing feature"
        expected_lift: "5% WAU lift"
  alternatives:
    - metric_name: "Daily Active Users (DAU)"
      pros: "Strong real-time responsiveness"
      cons: "High volatility, low stability"
      fit_score: 0.75
      drives_features: []
    - metric_name: "Monthly Active Users (MAU)"
      pros: "Good stability, reflects long-term user base"
      cons: "Slow response, hard to detect issues in time"
      fit_score: 0.70
      drives_features: []
    - metric_name: "User Engagement Score"
      pros: "Comprehensively reflects user engagement"
      cons: "Subjective definition, hard to standardize"
      fit_score: 0.65
      drives_features: []
  analysis_summary:
    recommendation_rationale: "WAU balances real-time responsiveness and stability, has strong correlation with both user value and product business success, and the team has a clear path to improve it"
    implementation_notes: "Need to establish a user ID system and 7-day active calculation logic; recommend monitoring in parallel with DAU"
    warning: "Be aware of the difference in activity patterns between new and existing users"
```

## AI-Assisted Analysis Content

AI should provide the following analytical support:

1. **Candidate metric pool**
   - Analyze possible metrics based on BMC
   - Analyze related metrics based on user value data
   - Recommend metrics based on industry benchmarks

2. **Correlation analysis**
   - Correlation analysis between each metric and revenue
   - Correlation analysis between each metric and retention
   - Correlation matrix between metrics

3. **Trend analysis**
   - Historical trends of each candidate metric
   - Attribution analysis of metric changes
   - Predict future metric changes

4. **Risk assessment**
   - Metric gaming risk
   - Metric invalidation risk
   - Metric misleading risk

### Decision Flow

```
1. Human initiates the request
2. AI analyzes and recommends metric candidates
3. Human evaluates candidate metrics
4. AI provides detailed analytical support
5. Human discusses and selects
6. AI records the decision and rationale
7. Human confirms the final metric
```

## Decision Rules

1. **Human decision**: North Star Metric selection is a human decision point
2. **AI support**: AI only provides analytical support, does not make the final decision
3. **Multi-party involvement**: Recommend involving product, engineering, and business stakeholders in the discussion

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] At least 3 metric candidates analyzed
- [ ] Each candidate has 5-dimension evaluation

### P1 Checks (must pass for standard/deep)

- [ ] Correlation analysis completed
- [ ] Risk assessment provided
- [ ] Final selection has human confirmation record
- [ ] Selection rationale recorded
- [ ] drives_features[] is non-empty and contains at least 2 P0/P1 features
- [ ] Each driving feature has an expected lift description

### P2 Checks (only required for deep)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision record complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files are missing, this Skill can still execute independently:

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| User value data (voice-analysis / persona) | User provides product description → recommend North Star candidates | Lacking user value data, the correlation between metric and user value may be weak | Ask user to provide a description of core user value or upload persona.json/voice-analysis.json files |
| bmc.json | User provides product description → recommend North Star candidates | Lacking BMC data, the correlation between metric and business model may be weak | Ask user to provide a business model description or upload bmc.json file |
| User value data + bmc.json | User provides product description → recommend North Star candidates | Overall confidence reduced, metric lacks value-business dual anchoring | Ask user to provide product core value and business model description |
| All upstream files missing | Prompt user to execute prior phases first, or recommend North Star candidates based on user-provided product description | Overall confidence significantly reduced, recommendation is only a general industry reference | Ask user to provide product description, core value, and business model information |
| Business status data (user-provided) | If user does not provide business status data, prompt user to provide or skip steps related to this input | Lacking baseline data, unable to assess current metric status | Ask user to provide current core metric values (e.g., DAU, retention rate, revenue, etc.) |

## Data Acquisition Instructions

This Skill requires user value data and BMC data. Please provide via one of the following methods:
  1. Directly describe the product's core value and business model
  2. Upload persona.json / voice-analysis.json / bmc.json files
  3. Provide the data file path
- AI is not responsible for external data collection, only for analysis

---

## Upstream Change Response

### Upstream Change Impact Table

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| bmc.json value proposition change | Candidate metrics' correlation with value proposition needs re-evaluation | Re-execute Step 1-2, update candidate metrics and scores |
| bmc.json revenue model change | Metric's correlation with business success | Re-score the business correlation dimension |
| persona/voice-analysis user value update | Candidate metric pool and user value correlation | Re-execute Step 1, update candidate metrics |

### Downstream Notification Mechanism Table

| Change Type | Impact Scope | Notification Method |
|----------|----------|----------|
| North Star Metric change | planning-okr, planning-roadmap, design-prd | Output file version number + change summary |
| Input variable definition change | planning-okr | Output file version number + change summary |
| Candidate metric scoring change | planning-okr | Output file version number + change summary |
| drives_features change | design-prd | Output file version number + change summary |
