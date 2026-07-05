---
workflow_id: G
name: release
description: "Validate a selected release scope, review metadata/artifacts, and perform only user-authorized version and tag actions"
default_mode: skip
---
# Workflow: Release

Release is a non-LOOP delivery path. It does not require every item on the global FEATURES board to be done—only every item explicitly included in this release scope.

## Route

1. session-start; define release scope, target version, channel, and excluded known work.
2. Hard gate:
   - scoped tasks are done and reviewed;
   - current full verification/security evidence passes;
   - migrations/config/rollback/release notes are complete;
   - artifact command and clean-environment verification are known.
3. writing-documentation updates CHANGELOG from reviewed task/review evidence.
4. Build and verify release artifacts in a clean or representative environment.
5. Review version choice, CHANGELOG, artifacts, migration order, and rollback **before** tagging.
6. With explicit user authorization, update version files and create an annotated local tag.
7. Never push tags, publish packages/images, or deploy without separate explicit authorization.
8. session-end records the release and prepares requested handoffs.

## Exit

Artifacts match reviewed sources, release metadata is accurate, authorized local actions succeeded, and no external publication is implied.
