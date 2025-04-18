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
    property bool hiddenRPCSwitchStatus

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
            nodeClearnetScreen.hiddenRPCSwitchStatus = nodoConfig.getStringValueFromKey("config", "anon_rpc") === "TRUE" ? true : false
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
        id: hiddenRPCSwitchRect
        anchors.left: nodeClearnetScreen.left
        anchors.top: nodeClearnetScreen.top
        height: NodoSystem.nodoItemHeight
        //color: "black"
        //width: hiddenRPCText.width + hiddenRPCSwitch.width

        NodoLabel {
            id: hiddenRPCSwitchText
            height: hiddenRPCSwitchRect.height
            anchors.left: hiddenRPCSwitchRect.left
            anchors.top: hiddenRPCSwitchRect.top
            itemSize: labelSize
            text: qsTr("Hidden RPC")
        }

        NodoSwitch {
            id: hiddenRPCSwitch
            anchors.left: hiddenRPCSwitchText.right
            anchors.leftMargin: NodoSystem.padding
            height: hiddenRPCSwitchRect.height
            width: 2*hiddenRPCSwitchRect.height
            display: AbstractButton.IconOnly
            checked: nodeClearnetScreen.hiddenRPCSwitchStatus
            onCheckedChanged:
            {
                var cur = nodeClearnetScreen.hiddenRPCSwitchStatus;
                if (cur != hiddenRPCSwitch.checked)
                {
                    nodoControl.setHiddenRPCEnabled(hiddenRPCSwitch.checked);
                    nodeClearnetScreen.hiddenRPCSwitchStatus = hiddenRPCSwitch.checked;
                    nodoControl.sendUpdate();
                }
            }
        }

        Text {
            id: hiddenRPCSwitchDescription
            height: NodoSystem.nodoItemHeight
            width: parent.width - hiddenRPCSwitchRect.width
            anchors.left: hiddenRPCSwitch.right
            anchors.leftMargin: 25
            anchors.top: hiddenRPCSwitch.top
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("Allow wallets to connect only through Tor and I2P, enable on untrusted networks.")
        }
    }

    Text {
        id: hiddenRPCSwitchDescription2
        height: hiddenRPCSwitchDescription2.paintedHeight
        width: parent.width
        anchors.top: hiddenRPCSwitchRect.bottom
        anchors.left: nodeClearnetScreen.left
        anchors.leftMargin: NodoSystem.cardLeftMargin
        anchors.topMargin: NodoSystem.cardLeftMargin
        verticalAlignment: Text.AlignVCenter
        wrapMode: Text.WordWrap
        font.family: NodoSystem.fontInter.name
        font.pixelSize: NodoSystem.descriptionTextFontSize
        color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
        text: qsTr("Enable Hidden RPC with Tor > Route All Through Tor, to fully anonymize the Monero Daemon.")
    }

    NodoInfoField {
        id: clearnetAddressField
        anchors.left: nodeClearnetScreen.left
        anchors.top: hiddenRPCSwitchDescription2.bottom
        anchors.topMargin: (NodoSystem.nodoTopMargin*3) + 5
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
        width: labelSize + hiddenRPCSwitch.width
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
