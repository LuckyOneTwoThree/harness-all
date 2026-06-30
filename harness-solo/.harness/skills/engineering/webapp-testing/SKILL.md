---
name: webapp-testing
description: Frontend/Web App Verification — pure Agent tooling approach (no Playwright dependency)
---
# Webapp Testing — Frontend Verification

## When to use
- When frontend code is changed
- As a frontend verification sub-item of the verify skill
- When the user asks to verify UI/page behavior

## Inputs
- loops/specs/<feature>/spec.md
- docs/engineering/TECH_STACK.md
- rules/security.md

## Outputs
- frontend verification results returned to verify; verify alone writes evidence.md

## Iron Rule
**Frontend code changes must be verified; do not just read the code and say "should work".** Use a pure Agent tooling approach; do not introduce external dependencies like Playwright (abide by the constitution.md zero-new-dependency principle).

## Positioning

This skill is a **frontend-specific supplement to the verify skill** and does not replace unit tests:
- Unit tests (component logic) → handled by the tdd skill
- Integration tests (API integration) → handled by the tdd skill
- **Frontend structure/accessibility/build verification** → handled by this skill

## Process

1. **Confirm the frontend tech stack**
   - Read `docs/engineering/TECH_STACK.md` to confirm the framework (React/Vue/Svelte/native)
   - Confirm the build command (`npm run build` / `vite build`, etc.)
   - Confirm whether there is a lint command (`npm run lint` / `eslint`)

2. **Build verification** (mandatory)
   - Run the build command and confirm there are no compile errors:
     ```bash
     <build command, e.g. npm run build>
     ```
   - Show the full output; do not just say "build passed"
   - Build failure → return to tdd to fix

3. **Type check** (if TypeScript)
   - Run the type check command:
     ```bash
     <type check command, e.g. npm run typecheck or tsc --noEmit>
     ```
   - Show the output and confirm there are no type errors

4. **Lint check** (if any)
   - Run the lint command:
     ```bash
     <lint command, e.g. npm run lint>
     ```
   - Show the output and confirm there are no errors (warnings are acceptable but should be recorded)

5. **Structural verification** (using Agent tools, cross-platform)
   - Check component structure, accessibility baseline (Grep), and routing/page registration
   - 完整正则模式与返回结构模板见 `Reference/frontend-check-patterns.md`

6. **Security check** (frontend-specific)
   - Use Grep to search for `dangerouslySetInnerHTML` (React) / `v-html` (Vue):
     Hit → mark as an XSS risk; the input source must be confirmed trusted
   - Use Grep to search for hardcoded API addresses:
     ```
     (http|https)://[a-zA-Z0-9.-]+\.[a-z]{2,}
     ```
     Hit → confirm whether it should be configured via environment variables

7. **Return verification results**
   - Return structured results (Build/Type/Lint/Structural/Security) to verify for evidence merging
   - 完整正则模式与返回结构模板见 `Reference/frontend-check-patterns.md`

## Division of Labor with verify

| Dimension | verify | webapp-testing |
|------|--------|----------------|
| Trigger | Every VERIFY of LOOP | When frontend code is involved |
| Output | Canonical evidence.md | Structured frontend results for verify to merge |
| Relationship | verify invokes and records | webapp-testing checks but does not write evidence |

**Invocation**: when the verify skill detects frontend code changes, it invokes this skill for frontend-specific verification, and the results are merged into evidence.md.

## Prohibitions
- Skipping build verification (frontend code that fails to build cannot be delivered)
- Reading code without running the build ("I think it compiles" is not evidence)
- Ignoring accessibility issues (not optional; it is a baseline quality)
- Introducing external dependencies like Playwright/Cypress for E2E (violates the zero-new-dependency principle; if E2E is needed, the user configures it separately)

## Relationship with LOOP

Invoked by verify at verify-full (LOOP exit gate) when frontend code is detected; verify-fast per iteration does not invoke. See `.harness/loops/LOOP.md`.
