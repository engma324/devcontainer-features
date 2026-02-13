#!/bin/bash

set -e

source dev-container-features-test-lib

check "opencode installed" bash -c "command -v opencode"
check "opencode executable" bash -c "opencode --version >/dev/null 2>&1"
check "opencode models returns no model" bash -c '
OUTPUT="$(opencode models 2>&1 || true)"
if [ -z "$(echo "$OUTPUT" | tr -d "[:space:]")" ]; then
	exit 0
fi
echo "$OUTPUT" | grep -Eiq "no models?|0 models?|none"
'

reportResults
