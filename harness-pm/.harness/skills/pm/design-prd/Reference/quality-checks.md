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

## Import Mode Gate Adaptation

> When design-prd runs in Import Mode (external PRD normalization), the 4 Quality Gates must respect user decisions recorded during the IM-3 audit phase. See [import-audit-checklist.md](import-audit-checklist.md) for the audit dimensions and [SKILL.md §Import Mode](../SKILL.md#import-mode-external-prd-normalization) for the flow.

### User-Decision Awareness Rule

For each issue presented in IM-3 audit, the user made one of three decisions: **Adopt** / **Keep** / **Defer**. The Gate behavior adapts accordingly:

| User Decision | Gate Behavior |
|---------------|---------------|
| **Adopt** (fix applied in IM-4) | Gate re-checks the fixed content; passes if the fix is valid |
| **Keep** (P1/P2 only; original preserved) | Gate **skips** this issue — reads progress.md decision record and does NOT re-flag. The issue is already recorded in PRD.md §9.3 Open Issues (P1) or progress.md (P2). |
| **Defer** (marked deferred with owner+required_before) | Gate treats `deferred` as a valid structural state — passes if the deferred marker is properly formatted |

**Circuit-breaker guarantee**: A Gate MUST NOT fail on an issue that the user already decided on. This prevents the "audit → gate loop" where the Gate keeps re-challenging what the user chose to keep.

### Gate 1 (Completeness) in Import Mode

- P0-Block issues from audit Dimension 1 & 5: user MUST have chosen Adopt or Defer (Keep is not allowed for P0)
- If user chose Defer: Gate 1 checks that the deferred marker exists in PRD.md with reason + owner + required_before; passes if present
- If user chose Adopt: Gate 1 re-checks the fixed content normally
- Gate 1 MAY still fail on NEW completeness issues not covered by the audit (e.g., if IM-4 rebuild introduced a new structural defect)

### Gate 2 (Consistency) in Import Mode

- P1-Advise issues from audit Dimension 2: if user chose Keep, Gate 2 skips those specific issues
- Gate 2 still checks for NEW consistency issues introduced during IM-4 rebuild
- Standard/deep mode: Gate 2 required; quick mode: best-effort (same as Generate Mode)

### Gate 3 (Ambiguity) in Import Mode

- P1-Advise issues from audit Dimension 3: if user chose Keep, Gate 3 skips those specific issues
- **UI instruction overreach special case**: if the user chose to keep a UI overreach AC, it is recorded in Open Items with `needs_human_review: true` — Gate 3 passes but the flag travels with the PRD for downstream visibility
- Gate 3 still checks for NEW ambiguity issues introduced during IM-4 rebuild

### Gate 4 (Traceability) in Import Mode

- P1/P2 traceability issues from audit Dimension 2 & 4: if user chose Keep/Acknowledge, Gate 4 skips those specific issues
- Gate 4 still checks for NEW traceability issues
- Deep mode: Gate 4 required; standard mode: best-effort; quick mode: skip (same as Generate Mode)

### Self-Correction Loop in Import Mode

If a Gate fails on a NEW issue (not in the original audit list):
1. Record the new issue
2. Present to user (👤) with Adopt/Defer options (Keep not allowed for new P0; allowed for new P1/P2)
3. Apply user decision
4. Re-run the failed Gate only (not all 4)
5. Max 2 self-correction rounds (same as Generate Mode)
6. After 2 rounds: output problem report, require human intervention

