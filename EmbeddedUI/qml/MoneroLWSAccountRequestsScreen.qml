import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: moneroLWSAccountCreationRequestsScreen
	anchors.fill: parent
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

    NodoButton {
        id: moneroLWSAcceptAllRequestsButton
		anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.top: moneroLWSAccountCreationRequestsScreen.top
        text: qsTr("Accept All Requests")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }

    NodoInfoField {
        id: moneroLWSAccountRequestsAddressField
		anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.top: moneroLWSAcceptAllRequestsButton.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: labelSize + 300
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Address")
        valueText: "a very long address"
    }

    NodoInfoField {
        id: moneroLWSAccountRequestsHeightField
		anchors.left: moneroLWSAccountRequestsAddressField.right
        anchors.top: moneroLWSAccountRequestsAddressField.top
        anchors.leftMargin: 20
        width: labelSize+300
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Start Height")
        valueText: "2999185"
    }

    NodoButton {
        id: moneroLWSAccountRequestsAcceptButton
		anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.top: moneroLWSAccountRequestsHeightField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Accept")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }

    NodoButton {
        id: moneroLWSAccountRequestsRejectButton
		anchors.left: moneroLWSAccountRequestsAcceptButton.right
        anchors.top: moneroLWSAccountRequestsAcceptButton.top
		anchors.leftMargin: 20
        text: qsTr("Reject")
        height: NodoSystem.infoFieldLabelHeight
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }
}

