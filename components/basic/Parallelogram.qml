import QtQuick

Rectangle {
    id: root
    property real factor: -0.3

    transform: Matrix4x4{
        matrix: Qt.matrix4x4(1, root.factor, 0, 0,
            0,    1, 0, 0,
            0,    0, 1, 0,
            0,    0, 0, 1)
    }
}