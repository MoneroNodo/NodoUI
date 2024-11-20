import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: 1880
    height: 196
    color: nodoControl.appTheme ? NodoSystem.dataFieldTextBGColorNightModeOn  : NodoSystem.dataFieldTextBGColorNightModeOff
    property string inactiveAddress: ""
    property int scanHeight: 0
    property int labelSize: 0

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(moneroLWSinactiveAddressField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSinactiveAddressField.labelRectRoundSize

        if(moneroLWSinactiveHeightField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSinactiveHeightField.labelRectRoundSize
    }

    NodoInfoField {
        id: moneroLWSinactiveAddressField
        anchors.left: mainRect.left
        anchors.right: mainRect.right
        anchors.top: mainRect.top
        anchors.topMargin: 10
        anchors.leftMargin: 8
        anchors.rightMargin: 8
        itemSize: 160
        height: NodoSystem.nodoItemHeight
        itemText: systemMessages.messages[NodoMessages.Message.Address] //Label "Address"
        valueText: inactiveAddress
        valueFontSize: 30
    }


    NodoInfoField {
        id: moneroLWSinactiveHeightField
        anchors.left: moneroLWSinactiveAddressField.left
        anchors.top: moneroLWSinactiveAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        itemSize: 160
        width: 250
        height: NodoSystem.nodoItemHeight
        itemText: qsTr("Height")
        valueText: scanHeight
    }

    NodoButton {
        id: moneroLWSReactivateButton
        anchors.left: moneroLWSinactiveHeightField.right
        anchors.top: moneroLWSinactiveHeightField.top
        anchors.leftMargin: 20
        text: qsTr("Reactivate")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.reactivateAccount(moneroLWSinactiveAddressField.valueText)
        }
    }

    NodoButton {
        id: moneroLWSDeleteButton
        anchors.left: moneroLWSReactivateButton.right
        anchors.top: moneroLWSinactiveHeightField.top
        anchors.leftMargin: 20
        text: qsTr("Delete")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.deleteAccount(moneroLWSinactiveAddressField.valueText)
        }
    }

}
