# Component Map Contract — Reference

The canonical schema, consumption rules, and worked example for `docs/handoff/component-map.json`. The main SKILL.md keeps only the summary; this file holds the field-level detail. Read it before implementing any component listed in the map.

## Schema

`component-map.json` is a JSON object keyed by the design-layer component name. Each value is an object with the following shape:

```json
{
  "<DesignComponentName>": {
    "designToken": "<token.path>",
    "engineeringComponent": "<CodeComponentName>",
    "props": { "<propName>": "<propValue or type>" },
    "states": ["<state1>", "<state2>", "..."],
    "notes": "<free-form engineering note>"
  }
}
```

## Field Reference

| Field | Type | Required | Meaning |
|-------|------|----------|---------|
| `designToken` | string | yes | Token path linked to `tokens.json` (e.g. `button.primary`). Hardcoded color/spacing values are forbidden; resolve every value through this path. |
| `engineeringComponent` | string | yes | Engineering component name (e.g. `Button`). Used verbatim as the code component name; do not rename on import. |
| `props` | object | yes | Contract for component props. Every prop must be implemented; dropping a prop is a contract violation. |
| `states` | string[] | yes | All interactive/visual states that must be covered. A missing state is a design omission — feed it back to harness-design, do not silently skip. |
| `notes` | string | no | Free-form engineering guidance (e.g. "at most 1 per screen"). Read but not machine-enforced. |

## Consumption Rules

1. **`engineeringComponent` is the source name.** Use it verbatim as the code component name. Do not translate, abbreviate, or alias it to fit a local naming convention.
2. **`props` is a contract, not a suggestion.** Every prop in the map must be implemented by the engineering component. If a prop is impractical for the framework, raise it with harness-design rather than dropping it silently.
3. **`states` is exhaustive.** Every listed state must be handled (default / hover / active / disabled / loading / etc.). A missing state is a design omission, not an engineering shortcut — feed it back to harness-design.
4. **`designToken` links to `tokens.json`.** Hardcoded color/spacing values are forbidden; resolve every value through the token path. Bare `#333` or `13px` is a violation.
5. **Framework-agnostic Type alignment.** The `props` Type must match the framework declared in `docs/engineering/TECH_STACK.md`:

   | Framework | Allowed Types |
   |-----------|---------------|
   | React | `ReactNode` / `JSX.Element` |
   | Vue | `VNode` / `Slot` |
   | Svelte | `Snippet` / `Component` |
   | Native / Web Components | `HTMLElement` / `Slot` |

   If the Type in `component-map.json` does not match the project framework, mark the entry "to be aligned with harness-design" and raise it back — do not silently rewrite the type.

## Override and Priority

When sources conflict, follow this priority (highest first):

1. `docs/handoff/component-map.json` — component-level contract (this file)
2. `docs/handoff/design-to-solo.md` — feature-level handoff notes (open items, AC overrides)
3. `docs/design-system/DESIGN.md` — global design system constraints
4. `docs/design-system/tokens.json` / `tokens.css` — token values

A higher-priority source may refine but not contradict a lower one. If a contradiction appears, treat it as a handoff defect and feed it back to harness-design — do not silently pick one source.

## Worked Example

```json
{
  "PrimaryButton": {
    "designToken": "button.primary",
    "engineeringComponent": "Button",
    "props": { "variant": "primary", "size": "md" },
    "states": ["default", "hover", "active", "disabled", "loading"],
    "notes": "Primary action button, at most 1 per screen"
  }
}
```

Engineering implementation contract derived from the example:

- Component name in code: `Button` (used verbatim from `engineeringComponent`)
- Must accept props `variant: "primary"` and `size: "md"` — both are mandatory
- Must implement five states: `default`, `hover`, `active`, `disabled`, `loading` — none may be missing
- Color/spacing values resolve through the `button.primary` token path in `tokens.json`
- At most one `PrimaryButton` per screen (engineering note, enforced at review time)

## What NOT to do

- Rename `engineeringComponent` to fit a local naming convention — the map is the contract.
- Drop a prop because "the design didn't seem to need it" — feed it back to harness-design instead.
- Hardcode a color because the token path was inconvenient — resolve through `tokens.json`.
- Silently skip a state because the framework makes it hard — raise the gap with harness-design.
- Treat `notes` as ignorable commentary — read it and enforce it at review time.
