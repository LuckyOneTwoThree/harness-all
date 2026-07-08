---
name: release-notes
description: Used when generating release notes, changelogs, or version announcements for product version releases. Version release notes auto-generation, based on change logs and PRD diffs, generates user/customer-facing version update notes, supports multi-language and multi-platform formats.
---
# Version Release Notes Auto-Generation

## When to use
- Help me write version update notes
- Generate release notes
- What's new in this version, organize it
- Keywords: version release notes, Release Notes, changelog, version update, update notes, release notes, what's new

## Outputs
- docs/monitoring/release-notes.md
- memory/progress.md
- memory/knowledge-base.md

## Core Principles

1. **User perspective**—users care about "what's the impact on me", not "what code changed"
2. **Tiered presentation**—important changes highlighted, minor changes not buried
3. **Honest and transparent**—known issues not hidden, breaking changes announced in advance
4. **Action-oriented**—what users need to do (upgrade/configure/note) must be clear

## Interaction Mode

🤖→👤 AI suggests, human approves

## Inputs

| Input Item | Type | Required | Source | Description |
|--------|------|------|------|------|
| Requirement change log | Markdown/JSON | ○ | docs/monitoring/release-notes.md ("Release Checklist" section) | Requirement changes for this version |
| PRD document | Markdown | ○ | docs/product/PRD.md | Product requirement reference |
| SRS document | Markdown | ○ | docs/product/PRD.md | Requirement specification reference (covered by design-prd) |
| Version number | string | Yes | User-provided | e.g., v2.3.0 |
| Release date | string | Yes | User-provided | e.g., 2025-03-15 |
| Release type | string | Yes | User-provided | major / minor / patch / hotfix |
| Target audience | string | ○ | User-provided | End users / Enterprise customers / Developers / Internal team |

## Execution Steps

### Step 1: Change Collection & Classification [Core]

Collect all changes for this version and classify by type:

**Change Classification System**:

| Category | Icon | Description | Example |
|------|------|------|------|
| 🆕 New Features | ✨ | New product features | Added social sharing feature |
| 🔄 Improvements | 🔧 | Optimizations to existing features | Search speed improved 3x |
| 🐛 Fixes | 🐛 | Bug fixes | Fixed login page white screen issue |
| ⚠️ Breaking Changes | 💥 | Changes requiring user adaptation | API v1 sunset, please migrate to v2 |
| 🗑️ Deprecations | 🗑️ | Feature/API removal | Removed legacy export feature |
| 🔒 Security | 🔒 | Security-related fixes | Fixed XSS vulnerability |

**Change Source Mapping**:

| Change Source | Extraction Method |
|----------|---------|
| requirements-change-log | Extract approved requirement changes from change log |
| PRD diff | Compare old and new PRD to extract feature changes |
| User-provided | Change content directly described by user |

### Step 2: User Impact Assessment [Core]

Assess the impact of each change on users:

**Impact Levels**:

| Level | Definition | Position in Release Notes |
|------|------|----------------|
| 🔴 High impact | Changes core user workflow or requires user action | Top "Important Changes" area |
| 🟡 Medium impact | Improves experience but no mandatory action | Listed by category |
| 🟢 Low impact | Optimizations users don't notice | Collapsed area |

**User Action Items**:

| Action Type | Description | Example |
|----------|------|------|
| Must do | Not doing affects usage | Please reconfigure API key |
| Recommended | Doing improves experience | Recommend updating mobile to latest version |
| No action needed | Takes effect automatically | Performance optimization auto-applied |

## output-schema Guidance

The detailed templates, examples, and depth-specific execution guidance are in [Reference/output-schema.md](Reference/output-schema.md). Load that file only when producing the full artifact or when a deep-mode decision requires it.


## Output Validation Rules

| Field Path | Type | Required | Description |
|----------|------|------|------|
| release_notes | object | Yes | Release notes root object |
| release_notes.version | string | Yes | Version number |
| release_notes.release_date | string | Yes | Release date |
| release_notes.highlights | array | Yes | Core highlights list, at least 1 item |
| release_notes.highlights[].title | string | Yes | Highlight title |
| release_notes.highlights[].description | string | Yes | Highlight description |
| release_notes.highlights[].target_audience | string | Yes | Target audience |
| release_notes.changes | object | Yes | Change classification |
| release_notes.changes.new_features | array | Yes | New features list |
| release_notes.changes.improvements | array | Yes | Improvements list |
| release_notes.changes.bug_fixes | array | Yes | Fixes list |
| release_notes.changes.breaking_changes | array | No | Breaking changes list |
| release_notes.changes.deprecations | array | No | Deprecated features list |
| release_notes.upgrade_guide | object | Conditionally required | Upgrade guide, required when breaking_changes exist |
| release_notes.known_issues | array | No | Known issues list |
| release_notes.acknowledgments | array | No | Acknowledgments list |

## Upstream Change Response

When upstream inputs change, this Skill's response strategy:

| Upstream Change | Impact Scope | Response Strategy |
|----------|----------|----------|
| PRD requirement change | New features and improvement descriptions | Update change classification and descriptions, mark for human confirmation |
| Canary release results | Known issues and upgrade guide | Update known issues list, supplement upgrade notes |
| Acceptance report change | Change classification and completeness | Re-evaluate change classification, ensure all changes covered |
| Checklist change | Release notes completeness | Update release notes, ensure consistency with checklist |

When the release notes themselves change, the notification mechanism for downstream:

| Notes Change Type | Notification Scope | Notification Method |
|-------------|----------|----------|
| New breaking change | All downstream | Mark breaking change, trigger impact assessment |
| New known issue | agile-launch-review | Mark known issue, trigger retrospective input |
| Version number change | release-gradual | Mark version change, trigger canary configuration update |

---

## Decision Rules

| Condition | Decision |
|------|------|
| Has breaking changes | Must highlight in top "Important Changes" area |
| Has security fixes | Must include security fixes section, mark CVE number |
| Change items > 20 | Sort by impact level, collapse low impact |
| hotfix type | Only list fixes, no new features and improvements |
| major version | Must include upgrade guide and rollback plan |

## Quality Checks

### P0 Checks (must pass for quick/standard/deep)

- [ ] Version number and date correct
- [ ] Changes classified by category

### P1 Checks (must pass for standard/deep)

- [ ] Breaking changes highlighted
- [ ] User action items clear
- [ ] Known issues listed
- [ ] Multi-format generated (user/enterprise/developer versions)
- [ ] No technical terminology leaked to end user version

### P2 Checks (must pass for deep only)

- [ ] Extended analysis complete (in-depth derivation and roadmap generated)
- [ ] Decision records complete (key decisions have rationale and alternatives)

## Degradation Strategy

| Missing Upstream Input | Degradation Plan | Output Impact |
|---------------|---------|---------|
| Change log missing | Generate based on user-provided change description | Changes may be incomplete |
| PRD missing | Cannot auto-extract feature changes | Need manual feature description supplementation |
| Target audience not specified | Default to end user version | May need to supplement other versions |
