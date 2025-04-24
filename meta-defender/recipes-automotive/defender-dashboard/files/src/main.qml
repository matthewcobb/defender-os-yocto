import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: "Defender Dashboard"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e1e"

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 20

            Text {
                text: "Speed"
                color: "white"
                font.pixelSize: 24
                Layout.alignment: Qt.AlignHCenter
            }

            Text {
                text: "0 mph"
                color: "white"
                font.pixelSize: 72
                Layout.alignment: Qt.AlignHCenter
            }

            ProgressBar {
                value: 0.0
                Layout.preferredWidth: 400
            }

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 40

                Column {
                    Label {
                        text: "RPM"
                        color: "white"
                    }
                    Label {
                        text: "0"
                        color: "white"
                        font.pixelSize: 32
                    }
                }

                Column {
                    Label {
                        text: "Temperature"
                        color: "white"
                    }
                    Label {
                        text: "75°F"
                        color: "white"
                        font.pixelSize: 32
                    }
                }
            }
        }
    }
}