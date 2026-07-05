# User Modeling - Decision Tables

This file contains the decision rules, quality checks, degradation strategy, and upstream change response tables referenced by `SKILL.md` for the `user-research-user-modeling` skill.

## Decision Rules

| Condition | Action |
|------|------|
| Persona overall confidence < 0.5 | Escalate to human validation, mark "needs manual confirmation", do not automatically proceed to subsequent flows |
| Emotional Job inference confidence < 0.5 | Escalate to human validation, mark "emotional need inference pending confirmation" |
| Social Job inference confidence < 0.5 | Escalate to human validation, mark "social need inference pending confirmation" |
| Two Personas have insufficient distinctiveness (trait overlap > 70%) | Merge into 1 Persona or mark "needs manual judgment on whether to split" |
| Clustering quality score < 0.4 | Mark "poor clustering quality", recommend adjusting clustering parameters or supplementing data |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] At least 1 Persona with confidence ≥ 0.7 (satisfied)
- [ ] Each Persona has data support (each field annotated with data source)

### P1 Checks (must pass for standard/deep)

- [ ] Distinctiveness between Personas (trait overlap < 70%)
- [ ] Representative quotes (each Persona ≥ 3 quotes)
- [ ] Empathy Map four quadrants complete (each quadrant ≥ 2 items)
- [ ] Journey Map stages complete (covers core stages)
- [ ] All outputs annotated with confidence (100%)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep inference and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|---------|------------|
| voice-analysis.json | Infer Persona based on user-described target user traits, annotate "lacks voice data support" | Persona voice traits and pain points based on inference, representative_quotes missing, core_pain_points confidence reduced | Ask user to provide user feedback text or upload voice-analysis.json file |
| behavior-analysis.json | Infer Persona based on user-described user behavior, annotate "lacks behavior data support" | Persona behavior traits and Aha Moment based on inference, key_behaviors confidence reduced, Journey Map behavior data missing | Ask user to provide behavior event logs or upload behavior-analysis.json file |
| voice-analysis.json + behavior-analysis.json | User provides target user description → infer Persona based on description, overall confidence reduced | personas overall confidence reduced, data_source mostly inferred, low_confidence_fields increased | Ask user to provide user feedback text and behavior event logs |
| All upstream files missing | Prompt user to execute preceding stages first, or execute lightweight Persona inference based on user's verbal description | Output is purely inferred Persona, confidence_overall capped at 0.3, all fields annotated as inferred | Ask user to provide target user trait description, behavior patterns, and core pain points |
| If user does not provide survey_data | Skip steps related to this input, Persona demographic information based on inference, annotate "lacks survey data" | Demographic field data_source is inferred, confidence reduced | Ask user to provide user survey data (including demographics, usage habits, etc.) |
| If user does not provide modeling_config | Skip steps related to this input, use default modeling configuration (max Persona count: 4, confidence threshold: 0.5) | Using default configuration, Persona count and threshold may be suboptimal | Ask user to provide modeling parameters such as max Persona count and confidence threshold |

### Data Acquisition Instructions

This Skill requires user voice analysis and behavior analysis data. Please provide via one of the following methods:
  1. Directly paste user description text (target user traits, behavior patterns, etc.)
  2. Upload voice-analysis.json / behavior-analysis.json files
  3. Provide data file paths
- AI is not responsible for external data collection, only for analysis

## Upstream Change Response

### Upstream Change Impact

| Upstream Skill | Change type | Impact scope | Response action |
|-----------|---------|---------|---------|
| user-research-voice-analysis | voice-analysis.json structure change | User segments, pain points, theme data format changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-voice-analysis | voice-analysis.json content update | Pain point severity, sentiment distribution, segment results change | Re-execute clustering and Persona generation, annotate "rebuilt based on updated data" |
| user-research-behavior-analysis | behavior-analysis.json structure change | Behavior segments, Aha Moment, feature usage data format changes | Check input field mapping, adapt to new structure, mark "upstream data format anomaly" if incompatible |
| user-research-behavior-analysis | behavior-analysis.json content update | Funnel, paths, anomaly detection results change | Re-execute clustering and Persona generation, annotate "rebuilt based on updated data" |

### Downstream Notification Mechanism

| Downstream Skill | Notification trigger condition | Notification method | Notification content |
|-----------|------------|---------|---------|
| user-research-interview-assist | persona.json update complete | Write to output file | Notify that Persona data is ready and can be used for interview script design |
| user-research-report | persona.json / empathy-map.json / journey-map.json update complete | Write to output file | Notify that user modeling data is ready and can be used for report generation |
