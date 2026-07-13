pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: resourceProvider
    property int cpuTemperature: 0
    property int gpuTemperature: 0

    // retrieve hwmon index
    Process {
        id: retrieveCpuMon
        property int hwmonIndex: 0
        command: ["cat", "/sys/class/hwmon/hwmon0/name"]

        running: true
        stdout: StdioCollector {
            onStreamFinished: {
                if (!text.includes("k10temp")) {
                    retrieveCpuMon.hwmonIndex++;
                    retrieveCpuMon.command[1] = `/sys/class/hwmon/hwmon${retrieveCpuMon.hwmonIndex}/name`
                    retrieveCpuMon.running = true
                } else {
                    retrieveCpuTemp.command[1] = `/sys/class/hwmon/hwmon${retrieveCpuMon.hwmonIndex}/temp1_input`;
                    retrieveCpuTemp.running = true;
                }
            }
        }
    }

    // retrieve cpu temperature
    Process {
        id: retrieveCpuTemp
        command: ["cat", "/sys/class/hwmon/hwmon69/temp1_input"]
        running: false

        stdout: StdioCollector {
            onStreamFinished: {
                onStreamFinished: {
                    const number = parseInt(text);
                    if (isNaN(number)) {
                        resourceProvider.cpuTemperatue = 0
                        return
                    }
                    resourceProvider.cpuTemperature = number/1000
                }
            }
        }
    }

    Timer {
        repeat: true
        interval: 1000
        running: true
        onTriggered: {
            retrieveCpuTemp.running = true
        }
    }
}
