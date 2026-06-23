# Handoff: <source framework> → <target framework>

> Generated: YYYY-MM-DD HH:MM
> Source framework: <harness-pm / harness-solo / harness-design / ...>
> Target framework: <harness-solo / harness-growth / harness-design / ...>

## Phase summary

<What this phase did, in one sentence>

## Output list

| Output | Path | Type | Notes |
|--------|------|------|------|
| PRD | docs/product/PRD.md | Markdown | Product requirements document, including feature list and acceptance criteria |
| Tracking plan | docs/metrics/tracking-plan.md | Markdown | Event tracking definition |

> Note: harness-pm produces this handoff document (with PRD path pointers), not the engineering PROJECT.md directly.
> The engineering PROJECT.md is maintained by harness-solo's brainstorming skill (written after extracting requirements from the handoff document).

## Key decisions

| Decision | Reason | Impact scope |
|------|------|---------|
| Chose option X | Supported by user research + technically feasible | Whole project |
| No feature Y | Not in MVP scope | Scope boundary |

## Acceptance criteria (AC)

Testable conditions that the downstream framework must satisfy when implementing:

- [ ] AC-001: <testable description>
- [ ] AC-002: <testable description>
- [ ] AC-003: <testable description>

## Open items

Questions that the downstream framework needs to handle or confirm with the upstream:

- Open 1: <question description>
- Open 2: <question description>

## Suggested next steps

The downstream framework should prioritize:

1. <task 1>
2. <task 2>
3. <task 3>

## Risk notes

| Risk | Level | Mitigation |
|------|------|---------|
| Technical risk X | high/medium/low | <action> |
| Dependency risk Y | high/medium/low | <action> |

---

## Downstream framework usage notes

The downstream framework's session-start skill will auto-detect this file and read it.
If not auto-recognized, you can manually point to this file path for the Agent to read.
