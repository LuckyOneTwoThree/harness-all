---
name: validation-usability
description: Used when assistance is needed for usability testing. Usability testing assistance tool that provides AI-supported help across pre-test, during-test, and post-test phases: generates task scripts and recruitment surveys before testing, and organizes data and generates insight reports after testing. Note: Actual test execution must be led by a human researcher. This Skill consumes the method selection from validation-experiment (when method=usability test), generating specific test task scripts, recruitment surveys, and test reports.
---
# Usability Testing Assistance

## When to use
- How to conduct usability testing
- Help me design test tasks
- How to run user experience testing
- Keywords: usability testing, task scripts, recruitment screening, problem clustering, insight extraction, user experience testing, test tasks

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/product/PRD.md
- docs/metrics/experiment-report.md
- docs/handoff/design-to-solo.md

## Outputs
- docs/product/PRD.md
- docs/handoff/pm-to-design.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **User behavior is more truthful than user opinions** — Observe what users do, not what they say
2. **5 users find 85% of problems** — Usability testing doesn't need large samples; 5-8 people can uncover major issues
3. **Severity determines fix priority** — Critical issues must be fixed; minor issues can be scheduled
4. **Test reports must be actionable** — Every finding must map to an improvement suggestion; non-actionable findings are noise

### Basic Information

| Attribute | Value |
|------|-----|
| Pipeline ID | 13 |
| Name | Usability Testing Assistance |
| Execution Mode | 👤→🤖 Human executes, AI assists |
| Input | Assumption map + MVP features + Test goals |

## Interaction Mode

👤→🤖 Human executes, AI assists

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Usability test plan | object | Yes | docs/product/PRD.md ("Assumption Map" section) | Test goals, assumption map, MVP features |
| Test participants | object | Yes | User-provided | Target user personas, recruitment screening criteria |
| Test task scenarios | object | Yes | User-provided or harness-design output | Usability hypotheses to validate and task scripts (if harness-design has produced prototypes, read prototype paths referenced in docs/handoff/design-to-solo.md) |
| Experiment method selection | object | ○ | docs/metrics/experiment-report.md ("Experiment Design" section) | When method=usability test, consumes the method selection and experiment framework from validation-experiment |

## Execution Steps

### ⚠️ Important Note

Usability testing is the only phase that must be **led by a human researcher**. AI provides assistance in this workflow:

| Phase | Executor | AI Assistance Content |
|------|--------|------------|
| Pre-test | 👤 Preparation | Generate task scripts, recruitment surveys, observation record templates |
| During test | 👤 Execution | Human researcher leads the test |
| Post-test | 👤+🤖 | AI organizes and analyzes, human reviews and confirms |

### Pre-test AI Assistance

#### Step 1: Determine Test Goals

Define usability test goals based on the assumption map.

> See [Reference/examples.md](./Reference/examples.md#step-1-determine-test-goals) for the `test_goals` JSON schema.

#### Step 2: Generate Task Scripts

**Rule**: Each task maps to a usability hypothesis to be validated

> 🔗 **Upstream Consumption**: When experiment_method input exists and selected_method=usability_test, design specific test task scripts based on experiment_framework (hypotheses, metrics, sample size, duration); otherwise, design independently based on the assumption map and test goals.

> See [Reference/examples.md](./Reference/examples.md#step-2-generate-task-scripts) for the `task_script` JSON schema.

#### Step 3: Generate Recruitment Screening Survey

**Screening Criteria**:
- Target user persona match
- Product usage experience requirements
- No conflict of interest

> See [Reference/examples.md](./Reference/examples.md#step-3-generate-recruitment-screening-survey) for the `recruitment_survey` JSON schema.

#### Step 4: Generate Observation Record Template

> See [Reference/examples.md](./Reference/examples.md#step-4-generate-observation-record-template) for the `observation_template` JSON schema.

### Post-test AI Assistance

#### Step 5: Structured Test Record Organization

Convert raw test records into structured data.

> See [Reference/examples.md](./Reference/examples.md#step-5-structured-test-record-organization) for the `structured_records` JSON schema.

#### Step 6: Automatic Problem Clustering

**Clustering Dimensions**:

| Dimension | Description |
|------|------|
| Severity | Critical / Major / Moderate / Minor |
| Frequency | High / Medium / Low |
| Affected Stage | Navigation / Operation / Feedback / Content |

**Severity Definitions**:

| Level | Definition | Impact |
|------|------|------|
| Critical (P0) | Task cannot be completed | Causes user abandonment |
| Major (P1) | Task requires significant assistance | Severely impacts efficiency |
| Moderate (P2) | Task is difficult but completed | Affects user experience |
| Minor (P3) | Operation is inconvenient but acceptable | Optimization item |

> See [Reference/examples.md](./Reference/examples.md#step-6-automatic-problem-clustering) for the `problem_clusters` JSON schema.

#### Step 7: Insight Extraction

**Three Types of Insights**:

| Type | Description | Example |
|------|------|------|
| Hypothesis validation | Whether hypothesis is validated | A001 hypothesis confirmed/rejected/partially confirmed |
| Design changes | Design points needing adjustment | Recommendation display position adjustment |
| Unexpected findings | New problems/opportunities discovered during testing | Discovered new user scenario |

> See [Reference/examples.md](./Reference/examples.md#step-7-insight-extraction) for the `insights` JSON schema.

#### Step 8: Generate Improvement Suggestions

**Priority Ranking Rules**:

1. P0 issues → Fix immediately
2. P1 issues → High priority
3. P2 issues → Medium priority
4. P3 issues → Low priority

> See [Reference/examples.md](./Reference/examples.md#step-8-generate-improvement-suggestions) for the `improvement_suggestions` JSON schema.

### Output Depth Tiers

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Usability issues and improvement suggestions | Core conclusions + minimum viable artifact |
| standard | Full artifact (current default) | Full artifact, including all Step outputs |
| deep | Full assessment + usability scoring system + priority ranking + improvement roadmap | Full artifact + extended analysis + deep reasoning |

## Output

**Storage Path**: `docs/product/PRD.md ("Usability Testing" section)`
**Output File**: usability_report.json

> See [Reference/examples.md](./Reference/examples.md#output-file-usability_reportjson) for the output `usability_report` JSON schema.

**Output Validation Rules**: See [Reference/output-schema.md](./Reference/output-schema.md) for field-level validation rules.

## Decision Rules

| Situation | Handling |
|------|----------|
| P0 issue (task cannot be completed) | Fix immediately, block release |
| Same issue encountered by 3/8+ users | Mark as high-frequency issue, prioritize |
| Hypothesis overturned | Update assumption map, adjust design direction |
| Fewer than 5 test participants | Results are for reference only; recommend additional testing |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Problem severity grading (P0/P1/P2/P3 grading is reasonable)
- [ ] Insight hypothesis linkage (insights correspond to the assumption map)

### P1 Checks (must pass for standard/deep)

- [ ] Improvement suggestions actionable (suggestions are clear and actionable)
- [ ] Data completeness (test data is complete with no omissions)

### P2 Checks (only deep must pass)

- [ ] Extended analysis complete (deep reasoning and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

---

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Notes |
|---------------|---------|---------|------------|
| Prototype data missing | User provides design description, generate test scripts | Lacks prototype data, test tasks may be less precise | Ask user to provide design description and page screenshots or upload prototype file |
| Assumption map missing | User provides design description, generate test scripts | Lacks assumption map data, test goals may be less focused | Ask user to provide key hypothesis list or upload assumption-map file |
| Both prototype and assumption map missing | User provides design description, generate test scripts | Overall confidence reduced, test scripts may be incomplete | Ask user to provide design description and key hypotheses |
| All upstream files missing | Prompt user to run preceding stages first, or generate test scripts based on user description | Output is only a basic test framework | Ask user to provide design description, core features, and test goals |

## Upstream Change Response

### Upstream Change Impact

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| Prototype change (page/interaction modification) | Test tasks, test scripts | Mark affected test tasks; recommend human confirm whether to update test scripts |
| Assumption map change (hypothesis add/remove or score change) | Test goals, hypothesis validation items | Mark affected test goals; recommend human confirm whether to adjust test focus |
| MVP scope change | Test scope | Mark affected test scope; recommend human confirm whether to adjust test coverage |

### Downstream Notification Mechanism

| Usability Test Report Change Type | Notification Scope | Notification Method |
|----------------------|----------|----------|
| Problem finding add/remove | harness-design (via docs/handoff/pm-to-design.md feedback) | Mark problem change, trigger harness-design prototype and interaction spec update |
| Hypothesis validation result change | validation-assumption-map, validation-mvp | Mark validation result change, trigger assumption map and MVP scope update |
| Improvement suggestion change | harness-design (via docs/handoff/pm-to-design.md feedback) | Mark suggestion change, trigger harness-design prototype update |

---

## Usage Example

**Test Execution**: Human researcher leads, 8 users participate

**AI-Assisted Output**: Same structure as the output JSON above, where `problems`/`insights`/`improvement_suggestions` arrays are populated based on actual test results, with field meanings consistent with the output validation rules.

> See [Reference/examples.md](./Reference/examples.md#complete-example-course-recommendation-feature-usability-test-report) for a complete worked example: Course Recommendation Feature Usability Test Report, including populated `problems`, `insights`, and `improvement_suggestions` arrays with example notes and priority handling.
