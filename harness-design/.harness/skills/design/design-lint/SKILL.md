---
name: design-lint
description: Mechanically verifies design against design system rules using script execution. Use after verify in LOOP. Use before design-review.
triggers:
  - In-LOOP, after verify
  - Design mockups need mechanical rule checks
  - Before design-review
reads:
  - .harness/craft/anti-ai-slop.md
  - docs/design-system/DESIGN.md
  - docs/design-system/tokens.json
  - docs/visual/
  - docs/interaction/
  - docs/design-system/components/
writes:
  - loops/specs/<task>/lint-report.md
---

# Design Lint

## Overview

AI design Linter; mechanically verifiable rule checks with zero subjective judgment. Checks consistency against the design system itself, like ESLint catching code errors.

**Key**: Real mechanical rules must be executed by real code, not LLM hallucination. The Agent writes and runs a one-off Node.js script to do regex scanning.

## When to Use

- ✅ In-LOOP, after verify
- ✅ Design mockups need mechanical rule checks
- ✅ Before design-review
- ❌ NOT for subjective design judgment (use the design-review skill)

## Process

### 1. Read Context

- `docs/design-system/DESIGN.md`: Design system
- `docs/design-system/tokens.json`: Token definitions
- Design mockups to be checked (`docs/visual/<page>.md`)

### 2. Write Lint Script

The Agent writes a one-off Node.js script that regex-scans the design mockups:

```javascript
// lint-design.mjs - One-off script, discard after use
import { readFileSync, writeFileSync } from 'fs';

const design = readFileSync('docs/visual/<page>.md', 'utf8');
const tokens = JSON.parse(readFileSync('docs/design-system/tokens.json', 'utf8'));

const errors = [];

// L001: All colors must come from tokens (no hardcoded hex)
const hexMatches = design.matchAll(/#[0-9a-fA-F]{6}/g);
const tokenColors = Object.values(tokens.color || {}).map(t => t.$value.toLowerCase());
for (const match of hexMatches) {
  if (!tokenColors.includes(match[0].toLowerCase())) {
    errors.push({
      rule: 'L001',
      severity: 'error',
      value: match[0],
      position: match.index,
      expected: 'token reference',
      fix: 'use token from tokens.json'
    });
  }
}

// L011: Forbid Inter/Roboto/Arial as primary font
if (/font-family.*?(Inter|Roboto|Arial)/i.test(design)) {
  errors.push({
    rule: 'L011',
    severity: 'error',
    value: 'Inter/Roboto/Arial',
    expected: 'project design system font',
    fix: 'use font from DESIGN.md'
  });
}

// L012: Forbid #6366f1 purple
if (/#6366f1/i.test(design)) {
  errors.push({
    rule: 'L012',
    severity: 'error',
    value: '#6366f1',
    expected: 'project primary token',
    fix: 'use --color-primary'
  });
}

// L013: Forbid purple-blue gradient
if (/(indigo|violet|purple).*?(purple|violet|indigo)/i.test(design)) {
  errors.push({
    rule: 'L013',
    severity: 'error',
    value: 'purple-blue gradient',
    expected: 'flat color or subtle gradient',
    fix: 'remove gradient'
  });
}

// L015: Forbid Lorem ipsum
if (/lorem\s+ipsum/i.test(design)) {
  errors.push({
    rule: 'L015',
    severity: 'error',
    value: 'Lorem ipsum',
    expected: 'real placeholder content',
    fix: 'replace with real content'
  });
}

writeFileSync('loops/specs/<task>/lint-report.md', formatReport(errors));
console.log(`Lint complete: ${errors.length} issues found`);
```

### 3. Run the Script

```bash
node lint-design.mjs
```

### 4. Parse the Report

The script outputs `loops/specs/<task>/lint-report.md`, formatted as:

```markdown
# Lint Report

## Summary
- Errors: <count>
- Warnings: <count>
- Info: <count>

## Details

### L001: Hardcoded hex color [ERROR]
- Location: line 42
- Current value: #3B82F6
- Expected value: token reference
- Fix: use --color-primary

### L011: Forbidden font [ERROR]
- Location: line 15
- Current value: Inter
- Expected value: project design system font
- Fix: use font from DESIGN.md
```

### 5. Handle Results

- `error` level: Must fix; return to visual-design for revision
- `warning` level: Recommended fix; annotate the decision ("fix" or "ignore with reason")
- `info` level: Informational only; no action needed

## Lint Rule List

### Token Consistency
- L001: All colors must come from tokens (no hardcoded hex)
- L002: All spacing must be on the spacing scale
- L003: All border radii must come from the radius scale
- L004: All font sizes must be on the type scale
- L005: All shadows must come from the elevation scale

### Component Consistency
- L006: No more than 3 implementations for the same semantic component
- L007: Component variants differing by ≤2 props should be merged
- L008: Components must annotate all states

### Layout Consistency
- L009: Consistent alignment baseline
- L010: Consistent grid column count (12-column grid)

### Anti AI-slop
- L011: Forbid Inter/Roboto/Arial as primary font
- L012: Forbid #6366f1 purple
- L013: Forbid purple-blue gradient
- L014: Forbid uniform border radius (rounded-2xl everywhere)
- L015: Forbid Lorem ipsum placeholder text

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Lint rules are too strict and limit creativity" | Lint checks consistency, not creativity; creativity lives at the token definition layer |
| "Manual checks are enough" | Manual checks are not repeatable; lint is automatable |
| "LLM hallucinated checks are enough" | LLMs drift and hallucinate; scripts must be used |
| "Writing a script is too much trouble" | One-off scripts are discarded after use and are more reliable than manual checks |

## Red Flags

- No script written; only LLM hallucinated checks
- Claiming pass without running the script
- Continuing with unresolved error-level violations
- Warning-level violations without annotated decisions

## Verification

- [ ] Lint script written (evidence: lint-design.mjs file exists)
- [ ] Script run (evidence: command execution record)
- [ ] lint-report.md generated (evidence: file exists)
- [ ] All error-level violations fixed (evidence: re-running the script yields no errors)
- [ ] Warning-level violations have decisions (evidence: each warning annotated "fix" or "ignore with reason")

## Relationship with LOOP

- Stage: LINT (inside LOOP, after verify)
- Not a separate LOOP; serves as the third step of the design LOOP
- Flow: DESIGN → VERIFY → LINT
- Loop type: applies to all loop types (visual-design / interaction-design / wireframe / component)

## Failure Handling

On lint failure:
1. Update the `last_error` field of `state.yaml`, format: `Lint L00X: <description>` (reuse existing field; do not add a new lint_status)
2. Update `state.yaml` `stage` to `lint`, `status` to `retrying`
3. Append a line to `iterations.log`: `[<time>] iter=<N> stage=lint → FAILED: L00X <description>`
4. Return to the DESIGN stage to fix; iteration +1

On lint pass:
1. Clear the `last_error` field of `state.yaml`
2. Update `stage` to the next stage (out-of-LOOP gate or DONE)
