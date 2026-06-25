---
name: design-system
description: Creates a design system with DESIGN.md 10-section standard and token exports. Use when no design system exists. Use after design-recommendation.
---
# Design System

## When to use
- Create a design system
- No DESIGN.md
- After design-recommendation completes

## Inputs
- .harness/craft/anti-ai-slop.md
- .harness/craft/typography.md
- .harness/craft/color.md

## Outputs
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/design-system/tokens.css
- docs/design-system/pages/

## Overview

Creates the DESIGN.md 10-section standard + token exports (md + json + css). The design system is the single source of truth; all design mockups must follow it.

## Process

### 1. Check RECOMMENDATION.md

If `docs/design-system/RECOMMENDATION.md` exists, use it as the baseline.

### 2. Confirm Design System Scope

- Color system (primary/secondary/accent/background/foreground/muted/border/destructive)
- Typography system (heading/body/mono, including Google Fonts links)
- Spacing system (4px base, common scale)
- Shadow system
- Border radius system
- Breakpoint system

### 3. Fill in DESIGN.md 10 Sections

Reference craft/typography.md and craft/color.md.

#### Sections 1-9 (Standard)

1. Visual Theme & Atmosphere
2. Color Palette & Roles
3. Typography Rules
4. Component Stylings
5. Layout Principles
6. Depth & Elevation
7. Do's and Don'ts
8. Responsive Behavior
9. Agent Prompt Guide

#### Section 10: Semantic Vocabulary (Fixed Template)

Must contain the following common blocks (if the project has no corresponding scenario, annotate "Not applicable"):

```markdown
## 10. Semantic Vocabulary

### Header
- Component composition: Logo + Navigation + UserMenu
- Purpose: Global navigation

### Footer
- Component composition: FooterLink + FooterSection + Copyright
- Purpose: Footer information

### Hero
- Component composition: HeroTitle + HeroSubtitle + HeroCTA + HeroImage
- Purpose: Above-the-fold hero visual

### Form
- Component composition: FormField + Label + Input + ErrorMessage + SubmitButton
- Purpose: Form input

### Empty State
- Component composition: EmptyIllustration + EmptyTitle + EmptyDescription + PrimaryAction
- Purpose: Displayed when there is no data

### Dialog
- Component composition: Modal + DialogTitle + DialogBody + ButtonGroup(primary+secondary)
- Purpose: Confirmation / pop-up

### Error State
- Component composition: ErrorIcon + ErrorTitle + ErrorDescription + RetryAction
- Purpose: Error messaging

### Loading State
- Component composition: Skeleton | Spinner + LoadingText
- Purpose: Loading in progress
```

### 4. Token Export

#### tokens.json (W3C standard format)

```json
{
  "color": {
    "primary": { "$value": "#3b82f6", "$description": "Primary color" },
    "on-primary": { "$value": "#ffffff" }
  },
  "spacing": {
    "sm": { "$value": "0.5rem" },
    "md": { "$value": "1rem" }
  }
}
```

#### tokens.css (CSS custom properties)

```css
:root {
  --color-primary: #3b82f6;
  --color-on-primary: #ffffff;
  --spacing-sm: 0.5rem;
  --spacing-md: 1rem;
}
```

### 5. Master + Overrides Initialization

Create the `docs/design-system/pages/` directory for page-level overrides.

Retrieval rules (for use by downstream skills):
1. First check whether `docs/design-system/pages/<page>.md` exists
2. If it exists → its rules override MASTER.md (DESIGN.md)
3. If it does not exist → use MASTER.md only

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "The design system is too heavy; let's just draw pages first" | Pages without a design system are scattered and inconsistent |
| "A token table is enough" | Engineering needs json/css, not just markdown |
| "Semantic Vocabulary is too granular" | The fixed template has 7 common blocks; the granularity is just right |
| "Semantic Vocabulary lets me improvise" | The fixed template ensures downstream consumability; improvisation breaks the mapping |

## Red Flags

- Skipping Section 10 Semantic Vocabulary
- Semantic Vocabulary not using the fixed template
- Tokens only output as markdown, no json/css
- pages/ directory not created

## Verification

- [ ] DESIGN.md contains 10 sections (evidence: file content)
- [ ] Section 10 Semantic Vocabulary contains 7 common blocks (evidence: file content)
- [ ] tokens.json conforms to W3C format (evidence: JSON structure contains $value fields)
- [ ] tokens.css contains CSS custom properties (evidence: file contains --color-* variables)
- [ ] pages/ directory created (evidence: Glob confirms directory exists)

## Relationship with LOOP

- Not run inside LOOP (runs in the pre-LOOP design system setup stage)
- The DESIGN.md + tokens.json + tokens.css produced are read by all in-LOOP skills (visual-design / interaction-design / wireframe / component-design / verify / design-lint)
- The Section 10 Semantic Vocabulary produced is used by the component-design skill to identify the component list
- The tokens produced are checked for consistency by design-lint rules L001-L005
- The pages/ directory produced is used by the visual-design skill to retrieve page-level overrides
