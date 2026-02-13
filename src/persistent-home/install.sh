#!/bin/sh
set -e

echo "Activating feature 'persistent-home'"

echo "Home mount target is set to /home/host"

TARGET_HOME="/home/host"
REMOTE_USER="${_REMOTE_USER:-vscode}"
SOURCE_HOME="${_REMOTE_USER_HOME:-/home/vscode}"

echo "$REMOTE_USER" > /etc/persistent-home-user

mkdir -p "$TARGET_HOME"
echo "$SOURCE_HOME" > /etc/persistent-home-source

cat > /usr/local/bin/persistent-home-init \
<< 'EOF'
#!/bin/sh
set -e

TARGET_HOME="/home/host"
SOURCE_HOME=""
TARGET_USER="$(id -un)"

if [ -f /etc/persistent-home-user ]; then
	TARGET_USER="$(cat /etc/persistent-home-user)"
fi

if [ -f /etc/persistent-home-source ]; then
	SOURCE_HOME="$(cat /etc/persistent-home-source)"
fi

mkdir -p "$TARGET_HOME"

if [ "$(id -u)" -eq 0 ]; then
	if [ -n "$TARGET_USER" ] && [ "$TARGET_USER" != "root" ] && command -v usermod >/dev/null 2>&1; then
		usermod --home "$TARGET_HOME" "$TARGET_USER" || true
	fi
	chown "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME" || true
elif command -v sudo >/dev/null 2>&1; then
	if [ -n "$TARGET_USER" ] && [ "$TARGET_USER" != "root" ] && command -v usermod >/dev/null 2>&1; then
		sudo usermod --home "$TARGET_HOME" "$TARGET_USER" || true
	fi
	sudo chown "$TARGET_USER":"$TARGET_USER" "$TARGET_HOME" || true
fi

if [ -n "$SOURCE_HOME" ] && [ "$SOURCE_HOME" != "$TARGET_HOME" ] && [ -r "$SOURCE_HOME" ] && [ -x "$SOURCE_HOME" ]; then
	cp -a "$SOURCE_HOME"/. "$TARGET_HOME"/
fi

if [ -d "/home/userfiles" ]; then
	cp -a "/home/userfiles"/. "$TARGET_HOME"/
fi

EOF

chmod +x /usr/local/bin/persistent-home-init
