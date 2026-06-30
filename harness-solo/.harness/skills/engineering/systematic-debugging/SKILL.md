---
name: systematic-debugging
description: Systematic Debugging — root cause analysis rather than symptom patching
---
# Systematic Debugging — Systematic Debugging

## When to use
- When a test fails
- On a bug report
- When the verify stage finds an issue

## Inputs
- loops/LOOP.md
- loops/STATE_PROTOCOL.md
- loops/state.schema.json
- rules/security.md
- memory/knowledge-base.md

## Outputs
- loops/specs/<feature>/state.yaml
- loops/specs/<feature>/iterations.log
- memory/knowledge-base.md

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

### 5 Whys Failure Handling

The linear 5 Whys chain can stall when the bug spans modules or involves hidden state. Apply these fallbacks:

- After **3 Whys** without locating the root cause → switch to **bisection**: comment out half the suspect code, rerun the repro test, narrow the blast radius by ~50% each step
- After **5 Whys** without locating the root cause → **stop guessing**. Update `state.yaml` with `last_error: "root cause not found after 5 Whys"`, append to iterations.log, and report to the user that human intervention may be required
- Do not start a 6th Why — that is rationalization, not analysis

## State Maintenance

While debugging, follow `.harness/loops/STATE_PROTOCOL.md` and validate with `state.schema.json`:
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

## Anti-Rationalization Table

| Anti-pattern | Common excuse | Why it doesn't hold |
|---|---|---|
| Skipping reproduction, jumping to fix | "I know where the bug is" | No repro = no confirmation the fix actually works |
| Guessing root cause without verifying | "It's probably this" | "Probably" is not evidence; verify before fixing |
| Fixing the symptom, not the cause | "Stop the bleeding first" | The symptom resurfaces in another form within ≤ 3 changes |
| Changing multiple things at once | "Fixed another bug along the way" | You cannot isolate which change actually fixed it |
| No regression test added | "It's fixed, move on" | The same bug returns; nothing prevents regression |
| Still guessing after 3 failed fixes | "One more try" | 3 failures means the direction is wrong; switch to bisection |

## Red Flags

Stop immediately and reassess if you observe any of:
- The reproduction test still fails after the fix — you patched a symptom, not the cause
- Root cause is attributed to "a bug in a third-party library" but no minimal repro against that library exists — this is a guess, not a finding
- `git diff` contains changes to unrelated files — your fix is mixed with other edits, isolating effect is impossible
- The same `last_error` appears in iterations.log 3+ times — you are looping, not converging
- The fix is a `try/except` or `if x is not None` guard around the failure point — this is symptom suppression
- You cannot state the root cause in one sentence — you have not found the cause yet

## Good vs Bad

A good fix targets the root cause and is locked in by a regression test. A bad fix silences the symptom and leaves the cause free to resurface.

<Good>
```python
# Root cause: Y initialized after X reads it
# Fix: move Y's init before X's first read
def init():
    y = load_config()        # moved up
    x = build_parser(y)      # now sees config
```
</Good>

<Bad>
```python
# "Fix": guard against the None we observed
def init():
    x = build_parser(y)
    if x is None:
        x = DEFAULT_PARSER   # symptom patched, Y still wrong
```
</Bad>

## Relationship with LOOP
This skill is triggered when LOOP fails:
- tdd fails → systematic-debugging finds the root cause → return to tdd to fix
- verify fails → systematic-debugging finds the root cause → return to tdd to fix

Bug fix workflow:
session-start → systematic-debugging → LOOP(tdd→verify) → code-review → session-end
