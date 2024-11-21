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
    property int port
    property string rpcUser
    property string rpcPassword
    property string qrCodeAddress


    function updateParams()
    {
        var rpcStat = nodoControl.getrpcEnabledStatus()
        var rpcu = nodoControl.getrpcUser()
        var rpcp = nodoControl.getrpcPassword()
        networksClearnetScreen.port = nodoControl.getclearnetPort()

        if((rpcu === "") || (rpcp === ""))
        {
            rpcStat = false
        }

        networksClearnetScreen.isRPCEnabled = rpcStat
        networksClearnetScreen.rpcUser = rpcu
        networksClearnetScreen.rpcPassword = rpcp
    }

    function onCalculateMaximumTextLabelLength() {
        if(clearnetAddressField.labelRectRoundSize > labelSize)
            labelSize = clearnetAddressField.labelRectRoundSize

        if(clearnetPortField.labelRectRoundSize > labelSize)
            labelSize = clearnetPortField.labelRectRoundSize
    }

    function createAddress()
    {
        var uri = "xmrrpc://" + networksClearnetScreen.rpcUser + ":" + networksClearnetScreen.rpcPassword + "@" + clearnetAddressField.valueText + ":" + networksClearnetScreen.port.toString() + "?label=Nodo"
        return uri
        /*
        var uri = "xmrrpc://%1:%2@%3:%4?label=Nodo"
        return uri.arg(networksClearnetScreen.rpcUser,
            networksClearnetScreen.rpcPassword,
            clearnetAddressField.valueText,
            networksClearnetScreen.port.toString())
            */
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
            networksClearnetPopup.popupMessageText = systemMessages.backendMessages[errorCode]
            // networksClearnetPopup.popupMessageText = networkManager.getErrorMessage()
            networksClearnetPopup.commandID = -1;
            networksClearnetPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            networksClearnetPopup.open();
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            networksClearnetPopup.popupMessageText = systemMessages.backendMessages[errorCode]
            // networksClearnetPopup.popupMessageText = nodoControl.getErrorMessage()
            networksClearnetPopup.commandID = -1;
            networksClearnetPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            networksClearnetPopup.open();
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
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Address]
        valueText: ""
    }

    NodoInputField {
        id: clearnetPortField
        anchors.left: networksClearnetScreen.left
        anchors.top: clearnetAddressField.bottom
        anchors.topMargin: 16
        width: 924
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Port]
        valueText: networksClearnetScreen.clearnetPort
        textFlag: Qt.ImhDigitsOnly
        readOnlyFlag: networksClearnetScreen.inputFieldReadOnly
        validator: IntValidator{bottom: 0; top: 65535}
        onTextEditFinished: {
            if("" === clearnetPortField.valueText)
            {
                clearnetPortField.valueText = networksClearnetScreen.clearnetPort.toString()
            }

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
        text: systemMessages.messages[NodoMessages.Message.ApplyPort]
        height: NodoSystem.nodoItemHeight
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
        anchors.rightMargin: 12
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

    NodoPopup {
        id: networksClearnetPopup
        onApplyClicked: {
            close()
        }
    }
}
