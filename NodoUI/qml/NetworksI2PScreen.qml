import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Item {
    id: networksI2PScreen
    property int labelSize: 0
    property int infoFieldWidth: 1200

    property int i2pPort
    property string i2pPeer
    property string i2pAddress
    property bool i2pSwitchStatus
    property bool i2pPortFieldReadOnly: false

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
            networksI2PScreen.i2pSwitchStatus = nodoConfig.getStringValueFromKey("config", "i2p_enabled") === "TRUE" ? true : false
            networksI2PScreen.i2pAddress = nodoConfig.getStringValueFromKey("config", "i2p_address")
            networksI2PScreen.i2pPort = nodoConfig.getIntValueFromKey("config", "i2p_port")
            networksI2PScreen.i2pPeer = nodoConfig.getStringValueFromKey("config", "add_i2p_peer")
        }
    }

    Connections {
        target: nodoControl
        function onServiceStatusMessageReceived() {
            var statusMessage = nodoControl.getServiceMessageStatusCode();
            if(-1 === statusMessage)
            {
                systemPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.Restarting_monerod_service_failed]
                systemPopup.commandID = -1;
                systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                systemPopup.open();
            }
            else if(-2 === statusMessage)
            {
                systemPopup.popupMessageText = systemMessages.messages[NodoMessages.Message.Connection_with_nodo_dbus_service_failed]
                systemPopup.commandID = -1;
                systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                systemPopup.open();
            }

            i2pPortFieldReadOnly = false;
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
            checked: networksI2PScreen.i2pSwitchStatus
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
        valueText: networksI2PScreen.i2pAddress
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
        valueText: networksI2PScreen.i2pPort
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: networksI2PScreen.i2pPortFieldReadOnly
        onTextEditFinished: {
            if(i2pPortField.valueText !== networksI2PScreen.i2pPort.toString())
            {
                i2pApplyPortButton.isActive = true
            }
        }
    }

    NodoInputField {
        id: i2pPeerField
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPortField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.infoFieldLabelHeight
        itemSize: labelSize
        itemText: qsTr("Peer")
        valueText: networksI2PScreen.i2pPeer
        onTextEditFinished: {
        }
    }

    NodoButton {
        id: i2pApplyPortButton
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Apply Port")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            networksI2PScreen.i2pPortFieldReadOnly = true;
            nodoControl.setI2pPort(i2pPortField.valueText)
        }
    }

    NodoButton {
        id: i2pAddPeerButton
        anchors.left: networksI2PScreen.left
        anchors.top: i2pApplyPortButton.bottom
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

