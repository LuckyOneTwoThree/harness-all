# Quality and Validation

## Source: quality-checklist.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Quality Checklist

| Check Item | Standard | Non-compliance Handling |
|--------|------|------------|
| HMW dimension coverage (P0) | All 6 dimensions covered | Annotate "dimension missing", supplement HMW statements for missing dimensions |
| HMW count (P0) | At least 6 HMW statements per dimension | Annotate "insufficient count", supplement HMW generation for insufficient dimensions |
| HMW data support (P0) | Each HMW has user research data support | Annotate "lacks data support", associate existing data or return to input phase to supplement |
| HMW divergence potential scoring (P1) | All HMW have completed divergence potential scoring | Annotate "scoring missing", supplement scoring and re-sort |
| HMW broadness (P1) | No overly broad HMW | Annotate "too broad", narrow problem scope and regenerate |
| HMW preset solution (P1) | No HMW with preset solutions | Annotate "preset solution", rephrase as open-ended question format |
| SCAMPER dimension coverage (P1) | All 7 SCAMPER dimensions covered | Annotate "dimension missing", supplement solutions for missing dimensions |
| SCAMPER solution count (P1) | At least 3 solutions per dimension, at least 10 total | Annotate "insufficient count", supplement generation for insufficient dimensions |
| SCAMPER deduplication (P2) | Solution deduplication completed, no obvious duplicates | Annotate "duplicates exist", perform semantic deduplication |
| SCAMPER clustering (P2) | All solutions have cluster assignment | Annotate "cluster missing", supplement cluster assignment |
| Reverse thinking failure path count (P2) | 10-15 failure paths generated | Annotate "insufficient paths" or "too many paths", supplement or streamline |
| Reverse thinking failure path scoring (P2) | Each failure path has severity and likelihood scores | Annotate "scoring missing", supplement scoring and recalculate priority |
| Reverse thinking success condition correspondence (P2) | Each failure path has a corresponding success condition | Annotate "condition missing", reverse transform to supplement success conditions |
| Reverse thinking design constraint actionability (P2) | Each design constraint is specific and actionable | Annotate "constraint vague", transform abstract constraints into specific actionable descriptions |
| Reverse thinking constraint verification method (P2) | Design constraints have clear verification methods | Annotate "verification missing", define verification methods for each constraint |
| Convergence solution filtering (P1) | Solutions with feasibility <2 and constraint conflicts excluded | Annotate "filtering incomplete", supplement filtering |
| Convergence solution deepening (P2) | Top 5 solutions deepened, including all 6 dimensions | Annotate "insufficient deepening", supplement missing dimensions |
| Convergence comparison matrix (P2) | 6 dimensions complete, scoring criteria unified | Annotate "matrix incomplete", supplement missing dimensions |
| Unique ID (P0) | All entries have unique IDs | Annotate "ID missing", supplement unique identifiers |
| Output format (P0) | Output format complies with specification | Annotate "format exception", correct to standard output format |
| Statistics accuracy (P1) | Statistical data is accurate | Annotate "statistics incorrect", recalculate statistical data |

## Source: validation-rules.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| hmw_ideas | object | Yes | HMW output |
| hmw_ideas.hmw_statements | array | Yes | HMW statement list |
| hmw_ideas.hmw_statements[].id | string | Yes | HMW unique identifier |
| hmw_ideas.hmw_statements[].statement | string | Yes | HMW statement text |
| hmw_ideas.hmw_statements[].dimension | string | Yes | Dimension (remove/reduce/accelerate/amplify/expand/rethink) |
| hmw_ideas.hmw_statements[].source_problem | string | Yes | Associated core problem |
| hmw_ideas.hmw_statements[].source_data | object | Yes | Source user research data |
| hmw_ideas.hmw_statements[].divergence_potential | integer | Yes | Divergence potential score (1-5) |
| hmw_ideas.hmw_statements[].quality_check | string | Yes | Quality check result (passed/failed) |
| hmw_ideas.hmw_statements[].quality_issues | array | Yes | Quality issues list |
| hmw_ideas.hmw_statements[].related_dimensions | array | Yes | Other related dimensions |
| hmw_ideas.summary | object | Yes | HMW statistics summary |
| scamper_ideas | object | Yes | SCAMPER output |
| scamper_ideas.solutions | array | Yes | Solution list, at least 10 |
| scamper_ideas.solutions[].id | string | Yes | Solution unique identifier |
| scamper_ideas.solutions[].source_hmw | object | Yes | Source HMW statement |
| scamper_ideas.solutions[].scamper_dimension | string | Yes | SCAMPER dimension |
| scamper_ideas.solutions[].solution | string | Yes | Solution title |
| scamper_ideas.solutions[].description | string | Yes | Detailed solution description |
| scamper_ideas.solutions[].innovation_score | integer | Yes | Innovation score (1-5) |
| scamper_ideas.solutions[].feasibility_score | integer | Yes | Feasibility score (1-5) |
| scamper_ideas.solutions[].impact_score | integer | Yes | Impact score (1-5) |
| scamper_ideas.solutions[].risk_score | integer | Yes | Risk score (1-5) |
| scamper_ideas.solutions[].key_assumption | string | Yes | Key assumption |
| scamper_ideas.solutions[].cluster | string | Yes | Cluster ID |
| scamper_ideas.clusters | array | Yes | Cluster list |
| scamper_ideas.clusters[].cluster_id | string | Yes | Cluster ID |
| scamper_ideas.clusters[].cluster_name | string | Yes | Cluster name |
| scamper_ideas.clusters[].solution_ids | array | Yes | Solution IDs within the cluster |
| scamper_ideas.summary | object | Yes | SCAMPER statistics summary |
| inversion_ideas | object | Yes | Reverse thinking output |
| inversion_ideas.inversion_analysis | array | Yes | Inversion analysis list, at least 10 |
| inversion_ideas.inversion_analysis[].id | string | Yes | Unique identifier |
| inversion_ideas.inversion_analysis[].failure_mode | string | Yes | Failure mode description |
| inversion_ideas.inversion_analysis[].severity | integer | Yes | Severity (1-5) |
| inversion_ideas.inversion_analysis[].likelihood | integer | Yes | Likelihood (1-5) |
| inversion_ideas.inversion_analysis[].risk_score | integer | Yes | Risk score (severity × likelihood) |
| inversion_ideas.inversion_analysis[].priority | string | Yes | Priority (critical/high/medium/low) |
| inversion_ideas.inversion_analysis[].success_condition | string | Yes | Success condition |
| inversion_ideas.inversion_analysis[].design_constraints | array | Yes | Design constraints array |
| inversion_ideas.inversion_analysis[].design_constraints[].constraint | string | Yes | Constraint description |
| inversion_ideas.inversion_analysis[].design_constraints[].category | string | Yes | Constraint category |
| inversion_ideas.inversion_analysis[].design_constraints[].verifiable | boolean | Yes | Whether verifiable |
| inversion_ideas.inversion_analysis[].design_constraints[].verification_method | string | Yes | Verification method |
| inversion_ideas.summary | object | Yes | Reverse thinking statistics summary |
| converged_ideas | object | Yes | Convergence output |
| converged_ideas.converged_solutions | array | Yes | Converged solution list, at least 5 |
| converged_ideas.converged_solutions[].id | string | Yes | Solution unique identifier |
| converged_ideas.converged_solutions[].title | string | Yes | Solution title |
| converged_ideas.converged_solutions[].detailed_description | object | Yes | Detailed solution description |
| converged_ideas.converged_solutions[].interaction_flow | object | Yes | Interaction flow design |
| converged_ideas.converged_solutions[].assumptions | object | Yes | Key assumptions |
| converged_ideas.converged_solutions[].risks | object | Yes | Risk identification |
| converged_ideas.converged_solutions[].mvp_scope | object | Yes | MVP scope definition |
| converged_ideas.converged_solutions[].success_metrics | object | Yes | Success metrics |
| converged_ideas.comparison_matrix | object | Yes | Comparison matrix |
| converged_ideas.comparison_matrix.dimensions | array | Yes | Comparison dimension definitions, 6 dimensions |
| converged_ideas.comparison_matrix.solutions | array | Yes | Comparison data for each solution |
| converged_ideas.comparison_matrix.recommendations | object | Yes | AI recommendation results |
| converged_ideas.human_decision_package | object | Yes | Human decision package |
| converged_ideas.human_decision_package.approval_required | boolean | Yes | Whether human approval is required |

## Source: failure-handling.md

<!-- Reference material extracted from SKILL.md, consult as needed -->

# Failure Handling Decision Table

| Failure Scenario | Handling Process |
|----------|----------|
| HMW failed quality check | Identify quality issue type, targeted regeneration, re-run quality check |
| HMW dimension coverage incomplete | Check HMW count for 6 dimensions, supplement generation for missing dimensions |
| HMW lacks data support | Associate existing data or return to input phase to supplement user research data |
| Insufficient SCAMPER solutions | Supplement generation for sparse dimensions, lower similarity threshold |
| SCAMPER dimension coverage incomplete | Return to Step 2A, supplement generation for missing dimensions |
| Insufficient reverse thinking failure paths | Check failure path classification completeness, supplement missing dimensions |
| Design constraints too abstract | Review constraint descriptions, transform into specific actionable descriptions and define verification methods |
| Insufficient convergence solution deepening | Supplement missing deepening dimensions |
| Comparison matrix dimensions missing | Supplement missing dimension scores; if scoring is not possible, annotate "insufficient data" |
