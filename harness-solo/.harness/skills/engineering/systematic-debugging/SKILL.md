---
name: systematic-debugging
description: Systematic Debugging — root cause analysis rather than symptom patching
triggers:
  - When a test fails
  - On a bug report
  - When the verify stage finds an issue
reads:
  - loops/LOOP.md
  - rules/security.md
  - memory/knowledge-base.md
writes:
  - loops/specs/<feature>/state.yaml
  - loops/specs/<feature>/iterations.log
  - memory/knowledge-base.md
---

# Systematic Debugging — Systematic Debugging

## Iron Rule
**Find the root cause, do not patch the symptom.** "Changing it until it runs" is not debugging; it is gambling.

## Process

1. **Reproduce**
   - Write a test that reliably reproduces the bug
   - Confirm the test fails (red)
   - If you cannot reliably reproduce it = you do not yet understand the bug; do not start fixing

2. **Locate**
   - Bisection to narrow the scope: comment out half the code; is the bug still there?
   - Look at the error stack and find the earliest failure point
   - Check recent related changes (git log/diff)

3. **Analyze the root cause**
   Ask "why" at least 3 times:
   - Why did it fail? → Because X is null
   - Why is X null? → Because Y was not initialized
   - Why was Y not initialized? → Because Z's execution order is wrong
   - **The root cause is Z's ordering, not "X is null"**

4. **Fix the root cause**
   - Fix the real cause (Z's ordering), not the symptom (add a null check for X)
   - After the fix, the reproduction test should pass

5. **Regression check**
   - Run the full test suite and confirm the fix did not introduce new issues
   - Check for similar issues (the same root cause may exist elsewhere)

6. **Record the lesson**
   If the root cause is general, write it into the **"Pitfall Log" table** in `memory/knowledge-base.md` (not the "Technical Decisions" or "Pattern Repository" table):
   ```
   ## Pitfall Log
   | Date | Problem | Solution | Related Files |
   |------|------|---------|---------|
   | YYYY-MM-DD | [root cause description] | [fix approach] | [file path] |
   ```

## State Maintenance

While debugging, update per the "state.yaml Schema" in `loops/LOOP.md`:
- `stage`: `debug`
- `last_error`: `"[root cause description]"`
- `status`: `retrying`

For full field definitions and write responsibilities, see LOOP.md.

**Update iterations.log (must append, overwriting is forbidden)**:
- Tool approach: first Read the current iterations.log → append the new line → Write it back
- Or terminal command: `echo "[YYYY-MM-DD HH:MM] iter=<N> stage=debug → root cause: <root cause>" >> .harness/loops/specs/<feature>/iterations.log`
- Do not use Write to overwrite iterations.log directly (it would erase historical iteration records)

Append format:
```
[YYYY-MM-DD HH:MM] iter=<N> stage=debug → root cause: <root cause>
```

## Prohibitions
- Fixing without reproducing (you don't know whether the change worked)
- Fixing the symptom instead of the root cause ("add a try-catch to swallow the exception")
- Stopping once it runs (without running the full test suite)
- Fixing the same bug repeatedly (means the root cause was not found)

## Relationship with LOOP
This skill is triggered when LOOP fails:
- tdd fails → systematic-debugging finds the root cause → return to tdd to fix
- verify fails → systematic-debugging finds the root cause → return to tdd to fix

Bug fix workflow:
session-start → systematic-debugging → LOOP(tdd→verify) → code-review → session-end
