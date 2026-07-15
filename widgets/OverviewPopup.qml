import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

import QtQuick
import QtQuick.Layouts
import QtQuick.Shapes
import QtQuick.Effects

import "../components/basic"

PanelWindow {
    id: root
    property bool active: false
    property int elementWidth: 300
    property int elementWidthExpansion: 700

    property int elementHeight: 500
    property int elementHeightExpansion: 200
    visible: active

    readonly property var sortedTopLevels: {
        const toplevels = Hyprland.toplevels.values;
        const jsArray = Array.from({
            length: toplevels.length
        }, (_, i) => toplevels[i]);
        jsArray.sort((a, b) => {
            const aid = a.workspace.id || 999;
            const bid = b.workspace.id || 999;
            return aid - bid;
        });
        const newJsArray = [];
        let curId = jsArray[0].workspace.id;
        let index = 0;
        for (let next of jsArray) {
            index++;
            if (next.workspace.id != curId) {
                curId = next.workspace.id
                newJsArray.push({
                    separator: true
                });
            }
            next.windowIndex = index
            newJsArray.push(next);
        }
        return newJsArray;
    }

    function calculateOffset(height, angle) {
        return Math.tan(angle * Math.PI / 180) * height;
    }

    GlobalShortcut {
        name: "toggle_overview"

        onPressed: {
            //root.active = !root.active;
        }
    }

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    color: "#AA000000"

    RowLayout {
        id: contentLayout
        
        property int currentIndex: 0
        property int currentOffset: {
            let total = 0;
            for (let i = 0; i < screenRepeater.count; i++) {
                let idx = screenRepeater.itemAt(i).item;
                if (idx.isSeparator) {
                    total += idx.implicitWidth + spacing;
                    continue;
                }
                let width = idx.containerWidth;
                if (idx.currentSelected) {
                    width /= 2;
                    total += width;
                    currentIndex = idx.windowIndex
                    break;
                }
                total += width + spacing;
            }
            return total;
        }

        Behavior on x {
            SpringAnimation {
                spring: 5
                damping: 0.35
                epsilon: 0.1
            }
        }
        anchors {
            top: parent.top
            bottom: parent.bottom
        }
        x: root.screen.width / 2 - currentOffset

        spacing: -root.calculateOffset(root.elementHeight, 10) + 25

        Repeater {
            id: screenRepeater
            model: root.sortedTopLevels
            delegate: Loader {
                // i want modelData to be available in sourceComponent
                required property var modelData
                sourceComponent: modelData.separator ? separatorComponent : pgramContainerComponent

                Layout.fillHeight: true

                onLoaded: {
                    if (item.hasOwnProperty("modelData"))
                        item.modelData = modelData;
                }
            }
        }
    }

    // Main item component
    Component {
        id: pgramContainerComponent
        Item {
            id: pgramContainer
            property int windowIndex: modelData.windowIndex
            property bool currentSelected: {
                const active = Hyprland.activeToplevel == modelData;
                return active;
            }

            property int maximumWidth: root.screen.width
            readonly property int contentWidth: Math.min(root.elementWidth + (currentSelected ? root.elementWidthExpansion : 0), maximumWidth)
            readonly property int contentHeight: root.elementHeight + (currentSelected ? root.elementHeightExpansion : 0)

            property int currentWidth: contentWidth
            property int currentHeight: contentHeight

            readonly property int containerWidth: contentWidth
            readonly property int containerHeight: contentHeight
            readonly property int compensate: root.calculateOffset(containerHeight - root.elementHeight, 10)

            property int currentContainerWidth: containerWidth
            property int currentContainerHeight: containerHeight

            Behavior on currentWidth {
                NumberAnimation {
                    duration: 250
                    easing: Easing.OutQuad
                }
            }

            Behavior on currentHeight {
                NumberAnimation {
                    duration: 250
                    easing: Easing.OutQuad
                }
            }

            Behavior on currentContainerWidth {
                NumberAnimation {
                    duration: 250
                    easing: Easing.OutQuad
                }
            }

            Behavior on currentContainerHeight {
                NumberAnimation {
                    duration: 250
                    easing: Easing.OutQuad
                }
            }


            transform: Translate {
                id: popupTranslation
                property bool lastState: false

                property real currentProgress: root.active ? 1 : 0
                property real currentFloat: {
                    let currentState = lastState
                    if (currentProgress > 0.9 && !lastState) {
                        currentState = true
                    } else if (currentProgress < 0.9 && lastState) {
                        currentState = false
                    }
                    return currentState ? 1 : 0
                }

                Behavior on currentProgress {
                    NumberAnimation {
                        duration: 0 + 50 * Math.abs(contentLayout.currentIndex - pgramContainer.windowIndex)
                    }
                }

                Behavior on currentFloat {
                    NumberAnimation {
                        duration: 500
                        easing: Easing.OutCubic
                    }
                }

                y: (1 - currentFloat) * 100
                x: -root.calculateOffset(y, 10)
            }

            
            implicitWidth: currentContainerWidth
            implicitHeight: currentContainerHeight

            PgramShape {
                id: pgramShape
                Behavior on borderColor {
                    ColorAnimation {
                        duration: 200
                        easing: Easing.OutQuad
                    }
                }
            
                Behavior on overlayColor {
                    ColorAnimation {
                        duration: 200
                        easing: Easing.OutQuad
                    }
                }
                currentWidth: pgramContainer.currentWidth //root.elementWidth
                currentHeight: pgramContainer.currentHeight //root.elementHeight
                anchors.centerIn: parent

                borderColor: pgramContainer.currentSelected ? "#FFFFFFFF" : "#88FFFFFF"
                overlayColor: pgramContainer.currentSelected ? "#00000000" : "#88000000"
                opacity: popupTranslation.currentFloat * 0.5 + 0.5

                ScreencopyView {
                    id: windowView

                    anchors.centerIn: parent

                    height: pgramContainer.currentHeight
                    width: {
                        return height * sourceSize.width / sourceSize.height
                    }

                    visible: {
                        pgramContainer.maximumWidth = pgramContainer.contentHeight * sourceSize.width / sourceSize.height
                        return true
                    }

                    // implicitHeight: height
                    // implicitWidth: width

                    captureSource: modelData.wayland
                    live: pgramContainer.currentSelected
                }
            }

        }
    }

    // Workspace separator component
    Component {
        id: separatorComponent
        Rectangle {
            property bool isSeparator: true
            implicitWidth: root.calculateOffset(root.height, 10) * 0.7
            height: parent.height
            // color: "#AAFF0000"
            color: "transparent"

            Rectangle {
                id: separatorLine
                property real angle: 10

                anchors.centerIn: parent
                width: 1
                height: root.height * 2

                transform: [
                    Rotation {
                        angle: separatorLine.angle
                    },
                    Translate {
                        x: root.calculateOffset(root.height, separatorLine.angle)
                        y: root.height * 0.5 * (1 - Math.cos(separatorLine.angle * Math.PI / 180))
                    }
                ]
            }
        }
    }
}
