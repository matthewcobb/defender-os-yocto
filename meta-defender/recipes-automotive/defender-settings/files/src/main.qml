import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

ApplicationWindow {
    visible: true
    width: 1024
    height: 600
    title: "Defender Settings"

    Rectangle {
        anchors.fill: parent
        color: "#1e1e1e"

        ScrollView {
            anchors.fill: parent
            anchors.margins: 20

            ColumnLayout {
                width: parent.width
                spacing: 20

                Label {
                    text: "System Settings"
                    color: "white"
                    font.pixelSize: 32
                    Layout.alignment: Qt.AlignHCenter
                    Layout.bottomMargin: 20
                }

                GroupBox {
                    title: "Display"
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent

                        RowLayout {
                            Label {
                                text: "Brightness"
                                color: "white"
                            }
                            Slider {
                                Layout.fillWidth: true
                                value: 0.8
                            }
                        }

                        RowLayout {
                            Label {
                                text: "Night Mode"
                                color: "white"
                            }
                            Switch {
                                checked: true
                            }
                        }
                    }
                }

                GroupBox {
                    title: "Network"
                    Layout.fillWidth: true

                    ColumnLayout {
                        anchors.fill: parent

                        RowLayout {
                            Label {
                                text: "WiFi"
                                color: "white"
                            }
                            Switch {
                                checked: true
                            }
                        }

                        RowLayout {
                            Label {
                                text: "Bluetooth"
                                color: "white"
                            }
                            Switch {
                                checked: true
                            }
                        }
                    }
                }

                Button {
                    text: "Save Settings"
                    Layout.alignment: Qt.AlignHCenter
                    Layout.topMargin: 20
                }
            }
        }
    }
}