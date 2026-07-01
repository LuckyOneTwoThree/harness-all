# Webapp Testing — Frontend Check Patterns & Return Templates

## 5.1 Component structure check
- Use Glob to find the component files changed in this change (`*.tsx` / `*.vue` / `*.svelte`)
- Use Read to read each component and check:
  - [ ] The component has clear prop type definitions (not any)
  - [ ] The component has a corresponding test file (`*.test.tsx` / `*.spec.tsx`)
  - [ ] No hardcoded inline styles (should use CSS classes/Tailwind classes)
  - [ ] No uncleaned console.log / debugger

## 5.2 Accessibility baseline check (using Grep)
- Search `<img` to confirm all have `alt` attributes:
  ```
  <img(?![^>]*\balt=)[^>]*>
  ```
  Hit → mark as an accessibility issue (negative-lookahead anchored to img tag, robust against attributes ordered after `src`)
- Search `<button` to confirm all have readable text or `aria-label`:
  ```
  <button[^>]*>\s*</button>
  ```
  Hit (empty button) → mark as an accessibility issue
- Search click handlers to confirm they are not bound on div/span (should use button). Match React `onClick`, Vue `@click`, Svelte `on:click`, and native `onclick`:
  ```
  <div[^>]*(?:onClick|@click|on:click|onclick)
  ```
  Hit → mark as an accessibility suggestion

## 5.3 Routing/page check (if routing exists)
- Use Glob to find the routing config file
- Use Read to confirm new pages are registered in the routing
- Confirm the routing paths match the ACs in spec.md

## Return verification results structure

Return the following structure to verify for its "Frontend Verification" evidence section:

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

## Regarding E2E Tests & DOM-Level Accessibility Verification

### Default: Static checks only (zero-dependency)

This skill performs **static code checks only** (using Grep/Read), per the constitution.md zero-new-dependency principle. The following WCAG 2.1 AA checks are **statically verifiable** and always run:

- Contrast ratios (from token values)
- Touch target sizes (from component-spec dimensions)
- `alt` attribute presence on images
- `aria-label` presence on interactive elements
- Semantic HTML element choice (button vs div+onClick)
- Reduced-motion media query presence
- Color-blindness safe palette

### DOM-level checks (opt-in, requires user-configured E2E tool)

The following WCAG 2.1 AA checks **require a running DOM** and are **not performed by default**:

- Live focus trap behavior (Modal/Drawer)
- Runtime ARIA roles/labels computed by assistive technology
- Real screen reader output
- Dynamic focus order during keyboard navigation
- Focus visibility (outline rings) under runtime conditions

**Design framework's design-review Axis 5 declares these are "deferred to harness-solo verify", but Solo's default static checks cannot cover them.** This is an acknowledged architectural boundary:

- If the user has **not** configured an E2E tool (Playwright/Cypress): verify stage records `DOM-level WCAG checks skipped (no E2E tool configured; static subset verified)` in evidence.md. This is an **explicit, auditable skip**, not a silent gap.
- If the user **has** configured an E2E tool (approved in constitution.md dependency whitelist): verify stage invokes webapp-testing's opt-in DOM-check mode, which runs the user's E2E tool to execute the dynamic checks above.

### Opt-in E2E mode (user-triggered)

If the user explicitly needs DOM-level verification:
1. User approves introducing Playwright/Cypress (modify the dependency whitelist in constitution.md)
2. User configures the E2E tool in project settings
3. verify stage invokes webapp-testing with `dom_check: true` flag
4. Out of scope for the default zero-dependency skill mode
