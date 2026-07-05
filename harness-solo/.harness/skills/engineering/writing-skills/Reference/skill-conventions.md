# Writing Skills — Conventions & Examples

## Good vs Bad Skill Example

A good skill states an inviolable rule with a **verifiable exit condition**. A bad skill states a value with no way to check compliance.

<Good>
```markdown
## Iron Rule
**No production code without a failing test.** A test that passes immediately
= you are testing existing behavior, not new behavior.
## Process
1. Write a failing test → run it → confirm FAIL is visible
2. Write minimal code → run it → confirm PASS is visible
```
Exit condition: the test runner's actual output (FAIL then PASS) is observable evidence.
</Good>

<Bad>
```markdown
## Principles
Tests are important. Please write tests for your code and try to keep
coverage high. Quality matters.
```
Exit condition: none. "Important" and "high" are not measurable.
</Bad>

The difference: the Good example gives the Agent a binary check on its own output. The Bad example is an abstract slogan every implementation can claim to satisfy.

## Read-Only Inputs Annotation

In the **Inputs** section, annotate each entry with its access mode so the Agent (and reviewers) can see at a glance which files are referenced vs modified:

```
## Inputs
- loops/LOOP.md (read-only, schema reference)
- loops/specs/<feature>/state.yaml (read-write)
- rules/security.md (read-only, constraint reference)
- docs/handoff/<source>-to-solo.md (read-only, then consumed)
```

Convention:
- `(read-only[, ...])` — read for reference, must not be modified (default when no annotation)
- `(read-only, then consumed)` — read-only, but the skill acts on its contents this session
- `(read-write)` — the skill writes back; must also appear in **Outputs**

## Naming Conventions

- lowercase-kebab-case: `test-driven-development`, not `TestDrivenDevelopment`
- Prefer an action-oriented name: `writing-plans` / `code-review` / `verify`
- Avoid abbreviations: `systematic-debugging`, not `sys-debug`
- Exactly match the directory name
