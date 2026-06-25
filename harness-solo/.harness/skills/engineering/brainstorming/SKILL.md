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
   - If any of these exists, **read it first** as the source of requirements
   - **When reading pm-to-solo.md, you must also read the "Business Context Summary" section** to understand the business constraints behind the ACs
   - After reading, jump to step 3 of the process (technical solution exploration), skipping the requirements exploration in steps 1-2
2. **Product documentation**: If `docs/product/PROJECT.md` exists and is filled in, read it as the requirements input
   - PROJECT.md is the static requirements definition (written at project kickoff); FEATURES.md is the dynamic status dashboard (updated during development)
   - After reading, jump to step 2 of the process (constitution check), skipping the requirements exploration in step 1
3. **User conversation**: If none of the above exist, explore requirements with the user in a structured way following the process below

## Process

1. **Understand the requirements**
   Use structured Q&A to clarify:
   - What problem are we solving? (user pain point)
   - Who is it for? (target users)
   - What counts as success? (acceptance criteria, described in testable terms)
   - What are we NOT doing? (explicit boundaries to avoid scope creep)

2. **Constitution check**
   Read `constitution.md` and check whether the requirements violate the project constitution:
   - Will it introduce new dependencies? (zero-new-dependency principle; if needed, go through the `dependency-management` skill approval flow)
   - Does it involve APIs? (must have a test plan)
   - Does it involve schema changes? (must have a migration script, go through the `migration` skill)

3. **Technical feasibility**
   Assess whether the existing code can support the requirements:
   - Are there reusable modules?
   - What new files/modules need to be added?
   - Are there known technical risks?
   - **Business context constraint check** (if a business context summary from pm-to-solo.md exists):
     - Does the technical solution satisfy the engineering constraints in the summary? (e.g. "5GB export requires an async queue")
     - If you find a contradiction between an AC and a business constraint, **raise it proactively** instead of blindly implementing the AC
     - Write the business constraints into the technical solution section of PROJECT.md as architectural decision input

4. **Output the design document**
   Decide the write strategy based on the input source:
   - **With handoff documents**: Extract requirements from the handoff documents and write them to `docs/product/PROJECT.md` (PROJECT.md is always maintained by brainstorming; harness-pm produces handoff documents, not PROJECT.md). Also supplement the technical solution in the "open items" section of the handoff document or in a separate `docs/engineering/TECH_NOTES.md`
   - **Without handoff documents**: Write the confirmed requirements to `docs/product/PROJECT.md`
     - If the `docs/product/` directory does not exist, create it with a tool (do not use `mkdir -p`; use the Agent tool for cross-platform support)
     - If the file does not exist, create it; if it exists, append/update the corresponding feature rows (append a revision record)
   - The written content includes:
     - Feature description (one sentence)
     - Acceptance criteria (AC-xxx, testable)
     - Technical solution (brief)
     - Out-of-scope items (boundaries)

5. **Hard gate check**
   Confirm item by item:
   - [ ] Are the requirements clear? (can be stated in one sentence)
   - [ ] Are the acceptance criteria testable? (not "easy to use", but "given input X, returns Y")
   - [ ] Is the constitution satisfied?
   - [ ] Has the user confirmed?

   **If any item is not satisfied → stop and ask the user; do not proceed**

## Prohibitions
- Starting work before requirements are clear (the most common cause of mid-sized project failures)
- Writing acceptance criteria as untestable descriptions like "the system should be easy to use"
- Skipping the constitution check
- Making requirement decisions on behalf of the user

## Relationship with LOOP
This skill runs before the PLAN phase of LOOP and is the prerequisite gate for PLAN.
brainstorming (hard gate) → writing-plans (PLAN) → LOOP(tdd→verify) → ...
