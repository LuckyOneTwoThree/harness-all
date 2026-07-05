#!/bin/bash
# commit-msg hook wrapper; delegates format policy to the reusable guard.

if grep -qI $'\r' "$0" 2>/dev/null; then
  exec bash < <(tr -d '\r' < "$0") "$@"
fi

set -e
bash .harness/hooks/guards/guard-commit-msg.sh "$1"
