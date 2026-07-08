# Output Schema Reference

> Extracted from SKILL.md. Contains output validation rules, AI-assisted analysis content, and decision flow for the planning-north-star skill.

## Output Validation Rules

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
