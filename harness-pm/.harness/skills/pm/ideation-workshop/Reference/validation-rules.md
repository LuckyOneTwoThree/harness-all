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
