---
workflow_id: K
name: quick-prd
description: "Fast PRD draft through conversational refinement — for vibecoding scenarios that skip full discovery"
default_mode: standard
---

# Workflow K: Quick PRD Draft

> Shared pipeline conventions (mode selection, Exploration Gate, LOOP cycle, PRD quality gates, confidence propagation, handoff batch rules): see .harness/rules/pm-pipeline.md

> Applicable scenario: User has a product idea and wants a PRD fast, without running full discovery/business/strategy modules. Ideal for vibecoding, prototyping, hackathons, or early-stage idea validation.
> Core mode: Conversational clarification → (optional) divergent thinking → draft PRD → iterative refinement → draft handoff
> Default mode: standard (allows degradation; not subject to Principle 7's deep-mode discovery-first lock)

## When to use this vs other workflows

| Scenario | Workflow |
|----------|----------|
| Vague idea, want PRD fast for coding | **quick-prd** (this one) |
| New product, need full discovery→strategy→PRD→metrics | new-product |
| Existing product, need to change/add features | iteration |
| Existing PRD draft (from this workflow), ready to upgrade | new-product or iteration (Import Mode reads draft) |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm task scope
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Phase 1: Conversational Clarification   │
│                                         │
│  User freely describes their idea.      │
│  Agent asks seed questions (adapted     │
│  from new-product Step 0 + opportunity  │
│  problem-statement template):           │
│                                         │
│  1. What product do you want to build?  │
│     What problem does it solve?         │
│  2. Who are the target users?           │
│  3. What are the core features          │
│     (top 3-5)?                          │
│  4. What platform/tech context?         │
│     (web/mobile/CLI/API/desktop)        │
│  5. What constraints (time/budget/      │
│     tech)?                              │
│                                         │
│  Agent asks follow-up questions         │
│  based on answers (max 3 rounds).       │
│  Goal: extract enough structure for     │
│  design-prd to generate a baseline.     │
│                                         │
│  👤 User confirms Agent's understanding │
│    is correct before proceeding         │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Phase 2: Divergent Expansion (optional) │
│                                         │
│  👤 User chooses: diverge or skip       │
│                                         │
│  If diverge:                            │
│  - ideation-workshop (degraded mode)    │
│    HMW questions + SCAMPER +            │
│    reverse thinking                     │
│  - Output appended to PRD.md            │
│    "Creative Solutions" section          │
│                                         │
│  If skip: go directly to Phase 3        │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Phase 3: Draft PRD Generation           │
│                                         │
│  - design-prd (draft_mode=true)         │
│    Generate Mode (PRD.md doesn't exist  │
│    or is skeleton)                      │
│    Full degradation (no upstream        │
│    artifacts)                           │
│    Output Depth: quick                  │
│    Quality gates: Gate 1-3 best-effort, │
│    Gate 4 skip                          │
│    PRD.md header: status: draft         │
│    prd.json: metadata.status = "draft"  │
│                                         │
│  👤 User reviews draft                  │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Phase 4: Iterative Refinement           │
│  (max 3 rounds recommended)             │
│                                         │
│  👤 User points out gaps / changes      │
│                                         │
│  - design-prd (draft_mode=true)         │
│    Import Mode (PRD.md now exists)      │
│    IM-1~IM-6 incremental update         │
│    User decides Adopt/Keep/Defer        │
│    per audit issue                      │
│    Quality gates: same draft_mode rules │
│                                         │
│  👤 User confirms or requests           │
│    another round                        │
│                                         │
│  If rounds exceed 3:                    │
│  → Recommend upgrading to full PRD      │
│    (new-product or iteration workflow)  │
└────────┬────────────────────────────────┘
         ▼
┌─────────────────────────────────────────┐
│ Phase 5: Draft Handoff                  │
│                                         │
│  - session-end                          │
│    progress.md: record prd_status:      │
│    draft                                │
│    pm-to-engineering.md: marked         │
│    "⚠️ DRAFT PRD — not yet validated    │
│    through full discovery"              │
│                                         │
│  Prompt user:                           │
│  "Your PRD is in draft status.          │
│   Upgrade to full PRD?"                 │
│                                         │
│  👤 User chooses:                       │
│  - Yes → enter new-product or           │
│    iteration workflow (design-prd       │
│    Import Mode reads draft, applies     │
│    full quality gates)                  │
│  - No → draft is usable for coding      │
│    but not production-ready             │
└─────────────────────────────────────────┘
```

## Key Checkpoints

- [ ] Phase 1: User confirmed Agent's understanding is correct?
- [ ] Phase 3: Draft PRD generated with status: draft?
- [ ] Phase 4: User satisfied with refined draft? (or recommended upgrade after 3 rounds)
- [ ] Phase 5: User informed of draft status and upgrade path?

## What this workflow does NOT produce

- No docs/discovery/ artifacts (user research, market analysis, insight, opportunity)
- No docs/strategy/ artifacts (BMC, positioning, OKR, North Star, roadmap)
- No docs/metrics/ artifacts (metrics system, tracking plan, dashboard)
- No docs/monitoring/ artifacts (monitoring config)

These can be added later by running new-product or iteration workflow, which will use the draft PRD as input via Import Mode.

## Failure Handling

| Failure point | Handling |
|--------|---------|
| User idea too vague for Phase 1 | Agent asks more targeted questions; if still vague after 3 rounds, suggest running new-product workflow instead |
| design-prd Gate 1 fails even in draft_mode | Mark missing sections as "TBD (to be filled)"; do not block generation |
| User wants production launch from draft PRD | Block; require upgrade to full PRD via new-product or iteration workflow first |

## Relationship with LOOP

This workflow does NOT use the standard LOOP (PLAN→RESEARCH→VALIDATE). Phase 4's iterative refinement is a lightweight substitute — each round is a mini PLAN→RESEARCH→VALIDATE cycle scoped to PRD content only.

## Next Steps

- Draft PRD ready for coding → user proceeds to harness-engineering
- Draft PRD needs upgrade → enter **new-product** (full discovery) or **iteration** (add features to existing draft) workflow
- Draft PRD validated through coding → enter **launch** workflow (acceptance & release)
