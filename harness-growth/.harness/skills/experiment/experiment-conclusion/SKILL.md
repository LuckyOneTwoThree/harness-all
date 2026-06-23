---
name: experiment-conclusion
description: Generate experiment conclusions and decision recommendations (full rollout / iterate / kill), and distill knowledge base entries
triggers:
  - After experiment data analysis is complete
  - MEASURE phase of the growth experiment Loop, after experiment-analysis
  - When an experiment retrospective report is needed
reads:
  - loops/specs/<experiment>/spec.md
  - loops/specs/<experiment>/evidence.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<experiment>/evidence.md
  - loops/specs/<experiment>/state.yaml
  - memory/knowledge-base.md
  - docs/handoff/growth-to-pm.md
quality_gates: []
max_iterations: 1
---

# Experiment Conclusion — Experiment Conclusion and Distillation

## Iron Rules
- Conclusions must be based on **evidence**, not "I think it works"
- Decisions must be explicit: full rollout / iterate / kill — "let's observe more" is not allowed
- **Experiment failure is also a conclusion** — must record "why it failed" to avoid repeating the same trap
- Must distill to the knowledge base — not distilling means the experiment was wasted

## Process

1. **Read experiment evidence**
   From evidence.md, read the output of experiment-analysis:
   - Primary metric significance results
   - Guardrail metric check results
   - Segment heterogeneity analysis
   - SRM detection results

2. **Generate conclusion**
   Based on evidence, generate a structured conclusion:

   ```
   ## Experiment Conclusion

   ### Hypothesis validation
   - Hypothesis: If [change X], then [metric Y] will [change Z], because [reason]
   - Validation result: [effective / ineffective / partially effective]
   - Evidence: [p-value / effect size / confidence interval]

   ### Decision
   - Decision: [full rollout / iterate / kill]
   - Reason: [evidence-based decision rationale]

   ### Reusable insights
   - Insight 1: [e.g., "reducing form fields has a significant positive effect on activation rate"]
   - Insight 2: [e.g., "the effect is stronger for new users, with no significant difference for existing users"]
   ```

3. **Decision criteria**

   | Situation | Decision | Reason |
   |-----------|----------|--------|
   | Primary metric significant + guardrail passed | **Full rollout** | Hypothesis validated, can scale |
   | Primary metric significant + guardrail triggered | **Iterate** | Effective but with side effects, need to optimize the solution |
   | Primary metric not significant + segment heterogeneity | **Iterate** | Overall ineffective but a segment is effective, focus on that segment |
   | Primary metric not significant + no segment heterogeneity | **Kill** | Hypothesis falsified, record failure reason |
   | Insufficient sample | **Extend** | Continue collecting data until sample size is reached |
   | SRM triggered | **Redo** | Traffic split bug, experiment invalid |

4. **Generate action recommendations**
   - If full rollout: create a rollout plan (gradual release 5%→20%→50%→100%)
   - If iterate: list adjustment directions for the next round of experiments
   - If kill: record "why this hypothesis doesn't hold", update the hypothesis library status to "falsified"

5. **Distill to knowledge base**
   Append a row to the "growth experiment library" table in `memory/knowledge-base.md`:
   ```
   | G-<NNN> | [hypothesis] | [primary metric] | [effective / ineffective / uncertain (p-value)] | [full rollout / iterate / kill] | [reusable insight] | [tags] | [date] |
   ```

   Also update the "growth hypothesis library" table:
   - If hypothesis validated: change status to "validated"
   - If hypothesis falsified: change status to "falsified", record the falsification reason

6. **Update state.yaml**
   ```yaml
   stage: measure
   status: done
   last_error: ""
   ```

7. **Produce handoff document (optional)**
   If the experiment conclusion is worth feeding back to PM (major effective / ineffective findings):
   - Append to the "experiment results" section of `docs/handoff/growth-to-pm.md`
   - Or have session-end produce it at the end of the session

## Conclusion report template

```markdown
# Experiment Retrospective: <experiment-name>

## One-line conclusion
[e.g., Simplifying the sign-up form from 6 fields to 3 fields lifted activation rate by 10.2% (p=0.012); recommend full rollout]

## Experiment design recap
- Hypothesis: ...
- Primary metric: ...
- Guardrail metrics: ...
- Sample size: ...
- Experiment period: ...

## Results
[Key data excerpted from evidence.md]

## Decision and action
- Decision: full rollout
- Rollout plan: ...
- Next step: ...

## Learning distillation
- Reusable insights: ...
- Failure lessons (if any): ...
```

## Prohibitions
- Don't draw conclusions without evidence
- Don't make vague decisions ("let's observe more" is not a decision)
- Don't skip knowledge base distillation (not distilling = wasted experiment)
- Don't record only successes and skip failures (failure experiment insights are equally valuable)

## Relationship to LOOP
This skill runs in the **MEASURE phase** of LOOP; it is the last step of MEASURE.
PLAN → EXPERIMENT → MEASURE(experiment-analysis → experiment-conclusion) → DONE

## Relationship to Workflow
This skill is step 6 (the last step) of **growth-experiment-workflow**.
The knowledge base entries produced are read by hypothesis-generation in the next round of the Loop, forming compounding.
