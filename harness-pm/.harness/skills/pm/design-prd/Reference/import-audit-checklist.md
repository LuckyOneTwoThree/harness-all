# PRD Import Audit Checklist

> This is the single source of truth for auditing an externally-supplied PRD before Import Mode normalization.
> Used by design-prd Import Mode (see SKILL.md §Execution Steps → Import Mode).
>
> Design principle: the audit focuses on **structural / mechanical problems** (detectable by pattern matching),
> NOT on subjective product-value judgments. Value signals are surfaced as advisory evidence, leaving the
> decision to the user.

## Audit Severity Levels

| Level | Meaning | Blocking? | User Override Allowed? |
|-------|---------|-----------|------------------------|
| **P0-Block** | Structural defect that violates Gate 1 hard requirements | ✅ Must fix before continuing | ❌ No — user must fix or mark `deferred` with owner+required_before |
| **P1-Advise** | Quality issue worth fixing, but not a hard structural violation | ❌ Does not block | ✅ Yes — user can choose "keep as-is"; recorded in Open Items |
| **P2-Advisory** | Optimization suggestion / value signal worth attention | ❌ Does not block | ✅ Yes — recorded as advisory, no Open Items entry required |

**Circuit-breaker rule**: After the user has made a decision on an issue, the quality gate MUST NOT re-challenge the same issue. Decisions are final within this Import Mode run (recorded in progress.md).

## Audit Dimension 1: Structural Completeness (P0-Block)

| Check Item | Detection Method | Failure Example |
|-----------|------------------|-----------------|
| 9-section structure exists | Scan for Section 1-9 headings | Missing Section 5 NFR |
| Required fields non-empty | Field non-empty check | Section 3.2.1 Feature List empty |
| MoSCoW tags complete | Priority tag regex check | Feature without Must/Should/Could/Won't |
| AC ID format compliance | Regex `^AC-[A-Z0-9]+-[0-9]{3}$` | "AC1", "验收标准1", "AC-F01-1" |
| State coverage (5 states) | State type enum matching | Missing empty/error state definitions |
| NFR 4 dimensions present | Dimension existence check | Missing observability section |
| Document ID format | Regex `^PRDS-[0-9]{6}-[0-9]+$` | Missing or non-standard ID |
| Version field exists | Non-empty check | No version field |

**Failure handling**: Issue listed as P0-Block; user must fix or mark `deferred` (with reason, owner, required_before) to continue.

## Audit Dimension 2: Consistency (P1-Advise)

| Check Item | Detection Method | Failure Example |
|-----------|------------------|-----------------|
| Traceability chain connected | OKR→metric→feature→AC path check | Feature has no upstream OKR |
| Priority cross-reference consistent | MoSCoW consistency across all references | Feature marked Must in one place, Should in another |
| Version matches changelog | Version number consistency check | Version v1.0 but changelog only has v0.3 entry |
| Metric-feature alignment | Each metric has corresponding feature | Orphan metric with no feature |
| Entity reference consistency | entity_id cross-reference check | feature.related_entities references non-existent entity |
| Page reference consistency | page_id cross-reference check | feature.related_pages references non-existent page |

**Failure handling**: Issue listed as P1-Advise with specific location + correction suggestion. User can choose:
- **Adopt**: design-prd applies the fix
- **Keep**: original content preserved byte-for-byte; issue recorded in PRD.md Section 9.3 Open Items + progress.md
- **Defer**: mark `deferred` with owner + required_before

## Audit Dimension 3: Ambiguity & Overreach (P1-Advise)

| Check Item | Detection Method | Failure Example |
|-----------|------------------|-----------------|
| Fuzzy quantifiers | Regex matching (fast→<2s, large→specific number) | "response should be fast", "support large user volumes" |
| Dangling references | Reference resolution + existence validation | "see Section X" where Section X doesn't exist |
| Logical contradictions | Logic rule check | Precondition A contradicts result B |
| UI instruction overreach | UI form terminology detection | AC contains "left sidebar red button" |
| AC contains implementation details | Implementation keyword detection | AC prescribes specific database or caching strategy |

**UI overreach special handling**: Never auto-correct UI forms. Tag `needs_human_review: true` and present as P1-Advise. If user keeps as-is, record in Open Items.

**Failure handling**: Same as Dimension 2 (Adopt / Keep / Defer).

## Audit Dimension 4: Value Signals (P2-Advisory)

> **Boundary**: These are structural signals that *may* indicate a value problem, NOT direct value judgments.
> The framework presents evidence; the user decides whether the feature is worthwhile.

| Signal | Detection Method | What It May Indicate |
|--------|------------------|---------------------|
| Feature lacks `driven_by` | Field non-empty check | No upstream OKR / North Star support; value proposition unclear |
| Must feature has low `expected_lift` | Priority vs. expected_lift correlation | High-priority feature with low expected impact — verify priority |
| Two features logically conflict | Cross-feature dependency analysis | Implementing both may cause conflict or redundancy |
| Feature conflicts with NFR constraint | Feature vs. NFR cross-check | Feature X requires >2s response, but NFR mandates <500ms |
| Won't feature lacks reason | Won't feature reason field check | Explicitly excluded items should record rationale |
| Scope/NFR mismatch | Scope vs. NFR complexity analysis | Small scope but heavy NFR (e.g., landing page requiring 99.99% SLO) |

**Failure handling**: Issue listed as P2-Advisory. User can choose:
- **Adopt**: address the signal (supplement driven_by / adjust priority / add reason)
- **Acknowledge**: user acknowledges seeing it; no action taken; NOT recorded in Open Items (it's advisory only)
- **Defer**: mark `deferred` with owner + required_before

**Hard boundary**: The framework NEVER says "this feature isn't worth doing". It only presents structural evidence (e.g., "Feature X has no driven_by field linking to any OKR") and lets the user draw their own conclusion.

## Audit Dimension 5: prd.json Projection Readiness (P0-Block)

> This dimension checks whether the PRD content can be losslessly projected to prd.json.

| Check Item | Detection Method | Failure Handling |
|-----------|------------------|------------------|
| entities[].fields extractable | Entity table structure check | P0-Block — must fix structure |
| entities[].relationships extractable | Relationship diagram or table check | P0-Block |
| pages[].data_requirements present | Page data requirements section check | P0-Block (mark `not_applicable` if project has no pages) |
| tracking_plan.events present | Event list check | P0-Block (mark `not_applicable` if not tracked) |
| applicability domains identifiable | Each section's applicability can be determined | P0-Block — must mark applicable / not_applicable / deferred |
| AC-xxx can be extracted to features[].acceptance_criteria | AC-to-feature mapping check | P0-Block |
| NFR 4 dimensions extractable | NFR section structure check | P0-Block |

## User Decision Recording

Each issue presented to the user must record the decision:

| Issue ID | Severity | Location | Description | Suggested Fix | User Decision | Decision Rationale | Recorded In |
|----------|----------|----------|-------------|---------------|---------------|-------------------|-------------|
| AUD-001 | P1-Advise | Section 3.2.1, Feature F-003 | Fuzzy quantifier "fast response" | Change to "<500ms p99" | Keep | Business context allows flexibility | PRD.md §9.3 + progress.md |
| AUD-002 | P2-Advisory | Feature F-005 | No driven_by field | Link to OKR-1-KR2 | Acknowledge | Internal tool, no OKR tracking | progress.md only |
| AUD-003 | P0-Block | Section 5 | Missing observability NFR | Add metrics/logs/traces | Adopt | — | Applied to PRD.md |

## Relationship with 4 Quality Gates

Import Mode's Audit is a **pre-normalization check** that runs BEFORE the 4 Quality Gates:

```
External PRD → [Audit] → user decisions → [rebuild PRD.md + project prd.json] → [4 Quality Gates] → output
```

- **Audit**: checks the external PRD as-is, identifies issues, lets user decide
- **4 Quality Gates**: check the rebuilt PRD (after user decisions applied), same as normal mode

**Key guarantee**: P0-Block issues that the user refuses to fix will cause Gate 1 to fail, blocking output. The user cannot bypass structural requirements — they can only choose *how* to fix them (fix now / mark deferred with owner).

**P1-Advise issues that the user chooses to keep** will NOT cause Gate failure. The Gate recognizes the "user decided to keep" record (in progress.md) and does not re-challenge. This is the key mechanism that prevents "audit → gate loop".

## Scope Boundary

The Audit **does NOT** cover:

- Product strategy judgment (is this the right market to enter?)
- Feature prioritization opinion (should this be Must or Should?)
- Business model viability (will this make money?)
- Competitive analysis (is this better than competitor X?)
- User research quality (are these personas well-researched?)

These are **out of framework scope**. The framework only checks structural/mechanical compliance, not business wisdom.
