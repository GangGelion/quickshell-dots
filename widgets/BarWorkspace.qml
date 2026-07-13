import Quickshell
import QtQuick.Layouts
import QtQuick

import "../singletons"
import "../singletons/utils"
import "../components/basic"

Item {
    id: barWorkspace

    Layout.fillHeight: true
    implicitWidth: contentLayout.implicitWidth + 20

    Rectangle {
        anchors {
            top: parent.top
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        // color: "#30203040"
        color: "transparent"
        anchors {
            topMargin: 2
            bottomMargin: 2
        }
        width: contentLayout.width
        radius: 12
        RowLayout {
            id: contentLayout
            property real slidingIndex: WorkspaceProvider.currentWorkspace - 1
            property real springIndex: slidingIndex
            spacing: 3

            height: parent.height

            anchors {
                horizontalCenter: parent.horizontalCenter
                verticalCenter: parent.verticalCenter
            }

            transform: Translate {
                x: (contentLayout.slidingIndex - contentLayout.springIndex) / 2
            }

            Repeater {
                id: repeaterRoot
                model: 10

                Item {
                    required property int index
                    property real sizeMultiplier: {
                        const thing = 1 - Math.min(Math.abs(index - parent.slidingIndex), 1);
                        return thing;
                    }

                    Layout.fillHeight: true
                    implicitWidth: height * 0.4

                    Parallelogram {
                        property color startColor: "#FFA1A2A3"
                        property color endColor: "#FF313233"
                        anchors {
                            fill: parent
                            topMargin: 8 - 3 * parent.sizeMultiplier
                            bottomMargin: 8 - 3 * parent.sizeMultiplier
                            leftMargin: 1 * (parent.sizeMultiplier)
                            rightMargin: -1 * (parent.sizeMultiplier)
                        }

                        color: ColorUtils.interpolateColor(startColor, endColor, parent.sizeMultiplier)
                    }

                    MouseArea {
                        id: workspaceClickArea
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: {
                            WorkspaceProvider.switchWorkspace(index + 1);
                        }
                    }


                    /* Behavior on sizeMultiplier {
                        NumberAnimation {
                            duration: 100
                        }
                    } */
                }

                /* Item {
                    required property int index
                    property bool selected: index == WorkspaceProvider.currentWorkspace - 1

                    Layout.fillHeight: true
                    implicitWidth: height * 0.3 + (selected ? 8 : 0)

                    MouseArea {
                        id: workspaceClickArea
                        anchors.fill: parent
                        onClicked: {
                            WorkspaceProvider.switchWorkspace(index + 1)
                        }
                    }

                    Text {
                        anchors.centerIn: parent
                        text: (index + 1) % 10

                        color: selected ? "#FF000000": "#00000000"
                        font.pointSize: 12

                        Behavior on color {
                            ColorAnimation {
                                duration: 120
                            }
                        }
                    }

                    Rectangle {
                        anchors.centerIn: parent
                        width: selected ? 24 : 20
                        height: selected ? 24 : 5
                        radius: 6

                        color: selected ? "#00304050" : "#FF304050"

                        Behavior on width {
                            NumberAnimation {
                                duration: 150
                                easing: Easing.OutBack
                            }
                        }

                        Behavior on height {
                            NumberAnimation {
                                duration: 250
                                easing: Easing.OutQuad
                            }
                        }

                        Behavior on color {
                            ColorAnimation {
                                duration: 150
                            }
                        }
                    }

                    Behavior on implicitWidth {
                        NumberAnimation {
                            duration: 60
                            easing: Easing.Linear
                        }
                    }
                }*/
            }

            Behavior on slidingIndex {
                NumberAnimation {
                    duration: 100
                }
            }

            Behavior on springIndex {
                SpringAnimation {
                    spring: 5.0
                    damping: 0.3 // Extra bouncy
                    epsilon: 1
                }
            }
        }
    }
}
