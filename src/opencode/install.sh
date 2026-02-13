#!/bin/sh
set -e

echo "Activating feature 'opencode'"

if ! command -v curl >/dev/null 2>&1; then
    apt-get update && DEBIAN_FRONTEND=noninteractive apt-get -y install curl
fi
if ! command -v curl >/dev/null 2>&1; then
    echo "curl is required to install opencode"
    exit 1
fi

if ! command -v tar >/dev/null 2>&1; then
    echo "tar is required to install opencode"
    exit 1
fi

ARCH="$(uname -m)"
case "$ARCH" in
    x86_64|amd64)
        TARGET_ARCH="x64"
        ;;
    aarch64|arm64)
        TARGET_ARCH="arm64"
        ;;
    *)
        echo "Unsupported architecture: $ARCH"
        exit 1
        ;;
esac

MUSL_SUFFIX=""
if command -v ldd >/dev/null 2>&1 && ldd --version 2>&1 | grep -qi musl; then
    MUSL_SUFFIX="-musl"
fi

ASSET_NAME="opencode-linux-${TARGET_ARCH}${MUSL_SUFFIX}.tar.gz"
DOWNLOAD_URL="https://github.com/anomalyco/opencode/releases/latest/download/${ASSET_NAME}"

TMP_DIR="$(mktemp -d)"
trap 'rm -rf "$TMP_DIR"' EXIT

curl -fsSL "$DOWNLOAD_URL" -o "$TMP_DIR/opencode.tar.gz"
tar -xzf "$TMP_DIR/opencode.tar.gz" -C "$TMP_DIR"

BINARY_PATH="$(find "$TMP_DIR" -type f -name opencode | head -n 1)"
if [ -z "$BINARY_PATH" ]; then
    echo "Unable to find opencode binary in release asset ${ASSET_NAME}"
    exit 1
fi

install -m 0755 "$BINARY_PATH" /usr/local/bin/opencode

/usr/local/bin/opencode --version || true
