#!/bin/bash
set -e

source dev-container-features-test-lib

check "home target for user" bash -c '
if [ ! -f "$HOME/.bashrc" ]; then
    exit 1
fi
'
reportResults
