# Handoff Document Directory

This directory stores handoff documents between harness family frameworks.

## Handoff Protocol

Each handoff document follows a unified format so that downstream framework Agents can quickly understand upstream outputs.

## Document Naming Convention

```
<source-framework>-to-<target-framework>.md
```

For example:
- `pm-to-solo.md` — harness-pm hands off to harness-solo (Product → Engineering)
- `solo-to-growth.md` — harness-solo hands off to harness-growth (Engineering → Growth)
- `design-to-solo.md` — harness-design hands off to harness-solo (Design → Engineering)

## Usage

1. After completing its phase, the upstream framework generates a handoff document from the template and places it in this directory
2. The downstream framework's brainstorming skill will auto-detect and read the corresponding handoff document
3. You can also place files manually (e.g., copy a PRD from another project)

## Templates

- `handoff-template.md` — Generic handoff template
- `solo-to-growth-template.md` — harness-solo → harness-growth dedicated template (includes implemented features list + AC-xxx + performance metrics + tracking events)
- `solo-to-ops-template.md` — harness-solo → ops dedicated template (engineering handoff to ops: deployment checklist + config items + monitoring alerts + rollback plan)

Copy and fill in based on actual conditions.
