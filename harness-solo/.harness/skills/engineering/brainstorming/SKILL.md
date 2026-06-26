---
name: brainstorming
description: Requirements exploration and design refinement — a hard gate: no coding allowed until passed
---
# Brainstorming — Requirements Exploration

## When to use
- Before new feature development
- When kicking off a new project
- When requirements are ambiguous

## Inputs
- constitution.md
- rules/security.md
- docs/handoff/pm-to-solo.md
- docs/handoff/design-to-solo.md
- docs/handoff/component-map.json
- docs/product/PRD.md (read-only; sections 3.2.1 feature list, 3.2.5 data model, 3.2.6 interface definition, 4.2 tech constraints, 5 NFR, 7.1 acceptance criteria)
- docs/product/prd.json (read-only; features[], entities[], non_functional_requirements[], features[].acceptance_criteria[] for structured engineering input)
- docs/product/PROJECT.md

## Outputs
- docs/product/PROJECT.md

## Iron Rule
**No coding without clear requirements.** This is a hard gate — if you cannot pass it, stop and ask; do not guess and proceed.

## Input Sources (by priority)

1. **Handoff documents** (from harness-pm / harness-design):
   - `docs/handoff/pm-to-solo.md` — product requirements (PRD path, key decisions, open items) + **business context summary**
   - `docs/handoff/design-to-solo.md` — design handoff (design asset path, component mapping, design ACs)
   - `docs/handoff/component-map.json` — explicit mapping layer (design components → engineering components, including props/states)
   - **Mandatory read**: if `docs/handoff/design-to-solo.md` exists, you MUST read it before any technical solution exploration — skipping it drops the design contract from the entire downstream chain (writing-plans cannot fill `Contract:` lines without it, executing-plans cannot route to frontend-implementation, tdd will guess props/states). This is a hard gate, not a conditional.
   - If `docs/handoff/pm-to-solo.md` exists, read it as the source of product requirements.
   - **When reading pm-to-solo.md, you must also read the "Business Context Summary" section** to understand the business constraints behind the ACs
   - After reading, jump to step 3 of the process (technical solution exploration), skipping the requirements exploration in steps 1-2
2. **PRD direct read** (primary requirements source from harness-pm):
   - `docs/product/PRD.md` — full PRD document (sections: feature list, data model, interface definition, tech constraints, NFR, acceptance criteria)
   - `docs/product/prd.json` — structured data (features[], entities[], non_functional_requirements[], features[].acceptance_criteria[])
   - If handoff documents reference PRD paths, **read PRD sections directly** for full context that handoff AC-xxx alone cannot convey (especially data model for ER design, NFR for architecture decisions)
   - If PRD.md does not exist (early-stage project without harness-pm), fall back to PROJECT.md or user conversation
3. **Product documentation**: If `docs/product/PROJECT.md` exists and is filled in, read it as the requirements input
   - PROJECT.md is the static requirements definition (written at project kickoff); FEATURES.md is the dynamic status dashboard (updated during development)
   - After reading, jump to step 2 of the process (constitution check), skipping the requirements exploration in step 1
4. **User conversation**: If none of the above exist, explore requirements with the user in a structured way following the process below

## Process

1. **Understand the requirements**
   Use structured Q&A to clarify:
   - What problem are we solving? (user pain point)
   - Who is it for? (target users)
   - What counts as success? (acceptance criteria, described in testable terms)
   - What are we NOT doing? (explicit boundaries to avoid scope creep)

   *Exit condition: each of the four questions above has a written answer, and the "NOT doing" list contains at least one explicit item.*

2. **Constitution check**
   Read `constitution.md` and check whether the requirements violate the project constitution:
   - Will it introduce new dependencies? (zero-new-dependency principle; if needed, go through the `dependency-management` skill approval flow)
   - Does it involve APIs? (must have a test plan)
   - Does it involve schema changes? (must have a migration script, go through the `migration` skill)

   *Exit condition: every checkbox above is answered yes/no; for each "yes", the corresponding approval or migration skill is queued (or already executed) and recorded in PROJECT.md.*

3. **Technical feasibility**
   Assess whether the existing code can support the requirements:
   - Are there reusable modules?
   - What new files/modules need to be added?
   - Are there known technical risks?
   - **Business context constraint check** (if a business context summary from pm-to-solo.md exists):
     - Does the technical solution satisfy the engineering constraints in the summary? (e.g. "5GB export requires an async queue")
     - If you find a contradiction between an AC and a business constraint, **raise it proactively** instead of blindly implementing the AC
     - Write the business constraints into the technical solution section of PROJECT.md as architectural decision input

   *Exit condition: the technical solution names a concrete tech stack and at least one implementation path (files/modules to add or reuse); known risks are listed, not hidden.*

4. **Output the design document**
   Decide the write strategy based on the input source:
   - **With handoff documents + PRD**: Extract requirements from the handoff documents and PRD (PRD.md + prd.json), synthesize them into `docs/product/PROJECT.md`. PROJECT.md is the engineering-facing requirements doc maintained by solo (synthesized from PRD + handoff + constitution check); harness-pm produces PRD.md/prd.json as upstream input, solo's brainstorming translates them into PROJECT.md for engineering use. Also supplement the technical solution in the "open items" section of the handoff document or in a separate `docs/engineering/TECH_NOTES.md`
   - **Without handoff documents**: Write the confirmed requirements to `docs/product/PROJECT.md`
     - If the `docs/product/` directory does not exist, create it with a tool (do not use `mkdir -p`; use the Agent tool for cross-platform support)
     - If the file does not exist, create it; if it exists, append/update the corresponding feature rows (append a revision record)
   - The written content includes:
     - Feature description (one sentence)
     - Acceptance criteria (AC-xxx, testable)
     - Technical solution (brief)
     - Out-of-scope items (boundaries)

   *Exit condition: docs/product/PROJECT.md exists on disk and contains all four sections (feature description, AC-xxx, technical solution, out-of-scope) for the current feature.*

5. **Hard gate check**
   Confirm item by item:
   - [ ] Can the requirement be stated in one sentence (≤30 words, with no "and / or / etc." conjunctions)?
   - [ ] Does the technical solution specify a concrete tech stack and at least one implementation path?
   - [ ] Is the constitution satisfied (no unresolved violations)?
   - [ ] Have all prohibited items in `rules/security.md` been scanned and confirmed absent?

   **If any item is not satisfied → stop and ask the user; do not proceed**

   *Exit condition: all four checkboxes are ticked. If any checkbox cannot be ticked, the skill returns control to the user instead of advancing to writing-plans.*

## Prohibitions
- Starting work before requirements are clear (the most common cause of mid-sized project failures)
- Writing acceptance criteria as untestable descriptions like "the system should be easy to use"
- Skipping the constitution check
- Making requirement decisions on behalf of the user

## Anti-Rationalization Table

| Anti-pattern | Common excuse | Why it doesn't hold |
|---|---|---|
| Skipping brainstorming and jumping straight to code | "The requirements are simple" | Simple projects hide assumptions more easily; later changes cost exponentially more |
| Not reading the handoff documents | "The user already told me" | Handoff docs carry AC numbers and design constraints; a conversation can drop or misread them |
| Picking a tech stack without validation | "This library is popular" | Popular ≠ suitable; you must check compatibility, license, and maintenance status |
| Continuing past the hard gate | "Good enough for now" | "Good enough" is not "passed"; an un-passed gate produces an untestable plan downstream |
| Not writing the design document | "I'll keep it in my head" | writing-plans needs a doc input; memory drifts and is not queryable by downstream skills |
| Replacing testable ACs with vibes | "Users will know it when they see it" | "Vibes" cannot be verified by LOOP, so the feature never reaches done |

## Relationship with LOOP
This skill runs before the PLAN phase of LOOP and is the prerequisite gate for PLAN.
brainstorming (hard gate) → writing-plans (PLAN) → LOOP(tdd→verify) → ...
