import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

import "../singletons"
import "../components"

Item {
    id: barClock

    property real margin: 10
    property PanelWindow window
    implicitWidth: contentLayout.implicitWidth + margin * 2
    implicitHeight: contentLayout.implicitHeight + margin

    RowLayout {
        id: contentLayout
        spacing: 5
        anchors.centerIn: parent

        Text {
            text: `${ClockProvider.date}  ${ClockProvider.month}  • `
            font.pointSize: 12
        }

        RollingText {
            currentValue: ClockProvider.hours
        }

        Text {
            text: ":"
        }

        RollingText {
            currentValue: ClockProvider.minutes
        }
    }

    Rectangle {
        anchors.fill: parent
        color: mouseArea.containsMouse ? "#0E001020" : "#00000000"
        z: -1
        radius: 5
        Behavior on color {
            ColorAnimation {
                duration: 100
            }
        }
    }

    MouseArea {
        id: mouseArea
        property int leftOffset: 0
        anchors.fill: parent
        hoverEnabled: true

        onHoveredChanged: {
            leftOffset = parent.mapToGlobal(0, 0).x + parent.implicitWidth / 2;
            if (!containsMouse) {
                tooltipPopup.active = false;
                popupTimer.stop();
            } else {
                popupTimer.restart();
            }
        }
    }

    Timer {
        id: popupTimer
        interval: 499
        running: false
        onTriggered: {
            tooltipPopup.active = true;
        }
    }

    PopupWindow {
        id: tooltipPopup
        property bool active: false
        property int leftOffset: 0
        property int margin: 8
        property int totalWidth: tooltipText.width + margin * 2
        property int totalHeight: tooltipText.height + margin * 2

        anchor.window: barClock.window
        anchor.rect.x: mouseArea.leftOffset - totalWidth / 2
        anchor.rect.y: parentWindow.height + 5

        implicitHeight: totalHeight
        implicitWidth: totalWidth

        color: "#00000000"
        surfaceFormat.opaque: false
        visible: tooltipContainer.opacity > 0

        Item {
            id: tooltipContainer
            anchors.fill: parent
            opacity: tooltipPopup.active ? 1.0 : 0.0

            Rectangle {
                anchors.fill: parent
                radius: 8
            }

            Text {
                id: tooltipText
                anchors.centerIn: parent
                text: "This is the date you dumbass"

                font.pointSize: 10
            }

            Behavior on opacity {
                NumberAnimation {
                    duration: 100
                }
            }
        }
    }
}
