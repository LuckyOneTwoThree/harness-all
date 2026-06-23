---
name: webapp-testing
description: Frontend/Web App Verification — pure Agent tooling approach (no Playwright dependency)
triggers:
  - When frontend code is changed
  - As a frontend verification sub-item of the verify skill
  - When the user asks to verify UI/page behavior
reads:
  - loops/specs/<feature>/spec.md
  - docs/engineering/TECH_STACK.md
  - rules/security.md
writes:
  - loops/specs/<feature>/evidence.md
---

# Webapp Testing — Frontend Verification

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

   **5.1 Component structure check**
   - Use Glob to find the component files changed in this change (`*.tsx` / `*.vue` / `*.svelte`)
   - Use Read to read each component and check:
     - [ ] The component has clear prop type definitions (not any)
     - [ ] The component has a corresponding test file (`*.test.tsx` / `*.spec.tsx`)
     - [ ] No hardcoded inline styles (should use CSS classes/Tailwind classes)
     - [ ] No uncleaned console.log / debugger

   **5.2 Accessibility baseline check** (using Grep)
   - Search `<img` to confirm all have `alt` attributes:
     ```
     <img[^>]*(?!alt=)[^>]*>
     ```
     Hit → mark as an accessibility issue
   - Search `<button` to confirm all have readable text or `aria-label`:
     ```
     <button[^>]*>\s*</button>
     ```
     Hit (empty button) → mark as an accessibility issue
   - Search `onClick` to confirm it is not bound on div/span (should use button):
     ```
     <div[^>]*onClick
     ```
     Hit → mark as an accessibility suggestion

   **5.3 Routing/page check** (if routing exists)
   - Use Glob to find the routing config file
   - Use Read to confirm new pages are registered in the routing
   - Confirm the routing paths match the ACs in spec.md

6. **Security check** (frontend-specific)
   - Use Grep to search for `dangerouslySetInnerHTML` (React) / `v-html` (Vue):
     Hit → mark as an XSS risk; the input source must be confirmed trusted
   - Use Grep to search for hardcoded API addresses:
     ```
     (http|https)://[a-zA-Z0-9.-]+\.[a-z]{2,}
     ```
     Hit → confirm whether it should be configured via environment variables

7. **Write evidence**
   Summarize the above check results into the "Frontend Verification" section of evidence.md:
   ```markdown
   ## Frontend Verification

   ### Build
   $ <command>
   <actual output>

   ### Type Check
   $ <command>
   <actual output>

   ### Lint
   $ <command>
   <actual output>

   ### Structural Verification
   - Component files: X, all with prop types ✓/✗
   - Test files: X components have tests, Y missing
   - Accessibility: [issue list or "no issues"]

   ### Security
   - dangerouslySetInnerHTML: [hits or "none"]
   - Hardcoded API addresses: [hits or "none"]
   ```

## Division of Labor with verify

| Dimension | verify | webapp-testing |
|------|--------|----------------|
| Scope | Full-stack comprehensive verification | Frontend-specific |
| Trigger | Every VERIFY of LOOP | When frontend code is involved |
| Output | Main sections of evidence.md | "Frontend Verification" section of evidence.md |
| Relationship | verify invokes webapp-testing | webapp-testing is a sub-item of verify |

**Invocation**: when the verify skill detects frontend code changes, it invokes this skill for frontend-specific verification, and the results are merged into evidence.md.

## Prohibitions
- Skipping build verification (frontend code that fails to build cannot be delivered)
- Reading code without running the build ("I think it compiles" is not evidence)
- Ignoring accessibility issues (not optional; it is a baseline quality)
- Introducing external dependencies like Playwright/Cypress for E2E (violates the zero-new-dependency principle; if E2E is needed, the user configures it separately)

## Regarding E2E Tests

This skill **does not include** E2E tests (Playwright/Cypress), for the following reasons:
- E2E frameworks are heavy dependencies, violating the constitution.md zero-new-dependency principle
- E2E requires a browser environment, with complex cross-platform compatibility
- For personal mid-sized projects, unit tests + structural verification are usually sufficient

If the user explicitly needs E2E:
1. The user approves introducing Playwright (modify the dependency whitelist in constitution.md)
2. Create a separate `e2e-testing` skill
3. Out of scope for this skill

## Relationship with LOOP
This skill is invoked by the verify skill during the VERIFY phase of LOOP:
- tdd (ACT) → verify (VERIFY) → detects frontend code → invoke webapp-testing → merge evidence
