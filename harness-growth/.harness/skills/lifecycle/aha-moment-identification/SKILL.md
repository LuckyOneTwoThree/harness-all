---
name: aha-moment-identification
description: Aha Moment identification and validation, finding core actions through behavior-retention correlation analysis
---
# Aha Moment Identification — Aha Moment Identification

## When to use
- When it's unclear what the user aha moment is
- User operations Workflow
- User asks to "find the aha moment

## Inputs
- docs/handoff/solo-to-growth.md
- memory/knowledge-base.md

## Outputs
- docs/operations/aha-moment.md
- memory/knowledge-base.md

## Iron Rules
- Aha moment must be **validated with data**, not "I think users will like this"
- Must validate the **behavior-retention correlation** — users who performed the action have significantly higher retention
- Aha moment must be a **specific action**, not a vague feeling

## Process

1. **Candidate action list**
   Based on product features, list possible aha moment candidates:
   ```
   | Candidate action | Description | Trigger timing |
   |-------------------|-------------|----------------|
   | First message sent | User sends the first message in a channel/group | After sign-up |
   | First project created | User creates the first project | After sign-up |
   | First member invited | User invites the first collaborator | After sign-up |
   | First transaction completed | User completes the first purchase/booking | After sign-up |
   ```

2. **Behavior-retention correlation analysis**
   For each candidate action, analyze:
   ```
   | Action | Users who did it | Users who didn't | Retention difference | Correlation |
   |--------|------------------|------------------|----------------------|-------------|
   | First message sent | 7-day retention 65% | 7-day retention 15% | +50% | Strong |
   | First project created | 7-day retention 55% | 7-day retention 20% | +35% | Medium |
   | First invite | 7-day retention 80% | 7-day retention 25% | +55% | Strong |
   ```

3. **Time window analysis**
   - Aha moment should occur on the **first day / first week**
   - If the action occurs only after 7 days, it's not an aha moment (too late)
   - Analyze: among users who performed the action, how many did so on day 1?

4. **Causality validation**
   - Is it "did the action → high retention" or "high-retention users → more likely to do the action"?
   - Validate with time series: the action happens first, retention lift follows
   - If causality can't be determined, design an A/B test to validate

5. **Determine the Aha Moment**
   Select the action with the largest retention difference + highest day-1 completion rate:
   ```
   Aha Moment: [action description]
   Definition: User [completes a certain action] on day 1
   Validation: Users who did it have 7-day retention X%, those who didn't Y% (difference Z%)
   Current achievement rate: [e.g., 35% of day-1 users complete this action]
   Target achievement rate: [e.g., 50%]
   ```

6. **Write to documents and knowledge base**
   - Write to `docs/operations/aha-moment.md`
   - Sync to the "growth pattern repository" in `memory/knowledge-base.md`

## Prohibitions
- Don't substitute intuition for data validation
- Don't pick actions with small retention differences (< 10% difference may be noise)
- Don't ignore the time window (actions that occur too late are not aha moments)
- Don't confuse correlation with causation

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP(lifecycle).

## Relationship to Workflow
This skill is step 3 of **lifecycle-operations-workflow**.
Output is used by onboarding-design to design the guidance path.
