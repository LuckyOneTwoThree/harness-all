# Opportunity Definition - 决策表

本文档收录 Opportunity Definition Skill 的降级策略与上下游变更响应表。

## Degradation Strategy

When upstream files do not exist, this Skill can still execute independently:

| Missing upstream input | Degradation plan | Output impact | Data acquisition instructions |
|---------------|---------|----------|------------|
| User research data (voice-analysis / behavior-analysis) | User describes opportunity → score and generate Problem Statement based on description | `problem_validity.score` defaults to 2, `data_support.pain_point_frequency` is a user estimate, `confidence` <0.5 | Ask user to provide user feedback text and behavior data, or upload voice-analysis.json/behavior-analysis.json files |
| Market analysis data (tam-som) | User describes opportunity → market size dimension scored based on user estimate | `market_size.score` based on user estimate, `evidence` annotated "lacks market data" | Ask user to provide market size estimate data or upload tam-som.json file |
| Competitor analysis data (competitor-analysis) | User describes opportunity → competitive moat dimension scored based on user description | `competitive_moat.score` based on user description, `evidence` annotated "lacks competitor data" | Ask user to provide competitor information or upload competitor-analysis.json file |
| Requirement insight data (persona / insight-analysis) | Generate directly based on user description | `template_elements.target_user` may use generic terms, `quality_check.specific_user_group` may not pass | Ask user to provide target user persona description or upload persona.json/insight-analysis.json file |
| Technical team assessment data missing | Skip technical feasibility dimension scoring, annotate "pending tech assessment" | `technical_feasibility.score` uses default value, feasibility judgment lacks technical basis | Ask user to provide technical team capability assessment and tech stack information |
| All upstream files missing | Prompt user to execute preceding stages first, or execute directly based on user's verbally described opportunity | Multiple dimensions use default values, `weighted_total` credibility is very low, `quality_check` multiple items may not pass, Brief decision value significantly reduced | Ask user to provide opportunity description, target users, market estimate, and competitor information |

## Upstream Change Impact Table

| Upstream data source | Change type | Impact dimension | Impact description | Response strategy |
|-----------|----------|----------|----------|----------|
| voice-analysis.json | Pain point mention rate update | scoring.problem_validity / problem_statement.data_support | Pain point frequency changes affect scoring and Problem Statement | Recalculate problem_validity score, update data_support and core_pain |
| behavior-analysis.json | Behavior pattern data update | scoring.problem_validity / hmw.enhance_experience | Behavior data changes affect scoring and HMW | Re-evaluate behavior corroboration, update affected HMW's data_source and confidence |
| tam-som.json | SOM estimate adjustment | scoring.market_size / brief.evidence_summary.market_analysis | SOM value changes affect scoring and Brief | Recalculate market_size score, update Brief market analysis evidence |
| competitor-analysis.json | Competitor capability change | scoring.competitive_moat / brief.evidence_summary.competitive_landscape | Competitor changes affect scoring and Brief | Recalculate competitive_moat score, update Brief competitive landscape evidence |
| persona.json | User persona adjustment | problem_statement.template_elements.target_user | User group definition changes | Update target_user, re-execute specific_user_group check |
| insight-analysis.json | Insight analysis change | problem_statement.template_elements.task | User task definition changes | Update task element, re-execute quality checks |

## Downstream Notification Mechanism Table

| Downstream consumer | Notification field | Notification timing | Notification content |
|-----------|----------|----------|----------|
| Decision makers / stakeholders | `brief.title` / `scoring.opportunities[].weighted_total` | After Brief core conclusions change | Notify opportunity brief title and scoring changes, prompt need for re-review |
| Subsequent phases (solution exploration) | `brief.recommended_next_step` / `brief.key_assumptions` | After recommended action or assumption changes | Notify next-step action adjustments and assumption changes to be validated |
