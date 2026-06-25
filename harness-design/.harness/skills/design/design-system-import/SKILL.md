---
name: design-system-import
description: Imports design system from existing code configuration. Use when redesigning an existing project. Use when CSS/Tailwind/MUI config exists.
---
# Design System Import

## When to use
- Redesigning an existing project
- CSS/Tailwind/MUI configuration exists
- Need to extract design system from code

## Inputs
- tailwind.config.js
- src/theme.ts
- src/globals.css

## Outputs
- docs/design-system/DESIGN.md
- docs/design-system/tokens.json
- docs/design-system/tokens.css

## Overview

Extracts a design system from existing project configuration. Chesterton's Fence: understand the original design before deciding whether to rewrite it.

## Process

### 1. Detect Project Tech Stack

Check the following files to determine the tech stack:
- `tailwind.config.js` / `tailwind.config.ts` → Tailwind
- `src/theme.ts` / `src/theme/theme.ts` → MUI
- `components.json` → shadcn/ui
- `src/globals.css` / `src/index.css` → Plain CSS

### 2. Read Configuration Files

Read the corresponding configuration based on tech stack:
- **Tailwind**: Read theme.extend (colors/spacing/fontFamily/borderRadius/boxShadow)
- **MUI**: Read createTheme's palette/typography/spacing
- **shadcn**: Read CSS variables (--primary/--secondary/...)
- **Plain CSS**: Read :root CSS custom properties

### 3. Extract Tokens

Extract the following dimensions:
- Color (primary/secondary/accent/background/foreground/muted/border/destructive)
- Typography (heading/body/mono + Google Fonts links)
- Spacing (spacing scale)
- Shadow (box-shadow)
- Border radius (border-radius)
- Breakpoints

### 4. Generate DESIGN.md 10 Sections

Fill in DESIGN.md based on extracted tokens:
- Sections 1-9: Derived from tokens
- Section 10 Semantic Vocabulary: Scan existing component code to identify common blocks (Header/Footer/Hero/Form/Empty State/Dialog/Error State/Loading State)

### 5. Generate tokens.json + tokens.css

Convert extracted tokens to W3C standard format and CSS custom properties.

### 6. Diff Report

Generate `docs/design-system/IMPORT_REPORT.md`, recording:
- Successfully extracted tokens
- Unrecognized configurations (require manual confirmation)
- Suggested supplementary tokens (missing items in the design system)

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "The existing project has no design system" | Code always contains implicit tokens; extracting them yields a design system |
| "Rewriting from scratch is cleaner" | Chesterton's Fence: understand the original design before deciding whether to rewrite |
| "The config files are too messy to extract" | Extract dimension by dimension—color first, then typography, then spacing |

## Red Flags

- Generating a design system out of thin air without reading config files
- Extracted tokens inconsistent with the original configuration
- No diff report generated

## Verification

- [ ] Tech stack identified (evidence: configuration file detected)
- [ ] Configuration files read (evidence: Read command execution record)
- [ ] DESIGN.md 10 sections filled in (evidence: file content)
- [ ] tokens.json consistent with original configuration (evidence: compare config file values)
- [ ] IMPORT_REPORT.md generated (evidence: file exists)

## Relationship with LOOP

- Not run inside LOOP (runs in the pre-LOOP design system import stage, used for the redesign workflow)
- The DESIGN.md + tokens.json + tokens.css produced are equivalent to the design-system skill's output, consumed by downstream in-LOOP skills
- The IMPORT_REPORT.md produced is for the user to confirm differences and decide whether to enter the LOOP for redesign
