---
workflow_id: G
name: release
default_mode: skip
---

# Workflow F: Release

> Applicable scenario: Version release, CHANGELOG update, tagging, building release artifacts
> Core mode: verify full validation → writing-documentation update CHANGELOG → tag → build release artifacts

## Differences from Other Workflows

| Dimension | new-feature | **release** |
|------|-------------|------------|
| Goal | Implement new features | Release a version |
| Prerequisite | brainstorming | **All planned features complete (FEATURES.md all done)** |
| LOOP | tdd→verify | **No LOOP (validation-focused)** |
| Output | Code + tests | **Version number + tag + CHANGELOG + release artifacts** |

## Process

```
┌─────────────────┐
│ session-start   │  Load context, confirm release scope
└────────┬────────┘
         ▼
┌─────────────────────────────────────────┐
│ Release prerequisite check (hard gate)  │
│                                         │
│  - Are all features in FEATURES.md done?│
│  - Have PROJECT.md's success metrics    │
│    been met?                            │
│  - Have PROJECT.md's milestone statuses │
│    been updated?                        │
│  - Does the full test suite pass?       │
│  - Does the verify skill's comprehensive│
│    check pass?                          │
│  - Security scan has no critical/high?  │
│  - Constitution compliant?              │
│                                         │
│  ★ If any is not met → don't release    │
└────────┬────────────────────────────────┘
         │ Passed
         ▼
┌─────────────────┐
│ writing-docu-   │  Update CHANGELOG
│ mentation       │  - Added / Fixed / Changed
│                 │  - Link issue numbers
│                 │  - Extract changes from iterations.log
└────────┬────────┘
         ▼
┌─────────────────┐
│ Version number  │  Per semantic versioning
│ management      │  - major: incompatible API changes
│                 │  - minor: backward-compatible new features
│                 │  - patch: backward-compatible fixes
└────────┬────────┘
         ▼
┌─────────────────┐
│ Build + verify  │
│                 │  - Build release artifacts (e.g. npm pack / go build)
│                 │  - Verify artifacts run in a clean environment
│                 │  - Show build output
└────────┬────────┘
         ▼
┌─────────────────┐
│ Tag             │  git tag v<X.Y.Z>
│                 │  - annotated tag with CHANGELOG summary
│                 │  - Don't auto-push (requires user confirmation)
└────────┬────────┘
         ▼
┌─────────────────────┐
│ requesting-code-    │  Release review
│ review              │  - CHANGELOG accurate?
│                     │  - Version number reasonable?
│                     │  - Release artifacts complete?
└──────────┬──────────┘
           │ Passed
           ▼
┌─────────────────┐
│ session-end     │  Archive + baseline
│                 │  - Record release info to progress.md
│                 │  - Optional output solo-to-growth.md
└─────────────────┘
```

## Key Checkpoints

- [ ] Are all features in FEATURES.md marked done?
- [ ] Have PROJECT.md's success metrics been met? (Check item by item, show data)
- [ ] Have PROJECT.md's milestone statuses been updated? (Updated in FEATURES.md)
- [ ] Does the full test suite pass? (Show output)
- [ ] Does verify's comprehensive check pass?
- [ ] Security scan has no critical/high?
- [ ] CHANGELOG updated? (Added/Fixed/Changed)
- [ ] Does the version number follow semantic versioning?
- [ ] Were release artifacts verified in a clean environment?
- [ ] Was the tag created? (Don't auto-push)

## Failure Handling

| Failure Point | Handling |
|--------|---------|
| Some features not done | Don't release; finish them or remove from this version |
| Tests fail | Fix and re-validate; no skipping |
| Security scan has critical | Fix before release; don't ignore |
| Release artifact build fails | Fix the build issue; don't publish broken artifacts |
| code-review not passed | Fix issues and re-review |

## Safety Principles

1. **Don't auto-push tags**: Tags are created locally; push requires explicit user confirmation
2. **Don't auto-publish**: npm publish / docker push etc. require explicit user confirmation
3. **Release artifact verification**: Must verify it runs in a clean environment; don't "publish just because the build succeeded"
4. **CHANGELOG accuracy**: Extract from iterations.log; don't write from memory
