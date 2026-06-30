# Domain Boundaries and Routing

> Purpose: Prevent capability overlap from turning into duplicate execution. Independence remains available, but family collaboration uses one clear owner per outcome.

## Operating Modes

- **Standalone mode**: One harness may use its local fallback skills to complete domain-adjacent work.
- **Family mode**: When multiple harnesses are intentionally combined, the owner below executes the work; upstream frameworks define constraints and consume results.

The user chooses the operating mode. Do not infer that installed templates alone mean family mode.

## Ownership Matrix

| Outcome | Owner in family mode | Upstream contribution |
|---|---|---|
| Product strategy, PRD, product ACs | PM | Research and human decisions |
| Product analytics definitions, North Star, tracking requirements | PM | Growth/Ops may provide observed data |
| Visual/interaction system, tokens, component map, DACs | Design | PM provides PRD and Persona |
| Code, tests, architecture, engineering evidence | Solo | PM ACs + Design DACs/contracts |
| Channel/content/SEO/user operations and experiment execution | Growth | PM provides goals, hypotheses, guardrails, and tracking requirements |
| Growth statistical analysis and experiment conclusions | Growth | PM consumes conclusions and decides roadmap impact |
| Product-health interpretation and roadmap decision | PM | Growth provides growth data; Ops provides SLA/incidents |
| System observability, deployment, infrastructure, SLA/SLO | Ops | Solo provides deployable artifact and rollback contract |

## Naming Rules

- **product analytics**: User/product behavior metrics owned by PM.
- **growth experimentation**: Acquisition/activation/retention/revenue execution owned by Growth.
- **system observability**: Logs/Metrics/Traces, availability, latency, and infrastructure alerts owned by Ops.

Avoid the unqualified word “monitoring” in new contracts when one of these precise terms applies.

## Handoff Rules

In family mode:

1. PM does not run channels, publish content, or operate live growth experiments; it produces `pm-to-growth.md`.
2. Growth does not change product strategy or PRD; it produces `growth-to-pm.md` with evidence and recommendations.
3. PM product alerts do not configure infrastructure monitoring; Ops owns system observability.
4. Ops does not reinterpret business success metrics; it reports SLA, incidents, capacity, and cost to PM.
5. Standalone fallback output must be marked `mode: standalone-fallback` so it is not mistaken for an owner-produced family contract.
