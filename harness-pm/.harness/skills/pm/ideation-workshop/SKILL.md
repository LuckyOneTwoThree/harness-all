---
name: ideation-workshop
description: Use when you need creative divergence, solution ideation, or creative convergence workshops. Integrates multi-method divergence (HMW/SCAMPER/Reverse Thinking) and creative convergence.
---
# Creative Workshop

## When to use
- Help me brainstorm ideas
- Innovate using the SCAMPER method
- Think in reverse
- Too many options, which one to choose
- Let's brainstorm
- Creative workshop
- Keywords: creative divergence, creative convergence, HMW, SCAMPER, reverse thinking, creative workshop

## Inputs
- rules/security.md
- loops/LOOP.md
- docs/discovery/insight.md
- docs/discovery/opportunity.md

## Outputs
- docs/product/PRD.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **Questions matter more than answers** — The quality of HMW determines the quality of subsequent solutions; broad and solution-preset HMW is poison for creativity
2. **Seven dimensions are the insurance for divergence** — SCAMPER's seven dimensions ensure thinking doesn't fall into a single pattern, with at least 2 solutions per dimension
3. **Failure is more inspiring than success** — First figure out "why we would die", then figure out "how to live"; constraints are guardrails for creativity, not shackles
4. **Convergence is deepening, not elimination** — Filtered solutions must undergo complete deepening, not simple ranking
5. **Human decision rights cannot be transferred** — AI provides analysis and recommendations; final solution selection must be decided by humans
6. **Quantity before quality** — The divergence phase pursues solution quantity; the convergence phase filters; early judgment is the enemy of creativity

The creative workshop integrates four methods: HMW problem reframing, SCAMPER structured divergence, reverse thinking, and creative convergence, forming a complete "diverge → converge" creative process. Step 1 transforms problem statements into open-ended questions through HMW; Step 2 executes SCAMPER and reverse thinking in parallel to maximize divergence output; Step 3 completes creative convergence through filtering, deepening, and comparison matrix, providing structured support for human decision-making.

### Execution Role

🤖→👤 **AI suggests, human approves**

- **AI is responsible for**: HMW generation, SCAMPER solution generation, reverse thinking analysis, solution filtering, deepening analysis, comparison matrix generation
- **Human is responsible for**: HMW approval, final solution selection, priority confirmation, action item decisions

---

## Interaction Mode

🤖→👤 AI suggests, human approves

## Input

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Problem Statement | string | Yes | User-provided / Upstream output | Clearly and specifically describe the problem to be solved, avoiding being too abstract or broad |
| User Research Data | JSON/object | Yes | User-provided / Upstream output | Include at least one type of user research data (interview, survey, or behavior data) to ensure HMW generation is evidence-based |
| Current Solution | JSON/object | ○ | User-provided | Description of the current product's existing solution, including features and limitations |
| Competitor Solutions | JSON/array | ○ | User-provided | Analysis of at least 2-3 competitor solutions, including features, advantages, and disadvantages |
| Product Context | JSON/object | ○ | User-provided | Product strategy and resource constraint information |

### Input Format

> 📋 See [Reference/input-format.md](./Reference/input-format.md) for details

---

## Progressive-Disclosure Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/progressive-disclosure.md](Reference/progressive-disclosure.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Output

**Storage path**: `docs/product/PRD.md ("Creative Solutions" section)`
**Output files**: ideation-workshop.json + ideation-workshop.md

### Output Schema

`ideation-workshop.json` must conform to the complete data structure; field-level constraints are subject to the "Output Validation Rules".

> 📋 See [Reference/output-structures.md](./Reference/output-structures.md) (ideation-workshop.json Complete Data Structure section)

### ideation-workshop.md

Markdown format creative workshop report, including:
1. HMW problem reframing summary
2. SCAMPER solution list and clustering
3. Reverse thinking analysis summary
4. Converged solution comparison matrix
5. Human decision recommendations

---

## Output Validation Rules

> 📋 See [Reference/validation-rules.md](./Reference/validation-rules.md) for details

## Decision Rules

### Step 1 HMW Pass Conditions

1. **Quality check**: All HMW must pass the quality check
2. **Dimension coverage**: All 6 dimensions must have HMW coverage
3. **Data support**: Each HMW must have corresponding user research data support
4. **Scoring complete**: All HMW must complete divergence potential scoring

### Step 2 Parallel Divergence Pass Conditions

1. **SCAMPER solution count**: At least 10 candidate solutions generated
2. **SCAMPER dimension coverage**: All 7 SCAMPER dimensions must have solution coverage
3. **SCAMPER scoring completeness**: Each solution must have scores for all 4 dimensions
4. **SCAMPER clustering completeness**: All solutions must belong to a cluster
5. **Reverse thinking failure paths**: 10-15 failure paths generated, covering 5 dimensions
6. **Reverse thinking constraint transformation**: Each success condition transformed into specific design constraints

### Step 3 Convergence Pass Conditions

1. **Solution filtering**: Exclude solutions with feasibility < 2, exclude solutions conflicting with Critical/High constraints
2. **Solution deepening**: Top 5 solutions deepened, each solution includes all 6 dimensions
3. **Comparison matrix**: 6 dimensions complete, scoring criteria unified
4. **Human decision**: Final solution selection must be decided by humans

### Failure Handling

> 📋 See [Reference/failure-handling.md](./Reference/failure-handling.md) for details

---

## Quality Check

> 📋 See [Reference/quality-checklist.md](./Reference/quality-checklist.md) for details

---

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact | Data Acquisition Instructions |
|---------------|---------|---------|------------|
| Problem Statement missing | User describes the problem, directly generate HMW | Lacks structured Problem Statement, HMW may not be focused enough | Ask user to provide problem description and core pain points or upload opportunity-definition.json file |
| User research data missing | User describes the problem, directly generate HMW | Lacks user research data support, HMW may deviate from user needs | Ask user to provide user research conclusions or upload persona.json/voice-analysis.json files |
| Both Problem Statement and user research data missing | User describes the problem, directly generate HMW | Overall confidence reduced, HMW may be too broad | Ask user to provide problem description and core user pain points |
| Current solution description missing | Generate solutions directly based on HMW, no improvement baseline | Lacks current solution reference, substitute/modify dimension solutions may not be precise enough | Ask user to provide current product solution description and known shortcomings |
| Competitor solution data missing | Skip competitor borrowing, generate based on HMW and current solution | Lacks competitor solution reference, adapt dimension solutions may not be rich enough | Ask user to provide competitor solution description or upload competitor-analysis.json file |
| All upstream files missing | Prompt user to execute preceding phases first, or generate directly based on user verbal description | Output is only a basic HMW list and solution framework | Ask user to provide problem description, user pain points, and expected solution direction |

## Upstream Change Response

> 📋 See [Reference/upstream-change-response.md](./Reference/upstream-change-response.md) for details
