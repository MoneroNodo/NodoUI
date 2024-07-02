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
    property bool inputFieldReadOnly: false
    property bool isRPCEnabled
    property int rpcPort
    property string rpcUser
    property string rpcPassword
    property string qrCodeAddress


    function updateParams()
    {
        networksClearnetScreen.isRPCEnabled = nodoControl.getrpcEnabledStatus()
        if(networksClearnetScreen.isRPCEnabled)
        {
            networksClearnetScreen.rpcPort = nodoControl.getrpcPort()
            networksClearnetScreen.rpcUser = nodoControl.getrpcUser()
            networksClearnetScreen.rpcPassword = nodoControl.getrpcPassword()
        }
    }

    function onCalculateMaximumTextLabelLength() {
        if(clearnetAddressField.labelRectRoundSize > labelSize)
            labelSize = clearnetAddressField.labelRectRoundSize

        if(clearnetPortField.labelRectRoundSize > labelSize)
            labelSize = clearnetPortField.labelRectRoundSize
    }

    function createAddress()
    {
        var address = "xmrrpc://:"
        if(networksClearnetScreen.isRPCEnabled) //Clearnet (private): xmrrpc://:rpcuser:rpcpassword@192.168.2.100:monero_rpc_port?label=Nodo
        {
            address = address + networksClearnetScreen.rpcUser + ":" + networksClearnetScreen.rpcPassword + "@" + clearnetAddressField.valueText + ":" + networksClearnetScreen.rpcPort.toString() + "?label=Nodo"

        }
        else //Clearnet: xmrrpc://:@192.168.2.100:monero_public_port?label=Nodo
        {
            address = address + "@" + clearnetAddressField.valueText + ":" + clearnetPortField.valueText + "?label=Nodo"
        }
        return address
    }



    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            networksClearnetScreen.clearnetPort = nodoConfig.getIntValueFromKey("config", "monero_public_port")
            updateParams()
        }
    }

    Connections {
        target: networkManager
        function onIPReady() {
            clearnetAddressField.valueText = networkManager.getNetworkIP();
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

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        networkManager.checkNetworkStatusAndIP();
        networksClearnetScreen.inputFieldReadOnly = !nodoControl.isComponentEnabled();
        updateParams()
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

    NodoButton {
        id: clearnetApplyPortButton
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetPortField.bottom
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
            qrData: createAddress()
            qrForeground: "black"
            qrBackground: "white"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }
}
