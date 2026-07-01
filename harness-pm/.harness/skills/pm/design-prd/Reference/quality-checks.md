# PRD Quality Checks - Unified Matrix

> This is the single source of truth for PRD quality validation.
> The 4 Quality Gates (completeness / consistency / ambiguity elimination / traceability) map to P0/P1/P2 severity levels below.

## Gate 1: Completeness (P0 - must pass for all modes)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Structure completeness | All 9 sections exist | Section existence scan |
| Field completeness | Required fields 100% filled | Field non-empty check |
| MoSCoW prioritization | All features annotated with MoSCoW | Priority tag check |
| Acceptance coverage | Main flow + boundary + exception fully covered | Given-When-Then coverage rate |
| State coverage | All 5 states defined (empty/loading/error/partial/permission) | State type enum matching |
| NFR coverage | All 4 dimensions (performance/availability/security/observability) | Dimension existence check |

**Failure Handling**: Block the generation process, output missing items list, provide guidance for supplementation.

## Gate 2: Consistency (P1 - must pass for standard/deep)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Objective traceability chain | OKR→metric→feature→acceptance connected | Traceability chain completeness check |
| Priority consistency | MoSCoW consistent across all references | Priority cross-validation |
| Version consistency | Version number matches change log | Version number consistency check |
| Metrics-feature alignment | Each metric has corresponding feature | Cross-reference check |

**Traceability Chain**:
```
Strategic objectives → OKR → Key Results → Primary metrics → Functional requirements → Acceptance criteria
```

**Failure Handling**: Identify inconsistent locations, provide correction suggestions, record as items pending confirmation.

## Gate 3: Ambiguity Elimination (P1 - must pass for standard/deep)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Quantifier quantification | No fuzzy quantifiers (fast→<2s, large amount→specific number) | Quantifier regex matching + replacement |
| Dangling references | All references point to existing targets | Reference resolution + existence validation |
| Logical contradictions | No precondition-result contradictions | Logic rule engine check |
| UI instruction overreach | AC only describes business rules, does not include specific UI/color/control forms | UI form terminology detection, violations tagged with needs_human_review: true |

**Automatic vs Human Review**:
- **Auto-correct**: identifiable ambiguities (fuzzy quantifiers, dangling references)
- **NOT auto-correct**: logical contradiction issues; output `suspected_contradictions` list with `needs_human_review: true`

**Human Review Items**:
- Business rule reasonableness
- User scenario authenticity
- Technical solution feasibility
- Suspected contradiction items in `suspected_contradictions`

**Failure Handling**:
- Auto-correct identifiable ambiguities (fuzzy quantifiers, dangling references)
- Logical contradiction issues are NOT auto-corrected; output `suspected_contradictions` list and tag `needs_human_review: true`
- Mark items requiring human confirmation
- Generate ambiguity clarification question list

## Gate 4: Traceability (P2 - must pass for deep only)

| Check Item | Standard | Check Method |
|--------|------|----------|
| Feature traceability | Each feature point traceable to upstream output | Upstream artifact path check |
| Acceptance traceability | Each AC traceable to a specific metric | AC-to-metric mapping check |
| Metric traceability | Each metric traceable to a business objective | Metric-to-objective mapping check |

**Upstream Artifact Specific File Paths**:
- insight_analysis: `docs/discovery/insight.md`
- opportunity_definition: `docs/discovery/opportunity.md`
- north_star_metric: `docs/strategy/PRODUCT_STRATEGY.md` ("North Star" section)
- okr_candidates: `docs/strategy/OKR.md`

**Failure Handling**: Generate traceability chain breakpoint report, prompt missing traceability paths, require supplementing upstream evidence.

## Gate Pass Rules Summary

| Gate | Severity | quick | standard | deep |
|------|----------|-------|----------|------|
| Gate 1 (Completeness) | P0 | ✅ required | ✅ required | ✅ required |
| Gate 2 (Consistency) | P1 | ⚠️ best-effort | ✅ required | ✅ required |
| Gate 3 (Ambiguity Elimination) | P1 | ⚠️ best-effort | ✅ required | ✅ required |
| Gate 4 (Traceability) | P2 | ❌ skip | ⚠️ best-effort | ✅ required |

> "best-effort" means: attempt check, record failures, but do not block generation.

## Relationship with PRD Quality Gate References

- **design-prd SKILL.md §2**: Overview of 4 Gates + per-mode pass rules + failure handling summary
- **This file**: Detailed check items, standards, and check methods for each Gate
- Both files are consistent and must be updated together if Gate definitions change.
