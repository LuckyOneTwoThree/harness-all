---
name: release-notes
description: Used when generating release notes, changelogs, or version announcements for product version releases. Version release notes auto-generation, based on change logs and PRD diffs, generates user/customer-facing version update notes, supports multi-language and multi-platform formats. Keywords: version release notes, Release Notes, changelog, version update, update notes, release notes, what's new.
metadata:
  module: "Product Monitoring & Iteration"
  sub-module: "Release Launch"
  type: "pipeline"
  version: "2.0"
  domain_tags: ["Internet", "General"]
  trigger_examples:
    - "Help me write version update notes"
    - "Generate release notes"
    - "What's new in this version, organize it"
  interaction_mode: "ai_suggest_human_approve"
execution_depth:
  default: standard
  quick_description: "Directly output release notes and change list"
  deep_description: "Full notes + change impact analysis + upgrade guide + rollback plan"
reads:
  - rules/security.md
  - loops/LOOP.md
  - docs/monitoring/release-notes.md
  - docs/product/PRD.md
writes:
  - docs/monitoring/release-notes.md
  - memory/progress.md
  - memory/knowledge-base.md
---

# Version Release Notes Auto-Generation

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

### Step 3: Multi-Format Generation [Core]

Generate release notes in different styles based on target audience:

**Format A: End User Version** (concise, emotional)

```
## ✨ New Features
- **Social Sharing**: One-click share to WeChat/Weibo, let friends use the great tool too
- **Dark Mode**: Easier on the eyes for late-night work, one-click switch in settings

## 🔧 Improvements
- Search speed improved 3x, results appear as you type
- List loading smoother, no more lag

## 🐛 Fixes
- Fixed occasional login failure issue
- Fixed garbled export filename issue
```

**Format B: Enterprise Customer Version** (professional, structured)

```
## New Features
| Feature | Description | Impact Scope |
|------|------|---------|
| Social Sharing | Support sharing to Enterprise WeChat/DingTalk | All platforms |
| Dark Mode | System-level dark mode adaptation | Desktop |

## Improvements
| Improvement | Optimization | Performance Gain |
|--------|---------|---------|
| Search engine | Rebuilt indexing algorithm | Response time -70% |

## Security Fixes
- CVE-2025-XXXX: Fixed XSS vulnerability (High)
- Updated dependency library versions, fixed known security vulnerabilities

## Breaking Changes
- API v1 will be sunset on 2025-06-30, please migrate to API v2
  Migration guide: [link]

## Known Issues
- Occasional style misalignment in Safari 14, fixed in next version
```

**Format C: Developer Version** (technical, detailed)

```
## Breaking Changes
- `POST /api/v1/users` → `POST /api/v2/users` (added required field `tenant_id`)
- Removed `GET /api/v1/export` (use `GET /api/v2/export` instead)

## New APIs
- `POST /api/v2/share` — Social sharing API
- `GET /api/v2/preferences/theme` — Theme preference API

## Changelog
- feat: Added social sharing module
- perf: Search engine index rebuild, response time optimized 70%
- fix: Fixed issue where login token wasn't auto-refreshed after expiration
- security: Fixed XSS vulnerability CVE-2025-XXXX
```

### Step 4: Version Information Assembly [Core]

**Version Information Header**:

```
# {Product Name} v{Version} Release Notes

📅 Release Date: {Date}
🏷️ Version Type: {major/minor/patch/hotfix}
🔗 Upgrade Guide: {Link}
📋 Full Changelog: {Link}
```

**Version Number Semantics**:

| Type | Semantics | User Expectation |
|------|------|---------|
| major | Major update, may have breaking changes | Expect new experience, watch migration cost |
| minor | Feature update, backward compatible | Expect new features |
| patch | Bug fixes, backward compatible | Expect stability improvements |
| hotfix | Emergency fix | Expect issue resolution |

### Step 5: Document Assembly [Core]

**Complete Release Notes Structure**:

```
# {Product Name} v{Version} Release Notes

## ⚠️ Important Changes (if breaking changes or mandatory actions)
- ...

## ✨ New Features
- **Feature Name**: Description (impact level)
- ...

## 🔧 Improvements
- Description (impact level)
- ...

## 🐛 Fixes
- Description
- ...

## 🔒 Security Fixes (if any)
- Description

## 🗑️ Deprecation Notices (if any)
- Description and alternative

## ⚠️ Known Issues (if any)
- Description and temporary workaround

## 📋 Upgrade Guide (if needed)
### Prerequisites
### Upgrade Steps
### Rollback Plan

## Acknowledgments (optional)
```

### Output Depth Levels

| Depth Level | Output Scope | Description |
|----------|----------|------|
| quick | Release notes and change list | Core conclusions + minimum viable deliverable |
| standard | Full deliverable (current default) | Full deliverable, includes all Step outputs |
| deep | Full notes + change impact analysis + upgrade guide + rollback plan | Full deliverable + extended analysis + in-depth derivation |

## Output

**Storage path**: `docs/monitoring/release-notes.md ("Release Notes" section, overwrite)`

**Output Files**:

| File | Format | Description |
|------|------|------|
| release-notes-v{version}.md | Markdown | Complete release notes (end user version) |
| release-notes-v{version}-enterprise.md | Markdown | Enterprise customer version |
| release-notes-v{version}-developer.md | Markdown | Developer version |
| release-notes-v{version}.json | JSON | Structured data |

**Output Schema**:

```json
{
  "type": "object",
  "required": ["release_notes"],
  "properties": {
    "release_notes": {
      "type": "object",
      "description": "Release notes root object",
      "required": ["version", "release_date", "highlights", "changes"],
      "properties": {
        "version": {"type": "string", "description": "Version number"},
        "release_date": {"type": "string", "description": "Release date"},
        "highlights": {
          "type": "array",
          "description": "Core highlights list, at least 1 item",
          "items": {
            "type": "object",
            "required": ["title", "description", "target_audience"],
            "properties": {
              "title": {"type": "string", "description": "Highlight title"},
              "description": {"type": "string", "description": "Highlight description"},
              "target_audience": {"type": "string", "description": "Target audience"}
            }
          }
        },
        "changes": {
          "type": "object",
          "description": "Change classification",
          "required": ["new_features", "improvements", "bug_fixes"],
          "properties": {
            "new_features": {"type": "array", "description": "New features list"},
            "improvements": {"type": "array", "description": "Improvements list"},
            "bug_fixes": {"type": "array", "description": "Fixes list"},
            "breaking_changes": {"type": "array", "description": "Breaking changes list"},
            "deprecations": {"type": "array", "description": "Deprecated features list"}
          }
        },
        "upgrade_guide": {"type": "object", "description": "Upgrade guide, required when breaking_changes exist"},
        "known_issues": {"type": "array", "description": "Known issues list"},
        "acknowledgments": {"type": "array", "description": "Acknowledgments list"}
      }
    }
  }
}
```

**release-notes.json Structure**:

```json
{
  "release_notes": {
    "version": "2.3.0",
    "release_date": "2025-03-15",
    "highlights": [
      {
        "title": "Social Sharing",
        "description": "One-click share to WeChat/Weibo",
        "target_audience": "End users"
      }
    ],
    "changes": {
      "new_features": [ { /* See Step 1 Change Collection & Classification */ } ],
      "improvements": [ { /* See Step 1 Change Collection & Classification */ } ],
      "bug_fixes": [ { /* See Step 1 Change Collection & Classification */ } ],
      "breaking_changes": [ { /* See Step 1 Change Collection & Classification */ } ],
      "deprecations": [ { /* See Step 1 Change Collection & Classification */ } ]
    },
    "upgrade_guide": { /* See Step 5 Document Assembly, required when breaking_changes exist */ },
    "known_issues": [ { /* See Step 1 Change Collection & Classification */ } ],
    "acknowledgments": [ { /* See Step 5 Document Assembly */ } ]
  }
}
```

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
