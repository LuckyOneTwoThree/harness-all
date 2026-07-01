---
name: wireframe
description: Produces low-fidelity wireframes for structure validation. Use before visual design. Use for prototype tasks in LOOP.
---
# Wireframe

## When to use
- Wireframe tasks
- In-LOOP wireframe stage
- Need to validate structure before visual design

## Inputs
- docs/visual/DESIGN_BRIEF.md
- .harness/data/design/landing.csv
- docs/design-system/DESIGN.md

## Outputs
- docs/prototype/wireframe-<page>.md (per-page; supports product-level multi-page workflows)

## Overview

Low-fidelity wireframes for fast structure validation. Black, white, and gray only; no visual treatment. Structure first, visuals second—avoid doing visual design on the wrong structure.

## Process

### 1. Read Context

- `docs/visual/DESIGN_BRIEF.md`: Requirements
- `.harness/data/design/landing.csv`: Landing page structure patterns (if applicable)

### 2. Information Architecture (IA) Sorting

- List all information units on the page
- Sort by priority (P0/P1/P2)
- Group and categorize

### 3. User Flow Drawing

- Entry → key steps → exit
- Annotate branches and exception paths

### 4. Low-Fidelity Wireframe

Use ASCII art or markdown to describe the layout:

```
+----------------------------------+
| Logo          Nav     UserMenu   |
+----------------------------------+
|                                  |
|        Hero Title                |
|        Hero Subtitle             |
|        [Primary CTA]             |
|                                  |
+----------------------------------+
| Feature 1  | Feature 2 | Feature 3|
| [icon]     | [icon]    | [icon]   |
+----------------------------------+
| Footer Links    Copyright        |
+----------------------------------+
```

**Constraints**:
- Only black, white, and gray (no color)
- No font selection
- No specific images
- Annotate information priority (P0/P1/P2)

### 5. Responsive Structure

Annotate structural differences across mobile / tablet / desktop:

```
Mobile (375px): single-column stack
Tablet (768px): two columns
Desktop (1280px): three columns
```

### 6. Output

Write to `docs/prototype/wireframe.md`.

## Output Format

```markdown
# Wireframe: <Page Name>

## Information Architecture

### P0 (Required)
- Hero title
- Primary CTA

### P1 (Important)
- Feature list
- Social proof

### P2 (Optional)
- Footer links

## User Flow

Entry → Hero → CTA → Sign-up page → ...

## Wireframe

### Desktop (1280px)
<ASCII art>

### Tablet (768px)
<ASCII art>

### Mobile (375px)
<ASCII art>
```

## Common Rationalizations

| Excuse | Reality |
|--------|---------|
| "Going straight to high-fidelity is faster" | Doing visual design on the wrong structure is a waste of time |
| "Wireframes are too rough" | The purpose of a wireframe is to validate structure quickly; roughness is a virtue |
| "No need to sort the IA" | A wireframe without IA is just doodling |

## Red Flags

- Wireframe contains color / fonts / images
- No information priority annotated
- No responsive structure drawn
- Skipping IA and drawing the wireframe directly

## Verification

- [ ] IA sorted (evidence: P0/P1/P2 grouping)
- [ ] user-flow drawn (evidence: flow diagram)
- [ ] Wireframe only black, white, gray (evidence: no color / fonts / images)
- [ ] Responsive structure annotated (evidence: 375px/768px/1280px)
- [ ] Information priority annotated (evidence: P0/P1/P2 markers)

## Relationship with LOOP

- Stage: DESIGN
- Loop type: wireframe
- Max iterations: 5
- After each iteration, verify runs (unified gate including lint)
- After LOOP exits, design-review performs the Five-Axis review
