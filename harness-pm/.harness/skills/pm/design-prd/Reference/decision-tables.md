# PRD Generator - Decision Tables & Detailed Logic

This file contains the version lifecycle, execution decision logic, conflict escalation, degradation strategy, and upstream change response tables referenced by `SKILL.md` for the `design-prd` skill.

## Version Lifecycle

### Version State Machine

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│   v0.1 AI draft  →  v0.2 PM refinement  →  v0.3 Review revision │
│       ↓                ↓               ↓                    │
│   Auto-generated    Manual revision    Review feedback       │
│                                                             │
│   v1.0 Finalized  →  v1.x Dev change  →  v2.0 Release update │
│       ↓               ↓               ↓                    │
│   Review passed    Adjusted during dev  Post-release retrospective │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Version Definition

| Version | Trigger Condition | Change Authority | Review Requirement |
|------|----------|----------|----------|
| v0.1 | AI auto-generated | AI | None |
| v0.2 | PM first revision | PM | None |
| v0.3 | Post-review revision | PM + reviewer | None |
| v1.0 | Review passed and finalized | Change committee | Full review |
| v1.x | Change during development | Dev + PM | Change review |
| v2.0 | Major version update after release | PM | Retrospective review |

### State Transitions

| Current State | Transition Action | Next State | Trigger Condition |
|----------|----------|----------|----------|
| Draft | Submit for review | In Review | All 4 gates passed |
| In Review | Review passed | Finalized | Review committee approved |
| In Review | Review not passed | Review Revision | Blocking items exist |
| Finalized | Trigger change | Dev Change | Adjustment needed during development phase |
| Released | Publish update | Archived | New version released |

## Execution Decision Logic

### Generation Order Dependency Graph

**Topological Sort Rules**:
```
Generation priority (high to low):
1. Meta information (Section 1) - no dependencies
2. Background & objectives (Section 2) - depends on upstream exploration output
3. Solution design (Section 3) - depends on Section 2 and design output
4. Boundaries & constraints (Section 4) - depends on Section 3
5. Non-functional requirements (Section 5) - depends on Section 3
6. Tracking plan (Section 6) - depends on Section 3
7. Acceptance criteria (Section 7) - depends on Section 2, 3
8. Release & operations (Section 8) - depends on Section 7
9. Appendix (Section 9) - depends on all other Sections
```

### Upstream Conflict Decision Rules

**Conflict Types and Handling Strategies**:

| Conflict Type | Decision Rule | Handling Strategy | Escalation Condition |
|----------|----------|----------|----------|
| **Objective conflict** | Two OKRs in opposite directions | Priority arbitration | KPI impact > 10% |
| **Solution conflict** | Multiple solutions point to different implementations | Solution comparison scoring | Major architecture adjustment |
| **Metric conflict** | Metric optimization directions contradict | Guardrail metric constraints | Guardrail metric breached |
| **Priority conflict** | Feature priority ranking contradicts | MoSCoW re-prioritization | MVP scope change > 30% |

**Escalation Decision Matrix**:
```
Escalation thresholds:
- Number of sources ≥ 2 and conclusions inconsistent
- MVP scope change > 30%
- Involves security compliance issues
- Involves major technical debt

Escalation path:
1. Record conflict details
2. Convene stakeholder meeting
3. Produce decision minutes
4. Update PRD
```

### Upstream Data Incomplete Handling

**Missing Level Definition**:

| Level | Definition | Handling Method |
|------|------|----------|
| **L0** | Fields complete, but content is empty | AI supplements description, annotates low confidence |
| **L1** | Some fields missing | Fill with template, mark as pending confirmation |
| **L2** | Core fields completely missing | Interrupt process, force supplementation |

**Missing Handling Flow**:
```
Detect missing → Determine level → Apply strategy → Output result

L0 handling:
1. Annotate "AI supplemented, pending confirmation"
2. Provide confidence score
3. Generate confirmation question list

L1 handling:
1. Annotate "Pending supplementation"
2. Fill with default values or template
3. Block related downstream generation
4. Generate supplementation list

L2 handling:
1. Annotate "Missing core input"
2. Output interruption report
3. Specify missing fields
4. Require re-input
```

### Self-Correction Loop

**Trigger Conditions**:
- Gate check failure
- Human feedback correction
- Upstream data update

**Loop Limits**:
- Maximum self-correction rounds: 2
- Per-round timeout: 3 minutes
- Logical contradiction issues do not enter the self-correction loop; directly tag for manual review
- After exceeding limits, output problem report, human intervention

**Self-Correction Flow**:
```
Round N correction:
1. Analyze failure cause
2. Generate correction plan
3. Apply correction
4. Re-execute gate check
5. If passed, end; otherwise enter round N+1
```

## Detailed Decision Rules

### Gate Pass Rules

**Hard Conditions**:
- All 4 gates must pass
- Failure of any gate blocks entry into the development phase

**Gate Status Mapping**:
| Gate Status | Enter Development | Finalize | Release |
|----------|----------|------|------|
| All passed | ✓ | ✓ | ✓ |
| Gate 1 failed | ✗ | ✗ | ✗ |
| Gate 2 failed | ✗ | ✗ | ✗ |
| Gate 3 failed | Human confirmation required | Human confirmation required | ✗ |
| Gate 4 failed | Supplementation required | Supplementation required | ✗ |

### Conflict Escalation Rules

**Situations Requiring Escalation**:
1. **Source conflict**: Requirements involve ≥ 2 upstream sources, and conclusions are inconsistent
2. **Scope change**: MVP scope change > 30%
3. **Security compliance**: Involves user privacy, security compliance, financial regulation, and other sensitive areas
4. **Resource overrun**: Requirement resource consumption exceeds 50% of the original plan
5. **Technical risk**: Solution involves major technical architecture adjustment

**Escalation Process**:
```
1. Identify escalation trigger conditions
2. Generate escalation report (conflict details + stakeholder positions + impact analysis)
3. Determine escalation level (PM/Product committee/Management)
4. Convene decision meeting
5. Produce decision minutes
6. Update PRD
```

### Open Issue Management [Deep]

**Open Issue Status**:
- **Open**: Unresolved
- **In Progress**: Being handled
- **Resolved**: Resolved
- **Won't Fix**: Explicitly not doing

**Finalization Rules**:
- All Open issues must be Resolved or converted to Won't Fix
- Output issue closure report at finalization

## Degradation Strategy

### Upstream File Missing Degradation Plan

| Missing Scope | Degradation Plan | Output Impact | Data Acquisition Instructions |
|----------|----------|----------|------------|
| insight_analysis missing | Supplement user insights based on user description and opportunity_definition, annotate "Insight data pending supplementation" | Section 2 user requirements section simplified, requirements collection may not be complete enough | Ask user to provide user insight descriptions or upload insight-analysis.json file |
| opportunity_definition missing | Infer opportunities and priorities based on user description and insight_analysis, annotate "Priority pending confirmation" | Requirements understanding and priority ranking may not be precise enough | Ask user to provide opportunity definition and priority descriptions or upload opportunity-definition.json file |
| Both insight_analysis and opportunity_definition missing | Execute built-in requirements collection, understanding, and prioritization based on user verbal description (Step 1-3), annotate "Requirements management data is AI-inferred" | Requirements management full process relies on AI inference, confidence reduced | Ask user to provide core requirements, target users, and priority ranking |
| exploration_outputs missing | Background and objectives section annotated "Pending supplementation", generate simplified version based on user description | Section 2 content simplified | Ask user to provide product background and objective descriptions or upload discovery phase output files |
| strategy_outputs missing | OKR alignment and priority judgment section annotated "Pending supplementation" | Section 2.2 objective definition simplified | Ask user to provide strategic objectives and OKR or upload strategy phase output files |
| ideation_outputs missing | Solution design section annotated "Pending supplementation", generate feature list based on user description | Section 3 feature specs simplified | Ask user to provide feature solution descriptions or upload ideation phase output files |
| design_outputs missing | Interaction logic and state design annotated "Pending supplementation" | Section 3.2 interaction logic simplified | Ask user to provide interaction design descriptions or upload design phase output files |
| metrics_outputs missing | Tracking plan annotated "Pending supplementation" | Section 6 content simplified | Ask user to provide core metrics and tracking requirements or upload metrics phase output files |
| All upstream missing | Generate a baseline PRD (unified complete structure, content fields annotated "AI-inferred, pending confirmation") based on user verbal description, with built-in requirements collection, understanding, and prioritization | Output unified complete PRD with low-confidence annotations | Ask user to provide product requirements description, core features, and target users |

### Data Acquisition Instructions

When upstream files are missing, the user needs to provide the following information to support degraded generation:
- **Product requirements description**: What are the core requirements, what problem to solve
- **Target users**: Who are the product's target user groups
- **Core feature list**: The main feature points that need to be implemented

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| User insight added/changed | User requirements section in PRD | Annotate affected requirement items, recommend human confirmation on whether to update PRD |
| Business model change | Business model section in PRD | Annotate affected business logic, recommend human confirmation on whether to update PRD |
| OKR adjustment | Objectives and metrics section in PRD | Annotate affected metric definitions, recommend human confirmation on whether to update PRD |

When the PRD itself changes, the notification mechanism for downstream:

| PRD Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| Feature point addition/removal | change-impact-analysis | Mark change impact scope, trigger change impact analysis |
| Priority adjustment | change-impact-analysis | Mark priority change, trigger impact assessment |
| Objective metric change | metrics-system, tracking-plan | Mark metric change, trigger measurement system update |
| Business logic change | business-model-canvas, business-strategy-report | Mark business logic change, trigger strategy document update |

## Import Mode Decision Tables

> Used when design-prd runs in Import Mode (external PRD normalization). See [SKILL.md §Import Mode](../SKILL.md#import-mode-external-prd-normalization) and [import-audit-checklist.md](import-audit-checklist.md).

### Mode Selection Decision

| Condition | Mode | Rationale |
|-----------|------|-----------|
| PRD.md exists with real content AND user says "import" / "I have a PRD" | Import Mode | User has existing PRD; avoid overwriting |
| PRD.md exists with real content BUT user says "regenerate" / "rewrite" | Generate Mode | User explicitly wants regeneration |
| PRD.md is skeleton/placeholder (from setup) | Generate Mode | No real content to preserve |
| PRD.md does not exist | Generate Mode | Nothing to import |
| User provides external PRD path (not docs/product/PRD.md) | Import Mode | External document needs normalization |

### User Decision Options per Severity

| Severity | Adopt (apply fix) | Keep (preserve original) | Defer (postpone) | Acknowledge (advisory only) |
|----------|-------------------|-------------------------|------------------|-----------------------------|
| P0-Block | ✅ Allowed | ❌ Not allowed | ✅ Allowed (with owner+required_before) | ❌ N/A |
| P1-Advise | ✅ Allowed | ✅ Allowed | ✅ Allowed | ❌ N/A |
| P2-Advisory | ✅ Allowed | ✅ Allowed | ✅ Allowed | ✅ Allowed |

### Decision Recording Locations

| Decision Type | Recorded in PRD.md §9.3 Open Issues | Recorded in progress.md | Applied to PRD.md content |
|---------------|-------------------------------------|-------------------------|----------------------------|
| P0-Block → Adopt | ❌ (fixed, not an open issue) | ✅ (decision log) | ✅ (fix applied) |
| P0-Block → Defer | ✅ (with deferred marker) | ✅ (decision log) | ✅ (deferred marker added) |
| P1-Advise → Adopt | ❌ (fixed) | ✅ (decision log) | ✅ (fix applied) |
| P1-Advise → Keep | ✅ (with user rationale) | ✅ (decision log) | ❌ (preserved byte-for-byte) |
| P1-Advise → Defer | ✅ (with deferred marker) | ✅ (decision log) | ✅ (deferred marker added) |
| P2-Advisory → Adopt | ❌ (fixed) | ✅ (decision log) | ✅ (fix applied) |
| P2-Advisory → Acknowledge | ❌ (advisory only) | ✅ (decision log) | ❌ (preserved) |
| P2-Advisory → Defer | ✅ (with deferred marker) | ✅ (decision log) | ✅ (deferred marker added) |

### Gate Failure Recovery in Import Mode

| Gate Failure Scenario | Recovery Action | Max Rounds |
|----------------------|-----------------|------------|
| Gate fails on issue user already decided (Keep/Defer) | ❌ Cannot happen (circuit-breaker prevents) | 0 |
| Gate fails on NEW P0 issue (not in audit) | Present to user, offer Adopt/Defer only | 2 |
| Gate fails on NEW P1 issue (not in audit) | Present to user, offer Adopt/Keep/Defer | 2 |
| Gate fails after 2 self-correction rounds | Output problem report, require human intervention | — |
| Gate 1 fails because user deferred a P0 but deferred marker is malformed | Prompt user to fix the deferred marker format (reason+owner+required_before) | 1 (marker format only) |

### AC ID Assignment in Import Mode

| External PRD AC State | Import Mode Action | Stable-ID Rule |
|----------------------|-------------------|----------------|
| AC already matches `AC-<feature>-<sequence>` format | Preserve as-is | ✅ Compliant |
| AC uses non-standard format (e.g., "AC1", "验收标准1") | Assign new AC-xxx ID; record mapping in progress.md | New ID is immutable (no renumber/reuse) |
| AC has no ID at all | Assign new AC-xxx ID | New ID is immutable |
| AC ID has gaps (e.g., AC-F01-001, AC-F01-003, skipping 002) | Preserve gaps | ✅ Gaps are allowed per acceptance-id-protocol.md |
| Two ACs share the same ID | Assign new ID to the duplicate; record in progress.md | Original ID preserved for first occurrence; new ID for duplicate |
| AC ID format correct but content changed from previous version | Assign new ID; mark old ID as `superseded` with pointer to new ID | Per acceptance-id-protocol.md supersede rules |
