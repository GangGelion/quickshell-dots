import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import QtQuick
import QtQuick.Shapes
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

PanelWindow {
    id: root

    function calculateOffset(height, angle) {
        return Math.tan(angle * Math.PI / 180) * height;
    }

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
        }
    }

    Rectangle {
        id: mail
        width: 800
        height: 60

        y: parent.height * 0.8
        anchors.horizontalCenter: parent.horizontalCenter
        color: "transparent"

        layer.enabled: true
        layer.effect: MultiEffect {
            shadowEnabled: true
            shadowBlur: 0.5
            shadowVerticalOffset: 10
            shadowHorizontalOffset: 10
            shadowScale: 1
        }

        Shape {
            id: baseMail
            anchors.fill: parent

            ShapePath {
                id: baseMailPath
                strokeColor: "transparent"
                fillColor: "#66666666"

                startX: root.calculateOffset(mail.height, 10)
                startY: 0

                PathLine {
                    x: mail.width
                    y: 0
                }

                PathLine {
                    x: mail.width - root.calculateOffset(mail.height, 10)
                    y: mail.height
                }

                PathLine {
                    x: 0
                    y: mail.height
                }

                PathLine {
                    x: baseMailPath.startX
                    y: 0
                }
            }
        }
    }

    Rectangle {
        property int borderLength: nameInput.implicitWidth + 50
        id: strokeRectangle
        anchors.fill: mail
        color: "transparent"

        layer.enabled: true

        TextInput {
            id: nameInput
            focus: true
            x: 24
            anchors.verticalCenter: parent.verticalCenter
            
            font.pointSize: 14
            font.family: "JetBrains Mono"
            color: "white"

        }

        Shape {
            id: stroke
            anchors.fill: parent

            ShapePath {
                strokeWidth: 2
                strokeColor: "#11FFFFFF"
                fillColor: "transparent"

                startX: root.calculateOffset(mail.height, 10)
                startY: 1

                PathLine {
                    x: mail.width
                    y: 1
                }

                PathLine {
                    x: mail.width - root.calculateOffset(mail.height, 10)
                    y: mail.height
                }

                PathLine {
                    x: 0
                    y: mail.height
                }

                PathLine {
                    x: baseMailPath.startX
                    y: 1
                }
            }

            ShapePath {
                id: border1
                property int length: Math.min(strokeRectangle.borderLength, root.calculateOffset(mail.height, 10) * -1 + mail.width)
                strokeWidth: 2
                strokeColor: "#55FFFFFF"
                fillColor: "transparent"

                startX: length + root.calculateOffset(mail.height, 10)
                startY: 1

                PathLine {
                    x: root.calculateOffset(mail.height, 10)
                    y: 1
                }

                PathLine {
                    x: 0
                    y: mail.height - 1
                }

                PathLine {
                    x: border1.length
                    y: mail.height - 1
                }

                Behavior on length {
                    SpringAnimation {
                        spring: 7
                        damping: 0.5
                        epsilon: 1
                    }
                }
            }

            ShapePath {
                id: border2
                property int length: Math.min(mail.width - root.calculateOffset(mail.height, 10), strokeRectangle.borderLength + (strokeRectangle.width - strokeRectangle.borderLength)*0.2)
                strokeWidth: 1
                strokeColor: "#33FFFFFF"
                fillColor: "transparent"

                startX: length + root.calculateOffset(mail.height, 10)
                startY: 1

                PathLine {
                    x: root.calculateOffset(mail.height, 10)
                    y: 1
                }

                PathLine {
                    x: 0
                    y: mail.height
                }

                PathLine {
                    x: border2.length
                    y: mail.height
                }

                Behavior on length {
                    SpringAnimation {
                        spring: 5
                        damping: 0.5
                        epsilon: 1
                    }
                }
            }

            ShapePath {
                id: border3
                property int length: Math.min(mail.width - root.calculateOffset(mail.height, 10), strokeRectangle.borderLength + (strokeRectangle.width - strokeRectangle.borderLength)*0.4)
                strokeWidth: 1
                strokeColor: "#33FFFFFF"
                fillColor: "transparent"

                startX: length + root.calculateOffset(mail.height, 10)
                startY: 1

                PathLine {
                    x: root.calculateOffset(mail.height, 10)
                    y: 1
                }

                PathLine {
                    x: 0
                    y: mail.height
                }

                PathLine {
                    x: border3.length
                    y: mail.height
                }

                Behavior on length {
                    SpringAnimation {
                        spring: 3
                        damping: 0.5
                        epsilon: 1
                    }
                }
            }
        }
    }
}
