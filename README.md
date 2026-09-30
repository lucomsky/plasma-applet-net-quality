# Net Quality Monitor — KDE Plasma Plasmoid

A minimal KDE Plasma 6 panel widget that shows internet connection quality in real time.

![Net Quality Monitor in action](media/plugin-on-hover-baloon.gif)
![Net Quality Monitor configuration](media/config-screen.png)

## What it shows

- **Ping latency** in milliseconds (avg RTT to 8.8.8.8)
- **Packet loss** percentage (only shown when > 0%)
- **Color-coded status** — changes automatically without any interaction:
  - Green: online, ping < 100 ms
  - Amber: ping 100–200 ms
  - Red: ping > 200 ms or any packet loss

Updates every 5 seconds.

## Requirements

- KDE Plasma 6.0 or later (For Plasma 5, use the `plasma5` tag)
- `ping` utility (standard on all Linux systems)

## Supported distributions

Requires **Plasma 6**.

| Distribution | Version             | Plasma      |
| ------------ | ------------------- | ----------- |
| Ubuntu       | 24.10+              | 6.x         |
| KDE neon     | (Ubuntu 24.04 base) | 6.x         |
| Debian       | 13 (Trixie)         | 6.x         |
| Fedora       | 40+                 | 6.x         |
| Arch Linux   | Rolling             | 6.x         |

## Installation

### Option 1: Package manager (recommended)

Download the latest `.deb` or `.rpm` from the [Releases](https://github.com/lucomsky/plasma-applet-net-quality/releases) page.

**Debian/Ubuntu-based:**
```bash
sudo dpkg -i plasma-applet-net-quality_*_all.deb
```
To uninstall: `sudo dpkg -r plasma-applet-net-quality`

**Fedora/openSUSE/RHEL-based:**
```bash
sudo rpm -i plasma-applet-net-quality-*.noarch.rpm
```
To uninstall: `sudo rpm -e plasma-applet-net-quality`

The widget is installed system-wide and available to all users. After installation, right-click the panel → **Add Widgets** → search **Net Quality** → drag onto panel.

### Option 2: Script (per-user, no root)

```bash
git clone https://github.com/YOUR_USERNAME/plasma-applet-net-quality.git
cd plasma-applet-net-quality
bash install.sh
```

### Option 3: Manual (per-user, no root)

```bash
git clone https://github.com/YOUR_USERNAME/plasma-applet-net-quality.git
mkdir -p ~/.local/share/plasma/plasmoids/
cp -r plasma-applet-net-quality ~/.local/share/plasma/plasmoids/net.quality.monitor
kpackagetool6 --install ~/.local/share/plasma/plasmoids/net.quality.monitor --type Plasma/Applet
```

Then right-click the panel → **Add Widgets** → search **Net Quality** → drag onto panel.

## Uninstall

```bash
kpackagetool6 --remove net.quality.monitor --type Plasma/Applet
rm -rf ~/.local/share/plasma/plasmoids/net.quality.monitor
```

## File structure

```
net.quality.monitor/
  metadata.json        — widget metadata
  contents/ui/
    main.qml           — all UI and logic (~160 lines QML)
```

## License

[GPL-2.0-or-later](LICENSE)
