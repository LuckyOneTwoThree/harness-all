---
name: onboarding-design
description: Onboarding flow design, guiding new users to reach the aha moment on day 1
triggers:
  - When new user activation rate is low
  - User operations Workflow
  - User asks to "design an onboarding flow"
reads:
  - docs/handoff/solo-to-growth.md
  - memory/knowledge-base.md
writes:
  - docs/operations/onboarding-plan.md
quality_gates: []
max_iterations: 2
---

# Onboarding Design — Onboarding Flow Design

## Iron Rules
- The sole goal of onboarding is to **guide users to the aha moment**
- Each step must **reduce friction**, not add steps
- Must define **activation metrics** and **success thresholds**

## Process

1. **Identify the aha moment**
   - What is the moment when the user first feels the core value?
   - E.g., Slack = first message in a channel, Airbnb = first completed booking
   - If not defined, first call the aha-moment-identification skill

2. **Design the onboarding path**
   ```
   Sign-up → [Step 1] → [Step 2] → ... → aha moment

   Principles:
   - Steps ≤ 5 (each extra step adds 10-20% churn)
   - Each step has a clear goal
   - Each step has a progress indicator
   - Non-essential steps can be skipped
   ```

3. **Design each step's details**
   For each step, define:
   ```
   | Step | Goal | User action | Expected completion rate | Friction point | Optimization direction |
   |------|------|--------------|--------------------------|----------------|-------------------------|
   | 1. Welcome | Set expectations | Read intro | 95% | None | - |
   | 2. Create space | Core action | Enter name | 70% | Naming difficulty | Provide templates |
   | 3. Invite members | Activate virality | Enter email | 40% | Fear of bothering | Emphasize value |
   | 4. First use | aha | Complete first task | 60% | Don't know what to do | Guidance + templates |
   ```

4. **Design activation metrics**
   ```
   Activation definition: User [completes core action] on day 1
   Activation threshold: [e.g., "sends ≥ 1 message on day 1"]
   Current activation rate: [e.g., 35%]
   Target activation rate: [e.g., 50%]
   ```

5. **Design trigger mechanism**
   - How to trigger when a user is stuck at a step? (email/push/modal)
   - Trigger timing? (e.g., "24h after sign-up, step 3 not completed")
   - Trigger content? (targeted reminder, not generic push)

6. **Produce onboarding plan**
   Write to `docs/operations/onboarding-plan.md`

## Prohibitions
- Don't design too many steps (> 5 steps leads to high churn)
- Don't force completion of all steps (allow skipping non-essential steps)
- Don't ignore the aha moment (the goal of onboarding is to reach aha)
- Don't build a generic onboarding (different segments should have different paths)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP(lifecycle).

## Relationship to Workflow
This skill is step 2 of **lifecycle-operations-workflow**.
