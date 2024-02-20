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
    property int labelSize: 208

    Component.onCompleted: {
        nodoConfig.updateRequested()
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            torSwitch.checked = nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
            torRouteSwitch.checked = nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
            torOnionAddressField.valueText = nodoConfig.getStringValueFromKey("config", "tor_address")
            torPortField.valueText = nodoConfig.getIntValueFromKey("config", "tor_port")
            torPeerField.valueText = nodoConfig.getStringValueFromKey("config", "add_tor_peer")
        }
    }

    Rectangle {
        id: torSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: networksTorScreen.top
        height: 64

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
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("config", "tor_enabled") === "TRUE" ? true : false
        }
    }

    Rectangle {
        id: torRouteSwitchRect
        anchors.left: networksTorScreen.left
        anchors.top: torSwitchRect.bottom
        anchors.topMargin: 16
        height: 64

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
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("config", "tor_global_enabled") === "TRUE" ? true : false
        }
    }

    NodoInfoField {
        id: torOnionAddressField
        anchors.left: networksTorScreen.left
        anchors.top: torRouteSwitchRect.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Onion Address"
        valueText: nodoConfig.getStringValueFromKey("config", "tor_address")
    }

    NodoInputField {
        id: torPortField
        anchors.left: networksTorScreen.left
        anchors.top: torOnionAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Port"
        valueText: nodoConfig.getIntValueFromKey("config", "tor_port")
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInfoField {
        id: torPeerField
        anchors.left: networksTorScreen.left
        anchors.top: torPortField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Peer"
        valueText: nodoConfig.getStringValueFromKey("config", "add_tor_peer")
    }

    NodoButton {
        id: torAddPeerButton
        anchors.left: networksTorScreen.left
        anchors.top: torPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Set Peer")
        height: 64
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 16
        textRightPadding: 16
        frameRadius: 4
    }

    Label {
        id: torScanToLabel
        anchors.left: networksTorScreen.left
        anchors.top: torAddPeerButton.bottom
        anchors.topMargin: 64
        width: 497
        height: 60
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

