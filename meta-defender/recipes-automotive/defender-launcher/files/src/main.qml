import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: "Defender Launcher"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e1e"

        GridLayout {
            anchors.centerIn: parent
            columns: 2
            columnSpacing: 20
            rowSpacing: 20

            Button {
                text: "Dashboard"
                Layout.preferredWidth: 200
                Layout.preferredHeight: 120
                onClicked: console.log("Launch Dashboard")
            }

            Button {
                text: "CarPlay"
                Layout.preferredWidth: 200
                Layout.preferredHeight: 120
                onClicked: console.log("Launch CarPlay")
            }

            Button {
                text: "Settings"
                Layout.preferredWidth: 200
                Layout.preferredHeight: 120
                onClicked: console.log("Launch Settings")
            }

            Button {
                text: "Exit"
                Layout.preferredWidth: 200
                Layout.preferredHeight: 120
                onClicked: Qt.quit()
            }
        }
    }
}