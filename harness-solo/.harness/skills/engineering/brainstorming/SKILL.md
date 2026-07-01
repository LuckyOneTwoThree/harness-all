---
name: brainstorming
description: Resolves material requirement ambiguity and records an executable engineering-facing requirement boundary without choosing speculative implementation.
---
# Brainstorming

## When to use

- New/changed behavior has material ambiguity.
- Product-level feature inventory or success criteria are incomplete.
- Upstream requirements conflict with business, design, security, or engineering constraints.

Do not invoke ceremonially when a validated upstream/current spec is already executable. Bug reproduction, performance measurement, migration decision, and refactor equivalence are owned by their specialist skills.

**Plan-stage merge**: In standard/deep mode, brainstorming and writing-plans may be executed as one continuous Plan stage without a pause between them — brainstorming resolves ambiguity, then writing-plans immediately consumes the resolved requirements to produce spec.md + state.yaml. The two skills remain separate artifacts (PROJECT.md updates vs spec.md), but the workflow does not force a pause between them unless a material user-owned decision surfaces. When such a decision surfaces, the escalation path is the writing-plans Gate (the sole Plan-stage break point); brainstorming does not pause independently.

## Inputs

- `constitution.md`, risk/security rules, `TECH_STACK.md`
- authoritative local `PROJECT.md`
- validated PM/Design package contracts and bundled PRD/design artifacts when present
- user decisions and relevant existing-code evidence

## Outputs

- updated `docs/product/PROJECT.md` requirement/boundary records
- material unresolved decisions returned to the user
- optional ADR request for writing-documentation after an architecture decision is actually made

Never edit an inbound handoff or independently edit derived `prd.json`.

## Source Priority

1. Validated ready handoff package and authoritative bundled PRD.md.
2. Existing PROJECT.md revision.
3. Explicit user decision.
4. Existing implementation as evidence of current behavior—not automatic authority for desired behavior.

Conflict is surfaced; lower-priority material does not silently override higher-priority intent. **Family frontend hard gate**: family-mode frontend work enforces PM Delivery Routing and a ready Design package before planning.

## Process

### 1. State the Ambiguity

Name the exact missing/conflicting decision and why it changes observable behavior, scope, risk, or architecture. If no material ambiguity remains, stop successfully and let writing-plans use the existing source.

### 2. Explore the Minimum Decision Set

Ask only questions needed to determine:

- user/problem and observable outcome;
- stable acceptance behavior and failure/edge behavior;
- explicit non-goals;
- business/NFR constraints and affected contracts;
- material choices the user owns.

Do not impose arbitrary word counts, require a fake non-goal, or pause for confirmation of facts already explicit in a validated contract.

Deep mode compares material alternatives, rollback/operational impact, and cross-feature effects. Standard mode resolves only the blocking ambiguity. Both produce the same artifact shape.

### 3. Feasibility and Constitution Screen

Read the existing TECH_STACK rather than selecting a new stack by popularity. Identify reusable boundaries, dependency/schema/API/security implications, and contradictions with business/NFR constraints.

- New dependency routes to dependency-management.
- Schema/data migration routes to migration planning.
- Product/design contract defect blocks and routes feedback to its owner.
- Material architecture choice requires explicit decision and optional ADR.

This screen proves an implementation path exists; detailed tasks belong to writing-plans.

### 4. Record Requirements

Update PROJECT.md only with product/engineering-facing requirement facts:

- feature/outcome;
- stable AC IDs and source revision;
- in/out scope;
- business/NFR/compatibility constraints;
- open decisions with owner and required-before milestone.

Do not duplicate source-code task breakdown, framework bindings, API endpoint design, or implementation detail here.

## Exit Gate

- Observable outcome and boundaries are clear.
- Stable criteria are testable and source-traceable.
- No material user-owned decision is silently assumed.
- Feasibility/constitution implications have an owner/route.
- Writing-plans can create tasks without guessing.

## Relationship with Pipeline

Brainstorming is a conditional clarification skill before PLAN, not a mandatory step in every non-quick workflow.
