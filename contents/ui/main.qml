import QtQuick 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0

Item {
    id: root

    // Shared state — доступно и в compact, и в full representation
    property string pingMs: "..."
    property string packetLoss: "..."
    property bool online: false
    property bool firstRun: true

    function statusColor() {
        if (firstRun) return theme.disabledTextColor
        if (!online) return theme.negativeTextColor
        var ms = parseFloat(pingMs)
        if (isNaN(ms)) return theme.disabledTextColor
        if (ms < 100) return theme.positiveTextColor
        if (ms < 200) return "#f0a500"
        return theme.negativeTextColor
    }

    PlasmaCore.DataSource {
        id: pingSource
        engine: "executable"
        connectedSources: []

        onNewData: {
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

        Layout.minimumWidth: compactRow.implicitWidth + PlasmaCore.Units.smallSpacing * 2
        Layout.minimumHeight: PlasmaCore.Units.iconSizes.medium

        RowLayout {
            id: compactRow
            anchors.centerIn: parent
            spacing: PlasmaCore.Units.smallSpacing / 2

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
                font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize
                font.bold: true
                Behavior on color { ColorAnimation { duration: 600 } }
            }

            // Потери (только если > 0%)
            PlasmaComponents.Label {
                visible: !root.firstRun && parseInt(root.packetLoss) > 0
                text: root.packetLoss
                color: theme.negativeTextColor
                font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize
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
            spacing: PlasmaCore.Units.smallSpacing

            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: root.online ? "\u2705 Online" : "\u274C Offline"
                font.pixelSize: PlasmaCore.Theme.defaultFont.pixelSize * 1.2
            }
            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Ping: " + root.pingMs + " ms"
                color: root.statusColor()
            }
            PlasmaComponents.Label {
                Layout.alignment: Qt.AlignHCenter
                text: "Loss: " + root.packetLoss
                color: parseInt(root.packetLoss) > 0 ? theme.negativeTextColor : theme.textColor
            }
        }
    }
}
