import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: 1840
    height: 163
    color: "#141414"
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
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        itemSize: 0
        height: NodoSystem.infoFieldLabelHeight
        itemText: qsTr("Address")
        valueText: inactiveAddress
    }


    NodoInfoField {
        id: moneroLWSinactiveHeightField
        anchors.left: moneroLWSinactiveAddressField.left
        anchors.top: moneroLWSinactiveAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: labelSize + 300
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Height")
        valueText: scanHeight
    }

    NodoButton {
        id: moneroLWSReactivateButton
        anchors.left: moneroLWSinactiveHeightField.right
        anchors.top: moneroLWSinactiveHeightField.top
        anchors.leftMargin: 20
        text: qsTr("Reactivate")
        height: NodoSystem.infoFieldLabelHeight
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
        anchors.leftMargin: 16
        text: qsTr("Delete")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.deleteAccount(moneroLWSinactiveAddressField.valueText)
        }
    }

}
