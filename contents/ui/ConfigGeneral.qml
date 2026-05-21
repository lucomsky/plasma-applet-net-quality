import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.kirigami 2.5 as Kirigami

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
