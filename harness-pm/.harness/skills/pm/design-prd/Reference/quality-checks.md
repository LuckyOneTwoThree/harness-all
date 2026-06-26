# PRD Generator - Detailed Quality Checks

This file contains the detailed quality check standards referenced by `SKILL.md` for the `design-prd` skill.

## 10.1 Completeness Standards (P0)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Structure completeness | All 9 sections exist | Section existence scan |
| Field completeness | Required fields 100% filled | Field non-empty check |
| Acceptance coverage | Main flow + boundary + exception fully covered | Given-When-Then coverage rate |
| State coverage | All 5 states defined | State type enum matching |

## 10.2 Consistency Standards (P1)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Objective traceability chain | OKR→metric→feature→acceptance connected | Traceability chain completeness check |
| Priority consistency | MoSCoW consistent across all references | Priority cross-validation |
| Version consistency | Version number matches change log | Version number consistency check |

## 10.3 Ambiguity Elimination Standards (P1)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Quantifier quantification | No fuzzy quantifiers (fast→<2s) | Quantifier regex matching + replacement |
| Dangling references | All references point to existing targets | Reference resolution + existence validation |
| Logical contradictions | No precondition-result contradictions | Logic rule engine check |
| UI instruction overreach | AC only describes business rules, does not include specific UI/color/control forms | UI form terminology detection, violations tagged with needs_human_review |

## 10.4 Executability Standards (P2)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Acceptance format | Given-When-Then format correct | Format regex matching |
| Judgment clarity | Then result can be objectively judged | Judgment condition testability check |
| Coverage completeness | Happy Path + boundary + exception | Coverage rate statistical analysis |
