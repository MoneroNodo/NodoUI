import QtQuick 2.15
import QtQuick.Window 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15
import QtQuick.Controls.Universal 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.VirtualKeyboard 2.1
import QtQuick2QREncode 1.0
import NodoSystem 1.1

Item {
    id: networksI2PScreen

    property int labelSize: 0
    property int infoFieldWidth: 1200

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
        height: NodoSystem.nodoItemHeight

        NodoLabel{
            id: i2pSwitchText
            height: i2pSwitchRect.height
            anchors.left: i2pSwitchRect.left
            anchors.top: i2pSwitchRect.top
            text: qsTr("I2P")
        }

        NodoSwitch {
            id: i2pSwitch
            anchors.left: i2pSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: i2pSwitchRect.height
            width: 2*i2pSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodoConfig.getStringValueFromKey("config", "i2p_enabled") === "TRUE" ? true : false
        }
    }

    NodoInfoField {
        id: i2pAddressField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("I2P b32 Address")
        valueText: nodoConfig.getStringValueFromKey("config", "i2p_address")
    }

    NodoInputField {
        id: i2pPortField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
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
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Peer")
        valueText: nodoConfig.getStringValueFromKey("config", "add_i2p_peer")
    }

    NodoButton {
        id: i2pAddPeerButton
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPeerField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        text: qsTr("Set Peer")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
    }

    Rectangle{
        id: qrCodeRect
        anchors.right: networksI2PScreen.right
        anchors.top: networksI2PScreen.top
        anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.rightMargin: 100
        color: "black"
        width: 512
        height: 512

        QtQuick2QREncode {
            id: qr
            width: qrCodeRect.width
            height: qrCodeRect.height
            qrSize: Qt.size(width,width)
            qrData: i2pAddressField.valueText + ":" + i2pPortField.valueText
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }

}

