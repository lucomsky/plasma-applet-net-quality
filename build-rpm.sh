#!/usr/bin/env bash
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
VERSION=$(grep -oP '(?<="Version": ")[^"]+' "$SCRIPT_DIR/metadata.json")
PKG_NAME="plasma-applet-net-quality"
OUT_FILE="${SCRIPT_DIR}/${PKG_NAME}-${VERSION}-1.noarch.rpm"

echo "Building $PKG_NAME version $VERSION..."

RPMBUILD_DIR=$(mktemp -d)
trap "rm -rf $RPMBUILD_DIR" EXIT

mkdir -p "$RPMBUILD_DIR/BUILD"
mkdir -p "$RPMBUILD_DIR/RPMS"
mkdir -p "$RPMBUILD_DIR/SOURCES"
mkdir -p "$RPMBUILD_DIR/SPECS"
mkdir -p "$RPMBUILD_DIR/SRPMS"
mkdir -p "$RPMBUILD_DIR/BUILDROOT"

SPEC_FILE="$RPMBUILD_DIR/SPECS/$PKG_NAME.spec"

cat > "$SPEC_FILE" << EOF
Name:           $PKG_NAME
Version:        $VERSION
Release:        1%{?dist}
Summary:        KDE Plasma panel widget for internet connection quality
BuildArch:      noarch
License:        GPLv2+
URL:            https://github.com/lucomsky/plasma-applet-net-quality
Requires:       plasma-workspace, iputils

%description
Shows ping latency, packet loss, and online/offline status directly on the KDE Plasma panel.
Color-coded indicator (green/amber/red) updates automatically every few seconds.
Configurable ping host and update interval.

%install
mkdir -p %{buildroot}/usr/share/plasma/plasmoids/net.quality.monitor/contents/config
mkdir -p %{buildroot}/usr/share/plasma/plasmoids/net.quality.monitor/contents/ui
cp "$SCRIPT_DIR/contents/config/"* %{buildroot}/usr/share/plasma/plasmoids/net.quality.monitor/contents/config/
cp "$SCRIPT_DIR/contents/ui/"*     %{buildroot}/usr/share/plasma/plasmoids/net.quality.monitor/contents/ui/
cp "$SCRIPT_DIR/metadata.json"     %{buildroot}/usr/share/plasma/plasmoids/net.quality.monitor/

%files
/usr/share/plasma/plasmoids/net.quality.monitor/
EOF

rpmbuild --define "_topdir $RPMBUILD_DIR" -bb "$SPEC_FILE"

find "$RPMBUILD_DIR/RPMS" -name "*.rpm" -exec cp {} "$OUT_FILE" \;
chmod +x "$OUT_FILE" 2>/dev/null || true
echo "Done: $OUT_FILE"
echo "Install with: sudo rpm -i $OUT_FILE"