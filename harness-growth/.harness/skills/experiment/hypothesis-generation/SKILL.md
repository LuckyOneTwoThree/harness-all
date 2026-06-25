---
name: hypothesis-generation
description: Generate falsifiable growth hypotheses based on data insights and growth methodology, producing structured "if X, then Y, because Z" hypotheses
---
# Hypothesis Generation — Growth Hypothesis Generation

## When to use
- When a growth experiment needs to be designed but there's no hypothesis yet
- After AARRR diagnosis identifies weak links
- After user feedback / data analysis identifies opportunities
- PLAN phase of the growth experiment Loop

## Inputs
- memory/knowledge-base.md
- docs/handoff/pm-to-growth.md
- loops/LOOP.md

## Outputs
- loops/specs/<experiment>/spec.md
- memory/knowledge-base.md

## Iron Rules
- Each hypothesis must be **falsifiable** — able to be overturned by experimental data
- Hypotheses must include three elements: if [change X], then [metric Y] will [change Z], because [reason]
- "Gut-feel" hypotheses are not allowed — must be supported by data or insight
- Must check the knowledge base before generating hypotheses, to avoid repeating already-falsified experiments

## Process

1. **Collect inputs**
   - Read the "growth hypothesis library" and "growth experiment conclusions" in `memory/knowledge-base.md` to understand validated/falsified hypotheses
   - Read `docs/handoff/pm-to-growth.md` (if available) to get growth hypotheses and OKRs from PM
   - Read `docs/handoff/solo-to-growth.md` (if available) to get implemented features and tracking events
   - If no handoff documents, get business goals and current pain points from the user conversation

2. **Identify opportunities**
   - Based on data analysis (funnel bottlenecks, retention curve anomalies, user feedback clustering)
   - Based on growth methodology (AARRR weak links, Growth Loop breakpoints, missing HOOK steps)
   - Based on competitor analysis (what competitors did effectively that we haven't done)
   - List all opportunities, annotating the data source

3. **Generate hypotheses**
   For each opportunity, generate a hypothesis using the standard template:
   ```
   Hypothesis ID: H-<NNN>
   Hypothesis: If [specific change], then [metric name] will [increase/decrease] [X%],
              because [user psychology / behavior mechanism / data basis]
   Primary metric: [metric that determines experiment success/failure]
   Guardrail metric: [monitoring metric to prevent side effects]
   Falsification condition: [what data result would overturn this hypothesis]
   Source: [data insight / user feedback / methodology / competitor]
   ```

4. **Dedup and filter**
   - Cross-reference the "growth hypothesis library" in the knowledge base; mark which hypotheses have been validated/falsified
   - Don't regenerate falsified hypotheses, unless there are new variables
   - Mark validated hypotheses as "validated, can scale"

5. **Write to spec.md**
   Write the hypothesis list to the "Hypotheses" section of `loops/specs/<experiment>/spec.md`
   Number each hypothesis individually for easy reference by subsequent ice-scoring and experiment-design

6. **Update knowledge base**
   Write newly generated hypotheses to the "growth hypothesis library" table in `memory/knowledge-base.md`, status marked "to be validated"

## Hypothesis quality checklist

- [ ] Is the hypothesis falsifiable? (Has explicit falsification conditions)
- [ ] Is the primary metric quantifiable? (Has baseline and target values)
- [ ] Do guardrail metrics cover side-effect risks?
- [ ] Is the hypothesis supported by data/methodology? (Not pure intuition)
- [ ] Has dedup been done? (No duplicate of an existing hypothesis in the knowledge base)

## Prohibitions
- Don't generate vague hypotheses (e.g., "optimizing the experience will improve retention" — not falsifiable)
- Don't generate unmeasurable hypotheses (e.g., "users will be happier" — no metric)
- Don't generate hypotheses without a reason (missing the "because" part)
- Don't skip dedup and generate directly (may repeat already-falsified experiments)

## Relationship to LOOP
This skill runs in the **PLAN phase** of LOOP; it is the starting point of the experiment loop.
PLAN(hypothesis-generation → ice-scoring → experiment-design) → EXPERIMENT → MEASURE

## Relationship to Workflow
This skill is step 1 of **growth-experiment-workflow**.
Output is ranked by ice-scoring, then used by experiment-design to design the experiment plan.
