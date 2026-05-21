#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(grep -oP '(?<="Version": ")[^"]+' "$SCRIPT_DIR/metadata.json")
PKG_NAME="plasma-applet-net-quality"
OUT_FILE="${SCRIPT_DIR}/${PKG_NAME}_${VERSION}-1_all.deb"

echo "Building $PKG_NAME version $VERSION..."

STAGING=$(mktemp -d)
trap 'rm -rf "$STAGING"' EXIT

PLASMOID_DEST="$STAGING/usr/share/plasma/plasmoids/net.quality.monitor"
mkdir -p "$PLASMOID_DEST/contents/config"
mkdir -p "$PLASMOID_DEST/contents/ui"

cp "$SCRIPT_DIR/contents/config/"* "$PLASMOID_DEST/contents/config/"
cp "$SCRIPT_DIR/contents/ui/"*     "$PLASMOID_DEST/contents/ui/"
cp "$SCRIPT_DIR/metadata.json"     "$PLASMOID_DEST/"

mkdir -p "$STAGING/DEBIAN"
cat > "$STAGING/DEBIAN/control" << CTRL
Package: $PKG_NAME
Version: ${VERSION}-1
Architecture: all
Maintainer: YOUR NAME <your@email.com>
Depends: plasma-workspace, iputils-ping
Section: kde
Priority: optional
Homepage: https://github.com/YOUR_USERNAME/plasma-applet-net-quality
Description: KDE Plasma panel widget for internet connection quality
 Shows ping latency, packet loss, and online/offline status
 directly on the KDE Plasma panel. Color-coded indicator
 (green/amber/red) updates automatically every few seconds.
 Configurable ping host and update interval.
CTRL

fakeroot dpkg-deb --build "$STAGING" "$OUT_FILE"
echo "Done: $OUT_FILE"
echo "Install with: sudo dpkg -i $OUT_FILE"
