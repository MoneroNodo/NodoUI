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
    id: networksI2PScreen

    property int labelSize: 120
    Component.onCompleted: {
        nodoConfig.updateRequested()
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            i2pSwitch.checked = nodoConfig.getStringValueFromKey("config", "i2p_enabled") === "TRUE" ? true : false
            i2pAddressField.valueText = nodoConfig.getStringValueFromKey("config", "i2p_address")
            i2pPortField.valueText = nodoConfig.getIntValueFromKey("config", "i2p_port")
            i2pPeerField.valueText = nodoConfig.getStringValueFromKey("config", "add_i2p_peer")
        }
    }

    Rectangle {
        id: i2pSwitchRect
        anchors.left: networksI2PScreen.left
        anchors.top: networksI2PScreen.top
        height: 64

        Text{
            id:i2pSwitchText
            x: 0
            y: (i2pSwitch.height - i2pSwitchText.height)/2
            width: i2pSwitchText.paintedWidth
            height: i2pSwitchText.paintedHeight
            text: "I2P"
            color: nodoControl.appTheme ? NodoSystem.defaultColorNightModeOn : NodoSystem.defaultColorNightModeOff
            font.family: NodoSystem.fontUrbanist.name
            font.pixelSize: NodoSystem.textFontSize
        }

        NodoSwitch {
            id: i2pSwitch
            x: i2pSwitchText.width + 20
            y: 0
            width: 128
            height: 64
            text: qsTr("")
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("config", "i2p_enabled") === "TRUE" ? true : false
        }
    }

    NodoInfoField {
        id: i2pAddressField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pSwitchRect.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "I2P b32 Addr"
        valueText: nodoConfig.getStringValueFromKey("config", "i2p_address")
    }

    NodoInputField {
        id: i2pPortField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Port"
        valueText: nodoConfig.getIntValueFromKey("config", "i2p_port")
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInfoField {
        id: i2pPeerField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPortField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: "Peer"
        valueText: nodoConfig.getStringValueFromKey("config", "add_i2p_peer")
    }

    NodoButton {
        id: i2pAddPeerButton
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPeerField.bottom
        anchors.topMargin: 16
        text: qsTr("Add Peer")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        textLeftPadding: 16
        textRightPadding: 16
        frameRadius: 4
    }

    Label {
        id: i2pScanToLabel
        anchors.left: networksI2PScreen.left
        anchors.top: i2pAddPeerButton.bottom
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
        id: i2pQRCodeImage
        anchors.left: networksI2PScreen.left
        anchors.top: i2pScanToLabel.bottom
        anchors.topMargin: 16
        width: 175
        height: 175
        fillMode: Image.PreserveAspectFit
        source: "qrc:/Images/no_qrcode.png"
    }
}

