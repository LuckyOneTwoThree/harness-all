# MVP Scope - Output Schema & Decision Tables

This file contains the output validation rules, degradation strategy, and upstream change response tables referenced by `SKILL.md` for the `validation-mvp` skill.

## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| mvp_scope | object | Yes | MVP scope definition |
| mvp_scope.core_hypothesis | array | Yes | Core hypothesis list |
| mvp_scope.must_have | array | Yes | Must Have feature list |
| mvp_scope.nice_to_have | array | Yes | Nice to Have feature list |
| mvp_scope.cut_features | array | Yes | Cut feature list |
| mvp_scope.timeline | object | Yes | Timeline |
| mvp_scope.timeline.total_weeks | number | Yes | Total weeks (≤2; when exceeded, human_override: true required) |
| mvp_scope.timeline.milestones | array | Yes | Milestone list |
| mvp_scope.resource_estimate | object | Yes | Resource estimate |
| mvp_scope.effort_summary | object | Yes | Effort summary |
| mvp_scope.effort_summary.mvp_total | number | Yes | MVP total effort |
| mvp_scope.effort_summary.full_solution_total | number | Yes | Full solution total effort |
| mvp_scope.effort_summary.mvp_ratio | string | Yes | MVP ratio |
| mvp_scope.success_criteria | array | Yes | Success criteria |
| mvp_scope.risk_mitigation | array | Yes | Risk mitigation measures |
| mvp_scope.go_no_go | object | Yes | Go/No-Go decision framework |
| mvp_scope.go_no_go.metrics | array | Yes | Decision metrics |
| mvp_scope.go_no_go.thresholds | object | Yes | Threshold definitions |
| human_override | boolean | Yes | Human override flag (default false; must be true when total_weeks > 2) |

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| Assumption map missing | User describes key hypotheses, define MVP | Lacks structured hypothesis data, MVP scope may be less precise | Ask user to provide key hypothesis list and validation priority or upload assumption map file |
| Solution design data missing | User describes solution, define MVP | Lacks solution data, feature cuts may be less reasonable | Ask user to provide feature solution description and core feature list or upload ideation output file |
| Resource constraint data missing | User describes resource constraints, define MVP | Lacks resource constraint data, timeline may be less reasonable | Ask user to provide team size, available timeline, and tech stack resource constraints |
| Assumption map + solution design + resource constraints all missing | User describes hypotheses and solution, define MVP | Overall confidence reduced, MVP scope may be incomplete | Ask user to provide key hypotheses, feature solution, and resource constraint descriptions |
| All upstream files missing | Prompt user to run preceding stages first, or define MVP based on user description | Output is only a basic MVP framework | Ask user to provide core hypotheses, minimum feature set, and resource constraints |

## Upstream Change Response

### Upstream Change Impact

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Assumption map change (hypothesis add/remove or risk score change) | Core hypotheses, Must Have features | Mark affected hypotheses and features; recommend human confirm whether to redefine MVP |
| Solution design change | Feature list, cut decisions | Mark affected features; recommend human confirm whether to adjust MVP scope |
| Resource constraint change | Timeline, resource estimate | Mark affected timeline; recommend human confirm whether to adjust MVP scope |
| Experiment result update | Core hypothesis validation status | Mark affected hypotheses; recommend human confirm whether to adjust MVP strategy |

### Downstream Notification Mechanism

| MVP Scope Change Type | Notification Scope | Notification Method |
|----------------|----------|----------|
| Must Have feature add/remove | validation-experiment, validation-usability | Mark feature change, trigger experiment design and usability test update |
| Timeline change | validation-experiment | Mark timeline change, trigger experiment cycle adjustment |
| Success criteria change | validation-experiment | Mark criteria change, trigger experiment metric update |
| Go/No-Go decision change | All downstream Skills | Mark decision change, trigger full-flow update |
