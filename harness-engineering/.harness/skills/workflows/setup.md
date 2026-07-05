---
workflow_id: A
name: setup
description: "Validate and complete the project-owned configuration created by install.sh"
default_mode: none
---
# Workflow: Setup

Use for first-time initialization or incomplete `SOUL.md`, `constitution.md`, `PROJECT.md`, or `TECH_STACK.md`. This is configuration work, not a code LOOP.

> **Matrix**: non-LOOP path (workflow `A`) — see `engineering-pipeline.md` Non-LOOP Paths. No phase routing, no state.yaml, no task_type.

## Route

1. Run session-start and detect first-use/incomplete configuration.
2. Confirm install-created files exist; missing framework files route to reinstall/upgrade rather than manual reconstruction.
3. Fill project-owned files from evidence in the codebase and user decisions:
   - SOUL: preferences, not hard policy;
   - constitution: project-specific, mechanically verifiable constraints;
   - PROJECT: scope, stable acceptance criteria, non-goals;
   - TECH_STACK: actual language/framework plus executable test/build/lint/start commands.
4. Run every declared command that is safe in the current environment; mark unavailable commands with owner and blocker.
5. Record configuration status in progress.md.

## Exit

Required files are non-placeholder, commands are verified or explicitly blocked, and the next engineering workflow can pass its Foundation gate.
