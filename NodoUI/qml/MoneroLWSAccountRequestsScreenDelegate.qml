import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: parent.width
    height: moneroLWSAccountRequestsHeightField.y + moneroLWSAccountRequestsHeightField.height + NodoSystem.cardTopMargin//295
    color: NodoSystem.cardBackgroundColor
    property string requestAddress: ""
    property int scanHeight: 0
    property int labelSize: 0

    Component.onCompleted: {
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(moneroLWSAccountRequestsAddressField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSAccountRequestsAddressField.labelRectRoundSize

        if(moneroLWSAccountRequestsHeightField.labelRectRoundSize > labelSize)
            labelSize = moneroLWSAccountRequestsHeightField.labelRectRoundSize
    }

    NodoInfoField {
        id: moneroLWSAccountRequestsAddressField
        anchors.left: mainRect.left
        anchors.right: mainRect.right
        anchors.top: mainRect.top
        anchors.topMargin: NodoSystem.cardTopMargin
        anchors.leftMargin: NodoSystem.cardLeftMargin - 2
        anchors.rightMargin: NodoSystem.cardLeftMargin - 2
        itemSize: 180
        height: NodoSystem.nodoItemHeight
        itemText: systemMessages.messages[NodoMessages.Message.Address] //Label "Address"
        valueText: requestAddress
        valueFontSize: 31
    }

    NodoInfoField {
        id: moneroLWSAccountRequestsHeightField
        anchors.left: moneroLWSAccountRequestsAddressField.left
        anchors.top: moneroLWSAccountRequestsAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        itemSize: 180
        width: 400
        height: NodoSystem.nodoItemHeight
        
        itemText: qsTr("Height")
        valueText: scanHeight
    }

    NodoButton {
        id: moneroLWSAccountRequestsAcceptButton
        anchors.right: mainRect.right
        anchors.rightMargin: NodoSystem.cardTopMargin
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: NodoSystem.cardTopMargin
        text: qsTr("Accept")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.acceptRequest(moneroLWSAccountRequestsAddressField.valueText);
        }
    }

    NodoButton {
        id: moneroLWSAccountRequestsRejectButton
        anchors.right: moneroLWSAccountRequestsAcceptButton.left
        anchors.rightMargin: 25
        anchors.bottom: mainRect.bottom
        anchors.bottomMargin: NodoSystem.cardTopMargin
        text: qsTr("Reject")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.rejectRequest(moneroLWSAccountRequestsAddressField.valueText);
        }
    }
}
