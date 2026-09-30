#!/bin/sh
set -e

echo "Activating feature 'playwright-cli'"

if ! command -v node >/dev/null 2>&1 || ! command -v npm >/dev/null 2>&1; then
	echo "Node.js and npm are required. Use a Node-based image or add ghcr.io/devcontainers/features/node to your devcontainer features." >&2
	exit 1
fi

npm install -g @playwright/cli@latest
playwright-cli install-browser chrome --with-deps