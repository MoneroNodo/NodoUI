import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

CheckBox {
    id: checkBox

    property string backgroundColor:  nodoControl.appTheme ? NodoSystem.buttonBGColorNightModeOn : NodoSystem.buttonBGColorNightModeOff

    background: NodoCanvas {
        width: checkBox.width
        height: checkBox.height
        color: checked ? checkBox.backgroundColor : NodoSystem.dataFieldTextBGColorNightModeOff
    }

    indicator: Text {
        width: checkBox.width
        height: checkBox.height
        x: 1
        y: -6
        text: "\u2713"
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: checkBox.width
        color: "white"
        visible: checkBox.checked
    }
}

