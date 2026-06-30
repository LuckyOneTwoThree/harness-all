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

## Regarding E2E Tests

This skill **does not include** E2E tests (Playwright/Cypress), for the following reasons:
- E2E frameworks are heavy dependencies, violating the constitution.md zero-new-dependency principle
- E2E requires a browser environment, with complex cross-platform compatibility
- For personal mid-sized projects, unit tests + structural verification are usually sufficient

If the user explicitly needs E2E:
1. The user approves introducing Playwright (modify the dependency whitelist in constitution.md)
2. Create a separate `e2e-testing` skill
3. Out of scope for this skill
