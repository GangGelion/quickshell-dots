import QtQuick
import Quickshell

QtObject {
    required property DesktopEntry desktopEntry
    required property string name
    required property string id

    function getIcon() {
        return Quickshell.iconPath(desktopEntry.icon, true)
    }
}