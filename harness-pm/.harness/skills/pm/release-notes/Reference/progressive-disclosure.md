# release-notes — Detailed Guidance

> Load on demand from the parent SKILL.md. This file preserves detailed templates and examples outside the default routing context.

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
