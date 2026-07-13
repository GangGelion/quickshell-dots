pragma Singleton

import Quickshell
import QtQuick

Singleton {
    function interpolateColor(colorA, colorB, weight) {
        // Ensure weight is clamped between 0.0 and 1.0
        let t = Math.max(0.0, Math.min(1.0, weight)); 
        
        return Qt.rgba(
            colorA.r + (colorB.r - colorA.r) * t,
            colorA.g + (colorB.g - colorA.g) * t,
            colorA.b + (colorB.b - colorA.b) * t,
            colorA.a + (colorB.a - colorA.a) * t
        );
    }
}