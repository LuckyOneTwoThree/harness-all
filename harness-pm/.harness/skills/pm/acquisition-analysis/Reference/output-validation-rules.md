# Output Validation Rules

> Extracted from SKILL.md. Field validation rules for acquisition-analysis.json output.

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| channel_assessment | object | Yes | Channel evaluation results, must contain channels/primary_channels/test_channels/observation_channels |
| channel_assessment.channels | array | Yes | Channel evaluation details list, each item must contain name/scale/conversion_rate/roi/classification |
| channel_assessment.channels[].name | string | Yes | Channel name, cannot be empty |
| channel_assessment.channels[].scale | string | Yes | Channel scale description |
| channel_assessment.channels[].volume | number | No | Channel user volume |
| channel_assessment.channels[].conversion_rate | number | Yes | Conversion rate, range 0-1 |
| channel_assessment.channels[].cost_per_acquisition | number | No | Cost per acquisition |
| channel_assessment.channels[].quality_score | number | No | Quality score, range 0-1 |
| channel_assessment.channels[].classification | string | Yes | Channel tier, only primary/test/observation allowed |
| channel_assessment.channels[].roi | number | Yes | Channel ROI, must be calculated based on LTV |
| channel_assessment.primary_channels | array | Yes | Primary channel name list, at least 1 channel |
| channel_assessment.test_channels | array | Yes | Test channel name list |
| channel_assessment.observation_channels | array | Yes | Observation channel name list |
| channel_assessment.total_new_users | number | Yes | Total new users, must be >0 |
| channel_assessment.blended_cac | number | Yes | Blended CAC, must be >0 |
| channel_assessment.blended_roi | number | Yes | Blended ROI |
| funnel_analysis | object | Yes | Funnel analysis, must contain stages and critical_drop_off |
| funnel_analysis.stages | array | Yes | Stage data, each item must contain name/volume/conversion_rate/drop_off_rate |
| funnel_analysis.stages[].name | string | Yes | Stage name, cannot be empty |
| funnel_analysis.stages[].volume | number | Yes | Stage user volume, must be ≥0 |
| funnel_analysis.stages[].conversion_rate | number | Yes | Conversion rate, range 0-1 |
| funnel_analysis.stages[].drop_off_rate | number | Yes | Drop-off rate, range 0-1 |
| funnel_analysis.critical_drop_off | object | Yes | Critical drop-off node, must contain from_stage/to_stage/drop_off_rate/impact_score |
| funnel_analysis.critical_drop_off.from_stage | string | Yes | Drop-off start stage |
| funnel_analysis.critical_drop_off.to_stage | string | Yes | Drop-off target stage |
| funnel_analysis.critical_drop_off.drop_off_rate | number | Yes | Drop-off rate, range 0-1 |
| funnel_analysis.critical_drop_off.impact_score | number | Yes | Impact score, range 0-1 |
| optimization_suggestions | array | Yes | Optimization recommendations list, each item must contain priority/stage/issue/solution/expected_improvement |
| optimization_suggestions[].priority | number | Yes | Priority, starting from 1 |
| optimization_suggestions[].stage | string | Yes | Target stage, cannot be empty |
| optimization_suggestions[].issue | string | Yes | Issue description, cannot be empty |
| optimization_suggestions[].solution | string | Yes | Solution, cannot be empty |
| optimization_suggestions[].expected_improvement | string | Yes | Expected improvement |
| ab_test_designs | array | No | A/B test design plans list, each item must contain test_id/hypothesis/primary_metric |
| ab_test_designs[].test_id | string | Yes | Test ID, cannot be empty |
| ab_test_designs[].hypothesis | string | Yes | Test hypothesis, cannot be empty |
| ab_test_designs[].primary_metric | string | Yes | Primary metric, cannot be empty |
