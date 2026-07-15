import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

PanelWindow {
    id: root

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "#44000000"

    visible: false

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    GlobalShortcut {
        name: "toggle_overview"

        onPressed: {
            root.visible = !root.visible;
            nameInput.focus = true;
        }
    }

    TextInput {
        id: nameInput
        anchors.centerIn: parent

        focus: true

        onAccepted: {
            focus = false;
            console.log("Got text", text);
        }
    }

    Rectangle {
        id: mail
        width: 800
        height: 500

        anchors.centerIn: parent
        color: "transparent"

        Shape {
            id: baseMail
            anchors.fill: parent

            ShapePath {
                id: baseMailPath
                strokeColor: "transparent"
                fillColor: "#FFEEEEEE"

                startX: 0
                startY: 0

                PathLine {
                    x: mail.width / 2
                    y: 200
                }

                PathLine {
                    x: mail.width
                    y: 0
                }

                PathLine {
                    x: mail.width
                    y: mail.height
                }

                PathLine {
                    x: 0
                    y: mail.height
                }

                PathLine {
                    x: 0
                    y: 0
                }
            }
        }

        Rectangle {
            id: mailCover
            anchors.fill: parent
            color: "transparent"

            Shape {
                anchors.fill: parent
                ShapePath {
                    id: backMailPath
                    strokeColor: "transparent"
                    fillColor: "#FFFFFFFF"

                    startX: 0
                    startY: 0

                    PathLine {
                        x: mail.width / 2
                        y: 200
                    }

                    PathLine {
                        x: mail.width
                        y: 0
                    }

                    PathLine {
                        x: 0
                        y: 0
                    }
                }
            }

            layer.enabled: true
            layer.effect: MultiEffect {
                shadowEnabled: true
                shadowBlur: 5
            }
        }

        
    }
}
