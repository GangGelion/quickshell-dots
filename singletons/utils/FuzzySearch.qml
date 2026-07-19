pragma Singleton

import QtQuick
import Quickshell

import "fuse.min.js.js" as FuseLib

Singleton {
    property var filteredData: []

    function prepare(data) {
        FuseLib.prepare(data)
    }

    function search(name) {
        return FuseLib.search(name)
    }
}
