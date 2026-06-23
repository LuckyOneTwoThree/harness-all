# orchestrator-protocol.md

> Purpose: orchestrator orchestration protocol specification, defining how an orchestrator orchestrates pipeline skills.
>
> All orchestrators (skills with type: "orchestrator") must follow this protocol. The orchestrator is only responsible for **orchestration**, not **execution** — the actual work is done by pipeline skills.

## 1. Orchestrator responsibility definition

The orchestrator is the **orchestrator**, not the **executor**.

| Responsibility | Description |
|------|------|
| Schedule pipeline skills | Call sub-skills in stage order / parallel / conditional |
| Pass context | Pass the upstream skill's output as the downstream skill's input |
| Gate quality gates | Check gate conditions at the end of each stage; block or degrade if not passed |
| Generate phase summary | Produce `output/phase-reports/<orchestrator-name>.json` in the post_pipeline phase |
| Connect downstream | Declare primary/alternatives downstream orchestrators |

**Prohibited actions**:
- The orchestrator does not directly produce business documents (docs/); documents are produced by pipeline skills
- The orchestrator does not replace pipeline skills to do specific analysis work
- The orchestrator does not skip gate checks to enter the next stage directly

## 2. Orchestration modes

The orchestrator supports three orchestration modes, declared via `depends_on` in the Pipeline's `stages`:

### 2.1 Sequential orchestration

Stages have dependencies; the next executes only after the previous one completes.

```yaml
stages:
  - id: phase-1
    name: "Step one"
    depends_on: []
    skills: [skill-a]
  - id: phase-2
    name: "Step two"
    depends_on: [phase-1]
    skills: [skill-b]
```

### 2.2 Parallel orchestration

Stages without dependencies can execute in parallel, used to accelerate collection-type tasks.

```yaml
stages:
  - id: phase-1
    name: "Parallel collection"
    depends_on: []
    skills:
      - skill-a
      - skill-b
    gate:
      condition: "skill-a.json + skill-b.json are both generated and verified"
      fail_action: "Failed sub-skills use the degraded plan to continue; do not block the other sub-skill"
```

### 2.3 Conditional orchestration

Decide whether to execute a stage based on upstream results or context, controlled via `gate.condition`.

```yaml
stages:
  - id: phase-2
    name: "Conditional step"
    depends_on: [phase-1]
    skills: [skill-c]
    gate:
      condition: "Execute when phase-1 output contains field X"
      fail_action: "Skip this stage, label 'condition not met'"
```

## 3. Interface with pipeline skills

The orchestrator and pipeline skills collaborate via **input/output contracts**.

### 3.1 Input contract

The orchestrator passes to pipeline skills:
- Basic parameters provided by the user (category_keywords, target_market, etc.)
- Output references from upstream skills (`<skill-name> → <output-file>.json`)
- Context variables (e.g., segment_data, retention_data)

### 3.2 Output contract

Pipeline skills must produce:
- **Business documents**: write to the specified section of `docs/<module>/<file>.md`
- **Machine data** (optional): write JSON for downstream skills to consume

### 3.3 Call specification

Each pipeline skill's call block should include:

```
Skill: <skill-name>
Input:
  <param>: <source>
Output: docs/<module>/<file>.md ("<section>")
Verification: <verification condition>
Mode: AI / AI→Human
```

- `Mode: AI` means AI executes automatically
- `Mode: AI→Human` means human approval is required after AI execution

## 4. State management

The orchestrator passes context between stages via the following mechanisms:

| Pass method | Usage | Example |
|---------|------|------|
| File reference | Pass structured output across stages | `tam_som_ref: docs/discovery/market-analysis.md` |
| JSON data | Pass machine-consumed data across skills | `output/metrics/<id>.json` |
| Context variables | Share parameters within the same stage | `user_segment_data` |
| memory/progress.md | Persist progress across sessions | orchestrator completion state |

**Context passing rules**:
- The upstream skill's output path is explicitly declared as the downstream skill's input parameter
- The orchestrator does not modify pipeline skill output files; it only references them
- Cross-session state is written to `memory/progress.md`, managed by session-start/session-end

## 5. Error handling

When a pipeline skill fails, the orchestrator degrades per the following strategies:

| Exception type | Handling strategy |
|---------|---------|
| Single skill failure (parallel stage) | Do not block other skills in the same stage; mark the failed skill as "degraded execution" |
| Single skill failure (sequential stage) | Try the degraded plan to continue; if it cannot degrade, block the stage and request human intervention |
| Gate condition not met | Handle per `fail_action`: supplement input / check upstream / degrade execution |
| All upstream data missing | Degrade to a lightweight flow, generate based on the AI knowledge base, label "inferred value" |
| Phase summary generation failed | Generate a partial summary based on completed skill outputs; mark missing items as "data missing" |
| Iteration limit exceeded | Block auto-handoff, request human intervention (see LOOP.md for details) |

**Degradation principles**:
- Degraded output must be labeled "degraded execution" or "inferred value"
- Degraded output must be human-confirmed before being passed downstream
- Degraded output with confidence < 0.3 blocks auto-handoff

## 6. Orchestration protocol example

Below is a complete orchestrator Pipeline example:

```yaml
pipeline: example-orchestrator
version: 1.0

post_pipeline:
  - action: stage-summary
    output: output/phase-reports/example-orchestrator.json

stages:
  # Stage 1: parallel collection (no dependencies)
  - id: phase-1
    name: "Parallel collection"
    depends_on: []
    skills:
      - skill-a
      - skill-b
    gate:
      condition: "skill-a.json + skill-b.json are both generated and verified"
      fail_action: "Failed sub-skills use the degraded plan to continue; do not block the other sub-skill"

  # Stage 2: integrated analysis (depends on stage 1)
  - id: phase-2
    name: "Integrated analysis"
    depends_on: [phase-1]
    skills: [skill-c]
    gate:
      condition: "Executive summary contains 3 core findings, Feature Matrix updated"
      fail_action: "Check whether upstream data is complete or supplement input parameters"

  # Stage 3: human approval (depends on stage 2)
  - id: phase-3
    name: "Human approval"
    depends_on: [phase-2]
    skills: [skill-d]
    gate:
      condition: "Human approval passed, decision record written to approval.json"
      fail_action: "Resubmit revised plan, iteration limit 3"
```

### Phase summary structure (post_pipeline output)

`output/phase-reports/<orchestrator-name>.json` must contain the following 6 structures (none can be empty):

1. **Execution overview**: orchestrator name and version, execution time, sub-skill execution status (success / failure / degraded)
2. **Key findings**: each sub-skill's core output summary (1-3 items), cross-sub-skill insights
3. **Decision record**: human decision points and decision results, AI automatic decisions and their basis
4. **Output list**: all output file paths and content summaries, output quality assessment (whether verification passed)
5. **Risks and to-dos**: items that did not pass verification, items degraded, suggested follow-up items
6. **Downstream connection**: which downstream orchestrators can consume this orchestrator's output, recommended next orchestrator

### Downstream connection declaration

```yaml
downstream_connection:
  primary: <next-orchestrator> (<trigger condition>)
  alternatives:
    - target: <alternative-orchestrator>
      reason: <selection reason>
      condition: <trigger condition>
  special_cases:
    - target: <skill-name>
      reason: <selection reason>
      condition: <trigger condition>
```
