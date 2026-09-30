import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import org.kde.plasma.components as PlasmaComponents
import org.kde.kirigami as Kirigami

Kirigami.FormLayout {
    id: configPage

    property alias cfg_pingHost: hostField.text
    property alias cfg_pingInterval: intervalSpinBox.value
    property alias cfg_amberThreshold: amberSpinBox.value
    property alias cfg_redThreshold: redSpinBox.value

    TextField {
        id: hostField
        Kirigami.FormData.label: "Ping host:"
        placeholderText: "e.g. 8.8.8.8 or google.com"
    }

    SpinBox {
        id: intervalSpinBox
        Kirigami.FormData.label: "Interval (seconds):"
        from: 1
        to: 300
        stepSize: 1
    }

    Kirigami.Separator {
        Kirigami.FormData.isSection: true
        Kirigami.FormData.label: "Color thresholds"
    }

    SpinBox {
        id: amberSpinBox
        Kirigami.FormData.label: "Amber above (ms):"
        from: 1
        to: 9999
        stepSize: 10
    }

    SpinBox {
        id: redSpinBox
        Kirigami.FormData.label: "Red above (ms):"
        from: 1
        to: 9999
        stepSize: 10
    }
}
