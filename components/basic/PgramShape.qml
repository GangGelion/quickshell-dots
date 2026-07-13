import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    required property int currentWidth
    required property int currentHeight

    property real angle: 30
    property int horizontalMargin: 10
    
    readonly property int offset: Math.tan(angle * Math.PI / 180)
    default property alias content: sourceContainer.data

    id: root

    width: currentWidth + horizontalMargin

    Shape {
        id: mask
        
        layer.enabled: true
        width: root.currentWidth
        height: root.currentHeight

        anchors.centerIn: parent

        ShapePath {
            id: maskShape

            startX: root.offset
            startY: 0

            PathLine {
                x: mask.implicitWidth
                y: 0
            }

            PathLine {
                x: mask.implicitWidth - root.offset
                y: mask.implicitHeight
            }

            PathLine {
                x: 0
                y: mask.implicitHeight
            }

            PathLine {
                x: root.offset
                y: 0
            }
        }
    }

    Item {
        id: sourceContainer
        anchors.fill: parent
    }

    MultiEffect {
        id: maskEffect
        source: sourceContainer
        maskEnabled: true
        maskSource: mask
    }
}