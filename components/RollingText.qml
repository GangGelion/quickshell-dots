import QtQuick
import Quickshell

Item {
    id: rollingText
    property int currentValue: 0
    property int oldValue: 0
    property real pointHeight: 12

    clip: true

    function getPixelHeight() {
        return oldText.implicitHeight;
    }

    onCurrentValueChanged: {
        slideAnimation.restart();
    }

    implicitHeight: getPixelHeight()
    implicitWidth: oldText.implicitWidth

    Text {
        id: oldText
        text: parent.oldValue.toString().padStart(2, '0')
        verticalAlignment: Text.AlignTop
        font.pointSize: parent.pointHeight
    }

    Text {
        id: newText
        text: parent.currentValue.toString().padStart(2, '0')
        verticalAlignment: Text.AlignTop
        font.pointSize: parent.pointHeight
    }

    ParallelAnimation {
        id: slideAnimation

        NumberAnimation {
            target: oldText
            properties: "y"
            from: 0
            to: rollingText.height
            duration: 300
            easing.type: Easing.InOutSine
        }

        NumberAnimation {
            target: newText
            properties: "y"
            from: -rollingText.height
            to: 0
            duration: 300
            easing.type: Easing.InOutSine
        }

        onFinished: {
            rollingText.oldValue = rollingText.currentValue;
        }
    }
}
