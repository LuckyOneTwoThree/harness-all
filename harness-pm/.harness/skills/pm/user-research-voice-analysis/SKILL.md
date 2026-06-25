---
name: user-research-voice-analysis
description: Used when extracting sentiment, themes, and pain points from user reviews, support tickets, social media mentions, and community posts. Large-scale user voice analysis pipeline. Keywords: user voice analysis, VOC, sentiment analysis, pain point extraction, user feedback analysis, user complaints, user reviews, user feedback.
---
# Large-Scale User Voice Analysis

## When to use
- What are users complaining about
- Help me analyze user feedback
- How are the user reviews

## Outputs
- docs/discovery/user-research.md
- memory/progress.md

## Core Principles

1. **Verbatims over summaries** — User's original words are more persuasive than AI summaries; every pain point must be supported by a representative verbatim
2. **Pain points are tiered, not flat-listed** — Score and tier by impact × pain degree × frequency; do not output an unprioritized pain point list
3. **Sentiment is signal, not noise** — Negative emotions point to real pain points; mixed emotions point to unmet expectations; both require in-depth analysis
4. **Data volume determines credibility** — When feedback volume < 500 entries, conclusions are downgraded to "exploratory" with a confidence cap of 0.5

## Interaction Mode

🤖 **AI auto-executes** — No human intervention required; fully automated end-to-end

---

## Inputs

| Input | Type | Required | Source | Description |
|--------|------|------|------|------|
| app_reviews | JSON | Yes | User-provided | App store review data (App Store / Google Play) |
| support_tickets | JSON | Yes | User-provided | Customer support ticket system data |
| social_mentions | JSON | ○ | User-provided | Social media mention data (Weibo / Xiaohongshu / Twitter, etc.) |
| community_posts | JSON | ○ | User-provided | Community / forum post data |
| analysis_config | object | ○ | User-provided | Analysis configuration (language, sentiment model, clustering method, min cluster size) |

### Input Format

```json
{
  "data_sources": [
    {
      "type": "app_reviews",
      "location": "string",
      "time_range": "string",
      "expected_volume": "number"
    },
    {
      "type": "support_tickets",
      "location": "string",
      "time_range": "string",
      "expected_volume": "number"
    },
    {
      "type": "social_mentions",
      "location": "string",
      "time_range": "string",
      "expected_volume": "number"
    },
    {
      "type": "community_posts",
      "location": "string",
      "time_range": "string",
      "expected_volume": "number"
    }
  ],
  "analysis_config": {
    "language": "string",
    "sentiment_model": "string",
    "clustering_method": "string",
    "min_cluster_size": "number"
  }
}
```

**Data source descriptions**:
- `app_reviews`: App store reviews (App Store / Google Play / others)
- `support_tickets`: Customer support ticket system data
- `social_mentions`: Social media mentions (Weibo / Xiaohongshu / Twitter, etc.)
- `community_posts`: Community / forum posts

---

## Execution Steps

### Step 1: Data Collection & Cleaning [Core]

- Pull raw data from each data source
- Deduplicate (same user, same content across platforms)
- Denoise (filter ads, astroturfing, irrelevant content)
- Language detection and filtering
- Time range validation
- Output: Cleaned feedback dataset, recording original count and cleaned count

### Step 2: Sentiment Classification [Core]

- Classify sentiment for each feedback entry: Positive / Negative / Neutral / Mixed
- Extract sentiment intensity (0-1)
- Extract sentiment dimensions for negative feedback: Anger / Disappointment / Confusion / Anxiety / Other
- Output: Each feedback entry annotated with sentiment label and intensity

### Step 3: Theme Clustering [Core]

- Perform semantic clustering on all feedback
- Generate theme labels (auto-generated + manually adjustable)
- Calculate feedback volume, sentiment distribution, and trend changes for each theme
- Identify cross-theme relationships
- Output: Theme list, each theme including feedback volume, sentiment distribution, and representative verbatims

### Step 4: Pain Point Extraction & Grading [Core]

- Extract pain points from negative and mixed feedback
- Pain point grading criteria:
  - **P0 (Critical)**: Affects core feature usage, large number of users impacted
  - **P1 (Severe)**: Affects important experience, moderate number of users impacted
  - **P2 (General)**: Affects secondary experience, some users impacted
  - **P3 (Minor)**: Experience imperfections, few users mention it
- Pain point score = Impact scope (affected user ratio) × Pain degree (avg sentiment intensity) × Frequency (mention count / total feedback count)
- Output: Pain point list, sorted by score in descending order

### Step 5: User Segment Insights [Core]

- Segment users based on feedback content and sentiment patterns
- Each segment description: Core characteristics, primary needs, sentiment tendency, size ratio
- Identify differences and commonalities between segments
- Output: User segment list

---

### Output Depth Tiers

| Depth level | Output scope | Description |
|----------|----------|------|
| quick | User voice themes and sentiment distribution | Core conclusions + minimum viable deliverable |
| standard | Full deliverable (current default) | Complete deliverable, including all Step outputs |
| deep | Full analysis + sentiment trend tracking + theme clustering deep analysis + action recommendation roadmap | Full deliverable + extended analysis + deep inference |

## Output

Output file: `docs/discovery/user-research.md (append "User Voice Analysis" section)`

**Output Schema**:

```json
{
  "type": "object",
  "required": ["summary", "metadata"],
  "properties": {
    "summary": {"type": "object", "description": "Analysis summary, including total feedback, sentiment distribution, themes, pain points, and user segments"},
    "metadata": {"type": "object", "description": "Metadata, including timestamp, data quality flags, and overall confidence"}
  }
}
```

**Output validation rules**:

| Field path | Type | Required | Description |
|----------|------|------|------|
| summary.total_feedback_analyzed | number | Yes | Total feedback analyzed, must be >0 |
| summary.data_sources_used | string[] | Yes | List of data sources actually used, cannot be empty |
| summary.time_range | string | Yes | Data time range |
| summary.sentiment_distribution.positive | number | Yes | Positive sentiment ratio, 0-1 |
| summary.sentiment_distribution.negative | number | Yes | Negative sentiment ratio, 0-1 |
| summary.sentiment_distribution.neutral | number | Yes | Neutral sentiment ratio, 0-1 |
| summary.sentiment_distribution.mixed | number | Yes | Mixed sentiment ratio, 0-1 |
| summary.top_themes | array | Yes | Theme list, each item must contain theme, feedback_count, representative_quotes, confidence |
| summary.top_themes[].theme | string | Yes | Theme name, cannot be empty |
| summary.top_themes[].feedback_count | number | Yes | Feedback count for this theme |
| summary.top_themes[].representative_quotes | string[] | Yes | Each theme ≥2 representative verbatims |
| summary.top_themes[].confidence | number | Yes | Theme confidence, 0-1 |
| summary.top_pain_points | array | Yes | Pain point list, each item must contain pain_point, severity, impact_score, representative_quotes, confidence |
| summary.top_pain_points[].pain_point | string | Yes | Pain point description, cannot be empty |
| summary.top_pain_points[].severity | string | Yes | Pain point severity enum: P0/P1/P2/P3 |
| summary.top_pain_points[].impact_score | number | Yes | Pain point impact score |
| summary.top_pain_points[].representative_quotes | string[] | Yes | Each pain point ≥2 representative verbatims |
| summary.top_pain_points[].confidence | number | Yes | Pain point confidence, 0-1 |
| summary.emerging_themes | array | No | Emerging theme list |
| summary.emerging_themes[].confidence | number | Yes | Emerging theme confidence, 0-1 |
| summary.user_segments | array | Yes | User segment list, each item must contain segment_name, size_ratio, confidence |
| summary.user_segments[].segment_name | string | Yes | Segment name, cannot be empty |
| summary.user_segments[].size_ratio | number | Yes | Size ratio, 0-1 |
| summary.user_segments[].confidence | number | Yes | Segment confidence, 0-1 |
| metadata.analysis_timestamp | string | Yes | Analysis timestamp |
| metadata.data_quality_flags | string[] | Yes | Data quality flags |
| metadata.confidence_overall | number | Yes | Overall confidence, 0-1 |

```json
{
  "summary": {
    "total_feedback_analyzed": "number",
    "data_sources_used": ["string"],
    "time_range": "string",
    "sentiment_distribution": {
      "positive": "number",
      "negative": "number",
      "neutral": "number",
      "mixed": "number"
    },
    "top_themes": [
      {
        "theme": "string",
        "feedback_count": "number",
        "sentiment_breakdown": {},
        "trend": "rising|stable|declining",
        "representative_quotes": ["string"],
        "confidence": "number"
      }
    ],
    "top_pain_points": [
      {
        "pain_point": "string",
        "severity": "P0|P1|P2|P3",
        "impact_score": "number",
        "affected_user_ratio": "number",
        "emotion_intensity_avg": "number",
        "frequency": "number",
        "related_theme": "string",
        "representative_quotes": ["string"],
        "confidence": "number"
      }
    ],
    "emerging_themes": [
      {
        "theme": "string",
        "frequency_change": "string",
        "current_volume": "number",
        "confidence": "number"
      }
    ],
    "user_segments": [
      {
        "segment_name": "string",
        "core_characteristics": ["string"],
        "primary_needs": ["string"],
        "sentiment_tendency": "string",
        "size_ratio": "number",
        "confidence": "number"
      }
    ]
  },
  "metadata": {
    "analysis_timestamp": "string",
    "data_quality_flags": ["string"],
    "confidence_overall": "number"
  }
}
```

---

## Decision Rules

| Condition | Action |
|------|------|
| Data volume < 500 entries | Mark "insufficient data", downgrade output to "exploratory conclusions", confidence cap 0.5 |
| Emerging theme frequency increase > 100% (MoM) | Trigger escalation, mark as "needs human attention", recommend entering deep analysis |
| P0-level pain point discovered | Immediately notify human, do not wait for the full process to complete |
| Sentiment classification confidence < 0.7 | Mark as "low-confidence classification", include in statistics but annotate warning |
| Data source missing rate > 30% | Mark "incomplete data sources", recommend supplementing data |

---

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Feedback coverage (≥ 500 entries)
- [ ] Sentiment classification coverage (≥ 95%)

### P1 Checks (must pass for standard/deep)

- [ ] Theme clustering consistency (Silhouette Score ≥ 0.5)
- [ ] All outputs annotated with confidence (100%)
- [ ] Pain points have representative verbatims (each pain point ≥2 verbatims)
- [ ] Data deduplication rate (record deduplication ratio)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|---------|------------|
| All data sources missing | Prompt user to provide feedback data first, or execute lightweight analysis based on feedback text directly pasted by user | summary fields are empty, confidence drops to 0 | Ask user to provide user feedback text (reviews, tickets, social mentions, etc.) |
| If user does not provide app_reviews | Prompt user to provide app store review data, otherwise core feedback source is missing | data_sources_used missing app_reviews, sentiment distribution and themes may be skewed | Ask user to provide app store review data or export review CSV file |
| If user does not provide support_tickets | Prompt user to provide support ticket data, otherwise core feedback source is missing | data_sources_used missing support_tickets, pain points may miss ticket-type issues | Ask user to provide support ticket data or export ticket list |
| If user does not provide social_mentions | Skip steps related to this input, social media data not included in analysis | data_sources_used missing social_mentions, emerging theme detection capability reduced | Ask user to provide social media mention data (e.g., Weibo, Twitter mentions) |
| If user does not provide community_posts | Skip steps related to this input, community post data not included in analysis | data_sources_used missing community_posts, deep user insights may be missing | Ask user to provide community / forum post data |
| If user does not provide analysis_config | Skip steps related to this input, use default analysis configuration | Using default configuration, analysis parameters may be suboptimal | Ask user to provide analysis parameter configuration such as sentiment analysis granularity and theme count |

## Data Acquisition Instructions

This Skill requires user voice data (reviews, tickets, social mentions, etc.). Please provide via one of the following methods:
  1. Directly paste feedback text content
  2. Upload CSV/Excel/JSON files
  3. Provide data file paths
- AI is not responsible for external data collection, only for analysis

---

## Upstream Change Response

### Upstream Change Impact

This Skill is a starting Skill with no upstream file dependencies and does not involve upstream change impact.

### Downstream Notification Mechanism

| Downstream Skill | Notification trigger condition | Notification method | Notification content |
|-----------|------------|---------|---------|
| user-research-user-modeling | voice-analysis.json update complete | Write to output file | Notify that user segments, pain points, and theme data are ready |
| user-research-report | voice-analysis.json update complete | Write to output file | Notify that sentiment distribution, pain points, and theme data are ready |
