import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: parent.width
    height: moneroLWSinactiveHeightField.y + moneroLWSinactiveHeightField.height + NodoSystem.cardTopMargin//196
    color: NodoSystem.cardBackgroundColor
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
        anchors.topMargin: NodoSystem.cardTopMargin
        anchors.leftMargin: NodoSystem.cardLeftMargin - 2
        anchors.rightMargin: NodoSystem.cardLeftMargin - 2
        itemSize: 180
        height: NodoSystem.nodoItemHeight
        itemText: systemMessages.messages[NodoMessages.Message.Address] //Label "Address"
        valueText: inactiveAddress
        valueFontSize: 31
    }


    NodoInfoField {
        id: moneroLWSinactiveHeightField
        anchors.left: moneroLWSinactiveAddressField.left
        anchors.top: moneroLWSinactiveAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        itemSize: 180
        width: 400
        height: NodoSystem.nodoItemHeight
        itemText: qsTr("Height")
        valueText: scanHeight
    }

    NodoButton {
        id: moneroLWSReactivateButton
        anchors.right: mainRect.right
        anchors.rightMargin: NodoSystem.cardTopMargin
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: NodoSystem.cardTopMargin
        //anchors.left: moneroLWSinactiveHeightField.right
        //anchors.top: moneroLWSinactiveHeightField.top
        //anchors.leftMargin: 25
        text: qsTr("Reactivate")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.reactivateAccount(moneroLWSinactiveAddressField.valueText)
        }
    }

    NodoButton {
        id: moneroLWSDeleteButton
        anchors.right: moneroLWSReactivateButton.left
        anchors.rightMargin: 20
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: NodoSystem.cardTopMargin
        //anchors.top: moneroLWSinactiveHeightField.top
        //anchors.leftMargin: 25
        text: qsTr("Delete")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.deleteAccount(moneroLWSinactiveAddressField.valueText)
        }
    }
}
