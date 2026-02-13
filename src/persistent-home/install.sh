#!/bin/sh
set -e

echo "Activating feature 'persistent-home'"

cat > /usr/local/bin/persistent-home-init \
<< 'EOF'
#!/bin/sh
set -e

if [ -d "/userfiles" ]; then
	cp -af "/userfiles"/. "$HOME"/
fi

EOF

chmod +x /usr/local/bin/persistent-home-init
