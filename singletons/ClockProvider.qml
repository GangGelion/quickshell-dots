pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: clockProviderRoot
    property string hours: "0"
    property string minutes: "0"
    property string seconds: "0"

    property string day: "Noneday"
    property string date: "25"
    property string month: "December"
    
    Timer {
        interval: 1000
        running: true
        repeat: true

        onTriggered: {
            const date = new Date();
            const ms = date.getTime() - date.getTimezoneOffset() * 60000;

            parent.hours = Math.floor(ms / (1000 * 60 * 60)) % 24;
            parent.minutes = Math.floor(ms / (1000 * 60)) % 60;
            parent.seconds = Math.floor(ms / 1000) % 60;
            
            parent.day = Qt.formatDate(date, "dddd")
            parent.date = Qt.formatDate(date, "d")
            parent.month = Qt.formatDate(date, "MMMM")
        }
    }
}