---
name: requesting-code-review
description: Code Review — quality gatekeeping; review after completion, not while writing
triggers:
  - After verify passes
  - Before a task is claimed complete
  - Before merging a branch
reads:
  - rules/security.md
  - constitution.md
  - loops/specs/<feature>/spec.md
  - loops/specs/<feature>/evidence.md
writes:
  - loops/specs/<feature>/iterations.log
---

# Requesting Code Review — Code Review

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
