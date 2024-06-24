import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Item {
    id: networksClearnetScreen
    property int labelSize: 0
    property int clearnetPort
    property string clearnetPeer
    property bool inputFieldReadOnly: false

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        networkManager.requestNetworkIP();
        networksClearnetScreen.inputFieldReadOnly = !nodoControl.isComponentEnabled();
    }

    function onCalculateMaximumTextLabelLength() {
        if(clearnetAddressField.labelRectRoundSize > labelSize)
        labelSize = clearnetAddressField.labelRectRoundSize

        if(clearnetPortField.labelRectRoundSize > labelSize)
        labelSize = clearnetPortField.labelRectRoundSize

        if(clearnetPeerField.labelRectRoundSize > labelSize)
        labelSize = clearnetPeerField.labelRectRoundSize
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            networksClearnetScreen.clearnetPort = nodoConfig.getIntValueFromKey("config", "monero_public_port")
            networksClearnetScreen.clearnetPeer = nodoConfig.getStringValueFromKey("config", "add_clearnet_peer")
        }
    }

    Connections {
        target: networkManager
        function onNetworkConnStatusReady() {
            clearnetAddressField.valueText = networkManager.getNetworkIP();
            qr.setQrData(clearnetAddressField.valueText + ":" + clearnetPortField.valueText)
        }

        function onErrorDetected() {
            var errorCode = networkManager.getErrorCode();
            if(4 === errorCode)
            {
                clearnetAddressField.valueText = "nan";
            }

            systemPopup.popupMessageText = networkManager.getErrorMessage()
            systemPopup.commandID = -1;
            systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            systemPopup.open();
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            systemPopup.popupMessageText = nodoControl.getErrorMessage()
            systemPopup.commandID = -1;
            systemPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            systemPopup.open();
        }

        function onComponentEnabledStatusChanged() {
            inputFieldReadOnly = !nodoControl.isComponentEnabled();
        }
    }

    NodoInfoField {
        id: clearnetAddressField
        anchors.left: networksClearnetScreen.left
        anchors.top: networksClearnetScreen.top
        width: 924
        height: 60
        itemSize: labelSize
        itemText: qsTr("Address")
        valueText: ""
    }

    NodoInputField {
        id: clearnetPortField
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: qsTr("Port")
        valueText: networksClearnetScreen.clearnetPort
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: networksClearnetScreen.inputFieldReadOnly
        validator: IntValidator{bottom: 0; top: 65535}
        onTextEditFinished: {
            if(clearnetPortField.valueText !== networksClearnetScreen.clearnetPort.toString())
            {
                clearnetApplyPortButton.isActive = true
            }
        }
    }

    NodoInputField {
        id: clearnetPeerField
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetPortField.bottom
        anchors.topMargin: 16
        width: 924
        height: 60
        itemSize: labelSize
        itemText: qsTr("Peer")
        valueText: networksClearnetScreen.clearnetPeer
        textFlag: Qt.ImhPreferLowercase
        readOnlyFlag: networksClearnetScreen.inputFieldReadOnly
        onTextEditFinished: {
            if(clearnetPeerField.valueText !== networksClearnetScreen.clearnetPeer)
            {
                clearnetAddPeerButton.isActive = true
            }
        }
    }

    NodoButton {
        id: clearnetApplyPortButton
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetPeerField.bottom
        anchors.topMargin: 20
        text: qsTr("Apply Port")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            nodoControl.setClearnetPort(clearnetPortField.valueText)
        }
    }

    NodoButton {
        id: clearnetAddPeerButton
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetApplyPortButton.bottom
        anchors.topMargin: 20
        text: qsTr("Set Peer")
        height: 60
        font.family: NodoSystem.fontUrbanist.name
        font.pixelSize: NodoSystem.buttonTextFontSize
        isActive: false
        onClicked:
        {
            isActive = false
            nodoControl.setClearnetPeer(clearnetPeerField.valueText)
        }
    }

    Rectangle{
        id: qrCodeRect
        anchors.right: networksClearnetScreen.right
        anchors.top: networksClearnetScreen.top
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
            qrData: clearnetAddressField.valueText + ":" + clearnetPortField.valueText
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }
}
