import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import NodoSystem 1.1

Item {
    id: networksI2PScreen

    property int labelSize: 0

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
    }

    function onCalculateMaximumTextLabelLength() {
        if(i2pAddressField.labelRectRoundSize > labelSize)
        labelSize = i2pAddressField.labelRectRoundSize

        if(i2pPortField.labelRectRoundSize > labelSize)
        labelSize = i2pPortField.labelRectRoundSize

        if(i2pPeerField.labelRectRoundSize > labelSize)
        labelSize = i2pPeerField.labelRectRoundSize
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
            text: qsTr("I2P")
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
            text: ""
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
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("I2P b32 Address")
        valueText: nodoConfig.getStringValueFromKey("config", "i2p_address")
    }

    NodoInputField {
        id: i2pPortField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Port")
        valueText: nodoConfig.getIntValueFromKey("config", "i2p_port")
        textFlag: Qt.ImhDigitsOnly
    }

    NodoInfoField {
        id: i2pPeerField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPortField.bottom
        anchors.topMargin: 16
        width: 924
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Peer")
        valueText: nodoConfig.getStringValueFromKey("config", "add_i2p_peer")
    }

    NodoButton {
        id: i2pAddPeerButton
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPeerField.bottom
        anchors.topMargin: 16
        text: qsTr("Set Peer")
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

    QtQuick2QREncode {
        id: qr
        x: 1000
        y: 10
        width: 512
        height: 512
        qrSize: Qt.size(width,width)
        qrData: i2pPeerField + ":" + i2pPortField
        qrForeground: "black"
        qrBackground: "white"
        qrMargin: 8
        qrMode: QtQuick2QREncode.MODE_8    //encode model
				qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
    }


}

