import QtQuick
import QtQuick.Shapes
import QtQuick.Effects

Item {
    id: root
    required property int currentWidth
    required property int currentHeight

    property real angle: 10
    property int margins: 0


    function calculateOffset(height) {
        return Math.tan(angle * Math.PI / 180) * height;
    }

    readonly property int offset: calculateOffset(currentHeight)
    default property alias content: sourceContainer.data

    implicitWidth: currentWidth + margins
    implicitHeight: currentHeight + margins

    Shape {
        id: mask

        implicitWidth: root.currentWidth
        implicitHeight: root.currentHeight
        layer.enabled: true

        anchors.centerIn: parent

        ShapePath {
            id: maskShape

            fillColor: "black"
            strokeWidth: 0

            startX: root.offset
            startY: 0

            PathLine {
                x: root.currentWidth
                y: 0
            }

            PathLine {
                x: root.currentWidth - root.offset
                y: root.currentHeight
            }

            PathLine {
                x: 0
                y: root.currentHeight
            }

            PathLine {
                x: root.offset
                y: 0
            }
        }

        visible: false
    }

    /* Rectangle {
        color: "#AA000000"
        anchors.fill: parent
    } */

    Shape {
        id: maskBorder
        property int margins: 0
        property int borderOffset: 0

        width: root.currentWidth + margins
        height: root.currentHeight + margins
        layer.enabled: true

        preferredRendererType: Shape.GeometryRenderer

        anchors.centerIn: root
        z: 2

        ShapePath {
            id: maskBorderShape

            fillColor: "transparent"
            strokeWidth: 1

            startX: root.offset + maskBorder.margins / 2 - maskBorder.borderOffset
            startY: 0 + maskBorder.margins / 2 - maskBorder.borderOffset

            PathLine {
                x: mask.width + maskBorder.margins / 2 + maskBorder.borderOffset
                y: 0 + maskBorder.margins / 2 - maskBorder.borderOffset
            }

            PathLine {
                x: mask.width - root.offset + maskBorder.margins / 2 + maskBorder.borderOffset
                y: mask.height + maskBorder.margins / 2 + maskBorder.borderOffset
            }

            PathLine {
                x: 0 + maskBorder.margins / 2 - maskBorder.borderOffset
                y: mask.height + maskBorder.margins / 2 + maskBorder.borderOffset
            }

            PathLine {
                x: maskBorderShape.startX
                y: maskBorderShape.startY
            }
        }
    }

    Item {
        id: sourceContainer
        anchors.fill: mask
        visible: false
    }


    MultiEffect {
        id: maskEffect
        anchors.centerIn: parent
        implicitWidth: root.currentWidth
        implicitHeight: root.currentHeight
        source: sourceContainer

        maskSource: mask
        maskEnabled: true
    }
}
