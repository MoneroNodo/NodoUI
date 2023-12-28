import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import NodoSystem 1.1

Item {
    id: moneroLWSAccountCreationRequestsScreen
	anchors.fill: parent
    property int labelSize: 120

    NodoButton {
        id: moneroLWSAcceptAllRequestsButton
		anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.top: moneroLWSAccountCreationRequestsScreen.top
        text: qsTr("Accept All Requests")
        height: 38
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }

    NodoInfoField {
        id: moneroLWSAccountRequestsAddressField
		anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.top: moneroLWSAcceptAllRequestsButton.bottom
		anchors.topMargin: 20
        width: 460
        height: 38
        itemSize: labelSize
        itemText: "Address"
        valueText: "a very long address"
    }

    NodoInfoField {
        id: moneroLWSAccountRequestsHeightField
		anchors.left: moneroLWSAccountRequestsAddressField.right
        anchors.top: moneroLWSAccountRequestsAddressField.top
		anchors.leftMargin: 10
        width: 260
        height: 38
        itemSize: labelSize
        itemText: "Start Height"
        valueText: "2999185"
    }

    NodoButton {
        id: moneroLWSAccountRequestsAcceptButton
		anchors.left: moneroLWSAccountCreationRequestsScreen.left
        anchors.top: moneroLWSAccountRequestsHeightField.bottom
		anchors.topMargin: 20
        text: qsTr("Accept")
        height: 38
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }

    NodoButton {
        id: moneroLWSAccountRequestsRejectButton
		anchors.left: moneroLWSAccountRequestsAcceptButton.right
        anchors.top: moneroLWSAccountRequestsAcceptButton.top
		anchors.leftMargin: 20
        text: qsTr("Reject")
        height: 38
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 25
        textRightPadding: 25
        frameRadius: 4
    }
}

