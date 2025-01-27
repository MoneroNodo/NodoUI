import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Item {
    id: nodeClearnetScreen
    property int labelSize: 0
    property int clearnetPort
    property bool clearnetSwitchStatus

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
        nodeClearnetScreen.port = nodoControl.getrpcPort()

        if((rpcu === "") || (rpcp === ""))
        {
            rpcStat = false
        }

        nodeClearnetScreen.isRPCEnabled = rpcStat
        nodeClearnetScreen.rpcUser = rpcu
        nodeClearnetScreen.rpcPassword = rpcp
    }

    function onCalculateMaximumTextLabelLength() {
        if(clearnetAddressField.labelRectRoundSize > labelSize)
            labelSize = clearnetAddressField.labelRectRoundSize

        if(clearnetPortField.labelRectRoundSize > labelSize)
            labelSize = clearnetPortField.labelRectRoundSize
    }

    function createAddress()
    {
        var uri = "xmrrpc://" + nodeClearnetScreen.rpcUser + ":" + nodeClearnetScreen.rpcPassword + "@" + clearnetAddressField.valueText + ":" + nodeClearnetScreen.port.toString() + "?label=Nodo"
        return uri
        /*
        var uri = "xmrrpc://%1:%2@%3:%4?label=Nodo"
        return uri.arg(nodeClearnetScreen.rpcUser,
            nodeClearnetScreen.rpcPassword,
            clearnetAddressField.valueText,
            nodeClearnetScreen.port.toString())
            */
    }

    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            nodeClearnetScreen.clearnetSwitchStatus = nodoConfig.getStringValueFromKey("config", "clearnet_enabled") === "TRUE" ? true : false
            nodeClearnetScreen.clearnetPort = nodoConfig.getIntValueFromKey("config", "monero_rpc_port")
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
            nodeClearnetPopup.popupMessageText = systemMessages.backendMessages[errorCode]
            // nodeClearnetPopup.popupMessageText = networkManager.getErrorMessage()
            nodeClearnetPopup.commandID = -1;
            //nodeClearnetPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            nodeClearnetPopup.open();
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            nodeClearnetPopup.popupMessageText = systemMessages.backendMessages[errorCode]
            // nodeClearnetPopup.popupMessageText = nodoControl.getErrorMessage()
            nodeClearnetPopup.commandID = -1;
            //nodeClearnetPopup.applyButtonText = systemMessages.messages[NodoMessages.Message.Close]
            nodeClearnetPopup.open();
        }

        function onComponentEnabledStatusChanged() {
            var enabled = !nodoControl.isComponentEnabled();
        }
    }

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        networkManager.checkNetworkStatusAndIP();
        updateParams()
    }

    Rectangle {
        id: clearnetSwitchRect
        anchors.left: nodeClearnetScreen.left
        anchors.top: nodeClearnetScreen.top
        height: NodoSystem.nodoItemHeight
        color: "black"
        width: clearnetSwitchText.width + clearnetSwitch.width

        NodoLabel {
            id: clearnetSwitchText
            height: clearnetSwitchRect.height
            anchors.left: clearnetSwitchRect.left
            anchors.top: clearnetSwitchRect.top
            itemSize: labelSize
            text: qsTr("Clearnet")
        }

        NodoSwitch {
            id: clearnetSwitch
            anchors.left: clearnetSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: clearnetSwitchRect.height
            width: 2*clearnetSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodeClearnetScreen.clearnetSwitchStatus
            onCheckedChanged:
            {
                var cur = nodeClearnetScreen.clearnetSwitchStatus;
                if (cur != clearnetSwitch.checked)
                {
                    nodoControl.setHiddenRPCEnabled(clearnetSwitch.checked);
                    nodeClearnetScreen.clearnetSwitchStatus = clearnetSwitch.checked;
                    nodoControl.sendUpdate();
                }
            }
        }
    }

    NodoInfoField {
        id: clearnetAddressField
        anchors.left: nodeClearnetScreen.left
        anchors.top: clearnetSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: labelSize + 300
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Address]
        valueText: ""
    }

    NodoInfoField {
        id: clearnetPortField
        anchors.left: nodeClearnetScreen.left
        anchors.top: clearnetAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: labelSize + clearnetSwitch.width
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Port]
        valueText: nodeClearnetScreen.clearnetPort
    }

    Rectangle {
        id: qrCodeRect
        anchors.right: nodeClearnetScreen.right
        anchors.bottom: nodeClearnetScreen.bottom
        //anchors.topMargin: NodoSystem.nodoTopMargin
        anchors.rightMargin: 10
        anchors.bottomMargin: 10
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
            qrBackground: "#F5F5F5"
            qrMargin: 8
            qrMode: QtQuick2QREncode.MODE_8    //encode model
            qrLevel: QtQuick2QREncode.LEVEL_Q // encode level
        }
    }

    NodoPopup {
        id: nodeClearnetPopup
        onApplyClicked: {
            close()
        }
    }
}
