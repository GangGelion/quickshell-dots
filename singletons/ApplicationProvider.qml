pragma Singleton

import Quickshell
import QtQuick
import Qt.labs.folderlistmodel

import "utils"

Singleton {
    property var applications: {
        let apps = Array.from(DesktopEntries.applications.values)
        FuzzySearch.prepare(apps)
        return apps
    }

    property var matchingApplications: {
        const arr = FuzzySearch.search(searchTerm).slice(0, 5).map(x => x.item)
        arr.reverse()
        return arr
    }

    property var currentSelected: matchingApplications[matchingApplications.length - 1]
    property var searchTerm: "aaa"

}
