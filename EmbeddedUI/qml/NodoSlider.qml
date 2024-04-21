import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Slider {
    id: control
    value: 0.5
    property int handleHight: 20
    property int handleWidth: 20

    background: NodoCanvas {
        id: sliderBackground
        x: control.leftPadding
        y: control.topPadding + control.height / 2 - height / 2
        width: control.width
        height: control.height
        color: nodoControl.appTheme ? NodoSystem.highlightedColorNightModeOn : NodoSystem.highlightedColorNightModeOff
    }

    handle: NodoCanvas {
        id: sliderHandle
        cornerColor: sliderBackground.color
        x: control.leftPadding + control.visualPosition * (control.width - width)
        y: control.topPadding + control.height / 2 - height / 2
        width:handleWidth
        height: handleHight
        color: "#ffffff"
    }


}
