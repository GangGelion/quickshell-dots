import Quickshell
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects

import "../singletons"

Item {
    width: contentLayout.width + 20

    RowLayout {
        id: contentLayout
        anchors.centerIn: parent
        spacing: 10
        
        Rectangle {
            id: cpuPill
            width: 150
            height: 12
            radius: 8
            color: "#FFE0E0E0"

            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    left: parent.left
                    margins: 3
                }
                color: "#66102030"
                width: (parent.width - 6) * Math.max(0, Math.min(ResourceProvider.cpuTemperature - 30, 90)/60)
                radius: 100
            }

            /* Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    margins: 2
                }
                
                color: "#55FF3333"
                width: (parent.width - 6) * 0.1
                topRightRadius: 20
                bottomRightRadius: 20
            }

            Rectangle {
                anchors {
                    top: parent.top
                    bottom: parent.bottom
                    right: parent.right
                    margins: 4
                }
                
                color: "#FFE0E0E0"
                width: (parent.width - 6) * 0.1
                topRightRadius: 20
                bottomRightRadius: 20
            } */
        }

        Text {
            text: `${ResourceProvider.cpuTemperature}°`
            font.pointSize: 11
        }
    }
}