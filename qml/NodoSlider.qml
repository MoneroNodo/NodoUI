import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import NodoSystem 1.1

Slider {
    id: control
    value: 0.5
    property int handleHight: 20
    property int handleWidth: 20
    property int handleRadius: 0

    background: Rectangle {
        x: control.leftPadding
        y: control.topPadding + control.height / 2 - height / 2
        width: control.width
        height: control.height
        radius: height*0.4
        color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff

    }

    handle: Rectangle {
        id: sliderHandle
        x: control.leftPadding + control.visualPosition * (control.width - width)
        y: control.topPadding + control.height / 2 - height / 2
        width:handleWidth
        height: handleHight
        radius: handleRadius
        color: "#ffffff"
        border.color: "#ffffff"
    }
}
