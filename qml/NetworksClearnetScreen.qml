import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Rectangle {
    id: networksClearnetScreen
    property int labelSize: 160
    color: "black"

    NodoInputField {
        id: clearnetAddressField
        anchors.left: networksClearnetScreen.left
        anchors.top: networksClearnetScreen.top
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Address"
        valueText: ""
        textFlag: Qt.ImhPreferNumbers
    }

    NodoInputField {
        id: clearnetPortField
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Port"
        valueText: ""
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInputField {
        id: clearnetPeerField
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetPortField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Peer"
        valueText: "clearnet.peer.com"
        textFlag: Qt.ImhPreferLowercase
    }

    NodoButton {
        id: clearnetAddPeerButton
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Add Peer")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 16
        textRightPadding: 16
        frameRadius: 4
    }

    Label {
        id: clearnetScanToLabel
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetAddPeerButton.bottom
        anchors.topMargin: 40
        width: 497
        height: 60
        text: qsTr("Scan to add Nodo to your wallet app:")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    Image {
        id: clearnetQRCodeImage
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetScanToLabel.bottom
        anchors.topMargin: 20
        width: 175
        height: 175
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Images/no_qrcode.png"
    }



}
