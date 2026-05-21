# Net Quality Monitor — KDE Plasma Plasmoid

A minimal KDE Plasma 5 panel widget that shows internet connection quality in real time.

## What it shows

- **Ping latency** in milliseconds (avg RTT to 8.8.8.8)
- **Packet loss** percentage (only shown when > 0%)
- **Color-coded status** — changes automatically without any interaction:
  - Green: online, ping < 100 ms
  - Amber: ping 100–200 ms
  - Red: ping > 200 ms or any packet loss

Updates every 5 seconds.

## Requirements

- KDE Plasma 5.x
- `ping` utility (standard on all Linux systems)

## Installation

### Option 1: Script

```bash
git clone https://github.com/YOUR_USERNAME/plasma-applet-net-quality.git
cd plasma-applet-net-quality
bash install.sh
```

### Option 2: Manual

```bash
git clone https://github.com/YOUR_USERNAME/plasma-applet-net-quality.git
mkdir -p ~/.local/share/plasma/plasmoids/
cp -r plasma-applet-net-quality ~/.local/share/plasma/plasmoids/net.quality.monitor
kpackagetool5 --install ~/.local/share/plasma/plasmoids/net.quality.monitor --type Plasma/Applet
```

Then right-click the panel → **Add Widgets** → search **Net Quality** → drag onto panel.

## Uninstall

```bash
kpackagetool5 --remove net.quality.monitor --type Plasma/Applet
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

GPL-2.0-or-later
