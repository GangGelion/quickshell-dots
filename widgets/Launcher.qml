import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects
import Qt5Compat.GraphicalEffects

import "../singletons"

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
        anchors {
            bottom: mail.top
            left: mail.left
            right: mail.right
        }
        height: queryLayout.implicitHeight + 50
        color: "transparent"

        ColumnLayout {
            id: queryLayout
            anchors {
                centerIn: parent
            }
            width: parent.width - 30

            Repeater {
                model: ApplicationProvider.matchingApplications

                delegate: Rectangle {
                    id: searchResult
                    property bool selected: {
                        if (!ApplicationProvider.currentSelected) {
                            return false
                        }
                        return ApplicationProvider.currentSelected.id == modelData.id
                    }
                    Layout.fillWidth: true
                    anchors.margins: 10
                    implicitHeight: titleText.implicitHeight + 20

                    color: "transparent"

                    Image {
                        id: appIcon
                        anchors.verticalCenter: parent.verticalCenter
                        x: 20
                        width: parent.implicitHeight - 10
                        height: width
                        source: Quickshell.iconPath(modelData.icon)
                    }

                    Text {
                        id: titleText
                        anchors.left: appIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 24
                        text: modelData.name
                        font.pointSize: 20
                        color: "white"
                        z: 2
                    }

                    Text {
                        id: titleOutline
                        anchors.left: appIcon.right
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.leftMargin: 24

                        font.pointSize: 20
                        color: "black"
                        opacity: 0.5

                        text: modelData.name
                        
                        transform: [
                            Translate {
                                x: 2
                                y: 2
                            }
                        ]
                        z: 1
                    }

                    // hope no one notices its off centered
                    Rectangle {
                        anchors.fill: parent
                        color: searchResult.selected ? "#AAFFFFFF" : "#55FFFFFF"
                        z: -1
                        
                        transform: Matrix4x4 {
                            matrix: {
                                // Calculate skew multiplier: tan(degrees * pi / 180)
                                let skewX = Math.tan(-10 * Math.PI / 180);
                                let skewY = Math.tan(0 * Math.PI / 180);

                                // Matrix structure layout:
                                // m11  m12  m13  m14 -> [X scale,  X skew,   0, Translate X]
                                // m21  m22  m23  m24 -> [Y skew,   Y scale,  0, Translate Y]
                                return Qt.matrix4x4(1, skewX, 0, 0, skewY, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
                            }
                        }
                    }

                    opacity: selected ? 1 : 0.7
                }
            }
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
        id: strokeRectangle
        property int borderLength: nameInput.implicitWidth + 50
        anchors.fill: mail
        color: "transparent"

        layer.enabled: true

        TextInput {
            id: nameInput
            focus: true
            x: 24
            anchors.verticalCenter: parent.verticalCenter

            text: ""
            font.pointSize: 14
            font.family: "JetBrains Mono"
            color: "white"

            onTextChanged: {
                ApplicationProvider.searchTerm = text;
            }
            
            onAccepted: {
                ApplicationProvider.currentSelected.execute()
                root.visible = false
                text = ""
            }

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
                property int length: Math.min(mail.width - root.calculateOffset(mail.height, 10), strokeRectangle.borderLength + (strokeRectangle.width - strokeRectangle.borderLength) * 0.2)
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
                property int length: Math.min(mail.width - root.calculateOffset(mail.height, 10), strokeRectangle.borderLength + (strokeRectangle.width - strokeRectangle.borderLength) * 0.4)
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
