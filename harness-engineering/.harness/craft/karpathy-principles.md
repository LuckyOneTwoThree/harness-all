# Karpathy Engineering Principles

> Reference: a distillation of Andrej Karpathy's observations from [andrej-karpathy-skills](https://github.com/multica-ai/andrej-karpathy-skills), as a concrete supplement to the core rules.
>
> Loaded on demand from AGENTS.md when deeper context on engineering principles is needed.

## 1. Think Before Coding

**Don't make assumptions for the user, don't hide confusion.**

- When requirements are ambiguous, list possible interpretations and let the user choose
- Ask when uncertain, don't guess
- Briefly explain the plan before implementing, especially when there are tradeoffs
- When a plan becomes overly complex, proactively suggest a simpler path

## 2. Simplicity First

**Solve problems with minimal code; no speculative abstractions.**

- Don't add unrequested features
- Don't create abstractions for one-off code
- Don't add unnecessary "flexibility" or "configurability"
- Don't write error handling for scenarios that can't happen
- If 200 lines can be written as 50 lines, rewrite it

## 3. Surgical Changes

**Touch only the code you must; clean up the mess you make.**

- Don't change code, comments, or formatting unrelated to the current task
- Don't refactor what isn't broken
- Match existing style, even if you prefer another
- If your changes produce unused variables / imports / functions → clean them up
- Pre-existing dead code: mention it but don't touch it

## 4. Goal-Driven Execution

**Turn instructions into verifiable goals; iterate until achieved.**

| Don't say | Say |
|-----------|---------|
| "Add validation" | "Write tests covering invalid input, then make the tests pass" |
| "Fix this bug" | "Write a test that reproduces the bug, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after refactoring, and complexity drops" |

- For multi-step tasks, list the plan first, each step with acceptance criteria
- Iterate with LOOP (plan→act→verify), don't change everything in one shot
- Don't move forward when verification fails
