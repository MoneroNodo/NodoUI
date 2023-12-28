import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls.Material 2.12
import QtQuick.Controls.Universal 2.12
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Item {
    id: networksTorScreen
    property int labelSize: 130

    Rectangle {
        id: torSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: networksTorScreen.top
        height: 40

        Text{
            id:torSwitchText
            x: 0           
            y: (torSwitch.height - torSwitchText.height)/2
            width: torSwitchText.paintedWidth
            height: torSwitchText.paintedHeight
            text: "Tor"
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: torSwitch
            x: torSwitchText.width + 20
            y: 0
            width: 80
            height: 40
            text: qsTr("")
            display: AbstractButton.IconOnly
        }
    }

    Rectangle {
        id: torRouteSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: torSwitchRect.bottom
        anchors.topMargin: 10
        height: 40

        Text{
            id:torRouteSwitchText
            x: 0
            y: (torRouteSwitch.height - torRouteSwitchText.height)/2
            width: torRouteSwitchText.paintedWidth
            height: torRouteSwitchText.paintedHeight
            text: "Route all connections through Tor"
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: torRouteSwitch
            x: torRouteSwitchText.width + 20
            y: 0
            width: 80
            height: 40
            text: qsTr("")
            display: AbstractButton.IconOnly
        }
    }

    NodoInfoField {
        id: torOnionAddressField
        anchors.left: networksTorScreen.left
        anchors.top: torRouteSwitchRect.bottom
        anchors.topMargin: 10
        width: 924
        height: 38
        itemSize: labelSize
        itemText: "Onion Address"
        valueText: "a very long onion address"
    }

    NodoInputField {
        id: torPortField
        anchors.left: networksTorScreen.left
        anchors.top: torOnionAddressField.bottom
        anchors.topMargin: 10
        width: 210
        height: 38
        itemSize: labelSize
        itemText: "Port"
        valueText: ""
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInfoField {
        id: torPeerField
        anchors.left: networksTorScreen.left
        anchors.top: torPortField.bottom
        anchors.topMargin: 10
        width: 924
        height: 38
        itemSize: labelSize
        itemText: "Peer"
        valueText: "a very long peer value"
    }

    NodoButton {
        id: torAddPeerButton
        anchors.left: networksTorScreen.left
        anchors.top: torPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Add Peer")
        height: 40
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 10
        textRightPadding: 10
        frameRadius: 4
    }

    Label {
        id: torScanToLabel
        anchors.left: networksTorScreen.left
        anchors.top: torAddPeerButton.bottom
        anchors.topMargin: 40
        width: 497
        height: 38
        text: qsTr("Scan to add Nodo to your wallet app:")
        font.pixelSize: NodoSystem.textFontSize
        verticalAlignment: Text.AlignVCenter
        color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
        font.family: NodoSystem.fontUrbanist.name
    }

    Image {
        id: torQRCodeImage
        anchors.left: networksTorScreen.left
        anchors.top: torScanToLabel.bottom
        anchors.topMargin: 8
        width: 175
        height: 175
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Images/no_qrcode.png"
    }
}

