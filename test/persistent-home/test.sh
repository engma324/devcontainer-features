#!/bin/bash
set -e

# Optional: Import test library bundled with the devcontainer CLI
# Provides the 'check' and 'reportResults' commands.
source dev-container-features-test-lib

check "home target for user" bash -c '
TARGET_HOME="$HOME"
CURRENT_USER="$(id -un)"
EXPECTED_HOME="$(getent passwd "$CURRENT_USER" | cut -d: -f6)"

if [ "$TARGET_HOME" != "$EXPECTED_HOME" ]; then
    echo "HOME does not match passwd home: $TARGET_HOME != $EXPECTED_HOME"
    exit 1
fi

if [ "$CURRENT_USER" != "root" ] && [ "$TARGET_HOME" != "/home/host" ]; then
    echo "unexpected non-root home: $TARGET_HOME"
    exit 1
fi
'

check "persistent-home-init copies from source" bash -c '
TARGET_HOME="$HOME"

if [ ! -f "$TARGET_HOME/.bashrc" ]; then
    exit 1
fi
'

# Report results
reportResults
