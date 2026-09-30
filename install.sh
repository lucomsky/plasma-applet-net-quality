#!/usr/bin/env bash
set -e

PLASMOID_ID="net.quality.monitor"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo "Installing Net Quality Monitor plasmoid..."

# Remove old install if exists
kpackagetool6 --remove "$PLASMOID_ID" --type Plasma/Applet 2>/dev/null || true

# Register with Plasma using the source directory
kpackagetool6 --install "$SCRIPT_DIR" --type Plasma/Applet

echo ""
echo "Done! Now:"
echo "  1. Right-click the KDE panel"
echo "  2. Choose 'Add Widgets...'"
echo "  3. Search for 'Net Quality'"
echo "  4. Drag it onto the panel"
