import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
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

