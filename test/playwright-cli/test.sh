#!/bin/bash

set -e

source dev-container-features-test-lib

check "playwright-cli installed" bash -c "command -v playwright-cli"
check "playwright-cli executable" bash -c "playwright-cli --version"
check "chrome installed" bash -c "google-chrome --version"
check "chrome launches" bash -c "google-chrome --headless --no-sandbox --disable-dev-shm-usage --dump-dom about:blank"

reportResults