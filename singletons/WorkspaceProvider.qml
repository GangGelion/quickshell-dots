pragma Singleton

import Quickshell
import Quickshell.Hyprland
import QtQuick

Singleton {
    property int currentWorkspace: {
        return Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : -1
    }

    function switchWorkspace(idx) {
        Hyprland.dispatch(`hl.dsp.focus({workspace = '${idx}'})`)
    }
}