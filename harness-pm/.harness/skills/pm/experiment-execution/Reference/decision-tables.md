# Experiment Execution - 决策表

本文档收录 Experiment Execution Skill 的上游变更响应、降级策略与执行频率说明。

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Experiment design change | Statistical test parameters and termination conditions | Update statistical test configuration, re-evaluate termination conditions |
| Experiment data update | Statistical testing and drill-down analysis | Re-run statistical testing, update heterogeneous effects |
| Termination condition change | Experiment run monitoring | Update termination conditions, re-evaluate whether termination criteria met |
| Product background change | Business relevance of action recommendations | Re-evaluate action recommendations, update risks and follow-up experiment recommendations |

When experiment results/report themselves change, the downstream notification mechanism:

| Result/Report Change Type | Notification Scope | Notification Method |
|-------------------|----------|----------|
| Conclusion change | decision-dace | Mark conclusion change, trigger DACE Analyze |
| Guardrail metric triggers alert | decision-dace | Mark guardrail alert, trigger insight conversion |
| Decision recommendation change | decision-dace | Mark recommendation change, trigger DACE Conclude |
| Action recommendation change | decision-culture | Mark recommendation change, trigger report push |

## Degradation Strategy - Upstream File Missing

| Missing Scope | Degradation Plan | Output Impact |
|----------|----------|----------|
| Experiment configuration missing | Cannot auto-monitor, user needs to provide experiment result data | Cannot execute in-run monitoring |
| Experiment data missing | User provides experiment result data → direct analysis | Cannot perform trend analysis and novelty effect detection |
| Experiment configuration + experiment data both missing | User provides experiment result data → direct analysis | Output based on user data analysis results, trend and novelty effect marked "to be supplemented" |
| No experiment design plan | Reverse-engineer experiment design elements from execution results, mark "design info missing" | Experiment overview section incomplete |
| No product background | Focus on statistical conclusions themselves, action recommendations marked "need business context" | Action recommendations may lack business relevance |

## Data Acquisition Instructions

When upstream files are missing, the following information is needed from the user to support degradation generation:
- **Experiment result data**: Sample size, metric mean, standard deviation, etc. for experiment and control groups
- **Experiment configuration** (optional): Traffic split ratio, run duration, metric definitions
- **Statistical significance requirements** (optional): Desired confidence level and statistical power
- **Product background** (optional): Product stage, business goals, and historical experiments

## Execution Frequency

- **In-run monitoring**: Every 4 hours or daily
- **Result analysis**: Triggered when termination conditions are met
- **Report generation**: Auto-triggered after result analysis completes
- **Auto-alert**: P0 issues trigger immediately
