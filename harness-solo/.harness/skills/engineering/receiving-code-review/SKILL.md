---
name: receiving-code-review
description: Receive and process code review feedback — triage + fix + reply
---
# Receiving Code Review — Handling Review Feedback

## When to use
- After requesting-code-review returns an issue list
- When external code review feedback is received
- When the user points out code issues

## Inputs
- rules/security.md
- loops/specs/<feature>/spec.md
- loops/specs/<feature>/evidence.md
- loops/specs/<feature>/iterations.log

## Outputs
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/iterations.log
- loops/specs/<feature>/evidence.md

## Iron Rule
**Every piece of feedback must receive a response; none may be ignored.** Responding ≠ accepting, but you must clearly state "fix / won't fix / discuss".

## Process

1. **Collect feedback**
   - Get the issue list from the `requesting-code-review` skill
   - Or collect from external review (PR review, user feedback)
   - Record the original text of each piece of feedback

2. **Triage** (by severity)

   | Level | Definition | Handling |
   |------|------|---------|
   | **Critical** | Functional bug / security vulnerability / data loss | Must fix; immediately return to tdd |
   | **Major** | Design flaw / performance issue / poor maintainability | Must fix; resolve within this round |
   | **Minor** | Naming / comments / style | Should fix; can be batched |
   | **Question** | Reviewer is unsure; needs discussion | Reply with explanation; may not require a change |
   | **Nitpick** | Personal preference; inconsequential | Can be ignored, but reply politely |

3. **Respond item by item**

   For each piece of feedback, choose one response:

   - **Accept and fix**:
     - Return to `test-driven-development`: write a test reproducing the issue → fix → verify
     - After fixing, append to iterations.log: `[time] review-fix: <feedback summary> → FIXED`

   - **Reject with explanation**:
     - Give a reason (e.g. "violates YAGNI", "conflicts with spec.md boundaries", "performance impact is negligible")
     - Append to iterations.log: `[time] review-reject: <feedback summary> → REJECTED: <reason>`

   - **Discuss**:
     - The feedback itself needs more information to decide
     - Ask the user and wait for clarification
     - Append to iterations.log: `[time] review-discuss: <feedback summary> → PENDING DISCUSSION`

4. **Update evidence.md**
   - Append a "Code Review Response" section to evidence.md:
     ```markdown
     ## Code Review Response

     | # | Level | Feedback | Response | Status |
     |---|------|------|------|------|
     | 1 | Critical | [feedback] | Fix | FIXED |
     | 2 | Major | [feedback] | Fix | FIXED |
     | 3 | Minor | [feedback] | Accept | FIXED |
     | 4 | Question | [feedback] | Explain | RESOLVED |
     | 5 | Nitpick | [feedback] | Ignore | WONTFIX |
     ```

5. **Second-round review** (if there are Critical/Major fixes)
   - After fixing Critical/Major, re-invoke `requesting-code-review` for re-review
   - Re-review passes → review closed loop complete
   - Re-review still has issues → return to step 2

## Response Principles

- **Honest**: do not pretend to accept to "pass the review" while secretly not changing
- **Well-reasoned**: rejection must give a reason, not just "I don't think it needs changing"
- **Non-defensive**: review helps you improve; it is not an attack; do not defend the code
- **Distinguish preference from problem**: a reviewer's personal preference can be rejected, but objective issues must be fixed

## Prohibitions
- Ignoring feedback without responding (even a nitpick must be acknowledged as "ignored")
- Pretending to fix without actually changing (violates the honesty principle)
- Batch-accepting all feedback without thinking (some feedback may be wrong)
- Claiming FIXED without running tests after a fix

## Anti-Rationalization Table

When you catch yourself thinking the excuse in column 2, read column 3 and resume the response.

| Anti-pattern | Common Excuse | Why It Fails |
|------|------|------|
| Defensive response to feedback | "You don't understand my design" | Review is about finding problems, not denying your ability |
| Accepting only Minor, rejecting Critical | "This Critical is not important" | Critical issues are by definition mandatory; you do not get to downgrade them |
| Not updating evidence after a fix | "Fixed, that's enough" | No evidence = not fixed; the review closed loop requires a recorded trail |
| Batch-accepting all feedback | "Whatever you say" | Blind acceptance = no thinking; it may introduce new problems |
| Skipping the second-round review | "It's fixed, that's enough" | Fixes may introduce new problems; a second round is required to confirm |
| Delaying the response | "When I have time" | Review feedback is time-sensitive; delay = blocking downstream work |
| Marking FIXED without running tests | "The change is trivial" | Trivial changes still break things; tests are mandatory before claiming FIXED |
| Rejecting feedback as "reviewer is wrong" | "They don't know this codebase" | Even a wrong comment points at something unclear; clarify before rejecting |
| Reopening a "fixed" issue with a workaround | "I worked around it" | A workaround is not a fix; the root cause remains and will resurface |

## Red Flags
Stop and re-triage if you observe any of the following:
- The same feedback is rejected 3+ times (you are likely defending instead of evaluating)
- evidence.md has no review response record (the closed loop was never closed)
- Critical feedback is not responded to within 24 hours
- Tests fail after a fix but delivery continues
- A second-round review finds a "fixed" issue has reappeared (the fix was never real)

Any single red flag is sufficient grounds to halt delivery and re-enter the triage step.
Do not override a red flag with "probably fine"; escalate it to a re-fix or to the user.

## Division of Labor with Other Skills

| Skill | Responsibility | Timing |
|-------|------|------|
| requesting-code-review | Initiate review, list issues | After LOOP |
| **receiving-code-review** | Respond to feedback, fix or reject | After review returns |
| test-driven-development | Fix issues found in review | Triggered by receiving-code-review |

## Relationship with LOOP
This skill is outside LOOP and is the closed loop for handling review feedback:
- requesting-code-review → **receiving-code-review** → (if fix needed) return to tdd → verify → re-requesting-code-review
- All Critical/Major fixes pass re-review = review closed loop complete
