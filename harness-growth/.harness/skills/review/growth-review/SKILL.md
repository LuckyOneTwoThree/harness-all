---
name: growth-review
description: Generate a growth review report (weekly / monthly / quarterly), summarizing metrics / experiments / insights, and produce a growth-to-pm handoff document
triggers:
  - During weekly / monthly / quarterly reviews
  - When session-end detects completed experiments
  - User asks to "summarize growth progress"
  - When a growth-to-pm.md handoff document is needed
reads:
  - memory/knowledge-base.md
  - memory/progress.md
  - loops/specs/*/state.yaml
  - loops/specs/*/evidence.md
  - FEATURES.md
  - docs/handoff/growth-to-pm-template.md
writes:
  - docs/handoff/growth-to-pm.md
  - memory/knowledge-base.md
quality_gates: []
max_iterations: 1
---

# Growth Review — Growth Review Report

## Iron Rules
- The report must be based on **actual data**, not "feels good"
- Must report both **successful and failed** experiments — failure experiment insights are equally valuable
- Must give **next-step recommendations** — review is not the goal, action is
- When producing growth-to-pm.md, must fill in the template with all fields complete

## Process

1. **Collect data**
   - Read the experiment library / hypothesis library / content performance library / SEO asset library in `memory/knowledge-base.md`
   - Read `memory/progress.md` to understand what was done this period
   - Scan `loops/specs/*/state.yaml` to find experiments completed this period
   - Read the corresponding `evidence.md` for experiment data
   - Read `FEATURES.md` for overall experiment/task status

2. **Summarize core metrics**
   Organize by the standard growth review report structure:
   ```
   ## Core Metrics Dashboard
   | Metric | Previous | Current | Change | Target | Achieved? |
   |--------|----------|---------|--------|--------|-----------|
   | NSM (North Star) | ... | ... | ... | ... | ✓/✗ |
   | Acquisition metric | ... | ... | ... | ... | ... |
   | Activation metric | ... | ... | ... | ... | ... |
   | Retention metric | ... | ... | ... | ... | ... |
   | Monetization metric | ... | ... | ... | ... | ... |
   ```

3. **Experiment review**
   Summarize all completed experiments this period:
   ```
   ## Key Experiment Review

   ### Top 3 Successful Experiments
   | Experiment ID | Hypothesis | Conclusion | Impact | Decision |
   |---------------|------------|------------|--------|----------|
   | G-001 | ... | Effective (p=0.02) | Activation rate +10% | Full rollout |

   ### Top 3 Failed Experiments (and learnings)
   | Experiment ID | Hypothesis | Conclusion | Failure reason | Reusable insight |
   |---------------|------------|------------|----------------|------------------|
   | G-003 | ... | Ineffective (p=0.45) | Hypothesized user pain point doesn't hold | "Users don't care about X; the real pain point is Y" |
   ```

4. **Per-domain progress**
   ```
   ## Per-domain Progress
   - Acquisition: [this week/month's progress]
   - Activation: [progress]
   - Retention: [progress]
   - Monetization: [progress]
   - Content: [progress]
   - SEO: [progress]
   ```

5. **Issues and risks**
   ```
   ## Issues and Risks
   | Risk | Level | Impact | Mitigation |
   |------|-------|--------|------------|
   | Rising acquisition cost | High | CAC approaching LTV/3 | Optimize channel mix |
   ```

6. **Next-step plan**
   ```
   ## Next-Period Plan
   - Theme focus: [e.g., "This month focuses on activation rate optimization"]
   - Experiment roadmap: [experiments planned for next period]
   - Resource needs: [items needing engineering/design support]
   ```

7. **Produce growth-to-pm.md** (when conditions are met)
   Fill in per the `docs/handoff/growth-to-pm-template.md` template:
   - Period summary: one-line summary of this period's growth work
   - Experiment results table: conclusions of all completed experiments
   - User feedback: collected user insights
   - Growth recommendations: data-based next-step recommendations
   - Metric anomalies: abnormal fluctuations and attribution

   **Note**: If growth-to-pm.md already exists, append this period's content; do not overwrite history

8. **Update knowledge base**
   - Append "reusable insights" to the "growth pattern repository" table in knowledge-base.md
   - Update the status of related hypotheses in the "growth hypothesis library"

## Report frequency and structure mapping

| Frequency | Report structure | Focus |
|-----------|------------------|-------|
| Weekly | Metrics + running experiment progress + next-week plan | Quick sync, focus on execution |
| Monthly | Metrics + completed experiments + per-domain progress + next-month theme | Mid-term retrospective, adjust direction |
| Quarterly | NSM progress + Loop health + roadmap retrospective + next-quarter strategy | Long-term strategy, goal alignment |

## Prohibitions
- Don't report only good news and hide bad (failed experiments must be recorded)
- Don't just list data without insight (data → insight → action is the complete loop)
- Don't omit the next-step plan (the purpose of review is to guide action)
- Don't include user PII in growth-to-pm.md (privacy compliance)

## Relationship to LOOP
This skill does not run inside LOOP; it is a **session-level / period-level** report output.
Usually triggered by session-end, or executed on explicit user request.

## Relationship to Workflow
This skill is the core step of **growth-review-workflow**, orchestrating the outputs of funnel-analysis / cohort-analysis / metric-anomaly-detection into a consolidated report.
