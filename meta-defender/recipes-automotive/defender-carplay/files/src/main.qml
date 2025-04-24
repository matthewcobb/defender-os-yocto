import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: "Defender CarPlay"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e1e"

        Text {
            anchors.centerIn: parent
            text: "Defender CarPlay Integration"
            color: "white"
            font.pixelSize: 32
        }
    }
}