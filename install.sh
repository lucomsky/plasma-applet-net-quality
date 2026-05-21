#!/usr/bin/env bash
set -e

PLASMOID_ID="net.quality.monitor"
DEST="$HOME/.local/share/plasma/plasmoids/$PLASMOID_ID"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Net Quality Monitor plasmoid..."

# Remove old install if exists
if [ -d "$DEST" ]; then
    kpackagetool5 --remove "$PLASMOID_ID" --type Plasma/Applet 2>/dev/null || true
    rm -rf "$DEST"
fi

# Copy files
mkdir -p "$(dirname "$DEST")"
cp -r "$SCRIPT_DIR" "$DEST"

# Register with Plasma
kpackagetool5 --install "$DEST" --type Plasma/Applet

echo ""
echo "Done! Now:"
echo "  1. Right-click the KDE panel"
echo "  2. Choose 'Add Widgets...'"
echo "  3. Search for 'Net Quality'"
echo "  4. Drag it onto the panel"
