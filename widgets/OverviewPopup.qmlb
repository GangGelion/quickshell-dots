// pragma ComponentBehavior: Bound

import Quickshell
import Quickshell.Wayland
import Quickshell.Hyprland

import QtQuick
import QtQuick.Layouts
import QtQuick.Effects
import QtQuick.Shapes

import "../components/basic"

PanelWindow {
    id: overviewWindow
    GlobalShortcut {
        name: "toggle_overview"
        onPressed: {
            overviewWindow.active = !overviewWindow.active;
        }
    }

    property bool active: false
    property real visibleProgress: active ? 1 : 0

    property int elementWidth: 300
    property int elementHeight: 700

    property int selectedWidthExpansion: 500
    property int workspaceDividerWidth: 100

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    // TODO: Separate this
    readonly property var sortedToplevels: {
        let topLevels = Hyprland.toplevels.values;
        let jsToplevels = Array.from({
            length: topLevels.length
        }, (_, i) => topLevels[i]);
        let sorted = jsToplevels.sort((a, b) => {
            const aId = a.workspace ? a.workspace.id : 0;
            const bId = b.workspace ? b.workspace.id : 0;
            return aId - bId;
        });
        if (true) {
            return jsToplevels.map(a => a);
        }
        // Convert the ObjectModel to a standard JS array
        let list = Array.from({
            length: ToplevelManagertoplevels.values.length
        }, (_, i) => ToplevelManager.toplevels.values[i]);

        // Sort the array using standard JS .sort()
        return list.sort((a, b) => {
            // Get the Hyprland properties attached to the Wayland toplevels
            let hyprA = HyprlandToplevel.attached(a);
            let hyprB = HyprlandToplevel.attached(b);

            let wsA = hyprA && hyprA.workspace ? hyprA.workspace.id : 999;
            let wsB = hyprB && hyprB.workspace ? hyprB.workspace.id : 999;

            // Sort primary by workspace ID
            if (wsA !== wsB) {
                return wsA - wsB;
            }

            // Optional secondary sort: Sort by window title alphabetically if on the same workspace
            return a.title.localeCompare(b.title);
        });
    }

    // grab focus

    WlrLayershell.keyboardFocus: WlrKeyboardFocus.OnDemand

    // anchor.window: mainBarWindow
    // anchor.rect.x: 0
    // anchor.rect.y: 0
    // implicitHeight: screen.height - 5
    // implicitWidth: Math.max(1, screen.width - 10)

    HyprlandFocusGrab {
        id: grabber
        windows: [overviewWindow]
        active: overviewWindow.active // Automatically turn grab on/off with visibility

        // Optional: Close the panel if the user clicks completely outside of it
        onCleared: {
            overviewWindow.active = false;
        }
    }

    Rectangle { // Background
        id: background
        anchors {
            verticalCenter: parent.verticalCenter
        }
        width: parent.width
        height: parent.height

        color: "#AA000000"
        opacity: overviewWindow.visibleProgress
        z: -10
        // visible: false

        FocusScope {
            anchors.fill: parent
            focus: true

            Keys.onPressed: event => {
                if (event.key == Qt.Key_Escape || event.key == Qt.Key_Return) {
                    overviewWindow.active = false;
                } else if (event.key == Qt.Key_Right) {
                    const nextIndex = contentLayout.currentIndex + 1;
                    if (nextIndex < overviewWindow.sortedToplevels.length) {
                        overviewWindow.sortedToplevels[nextIndex].wayland.activate();
                    }
                } else if (event.key == Qt.Key_Left) {
                    const nextIndex = contentLayout.currentIndex - 1;
                    if (nextIndex >= 0) {
                        overviewWindow.sortedToplevels[nextIndex].wayland.activate();
                    }
                }
            }
        }
    }

    color: "#00000000"

    Behavior on visibleProgress {
        NumberAnimation {
            duration: 300
            easing: Easing.InOutCubic
        }
    }

    visible: visibleProgress > 0.05

    RowLayout {
        id: contentLayout
        property int currentIndex: 0
        property int currentOffset: {
            let previousId = windowRepeater.model[0].workspace.id || 0;
            let total = 0;

            for (let i = 0; i <= currentIndex; i++) {
                let currentId = windowRepeater.model[i].workspace.id || 0;
                let item = windowRepeater.itemAt(i);
                let width = overviewWindow.elementWidth;
                if (i == currentIndex) {
                    width = (width + overviewWindow.selectedWidthExpansion) / 2;
                } else {
                    width += spacing;
                }
                if (previousId != currentId) {
                    width += 100;
                    previousId = currentId;
                }
                total += width;
            }

            return total;
        }

        anchors {
            verticalCenter: parent.verticalCenter
        }
        implicitHeight: overviewWindow.elementHeight
        spacing: overviewWindow.elementWidth * -0.3 + 10
        x: parent.width / 2 - currentOffset

        Behavior on x {
            SpringAnimation {
                spring: 3
                damping: 0.35
                epsilon: 0.1
            }
        }

        Repeater {
            id: windowRepeater
            model: overviewWindow.sortedToplevels
            delegate: Item {
                id: windowItem
                // required property int index
                property bool selected: {
                    if (modelData.activated) {
                        contentLayout.currentIndex = index;
                        return true;
                    } else {
                        return false;
                    }
                }

                property bool nextDifferent: {
                    const nextIndex = index + 1;
                    if (overviewWindow.sortedToplevels.length > nextIndex && overviewWindow.sortedToplevels[nextIndex].workspace.id != overviewWindow.sortedToplevels[index].workspace.id) {
                        return true;
                    }
                    return false;
                }

                property real currentOpacity: overviewWindow.active ? 1 : 0
                property int maximumWidth: copyView.maximumWidth
                property int currentWidth: Math.min(overviewWindow.elementWidth + (selected ? overviewWindow.selectedWidthExpansion : 0), maximumWidth)
                property int currentHeight: overviewWindow.elementHeight + (selected ? 100 : 0)

                Behavior on currentWidth {
                    NumberAnimation {
                        duration: 300
                        easing: Easing.OutCubic
                    }
                }

                Behavior on currentHeight {
                    NumberAnimation {
                        duration: 300
                        easing: Easing.OutCubic
                    }
                }

                Behavior on currentOpacity {
                    SequentialAnimation {
                        PauseAnimation {
                            duration: 60 * Math.abs(contentLayout.currentIndex - index) + 30
                        }
                        NumberAnimation {
                            duration: 120
                        }
                    }
                }

                Layout.alignment: Qt.AlignVCenter

                transform: Translate { // fade in effect
                    y: windowItem.currentOpacity < 0.1 ? 200 : 0
                    x: (-y * overviewWindow.elementWidth * 0.3 / overviewWindow.elementHeight)

                    Behavior on y {
                        NumberAnimation {
                            duration: 500
                            easing: Easing.OutCubic
                        }
                    }
                }

                implicitHeight: currentHeight
                implicitWidth: {
                    const resultWidth = currentWidth + (nextDifferent ? overviewWindow.workspaceDividerWidth : 0);

                    return resultWidth;
                }
                opacity: currentOpacity

                Shape { //main body shape
                    id: parallelogram
                    property int skewPixel: overviewWindow.elementWidth * 0.3 * windowItem.currentHeight / overviewWindow.elementHeight

                    anchors {
                        verticalCenter: parent.verticalCenter
                        left: parent.left
                    }
                    height: parent.currentHeight
                    width: parent.currentWidth

                    layer.enabled: true
                    preferredRendererType: Shape.NvprRenderer

                    ShapePath {
                        strokeColor: "#FF676767"
                        strokeWidth: 1
                        fillColor: "#01000000"

                        // Define starting position point
                        startX: parallelogram.skewPixel
                        startY: 1

                        // Draw lines to form the geometry

                        PathLine {
                            x: parallelogram.width
                            y: 1
                        }
                        PathLine {
                            x: parallelogram.width - parallelogram.skewPixel
                            y: parallelogram.height
                        }
                        PathLine {
                            x: 1
                            y: parallelogram.height
                        }

                        PathLine {
                            x: parallelogram.skewPixel
                            y: 1
                        }
                    }
                }

                Rectangle { // contents
                    id: viewContents
                    height: parent.currentHeight
                    width: parent.currentWidth

                    ScreencopyView {
                        property int maximumWidth: (overviewWindow.elementHeight + 100) * sourceSize.width / sourceSize.height
                        id: copyView
                        captureSource: modelData.wayland
                        height: parent.height
                        width: parent.height * sourceSize.width / sourceSize.height

                        implicitWidth: {
                            return width
                        }
                        implicitHeight: {
                            return height;
                        }
                        live: windowItem.selected


                        x: {
                            return -width/2 + parent.width/2
                        }

                        // Behavior on currentOffset {
                        //     NumberAnimation {
                        //         duration: 100
                        //     }
                        // }
                    }

                    visible: false

                    Shape { // skewed text body
                        id: parallelogramText
                        anchors {
                            left: parent.left
                            bottom: parent.bottom
                            right: parent.right
                        }
                        height: childText.height + 20
                        width: 1


                        property int skewPixel: windowItem.currentHeight * 0.3 * (childText.implicitHeight + 20) / overviewWindow.elementHeight

                        ShapePath {
                            strokeColor: "white"
                            fillColor: "white"

                            // Define starting position point
                            startX: 1
                            startY: 1

                            // Draw lines to form the geometry

                            PathLine {
                                x: childText.implicitWidth + 20 + parallelogramText.skewPixel / 2
                                y: 1
                            }

                            PathLine {
                                x: childText.implicitWidth + 20 - parallelogramText.skewPixel / 2
                                y: 100
                            }

                            PathLine {
                                x: 1
                                y: 100
                            }

                            PathLine {
                                x: 1
                                y: 1
                            }
                        }
                    }

                    Text { // title text
                        id: childText
                        anchors {
                            bottom: parent.bottom
                            left: parent.left
                            margins: 10
                        }
                        text: modelData.title
                        color: "black"
                        font.pointSize: 14
                    }
                }

                Loader {
                    anchors {
                        fill: parallelogram
                    }
                    active: windowItem.nextDifferent

                    sourceComponent: Rectangle {
                        anchors {
                            fill: parent
                        }
                        color: "transparent"

                        Shape {
                            id: dividerShape
                            property int padding: 20
                            property int currentHeight: overviewWindow.height
                            property int currentWidth: overviewWindow.elementWidth * 0.3 * currentHeight / overviewWindow.elementHeight + padding
                            property int verticalOffset: (overviewWindow.height - windowItem.currentHeight) / -2
                            property int horizontalOffset: currentWidth + overviewWindow.elementWidth * 0.3 * verticalOffset / overviewWindow.elementHeight - padding/2


                            height: currentHeight
                            width: currentWidth

                            x: windowItem.currentWidth + overviewWindow.workspaceDividerWidth + contentLayout.spacing / 2 - horizontalOffset * 1
                            y: verticalOffset
                            // z: 10
                            
                            preferredRendererType: Shape.CurveRenderer

                            layer.enabled: true
                            // layer.smooth: true

                            ShapePath {
                                strokeColor: "#FFAAAAAA"
                                strokeWidth: 1

                                startX: dividerShape.currentWidth - dividerShape.padding/2
                                startY: 0
                                PathLine {
                                    x: dividerShape.padding/2
                                    y: dividerShape.currentHeight
                                }
                            }
                        }
                    }
                }

                MultiEffect {
                    id: mask1
                    anchors {
                        fill: parallelogram
                        margins: 2
                    }
                    // height: parent.currentHeight - 2
                    // width: parent.currentWidth - 2
                    source: viewContents

                    maskSource: parallelogram
                    maskEnabled: true
                    opacity: (windowItem.selected ? 1 : 0.8)
                    visible: true

                    colorization: (1 - opacity) * 2
                    colorizationColor: "black"

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 300
                            easing: Easing.OutCubic
                        }
                    }
                }
            }
        }
    }

    MultiEffect {
        anchors.fill: contentLayout
        source: contentLayout

        shadowEnabled: true
        shadowColor: "black"
        shadowBlur: 2
        shadowVerticalOffset: 15
        shadowHorizontalOffset: 15
    }
}
