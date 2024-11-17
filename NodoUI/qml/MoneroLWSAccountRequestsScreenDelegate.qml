import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0

NodoCanvas {
    id: mainRect
    width: 1840
    height: 263
    color: "#181818"
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
        anchors.topMargin: 10
        anchors.leftMargin: 10
        anchors.rightMargin: 10
        itemSize: 0
        height: NodoSystem.nodoItemHeight
        itemText: systemMessages.messages[NodoMessages.Message.Address]
        valueText: requestAddress
    }

    NodoInfoField {
        id: moneroLWSAccountRequestsHeightField
        anchors.left: moneroLWSAccountRequestsAddressField.left
        anchors.top: moneroLWSAccountRequestsAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: labelSize+300
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("Height")
        valueText: scanHeight
    }

    NodoButton {
        id: moneroLWSAccountRequestsAcceptButton
        anchors.left: moneroLWSAccountRequestsAddressField.left
        anchors.top: moneroLWSAccountRequestsHeightField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Accept")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.acceptRequest(moneroLWSAccountRequestsAddressField.valueText);
        }
    }

    NodoButton {
        id: moneroLWSAccountRequestsRejectButton
        anchors.left: moneroLWSAccountRequestsAcceptButton.right
        anchors.top: moneroLWSAccountRequestsAcceptButton.top
        anchors.leftMargin: 20
        text: qsTr("Reject")
        height: NodoSystem.nodoItemHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        onClicked: {
            moneroLWS.rejectRequest(moneroLWSAccountRequestsAddressField.valueText);
        }
    }
}

