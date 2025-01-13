import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

Slider {
    id: control
    value: 0.5
    property int handleHeight: 20
    property int handleWidth: 20
    property int handlePadding: 6

    background: NodoCanvas {
        id: sliderBackground
        x: 0
        y: 0
        width: control.width
        height: control.height
        color: NodoSystem.dataFieldTextBGColorNightModeOff//nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
    }

    handle: NodoCanvas {
        id: sliderHandle
        x: handlePadding + (control.visualPosition * (control.width - width - (2*handlePadding)))
        y: (control.height - height)/2
        width: handleWidth
        height: handleHeight
        color: "#F5F5F5"
        borderColor: "#F5F5F5"
    }
}
