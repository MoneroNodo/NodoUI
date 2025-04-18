import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.VirtualKeyboard
import NodoSystem 1.1
import NodoCanvas 1.0
import QtQuick2QREncode 1.0

Item {
    id: nodeI2PScreen
    property int labelSize: 0
    property int infoFieldWidth: width - NodoSystem.subMenuLeftMargin

    property int i2pPort
    property string i2pAddress
    property bool i2pSwitchStatus
    property bool i2pPortFieldReadOnly: false

    property bool isRPCEnabled
    property int port
    property string rpcUser
    property string rpcPassword

    function updateParams()
    {
        var rpcStat = nodoControl.getrpcEnabledStatus()
        var rpcu = nodoControl.getrpcUser()
        var rpcp = nodoControl.getrpcPassword()
        nodeI2PScreen.port = nodoControl.getrpcPort()

        if((rpcu === "") || (rpcp === ""))
        {
            rpcStat = false
        }

        nodeI2PScreen.isRPCEnabled = rpcStat
        nodeI2PScreen.rpcUser = rpcu
        nodeI2PScreen.rpcPassword = rpcp
    }

    function createAddress()
    {
        var uri = "xmrrpc://" + nodeI2PScreen.rpcUser + ":" + nodeI2PScreen.rpcPassword + "@" + i2pAddressField.valueText + ":" + nodeI2PScreen.port.toString() + "?label=Nodo I2P Node"
        return uri
    }

    Component.onCompleted: {
        nodoConfig.updateRequested()
        onCalculateMaximumTextLabelLength()
        var enabled = !nodoControl.isComponentEnabled();
        i2pPortFieldReadOnly = enabled
    }

    function onCalculateMaximumTextLabelLength() {
        if(i2pSwitchText.labelRectRoundSize > labelSize)
            labelSize = i2pSwitchText.labelRectRoundSize

        if(i2pAddressField.labelRectRoundSize > labelSize)
            labelSize = i2pAddressField.labelRectRoundSize

        if(i2pPortField.labelRectRoundSize > labelSize)
            labelSize = i2pPortField.labelRectRoundSize
    }


    Connections {
        target: nodoConfig
        function onConfigParserReady() {
            nodeI2PScreen.i2pSwitchStatus = nodoConfig.getStringValueFromKey("config", "i2p_enabled") === "TRUE" ? true : false
            nodeI2PScreen.i2pAddress = nodoConfig.getStringValueFromKey("config", "i2p_address");
            nodeI2PScreen.i2pPort = nodoConfig.getIntValueFromKey("config", "monero_rpc_port")
            updateParams()
        }
    }

    Connections {
        target: nodoControl
        function onErrorDetected() {
            var errorCode = nodoControl.getErrorCode();
            if(0 !== errorCode)
            {
                nodeI2PPopup.popupMessageText = systemMessages.backendMessages[errorCode]
                nodeI2PPopup.commandID = -1;
                nodeI2PPopup.open();
            }
        }

        function onComponentEnabledStatusChanged() {
            var enabled = !nodoControl.isComponentEnabled();
            i2pPortFieldReadOnly = enabled
        }
    }


    Rectangle {
        id: i2pSwitchRect
        anchors.left: nodeI2PScreen.left
        anchors.top: nodeI2PScreen.top
        height: NodoSystem.nodoItemHeight

        NodoLabel {
            id: i2pSwitchText
            itemSize: labelSize
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
            checked: nodeI2PScreen.i2pSwitchStatus
            onCheckedChanged:
            {
                var cur = nodeI2PScreen.i2pSwitchStatus;
                if (cur != i2pSwitch.checked)
                {
                    nodoControl.setI2PEnabled(i2pSwitch.checked);
                    nodeI2PScreen.i2pSwitchStatus = i2pSwitch.checked;
                    nodoControl.sendUpdate();
                }
            }
        }

        Text {
            id: i2pSwitchDescription
            height: NodoSystem.nodoItemHeight
            width: parent.width - i2pSwitchRect.width
            anchors.left: i2pSwitch.right
            anchors.leftMargin: 25
            anchors.top: i2pSwitch.top
            verticalAlignment: Text.AlignVCenter
            font.family: NodoSystem.fontInter.name
            font.pixelSize: NodoSystem.descriptionTextFontSize
            color: nodoControl.appTheme ? NodoSystem.descriptionTextFontColorNightModeOn : NodoSystem.descriptionTextFontColorNightModeOff
            text: qsTr("Broadcast and receive transactions through I2P.")
        }
    }

    NodoInfoField {
        id: i2pAddressField
        anchors.left: nodeI2PScreen.left
        anchors.top: i2pSwitchRect.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: infoFieldWidth
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: qsTr("I2P b32 Address")
        valueText: nodeI2PScreen.i2pAddress
        //valueFontSize: 34
    }

    NodoInfoField {
        id: i2pPortField
        anchors.left: nodeI2PScreen.left
        anchors.top: i2pAddressField.bottom
        anchors.topMargin: NodoSystem.nodoTopMargin
        width: labelSize + i2pSwitch.width
        height: NodoSystem.nodoItemHeight
        itemSize: labelSize
        itemText: systemMessages.messages[NodoMessages.Message.Port] //qsTr("Port")
        valueText: nodeI2PScreen.i2pPort

    }

    Rectangle {
        id: qrCodeRect
        anchors.right: nodeI2PScreen.right
        anchors.bottom: nodeI2PScreen.bottom
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
        id: nodeI2PPopup
        onApplyClicked: {
            close()
        }
    }
}
