import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

CheckBox {
    id: control
    property string checkBoxText: ""

    Text{
        x: control.width
        y: control.topPadding + (control.availableHeight - height) / 2
        text: qsTr(checkBoxText)
        color: "white"
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.textFontSize

    }
}


