import QtQuick
import QtQuick.Layouts
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.components as PlasmaComponents
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support
import org.kde.kirigami as Kirigami

Item {
    id: root

    // Shared state — доступно и в compact, и в full representation
    property string pingMs: "..."
    property string packetLoss: "..."
    property bool online: false
    property bool firstRun: true

    function statusColor() {
        if (firstRun) return Kirigami.Theme.disabledTextColor
        if (!online) return Kirigami.Theme.negativeTextColor
        var ms = parseFloat(pingMs)
        if (isNaN(ms)) return Kirigami.Theme.disabledTextColor
        var amber = plasmoid.configuration.amberThreshold || 100
        var red   = plasmoid.configuration.redThreshold   || 200
        if (ms < amber) return Kirigami.Theme.positiveTextColor
        if (ms < red)   return "#f0a500"
        return Kirigami.Theme.negativeTextColor
    }

    Plasma5Support.DataSource {
        id: pingSource
        engine: "executable"
        connectedSources: []

        onNewData: function(sourceName, data) {
            var stdout = data["stdout"] || ""

            var lossMatch = stdout.match(/(\d+)% packet loss/)
            if (lossMatch) {
                var loss = parseInt(lossMatch[1])
                root.packetLoss = loss + "%"
                root.online = (loss < 100)
            } else {
                root.online = false
                root.packetLoss = "100%"
            }

            var rttMatch = stdout.match(/rtt[^=]+=\s*[\d.]+\/([\d.]+)\//)
            if (rttMatch) {
                root.pingMs = Math.round(parseFloat(rttMatch[1])).toString()
            } else {
                root.pingMs = root.online ? "?" : "\u2014"
            }

            root.firstRun = false
            disconnectSource(sourceName)
        }

        function run() {
            var host = plasmoid.configuration.pingHost || "8.8.8.8"
            connectSource("ping -c 3 -W 1 " + host)
        }
    }

    Timer {
        id: refreshTimer
        interval: (plasmoid.configuration.pingInterval || 5) * 1000
        running: true
        repeat: true
        onTriggered: pingSource.run()
    }

    // Перезапустить таймер при изменении интервала в настройках
    Connections {
        target: plasmoid.configuration
        function onPingIntervalChanged() {
            refreshTimer.restart()
        }
    }

    Component.onCompleted: pingSource.run()

    // Compact representation — то что видно прямо на панели
    Plasmoid.compactRepresentation: Item {
        id: compact

        Layout.minimumWidth: compactRow.implicitWidth + Kirigami.Units.smallSpacing * 2
        Layout.minimumHeight: Kirigami.Units.iconSizes.medium

        RowLayout {
            id: compactRow
            anchors.centerIn: parent
            spacing: Kirigami.Units.smallSpacing / 2

            // Цветная точка-статус
            Rectangle {
                width: 8
                height: 8
                radius: 4
                color: root.statusColor()
                opacity: root.firstRun ? 0.3 : 1.0
                Layout.alignment: Qt.AlignVCenter
                Behavior on color { ColorAnimation { duration: 600 } }
            }

            // Пинг
            PlasmaComponents.Label {
                text: root.firstRun ? "..." : (root.pingMs + "ms")
                color: root.statusColor()
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
                font.bold: true
                Behavior on color { ColorAnimation { duration: 600 } }
            }

            // Потери (только если > 0%)
            PlasmaComponents.Label {
                visible: !root.firstRun && parseInt(root.packetLoss) > 0
                text: root.packetLoss
                color: Kirigami.Theme.negativeTextColor
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize
                font.bold: true
            }
        }

        PlasmaCore.ToolTipArea {
            anchors.fill: parent
            mainText: "Net Quality Monitor"
            subText: root.online
                ? "Ping: " + root.pingMs + " ms  |  Loss: " + root.packetLoss + "  |  Host: " + (plasmoid.configuration.pingHost || "8.8.8.8")
                : "Offline \u2014 no response from " + (plasmoid.configuration.pingHost || "8.8.8.8")
        }
    }

    // Full representation — при клике на виджет
    Plasmoid.fullRepresentation: Item {
        width: 200
        height: 80

        ColumnLayout {
            anchors.centerIn: parent
            spacing: Kirigami.Units.smallSpacing

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.online ? "\u2705 Online" : "\u274C Offline"
                font.pixelSize: Kirigami.Theme.defaultFont.pixelSize * 1.2
            }
            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Ping: " + root.pingMs + " ms"
                color: root.statusColor()
            }
            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Loss: " + root.packetLoss
                color: parseInt(root.packetLoss) > 0 ? Kirigami.Theme.negativeTextColor : Kirigami.Theme.textColor
            }
        }
    }
}
