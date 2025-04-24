import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15

ApplicationWindow {
    id: window
    visible: true
    width: 1280
    height: 720
    title: "Defender Dashboard"

    // Set dark theme
    Material.theme: Material.Dark
    Material.accent: Material.Blue

    color: "#1e1e1e"

    // Main dashboard layout
    ColumnLayout {
        anchors.fill: parent
        spacing: 20

        // Top status bar
        Rectangle {
            Layout.fillWidth: true
            height: 40
            color: "#252525"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 5

                // Time display
                Label {
                    id: timeLabel
                    font.pixelSize: 18
                    color: "white"

                    Timer {
                        interval: 1000
                        running: true
                        repeat: true
                        onTriggered: {
                            var date = new Date();
                            timeLabel.text = date.toLocaleTimeString(Qt.locale(), "hh:mm");
                        }
                    }
                    Component.onCompleted: {
                        var date = new Date();
                        timeLabel.text = date.toLocaleTimeString(Qt.locale(), "hh:mm");
                    }
                }

                Item { Layout.fillWidth: true }

                // Temperature display
                Label {
                    text: dashboardController.temperature.toFixed(1) + "°C"
                    font.pixelSize: 18
                    color: dashboardController.temperature > 100 ? "red" : "white"
                }

                // Warning indicator
                Image {
                    source: "qrc:/images/engine-warning.png"
                    width: 24
                    height: 24
                    visible: dashboardController.engineWarning

                    ColorOverlay {
                        anchors.fill: parent
                        source: parent
                        color: "red"
                    }
                }
            }
        }

        // Main dashboard panel
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true

            Rectangle {
                anchors.centerIn: parent
                width: parent.width * 0.9
                height: parent.height * 0.7
                radius: 10
                color: "#2a2a2a"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20

                    // Speedometer
                    Item {
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.height * 0.6

                        Rectangle {
                            id: speedometerBg
                            width: Math.min(parent.width, parent.height) * 0.8
                            height: width
                            radius: width / 2
                            color: "#1e1e1e"
                            anchors.centerIn: parent

                            // Speed display
                            Column {
                                anchors.centerIn: parent
                                spacing: 5

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: dashboardController.speed
                                    font.pixelSize: speedometerBg.width * 0.25
                                    font.bold: true
                                    color: "white"
                                }

                                Label {
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    text: "km/h"
                                    font.pixelSize: speedometerBg.width * 0.1
                                    color: "#aaaaaa"
                                }
                            }
                        }

                        // RPM indicator
                        ProgressBar {
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter
                            width: parent.width * 0.8
                            height: 20
                            from: 0
                            to: 8000
                            value: dashboardController.rpm

                            background: Rectangle {
                                implicitWidth: 200
                                implicitHeight: 20
                                color: "#3a3a3a"
                                radius: 10
                            }

                            contentItem: Item {
                                Rectangle {
                                    width: dashboardController.rpm / 8000 * parent.width
                                    height: parent.height
                                    radius: 10
                                    color: dashboardController.rpm > 6000 ? "#e53935" :
                                           dashboardController.rpm > 4000 ? "#ffb300" : "#4caf50"
                                }
                            }
                        }
                    }

                    // Car info panel
                    Rectangle {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        color: "#252525"
                        radius: 8

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 10
                            spacing: 20

                            // Fuel gauge
                            Column {
                                Layout.preferredWidth: 100

                                Label {
                                    text: "Fuel"
                                    font.pixelSize: 16
                                    color: "#aaaaaa"
                                }

                                ProgressBar {
                                    width: 80
                                    height: 200
                                    orientation: Qt.Vertical
                                    from: 0
                                    to: 100
                                    value: dashboardController.fuelLevel

                                    background: Rectangle {
                                        color: "#3a3a3a"
                                        radius: 5
                                    }

                                    contentItem: Item {
                                        Rectangle {
                                            width: parent.width
                                            height: dashboardController.fuelLevel / 100 * parent.height
                                            y: parent.height - height
                                            radius: 5
                                            color: dashboardController.fuelLevel < 20 ? "#e53935" : "#4caf50"
                                        }
                                    }
                                }

                                Label {
                                    text: dashboardController.fuelLevel + "%"
                                    font.pixelSize: 18
                                    font.bold: true
                                    color: dashboardController.fuelLevel < 20 ? "#e53935" : "white"
                                }
                            }

                            // Gear indicator
                            Column {
                                Layout.preferredWidth: 100

                                Label {
                                    text: "Gear"
                                    font.pixelSize: 16
                                    color: "#aaaaaa"
                                }

                                Rectangle {
                                    width: 80
                                    height: 80
                                    radius: 40
                                    color: "#1e1e1e"
                                    border.width: 3
                                    border.color: "#4caf50"

                                    Label {
                                        anchors.centerIn: parent
                                        text: dashboardController.currentGear
                                        font.pixelSize: 32
                                        font.bold: true
                                        color: "white"
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Button {
                                        text: "P"
                                        width: 40
                                        height: 40
                                        onClicked: dashboardController.setGear("P")
                                        highlighted: dashboardController.currentGear === "P"
                                    }

                                    Button {
                                        text: "R"
                                        width: 40
                                        height: 40
                                        onClicked: dashboardController.setGear("R")
                                        highlighted: dashboardController.currentGear === "R"
                                    }
                                }

                                Row {
                                    spacing: 10

                                    Button {
                                        text: "N"
                                        width: 40
                                        height: 40
                                        onClicked: dashboardController.setGear("N")
                                        highlighted: dashboardController.currentGear === "N"
                                    }

                                    Button {
                                        text: "D"
                                        width: 40
                                        height: 40
                                        onClicked: dashboardController.setGear("D")
                                        highlighted: dashboardController.currentGear === "D"
                                    }
                                }
                            }

                            // Controls panel
                            Column {
                                Layout.fillWidth: true
                                spacing: 10

                                Label {
                                    text: "Controls"
                                    font.pixelSize: 16
                                    color: "#aaaaaa"
                                }

                                Row {
                                    spacing: 20

                                    // Headlights toggle
                                    Button {
                                        width: 120
                                        height: 60
                                        text: "Headlights"
                                        highlighted: dashboardController.headlightsOn
                                        onClicked: dashboardController.toggleHeadlights()
                                    }

                                    // Left signal
                                    Button {
                                        width: 120
                                        height: 60
                                        text: "Left Signal"
                                        highlighted: dashboardController.turnSignalLeft
                                        onClicked: dashboardController.toggleLeftSignal()
                                    }

                                    // Right signal
                                    Button {
                                        width: 120
                                        height: 60
                                        text: "Right Signal"
                                        highlighted: dashboardController.turnSignalRight
                                        onClicked: dashboardController.toggleRightSignal()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

        // Bottom navigation bar
        Rectangle {
            Layout.fillWidth: true
            height: 80
            color: "#252525"

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 20

                Button {
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    text: "Dashboard"
                    highlighted: true
                }

                Button {
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    text: "CarPlay"
                    onClicked: {
                        // In a real system, this would navigate to the CarPlay app
                        console.log("Navigate to CarPlay")
                    }
                }

                Button {
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    text: "Navigation"
                    onClicked: {
                        // In a real system, this would navigate to the Navigation app
                        console.log("Navigate to Navigation")
                    }
                }

                Button {
                    Layout.preferredWidth: 100
                    Layout.fillHeight: true
                    text: "Settings"
                    onClicked: {
                        // In a real system, this would navigate to the Settings app
                        console.log("Navigate to Settings")
                    }
                }

                Item { Layout.fillWidth: true }
            }
        }
    }
}