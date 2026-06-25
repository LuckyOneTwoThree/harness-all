---
name: requesting-code-review
description: Code Review — quality gatekeeping; review after completion, not while writing
---
# Requesting Code Review — Code Review

## When to use
- After verify passes
- Before a task is claimed complete
- Before merging a branch

## Inputs
- rules/security.md
- constitution.md
- loops/specs/<feature>/spec.md
- loops/specs/<feature>/evidence.md

## Outputs
- loops/specs/<feature>/iterations.log

## Iron Rule
**Passing verify does not mean deliverable.** Tests passing only means "the feature works"; review means "the code is good".

## Process

1. **Prepare review materials**
   - Read spec.md to confirm the feature scope
   - Read evidence.md to confirm verification has passed
   - List the files changed in this change (git diff)

2. **Review item by item**

   ### Design level
   - [ ] Does the code match the design defined in spec.md?
   - [ ] Is there over-engineering? (YAGNI)
   - [ ] Are responsibilities unclear? (one function doing too much)
   - [ ] Is naming clear? (understandable without comments)

   ### Implementation level
   - [ ] Are there hardcoded magic values?
   - [ ] Is there duplicated code? (DRY)
   - [ ] Is error handling complete? (edge cases)
   - [ ] Are there security risks? (check against security.md)

   ### Constitution compliance
   - [ ] Are unapproved new dependencies introduced?
   - [ ] Do new APIs have tests?
   - [ ] Do schema changes have migration scripts?

   ### Maintainability
   - [ ] Will it still be understandable three months from now?
   - [ ] Can someone else taking it over understand it?
   - [ ] Are key decisions annotated with why (not what)?

3. **Record review results**
   - Pass → append to iterations.log: `[time] code-review PASSED`
   - Fail → list the issues (classified by Critical/Major/Minor/Question/Nitpick) and hand off to the `receiving-code-review` skill

4. **Update feature status**
   After the review passes, the feature can be marked as `done` (batch-synced to FEATURES.md by session-end)

## Review Feedback Classification Standard

| Level | Definition | Example |
|------|------|------|
| **Critical** | Functional bug / security vulnerability / data loss | SQL injection, null pointer crash, plaintext password storage |
| **Major** | Design flaw / performance issue / poor maintainability | 500-line function, 5-level nested loops, duplicated code |
| **Minor** | Naming / comments / style | Variable name `a`, missing type annotation, magic number |
| **Question** | Reviewer is unsure; needs discussion | "Why use X instead of Y here?" |
| **Nitpick** | Personal preference; inconsequential | "I think this blank line can be removed" |

The issue list is handed off to the `receiving-code-review` skill; this skill does not handle fixes.

## Prohibitions
- Claiming completion while skipping review
- Reviewing only for "does it run" (that's verify's job)
- Spotting issues in review but letting them pass without fixing
- Going soft on self-review (be honest; review your code as if it were someone else's)

## Anti-Rationalization Table

When you catch yourself thinking the excuse in column 2, read column 3 and resume the review.

| Anti-pattern | Common Excuse | Why It Fails |
|------|------|------|
| Skipping code review and delivering directly | "I already reviewed it myself" | Self-review has blind spots; others can spot issues you cannot see |
| Reviewing only functionality, ignoring design | "The feature works, that's enough" | Design problems are the root source of technical debt |
| Delivering feedback without classification | "Everything has problems" | No classification = no triage; the developer does not know what to fix first |
| Giving vague feedback | "This part is not great" | "Not great" is not actionable; be specific down to the line and the reason |
| Not verifying the fix | "They said they fixed it" | "Said they fixed it" ≠ "fixed correctly"; you must re-verify the change |
| Reviewing your own code | "I am the most familiar with it" | Familiarity = blind spot; have someone else review your code |
| Rubber-stamping the review | "It looks fine at a glance" | A glance is not a review; missing issues at a glance is still a missed review |
| Reviewing only the diff, ignoring context | "I only review the changed lines" | Bugs often live in the interaction between changed and unchanged code |
| Approving to avoid conflict | "I don't want to block them" | Review is a quality gate, not a courtesy; avoiding conflict = abandoning the gate |
| Reviewing only happy-path tests | "Tests pass, so it is fine" | Tests covering only happy paths prove nothing about edge cases or failure modes |
| Not checking security.md explicitly | "I do not see any security issue" | Security risks are not always visible; you must check against security.md item by item |
| Closing review before re-verify passes | "They said tests pass again" | Re-verify is part of the review closed loop; closing early = unverified fix |

## Red Flags
Stop and re-review if you observe any of the following:
- Review feedback has fewer than 3 items (the reviewer likely did not look carefully)
- All feedback is Nitpick (the reviewer is avoiding major issues)
- Feedback contains "I think" / "maybe" / "not sure" (the reviewer is not committing to a judgment)
- Critical feedback is not responded to within 24 hours
- The same issue appears in multiple consecutive reviews (the root cause was never addressed)

Any single red flag is sufficient grounds to reject the review conclusion and require a re-review.
Do not override a red flag with "probably fine"; escalate it to a re-review or to the user.

## Relationship with LOOP
This skill is outside LOOP and is the final review after LOOP completes:
- LOOP(tdd → verify) passes → requesting-code-review → passes = truly complete
- LOOP(tdd → verify) passes → requesting-code-review → fails → return to tdd

## Division of Labor with verify
| Dimension | verify | code-review |
|------|--------|-------------|
| Focus | Is the feature correct? | Is the code good? |
| Timing | Every LOOP iteration | Once after LOOP completes |
| Output | evidence.md | Review conclusion |
| Failure | Return to tdd | Hand off to receiving-code-review |

## Coordination with receiving-code-review
| Stage | Responsibility |
|------|------|
| requesting-code-review | Initiate review, list issues |
| receiving-code-review | Respond to feedback, fix/reject/discuss |
| (if fixed) tdd + verify | Re-verify after the fix |
| requesting-code-review (re-review) | Confirm the fix is effective |
