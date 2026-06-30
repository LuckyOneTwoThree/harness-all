---
name: code-review
description: Final maintainability gate that records findings, resolves feedback, reruns affected verification, and owns the done transition.
---
# Code Review

## When to use

- After verify-full passes.
- When external review feedback arrives for an active task.
- Before merge or completion claims.

## Inputs

- `.harness/rules/engineering-pipeline.md`
- `.harness/loops/STATE_PROTOCOL.md` and `state.schema.json`
- `constitution.md`, `spec.md`, `evidence.md`, raw `state.yaml`
- complete diff plus enough unchanged context to understand interactions
- external review comments, if any

## Outputs

- `loops/specs/<task>/review.md`
- updated `state.yaml` and `iterations.log`
- code/test changes only through a routed ACT attempt

## Review Modes

Prefer an independent human or fresh-context reviewer when available. In Solo/self-review mode, perform a deliberate second pass after verification and record `reviewer_mode: self-fresh-pass`. Lack of an external reviewer does not justify skipping the gate.

## Process

### 1. Scope + Review (merged)

Confirm verify-full passed for the current diff and read the feature intent, changed files, affected contracts, and surrounding call sites. A later code change invalidates the review until affected verification reruns.

Review only dimensions not already owned by verify: responsibility boundaries and unnecessary abstraction; readability/naming and explainability of non-obvious decisions; duplication and maintainability; error semantics and cross-module interaction; performance/resource risks visible in design; diff scope and deletion/orphan cleanup caused by this change.

Do not rerun the security suite, acceptance checklist, build, or token scan here; cite verify evidence. Raise a finding only when actionable.

### 2. Record + Resolve (merged)

Record review.md with the canonical template (reviewer_mode / reviewed_revision / verification_evidence / findings table / conclusion). A clean review may legitimately contain zero findings. Never invent findings to satisfy a quota; still record reviewed scope and reasoning.

Resolve every finding: **Critical/Major** fix required (record `accepted`, route through ACT, rerun affected fast verification and verify-full, review the new revision); **Minor** fix now or defer with owner/reason; **Question** answer with evidence, change only if the answer exposes a defect; **Nit** optional, acknowledge without forced churn; **Reject** allowed with concrete spec/evidence/engineering rationale, unresolved disagreement becomes `needs-human`. Every external comment receives a response; response does not imply acceptance.

### 3. Complete

Pass requires no unresolved Critical/Major, current verify evidence, and all comments resolved. Then write:

- `stage: review`, `status: done`, clear error;
- one `code-review PASSED revision=<...>` event in iterations.log.

Changes-required writes `stage: review`, `status: retrying` or `needs-human`; it never increments iteration. The next ACT attempt increments before mutation.

## Invalid Review Patterns

- requiring fabricated findings (“fewer than three means shallow”);
- reviewing only changed lines without interaction context;
- duplicating verify checks instead of assessing maintainability;
- marking a finding fixed without current verification;
- approving a revision different from the reviewed/verified revision;
- setting done anywhere before this gate.

## Relationship with LOOP

Outside LOOP but closes delivery; a required fix re-enters ACT and review reruns on the re-verified revision. See `.harness/loops/LOOP.md`.
