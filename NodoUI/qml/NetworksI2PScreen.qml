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
    property string i2pAddress
    property bool i2pSwitchStatus
    property bool i2pPortFieldReadOnly: false

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        var enabled = !nodoControl.isComponentEnabled();
        i2pPortFieldReadOnly = enabled
    }

    function onCalculateMaximumTextLabelLength() {
        if(i2pAddressField.labelRectRoundSize > labelSize)
            labelSize = i2pAddressField.labelRectRoundSize

        if(i2pPortField.labelRectRoundSize > labelSize)
            labelSize = i2pPortField.labelRectRoundSize
    }


    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            networksI2PScreen.i2pSwitchStatus = nodoConfig.getStringValueFromKey("config", "i2p_enabled") === "TRUE" ? true : false
            networksI2PScreen.i2pAddress = nodoConfig.getStringValueFromKey("config", "i2p_address")
            networksI2PScreen.i2pPort = nodoConfig.getIntValueFromKey("config", "i2p_port")
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(0 !== errorCode)
            {
                systemPopup.popupMessageText = nodoControl.getErrorMessage()
                systemPopup.commandID = -1;
                systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
                systemPopup.open();
            }
        }

        function onComponentEnabledStatusChanged() {
            var enabled = !nodoControl.isComponentEnabled();
            i2pPortFieldReadOnly = enabled
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
        itemText: systemMessages.messages[NodoMessages.Message.Port]
        valueText: networksI2PScreen.i2pPort
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: networksI2PScreen.i2pPortFieldReadOnly
        validator: IntValidator{bottom: 0; top: 65535}
        onTextEditFinished: {
            if(i2pPortField.valueText !== networksI2PScreen.i2pPort.toString())
            {
                i2pApplyPortButton.isActive = true
            }
        }
    }

    NodoButton {
        id: i2pApplyPortButton
        anchors.left: networksI2PScreen.left
        anchors.top: i2pPortField.bottom
        anchors.topMargin: 20
        text: systemMessages.messages[NodoMessages.Message.ApplyPort]
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            nodoControl.setI2pPort(i2pPortField.valueText)
        }
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
            qrData: "xmrrpc://:@" + i2pAddressField.valueText + ":" + i2pPortField.valueText + "?label=Nodo I2P Node"
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }
}
