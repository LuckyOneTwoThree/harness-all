# Handoff Document Directory

This directory stores handoff documents between harness family frameworks.

## Handoff Protocol

Each handoff document follows a unified format so that downstream framework Agents can quickly understand upstream outputs.

## Document Naming Convention

```
<source-framework>-to-<target-framework>.md
```

For example:
- `pm-to-design.md` — harness-pm hands off to harness-design (Product → Design)
- `design-to-solo.md` — harness-design hands off to harness-solo (Design → Engineering)

## Usage

1. After completing its phase, the upstream framework generates a handoff document from the template and places it in this directory
2. The downstream framework's session-start skill will auto-detect and read the corresponding handoff document
3. You can also place files manually (e.g., copy a PRD from another project)

## Templates

- `handoff-template.md`: Generic handoff template
- `design-to-solo-template.md`: harness-design → harness-solo dedicated template (includes AC-xxx/DAC-xxx sections + component-map.json reference)

Copy and fill in based on actual conditions.
