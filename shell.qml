import Quickshell // for PanelWindow
import Quickshell.Wayland

import QtQuick.Layouts
import QtQuick // for Text
import Quickshell.Io

import "./widgets"

PanelWindow {
    id: mainBarWindow

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 36

    property real margin: 10

    BarWorkspace {
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
            leftMargin: 10
        }
    }

    BarClock {
        window: mainBarWindow
        anchors {
            centerIn: parent
        }
    }

    BarPower {
        anchors {
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
    }

    OverviewPopup {}

    MailThingy {}

    /* Text {
    // center the bar in its parent component (the window)
    id: clock

    anchors.centerIn: parent

    text: "This is a centered text inside of a parent"

    Process {
      id: clockProcess

      command: ["date"] running: true

      stdout: StdioCollector {
        onStreamFinished: {
          const splits = this.text.split(" ");
          clock.text = splits[4]
        }
      }
    }
  } */

}
